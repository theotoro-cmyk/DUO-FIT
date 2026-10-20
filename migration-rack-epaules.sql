-- Projet Supabase existant : exécuter UNE FOIS AVANT de publier cette version.
-- Ajout non destructif : aucun résultat existant n'est effacé.
begin;
alter table public.performances add column if not exists rack text;
alter table public.performances add column if not exists variant text;
do $$ begin
if not exists(select 1 from pg_constraint where conrelid='public.performances'::regclass and conname='performance_rack_check') then
 alter table public.performances add constraint performance_rack_check check(rack is null or (movement in (0,4) and length(rack)<=80));
end if;
if not exists(select 1 from pg_constraint where conrelid='public.performances'::regclass and conname='performance_variant_check') then
 alter table public.performances add constraint performance_variant_check check(variant is null or (movement=5 and variant in ('Développé militaire haltères','Développé debout','Élévations haltères','Élévations poulie')));
end if;
end $$;
commit;
notify pgrst, 'reload schema';
