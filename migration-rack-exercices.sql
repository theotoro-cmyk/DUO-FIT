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
