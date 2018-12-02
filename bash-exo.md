---
title: Programmation Bash - exercices
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---

# Programmation Bash - exercices

Téléchargez le fichier `genomes.tgz` avec la commande :
```
wget https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/bash/genomes.tgz
```

*Remarque.* Si la commande `wget` n'est pas disponible sur votre machine, essayez d'utiliser la commande `curl` :
```
curl https://raw.githubusercontent.com/patrickfuchs/cours-unix/master/files/bash/genomes.tgz -o genomes.tgz
```

Ce fichier contient les fichiers GenBank tronqués de quelques organismes (les dix premières lignes seulement).


## Découverte du jeu de données

1. Décompressez l'archive `genomes.tgz` que vous avez téléchargée.

2. Combien de fichiers contient le répertoire `genomes` qui a été créé ? Utilisez, bien sur, une (ou plusieurs) commande(s) Unix pour répondre. :sunglasses:

3. Familiarisez-vous avec les fichiers GenBank contenu dans le répertoire `genomes`. Combien de lignes y-a-t-il dans chaque fichiers ?

4. Quelle ligne des fichiers GenBank permet de savoir si l'organisme concerné est un staphylocoque ? Par exemple, le fichier *NC_002976_head.gbk* est un fichier d'un staphylocoque alors que *NC_002505_head.gbk* non.


## Extraction des staphylocoques

Supprimer maintenant le répertoire `genomes`.

Écrivez le script bash `get_staphylo.sh` qui s'exécute dans le même répertoire que `genomes.tgz` et qui :

1. décompresse l'archive `genomes.tgz` ;
2. crée un répertoire `staphylo`, au même niveau que le répertoire `genomes` qui contient les fichiers GenBank ;
3. affiche les noms des fichiers GenBank de staphylocoques ;
4. copie ces fichiers dans le répertoire `staphylo` ;
5. archive et compresse le répertoire `staphylo` sous le nom `staphylo.tgz` ;
6. supprime les répertoires `genomes` et `staphylo`.
