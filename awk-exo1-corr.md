---
title: Awk - Exercices - Eléments de correction
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---


# TP awk - jeu de données `people.dat` - éléments de correction

2. Combien de femmes sont listées dans le jeu de données ?

    a. Avec `grep` et `wc` :

        ```
        $ grep "woman" people.dat | wc -l
        6
        ```

    b. Avec `grep` seulement :

        ```
        $ grep -c "woman" people.dat
        6
        ```

    c. Avec `awk` et `wc` :

        ```
        $ awk '/woman/' people.dat | wc -l
        6
        ```

3. Les hommes listés dans le jeu de données :

    a. Avec `grep` :

        ```
        $ grep "^man" people.dat
        man     simon       175     33
        man     serge       181     44
        man     patrick     172     52
        man     paul        185     29
        man     baptiste    178     39
        man     bob         186     33
        ```

    b. Avec `awk` et en cherchant sur la ligne entière :

        ```
        $ awk '/^man/' people.dat
        man     simon       175     33
        man     serge       181     44
        man     patrick     172     52
        man     paul        185     29
        man     baptiste    178     39
        man     bob         186     33
        ```

    c. Avec `awk` et en cherchant sur la première colonne uniquement :

        ```
        $ awk '$1 ~ /^man/' people.dat
        man     simon       175     33
        man     serge       181     44
        man     patrick     172     52
        man     paul        185     29
        man     baptiste    178     39
        man     bob         186     33
        ```

4. Les femmes :

    a. dont le prénom se termine par la lettre *e* :

        ```
        $ awk '/woman/ && $2 ~ /e$/' people.dat
        woman   morgane     174     31
        woman   julie       168     37
        woman   jeanne      172     56
        woman   mathilde    168     46
        woman   elise       159     63
        ```

    b. dont le prénom se termine par la lettre *e* et débute par la lettre *m* :

        ```
        $ awk '/woman/ && $2 ~ /^m.*e$/' people.dat
        woman   morgane     174     31
        woman   mathilde    168     46
        ```

    c. dont la 3e lettre du prénom est *l* :

        ```
        $ awk '/woman/ && $2 ~ /^..l/' people.dat
        woman   julie       168     37
        ```

5. Les personnes :

    a. dont le prénom se termine par la lettre *e* et dont la taille est supérieure à 1,70 m :

        ```
        $ awk '$2 ~ /e$/ && $3>170' people.dat
        man     serge       181     44
        woman   morgane     174     31
        woman   jeanne      172     56
        man     baptiste    178     39
        ```

    b. dont le prénom se termine par la lettre *e*, dont la taille est supérieure à 1,70 m et dont l'âge est inférieur à 40 ans :

        ```
        $ awk '$2 ~ /e$/ && $3>170 && $4<40' people.dat
        woman   morgane     174     31
        man     baptiste    178     39
        ```

    c. qui ont entre 40 et 50 ans (inclus) :

        ```
        $ awk '$4 >= 40 && $4 <= 50' people.dat
        woman   clara       167     45
        man     serge       181     44
        woman   mathilde    168     46
        ```
