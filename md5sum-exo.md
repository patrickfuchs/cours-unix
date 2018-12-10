---
title: Sommes de contrôle - exercices
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---


# Sommes de contrôle - exercices

L'objectif de ce TP est de découvrir le fonctionnement et l’utilité des commandes `md5sum` et `sha256sum`.

**Remarque :** avec un système d'exploitation Mac OS X, 

- l'équivalent de la commande `md5sum` est `md5`
- et l'équivalent de la commande `sha256sum` est `shasum -a 256` .


## MD5

1. Dans votre répertoire utilisateur, créez le fichier `test1.txt` et ajoutez à l'intérieur quelques lignes.
2. Faites une copie de ce fichier dans `test2.txt`.
3. Calculez les empreintes MD5 des deux fichiers avec la commande
    ```
    md5sum test1.txt test2.txt
    ```

4. Que pouvez-vous dire de ces empreintes et des fichiers correspondants ?
5. Ouvrez le fichier `test2.txt` et modifiez un seul caractère.
6. Calculez à nouveau les empreintes MD5 des deux fichiers.
7. Que pouvez-vous dire de ces empreintes ? Existe-t-il une similarité entre les deux empreintes ?
8. Supprimez le fichier `test2.txt`.
9. Téléchargez (avec votre navigateur ou en ligne de commande) les fichiers `mng2015_children_malaria_data.csv` et `mng2015_children_malaria_codebook.txt` que vous trouverez en bas de la page <https://zenodo.org/record/154453/>. En utilisant les empreintes MD5 disponibles sur la page <https://zenodo.org/record/154453/>, vérifiez l'intégrité de ces fichiers.


## SHA256

1. Faites une nouvelle copie de `test1.txt` dans `test3.txt`.
2. Calculez les empreintes SHA256 des deux fichiers avec la commande
    ```
    sha256sum test1.txt test3.txt
    ```

3. Que pouvez-vous dire de ces empreintes ? Comparez-les aux empreintes MD5.
4. Ouvrez le fichier `test3.txt` et modifiez un seul caractère.
5. Calculez à nouveau les empreintes SHA256 des deux fichiers.
6. Que pouvez-vous dire de ces empreintes ? Y a-t-il une similarité entre les deux empreintes ?
