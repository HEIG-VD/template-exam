# Template LaTeX pour Examen

Ce référentiel contient le nécessaire pour la génération d'un examen final à la HEIG-VD. Il peut être utilisé pour d'autres établissements en modifiant les en-têtes et par les professeurs de la HEIG-VD pour d'autres examens.

## Composition de l'examen

Première de couverture, nom de l'examen, résumé des points obtenus, date de réalisation, nom de l'étudiant et consignes d'examen. Deuxième de couverture vide. Troisième et quatrième de couverture vides.

Chaque problème est un feuillet soit A4, soit A3 avec en tête le numéro du problème.

- `problem1.tex`,
- `problem2.tex`,
- `problem3.tex`,
- `problem4.tex`,

Les objectifs de génération sont :

- regrouper l'examen en un feuillet simplement manipulable ;
- réduire le nombre de pages ;
- isoler les problèmes en des feuillets indépendants ;
- faciliter le tirage et l'assemblage.

## Utilisation

### Editer les métadonnées

Le fichier `config.yml` contient les métadonnées de l'examen. Il est possible de modifier le titre, le nom des auteurs, la date etc.

Ce fichier est méta-génère `config.tex` qui est inclus dans le fichier `exam.tex`.

### Editer les consignes de l'examen

Le fichier `directives.tex` contient les consignes de l'examen. Il est possible de modifier les consignes à votre convenance.

### Ajouter des problèmes

Chaque problème est un fichier séparé nommé `problemX.tex` où `X` est le numéro du problème. Il est possible d'ajouter autant de problèmes que nécessaire. Renseignez le fichier `exam.tex` le nombre de problèmes pour en inclure davantage.

### Générer l'examen

Pour générer l'examen, il suffit de lancer la commande `make` depuis un terminal. L'examen est généré dans :

- `dist/exam.pdf` : l'examen complet ;
- `dist/solution.pdf` : l'examen complet avec les solutions.

## Prérequis

- Docker ou
- XeLatex + Latexmk

## Génération

Depuis un devcontainer, simplement exécuter la commande suivante :

```bash
make
```