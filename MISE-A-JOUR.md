# MoniToro — cartes et exercices au rack

## Mettre à jour

1. Si Supabase est actif, exécuter migration-rack-exercices.sql dans SQL Editor avant publication. Compatible avec une base V3 d’origine ou la migration précédente. Il ajoute les colonnes manquantes et élargit la liste des variantes, sans effacer les résultats. Ne pas relancer supabase.sql sur un projet existant.
2. Décompresser le ZIP. Charger son contenu directement à la racine du dépôt GitHub puis Commit changes. Conserver config.js actuel (exclu du ZIP). config.example.js est un modèle uniquement.
3. Attendre le succès Pages dans Actions, puis recharger Safari. Ne pas effacer les données du site.

## Nouveautés

- Développé couché au rack et Squat au rack sont deux exercices sélectionnables, avec saisie de performances, suggestions et rapports distincts des versions classiques. Le champ de commentaire « réglage du rack » est retiré.
- Toucher l’un des quatre emplacements ouvre une bibliothèque de cartes d’exercices. Un mouvement déjà placé est désactivé pour éviter les doublons. Un emplacement peut rester vide.
- NANA prend le bleu du logo (#3554EC) ; TOMTOM reste vert.
- Les noms longs se répartissent sur plusieurs lignes, avec un équilibre sur deux lignes lorsque la largeur le permet, sans supprimer de mots.
- Les quatre variantes d’épaules restent disponibles séparément.

Dans Rapports : sélectionner Développé couché ou Squat, puis la variante au rack. Les anciennes performances restent dans Version classique : un ancien commentaire rack ne permet pas de déduire l’exercice pratiqué et n’est pas converti automatiquement. Ces commentaires historiques restent conservés dans les données et visibles dans le journal.

Les choix des quatre emplacements restent propres à chaque appareil et profil/date/module. Les performances et variantes se synchronisent via Supabase après migration. Cette mise à jour ne change pas les comptes, les droits ni le stockage existant.

Validation : 26 assertions métier et 12 vérifications de rendu avec DOM simulé réussies. Pas de vérification visuelle Safari ni de migration exécutée contre un projet réel. Aucun déploiement effectué ici.
