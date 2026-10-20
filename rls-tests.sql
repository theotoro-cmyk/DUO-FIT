-- Projet de TEST uniquement, après installation et association des deux membres.
-- Exécuter dans SQL Editor. Succès = aucun message d'erreur. Tout est annulé.
begin;
do $$ declare n public.members; t public.members; begin
 select * into n from public.members where profile='NANA' limit 1;
 select * into t from public.members where profile='TOMTOM' and duo_id=n.duo_id;
 if n.user_id is null or t.user_id is null then raise exception 'Créer les deux membres du même duo avant le test'; end if;
 perform set_config('test.nana',n.user_id::text,true);
 perform set_config('test.tomtom',t.user_id::text,true);
 perform set_config('test.duo',n.duo_id::text,true);
 perform set_config('test.result',gen_random_uuid()::text,true);
end $$;
set local role anon;
do $$ begin
 begin perform * from public.program; raise exception 'ECHEC: anon peut lire'; exception when insufficient_privilege then null; end;
 begin insert into public.performances(duo_id,owner_id,profile,movement,mode,date,kind,kg,reps) values(current_setting('test.duo')::uuid,current_setting('test.nana')::uuid,'NANA',0,'Force',current_date,'total',20,5); raise exception 'ECHEC: anon peut écrire'; exception when insufficient_privilege then null; end;
end $$;
reset role;
select set_config('request.jwt.claim.sub',current_setting('test.nana'),true);
set local role authenticated;
do $$ declare c int; begin
 select count(*) into c from public.program where duo_id=current_setting('test.duo')::uuid;
 if c<>6 then raise exception 'ECHEC: programme NANA illisible'; end if;
 insert into public.performances(id,duo_id,owner_id,profile,movement,mode,date,kind,kg,reps) values(current_setting('test.result')::uuid,current_setting('test.duo')::uuid,auth.uid(),'NANA',0,'Force',current_date,'total',20,5);
 update public.program set note='Test transactionnel' where duo_id=current_setting('test.duo')::uuid and id=0;
 get diagnostics c=row_count; if c<>1 then raise exception 'ECHEC: NANA ne peut modifier le programme'; end if;
 begin insert into public.performances(duo_id,owner_id,profile,movement,mode,date,kind,kg,reps) values(current_setting('test.duo')::uuid,auth.uid(),'TOMTOM',0,'Force',current_date,'total',20,5); raise exception 'ECHEC: usurpation profil autorisée'; exception when insufficient_privilege then null; end;
 begin update public.members set profile='TOMTOM' where user_id=auth.uid(); raise exception 'ECHEC: membre modifiable'; exception when insufficient_privilege then null; end;
 begin update public.performances set kg=100 where id=current_setting('test.result')::uuid; raise exception 'ECHEC: résultat modifiable'; exception when insufficient_privilege then null; end;
end $$;
reset role;
select set_config('request.jwt.claim.sub',current_setting('test.tomtom'),true);
set local role authenticated;
do $$ declare c int; begin
 select count(*) into c from public.performances where id=current_setting('test.result')::uuid;
 if c<>1 then raise exception 'ECHEC: partenaire ne voit pas le résultat'; end if;
 delete from public.performances where id=current_setting('test.result')::uuid;
 get diagnostics c=row_count; if c<>0 then raise exception 'ECHEC: partenaire peut supprimer le résultat'; end if;
 update public.program set note='Test TOMTOM' where duo_id=current_setting('test.duo')::uuid and id=0;
 get diagnostics c=row_count; if c<>1 then raise exception 'ECHEC: TOMTOM ne peut modifier le programme'; end if;
end $$;
reset role;
select set_config('request.jwt.claim.sub',gen_random_uuid()::text,true);
set local role authenticated;
do $$ declare c int; begin
 select count(*) into c from public.program;
 if c<>0 then raise exception 'ECHEC: tiers peut lire programme'; end if;
 select count(*) into c from public.performances;
 if c<>0 then raise exception 'ECHEC: tiers peut lire résultats'; end if;
 update public.program set note='Intrusion' where duo_id=current_setting('test.duo')::uuid;
 get diagnostics c=row_count; if c<>0 then raise exception 'ECHEC: tiers peut modifier programme'; end if;
 begin insert into public.performances(duo_id,owner_id,profile,movement,mode,date,kind,kg,reps) values(current_setting('test.duo')::uuid,current_setting('test.nana')::uuid,'NANA',0,'Force',current_date,'total',20,5); raise exception 'ECHEC: tiers peut insérer'; exception when insufficient_privilege then null; end;
end $$;
reset role;
select set_config('request.jwt.claim.sub',current_setting('test.nana'),true);
set local role authenticated;
do $$ declare c int; begin
 delete from public.performances where id=current_setting('test.result')::uuid;
 get diagnostics c=row_count; if c<>1 then raise exception 'ECHEC: suppression propre refusée'; end if;
end $$;
reset role;
rollback;
