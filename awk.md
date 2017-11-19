---
author:
    - Patrick Fuchs
    - Pierre Poulain
title: Awk
---

# Awk

`awk` est une commande Unix qui permet de traiter des lignes de fichiers, lus en colonnes. Cela signifie que `awk` lit un fichier ligne par ligne mais filtre et sélectionne des éléments sur la base de colonnes.

`awk` s'utilise de la manière suivante : **`awk [options] 'tests {actions}' fichier`**


## Exemple / jeu de données

Voici le jeu de données (`people.dat`) que allons utiliser par la suite :

```
man     simon       175     33
woman   clara       167     45
man     serge       181     44
woman   morgane     174     31
man     patrick     172     52
woman   julie       168     37
man     paul        185     29
woman   jeanne      172     56
man     baptiste    178     39
woman   mathilde    168     46
man     bob         186     33
woman   elise       159     63
```

- La première colonne correspond au sexe de la personne (`man` ou `woman`).
- La deuxième colone correspond au prénom.
- La troisième colonne correspond à la taille (en centimètres).
- La quatrième colonne correspond à l'âge (en années).


## Tests

### Sélection par expression régulière

`awk '/regex/' fichier`

On effectue un test sur chaque ligne et on affiche la ligne si le test est vérifié. Par exemple, on cherche le mot clef `woman` et on affiche les lignes qui le contiennent :

```
$ awk '/woman/' people.dat
woman   clara       167     45
woman   morgane     174     31
woman   julie       168     37
woman   jeanne      172     56
woman   mathilde    168     46
woman   elise       159     63
```

La syntaxe des expressions régulières est utilisable :

```
$ awk '/i..e/' people.dat
man     baptiste    178     39
woman   mathilde    168     46
```

Rappel : le métacaractère `.` correspond à n'importe quel caractère.


```
$ awk '/s[ie]/' people.dat
man     simon       175     33
man     serge       181     44
woman   elise       159     63
```

Rappel : l'expression régulière `s[ie]` correspond au caractère `s` suivi du caractère `i` ou `e`.

### Sélection sur une colonne précise

Bien sur, si l'expression régulière n'est pas très précise, on récupère beaucoup de lignes :

```
$ awk '/an/' people.dat
man     simon       175     33
woman   clara       167     45
man     serge       181     44
woman   morgane     174     31
man     patrick     172     52
woman   julie       168     37
man     paul        185     29
woman   jeanne      172     56
man     baptiste    178     39
woman   mathilde    168     46
man     bob         186     33
woman   elise       159     63
```

On peut demander à `awk` de vérifier l'expression régulière sur une colonne en particulier (ici la deuxième) :

```
$ awk '$2~/an/' people.dat 
woman   morgane     174     31
woman   jeanne      172     56
```


`awk` numérote automatique les colonnes de `$1` la première colonne à `$n` la n-ième colonne. La notation `$0` désigne toutes les colonnes (donc la ligne entière).

```
      man     simon       175     33
      woman   clara       167     45
      man     serge       181     44
      woman   morgane     174     31
      man     patrick     172     52
      woman   julie       168     37
      man     paul        185     29
      woman   jeanne      172     56
      man     baptiste    178     39
      woman   mathilde    168     46
      man     bob         186     33
$0 -- woman   elise       159     63
      |       |           |       | 
      $1      $2          $3      $4
```

Exemples : 

Affichage des lignes pour lesquelles la première colonne débute par `ma` (expression régulière `^ma`) et la deuxième colonne contient `mo`.

```
$ awk '$1~/^ma/ && $2~/mo/' people.dat
man     simon       175     33
```

Affichage des lignes pour lesquelles la première colonne débute par `ma` (expression régulière `^ma`) et la troisième colonne est supérieure à 180. Pour la troisième colonne, on ne compare pas d'expression régulière entre `\\` mais directement la valeur numérique.

```
$ awk '$1~/^ma/ && $3 > 180' people.dat
man     serge       181     44
man     paul        185     29
man     bob         186     33
```

Affichage des lignes pour lesquelles la première colonne débute par `ma` (expression régulière `^ma`) et la quatrième colonne est égale à 33.

```
$ awk '$1~/^ma/ && $4 == 33' people.dat
man     simon       175     33
man     bob         186     33
```


### Opérateurs de comparaisons

Pour les expressions régulières ou les chaînes de caractères :

| opérateur | signification     |
|-----------|-------------------|
| `~`       | correspond        |
| `!~`      | ne correspond pas |

Pour les valeurs numériques :

| opérateur | signification        |
|-----------|----------------------|
| `==`      | égal à               |
| `!=`      | différent            |
| `>`       | supérieur à          |
| `>=`      | supérieur ou égale à |
| `<`       | inférieur à          |
| `<=`      | inférieur ou égale à |

Combinaison de plusieurs comparaisons :

| opérateur | signification |
|-----------|---------------|
| `&&`      | et            |
| `||`      | ou            |


Exemple : affichage des lignes pour lesquelles la quatrième colonne est inférieur (strictement) à 30 **ou** la quatrième colonne est supérieure à 60 :

```
$ awk '$4 < 30 || $4 > 60' people.dat
man     paul        185     29
woman   elise       159     63
```

