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

Ce jeu de données contient les caractères d'un certain nombre d'individus :

- La première colonne correspond au sexe de la personne (`man` ou `woman`).
- La deuxième colone correspond au prénom.
- La troisième colonne correspond à la taille (en centimètres).
- La quatrième colonne correspond à l'âge (en années).


## Tests

### Sélection par expression régulière

L'utilisation générale est de la forme : `awk '/regex/' fichier`

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

On peut mettre une chaîne de caractères ou une expression régulière entre `/ /`. Par exemple, pour afficher les lignes qui contiennent le caractère `i` puis n'importe quel caractère (`..`) deux fois puis le caractère `e` :

```
$ awk '/i..e/' people.dat
man     baptiste    178     39
woman   mathilde    168     46
```


Afficher les lignes qui contiennent le caractère `s` suivi du caractère `i` ou `e` :

```
$ awk '/s[ie]/' people.dat
man     simon       175     33
man     serge       181     44
woman   elise       159     63
```


### Sélection sur une colonne précise

Bien sur, si l'expression régulière n'est pas très précise, on affiche beaucoup de lignes :

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

Exemple. Afficher les lignes pour lesquelles la seconde colonne débute par la lettre `p` :

```
$ awk '$2~/^p/' people.dat 
man     patrick     172     52
man     paul        185     29
```

Exemple. Afficher les lignes pour lesquelles la quatrième colonne est supérieure (strictement) à 50 :

```
$ awk '$4 > 50' people.dat 
man     patrick     172     52
woman   jeanne      172     56
woman   elise       159     63
```

Pour revenir à `$0`, les deux commandes suivantes sont équivalentes :

```
$ awk '/is/' people.dat
man     baptiste    178     39
woman   elise       159     63
$ awk '$0~/is/' people.dat
man     baptiste    178     39
woman   elise       159     63
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


Exemple. Afficher les lignes pour lesquelles la première colonne débute par `ma` (expression régulière `^ma`) et la deuxième colonne contient `mo`.

```
$ awk '$1~/^ma/ && $2~/mo/' people.dat
man     simon       175     33
```

Exemple. Afficher les lignes pour lesquelles la première colonne débute par `ma` (expression régulière `^ma`) et la troisième colonne est supérieure à 180. Pour la troisième colonne, on ne compare pas d'expression régulière entre `\\` mais directement la valeur numérique.

```
$ awk '$1~/^ma/ && $3 > 180' people.dat
man     serge       181     44
man     paul        185     29
man     bob         186     33
```

Exemple. Afficher les lignes pour lesquelles la première colonne débute par `ma` (expression régulière `^ma`) et la quatrième colonne est égale à 33.

```
$ awk '$1~/^ma/ && $4 == 33' people.dat
man     simon       175     33
man     bob         186     33
```


Exemple. Afficher les lignes pour lesquelles la quatrième colonne est inférieure (strictement) à 30 **ou** supérieure (strictement) à 60 :

```
$ awk '$4 < 30 || $4 > 60' people.dat
man     paul        185     29
woman   elise       159     63
```


## Actions

Pour mémoire, la syntaxe générale de `awk` est : **`awk [options] 'tests {actions}' fichier`**

On peut indiquer à `awk` de faire plusieurs actions entre `{ }`. La plus utilisée étant l'affichage avec `print`.

Exemple. Afficher la deuxième colonne des lignes qui contiennent le mot `woman` :

```
awk '/woman/ {print $2}' people.dat
clara
morgane
julie
jeanne
mathilde
elise
```

Même chose, précédée de la chaîne de caractères `prenom :` :

```
$ awk '/woman/ {print "prenom :", $2}' people.dat
prenom : clara
prenom : morgane
prenom : julie
prenom : jeanne
prenom : mathilde
prenom : elise
```


## Variables prédéfinies

`awk` fournit automatiquement un certain nombre de variables prédéfinies :

### Nombre de champs (colonnes) `NF`

```
$ awk '/paul/ {print NF}' people.dat
4
```

### Numéro de ligne `NR`

```
$ awk 'NR>3 && NR<=5 {print $2}' people.dat
morgane
patrick
```

Exemple. Afficher les lignes paires :

```
$ awk 'NR%2==0 {print $2}' people.dat
clara
morgane
julie
jeanne
mathilde
elise
```

### Variables crées à la volée

```
$ awk '/woman/ {a=a+1; print a, $2}' people.dat
1 clara
2 morgane
3 julie
4 jeanne
5 mathilde
6 elise
```

Dans cet exemple, la variable `a` n'existe pas a priori. Lorsque `awk` veut l'utiliser dans l'expression `a = a + 1`, il l'initialise à `0`. Il l'utilise ensuite dans l'expression `print a, $2`.

Dans `awk`, deux actions sont séparées par le caractère `;`.

L'expression `a=a+1` est équivalente à `a++`, qui présente l'avantage d'être plus comptacte :

```
$ awk '/woman/ {a++; print a, $2}' people.dat
1 clara
2 morgane
3 julie
4 jeanne
5 mathilde
6 elise
```


## BEGIN et END

Les mot-clefs `BEGIN` et `END` ont une signification très particulière puisque les actions qui les suivent ne sont exécutées qu'au début (`BEGIN`) ou à la fin (`END`) du parcours du fichier.

Exemple. Afficher le nombre total de lignes sélectionnées. L'action `{print "total:", a }` n'est exécutée que lorsque toutes les lignes du fichier `people.dat` ont été parcourues.

```
$ awk '/woman/ {a++; print $2} END {print "total:", a }' people.dat
clara
morgane
julie
jeanne
mathilde
elise
total: 6
```

Exemple :

- afficher `women found:` avant la lecture du fichier, 
- afficher la deuxième colonne des lignes du fichier `people.dat` qui contiennent `woman`,
- afficher `total: ` avec le nombre total de lignes sélectionnées après la lecture du fichier.

```
$ awk 'BEGIN {print "women found:"} \
/woman/ {a++; print $2} \
END {print "total:", a }' people.dat
women found:
clara
morgane
julie
jeanne
mathilde
elise
total: 6
```

Rappel : le symbole `\` en fin de ligne permet d'écrire une commande sur plusieurs lignes.

### Calcul

Calculer et afficher l'âge moyen des femmes :

```
$ awk '/woman/ {age=age+$4; count++} \
END {print "mean age:", age/count}' people.dat
mean age: 46.3333
```

Calculer et afficher l'âge moyen des femmes et afficher le nombre de femmes :

```
$ awk '/woman/ {age=age+$4; count++} \
END {print "total:",count; \
print "mean age:", age/count}' people.dat
total: 6
mean age: 46.3333
```

# Script

Lorsque les instructions `awk` deviennent trop nombreuses, il est plus pertinenent d'écrire un script dédié.

Exemple . Calculer et afficher l'âge moyen des femmes et afficher le nombre de femmes.

Fichier `mean_age_women.awk` :

```
BEGIN {
age=0
count=0
}

/woman/ {
count++
age=age+$4
}

END {
print "total woman:", count
print "mean age:", age/count
}

```

Les blocs d'instructions sont ainsi plus lisibles. Le retour à la ligne suffit à séparer plusieurs actions (pas besoin de `;`).

Ce script s'utilise en appelant `awk` avec l'option `-f` cette manière :

```
$ awk -f mean_age_women.awk people.dat
total woman: 6
mean age: 46.3333
```


# Séparateur de champ : option -F

Par défaut, `awk` suppose que les différentes colonnes (les différents champs) sont séparées par des espaces ou des tabulations (1 ou plusieurs.)

L'option `-F` (à ne pas confondre avec `-f`) définit le caractère qui séparer les différents champs.

Dans notre exemple `people.dat`, les différents champs sont séparés par des espaces (séparateur par défaut de `awk`).

Pour le vérifier, on peut demander à `awk` d'afficher le nombre de champs trouvés pour la première ligne uniquement :

```
$ awk 'NR==1 {print NF}' people.dat
4
```

Si on demande à `awk` de lire le même fichier mais en prenant le caractère `,` comme séparateur, `awk` ne trouve plus qu'un seul champ (car il n'y a pas de `,` dans le fichier `people.dat`) :

```
$ awk -F "," 'NR==1 {print NF}' people.dat
1
```

Dans un fichier au format [*tabulation-separated values*](https://fr.wikipedia.org/wiki/Tabulation-separated_values) (`.tsv`), les différents champs sont séparés par le caractère tabulation. Par exemple, dans le fichier `people.tsv` :

```
man simon   175 33
woman   clara   167 45
man serge   181 44
woman   morgane 174 31
man patrick 172 52
woman   julie   168 37
man paul    185 29
woman   jeanne  172 56
man baptiste    178 39
woman   mathilde    168 46
man bob 186 33
woman   elise   159 63
```

Ici, l'option `-F` n'est pas nécessaire :

```
$ awk 'NR==1 {print NF}' people.tsv
4
```


Par contre, dans un fichier au format [*comma-separated values*](https://fr.wikipedia.org/wiki/Comma-separated_values) (`.csv`), les différents champs sont séparés par une virgule. Par exemple, dans le fichier `people.csv` :

```
man,simon,175,33
woman,clara,167,45
man,serge,181,44
woman,morgane,174,31
man,patrick,172,52
woman,julie,168,37
man,paul,185,29
woman,jeanne,172,56
man,baptiste,178,39
woman,mathilde,168,46
man,bob,186,33
woman,elise,159,63
```

Ici, l'utilisation de l'option `-F` est indispensable pour que `awk` parcourt correctement le fichier :

```
$ awk 'NR==1 {print NF}' people.csv
1
$ awk -F "," 'NR==1 {print NF}' people.csv
4
```

et sur un cas concret :

```
$ awk '/woman/ {print "prenom :", $2}' people.csv
prenom : 
prenom : 
prenom : 
prenom : 
prenom : 
prenom : 
$ awk -F "," '/woman/ {print "prenom :", $2}' people.csv
prenom : clara
prenom : morgane
prenom : julie
prenom : jeanne
prenom : mathilde
prenom : elise
```

Soyez toujours très attentif au format des fichiers que vous manipulez.