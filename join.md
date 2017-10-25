---
author:
    - Patrick Fuchs
    - Pierre Poulain
title: Join
---

# Join

`join` est un outil Unix qui va fusionner deux jeux de données organisés sous forme de colonnes à partir d'une colonne commune qui va ainsi faire le lien entre les deux fichiers.

Par exemple, je souhaite fusionner :

- le fichiers `age.txt` qui contient une liste de personnes avec leur prénom et leur age ;
- le fichier  `ville.txt` qui contient également une liste de personnes mais avec leur prénom et la ville où ils habitent.

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
```

La colonne commune entre les deux fichiers est la colonne qui contient les prénoms des personnes. On souhaite que le résultat final contienne le prénom des personnes mais aussi leur age et la ville où ils habitents. `join` donne rapidement le résultat attendu :

```
$ join age.txt ville.txt 
Alex 32 Nantes
Alice 41 Paris
Bob 55 Lyon
Julie 23 Pau
Paul 17 Marseille
```

La fusion s'est opérée par défaut sur la première colonne, qui est justement la colonne que les deux fichiers ont en commun.


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

Pour ordonner le fichier `ville2.txt`, on utilise la commande `sort` :

```
$ sort -k 1 ville2.txt 
Alex Nantes
Alice Paris
Bob Lyon
Julie Pau
Paul Marseille
```

Le paramètre `-k 1` signifie qu'on ordonne le fichier basé sur la première colonne.

En utilisant `join` et `sort`, vous pouvez combinez le fichier `age.txt` (ordonné) et le fichier `ville2.txt` (non ordonné) :

```
$ join age.txt <(sort -k 1 ville2.txt)
Alex 32 Nantes
Alice 41 Paris
Bob 55 Lyon
Julie 23 Pau
Paul 17 Marseille
```

Bien sur, si les deux fichiers sont désordonnés, cela fonctionne également :

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

À chaque fois, on réordonne les fichiers sur la base de la première colonne qui contient les prénoms.


## Séparateur

Le **séparateur** est le caractère utilisé pour séparer les différentes colonnes de données. Par défaut, `join` utilise un espace.

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

Si on fusionne les deux fichiers, voici ce qu'on obtient :

```
$ join age.txt ville.txt
Alice 41 Paris
Bob 55 Lyon
Paul 17 Marseille
```

Seuls les données communent aux deux fichiers sont prises en compte.

On peut forcer l'affichage des données d'un fichier, même si elles n'ont pas toutes de correspondance dans l'autre fichier.

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

Dans cet exemple, c'est le caractère `?` qui représente la valeur manquante. On aurait très bien aussi pu utiliser `--`, `NaN`, `inconnu`, `0`...

L'option `-o "0,1.2,2.2"` nécessite un peu plus d'explications. `0,1.2,2.2` signifie qu'on affiche la colonne utilisée pour fusionner les données (`0`), la seconde colonne du premier fichier (`1.2`) et la seconde colonne du second fichier (`2.2`). C'est un peu complexe mais très puissant !


## Un exemple complet

Nous allons maintenant utiliser un exemple plus complet et plus proche de la biologie.

Dans un premier fichier `prot.csv`, nous avons un jeu de données provenant de la base de données [UniProt](http://www.uniprot.org/) avec le nom, l'identifiant et la taille de quelques protéines :

```
$ cat prot.csv
name,id,length
CLH_DROME,P29742,1678
HSP83_DROME,P02828,717
HSP7D_DROME,P11147,651
EF2_DROME,P13060,844
CH60_DROME,O02649,573
ALF_DROME,P07764,361
APLP_DROME,Q9V496,3351
ENO_DROME,P15007,500
PYG_DROME,Q9XTL9,844
TPR_DROME,A1Z8P9,2346
POE_DROME,Q9VLT5,5322
TOP2_DROME,P15348,1447
TERA_DROME,Q7KN62,801
```

Le fichier est au format [Comma Separated Values](https://fr.wikipedia.org/wiki/Comma-separated_values) (csv). Sur chaque ligne, les différentes valeurs sont séparées par des `,`. La première ligne `name,id,length` est la ligne d'entête qui indique à quoi correspondant à chaque colonne.

Vous pouvez mieux vous rentre compte de l'organisation en colonne avec la commande suivante avec laquelle on remplace les caractères `,` par une tabulation (`\t`) :

```
$ sed 's/,/\t/g' prot.csv 
name    id  length
CLH_DROME   P29742  1678
HSP83_DROME P02828  717
HSP7D_DROME P11147  651
EF2_DROME   P13060  844
CH60_DROME  O02649  573
ALF_DROME   P07764  361
APLP_DROME  Q9V496  3351
ENO_DROME   P15007  500
PYG_DROME   Q9XTL9  844
TPR_DROME   A1Z8P9  2346
POE_DROME   Q9VLT5  5322
TOP2_DROME  P15348  1447
TERA_DROME  Q7KN62  801
```

La première ligne n'est pas encore très bien alignée mais on visualise déjà un peu mieux ce jeu de données. On remarque d'ailleurs que les colonnes ne sont pas ordonnées.

Dans un second fichier, également au format csv, nous avons une liste de protéines associées à des valeurs mesurées expérimentalement :

```
$ cat score.csv 
id,score
P37276,626000
Q9W596,1023000
P13607,543000
P02828,537000
P11147,869000
Q9V8R9,88000
P13060,395000
O02649,231000
Q9VLT5,24000
P08928,271000
P15348,311000
Q7KN62,97000
```

Et pour mieux *voir* le jeu de données :

```
$ sed 's/,/\t/g' score.csv 
id  score
P37276  626000
Q9W596  1023000
P13607  543000
P02828  537000
P11147  869000
Q9V8R9  88000
P13060  395000
O02649  231000
Q9VLT5  24000
P08928  271000
P15348  311000
Q7KN62  97000
```

On souhaite fusionner ces deux fichiers sur la base des identifiants des protéines de façon à avoir, pour toutes les protéines analysées expérimentalement :

- l'identifiant de la protéine,
- son nom (si il existe),
- la valeur du *score* mesuré expérimentalement.

Pour que ces fichiers puissent être traités par `join`, il faut que les données dans la colonne *commune* soient ordonnées. On utilise pour cela la commande `sort` :

```
$ sort -k 2 prot.csv -t ","
TPR_DROME,A1Z8P9,2346
name,id,length
CH60_DROME,O02649,573
HSP83_DROME,P02828,717
ALF_DROME,P07764,361
HSP7D_DROME,P11147,651
EF2_DROME,P13060,844
ENO_DROME,P15007,500
TOP2_DROME,P15348,1447
CLH_DROME,P29742,1678
TERA_DROME,Q7KN62,801
APLP_DROME,Q9V496,3351
POE_DROME,Q9VLT5,5322
PYG_DROME,Q9XTL9,844
```

L'option `-t ","` indique que le séparateur des colonnes est la virgule.

L'option `-k 2` indique qu'on ordonne le fichier sur la base des données de la deuxième colonne.

Vous remarquerez par contre que la ligne d'entête du fichier csv (`name,id,length`) a aussi été prise en compte. Elle ne nous intéresse pas et il faut l'exclure. On va utliser pour cela la commande `tail` :

```
$ tail -n +2 prot.csv 
CLH_DROME,P29742,1678
HSP83_DROME,P02828,717
HSP7D_DROME,P11147,651
EF2_DROME,P13060,844
CH60_DROME,O02649,573
ALF_DROME,P07764,361
APLP_DROME,Q9V496,3351
ENO_DROME,P15007,500
PYG_DROME,Q9XTL9,844
TPR_DROME,A1Z8P9,2346
POE_DROME,Q9VLT5,5322
TOP2_DROME,P15348,1447
TERA_DROME,Q7KN62,801
```

Ici, l'option `-n +2` indique qu'on va afficher le fichier depuis la deuxième ligne jusqu'à la fin.

En reprenant le tri des fichiers, on obtient :

```
$ tail -n +2 prot.csv | sort -t "," -k 2
TPR_DROME,A1Z8P9,2346
CH60_DROME,O02649,573
HSP83_DROME,P02828,717
ALF_DROME,P07764,361
HSP7D_DROME,P11147,651
EF2_DROME,P13060,844
ENO_DROME,P15007,500
TOP2_DROME,P15348,1447
CLH_DROME,P29742,1678
TERA_DROME,Q7KN62,801
APLP_DROME,Q9V496,3351
POE_DROME,Q9VLT5,5322
PYG_DROME,Q9XTL9,844

$ tail -n +2 score.csv | sort -t "," -k 1
O02649,231000
P02828,537000
P08928,271000
P11147,869000
P13060,395000
P13607,543000
P15348,311000
P37276,626000
Q7KN62,97000
Q9V8R9,88000
Q9VLT5,24000
Q9W596,1023000
```

On remarque déjà que la protéine `A1Z8P9` existe dans le fichier `prot.csv` mais pas dans `score.csv` et que la protéine `Q9W596` existe dans le fichier `score.csv` mais pas dans `prot.csv`. Nous occuperons des valeurs manquantes par la suite.

Pour simplifier les futures commandes que nous allons utiliser, on sauvegarde les fichiers sans leur entête et bien ordonnés :

```
$ tail -n +2 prot.csv | sort -t "," -k 2 > prot_clean.csv
$ tail -n +2 score.csv | sort -t "," -k 1 > score_clean.csv
```

Dans le fichier `prot_clean.csv`, la colonne qui contient les identifiants des protéines est la deuxième colonne. Pour le fichier `score_clean.csv`, les identifiants sont dans la première colonne.

Faisons déjà un premier test avec `join` : 

```
$ join -t "," -1 2 -2 1 prot_clean.csv score_clean.csv 
O02649,CH60_DROME,573,231000
P02828,HSP83_DROME,717,537000
P11147,HSP7D_DROME,651,869000
P13060,EF2_DROME,844,395000
P15348,TOP2_DROME,1447,311000
Q7KN62,TERA_DROME,801,97000
Q9VLT5,POE_DROME,5322,24000
```

C'est pas mal mais les protéines avec les valeurs manquantes n'apparaissent pas. On veux afficher toutes les protéines analysées expérimentalement (donc présentes dans `score_clean.csv`) même si elles ne sont pas présentes dans `prot_clean.csv` :

```
$ join prot_clean.csv score_clean.csv -t "," -1 2 -2 1 -a2
O02649,CH60_DROME,573,231000
P02828,HSP83_DROME,717,537000
P08928,271000
P11147,HSP7D_DROME,651,869000
P13060,EF2_DROME,844,395000
P13607,543000
P15348,TOP2_DROME,1447,311000
P37276,626000
Q7KN62,TERA_DROME,801,97000
Q9V8R9,88000
Q9VLT5,POE_DROME,5322,24000
Q9W596,1023000
```

Dans la 3e colonne, se trouve la longueur de la protéine, qui ne nous intéresse pas. Par ailleurs, il faut que les données manquantes apparaissent clairement avec `--`. On utilise alors les options `-e` et `-o` pour améliorer cela :

```
$ join prot_clean.csv score_clean.csv -t "," -1 2 -2 1 -a2 -e "--" -o 0,1.1,2.2
O02649,CH60_DROME,231000
P02828,HSP83_DROME,537000
P08928,--,271000
P11147,HSP7D_DROME,869000
P13060,EF2_DROME,395000
P13607,--,543000
P15348,TOP2_DROME,311000
P37276,--,626000
Q7KN62,TERA_DROME,97000
Q9V8R9,--,88000
Q9VLT5,POE_DROME,24000
Q9W596,--,1023000
```

Pour l'option `-o 0,1.1,2.2` :

- `0` correspond à la colonne commune entre les deux fichiers, c'est-à-dire à l'identifiant des protéines.
- `1.1` correspond à la première colonne du fichier `prot_clean.csv`, c'est-à-dire le nom des protéines.
- `2.2` correspond à la seconde colonne du fichier `score_clean.csv`, c'est-à-dire la valeur expérimentale.

Enfin, il peut être pertinent de remettre une ligne d'entête :

```
$ join prot_clean.csv score_clean.csv -t "," -1 2 -2 1 -a2 -e "--" -o 0,1.1,2.2 | sed '1s/^/id,name,score\n/'
id,name,score
O02649,CH60_DROME,231000
P02828,HSP83_DROME,537000
P08928,--,271000
P11147,HSP7D_DROME,869000
P13060,EF2_DROME,395000
P13607,--,543000
P15348,TOP2_DROME,311000
P37276,--,626000
Q7KN62,TERA_DROME,97000
Q9V8R9,--,88000
Q9VLT5,POE_DROME,24000
Q9W596,--,1023000
```

puis d'enregistrer le tout dans un fichier.

```
$ join prot_clean.csv score_clean.csv -t "," -1 2 -2 1 -a2 -e "--" -o 0,1.1,2.2 | sed '1s/^/id,name,score\n/' > prot_score.csv
```


Pour terminer, les fichiers `prot_clean.csv` et `score_clean.csv` auraient pu être remplacés par les lignes de commandes équivalentes. Cela donne une énorme commande :

```
$ join <(tail -n +2 prot.csv | sort -t "," -k 2) <(tail -n +2 score.csv | sort -t "," -k 1) -t "," -1 2 -2 1 -a2 -e "--" -o 0,1.1,2.2 | sed '1s/^/id,name,score\n/' > prot_score.csv
```

La même commande peut être organisée pour devenir (un peu) plus lisible :

```
$ join \
<(tail -n +2 prot.csv | sort -t "," -k 2) \
<(tail -n +2 score.csv | sort -t "," -k 1) \
-t "," -1 2 -2 1 -a2 -e "--" -o 0,1.1,2.2 \
| sed '1s/^/id,name,score\n/' \
> prot_score.csv
```

