---
title: Sommes de contrôle - exercices - correction
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---


# Sommes de contrôle - exercices - éléments de correction

Les réponses proposées ci-dessous ne sont que des éléments de correction. D'autres solutions alternatives sont parfaitement possibles.

**Remarque :** avec un système d'exploitation Mac OS X,

- l'équivalent de la commande `md5sum` est `md5`
- et l'équivalent de la commande `sha256sum` est `shasum -a 256` .

## MD5

1. Retour dans le répertoire utilisateur (au cas où on serait ailleurs) :
    ```
    $ cd
    ```

    Création d'un fichier avec deux lignes :

    ```
    $ echo "test avec quelques mots" > test1.txt
    $ echo "et une seconde ligne" >> test1.txt
    ```

    Bien sur, vous pouvez aussi créer un fichier avec un éditeur de texte (`nano` en ligne de commande ou `gedit` dans l'interface graphique).

2. Copie du fichier `test1.txt` dans `test2.txt` :
    ```
    $ cp test1.txt test2.txt
    ```

3. Calcul des empreintes MD5 :
    ```
    $ md5sum test1.txt test2.txt
    ```

    Résultats avec mes fichiers `test1.txt` et `test2.txt` :  

    ```
    359301390fda64ae348aaa31e3bbabba  test1.txt
    359301390fda64ae348aaa31e3bbabba  test2.txt
    ```

    Attention, suivant ce que vous avez mis dans votre fichier, vous n'aurez pas la même empreinte.

4. Les empreintes sont les mêmes donc les fichiers sont identiques (copie l'un de l'autre)

5. Modification d'un seul caractère (le 'a' de 'avec' est remplacé par 'A') :

    ```
    $ sed -i 's/a/A/' test2.txt
    ```

    Vous pouvez aussi modifier le fichier en l'ouvrant dans un éditeur de texte.

6. Calcul des empreintes MD5 :
    ```
    $ md5sum test1.txt test2.txt
    ```

    Résultats avec mes fichiers `test1.txt` `test2.txt` :  
    ```
    359301390fda64ae348aaa31e3bbabba  test1.txt
    e6265cb52c9d3c289e2540e9cd7b169c  test2.txt
    ```

    Attention, suivant ce que vous avez mis dans votre fichier, vous n'aurez pas la même empreinte.

7. L'empreinte du fichier `test1.txt` est la même que précédemment car le fichier n'a pas été modifié. Par contre, l'empreinte du fichier `test2.txt` est complètement différente, alors qu'un seul caractère a été modifié (*a* minuscule remplacé par un *A* majuscule).

8. Suppression du fichier `test2.txt` :
    ```
    $ rm -f test2.txt
    ```

9. Téléchargement des fichiers `mng2015_children_malaria_data.csv` et `mng2015_children_malaria_codebook.txt` en ligne de commande :
    ```
    $ wget https://zenodo.org/record/154453/files/mng2015_children_malaria_data.csv
    $ wget https://zenodo.org/record/154453/files/mng2015_children_malaria_codebook.txt
    ```
    Calcul des empreintes MD5 :
    ```
    $ md5sum mng2015_*
    0bc6bcc866abe464a47cafdb37e89d5d  mng2015_children_malaria_codebook.txt
    c180c7af9169b2cf1f8e99e7ad018cc4  mng2015_children_malaria_data.csv
    ```

    Les empreintes MD5 des fichiers téléchargés sont les mêmes que celles indiquées en bas de la page <https://zenodo.org/record/154453/>. Les fichiers téléchargés et ceux sur le serveur sont donc identiques. J'ai téléchargé les bons fichiers.


## SHA256

1. Nouvelle copie du fichier test1.txt :
    ```
    $ cp test1.txt test3.txt
    ```

2. Calcul des empreintes SHA256 :
    ```
    $ sha256sum test1.txt test3.txt
    ```

3. Résultats avec mes fichiers `test1.txt` et `test3.txt` :

    Attention, suivant ce que vous avez mis dans votre fichier, vous n'aurez pas la même empreinte.

    ```
    05d3d44abc1420d215c7257958d3df5b5aa350427ef0ba01e2009ecca78a6485  test1.txt
    05d3d44abc1420d215c7257958d3df5b5aa350427ef0ba01e2009ecca78a6485  test3.txt
    ```
    Les empreintes SHA256 sont identiques car les deux fichiers sont identiques (copie l'un de l'autre).
    Les empreintes SHA256 sont plus longues (donc plus complexes) que les empreintes MD5. Les empreintes SH256 sont composées de 64 caractères contre 32 caractères pour les empreintes MD5.

4. Modification d'un seul caractère (ici, le 'v' de 'avec' est remplacé par 'b') :

    ```
    sed -i 's/v/b/' test3.txt
    ```

    Vous pouviez évidemment modifier le fichier en l'ouvrant dans un éditeur de texte.

5. Calcul des empreintes SHA256 :

    ```
    sha256sum test1.txt test3.txt
    ```

6. Résultats avec mes fichiers `test1.txt` et `test3.txt` :

    Attention, suivant ce que vous avez mis dans votre fichier, vous n'aurez pas la même empreinte.

    ```
    05d3d44abc1420d215c7257958d3df5b5aa350427ef0ba01e2009ecca78a6485  test1.txt
    79d7a0cbd29198132f295b863906ae117b65355d99adb8fbe5ff99811c7d5946  test3.txt
    ```

    L'empreinte du fichier `test1.txt` est la même que précédemment car le fichier n'a pas été modifié. Par contre, l'empreinte du fichier `test3.txt` est complètement différente, alors qu'un seul caractère a été modifié (*v* remplacé par un *b*).
