-- ESTO ES DRUNKTASY · esquema Supabase
-- Ejecutar en el SQL Editor del proyecto. Tablas con prefijo ddv_ para no pisar nada.
-- Todo cuelga de un grupo (cuadrilla): cada uno con su ranking, su muro y sus juicios.

create table if not exists ddv_groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  code text not null unique,        -- va en el enlace de invitación: index.html#g=CODIGO
  created_at timestamptz not null default now()
);

create table if not exists ddv_players (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references ddv_groups(id) on delete cascade,
  name text not null,
  nickname text not null,
  created_at timestamptz not null default now()
);
create index if not exists ddv_players_group on ddv_players(group_id);

create table if not exists ddv_categories (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references ddv_groups(id) on delete cascade,
  label text not null,
  points int not null check (points between 1 and 10),
  emoji text,
  created_at timestamptz not null default now()
);
create index if not exists ddv_categories_group on ddv_categories(group_id);

create table if not exists ddv_events (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references ddv_groups(id) on delete cascade,
  player_id uuid not null references ddv_players(id) on delete cascade,
  kind text not null check (kind in ('drink','anecdote')),
  type text not null,
  label text not null,
  points int not null,
  note text,
  photo text,                       -- JPEG comprimido en data URL (~60-120 KB)
  has_photo boolean not null default false,
  reported_by uuid references ddv_players(id) on delete set null,
  status text not null default 'approved' check (status in ('approved','pending','rejected')),
  month text not null,              -- 'YYYY-MM': la temporada
  created_at timestamptz not null default now()
);
create index if not exists ddv_events_month on ddv_events(month);
create index if not exists ddv_events_group on ddv_events(group_id, month);

create table if not exists ddv_votes (
  group_id uuid not null references ddv_groups(id) on delete cascade,
  event_id uuid not null references ddv_events(id) on delete cascade,
  voter_id uuid not null references ddv_players(id) on delete cascade,
  approve boolean not null,
  created_at timestamptz not null default now(),
  primary key (event_id, voter_id)
);
create index if not exists ddv_votes_group on ddv_votes(group_id);

-- Sin cuentas: cualquiera con el enlace (anon key) lee y escribe. Es para colegas.
alter table ddv_groups     enable row level security;
alter table ddv_players    enable row level security;
alter table ddv_categories enable row level security;
alter table ddv_events     enable row level security;
alter table ddv_votes      enable row level security;
do $$ declare t text; begin
  foreach t in array array['ddv_groups','ddv_players','ddv_categories','ddv_events','ddv_votes'] loop
    execute format('drop policy if exists "cuadrilla" on %I', t);
    execute format('create policy "cuadrilla" on %I for all to anon using (true) with check (true)', t);
  end loop;
end $$;
