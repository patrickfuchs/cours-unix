---
title: Awk - exercices
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---

# Awk - exercices

L'objectif de ces exercices est d'approfondir vos compétences d'Unix, mais aussi de vous faire découvrir `awk`.


# Jeu de données `people.dat`

## Préparation des données

Téléchargez le fichier `people.dat` avec la commande :
```
wget https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/awk/people.dat
```

*Remarque.* Si la commande `wget` n'est pas disponible sur votre machine, essayez d'utiliser la commande `curl` :
```
curl https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/awk/people.dat -o people.dat
```

## Analyses


### Nombre de femmes

Déterminez combien de femmes sont présentes dans le jeu de données.
1. En utilisant `grep` et `wc`.
1. En utilisant `grep` avec une option particulière. Pour trouver la bonne option, allez voir dans le manuel (`man grep`) et recherchez le mot clef *count*.
1. En utilisant `awk` et `wc`.


### Mémo sur les expressions régulières

Voici quelques métacaractères utiles pour la suite :
- `^` : début d'une colonne (ou d'une ligne)
- `$` : fin d'une colonne (ou d'une ligne)
- `.` : n'importe quel caractère (1 seule fois)
- `*` : entre 0 et plusieurs fois le caractère (ou métacaractère) précédent.
    Par exemple :
    + `a*` désigne rien ou `a` ou `aa`...
    + `.*` désigne rien ou `ab` ou `1213DZDSDD` (n'importe quel caractère 0 ou plusieurs fois)

### Nombre d'hommes

Affichez tous les hommes présents dans le jeu de données.
1. En utilisant `grep`.
1. En utilisant `awk` et en filtrant sur la ligne entière.
1. En utilisant `awk` et en filtrant sur la première colonne uniquement.


### Sélection sur les prénoms

Désormais, vous n'utiliserez que `awk`.

Affichez toutes les femmes :
1. Dont le prénom se termine par la lettre *e*.
1. Dont le prénom se termine par la lettre *e* et débute par la lettre *m*.
1. Dont la 3e lettre du prénom est *l*.


### Sélection sur plusieurs colonnes

Affichez toutes les personnes
1. dont le prénom se termine par la lettre *e* et dont la taille est supérieure à 1,70 m.
1. dont le prénom se termine par la lettre *e*, dont la taille est supérieure à 1,70 m et dont l'âge est inférieur à 40 ans.
1. qui ont entre 40 et 50 ans (inclus).


# Jeu de données MNG2015

## Préparation des données

Téléchargez le fichier `mng2015_children_malaria_data.csv` avec la commande :
```
wget https://zenodo.org/record/154453/files/mng2015_children_malaria_data.csv
```

Téléchargez également le *codebook* associé :
```
wget https://zenodo.org/record/154453/files/mng2015_children_malaria_codebook.txt
```


## Analyses

Ce [jeu de données](https://zenodo.org/record/154453/) a été généré dans le cadre de l'étude :

*Plasmodium falciparum infection in febrile Congolese children: prevalence of clinical malaria 10 years after introduction of artemisinin‐combination therapies*,  
publié dans *Tropical Medicine & International Health*, 2016, DOI [10.1111/tmi.1278](https://doi.org/10.1111/tmi.12786). Une version PDF de l'article est consultable [ici](http://cupnet.net/docs/Etoka-Beka_2016_TMIH.pdf).

Cette étude portaient sur la prévalence du paludisme chez des enfants de 1 à 10 ans, à l’hôpital de Brazzaville, en République du Congo.


### Format du jeu de données

Ce jeu  de données à deux particularités :
1. La première ligne contient l'entête, c'est-à-dire le nom des colonnes. Les données se trouvent donc au delà de la première ligne. Il faut dire à `awk` d'ignorer cette première ligne (avec la variable `NR`).
2. Le jeu de données est au format *comma-separated values* (`.csv`), ce qui signifie que les différentes colonnes sont séparées par des virgules. Il faut expressément dire à `awk` que le séparateur de colonne est une virgule (avec l'option `-F`).


### Codebook

Pour comprendre ce jeu de données, prenez connaissance du *codebook*. Le *codebook* explique la signification de chaque colonne du jeu de données.

Voici les premières lignes :
```
patient_id
    - patient id
    - format: MNGXXX with XXX a sequential number
    - values: MNG001, MNG270 ...

sampling_date
    - date of blood sampling
    - format: YYYY/MM/DD
    - values: 2015/02/04, 2014/12/10 ...

age
    - age of patient (in years)
    - format: integer
    - values: 4, 10 ...
```


### Sexe des patients

En utilisant les outils `awk` et `wc`, déterminez :

1. Le nombre de patients de sexe masculin.
1. Le nombre de patients de sexe féminin.
1. Ces valeurs concordent-elles avec le nombre total de patients ?


### Âge moyen

En utilisant `awk` uniquement, déterminez :

1. L'âge moyen de tous les patients.
1. L'âge moyen des patients ayant un profil hémoglobinique normal (colonne *hb_profile* avec le profile *normal hemoglobin*). Attention, utilisez le *codebook* pour savoir comment est représentée l'information *hb_profile*.
1. L'âge moyen des patients ayant un profil hémoglobinique drépanocytaire (colonne *hb_profile* avec le profile *sickle cell trait*).
1. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.


### Taux d'hémoglobine moyen

En utilisant `awk` uniquement, déterminez :

1. Le taux d'hémoglobine (colonne *hb_conc*) moyen des patients ayant un profil hémoglobinique normal.
1. Le taux d'hémoglobine (colonne *hb_conc*) moyen des patients drépanocytaires.
1. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.


### Température moyenne

En utilisant `awk` uniquement, déterminez :

1. La température (colonne *temp*) moyenne des patients ayant un paludisme diagnostiqué par microscopie (colonne *malaria* correspondante à *malaria diagnosed by microscopy*). Attention, utilisez le *codebook* pour savoir comment est représentée l'information *malaria*.
1. La température (colonne *temp*) moyenne des patients ayant un paludisme diagnostiqué par *polymerase chain reaction* (colonne *malaria* correspondante à *malaria diagnosed by PCR*).
1. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.
