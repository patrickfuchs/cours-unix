---
title: Awk - Exercices
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---

# TP awk - jeu de données `people.dat`

L'objectif de ce TP est d'approfondir les compétences acquises précédemment pendant le cours d'Unix, mais aussi de découvrir `awk`.

1. Téléchargez le fichier `people.dat` avec la commande :
    ```
    wget https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/awk/people.dat
    ```

2. Déterminez combien de femmes sont listées dans le jeu de données.
    1. En utilisant `grep` et `wc`.
    1. En utilisant `grep` seulement et une option. Pour trouver la bonne option, allez voir dans le manuel (`man grep`) et recherchez le mot clef *count*.
    1. En utilisant `awk` et `wc`.

3. Affichez tous les hommes listés dans le jeu de données.
    1. En utilisant `grep`.
    1. En utilisant `awk` et en cherchant sur la ligne entière.
    1. En utilisant `awk` et en cherchant sur la première colonne uniquement.

4. Désormais, vous n'utilisez que `awk`. Affichez toutes les femmes,
    1. dont le prénom se termine par la lettre *e*.
    1. dont le prénom se termine par la lettre *e* et débute par la lettre *m*.
    1. dont la 3e lettre du prénom est *l*.

5. Affichez toutes les personnes,
    1. dont le prénom se termine par la lettre *e* et dont la taille est supérieure à 1,70 m.
    1. dont le prénom se termine par la lettre *e*, dont la taille est supérieure à 1,70 m et dont l'âge est inférieur à 40 ans.
    1. qui ont entre 40 et 50 ans (inclus).
