-- Run this in Supabase Dashboard > SQL Editor

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  reporter_name text not null,
  category text not null,
  title text not null,
  location text not null,
  description text not null,
  status text not null default 'Pending',
  created_at timestamptz not null default now()
);

create table public.appointments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  patient_name text not null,
  service text not null,
  appt_date date not null,
  appt_time text not null,
  status text not null default 'Pending',
  created_at timestamptz not null default now()
);

create table public.document_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  full_name text not null,
  doc_type text not null,
  purpose text not null,
  status text not null default 'Pending',
  created_at timestamptz not null default now()
);

create table public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  venue text not null,
  event_at timestamptz not null
);

-- Row Level Security
alter table public.reports enable row level security;
alter table public.appointments enable row level security;
alter table public.document_requests enable row level security;
alter table public.events enable row level security;

-- Residents can only see and create their OWN rows
create policy "own reports select" on public.reports for select to authenticated using (user_id = auth.uid());
create policy "own reports insert" on public.reports for insert to authenticated with check (user_id = auth.uid());

create policy "own appts select" on public.appointments for select to authenticated using (user_id = auth.uid());
create policy "own appts insert" on public.appointments for insert to authenticated with check (user_id = auth.uid());

create policy "own docs select" on public.document_requests for select to authenticated using (user_id = auth.uid());
create policy "own docs insert" on public.document_requests for insert to authenticated with check (user_id = auth.uid());

-- Everyone logged in can read events (admin adds them via Table Editor)
create policy "events read" on public.events for select to authenticated using (true);

-- Sample events
insert into public.events (title, venue, event_at) values
  ('Barangay Assembly', 'Barangay Hall', '2026-11-05 15:00+08'),
  ('Free Medical Mission', 'Health Center', '2026-11-12 08:00+08'),
  ('Clean-up Drive', 'Covered Court', '2026-11-15 06:00+08'),
  ('Feeding Program', 'Day Care Center', '2026-11-20 10:00+08');
