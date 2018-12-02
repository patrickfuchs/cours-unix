---
title: Programmation Bash - exercices - correction
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---


# Programmation Bash - exercices - éléments de correction

Les réponses proposées ci-dessous ne sont que des éléments de correction. D'autres solutions alternatives sont parfaitement possibles.


## Découverte du jeu de données

1. La commande pour décompressez l'archive `genomes.tgz` est :
    ```
    $ tar zxf genomes.tgz
    ```

    Un répertoire `genomes` est alors créé :
    ```
    $ ls -lh
    total 72K
    drwxr-xr-x 2 pierre pierre 4,0K juil. 26  2010 genomes/
    -rw-r--r-- 1 pierre pierre  63K juil. 26  2010 genomes.tgz
    ```

2. Pour déterminer le nombre de fichiers dans le répertoire `genomes`, on peut utiliser la commande `ls -l` qui affiche un fichier par ligne puis compter le nombre de lignes :
    ```
    $ ls -l genomes/ | wc -l
    48
    ```

    Mais il faut faire attention car la commande `ls -l` affiche effectivement un fichier par ligne mais aussi la taille total des fichiers (ici `total 376`) au début :
    ```
    $ ls -l genomes/
    total 376
    -rw-r--r-- 1 pierre pierre 5111 juil. 26  2010 NC_000907_head.gbk
    -rw-r--r-- 1 pierre pierre 5766 juil. 26  2010 NC_000964_head.gbk
    -rw-r--r-- 1 pierre pierre 5035 juil. 26  2010 NC_001869_head.gbk
    [...]
    -rw-r--r-- 1 pierre pierre 5089 juil. 26  2010 NC_013123_head.gbk
    -rw-r--r-- 1 pierre pierre 4745 juil. 26  2010 NC_013893_head.gbk
    -rw-r--r-- 1 pierre pierre 5410 juil. 26  2010 NC_014205_head.gbk
    ```

    Il faut donc retirer un du résultat précédent. Il y a donc **47 fichiers** dans le répertoire `genomes`.

    Pour afficher exactement un fichier par ligne, sans ligne supplémentaire, on peut utiliser l'option `-1` (le chiffre 1) de la commande `ls` :
    ```
    $ ls -1 genomes/
    NC_000907_head.gbk
    NC_000964_head.gbk
    NC_001869_head.gbk
    [...]
    NC_013123_head.gbk
    NC_013893_head.gbk
    NC_014205_head.gbk
    ```

    ce qui donne bien :
    ```
    $ ls -1 genomes/ | wc -l
    47
    ```

3. Nombre de lignes pour chaque fichier :
    ```
    $ wc -l *
       100 genomes/NC_000907_head.gbk
       100 genomes/NC_000964_head.gbk
       100 genomes/NC_001869_head.gbk
    [...]
       100 genomes/NC_013123_head.gbk
       100 genomes/NC_013893_head.gbk
       100 genomes/NC_014205_head.gbk
    4700 total
    ```
    Il y a 100 lignes par fichiers.


4. En observant les différents fichiers GenBank, on se rend compte que le nom d'organisme des staphylocoques est de la forme :
    ```
      ORGANISM  Staphylococcus epidermidis RP62A
    ```
    C'est en particulier le mot `Staphylococcus` qui est discriminant ici.

    En réalité d'autres lignes pourraient servir à identifier les staphylocoques, comme :
    ```
    DEFINITION  Staphylococcus epidermidis RP62A, complete genome.
    ```
    ou
    ```
    SOURCE      Staphylococcus epidermidis RP62A
    ```


## Extraction des staphylocoques

Suppression du répertoire `genomes` :
```
$ rm -rf genomes/
```

:warning: Attention à la commande `rm -rf` qui va supprimer sans demander confirmation le répertoire fourni en argument. Sous Unix, il n'y a pas de corbeille, ni possibilité de revenir en arrière.


Le script `get_staphylo.sh` devrait ressembler au script ci-dessous :

```
#! /usr/bin/env bash

# Pierre Poulain 2018

# define directories with data
dir_input="genomes"
dir_output="staphylo"

# uncompress initial file
tar zxf genomes.tgz

# create empty directory for Staphylococcus genomes
mkdir ${dir_output}

# loop on all genbank files
for name in $(ls ${dir_input}/*.gbk)
do
    # get organism name
    orga=$(awk '/ORGANISM/{print $2}' ${name})

    # select Staphylococcus files only
    if [[ ${orga} = "Staphylococcus" ]]
    then
        # print filename with Staphylococcus
        echo "${name} is a Staphylococcus"
        # copy Staphylococcus file into staphylo directory
        cp ${name} ${dir_output}
    fi
done

# create final archive
tar zcf staphylo.tgz ${dir_output}/

# delete data directories
rm -rf ${dir_input} ${dir_output}
```
