# DUO FIT V3 — installation et mise à jour

## Ce qui est livré

Application web statique en français, responsive iPhone, sans compilation. NANA rose, TOMTOM vert, six mouvements partagés, Force/Volume/Endurance, journal, suppression d'un résultat, rapports par semaine avec courbes de charge et de 1RM estimé. Les noms et consignes du programme sont modifiables par les deux comptes. Aucun nombre de séries imposé en Force ; les autres modules enregistrent les séries réellement faites avec cibles 8–12 et 15–20.

La V2 n'a pas pu être récupérée depuis le dépôt pendant la création et aucun fichier source n'était disponible. Cette V3 est une reconstruction des exigences, pas une modification vérifiée du code V2. Aucune migration automatique d'un format V2 inconnu : sauvegardez les fichiers et données V2 avant remplacement. Les images de l'ancien échange n'étaient pas disponibles.

## 1. Essai local

Ouvrir via un serveur web (par exemple `python3 -m http.server 8000` dans ce dossier), puis http://localhost:8000. Pas d'installation de dépendances. Sans configuration, les données sont stockées dans ce navigateur uniquement. Elles ne passent pas d'un téléphone à l'autre. Dans Connexion → Exporter, conserver un JSON puis le restaurer dans le mode local sur l'autre appareil. L'import remplace les données locales après confirmation. Les exports ne sont pas chiffrés : les garder privés. Les données des fenêtres privées ou d'un navigateur effacé peuvent disparaître.

## 2. Créer le service partagé

1. Créer un projet sur https://supabase.com, en choisissant une région proche et un mot de passe de base fort conservé dans votre gestionnaire. L'offre gratuite peut suffire pour deux personnes ; vérifier quotas et conditions actuels sur https://supabase.com/pricing. Ne pas compter sur une disponibilité sans interruption : un projet gratuit peut être suspendu selon ses conditions.
2. Dans SQL Editor, exécuter **supabase.sql** une fois sur un projet neuf. Il crée les tables, RLS, permissions minimales, versionnement du programme et publication Realtime. Si une table existe déjà, ne pas la supprimer : utiliser un projet neuf ou préparer une migration adaptée. Le fichier est transactionnel et n'est pas prévu pour être réexécuté.
3. Authentication → Providers → Email : activer e-mail/mot de passe. Désactiver les inscriptions publiques (« Allow new users to sign up »). Configurer une longueur minimale de 12 caractères, activer confirmation d'e-mail si inscription autorisée ultérieurement. Pour l'usage courant, deux comptes séparés, jamais un mot de passe partagé.
4. Authentication → Users → Add user → Create user : créer les deux utilisateurs avec leurs vraies adresses, mots de passe forts et distincts, et confirmation d'adresse via le processus administrateur. Communiquer les accès en privé, jamais dans GitHub. Copier leurs UUID affichés dans Users. Les changements de mot de passe se font par lien de récupération ; configurer votre SMTP pour un envoi fiable et vérifier ses limites. Ne pas mettre de mot de passe dans le SQL ou dans les fichiers publiés.
5. SQL Editor : exécuter le bloc suivant **après remplacement des deux UUID**. Le même duo_id doit être utilisé pour les deux personnes et le programme. L'UUID du duo ci-dessous est un identifiant public, pas un secret ; vous pouvez en générer un autre et le remplacer partout dans ce bloc.

```sql
begin;
insert into public.members(user_id,duo_id,profile) values
('UUID_AUTH_NANA','8102b70a-d96f-4b37-a6a3-31f175cf7470','NANA'),
('UUID_AUTH_TOMTOM','8102b70a-d96f-4b37-a6a3-31f175cf7470','TOMTOM');
insert into public.program(duo_id,id,name) values
('8102b70a-d96f-4b37-a6a3-31f175cf7470',0,'Développé couché'),
('8102b70a-d96f-4b37-a6a3-31f175cf7470',1,'Tractions'),
('8102b70a-d96f-4b37-a6a3-31f175cf7470',2,'Dips'),
('8102b70a-d96f-4b37-a6a3-31f175cf7470',3,'Soulevé de terre'),
('8102b70a-d96f-4b37-a6a3-31f175cf7470',4,'Squat'),
('8102b70a-d96f-4b37-a6a3-31f175cf7470',5,'Épaules');
commit;
```

6. Settings → API / API Keys (les intitulés du tableau de bord peuvent évoluer) : copier l'URL `https://…supabase.co` et la **publishable key** `sb_publishable_…` ou la clé historique **anon**. Dans `config.js`, remplir :

```js
window.DUOFIT_CONFIG = {
  supabaseUrl: 'https://VOTRE-PROJET.supabase.co',
  supabaseKey: 'VOTRE_CLE_PUBLIQUE_PUBLISHABLE_OU_ANON'
};
```

Ces deux valeurs sont publiques et peuvent être dans le dépôt ; les règles RLS protègent les données. **Jamais de `service_role`, `sb_secret_…`, mot de passe, jeton personnel ou clé privée** dans le navigateur ou GitHub. N'envoyez aucun secret pour réaliser cette configuration.

7. Authentication → URL Configuration : définir Site URL à `https://theotoro-cmyk.github.io/DUO-FIT/` et ajouter exactement cette adresse dans Redirect URLs. Adapter si domaine ou chemin différents. Pour un essai local, ajouter `http://localhost:8000/`. Le lien de récupération ramène vers l'app, qui propose le nouveau mot de passe. Tester ce parcours avec votre SMTP avant usage.
8. Database → Replication / Realtime : vérifier que `program` et `performances` sont présents dans la publication `supabase_realtime`. Le SQL le fait déjà. Aucun accès anonyme aux tables. Les utilisateurs n'ont pas de droit d'écriture sur `members`, ni de droit de changer les identifiants du programme.
9. Sur chaque téléphone ouvrir la même URL, puis Connexion : chacun entre **son propre compte**. NANA/TOMTOM en haut sélectionne le profil consulté ; ce bouton ne change jamais les autorisations. Chacun voit les performances du duo, saisit et supprime uniquement les siennes. Tous deux éditent le programme. Un compte non associé voit un message explicite, aucune donnée du duo.

## 3. Ce que la synchronisation fait

Supabase conserve les données côté service et émet les modifications aux appareils connectés via Realtime. Une actualisation toutes les 20 secondes et au retour dans l'app complète la reconnexion. Sur une page en cours de saisie, les brouillons restent en place ; les nouvelles valeurs sont visibles après sortie du champ ou navigation. En cas de modifications simultanées du même mouvement, la seconde sauvegarde est refusée et la version du partenaire est présentée. Les séances sont des résultats distincts ; des enregistrements multiples volontaires sont conservés.

Les écritures en mode partagé nécessitent Internet. Un échec affiche une erreur ; la saisie reste disponible pour réessayer. Il n'y a **pas de file d'attente hors ligne**, ni de synchronisation implicite du mode local vers le cloud. Les données locales d'essai restent séparées des comptes Supabase. Pour reprendre de vraies données locales en partagé, saisir les résultats utiles une fois connecté ; pour une V2, établir d'abord son format d'export réel.

Sur un nouveau téléphone : ouvrir l'URL et se connecter au même compte. Les données reviennent depuis Supabase. GitHub Pages héberge seulement HTML/CSS/JS ; **GitHub Pages seul ne synchronise ni ne sauvegarde les séances**. La session reste sur l'appareil : verrouiller le téléphone et se déconnecter sur un appareil partagé. Ne pas ajouter de scripts non fiables qui pourraient lire la session.

## 4. Vérifier les accès avant usage

Sur un projet de test, exécuter `rls-tests.sql` après création des deux membres et du programme. La transaction se termine par ROLLBACK et ne conserve aucun résultat de test. Les tests simulent anon, NANA, TOMTOM et un utilisateur extérieur : lecture privée, insertion propre autorisée, usurpation et écriture du programme hors duo refusées. Ne pas désactiver RLS pour résoudre une erreur.

Puis avec deux navigateurs/comptes :
- Ajouter un résultat NANA ; vérifier son apparition dans Rapports sur TOMTOM sans recharger, et inversement.
- Modifier une consigne ; ouvrir Programme sur l'autre appareil. Essayer deux sauvegardes concurrentes : le conflit doit être signalé.
- En compte NANA, consulter TOMTOM : aucun bouton actif pour écrire ses performances. Tester aussi une requête directe : RLS doit refuser (test SQL fourni).
- Déconnecté ou avec un troisième compte non membre : aucune donnée. Tester un nouveau téléphone, la récupération de mot de passe, et un échec réseau.

## 5. Mettre à jour GitHub Pages sans outil de build

1. Dans le dépôt `theotoro-cmyk/DUO-FIT`, sauvegarder la V2 et ses éventuelles données/export ; créer si possible une branche `v3` pour revue. Aucun changement au dépôt n'a été effectué dans cette livraison.
2. Remplacer / ajouter à la racine : `index.html`, `style.css`, `app.js`, `logic.mjs`, `config.js` rempli de valeurs publiques, `icon.svg`, `manifest.webmanifest` et `.nojekyll`. Conserver les documents SQL/Markdown dans le dépôt pour maintenance si souhaité. Ne pas importer tout le ZIP en tant que fichier unique : extraire et placer les fichiers au bon niveau.
3. Si la V2 a installé un service worker, vérifier dans son code le nom de son fichier et son périmètre. Retirer son enregistrement et publier temporairement un service worker de retrait **au même chemin** qui s'active immédiatement et désinscrit son propre scope ; une simple suppression du fichier ne retire pas un worker déjà actif. Sans son code, cette migration n'est pas automatisée. Sur iPhone, effacer les données du site seulement après export local si un ancien écran persiste. V3 n'installe aucun service worker.
4. Commit via GitHub « Add file → Upload files » sur la branche choisie, puis fusionner après revue. Ici, aucun commit, push ou déploiement n'a été lancé.
5. Settings → Pages → Build and deployment → Source : **Deploy from a branch**, branche `main` (ou celle effectivement utilisée), dossier **/(root)**, Save. Si Pages pointe déjà sur `/docs`, mettre les fichiers dans `docs/` ou changer la source. Si un workflow Actions existant publie Pages, l'adapter au lieu de garder deux méthodes concurrentes.
6. Attendre le succès du déploiement dans Actions / Pages. Ouvrir `https://theotoro-cmyk.github.io/DUO-FIT/`, recharger et vérifier les trois onglets et les deux comptes. Tous les chemins d'assets sont relatifs pour fonctionner sous `/DUO-FIT/`.
7. iPhone : Safari → Partager → Sur l'écran d'accueil. C'est une application web installable, pas une application App Store. La connexion réseau est nécessaire pour charger les dépendances Supabase et utiliser le mode partagé ; les polices externes ont un repli système.

## 6. Sauvegardes et limites

Le cloud assure la persistance entre appareils, pas une sauvegarde indépendante contre l'effacement du projet. Exporter régulièrement `members`, `program`, `performances` depuis Supabase (CSV par table via Table Editor, ou sauvegarde PostgreSQL selon votre offre). Stocker hors du dépôt dans un endroit privé. Les UUID des membres référencent Supabase Auth : une restauration vers un autre projet nécessite de recréer/réassocier les comptes et de mapper owner_id ; un export CSV n'est pas à lui seul une sauvegarde complète d'Auth. Tester la restauration avant d'en avoir besoin. Les exports locaux JSON concernent uniquement le mode local.

Les suggestions maintiennent la dernière référence d'une semaine précédente et ne prescrivent pas de maximum. Après plus de 21 jours sans référence antérieure : reprise plus légère selon sensations. Lest et assistance ne se mélangent pas ; la suggestion pour tractions/dips reprend le lest, pas l'assistance. Pour la charge totale, le 1RM estimé Epley est affiché seulement de 1 à 10 reps. Le record de charge et le record estimé peuvent provenir de séries différentes. Une charge de zéro n'a pas de 1RM. Les dates et semaines sont locales (lundi au dimanche), les semaines sans résultat restent absentes.

## Références officielles

- RLS et permissions : https://supabase.com/docs/guides/database/postgres/row-level-security
- Realtime Postgres Changes : https://supabase.com/docs/guides/realtime/postgres-changes
- Auth mot de passe : https://supabase.com/docs/guides/auth/passwords
- Clés API : https://supabase.com/docs/guides/api/api-keys
- Source GitHub Pages : https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site
