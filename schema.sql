-- EL DIARIO DE LA VERGÜENZA · esquema Supabase
-- Ejecutar en el SQL Editor del proyecto. Tablas con prefijo ddv_ para no pisar nada.

create table if not exists ddv_players (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  nickname text not null,
  created_at timestamptz not null default now()
);

create table if not exists ddv_categories (
  id uuid primary key default gen_random_uuid(),
  label text not null,
  points int not null check (points between 1 and 10),
  emoji text,
  created_at timestamptz not null default now()
);

create table if not exists ddv_events (
  id uuid primary key default gen_random_uuid(),
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

create table if not exists ddv_votes (
  event_id uuid not null references ddv_events(id) on delete cascade,
  voter_id uuid not null references ddv_players(id) on delete cascade,
  approve boolean not null,
  created_at timestamptz not null default now(),
  primary key (event_id, voter_id)
);

-- Sin cuentas: cualquiera con el enlace (anon key) lee y escribe. Es para colegas.
alter table ddv_players    enable row level security;
alter table ddv_categories enable row level security;
alter table ddv_events     enable row level security;
alter table ddv_votes      enable row level security;
do $$ declare t text; begin
  foreach t in array array['ddv_players','ddv_categories','ddv_events','ddv_votes'] loop
    execute format('drop policy if exists "cuadrilla" on %I', t);
    execute format('create policy "cuadrilla" on %I for all to anon using (true) with check (true)', t);
  end loop;
end $$;
