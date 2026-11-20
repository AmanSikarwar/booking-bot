alter table private.chat_quota_reservations add column user_id uuid;
create index chat_quota_user_time_idx
  on private.chat_quota_reservations (scope, user_id, reserved_at)
  where user_id is not null;

drop function public.reserve_chat_quota(text);

create function public.reserve_chat_quota(p_scope text, p_user uuid default null)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  observed_at timestamptz;
  day_start timestamptz;
  minute_start timestamptz;
  daily_count integer;
  minute_count integer;
  oldest_in_minute timestamptz;
  user_daily integer;
  user_minute integer;
  user_oldest timestamptz;
begin
  if p_scope is null or p_scope not in ('chat', 'openrouter') then
    raise exception 'Invalid quota scope';
  end if;

  perform pg_advisory_xact_lock(24019, case p_scope when 'chat' then 1 else 2 end);
  observed_at := clock_timestamp();
  day_start := date_trunc('day', observed_at, 'UTC');
  minute_start := observed_at - interval '60 seconds';

  delete from private.chat_quota_reservations
  where scope = p_scope and reserved_at < least(day_start, minute_start);

  select count(*) filter (where reserved_at >= day_start),
         count(*) filter (where reserved_at > minute_start),
         min(reserved_at) filter (where reserved_at > minute_start),
         count(*) filter (where user_id = p_user and reserved_at >= day_start),
         count(*) filter (where user_id = p_user and reserved_at > minute_start),
         min(reserved_at) filter (where user_id = p_user and reserved_at > minute_start)
  into daily_count, minute_count, oldest_in_minute, user_daily, user_minute, user_oldest
  from private.chat_quota_reservations
  where scope = p_scope;

  if p_user is not null and user_daily >= 40 then
    return jsonb_build_object(
      'code', 'user_daily_limit',
      'retry_after', ceil(extract(epoch from day_start + interval '24 hours' - observed_at))
    );
  end if;

  if p_user is not null and user_minute >= 4 then
    return jsonb_build_object(
      'code', 'rate_limited',
      'retry_after', greatest(1, ceil(extract(epoch from user_oldest + interval '60 seconds' - observed_at)))
    );
  end if;

  if daily_count >= 200 then
    return jsonb_build_object(
      'code', 'quota_exhausted',
      'retry_after', ceil(extract(epoch from day_start + interval '24 hours' - observed_at))
    );
  end if;

  if p_scope = 'chat' and minute_count >= 10 then
    return jsonb_build_object(
      'code', 'rate_limited',
      'retry_after', greatest(1, ceil(extract(epoch from oldest_in_minute + interval '60 seconds' - observed_at)))
    );
  end if;

  insert into private.chat_quota_reservations (scope, reserved_at, user_id) values (p_scope, observed_at, p_user);
  return null;
end;
$$;

revoke execute on function public.reserve_chat_quota(text, uuid) from public, anon, authenticated;
grant execute on function public.reserve_chat_quota(text, uuid) to service_role;
