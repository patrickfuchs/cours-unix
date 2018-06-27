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
    wget 
    ```

2. Déterminez combien de femmes sont listées dans le jeu de données.

    a. En utilisant `grep` et `wc`.
    b. En utilisant `grep` seulement. (Allez voir dans le manuel et recherchez le mot clef *count*).
    c. En utilisant `awk` et `wc`.

3. Affichez tous les hommes listés dans le jeu de données.

    a. En utilisant `grep`.
    b. En utilisant `awk` et en cherchant sur la ligne entière.
    c. En utilisant `awk` et en cherchant sur la première colonne uniquement.

4. Désormais, vous n'utilisez que `awk`. Affichez toutes les femmes,

    a. dont le prénom se termine par la lettre *e*.
    b. dont le prénom se termine par la lettre *e* et débute par la lettre *m*.
    c. dont la 3e lettre du prénom est *l*.

5. Affichez toutes les personnes,

    a. dont le prénom se termine par la lettre *e* et dont la taille est supérieure à 1,70 m.
    b. dont le prénom se termine par la lettre *e*, dont la taille est supérieure à 1,70 m et dont l'âge est inférieur à 40 ans.
    c. qui ont entre 40 et 50 ans (inclus).
