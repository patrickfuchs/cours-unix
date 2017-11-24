---
title: Bash
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage à l’identique 3.0"
---

# Bash

Bash est un interpréteur de ligne de commande (*shell*) utilisé sur des systèmes Unix / Linux. C'est un des shells les plus utilisés sous Linux.

Dans ce qui suit, l'invite du shell sera représentée par le symbole `$` en début de ligne.


## Variables et variables d'environnement

En Bash, il est possible de définir un certain nombre d'objets, qui vont contenir de l'information et résidés dans la mémoire du shell.


### Variables locales

Les variables locales ne sont pas transmistes au processus fils.

Par convention, elles sont écrites en miniscules. Par exemple: 

```
$ a=1
$ test='ma chaine de caracteres'
```

Attention. Il n'y a pas d'espace avant ou après le symbole `=` !

Si `var` est une variable, alors `$var` permet d'accéder au contenu de la variable et `echo $var` affiche le contenu de cette variable. Par exemple :

```
$ a=1
$ echo $a
1
$ test='ma chaine de caracteres'
$ echo $test
ma chaine de caracteres
```

Attention à ne pas confondre l'invite du shell en début de ligne `$` avec l'appel de la variable avec `$var`.

Lors de l'utilisation d'une variable, il est fortement recommandé d'entourer son nom pas des accolades `{ }`. Par exemple : 

```
$ a=1
$ echo ${a}
1
$ test='ma chaine de caracteres'
$ echo ${test}
ma chain
```


### Variable d'environnement

Les variables d'environnement sont transmises au processus fils. Par convention, elles s'écrivent en majuscules. Elles sont déclarées comme variables d'environnement avec la commande `export`.

Exemple : 

```
$ export PROSPER='Youplaboum'
$ echo ${PROSPER}
Youplaboum
```

Voici quelques variables d'environnement d'intérêt :

- `PATH` contient les chemins d’accès (répertoires) où le shell recherche les commandes tapées par l’utilisateur.
    ```
    export PATH=${PATH}:/my/new/dir
    ```
    ajoute le contenu de `/my/new/dir` à la variable `PATH`.
- `SHELL` contient le chemin vers le shell utilisateur (`/bin/bash` bien souvent).
- `USER` contient le nom (identifiant) de l’utilisateur.
- `HOSTNAME` contient le nom de la machine.
- `PWD` contient le chemin du répertoire courant.

La commande `env` affiche toutes les variables d'environnement.

Au Script, la connexion internet se fait via un proxy. Pour l'utiliser, il faut définir quelques variables d'environnement : 

```
export http_proxy=http://www-cache.script.univ-paris-diderot.fr:3128/
export https_proxy=http://www-cache.script.univ-paris-diderot.fr:3128/
export ftp_proxy=http://www-cache.script.univ-paris-diderot.fr:3128/
```


### Configuration du shell Bash

L'utilisateur peut configurer son shell Bash dans le fichier `.bashrc` situé dans le répertoire utilisateur (`$HOME`).

Exemple de fichier `.bashrc` :

```
# commentaire
alias ll='ls -lh'
alias lt='ls -rt'

export PATH=${PATH}:/my/new/dir
```


### Variables et caractères spéciaux

Les noms de variables peuvent contenir les lettre `A` à `Z`, `a` à `z` et les chiffres `0` à `9` ainsi que le caractère `_`

Il ne faut pas utiliser les caractères spéciaux  `* ? ! $ < > & \ / " '  ; #` et évitez les espaces.

Le caractère `\` "échappe" le caractère spécial suivant de l’interprétation du shell.

Les guillemets doubles (`"`) permettent l'interprétation des variables mais pas les guillemets simples (`'`). Exemple :

```
$ echo "mon login est ${USER}"
mon login est pierre
$ echo 'mon login est ${USER}'
mon login est $USER
```


## Programmation

> Fondamentalement, l'ordinateur et l'homme sont les deux opposés les plus intégraux qui existent. L'homme est lent, peu rigoureux et très intuitif. L'ordinateur est super rapide, très rigoureux et complètement con...

-- Gérard Berry, informaticien, médaille d'or du CNRS 2014, professeur au collège de France ([entretien au Nouvel Obs](https://tempsreel.nouvelobs.com/rue89/rue89-le-grand-entretien/20160826.RUE7684/gerard-berry-l-ordinateur-est-completement-con.html), 2016).


En programmation, on a besoin de faire 3 choses bien distinctes :

1. Stocker de l'information (par les variables).
2. Répéter des actions (par les boucles).
3. Prendre des décisions (par les tests).

Une fois qu'on sait faire ces 3 choses, on peut pratiquement tout faire.


### Script

La plupart du temps, quand il y a plusieurs commandes Bash, on les écrit dans un fichier qu'on appelle script.

#### Exécution

Pour être lancé, le script (par exemple `script.sh`) doit être rendu exécutable :

```
$ chmod +x script.sh
```

#### Première ligne et shebang

La première ligne du script est une ligne particulière qui débute par les caractères `#!` qu'on appelle [Shebang](https://fr.wikipedia.org/wiki/Shebang) (ou shabang) et qui contient le chemin pour trouver l'interpréteur de commandes, c'est-à-dire le shell. Pour Bash, on utilise :

```
#! /bin/bash
```

ou plus générique :

```
#! /usr/bin/env bash
```

La commmande précédente est celle qui permettra d'utiliser le script Bash sur le plus de systèmes d'exploitation Unix / Linux différents. C'est celle à utiliser.


À noter que l'option `-norc` permet ne pas tenir en compte le fichier de configuration `.bashrc` défini par l'utilisateur. Ce qui donne comme première ligne du script :

```
#! /usr/bin/env bash -norc
```

#### Arguments et variables prédéfinies

Dans un script Bash, tout ce qui suit le caractère `#` est ignoré et considéré comme un commentaire (sauf pour la première ligne et le shebang).

Il existe des variables prédéfinies comme :

- `$1`, `$2`... les arguments de la ligne de commande.
- `$*` tous les arguments de la ligne de commande.
- `$#` le nombre d'argument de la ligne de commande.

Par exemple, avec le script `test.sh` suivant :

```
#! /usr/bin/env bash

# affiche le nombre d'arguments donnés dans la ligne de commande
echo "Nombre d'arguments : $#"

# affiche tous les arguments en une seule fois
echo "Tous les arguments : $*"

# affiche le premier argument, puis le deuxième, puis...
echo "Premier argument : $1"
echo "Deuxième argument : $2"
echo "Troisième argument : $3"
```

Si on utilise maintenant `test.sh` avec deux arguments (`toto` et `titi`) :

```
$ ./test.sh toto titi 
Nombre d'arguments : 2
Tous les arguments : toto titi
Premier argument : toto
Deuxième argument : titi
Troisième argument : 
```

On remarque que l'affichage du troisième argument, qui pourtant n'existe pas, ne pose pas de problème à Bash. Par défaut, si une variable est appelée alors qu'elle n'a pas été définie au préalable, ça valeur est une chaîne de caractères vide.

Si on utilise maintenant `test.sh` avec trois arguments (`toto`, `titi` et `42`) :

```
$ ./test.sh toto titi 42
Nombre d'arguments : 3
Tous les arguments : toto titi 42
Premier argument : toto
Deuxième argument : titi
Troisième argument : 42
```

#### Résultat d'une commande

Il est possible de stocker le résultat d'une commande dans une variable :

```
$ nombre_femmes=$(awk '/woman/' people.dat | wc -l)
$ echo ${nombre_femmes} 
6
```

On peut utiliser également les caractères ` :

```
$ nombre_femmes=`awk '/woman/' people.dat | wc -l`
$ echo ${nombre_femmes} 
6
```

Toutefois, l'utilisation de `$( )` est préférable.


#### Un dernier exemple

Voici le script `bash_example.sh` :

```
#! /usr/bin/env bash

# define variables
var1=123
var2="Test for bash script"
var3=$(ls *.dat)

# print local variables
echo ${var1}
echo ${var2}
echo ${var3}

# print environment variables
echo "User ${USER} is working on computer ${HOSTNAME}"
echo 'User ${USER} is working on computer ${HOSTNAME}'
```

Et son utilisation, en vérifiant que le script est bien exécutable :

```
$ chmod +x bash_example.sh 
pierre@jeera:bash$ ls -l bash_example.sh 
-rwxrwxr-x 1 pierre pierre 301 nov.  22 15:03 bash_example.sh*
```

Puis : 

```
pierre@jeera:bash$ ./bash_example.sh 
123
Test for bash script
people.dat
User pierre is working on computer jeera
User ${USER} is working on computer ${HOSTNAME}
```

Soyez très attentifs aux différents type de guillemets utilisées (simple `'`, double `"` ou inversé `).


Astuce : récupérer la racine d'un nom de fichier, c'est-à-dire son nom sans l'extension.

```
$ name="people.dat"
$ root1=$(basename $name .dat)
$ root2=${name%.dat}
$ echo ${name} ${root1} ${root2}
people.dat people people
```


### Manipulation de variables

Bash ne sait manipuler que les variables numériques entières :

```
$ i=3
$ let i++
$ echo $i
4
$ let i--
$ echo $i
3
$ let i=$i+10
$ echo $i
13
```

On peut également manipuler des chaînes de caractères :

```
$ a="I love"
$ b="Unix"
$ echo "$a $b"
I love Unix
```


### Boucles for

Voici une boucle sur une liste d'éléments explicits :

```
for fruit in pomme poire fraise
do
    echo ${fruit}
done
```

Les actions à réaliser pour chacun des éléments de la boucle sont entre `do` et `done`. Ici, il n'y a qu'une action `echo ${fruit}`, c'est-à-dire l'affichage du contenu de la variable `fruit`. 

L'indentation -- le retrait à droite -- des actions à réaliser dans la boucle n'est pas obligatoire mais facilite la lecture de la boucle.


Voici maintenant une boucle sur les fichiers `.html` du répertoire courant :

```
for i in *.html
do
    echo $i
done
```

Et une boucle pour afficher tous les mots d'un fichier, un mot par ligne :

```
for i in $(cat fichier)
do
    echo $i
done
```

La même chose sur une seule ligne :

```
for i in $(cat fichier) ; do echo $i ; done
```


### Test

Pour faire un test, il faut réaliser une comparaison. Une comparaison utilise des opérateurs logiques.

Opérateurs pour les entiers :

| opérateur  | signification        |
|------------|----------------------|
| `-eq`      | égal à               |
| `-ne`      | différent de         |
| `-gt`      | supérieur à          |
| `-ge`      | supérieur ou égale à |
| `-lt`      | inférieur à          |
| `-le`      | inférieur ou égale à |


Opérateurs pour les chaînes de caractères :

| opérateur  | signification        |
|------------|----------------------|
| `=`        | égal à               |
| `!=`       | différent de         |
| `>`        | supérieur à          |
| `<`        | inférieur à          |
| `-z`       | vide                 |


Enfin, on peut également combiner plusieurs comparaisons dans un test avec des opérateurs booléens :

| opérateur  | signification |
|------------|---------------|
| `!`        | négation      |
| `&&`       | et            |
| `!!`       | ou            |


Voici un premier test simple qui n'utilise pas de comparaisons :

```
if grep ORGANISM *gbk
then
    echo "recherche dans *.gbk"
else
    echo "recherche echouee"
fi
```

Si le mot-clef `ORGANISM` est trouvé dans les répertoires Genbank du répertoire courant `*.gbk` alors on affiche `recherche dans *.gbk`. Si ce n'est pas le cas, alors on affiche `recherche echouee`.



## Pour conclure sur la programmation en générale et Bash en particulier

> Programs must be written for people to read, and only incidentally for machines to execute.

-- [Harold Abelsen](https://fr.wikipedia.org/wiki/Hal_Abelson), *Structure and Interpretation of Computer Programs*, The MIT Press, 1996, préface de la première édition. H. Abelsen est informaticien et un membre fondateur des Creatives Commons et de la Free Software Foundation.

Vos programmes et scripts doivent contenir : 

- des commentaires précis et réguliers ;
- des noms de variables qui ont du sens ;
- une structure et une organisation claire.







## Ressources

[Bash scripting quirks & safety tips](https://jvns.ca/blog/2017/03/26/bash-quirks/)

