# MoniToro — séance à quatre exercices

## Mise à jour

1. Si Supabase est déjà configuré : exécuter seulement migration-rack-epaules.sql dans SQL Editor AVANT de publier les fichiers. Il ajoute rack et variant sans effacer les résultats et conserve les règles RLS. Ne pas relancer supabase.sql sur un projet existant. En mode local, aucune opération SQL nécessaire.
2. Décompresser le ZIP. Charger les fichiers à la racine du dépôt GitHub puis Commit changes. Conserver config.js actuel, exclu de ce ZIP. config.example.js est un modèle uniquement.
3. Attendre le déploiement réussi dans Actions, puis recharger le site Safari. Ne pas effacer ses données.

## Modifications

- Quatre emplacements de choix d'exercices remplacent le bandeau noir. Seules les fiches choisies apparaissent. Chaque emplacement peut être laissé vide ; un même exercice ne peut être sélectionné deux fois. Les quatre variantes d'épaules sont des choix distincts.
- Choix disponibles : développé couché, tractions, dips, soulevé de terre, squat, développé militaire haltères, développé debout, élévations haltères, élévations poulie.
- Rack pour développé couché et squat : texte facultatif pour hauteur des crochets et sécurités, mémorisé avec le résultat ; dernier réglage proposé à la prochaine saisie. Le journal affiche ce réglage. Ce champ ne représente pas une charge supplémentaire.
- Rapports et suggestions séparés par variante d'épaules. Dans Rapports, choisir le mouvement Épaules puis la variante. Les anciennes séances restent sous « variante non précisée », sans attribution arbitraire.
- NANA et TOMTOM plus grands. Suppression des flèches et symboles décoratifs.

Les choix des quatre emplacements sont conservés sur cet appareil par profil/date/module. Ils ne sont pas synchronisés ; les performances, variantes et réglages de rack le sont via Supabase après migration. Une autre sélection ne supprime aucun résultat. Tables, clés de stockage des performances et comptes existants sont conservés.

Validation : 23 assertions métier et 9 vérifications de rendu via DOM simulé réussies. Vérification visuelle Safari et exécution de la migration contre votre Supabase restent à effectuer. Aucun déploiement effectué ici.
