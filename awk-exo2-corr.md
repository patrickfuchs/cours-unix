---
title: TP awk - jeu de données MNG2015 - éléments de correction
author:
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---


# TP awk - jeu de données MNG2015 - éléments de correction


## Préparation des données

```
wget https://zenodo.org/record/154453/files/mng2015_children_malaria_data.csv
wget https://zenodo.org/record/154453/files/mng2015_children_malaria_codebook.txt
```

À chaque fois les fichiers téléchargés sont enregistrés dans le répertoire à partir duquel vous avez lancé la commande `wget` (celui où vous étiez dans votre terminal).

1. Le *codebook* (`mng2015_children_malaria_codebook.txt`) vous permet de comprendre le contenu du jeu de données.

    Attention, à chaque fois, il faudra ignorer la première ligne du jeu de données qui contient les entêtes des colonnes.

2. Sexe des patients

    a. Nombre de patients de sexe masculin :

        ```
        $ awk -F "," 'NR>1 && $4 ~ /^male/' mng2015_children_malaria_data.csv | wc -l
        124
        ```

    b. Nombre de patients de sexe féminin :

        ```
        $ awk -F "," 'NR>1 && $4 ~ /^female/' mng2015_children_malaria_data.csv | wc -l
        105
        ```

    c. Nombre total de patients :

        ```
        $ awk -F "," 'NR>1' mng2015_children_malaria_data.csv | wc -l
        229
        ```

        Cette étude comprenait effectivement 229 enfants.  
        Attention, `wc` seul ne donne pas le bon résultat car la première ligne (la ligne avec l'entête des colonnes) est aussi prise en compte :

        ```
        $ wc -l mng2015_children_malaria_data.csv
        230 mng2015_children_malaria_data.csv
        ```

3. Age moyen

    a. Age moyen de tous les patients :

        ```
        $ awk -F "," 'NR>1  {age+=$3; count++} END {print "mean age:", age/count}' mng2015_children_malaria_data.csv
        mean age: 3.0917
        ```

        Avec FreeBSD, vous devriez obtenir `3,0917`. Aucune importance pour le moment mais gardez cela en tête pour la suite.

    b. Age moyen des patients ayant un profil hémoglobinique normal.

        Il faut aller chercher dans le champ *hb_profile* (7e champ) qui contient le profil hémoglobinique des patients. Les patients avec profil hémoglobinique normal sont notés *AA*. Les patients un profil hémoglobinique drépanocytaire sont notés *AS*.

        ```
        $ awk -F "," 'NR>1 && $7~/AA/ {age+=$3; count++} END {print "mean age:", age/count}' mng2015_children_malaria_data.csv
        mean age: 3.12563
        ```

        Avec FreeBSD, vous devriez obtenir `3,12563`.

    c. Age moyen des patients ayant un profil hémoglobinique drépanocytaire (*sickle cell trait)*.

        ```
        $ awk -F "," 'NR>1 && $7~/AS/ {age+=$3; count++} END {print "mean age:", age/count}' mng2015_children_malaria_data.csv
        mean age: 2.86667
        ```

        Avec FreeBSD, vous devriez obtenir `2,86667`.

    d. Comparaison avec les résultats de l'article scientifique.

        L'article est disponible [ici](http://cupnet.net/docs/Etoka-Beka_2016_TMIH.pdf). On obtient des valeurs en accord avec celles du tableau 1 de l'article.

4. Taux d'hémoglobine moyen

    Le taux d'hémoglobine se trouve dans la colonne *hb_conc* (8e colonne).

    a. Taux d'hémoglobine moyen des patients ayant un profil hémoglobinique normal.

        Sur ma machine, j'obtiens :

        ```
        $ awk -F "," 'NR>1 && $7~/AA/ {hb+=$8; count++} END {print "mean hb:", hb/count}' mng2015_children_malaria_data.csv
        mean hb: 11.3447
        ```

        Sur les machines FreeBSD du Script, vous devriez obtenir :

        ```
        mean hb: 10,8643
        ```

        ce qui n'est pas du tout la valeur attendue.

        On remarque par contre que la valeur décimale `10,8643` est exprimée avec le symbole **,** comme séparateur décimale alors que c'est le symbole **.** qui est utilisé dans le jeu de données.

        Ce problème est récurrent sur les systèmes informatiques configurés en français. Pour corriger cela, il suffit de déclarer au préalable la variable d'environnement `LC_NUMERIC=C` avec la commande :

        ```
        export LC_NUMERIC=C
        ```

        Cette commande n'est à lancer qu'une seule fois, avant les analyses, ou à mettre dans votre fichier de configuration du *shell* (`.bashrc` ou `.profile`).

        Désormais, on obtient le bon résulat :

        ```
        $ awk -F "," 'NR>1 && $7~/AA/ {hb+=$8; count++} END {print "mean hb:", hb/count}' mng2015_children_malaria_data.csv
        mean hb: 11.3447
        ```

        Restez toujours vigilants sur ce problème de séparateur décimal (`.` ou `,`).

    b. Taux d'hémoglobine moyen des patients drépanocytaires.

        ```
        $ awk -F "," 'NR>1 && $7~/AS/ {hb+=$8; count++} END {print "mean hb:", hb/count}' mng2015_children_malaria_data.csv
        mean hb: 11.18
        ```

    c. Comparaison avec les résultats de l'article scientifique.

        Les résultats sont bien en accords avec le tableau 1 de l'article.


5. Température moyenne.

    La température se trouve dans le champ *temp* (6e colonne).

    La méthode de diagnostic du paludisme se trouve dans le champ *malaria* (12e colonne). Les valeurs possibles pour ce champ sont : *negative* (pas de paludisme), *uncomplicated* (paludisme diagnostiqué par microcopie) et *submicroscopic* (paludisme diagnostiqué par *Polymerase Chain Reaction* (PCR)).

    a. Température moyenne des patients ayant un paludisme diagnostiqué par microscopie. On sélectionne les patients dont le champ *malaria* vaut *uncomplicated*.

        ```
        $ awk -F "," 'NR>1 && $12~/uncomplicated/ {temp+=$6; count++} END {print "mean temp:", temp/count}' mng2015_children_malaria_data.csv
        mean temp: 38.7727
        ```

    b. Température moyenne des patients ayant un paludisme diagnostiqué par PCR. On sélectionne les patients dont le champ *malaria* vaut *submicroscopic*.

        ```
        $ awk -F "," 'NR>1 && $12~/submicroscopic/ {temp+=$6; count++} END {print "mean temp:", temp/count}' mng2015_children_malaria_data.csv
        mean temp: 37.7388
        ```

    c. Comparaison avec les résultats de l'article scientifique.

        Les résultats sont bien en accords avec le tableau 2 de l'article.
