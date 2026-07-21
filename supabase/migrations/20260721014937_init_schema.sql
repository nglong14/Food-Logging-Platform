-- init schema: core edible tables, indexes, and RLS
-- identity: auth.users (Supabase Auth); no custom users table

-- ---------------------------------------------------------------------------
-- Reference tables
-- ---------------------------------------------------------------------------

create table public.conditions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  created_at timestamptz not null default now()
);

create table public.allergens (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  created_at timestamptz not null default now()
);

create table public.recommendation_rules (
  id uuid primary key default gen_random_uuid(),
  condition_id uuid not null references public.conditions (id) on delete cascade,
  rule_type text not null,
  parameters jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index recommendation_rules_condition_id_idx
  on public.recommendation_rules (condition_id);

-- ---------------------------------------------------------------------------
-- User-owned health profile + junctions
-- ---------------------------------------------------------------------------

create table public.health_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users (id) on delete cascade,
  age integer,
  weight_kg numeric(6, 2),
  goals jsonb not null default '[]'::jsonb,
  biometrics jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint health_profiles_age_check check (age is null or age >= 0),
  constraint health_profiles_weight_check check (weight_kg is null or weight_kg > 0)
);

create table public.user_conditions (
  profile_id uuid not null references public.health_profiles (id) on delete cascade,
  condition_id uuid not null references public.conditions (id) on delete cascade,
  primary key (profile_id, condition_id)
);

create index user_conditions_profile_id_idx
  on public.user_conditions (profile_id);

create table public.user_allergies (
  profile_id uuid not null references public.health_profiles (id) on delete cascade,
  allergen_id uuid not null references public.allergens (id) on delete cascade,
  primary key (profile_id, allergen_id)
);

create index user_allergies_profile_id_idx
  on public.user_allergies (profile_id);

-- ---------------------------------------------------------------------------
-- Food logs + nutrition + recommendations
-- ---------------------------------------------------------------------------

create table public.food_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  source_type text not null,
  created_at timestamptz not null default now(),
  deleted_at timestamptz,
  constraint food_logs_source_type_check
    check (source_type in ('photo', 'upload', 'manual', 'text'))
);

create index food_logs_user_id_created_at_idx
  on public.food_logs (user_id, created_at desc);

create table public.food_items (
  id uuid primary key default gen_random_uuid(),
  food_log_id uuid not null references public.food_logs (id) on delete cascade,
  name text not null,
  confidence numeric(4, 3),
  portion_g numeric(10, 2),
  created_at timestamptz not null default now()
);

create index food_items_food_log_id_idx
  on public.food_items (food_log_id);

create table public.nutrition_estimates (
  id uuid primary key default gen_random_uuid(),
  food_item_id uuid not null unique references public.food_items (id) on delete cascade,
  calories numeric(10, 2),
  carbohydrates_g numeric(10, 2),
  sugar_g numeric(10, 2),
  sodium_mg numeric(10, 2),
  protein_g numeric(10, 2),
  fat_g numeric(10, 2),
  created_at timestamptz not null default now()
);

create table public.recommendations (
  id uuid primary key default gen_random_uuid(),
  food_log_id uuid not null references public.food_logs (id) on delete cascade,
  verdict text not null,
  warnings jsonb not null default '[]'::jsonb,
  suggestions jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

create index recommendations_food_log_id_idx
  on public.recommendations (food_log_id);

-- ---------------------------------------------------------------------------
-- updated_at trigger for health_profiles
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger health_profiles_set_updated_at
  before update on public.health_profiles
  for each row
  execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

alter table public.conditions enable row level security;
alter table public.allergens enable row level security;
alter table public.recommendation_rules enable row level security;
alter table public.health_profiles enable row level security;
alter table public.user_conditions enable row level security;
alter table public.user_allergies enable row level security;
alter table public.food_logs enable row level security;
alter table public.food_items enable row level security;
alter table public.nutrition_estimates enable row level security;
alter table public.recommendations enable row level security;

-- Reference tables: world-readable
create policy "conditions_select_all"
  on public.conditions for select
  to anon, authenticated
  using (true);

create policy "allergens_select_all"
  on public.allergens for select
  to anon, authenticated
  using (true);

create policy "recommendation_rules_select_all"
  on public.recommendation_rules for select
  to anon, authenticated
  using (true);

-- health_profiles: owner only
create policy "health_profiles_select_own"
  on public.health_profiles for select
  to authenticated
  using (auth.uid() = user_id);

create policy "health_profiles_insert_own"
  on public.health_profiles for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "health_profiles_update_own"
  on public.health_profiles for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "health_profiles_delete_own"
  on public.health_profiles for delete
  to authenticated
  using (auth.uid() = user_id);

-- user_conditions: via owning profile
create policy "user_conditions_select_own"
  on public.user_conditions for select
  to authenticated
  using (
    exists (
      select 1 from public.health_profiles hp
      where hp.id = profile_id and hp.user_id = auth.uid()
    )
  );

create policy "user_conditions_insert_own"
  on public.user_conditions for insert
  to authenticated
  with check (
    exists (
      select 1 from public.health_profiles hp
      where hp.id = profile_id and hp.user_id = auth.uid()
    )
  );

create policy "user_conditions_delete_own"
  on public.user_conditions for delete
  to authenticated
  using (
    exists (
      select 1 from public.health_profiles hp
      where hp.id = profile_id and hp.user_id = auth.uid()
    )
  );

-- user_allergies: via owning profile
create policy "user_allergies_select_own"
  on public.user_allergies for select
  to authenticated
  using (
    exists (
      select 1 from public.health_profiles hp
      where hp.id = profile_id and hp.user_id = auth.uid()
    )
  );

create policy "user_allergies_insert_own"
  on public.user_allergies for insert
  to authenticated
  with check (
    exists (
      select 1 from public.health_profiles hp
      where hp.id = profile_id and hp.user_id = auth.uid()
    )
  );

create policy "user_allergies_delete_own"
  on public.user_allergies for delete
  to authenticated
  using (
    exists (
      select 1 from public.health_profiles hp
      where hp.id = profile_id and hp.user_id = auth.uid()
    )
  );

-- food_logs: owner only
create policy "food_logs_select_own"
  on public.food_logs for select
  to authenticated
  using (auth.uid() = user_id);

create policy "food_logs_insert_own"
  on public.food_logs for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "food_logs_update_own"
  on public.food_logs for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "food_logs_delete_own"
  on public.food_logs for delete
  to authenticated
  using (auth.uid() = user_id);

-- food_items: via owning food log
create policy "food_items_select_own"
  on public.food_items for select
  to authenticated
  using (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  );

create policy "food_items_insert_own"
  on public.food_items for insert
  to authenticated
  with check (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  );

create policy "food_items_update_own"
  on public.food_items for update
  to authenticated
  using (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  );

create policy "food_items_delete_own"
  on public.food_items for delete
  to authenticated
  using (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  );

-- nutrition_estimates: via owning food item → food log
create policy "nutrition_estimates_select_own"
  on public.nutrition_estimates for select
  to authenticated
  using (
    exists (
      select 1
      from public.food_items fi
      join public.food_logs fl on fl.id = fi.food_log_id
      where fi.id = food_item_id and fl.user_id = auth.uid()
    )
  );

create policy "nutrition_estimates_insert_own"
  on public.nutrition_estimates for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.food_items fi
      join public.food_logs fl on fl.id = fi.food_log_id
      where fi.id = food_item_id and fl.user_id = auth.uid()
    )
  );

create policy "nutrition_estimates_update_own"
  on public.nutrition_estimates for update
  to authenticated
  using (
    exists (
      select 1
      from public.food_items fi
      join public.food_logs fl on fl.id = fi.food_log_id
      where fi.id = food_item_id and fl.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from public.food_items fi
      join public.food_logs fl on fl.id = fi.food_log_id
      where fi.id = food_item_id and fl.user_id = auth.uid()
    )
  );

create policy "nutrition_estimates_delete_own"
  on public.nutrition_estimates for delete
  to authenticated
  using (
    exists (
      select 1
      from public.food_items fi
      join public.food_logs fl on fl.id = fi.food_log_id
      where fi.id = food_item_id and fl.user_id = auth.uid()
    )
  );

-- recommendations: via owning food log
create policy "recommendations_select_own"
  on public.recommendations for select
  to authenticated
  using (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  );

create policy "recommendations_insert_own"
  on public.recommendations for insert
  to authenticated
  with check (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  );

create policy "recommendations_update_own"
  on public.recommendations for update
  to authenticated
  using (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  );

create policy "recommendations_delete_own"
  on public.recommendations for delete
  to authenticated
  using (
    exists (
      select 1 from public.food_logs fl
      where fl.id = food_log_id and fl.user_id = auth.uid()
    )
  );
