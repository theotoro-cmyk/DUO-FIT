# Vérification de livraison

## Effectué

- Vérification de syntaxe JavaScript de `app.js` et des modules.
- 18 assertions exécutées avec succès : semaines lundi/dimanche et changement d'année, Epley, exclusion séries longues/lest/assistance/zéro, validation des résultats, exclusion semaine en cours et futur pour les suggestions, pause longue, meilleure charge de la semaine précédente, agrégation hebdomadaire.
- Relecture des flux : saisie locale ou cloud distincte, modification du programme avec détection de concurrence, traitement des erreurs, profils et échappement du texte utilisateur.
- Configuration et permissions documentées à partir des pages officielles Supabase et GitHub.

Pour relancer les tests métier avec Node installé : `node logic.test.mjs`.

## À vérifier avant utilisation réelle

- Vérification visuelle Safari iPhone et navigateur bureau : non exécutée ici. Serveur local bloqué par l'environnement ; navigateur automatisé indisponible. Les styles prévoient une disposition mobile à une colonne, champs 16 px, zones tactiles et largeur de viewport.
- Auth, récupération de mot de passe, RLS et Realtime : non exécutés contre un projet réel. Aucun compte, secret ou projet Supabase n'a été demandé ou créé. Le script `rls-tests.sql` et le parcours à deux comptes du guide sont fournis pour cette validation.
- Aucune vérification de compatibilité avec une V2 : les sources du dépôt n'ont pas été accessibles et le dossier était vide. Pas d'import automatique de données V2.
- Aucun dépôt modifié, aucun déploiement réalisé.
