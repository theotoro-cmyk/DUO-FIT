# Mettre à jour MoniToro — dernier logo bleu

1. Décompresser le ZIP MoniToro-application-mise-a-jour.zip.
2. Dans GitHub, ouvrir https://github.com/theotoro-cmyk/DUO-FIT/upload/main avec le compte propriétaire connecté.
3. Glisser tous les fichiers contenus dans le ZIP directement à la racine du dépôt, pas le dossier ni le ZIP.
4. Cliquer sur Commit changes, puis attendre le succès de la publication Pages dans Actions.
5. Ouvrir https://theotoro-cmyk.github.io/DUO-FIT/ dans Safari et recharger.

IMPORTANT : votre config.js actuel n’est pas inclus dans ce ZIP pour ne pas écraser votre configuration Supabase. Le laisser dans le dépôt. config.example.js est seulement un modèle : pour une première installation sans config.js, le copier en config.js. Sans URL et clé publique, le mode local reste actif. Aucune synchronisation cloud sans configuration Supabase.

Ne pas supprimer les anciens résultats ni effacer les données Safari. Le nom interne du stockage et les tables Supabase sont conservés. Ne pas renommer le dépôt. Ne pas relancer supabase.sql ou rls-tests.sql pour cette mise à jour visuelle ; ils sont fournis uniquement pour installation et validation selon CONFIGURATION.md.

Le nouveau logo est bleu #3554EC avec trois barres et des cornes redessinées en courbes continues. Le symbole et le nom sont indépendants des profils ; la personnalisation des comptes clients n’est pas incluse. NANA et TOMTOM restent les deux profils actuels.

Sur un raccourci iPhone déjà installé, le nom et l’icône peuvent rester en cache : ouvrir d’abord le site dans Safari, puis l’ajouter à l’écran d’accueil sous MoniToro. Vérifier les données avant de retirer l’ancien raccourci.

Validation : syntaxe JavaScript et 18 tests métier réussis. Rendu Safari iPhone et connexion Supabase réelle non vérifiés dans cet environnement. Aucun déploiement effectué par l’assistant.
