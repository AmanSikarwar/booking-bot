begin;

delete from private.chat_quota_reservations;

set local role service_role;

do $$
declare
  denial jsonb;
begin
  for i in 1..10 loop
    if public.reserve_chat_quota('chat') is not null then
      raise exception 'Chat request % was denied before the minute limit', i;
    end if;
  end loop;

  denial := public.reserve_chat_quota('chat');
  if denial->>'code' is distinct from 'rate_limited'
     or (denial->>'retry_after')::integer not between 1 and 60 then
    raise exception 'Expected the minute limit and retry time, got %', denial;
  end if;

  for i in 1..200 loop
    if public.reserve_chat_quota('openrouter') is not null then
      raise exception 'Model attempt % was denied before the daily limit', i;
    end if;
  end loop;

  denial := public.reserve_chat_quota('openrouter');
  if denial->>'code' is distinct from 'quota_exhausted'
     or (denial->>'retry_after')::integer not between 1 and 86400 then
    raise exception 'Expected the daily model limit and retry time, got %', denial;
  end if;
end;
$$;

reset role;

update private.chat_quota_reservations
set reserved_at = clock_timestamp() - interval '61 seconds'
where scope = 'chat';

do $$
begin
  if public.reserve_chat_quota('chat') is not null then
    raise exception 'A chat request should pass once the rolling minute expires';
  end if;
end;
$$;

insert into private.chat_quota_reservations (scope, reserved_at)
select 'chat', date_trunc('day', now(), 'UTC') from generate_series(1, 200);

do $$
begin
  if public.reserve_chat_quota('chat')->>'code' is distinct from 'quota_exhausted' then
    raise exception 'Expected the daily API limit';
  end if;
  if has_function_privilege('anon', 'public.reserve_chat_quota(text)', 'execute')
     or has_function_privilege('authenticated', 'public.reserve_chat_quota(text)', 'execute') then
    raise exception 'Only the backend service role should be able to reserve quota';
  end if;
end;
$$;

rollback;
