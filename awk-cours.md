---
title: Awk
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---

# Awk

`awk` est une outil Unix qui permet de traiter les lignes d'un fichier, lu en colonnes. Cela signifie que `awk` lit un fichier ligne par ligne mais peut filtrer et sélectionner des éléments sur la base de colonnes.

La syntaxe de `awk` est :

**`awk [options] 'filtres {actions}' fichier`**

- :warning: Les guillemets simples `'` sont très importants.
- Les filtres sont optionnels. Par défaut, tout est sélectionné.
- Les actions sont optionnelles. Par défaut, toute la ligne est affichée.


## Jeu de données

Voici le jeu de données (`people.dat`) que nous allons utiliser par la suite et que vous pouvez télécharger [ici](https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/awk/people.dat).

```
man     simon       175     33
woman   clara       167     45
man     serge       181     44
woman   claire      174     31
man     patrick     172     52
woman   julie       168     37
man     paul        185     29
woman   jeanne      172     56
man     baptiste    178     39
woman   mathilde    168     46
man     bob         186     33
woman   elise       159     63
```

Ce jeu de données contient les caractéristiques d'un certain nombre d'individus :

- La première colonne contient le sexe de la personne (`man` ou `woman`).
- La deuxième colonne contient le prénom.
- La troisième colonne contient la taille (en centimètres).
- La quatrième colonne contient l'âge (en années).


## Filtres

### Sélection par expression régulière

Une expression régulière est une combinaison de caractères et de métacaractères (caractères ayant une signification spéciale) utilisée pour filtrer une chaîne de caractères cible. En anglais, une expression régulière se dit *regular expression* ou *regex*.

Avec `awk`, une utilisation des expressions régulières est de la forme : `awk '/regex/ {actions}' fichier`

On rappelle que les `{actions}` que nous verrons par la suite sont optionnelles. On peut donc écrire directement `awk '/regex/' fichier`

On effectue un test avec l'expression régulière sur chaque ligne et on affiche la ligne si le test est vérifié. La notion de colonne n'a pas encore d'importance ici. Par exemple, on cherche dans le jeu de données le mot clef `woman` et on affiche les lignes qui le contiennent :

```
$ awk '/woman/' people.dat
woman   clara       167     45
woman   claire      174     31
woman   julie       168     37
woman   jeanne      172     56
woman   mathilde    168     46
woman   elise       159     63
```

Remarquez l'expression régulière `woman` qui se met entre `/ /`.

Par exemple, pour afficher les lignes qui contiennent le caractère `i` puis n'importe quel caractère deux fois (`..`) puis le caractère `e` :

```
$ awk '/i..e/' people.dat
man     baptiste    178     39
woman   mathilde    168     46
```

Remarque : dans une expression régulière, le métacaractère `.` correspond à n'importe quel caractère.

Voici un autre exemple qui affiche les lignes qui contiennent le caractère `s` suivi du caractère `i` ou `e` (les caractères `i` et `e` sont alors entre crochets) :

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
woman   claire      174     31
man     patrick     172     52
woman   julie       168     37
man     paul        185     29
woman   jeanne      172     56
man     baptiste    178     39
woman   mathilde    168     46
man     bob         186     33
woman   elise       159     63
```

Dans l'exemple ci-dessus, l'expression régulière `an` est présente dans la 1re et la 2e colonne.

On peut alors demander à `awk` de vérifier l'expression régulière sur une colonne en particulier (ici la 2e) :

```
$ awk '$2~/an/' people.dat
woman   jeanne      172     56
```

`awk` numérote automatique les colonnes de `$1` la première colonne à `$n` la n-ième colonne. La notation `$0` désigne toutes les colonnes (donc la ligne entière).

```
      man     simon       175     33
      woman   clara       167     45
      man     serge       181     44
      woman   claire      174     31
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

Exemple. Afficher les lignes pour lesquelles la seconde colonne débute par la lettre `p`. Le métacaractère `^` est utilisé pour indiquer le début de la colonne.

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

Voici quelques opérateurs de comparaison pour les expressions régulières, les chaînes de caractères et les valeurs numériques.

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
| &&        | et            |
| &#921;&#921;     | ou            |

Exemple. Afficher les lignes pour lesquelles la première colonne débute par `m` (expression régulière `^m`) et la deuxième colonne contient `mo`.

```
$ awk '$1~/^m/ && $2~/mo/' people.dat
man     simon       175     33
```

Exemple. Afficher les lignes pour lesquelles la première colonne débute par `m` (expression régulière `^m`) et la troisième colonne est supérieure à 180. Pour la troisième colonne, on ne compare pas d'expression régulière entre `/ /` mais directement la valeur numérique.

```
$ awk '$1~/^m/ && $3 > 180' people.dat
man     serge       181     44
man     paul        185     29
man     bob         186     33
```

Exemple. Afficher les lignes pour lesquelles la première colonne débute par `m` (expression régulière `^m`) et la quatrième colonne est égale à 33.

```
$ awk '$1~/^m/ && $4 == 33' people.dat
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

Pour mémoire, la syntaxe générale de `awk` est : **`awk [options] 'filtres {actions}' fichier`**

L'action la plus courante avec `awk` est l'affichage avec la commande `print`.

Exemple. Afficher la deuxième colonne des lignes qui contiennent le mot `woman` :

```
awk '/woman/ {print $2}' people.dat
clara
claire
julie
jeanne
mathilde
elise
```

Même chose, précédée de la chaîne de caractères `prenom :` :

```
$ awk '/woman/ {print "prenom :", $2}' people.dat
prenom : clara
prenom : claire
prenom : julie
prenom : jeanne
prenom : mathilde
prenom : elise
```


## Variables prédéfinies

`awk` fournit automatiquement un certain nombre de variables prédéfinies :


### Nombre de champs (colonnes) : `NF`

```
$ awk '/paul/ {print NF}' people.dat
4
```

### Numéro de ligne : `NR`

La première ligne du fichier porte le numéro 1.
```
$ awk 'NR>3 && NR<=5 {print $2}' people.dat
claire
patrick
```

Exemple. Afficher les lignes paires :

```
$ awk 'NR%2==0 {print $2}' people.dat
clara
claire
julie
jeanne
mathilde
elise
```

Remarque : l'opérateur modulo `%` renvoie le reste de la division entière. Ainsi `4%2` renvoie 0, `5%2` renvoie 1, `6%2` renvoie 0, `7%2` renvoie 1, etc.


### Variables crées à la volée

```
$ awk '/woman/ {a=a+1; print a, $2}' people.dat
1 clara
2 claire
3 julie
4 jeanne
5 mathilde
6 elise
```

Dans cet exemple, la variable `a` n'existe pas a priori. Lorsque `awk` veut l'utiliser dans l'expression `a = a + 1`, il l'initialise à `0`. Il l'utilise ensuite dans l'expression `print a, $2`.

Dans `awk`, deux actions sont séparées par le caractère `;`.

L'expression `a=a+1` est équivalente à `a++`, qui présente l'avantage d'être plus compacte :

```
$ awk '/woman/ {a++; print a, $2}' people.dat
1 clara
2 claire
3 julie
4 jeanne
5 mathilde
6 elise
```


## BEGIN et END

Les mot-clefs `BEGIN` et `END` ont une signification très particulière puisque les actions qui les suivent ne sont exécutées qu'au début (`BEGIN`) ou à la fin (`END`) du parcours du fichier.

Exemple. Afficher la 2e colonne lorsque les lignes contiennent `woman`, puis le nombre total de lignes affichées.

```
$ awk '/woman/ {a++; print $2} END {print "total:", a }' people.dat
clara
claire
julie
jeanne
mathilde
elise
total: 6
```

L'action `{print "total:", a }` n'est exécutée que lorsque toutes les lignes du fichier `people.dat` ont été parcourues.

Autre Exemple :

- afficher `women found:` avant la lecture du fichier,
- afficher la deuxième colonne des lignes du fichier `people.dat` qui contiennent `woman`,
- afficher `total: ` avec le nombre total de lignes sélectionnées après la lecture du fichier.

```
$ awk 'BEGIN {print "women found:"} \
/woman/ {a++; print $2} \
END {print "total:", a }' people.dat
women found:
clara
claire
julie
jeanne
mathilde
elise
total: 6
```

Remarque : le symbole `\` en fin de ligne permet d'écrire une commande sur plusieurs lignes.

Et deux derniers exemples pour terminer :

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

Lorsque les instructions `awk` deviennent trop nombreuses, il est plus pratique d'écrire un script dédié.

Exemple . Calculer et afficher l'âge moyen des femmes et afficher le nombre de femmes.

Les instructions `awk` sont dans le fichier `mean_age_women.awk` (téléchargeable [ici](https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/awk/mean_age_women.awk)) :

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

Ce script s'utilise en appelant `awk` avec l'option `-f` :

```
$ awk -f mean_age_women.awk people.dat
total woman: 6
mean age: 46.3333
```


# Séparateur de champ : option -F

Par défaut, `awk` suppose que les différentes colonnes (les différents champs) du fichier d'entrée sont séparées par des espaces ou des tabulations (une ou plusieurs.)

L'option `-F` (à ne pas confondre avec `-f`) définit le caractère qui sépare les différentes colonnes entre elles.

Dans notre exemple `people.dat`, les différentes colonnes sont séparées par des espaces (séparateur par défaut de `awk`).

Pour le vérifier, on peut demander à `awk` d'afficher le nombre de colonnes trouvées pour la première ligne uniquement :

```
$ awk 'NR==1 {print NF}' people.dat
4
```

Si on demande à `awk` de lire le même fichier mais en prenant le caractère `,` comme séparateur, `awk` ne trouve plus qu'un seul champ (car il n'y a pas de `,` dans le fichier `people.dat`) :

```
$ awk -F "," 'NR==1 {print NF}' people.dat
1
```

Dans un fichier au format [*tabulation-separated values*](https://fr.wikipedia.org/wiki/Tabulation-separated_values) (`.tsv`), les différentes colonnes sont séparées par le caractère tabulation. Par exemple, dans le fichier `people.tsv` que vous pouvez télécharger [ici](https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/awk/people.tsv).

```
man	simon	175	33
woman	clara	167	45
man	serge	181	44
woman	claire	174	31
man	patrick	172	52
woman	julie	168	37
man	paul	185	29
woman	jeanne	172	56
man	baptiste	178	39
woman	mathilde	168	46
man	bob	186	33
woman	elise	159	63
```

Remarque : le caractère tabulation est un caractère "élastique", c'est-à-dire qu'il est affiché avec une taille variable correspondante à 1 ou plusieurs caractères. Regardez par exemple la première ligne du fichier `people.tsv` où les champs *man*, *simon*, *175* et *33* sont séparés les uns des autres par un seul caractère tabulation mais qui apparaît comme 1 ou plusieurs espaces.

Ici, l'option `-F` n'est pas nécessaire car la tabulation est aussi le séparateur par défaut reconnu par `awk` (comme l'espace).

```
$ awk 'NR==1 {print NF}' people.tsv
4
```


Par contre, dans un fichier au format [*comma-separated values*](https://fr.wikipedia.org/wiki/Comma-separated_values) (`.csv`), les différents champs sont séparés par une virgule. Par exemple, dans le fichier `people.csv` que vous pouvez télécharger [ici](https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/awk/people.csv).

```
man,simon,175,33
woman,clara,167,45
man,serge,181,44
woman,claire,174,31
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
prenom : claire
prenom : julie
prenom : jeanne
prenom : mathilde
prenom : elise
```

:warning: Soyez toujours très attentif au format des fichiers que vous manipulez.
