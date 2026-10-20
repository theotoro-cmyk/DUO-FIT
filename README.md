# DUO FIT V3

Commencer par **CONFIGURATION.md** : essai local, configuration Supabase, comptes, RLS, sauvegardes et mise à jour GitHub Pages.

- Application : `index.html` et ses fichiers voisins. Aucun build nécessaire.
- Configuration publique : `config.js` (mode local tant qu'il est vide).
- Installation base : `supabase.sql`.
- Tests des permissions à exécuter dans un projet de test : `rls-tests.sql`.
- Vérifications et limites : `VERIFICATION.md`.

Ne publier aucune clé secrète. La synchronisation et la persistance multi-appareils sont assurées par Supabase après configuration, pas par GitHub Pages.
