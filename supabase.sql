-- À exécuter UNE FOIS dans le SQL Editor d'un nouveau projet Supabase.
-- Les deux UUID des comptes seront ajoutés séparément : voir CONFIGURATION.md.
begin;
create table public.members (
 user_id uuid primary key references auth.users(id) on delete cascade,
 duo_id uuid not null,
 profile text not null check (profile in ('NANA','TOMTOM')),
 unique(duo_id,profile)
);
create table public.program (
 duo_id uuid not null,
 id smallint not null check(id between 0 and 5),
 name text not null check(length(trim(name)) between 1 and 80),
 note text not null default '' check(length(note)<=500),
 updated_at timestamptz not null default now(),
 primary key(duo_id,id)
);
create table public.performances (
 id uuid primary key default gen_random_uuid(),
 duo_id uuid not null,
 owner_id uuid not null references auth.users(id) on delete cascade,
 profile text not null check(profile in ('NANA','TOMTOM')),
 movement smallint not null check(movement between 0 and 5),
 mode text not null check(mode in ('Force','Volume','Endurance')),
 date date not null check(date<=current_date+1),
 kind text not null check(kind in ('total','lest','assistance')),
 kg numeric not null check(kg between 0 and 1000),
 reps smallint not null check(reps between 1 and 100),
 created_at timestamptz not null default now(),
 check((movement in (1,2) and kind in ('lest','assistance')) or (movement not in (1,2) and kind='total'))
);
create index on public.performances(duo_id,date);
alter table public.members enable row level security;
alter table public.program enable row level security;
alter table public.performances enable row level security;
revoke all on public.members,public.program,public.performances from anon,authenticated;
grant select on public.members to authenticated;
grant select on public.program to authenticated;
grant update(name,note,updated_at) on public.program to authenticated;
grant select,insert,delete on public.performances to authenticated;
-- Aucun membre ne peut se créer un accès ou changer son profil depuis le navigateur.
create policy members_self on public.members for select to authenticated using(user_id=(select auth.uid()));
create policy program_read on public.program for select to authenticated using(exists(select 1 from public.members m where m.user_id=(select auth.uid()) and m.duo_id=program.duo_id));
create policy program_edit on public.program for update to authenticated using(exists(select 1 from public.members m where m.user_id=(select auth.uid()) and m.duo_id=program.duo_id)) with check(exists(select 1 from public.members m where m.user_id=(select auth.uid()) and m.duo_id=program.duo_id));
create policy performance_read on public.performances for select to authenticated using(exists(select 1 from public.members m where m.user_id=(select auth.uid()) and m.duo_id=performances.duo_id));
create policy performance_add on public.performances for insert to authenticated with check(owner_id=(select auth.uid()) and exists(select 1 from public.members m where m.user_id=(select auth.uid()) and m.duo_id=performances.duo_id and m.profile=performances.profile));
create policy performance_delete on public.performances for delete to authenticated using(owner_id=(select auth.uid()) and exists(select 1 from public.members m where m.user_id=(select auth.uid()) and m.duo_id=performances.duo_id));
-- Version générée côté base pour détecter les modifications simultanées du programme.
create function public.duofit_program_version() returns trigger language plpgsql set search_path='' as $$ begin new.updated_at=clock_timestamp(); return new; end $$;
create trigger program_version before update on public.program for each row execute function public.duofit_program_version();
alter publication supabase_realtime add table public.program,public.performances;
commit;


-- Supabase existant : exécuter avant de publier la nouvelle application.
-- Les exercices rack sont des variantes distinctes, pas des commentaires.
begin;
alter table public.performances add column if not exists rack text;
alter table public.performances add column if not exists variant text;
alter table public.performances drop constraint if exists performance_variant_check;
alter table public.performances add constraint performance_variant_check check(
 variant is null
 or (movement=5 and variant in ('Développé militaire haltères','Développé debout','Élévations haltères','Élévations poulie'))
 or (movement=0 and variant='Développé couché au rack')
 or (movement=4 and variant='Squat au rack')
);
commit;
notify pgrst, 'reload schema';
