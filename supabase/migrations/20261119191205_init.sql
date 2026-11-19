create table public.conversations (
  id uuid primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  locale text not null check (locale in ('en', 'hi')),
  flagged boolean not null default false,
  created_at timestamptz not null default now()
);
create index conversations_user_id_idx on public.conversations (user_id);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  client_message_id uuid,
  reply_to uuid references public.messages (id) on delete cascade,
  role text not null check (role in ('user', 'assistant')),
  kind text not null default 'text' check (kind in ('text', 'action')),
  content jsonb not null default '{}'::jsonb,
  status text not null check (status in ('processing', 'completed', 'failed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (conversation_id, client_message_id)
);
create index messages_conversation_created_idx on public.messages (conversation_id, created_at);
create index messages_user_created_idx on public.messages (user_id, created_at);
create index messages_reply_to_idx on public.messages (reply_to);

create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  booking_ref text not null unique,
  user_id uuid not null references auth.users (id) on delete cascade,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  package_id text not null,
  slot_date date not null,
  time_window text not null check (time_window in ('07-09', '09-11', '11-13', '16-18')),
  address_label text not null,
  patient_name text not null,
  status text not null default 'confirmed',
  idempotency_key text not null unique,
  created_at timestamptz not null default now()
);
create index bookings_user_id_idx on public.bookings (user_id);
create index bookings_conversation_id_idx on public.bookings (conversation_id);
create index bookings_slot_idx on public.bookings (slot_date, time_window);

create table public.safety_checks (
  id bigint generated always as identity primary key,
  message_id uuid references public.messages (id) on delete cascade,
  keyword_match text[] not null default '{}',
  decider_model text,
  decider_probs jsonb,
  outcome text not null check (outcome in ('urgent', 'crisis', 'pass', 'decider_unavailable', 'skipped')),
  latency_ms integer,
  created_at timestamptz not null default now()
);
create index safety_checks_message_id_idx on public.safety_checks (message_id);

create table public.llm_usage (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users (id) on delete set null,
  conversation_id uuid references public.conversations (id) on delete set null,
  kind text not null check (kind in ('chat', 'decision')),
  provider text not null default 'openrouter',
  model text,
  status text not null check (status in ('ok', 'rate_limited', 'upstream_error', 'invalid_tool_call')),
  input_tokens integer not null default 0,
  output_tokens integer not null default 0,
  cost_usd numeric(12, 6) not null default 0,
  latency_ms integer,
  created_at timestamptz not null default now()
);
create index llm_usage_created_at_idx on public.llm_usage (created_at);
create index llm_usage_user_id_idx on public.llm_usage (user_id);
create index llm_usage_conversation_id_idx on public.llm_usage (conversation_id);

alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.bookings enable row level security;
alter table public.safety_checks enable row level security;
alter table public.llm_usage enable row level security;

revoke all on public.conversations, public.messages, public.bookings, public.safety_checks, public.llm_usage
  from anon, authenticated;
grant select on public.conversations, public.messages, public.bookings to authenticated;
grant all on public.conversations, public.messages, public.bookings, public.safety_checks, public.llm_usage
  to service_role;

create policy "own conversations" on public.conversations for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "own messages" on public.messages for select
  to authenticated using ((select auth.uid()) = user_id);
create policy "own bookings" on public.bookings for select
  to authenticated using ((select auth.uid()) = user_id);
