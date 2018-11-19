---
title: Awk - exercices - correction
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---


# Awk - exercices - éléments de correction

Les réponses proposées ci-dessous ne sont que des éléments de correction. D'autres solutions alternatives sont parfaitement possibles.


# Jeu de données `people.dat`

## Analyses

### Nombre de femmes

Nombre de femmes sont présentes dans le jeu de données.

1. Avec `grep` et `wc` :
    ```
    $ grep "woman" people.dat | wc -l
    6
    ```

1. Avec `grep` seulement et l'option `-c`. Voici l'extrait du manuel de `grep` qui concerne cette option :
    ```
    -c, --count
           Suppress  normal output; instead print a count of matching lines for each
           input file.  With the -v, --invert-match option (see below),  count  non-
           matching lines.
    ```
    Ce qui donne pour notre jeu de données :
    ```
    $ grep -c "woman" people.dat
    6
    ```

1. Avec `awk` et `wc` :
    ```
    $ awk '/woman/' people.dat | wc -l
    6
    ```


### Nombre d'hommes

Les hommes présents dans le jeu de données.
1. Avec `grep` :
    ```
    $ grep "^man" people.dat
    man     simon       175     33
    man     serge       181     44
    man     patrick     172     52
    man     paul        185     29
    man     baptiste    178     39
    man     bob         186     33
    ```

1. Avec `awk` et en filtrant sur la ligne entière :
    ```
    $ awk '/^man/' people.dat
    man     simon       175     33
    man     serge       181     44
    man     patrick     172     52
    man     paul        185     29
    man     baptiste    178     39
    man     bob         186     33
    ```

1. Avec `awk` et en filtrant sur la première colonne uniquement :
    ```
    $ awk '$1 ~ /^man/' people.dat
    man     simon       175     33
    man     serge       181     44
    man     patrick     172     52
    man     paul        185     29
    man     baptiste    178     39
    man     bob         186     33
    ```

### Sélection sur les prénoms

Les femmes :

1. dont le prénom se termine par la lettre *e* :
    ```
    $ awk '/woman/ && $2 ~ /e$/' people.dat
    woman   claire     174     31
    woman   julie       168     37
    woman   jeanne      172     56
    woman   mathilde    168     46
    woman   elise       159     63
    ```

1. dont le prénom se termine par la lettre *e* et débute par la lettre *m* :
    ```
    $ awk '/woman/ && $2 ~ /^m.*e$/' people.dat
    woman   mathilde    168     46
    ```
    Remarque : l'expression régulière `^m.*e$` signifie que la colonne doit débuter par `m` puis contenir n'importe quel(s) caractère(s), puis se terminer par `e`.

1. dont la 3e lettre du prénom est *l* :
    ```
    $ awk '/woman/ && $2 ~ /^..l/' people.dat
    woman   julie       168     37
    ```


### Sélection sur plusieurs colonnes

Les personnes :

1. dont le prénom se termine par la lettre *e* et dont la taille est supérieure à 1,70 m :

    ```
    $ awk '$2 ~ /e$/ && $3>170' people.dat
    man     serge       181     44
    woman   claire      174     31
    woman   jeanne      172     56
    man     baptiste    178     39
    ```

1. dont le prénom se termine par la lettre *e*, dont la taille est supérieure à 1,70 m et dont l'âge est inférieur à 40 ans :

    ```
    $ awk '$2 ~ /e$/ && $3>170 && $4<40' people.dat
    woman   claire      174     31
    man     baptiste    178     39
    ```

1. qui ont entre 40 et 50 ans (inclus) :

    ```
    $ awk '$4 >= 40 && $4 <= 50' people.dat
    woman   clara       167     45
    man     serge       181     44
    woman   mathilde    168     46
    ```


# Jeu de données MNG2015


## Analyses

Pour que le jeu de données soit lu correctement, les commandes avec `awk` débuteront de la sorte :
```
$ awk -F "," 'NR>1 ...
```
Pour rappel, `-F ","` indique à `awk` que les colonnes sont séparées par une virgule et `NR>1` saute la première ligne.

Dans la suite, pour que la ligne de commande soit un peu plus courte, nous renommons le fichier contenant le jeu de données `mng2015_children_malaria_data.csv` en `mng2015.csv` :
```
$ mv mng2015_children_malaria_data.csv mng2015.csv
```

### Sexe des patients

1. Nombre de patients de sexe masculin :
    ```
    $ awk -F "," 'NR>1 && $4 ~ /^male/' mng2015.csv | wc -l
    124
    ```

1. Nombre de patients de sexe féminin :
    ```
    $ awk -F "," 'NR>1 && $4 ~ /^female/' mng2015.csv | wc -l
    105
    ```

1. Nombre total de patients :
    ```
    $ awk -F "," 'NR>1' mng2015.csv | wc -l
    229
    ```

    Cette étude comprenait effectivement 229 enfants.  
    Attention, `wc` seul ne donne pas le bon résultat car la première ligne (la ligne avec l'entête des colonnes) est aussi prise en compte :

    ```
    $ wc -l mng2015.csv
    230 mng2015.csv
    ```


### Âge moyen

1. Âge moyen de tous les patients :

    ```
    $ awk -F "," 'NR>1  {age+=$3; count++} END {print "mean age:", age/count}' mng2015.csv
    mean age: 3.0917
    ```

    Suivant votre système d'exploitation, vous pouvez obtenir `3,0917`. Aucune importance pour le moment mais gardez cela en tête pour la suite.

1. Âge moyen des patients ayant un profil hémoglobinique normal.

    Il faut aller chercher dans le champ *hb_profile* (7e champ) qui contient le profil hémoglobinique des patients. Les patients avec profil hémoglobinique normal sont notés *AA*. Les patients avec un profil hémoglobinique drépanocytaire sont notés *AS*.

    ```
    $ awk -F "," 'NR>1 && $7~/AA/ {age+=$3; count++} END {print "mean age:", age/count}' mng2015.csv
    mean age: 3.12563
    ```

    Suivant votre système d'exploitation, vous pouvez obtenir `3,12563`.

1. Âge moyen des patients ayant un profil hémoglobinique drépanocytaire (*sickle cell trait)*.

    ```
    $ awk -F "," 'NR>1 && $7~/AS/ {age+=$3; count++} END {print "mean age:", age/count}' mng2015.csv
    mean age: 2.86667
    ```

    Suivant votre système d'exploitation, vous pouvez obtenir `2,86667`.

1. Comparaison avec les résultats de l'article scientifique.

    L'article est disponible [ici](http://cupnet.net/docs/Etoka-Beka_2016_TMIH.pdf). On obtient des valeurs en accord avec celles du tableau 1 de l'article.


### Taux d'hémoglobine moyen

Le taux d'hémoglobine se trouve dans la colonne *hb_conc* (8e colonne).

1. Taux d'hémoglobine moyen des patients ayant un profil hémoglobinique normal (codé par `AA`).

    Sur ma machine, j'obtiens :

    ```
    $ awk -F "," 'NR>1 && $7~/AA/ {hb+=$8; count++} END {print "mean hb:", hb/count}' mng2015.csv
    mean hb: 11.3447
    ```

    Suivant votre système d'exploitation, vous pouvez obtenir :

    ```
    mean hb: 10,8643
    ```

    ce qui n'est pas du tout la valeur attendue.

    On remarque par contre que la valeur décimale `10,8643` est exprimée avec le symbole `,` comme séparateur décimale alors que c'est le symbole `.` qui est utilisé dans le jeu de données.

    Ce problème est récurrent sur les systèmes informatiques configurés en français. Pour corriger cela, il suffit de déclarer au préalable la variable d'environnement `LC_NUMERIC=C` avec la commande :

    ```
    $ export LC_NUMERIC=C
    ```

    Cette commande n'est à lancer qu'une seule fois, avant les analyses, ou à mettre dans votre fichier de configuration du *shell* (`.bashrc` ou `.profile`).

    Désormais, on obtient le bon résulat :

    ```
    $ awk -F "," 'NR>1 && $7~/AA/ {hb+=$8; count++} END {print "mean hb:", hb/count}' mng2015.csv
    mean hb: 11.3447
    ```

    :warning: Restez toujours vigilants sur ce problème de séparateur décimal (`.` ou `,`).

1. Taux d'hémoglobine moyen des patients drépanocytaires (codé par `AS`).

    ```
    $ awk -F "," 'NR>1 && $7~/AS/ {hb+=$8; count++} END {print "mean hb:", hb/count}' mng2015.csv
    mean hb: 11.18
    ```

1. Comparaison avec les résultats de l'article scientifique.

    Les résultats sont bien en accords avec le tableau 1 de l'article.


### Température moyenne

La température se trouve dans le champ *temp* (6e colonne).

La méthode de diagnostic du paludisme se trouve dans le champ *malaria* (12e colonne). Les valeurs possibles pour ce champ sont : *negative* (pas de paludisme), *uncomplicated* (paludisme diagnostiqué par microcopie) et *submicroscopic* (paludisme diagnostiqué par *Polymerase Chain Reaction* (PCR)).

1. Température moyenne des patients ayant un paludisme diagnostiqué par microscopie. On sélectionne les patients dont le champ *malaria* vaut *uncomplicated*.

    ```
    $ awk -F "," 'NR>1 && $12~/uncomplicated/ {temp+=$6; count++} END {print "mean temp:", temp/count}' mng2015.csv
    mean temp: 38.7727
    ```

1. Température moyenne des patients ayant un paludisme diagnostiqué par PCR. On sélectionne les patients dont le champ *malaria* vaut *submicroscopic*.

    ```
    $ awk -F "," 'NR>1 && $12~/submicroscopic/ {temp+=$6; count++} END {print "mean temp:", temp/count}' mng2015.csv
    mean temp: 37.7388
    ```

1. Comparaison avec les résultats de l'article scientifique.

    Les résultats sont bien en accords avec le tableau 2 de l'article.
