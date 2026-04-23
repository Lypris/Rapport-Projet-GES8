# Workflow des rapports LaTeX

Ce dépôt contient deux rapports indépendants:
- `rapport1/`
- `rapport2/`

Chaque rapport a son propre `main.tex`, ses `config/`, `contenu/` et `images/`.

## Travailler facilement sur l'un ou l'autre

Dans VS Code:
1. Ouvrir la palette de commandes (`Ctrl+Shift+P`)
2. Lancer `Tasks: Run Task`
3. Choisir l'une des tâches:
   - `Rapport: Compiler`
   - `Rapport: Nettoyer`
   - `Rapport: Rebuild complet`
4. Sélectionner ensuite le rapport cible (`rapport1` ou `rapport2`)

## Sorties générées

Le PDF compilé reste dans le dossier du rapport ciblé:
- `rapport1/main.pdf`
- `rapport2/main.pdf`

Les fichiers temporaires LaTeX sont ignorés via `.gitignore` et masqués dans l'explorateur VS Code.

## Recommandation d'organisation

- Modifier uniquement les fichiers dans le rapport actif (`rapport1` **ou** `rapport2`)
- Éviter de copier/coller des artefacts de compilation entre rapports
- Garder les fichiers partagés (si besoin plus tard) dans un dossier commun explicite, par exemple `shared/`
