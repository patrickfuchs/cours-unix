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

Ces données proviennent d'un [jeu de données](https://zenodo.org/record/154453/) qui a été généré dans le cadre de la publication scientifique [Plasmodium falciparum infection in febrile Congolese children: prevalence of clinical malaria 10 years after introduction of artemisinin-combination therapies](http://onlinelibrary.wiley.com/doi/10.1111/tmi.12786/abstract). L'article scientifique est consultable [ici](http://cupnet.net/docs/Etoka-Beka_2016_TMIH.pdf).


1. Pour comprendre ce jeu de données, prenez connaissance du *codebook*. Essayez d'en déduire le sens de chaque colonne.

2. Sexe des patients. En utilisant les outils `awk` et `wc`, déterminez :

    a. le nombre de patients de sexe masculin ;
    b. le nombre de patients de sexe féminin.
    c. Ces valeurs concordent-elles avec le nombre total de patients ?

3. Age moyen. En utilisant `awk` uniquement, déterminez :

    a. l'âge moyen de tous les patients ;
    b. l'âge moyen des patients ayant un profil hémoglobinique normal (champ *hb_profile*) ;
    c. l'âge moyen des patients ayant un profil hémoglobinique drépanocytaire (*sickle cell trait*).
    d. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.

4. Taux d'hémoglobine moyen. En utilisant `awk` uniquement, déterminez :

    a. le taux d'hémoglobine moyen des patients ayant un profil hémoglobinique normal ;
    b. le taux d'hémoglobine moyen des patients drépanocytaires.
    c. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.

5. Température moyenne. En utilisant `awk` uniquement, déterminez :

    a. la température moyenne des patients ayant un paludisme diagnostiqué par microscopie (champ *malaria*) ;
    b. la température moyenne des patients ayant un paludisme diagnostiqué par PCR.
    c. Comparez vos résultats avec ceux de l'article scientifique dont sont tirées ces données.
