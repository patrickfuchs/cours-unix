---
title: Programmation Bash
author:
    - Patrick Fuchs
    - Pierre Poulain
license: "Creative Commons Attribution - Partage dans les Mêmes Conditions 4.0"
---

# Programmation Bash

Bash est un interpréteur de ligne de commande (*shell*) utilisé sur des systèmes Unix / Linux. C'est un des *shells* les plus utilisés sous Linux.

Dans ce qui suit, l'invite du *shell* sera représentée par le symbole `$` en début de ligne.


## Variables et variables d'environnement

En Bash, il est possible de définir un certain nombre d'objets, qui vont contenir de l'information et résider dans la mémoire du *shell*.


### Variables locales

Les variables locales ne sont pas transmises au processus fils.

Par convention, elles sont écrites en minuscules. Par exemple :

```
$ a=1
$ test='ma chaîne de caractères'
```

Attention. Il n'y a pas d'espace avant ou après le symbole `=` !

Si `var` est une variable, alors `$var` donne accès au contenu de la variable et `echo $var` affiche le contenu de cette variable. Par exemple :

```
$ a=1
$ echo $a
1
$ test='ma chaîne de caractères'
$ echo $test
ma chaîne de caractères
```

Attention à ne pas confondre l'invite du *shell* en début de ligne `$` avec l'appel de la variable avec `$var`.

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

- `PATH` contient les chemins d’accès (répertoires) où le *shell* recherche les commandes tapées par l’utilisateur.
    ```
    export PATH=${PATH}:/mon/nouveau/repertoire
    ```
    ajoute le contenu de `/mon/nouveau/repertoire` à la variable `PATH`.
- `SHELL` contient le chemin vers le *shell* utilisateur (`/bin/bash` bien souvent).
- `USER` contient le nom (identifiant) de l’utilisateur.
- `HOSTNAME` contient le nom de la machine.
- `HOME` contient le chemin vers le répertoire personnel de l'utilisateur.
- `PWD` contient le chemin du répertoire courant.

La commande `env` affiche toutes les variables d'environnement.

Au Script, la connexion internet se fait via un [proxy](https://fr.wikipedia.org/wiki/Proxy). Pour l'utiliser, il faut définir quelques variables d'environnement :

```
export http_proxy=http://www-cache.script.univ-paris-diderot.fr:3128/
export https_proxy=http://www-cache.script.univ-paris-diderot.fr:3128/
export ftp_proxy=http://www-cache.script.univ-paris-diderot.fr:3128/
```

On notera qu'ici, exceptionnellement, ces variables d'environnement sont écrites en minuscules.


### Configuration du *shell* Bash

L'utilisateur peut configurer son *shell* Bash dans le fichier `.bashrc` situé dans le répertoire utilisateur (`$HOME`).

Exemple de fichier `.bashrc` :

```
# commentaire
alias ll='ls -lh'
alias lt='ls -rt'

export PATH=${PATH}:/my/new/dir
```


### Noms de variables

Les noms de variables peuvent contenir des lettres majuscules de `A` à `Z`, des lettres minuscules de `a` à `z`, des chiffres de `0` à `9` ainsi que les caractères `_`, `-` ou `.`.


### Guillemets doubles et simples

Les guillemets doubles (`"`) permettent l'interprétation des variables mais pas les guillemets simples (`'`). Exemple :

```
$ echo "mon login est ${USER}"
mon login est pierre
$ echo 'mon login est ${USER}'
mon login est $USER
```


## Attention aux caractères spéciaux dans les noms de fichiers

L'utilisation des caractères spéciaux  `* ? ! $ < > & \ / " '  ; #` et des espaces dans les noms de fichiers n'est pas recommandé.

Le caractère `\` *échappe* le caractère spécial suivant de l’interprétation du *shell*.

Par exemple, avec le fichier `mon fichier.txt`, l'affichage de son contenu (`hello world`) avec la commande `cat` pourra être problématique. Sans *échapper* l'espace contenu dans `mon fichier.txt`, `cat` va vouloir afficher les fichiers `mon` et `fichier.txt`, qui bien sur n'existent pas :

```
$ cat mon fichier.txt
cat: mon: Aucun fichier ou dossier de ce type
cat: fichier.txt: Aucun fichier ou dossier de ce type
```

Par contre, avec un espace correctement *échappé* avec `\` ou le nom de fichier entre guillemets, on peut afficher le contenu de `mon fichier.txt`.

```
$ cat mon\ fichier.txt
hello world

$ cat "mon fichier.txt"
hello world

$ cat 'mon fichier.txt'
hello world
```

Mais de manière générale, ne mettez pas d'espace dans vos noms de fichiers.


## Programmation

> Fondamentalement, l'ordinateur et l'homme sont les deux opposés les plus intégraux qui existent. L'homme est lent, peu rigoureux et très intuitif. L'ordinateur est super rapide, très rigoureux et complètement con...

-- Gérard Berry, informaticien, médaille d'or du CNRS 2014, professeur au collège de France ([entretien au Nouvel Obs](https://tempsreel.nouvelobs.com/rue89/rue89-le-grand-entretien/20160826.RUE7684/gerard-berry-l-ordinateur-est-completement-con.html), 2016).


En programmation, on a besoin de faire 3 choses bien distinctes :

1. Stocker de l'information (les variables).
2. Répéter des actions (les boucles).
3. Prendre des décisions (les tests).

Une fois qu'on sait faire ces 3 choses, on peut pratiquement tout faire.


### Script

La plupart du temps, quand il y a plusieurs commandes Bash, on les écrit dans un fichier qu'on appelle un script.

#### Exécution

Pour pouvoir lancer un script, il doit être rendu exécutable. Par exemple avec `script.sh` :

```
$ chmod +x script.sh
```

Cette opération n'est à faire qu'une seule fois.

Le script est ensuité exécuté en l'appelant avec son nom, précédé de `./` si il se trouve dans le répertoire courant :

```
$ ./script.sh
```

ou du chemin complet vers le script si il se trouve dans un autre répertoire :

```
$ /chemin/complet/script.sh
```


**Remarque :** On peut parfaitement exécuter un script Bash sans qu'il ne soit exécutable. Mais il faut pour cela appeler explicitement l'interpréteur Bash :

```
$ bash script.sh
```


#### Première ligne et shebang

La première ligne du script est une ligne particulière qui débute par les caractères `#!` qu'on appelle [Shebang](https://fr.wikipedia.org/wiki/Shebang) (ou shabang) et qui contient le chemin pour trouver l'interpréteur de commandes, c'est-à-dire le *shell*. Pour Bash, on utilise :

```
#! /bin/bash
```

ou plus générique :

```
#! /usr/bin/env bash
```

La commmande précédente est celle qui permettra d'utiliser le script Bash sur le plus de systèmes d'exploitation Unix / Linux différents. C'est celle à utiliser.


À noter que l'option `-norc` permet ne pas prendre en compte le fichier de configuration `.bashrc` défini par l'utilisateur. Ce qui donne comme première ligne du script :

```
#! /usr/bin/env bash -norc
```


#### Arguments et variables prédéfinies

Dans un script Bash, tout ce qui suit le caractère `#` est ignoré et considéré comme un commentaire (sauf pour la première ligne et le shebang).

Il existe des variables prédéfinies comme :

- `$1`, `$2`... les arguments de la ligne de commande.
- `$*` tous les arguments de la ligne de commande.
- `$#` le nombre d'arguments de la ligne de commande.

Par exemple, avec le script `arg.sh` suivant :

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

Si on utilise maintenant `arg.sh` avec deux arguments (`toto` et `titi`) :

```
$ ./test.sh toto titi
Nombre d'arguments : 2
Tous les arguments : toto titi
Premier argument : toto
Deuxième argument : titi
Troisième argument :
```

On remarque que l'affichage du troisième argument, qui pourtant n'existe pas, ne pose pas de problème à Bash. Par défaut, si une variable est appelée alors qu'elle n'a pas été définie au préalable, sa valeur est une chaîne de caractères vide.

Si on utilise maintenant `arg.sh` avec trois arguments (`toto`, `titi` et `42`) :

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

On peut utiliser également les caractères `` ` `` :

```
$ nombre_femmes=`awk '/woman/' people.dat | wc -l`
$ echo ${nombre_femmes}
6
```

Toutefois, l'utilisation de `$( )` est préférable.


#### Un dernier exemple

Voici le script `var.sh` :

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

On le rend exécutable avant la première utilisation :

```
$ chmod +x var.sh
$ ls -l var.sh
-rwxrwxr-x 1 pierre pierre 301 nov.  22 15:03 var.sh*
```

Puis on l'exécute :

```
$ ./var.sh
123
Test for bash script
people.dat
User pierre is working on computer jeera
User ${USER} is working on computer ${HOSTNAME}
```

Soyez très attentifs aux différents type de guillemets utilisées (simples `'`, doubles `"` ou inversés `` ` ``).


**Astuce** : Récupérer la racine d'un nom de fichier, c'est-à-dire son nom sans l'extension, par deux méthodes.

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

Les boucles permettent de répéter plusieurs fois des actions. Voici une boucle sur une liste d'éléments explicits :

```
for fruit in pomme poire fraise
do
    echo ${fruit}
done
```

Les actions à réaliser pour chacun des éléments de la boucle sont entre les mot-clefs `do` et `done`. Ici, il n'y a qu'une action `echo ${fruit}`, c'est-à-dire l'affichage du contenu de la variable `fruit`.

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

Les tests sont très utiles pour prendre des décisions.

#### Structure

Voici un premier test simple :

```
if free -h | grep Mem
then
    echo "Calcul de la mémoire vive : OK"
fi
```

Si la commande `free -h | grep Mem` qui permet d'obtenir la quantité de mémoire vive sur la machine s'exécute correctement, alors le programme affiche `Calcul de la mémoire vive : OK`.

Les actions à exécuter lorsque le test est correct se trouvent entre les mot-clefs `then` et `fi`. On peut ajouter le mot-clef `else` pour exécuter des actions si le test n'est pas correct :

```
if free -h | grep Mem
then
    echo "Calcul de la mémoire vive : OK"
else
    echo "Calcul de la mémoire vive impossible"
fi
```

Si la commande `free -h | grep Mem` ne s'exécute pas correctement alors le programme affiche `Calcul de la mémoire vive impossible`.


#### Opérateurs de comparaison

Mais le plus souvent, pour faire un test, on réalise une ou plusieurs comparaisons. Une comparaison utilise des opérateurs.

Opérateurs pour des entiers :

| opérateur  | signification        |
|:----------:|----------------------|
| `-eq`      | égal à               |
| `-ne`      | différent de         |
| `-gt`      | supérieur à          |
| `-ge`      | supérieur ou égale à |
| `-lt`      | inférieur à          |
| `-le`      | inférieur ou égale à |


Opérateurs pour des chaînes de caractères :

| opérateur  | signification        |
|:----------:|----------------------|
| `=`        | égal à               |
| `!=`       | différent de         |
| `>`        | supérieur à          |
| `<`        | inférieur à          |
| `-z`       | vide                 |


Opérateurs pour des fichiers :

| opérateur  | signification                                         |
|:----------:|-------------------------------------------------------|
| `-e`       | le fichier existe                                     |
| `-s`       | le fichier existe et sa taille est non nulle          |
| `-r`       | le fichier existe et est lisible par l'utilisateur    |
| `-w`       | le fichier existe et est modifiable par l'utilisateur |
| `-x`       | le fichier existe et est exécutable par l'utilisateur |

L'opérateur `!` est un peu particulier car c'est l'opérateur de négation.

Voici un premier exemple avec une comparaison de nombres entiers :

```
i=4
if [[ $i -eq 10 ]]
then
    echo "i vaut $i"
else
    echo "test negatif"
fi
```

Notez bien l'utilisation des doubles crochets ouvrants et fermants (`[[ ]]`) qui encadrent la comparaison. Il est impératif de garder un espace après `[[ ` et un espace avant ` ]]`.

Voici maintenant deux autres exemples avec des comparaisons de chaînes de caractères :

```
prenom="Pierre"
if [[ ${prenom} = "Pierre" ]]
then
    echo "Accès autorisé"
else
    echo "Accès refusé"
fi
```


```
msg="hello"
if [[ ! -z ${msg} ]]
then
    echo "msg vaut ${msg}"
else
    echo "msg est nulle"
fi
```

La comparaison `-z ${msg}` vérifie si la variable `msg` est vide donc la comparaison `! -z ${msg}` vérifie que `msg` n'est **pas** vide.

Enfin, voici un dernier exemple avec une comparaison de fichier :

```
if [[ -e /bin/bash ]]
then
    echo "Shell Bash trouvé !"
fi
```

Si le fichier `/bin/bash` existe, alors on affiche le message `Shell Bash trouvé !`.


**Remarque :** Vous pourrez trouver dans des livres ou sur internet d'autres manières d'écrire des tests.

- Avec un seul crochet ouvrant et fermant `[ ]` :

```
msg="hello"
if [ ! -z ${msg} ]
then
    echo "msg vaut ${msg}"
else
    echo "msg est nulle"
fi
```

- Avec la commande Bash `test` :

```
msg="hello"
if test ! -z ${msg}
then
    echo "msg vaut ${msg}"
else
    echo "msg est nulle"
fi
```

La méthode avec les doubles crochets `[[ ]]` est celle qui est recommandée et qu'il faut utiliser avec Bash. Pour en savoir plus, vous pouvez lire :

- [Bash test and comparison functions](https://www.ibm.com/developerworks/library/l-bash-test/index.html)
- [Test Constructs](http://www.tldp.org/LDP/abs/html/testconstructs.html)


#### Combinaisons de comparaison

Enfin, on peut également combiner plusieurs comparaisons dans un même test avec des opérateurs booléens :

| opérateur  | signification |
|:----------:|---------------|
| `&&`       | et            |
| `||`       | ou            |


Exemple :

```
msg="hello"
nombre=2
if [[ ! -z ${msg} && ${nombre} -eq 2 ]]
then
    echo "tests OK"
fi
```

La combinaison des deux comparaisons `! -z ${msg}` et `${nombre} -eq 2` se fait avec l'opérateur *et* logique `&&`. Les deux comparaisons se trouvent entre les doubles crochets `[[` et `]]`.


### Boucle while

Il existe un second type de boucles, qui utilise le mot-clef `while` :

```
nombre=1
while [[ ${nombre} -le 5 ]]
do
    echo "nombre vaut ${nombre}"
    let nombre++
done
```

Si on enregistre cet exemple dans le script `while.sh` et qu'on l'exécute ensuite, on obtient :

```
$ ./while.sh
nombre vaut 1
nombre vaut 2
nombre vaut 3
nombre vaut 4
nombre vaut 5
```

La boucle s'exécute tant que la variable `nombre` est inférieure ou égale à 5.

Les boucles `while` sont un peu particulières car pour fonctionner, elles ont besoin d'une variable :

- initialisée avant la boucle (`nombre=1`) ;
- testée au niveau du mot-clef `while` (`while [[ ${nombre} -le 5 ]]`) ;
- et incrémentée (modifiée) dans le corps de la boucle, c'est-à-dire entre les mot-clefs `do` et `done` (`let nombre++`).


### Quitter un script

La commande `exit` permet de quitter un script. Voici un exemple avec le script `exit.sh` et qui en plus utilise la boucle `while` et le test avec `if` :

```
#! /usr/bin/env bash

# script pour tester la commande exit

nombre=1
while [[ ${nombre} -le 5 ]]
do
    echo "nombre vaut ${nombre}"
    if [[ ${nombre} -eq 3 ]]
    then
        echo "Au revoir"
        exit
    fi
    let nombre++
done
```

On rend exécutable ce script avec la commande `chmod`, puis on le lance :

```
$ chmod +x exit.sh
$ ./exit.sh
nombre vaut 1
nombre vaut 2
nombre vaut 3
Au revoir
```

Quand la variable `nombre` atteint la valeur 3, le test `[[ ${nombre} -eq 3 ]]` est vérifié et le script s'arrête avec la commande `exit`.


## Pour conclure sur la programmation en générale et Bash en particulier

> Programs must be written for people to read, and only incidentally for machines to execute.

-- [Harold Abelsen](https://fr.wikipedia.org/wiki/Hal_Abelson), *Structure and Interpretation of Computer Programs*, The MIT Press, 1996, préface de la première édition.

H. Abelsen est informaticien et un membre fondateur des Creatives Commons et de la Free Software Foundation.


Nous vous conseillons fortement de suivre ce principe et de rendre vos scripts Bash clairs et lisibles. Pour cela, vos programmes et scripts doivent contenir :

- des commentaires précis et informatifs ;
- des noms de variables qui ont du sens ;
- une structure et une organisation claire.


## Ressources complémentaires

[Shell Scripting Tutorial](https://www.shellscript.sh/index.html) : un tutoriel intéressant sur *shell* Bash.

[Bash scripting quirks & safety tips](https://jvns.ca/blog/2017/03/26/bash-quirks/) : bonnes pratiques sur l'écriture de scripts Bash.

[ShellCheck](https://www.shellcheck.net/) : un outil en ligne qui vérifie la qualité d'un script Bash et propose des conseils pour l'améliorer.

[Writing Scripts](http://www.datacarpentry.org/shell-genomics/05-writing-scripts/) du tutoriel [Shell Genomics](http://www.datacarpentry.org/shell-genomics/) de [Data Carpentry](http://www.datacarpentry.org/).
