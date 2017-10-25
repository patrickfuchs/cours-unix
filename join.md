---
author:
    - Patrick Fuchs
    - Pierre Poulain
title: Join
---

# Join

`join` est un outil Unix qui va fusionner deux jeux de données organisés sous forme de colonnes à partir d'une colonne commune.

Exemple avec les fichiers `age.txt` (prénom et age) et `ville.txt` (prénom et ville) :

```
$ cat age.txt
Alex 32
Alice 41
Bob 55
Julie 23
Paul 17

$ cat ville.txt
Alex Nantes
Alice Paris
Bob Lyon
Julie Pau
Paul Marseille

$ join age.txt ville.txt 
Alex 32 Nantes
Alice 41 Paris
Bob 55 Lyon
Julie 23 Pau
Paul 17 Marseille
```

La fusion s'est opérée par défaut sur la première colonne.


## Colonne désordonnée

Notez que la colonne qui est utilisée pour la fusion doit être ordonnées. Regardez cet exemple avec le fichier `ville2.txt` qui n'est pas ordonné :

```
$ cat age.txt 
Alex 32
Alice 41
Bob 55
Julie 23
Paul 17

$ cat ville2.txt 
Alice Paris
Paul Marseille
Julie Pau
Bob Lyon
Alex Nantes

$ join age.txt ville2.txt 
Alice 41 Paris
join: ville2.txt:3 : n'est pas trié : Julie Pau
Paul 17 Marseille
```

Pour ordonner le fichier `ville2.txt`, vous pouvez utiliser la commande `sort` :

```
$ sort -k 1 ville2.txt 
Alex Nantes
Alice Paris
Bob Lyon
Julie Pau
Paul Marseille
```

Le paramètre `-k 1` signifie que voulez ordonner le fichier basé sur la première colonne.

En utilisant `join` et `sort`, vous pouvez combinez le fichier `age.txt` (ordonné) et le fichier `ville2.txt` (non ordonné) :

```
$ join age.txt <(sort -k 1 ville2.txt)
Alex 32 Nantes
Alice 41 Paris
Bob 55 Lyon
Julie 23 Pau
Paul 17 Marseille
```

Bien sur, les deux fichiers sont désordonnés, cela fonctionne également :

```
$ cat age2.txt 
Bob 55
Alex 32
Julie 23
Paul 17
Alice 41

$ cat ville2.txt
Alice Paris
Paul Marseille
Julie Pau
Bob Lyon
Alex Nantes

$ join <(sort -k 1 age2.txt) <(sort -k 1 ville2.txt)
Alex 32 Nantes
Alice 41 Paris
Bob 55 Lyon
Julie 23 Pau
Paul 17 Marseille
```


## Séparateur

Le **séparateur** est le caractère utilisé pour séparer les différentes colonnes de données. Par défaut `join` utilise un espace.

Vous pouvez spécifiez votre propre séparateur avec l'option `-t`. Par exemple :

```
$ cat age3.txt
Alex,32
Alice,41
Bob,55
Julie,23
Paul,17

$ cat ville3.txt
Alex,Nantes
Alice,Paris
Bob,Lyon
Julie,Pau
Paul,Marseille

$ join age3.txt ville3.txt -t ","
Alex,32,Nantes
Alice,41,Paris
Bob,55,Lyon
Julie,23,Pau
Paul,17,Marseille
```

Le séparateur spécifié par `-t` doit être le même dans les deux fichiers. C'est aussi le même qui est utilisé pour afficher les données fusionnées.

Si le séparateur est une tabulation, il y a une petite astuce supplémenaire :

```
$ cat age4.txt
Alex    32
Alice   41
Bob     55
Julie   23
Paul    17

$ cat ville4.txt
Alex    Nantes
Alice   Paris
Bob     Lyon
Julie   Pau
Paul    Marseille

$ join age4.txt ville4.txt -t $'\t'
Alex    32  Nantes
Alice   41  Paris
Bob     55  Lyon
Julie   23  Pau
Paul    17  Marseille
```

Notez bien le `-t $'\t'` !


## Données manquantes

Dans l'exemple suivant, *Alex* n'existe pas dans le fichier `ville.txt` et `Julie` n'existe pas dans le fichier `age.txt` :

```
$ cat age.txt 
Alex 32
Alice 41
Bob 55
Paul 17

$ cat ville.txt 
Alice Paris
Bob Lyon
Julie Pau
Paul Marseille
```

Si vous fusionnez les deux fichiers, voici ce que vous obtenez :

```
$ join age.txt ville.txt
Alice 41 Paris
Bob 55 Lyon
Paul 17 Marseille
```

Seuls les données communent aux deux fichiers sont prises en compte.

Vous pouvez forcer l'affichage des données d'un fichier, même si elles n'ont pas toutes de correspondance dans l'autre fichier.

Pour afficher toutes les données du premier fichier, on utilise l'option `-a1`.

```
$ join age.txt ville.txt -a1
Alex 32
Alice 41 Paris
Bob 55 Lyon
Paul 17 Marseille
```

`Alex` est présent dans le premier fichier mais pas dans le second. Il est donc affiché.

Réciproquement, l'option `-a2` affiche toutes les données du second fichier :

```
join age.txt ville.txt -a2
Alice 41 Paris
Bob 55 Lyon
Julie Pau
Paul 17 Marseille
```

`Julie` est présente dans le second fichier mais pas le premier. Elle est donc affichée. Attention cependant, on ne voit pas immédiatement qu'il manque une information (l'age) sur la ligne :

```
Julie Pau
```

Bien sur, on peut également affiche toutes les lignes des deux fichiers en combinant les options `-a1` et `-a2` :

```
$ join age.txt ville.txt -a1 -a2
Alex 32
Alice 41 Paris
Bob 55 Lyon
Julie Pau
Paul 17 Marseille
```

Cependant, il est préférable d'indiquer explicitement que des données sont manquantes, en leur associant une marque particulière. Pour cela, on utilise :

- l'option `-e` qui spécifie comment est représentée l'information manquante ;
- et l'option `-o` qui précise, pour chaque fichier, quelles colonnes sont affichées.


```
$ join age.txt ville.txt -a1 -a2 -e "?" -o "0,1.2,2.2"
Alex 32 ?
Alice 41 Paris
Bob 55 Lyon
Julie ? Pau
Paul 17 Marseille
```

Dans cet exemple, c'est le caractère `?` qui représente la valeur manquante. Vous auriez très bien aussi pu utiliser `--`, `NaN`, `inconnu`, `0`...

L'option `-o "0,1.2,2.2"` nécessite un peu plus d'explications. `0,1.2,2.2` signifie qu'on affiche la colonne utilisée pour fusionner les données (`0`), la seconde colonne du premier fichier (`1.2`) et la seconde colonne du second fichier (`2.2`). C'est un peu complexe mais très puissant !

