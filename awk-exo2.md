---
title: TP awk - jeu de données MNG2015
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---


# TP awk - jeu de données MNG2015

L'objectif de ce TP est développer vos compétences en Unix et `awk`.

**Remarque si vous êtes sur les machines du Script de l'Université Paris Diderot :**
- Déclarez la variable d'environnement `https_proxy` par :
    ```
    export https_proxy=http://www-cache.script.univ-paris-diderot.fr:3128/
    ```

## Préparation des données

Téléchargez le fichier `mng2015_children_malaria_data.csv` depuis internet avec la commande :
```
wget https://zenodo.org/record/154453/files/mng2015_children_malaria_data.csv
```

Téléchargez également le *codebook* associé :
```
wget https://zenodo.org/record/154453/files/mng2015_children_malaria_codebook.txt
```


## Analyse

Ces données proviennent d'un [jeu de données](https://zenodo.org/record/154453/) qui a été généré dans le cadre de la publication scientifique [Plasmodium falciparum infection in febrile Congolese children: prevalence of clinical malaria 10 years after introduction of artemisinin-combination therapies](http://onlinelibrary.wiley.com/doi/10.1111/tmi.12786/abstract). L'article scientifique est consultable [ici](http://cupnet.net/docs/Etoka-Beka_2016_TMIH.pdf).


1. Pour comprendre ce jeu de données, prenez connaissance du *codebook*. Essayez d'en déduire le sens de chaque colonne.

2. Sexe des patients. En utilisant les outils `awk` et `wc`, déterminez :

    1. le nombre de patients de sexe masculin ;
    1. le nombre de patients de sexe féminin.
    1. Ces valeurs concordent-elles avec le nombre total de patients ?

3. Age moyen. En utilisant `awk` uniquement, déterminez :

    1. l'âge moyen de tous les patients ;
    1. l'âge moyen des patients ayant un profil hémoglobinique normal (champ *hb_profile*) ;
    1. l'âge moyen des patients ayant un profil hémoglobinique drépanocytaire (*sickle cell trait*).
    1. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.

4. Taux d'hémoglobine moyen. En utilisant `awk` uniquement, déterminez :

    1. le taux d'hémoglobine moyen des patients ayant un profil hémoglobinique normal ;
    1. le taux d'hémoglobine moyen des patients drépanocytaires.
    1. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.

5. Température moyenne. En utilisant `awk` uniquement, déterminez :

    1. la température moyenne des patients ayant un paludisme diagnostiqué par microscopie (champ *malaria*) ;
    1. la température moyenne des patients ayant un paludisme diagnostiqué par PCR.
    1. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.
