create schema if not exists private;
grant usage on schema private to service_role;

create table private.chat_quota_reservations (
  scope text not null check (scope in ('chat', 'openrouter')),
  reserved_at timestamptz not null
);
create index chat_quota_scope_time_idx
  on private.chat_quota_reservations (scope, reserved_at);

alter table private.chat_quota_reservations enable row level security;
revoke all on private.chat_quota_reservations from public, anon, authenticated;
grant select, insert, delete on private.chat_quota_reservations to service_role;

insert into private.chat_quota_reservations (scope, reserved_at)
select 'openrouter', created_at
from public.llm_usage
where provider = 'openrouter' and created_at >= date_trunc('day', now(), 'UTC')
order by created_at desc
limit 200;

create function public.reserve_chat_quota(p_scope text)
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
         min(reserved_at) filter (where reserved_at > minute_start)
  into daily_count, minute_count, oldest_in_minute
  from private.chat_quota_reservations
  where scope = p_scope;

  if daily_count >= 200 then
    return jsonb_build_object(
      'code', 'quota_exhausted',
      'retry_after', ceil(extract(epoch from day_start + interval '24 hours' - observed_at))
    );
  end if;

  if p_scope = 'chat' and minute_count >= 10 then
    return jsonb_build_object(
      'code', 'rate_limited',
      'retry_after', ceil(extract(epoch from oldest_in_minute + interval '60 seconds' - observed_at))
    );
  end if;

  insert into private.chat_quota_reservations (scope, reserved_at) values (p_scope, observed_at);
  return null;
end;
$$;

revoke execute on function public.reserve_chat_quota(text) from public, anon, authenticated;
grant execute on function public.reserve_chat_quota(text) to service_role;
