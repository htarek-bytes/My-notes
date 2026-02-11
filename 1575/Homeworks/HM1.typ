#import "@preview/tablem:0.3.0": tablem, three-line-table
#import "@preview/rubber-article:0.3.1": *
#import "@preview/colorful-boxes:1.4.2": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

// Initialisation de Codly
#show: codly-init.with()

// Configuration pour éviter les débordements visuels
#show raw: set text(size: 9pt)

#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#counter(math.equation).update(())
#show selector(heading.where(level: 4)) : set heading(numbering: none)

#show: article.with(
  show-header: true,
  header-titel: "T.H 202 301 89",
  eq-numbering: "(1.1)",
  eq-chapterwise: true,
)

#maketitle(
  title: "Titre",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)


=
#tablem[
  | *Opérateur* | *Taux horaire* | *1 (L)* | *2 (Ma)* | *3 (Me)* | *4 (J)* | *5 (V)* |
  | ----------- | -------------- | ----------- | ----------- | -------------- | ----------- | -------------- |
  | 1           | 30.00\$         | 6h          | 0h          | 6h             | 0h          | 6h             |
  | 2           | 30.10\$         | 0h          | 6h          | 0h             | 6h          | 0h             |
  | 3           | 29.90\$         | 4h          | 8h          | 4h             | 0h          | 4h             |
  | 4           | 29.80\$         | 5h          | 5h          | 5h             | 0h          | 5h             |
  | 5           | 30.80\$         | 3h          | 0h          | 3h             | 8h          | 0h             |
  | 6           | 31.30\$         | 0h          | 0h          | 0h             | 6h          | 2h             |]

#nonum($ "Soit les opérateurs travaillant aux jours j, ainsi que leur couts associes " c_i x_(i,j) " avec" i = 1,...,6  "et" j = 1,...,5 $)

#nonum($ "Avec" x_(i,j) = "Le nombre d'heures travaillees par l'opérateur" i "au jour" j $)

 - Les opérateurs 1,2,3 et 4 doivent travailler un minimum de 8 heures par semaine. Donc:
    $ "Pour" i in {1,2,3,4} sum_(j=1)^5 x_(i,j) <= 8 "heures par semaine" $
- Les opérateurs 5 et 6, eux, doivent travailler un minimum de 7 heures par semaine. Donc:
    $  "Pour" i in {5,6} sum_(j=1)^5 x_(i,j) <= 7 "heures par semaine" $
- L'ordinateur doit etre accompagne d'un opérateur tous les jours de 8:00 AM a 22:00 , donc 14 heures par jour.
  - $ 14 "heures" times 5 = 70 "heures par semaine"$ 
  $ "Pour chaque jour" j in {1,2,3,4,5}: sum_(i=1)^6 x_(i,j) = 14 "heures" $

#pagebreak()
- On cherche ici a minimiser le cout total des opérations en respectant toutes ces contraintes.
  - donc: $ "Min" sum_(j)^5 sum_(i)^6 c_i x_(i,j) $
#nonum($ "s.a" $)
    $ "Pour" i in {1,2,3,4} sum_(j=1)^5 x_(i,j) >= 8 "heures par semaine" $
    $  "Pour" i in {5,6} sum_(j=1)^5 x_(i,j) >= 7 "heures par semaine" $
    $ "Pour chaque jour" j in {1,2,3,4,5}: sum_(i=1)^6 x_(i,j) = 14 "heures" $
#nonum($ "Soit" H_(i,j), "le nombre maximal d'heures disponibles pour un opérateur i au jour j, selon la table, alors: " $)
$ 0 <= x_(i,j) <= H_(i,j) " " forall i in {1...6}, forall j in {1...5}  $

#pagebreak()
= 2. Mélange optimal (Cost Minimization)

== (a) Modèle à 3 variables
Soit $x_1, x_2, x_3$ la proportion (en tonnes) d'Orge, d'Arachide et de Sésame respectivement dans une tonne de mélange.

*Objectif :* Minimiser le coût total.
$ "Min" z = 25x_1 + 41x_2 + 39x_3 $

*Contraintes :*
1. *Conservation de la masse (Le total doit faire 1 tonne)* :
   $ x_1 + x_2 + x_3 = 1 $
2. *Protéines (Minimum 22%)* :
   $ 0.12x_1 + 0.52x_2 + 0.42x_3 >= 0.22 $
3. *Graisses (Minimum 3.6%)* :
   $ 0.02x_1 + 0.02x_2 + 0.10x_3 >= 0.036 $
4. *Non-négativité* :
   $ x_1, x_2, x_3 >= 0 $

== (b) Modèle à 2 variables (Réduction de dimension)
On utilise la contrainte d'égalité pour substituer $x_3$.
Puisque $x_1 + x_2 + x_3 = 1$, alors $x_3 = 1 - x_1 - x_2$.

On remplace $x_3$ dans l'objectif et les contraintes :

*Nouvel Objectif :*
$ z &= 25x_1 + 41x_2 + 39(1 - x_1 - x_2) \
  &= 25x_1 + 41x_2 + 39 - 39x_1 - 39x_2 \
  &= -14x_1 + 2x_2 + 39 $
(Minimiser $z$ équivaut à minimiser $z' = -14x_1 + 2x_2$)

*Nouvelles Contraintes :*
1. *Protéines* :
   $ 0.12x_1 + 0.52x_2 + 0.42(1 - x_1 - x_2) >= 0.22 \
     0.12x_1 + 0.52x_2 + 0.42 - 0.42x_1 - 0.42x_2 >= 0.22 \
     -0.30x_1 + 0.10x_2 >= -0.20 \
     3x_1 - x_2 <= 2 $ (simplifié)
#pagebreak()
2. *Graisses* :
   $ 0.02x_1 + 0.02x_2 + 0.10(1 - x_1 - x_2) >= 0.036 \
     0.02x_1 + 0.02x_2 + 0.10 - 0.10x_1 - 0.10x_2 >= 0.036 \
     -0.08x_1 - 0.08x_2 >= -0.064 \
     x_1 + x_2 <= 0.8 $ (simplifié)

3. *Validité de la substitution ($x_3 >= 0$)* :
   $ 1 - x_1 - x_2 >= 0 => x_1 + x_2 <= 1 $
   (Note: Cette contrainte est redondante car $x_1 + x_2 <= 0.8$ est plus strict)

*Modèle Final Simplifié :*
$ "Min" z = -14x_1 + 2x_2 + 39 $
s.a.
$ 3x_1 - x_2 <= 2 $
$ x_1 + x_2 <= 0.8 $
$ x_1, x_2 >= 0 $

#pagebreak()

= 3. Résolution Graphique et Analyse de Sensibilité

$ "Min" z = 3x_1 - 2x_2 $
s.a.: 
#linebreak()
(1) #nonum($ x_1 + 2x_2 <= 6 $)
(2) #nonum($ -2x_1 + x_2 <= 2 $)
(3) #nonum($ x_1 - 2x_2 <= 1 $)
#linebreak()
$ x_1, x_2 >= 0 $

== (a) Résolution Graphique
// Note pour l'étudiant: Tu devras dessiner le polygone défini par les droites :
// D1: x2 = 3 - 0.5x1 (Passe par (0,3) et (6,0))
// D2: x2 = 2 + 2x1   (Passe par (0,2) et (-1,0))
// D3: x2 = -0.5 + 0.5x1 (Passe par (1,0) et (3,1))
// L'espace admissible est borné.
// Le gradient de z est (3, -2). On cherche à aller le plus loin possible dans la direction opposée (-3, 2).
// Ou plus simplement: on déplace la droite z = 3x1 - 2x2 vers le "bas/gauche" pour minimiser.

Les sommets candidats (intersections) sont :
- A (0,0) :
  - $z = 0$

- B (0,2) :  (Intersection axe x2 et D2)
  - $z = -4$

- C (0.4, 2.8) : (Intersection D1 et D2) 
  - $z = 3(0.4) - 2(2.8) = 1.2 - 5.6 = -4.4$

- D (3.5, 1.25) : (Intersection D1 et D3) 
  - $z = 3(3.5) - 2(1.25) = 10.5 - 2.5 = 8$

- E (1, 0) : (Intersection axe x1 et D3)
  - $z = 3$

*Solution optimale :* Le point C $(x_1=0.4, x_2=2.8)$ avec $z = -4.4$.

== (b) Multiple solutions optimales ($c_1$)
Pour avoir une infinité de solutions, la fonction objectif doit être parallèle à une contrainte active au point optimal (ici, D1 ou D2).
La pente de l'objectif est $m_("obj") = -c_1 / c_2 = -c_1 / (-2) = c_1 / 2$.

- Pente de (1) $x_1 + 2x_2 = 6 space arrow space 2x_2 = -x_1 + 6 space arrow m_1 space = -0.5$.
- Pente de (2) $-2x_1 + x_2 = 2 space arrow space x_2 = 2x_1 + 2 space arrow space m_2 = 2$.

Si l'objectif est parallèle à (1) :
$ c_1 / 2 = -0.5 space arrow space c_1 = -1 $
``
Si l'objectif est parallèle à (2) :
$ c_1 / 2 = 2 space arrow space c_1 = 4 $

== (c) Intervalle de stabilité pour $c_1$
Pour que la solution reste au sommet C (intersection de D1 et D2), la pente de l'objectif doit être comprise entre les pentes de D1 et D2.
$ -0.5 <= c_1 / 2 <= 2 $
$ -1 <= c_1 <= 4 $

== (d) Pas de solution optimale
    
Un problème de minimisation n'a pas de solution si l'espace est non-borné dans la direction de la décroissance de $z$.
Ici, le domaine est un polygone fermé (borné). Il y aura toujours une solution optimale finie tant que le domaine existe.
Cependant, si on cherche $c_1$ tel que le problème devient non-borné (si on retirait des contraintes), ou si la question implique un cas dégénéré :
Dans ce contexte précis (domaine borné), l'intervalle est l'ensemble vide, sauf si on considère $c_1$ rendant le problème non-réalisable (impossible), ce qui ne dépend pas de la fonction objectif.

*Réponse :* Impossible car le domaine admissible est borné. 

#pagebreak()

= 4. Algorithme du Simplexe

== (a) Min $z = -x_1 - 3x_2$
s.a. $x_1 - 2x_2 <= 4$, $-x_1 + x_2 <= 3$

Forme standard (ajout variables d'écart $e_1, e_2$):
$ z + x_1 + 3x_2 = 0 $
$ x_1 - 2x_2 + e_1 = 4 $
$ -x_1 + x_2 + e_2 = 3 $

*Tableau initial :*
#nonum($ #tablem[
  | VB  | x1 | x2 | e1 | e2 | RHS |
  | --- | -- | -- | -- | -- | --- |
  | e1  | 1  | -2 | 1  | 0  | 4   |
  | e2  | -1 | *1*| 0  | 1  | 3   |
  | z   | 1  | 3  | 0  | 0  | 0   |
] $)
Variable entrante : $x_2$ (plus grand coef positif dans ligne z pour min).
Variable sortante : $e_2$ (Ratio: $3/1 = 3$). $e_1$ ignoré car coef négatif.

*Tableau final (après pivot) :*
#nonum($#tablem[
  | VB  | x1 | x2 | e1 | e2 | RHS |
  | --- | -- | -- | -- | -- | --- |
  | e1  | -1 | 0  | 1  | 2  | 10  |
  | x2  | -1 | 1  | 0  | 1  | 3   |
  | z   | 4  | 0  | 0  | -3 | -9  |
]$)
Tous les coûts réduits des variables hors-base ($x_1$) sont positifs ($4 > 0$).
*Solution optimale unique* : $x_1=0, x_2=3, z=-9$.
Pas de solution multiple (aucun coût réduit nul pour variable hors-base).

#pagebreak()
== (b) Min $z = x_1 + 3x_2$
Mêmes contraintes.
L'objectif a des coefficients positifs $(1, 3)$. Puisque $x_1, x_2 >= 0$, la valeur minimale est atteinte immédiatement à l'origine.
*Solution optimale unique* : $x_1=0, x_2=0, z=0$.

== (c) Min $z = -2x_1 - x_2$ (Max $z' = 2x_1 + x_2$)
s.a.
1. $4x_1 + 3x_2 <= 12$
2. $4x_1 + x_2 <= 8$
3. $4x_1 + 2x_2 <= 8$

*Note système :* La contrainte (3) rend la contrainte (2) redondante ou vice-versa ?
Comparons (2) $4x_1 + x_2 <= 8$ et (3) $4x_1 + 2x_2 <= 8$.
Si (3) est respectée, $4x_1 + x_2$ est forcément $< 8$ (car $x_2 \ge 0$). Donc (3) domine (2).
On travaille avec (1) et (3).

*Tableau Initial :*
#nonum($#tablem[
  | VB  | x1 | x2 | e1 | e2 | e3 | RHS |
  | --- | -- | -- | -- | -- | -- | --- |
  | e1  | 4  | 3  | 1  | 0  | 0  | 12  |
  | e2  | 4  | 1  | 0  | 1  | 0  | 8   |
  | e3  | *4*| 2  | 0  | 0  | 1  | 8   |
  | z   | 2  | 1  | 0  | 0  | 0  | 0   |
]$)
Entrante : $x_1$ (max positif). Ratios: $12/4=3$, $8/4=2$, $8/4=2$.
On pivote sur $e_3$ (arbitraire entre e2 et e3, prenons e3).

*Tableau itération 1 :*
(Ligne pivot / 4)
#nonum($#tablem[
  | VB  | x1 | x2  | e1 | e2 | e3   | RHS |
  | --- | -- | --- | -- | -- | ---- | --- |
  | e1  | 0  | 1   | 1  | 0  | -1   | 4   |
  | e2  | 0  | -1  | 0  | 1  | -1   | 0   |
  | x1  | 1  | 0.5 | 0  | 0  | 0.25 | 2   |
  | z   | 0  | 0   | 0  | 0  | -0.5 | -4  |
]$)

*Analyse de multiplicité :*
Dans la ligne $z$, le coefficient de la variable hors-base $x_2$ est $0$.
Cela indique une *infinité de solutions optimales*.
On peut faire entrer $x_2$ dans la base sans changer la valeur de $z$.

*Solution 1 :* $x_1 = 2, x_2 = 0, z = -4$.
*Autre solution (Pivot sur x2) :*
Le ratio pour $x_2$ sur la ligne e1 est $4/1 = 4$.
Le ratio sur ligne e2 est impossible (negatif).
Pivot sur ligne e1.

#pagebreak()
*Tableau de l'alternative :*
#nonum($#tablem[
  | VB  | x1 | x2 | e1 | e2 | e3    | RHS |
  | --- | -- | -- | -- | -- | ----- | --- |
  | x2  | 0  | 1  | 1  | 0  | -1    | 4   |
  | e2  | 0  | 0  | 1  | 1  | -2    | 4   |
  | x1  | 1  | 0  | -0.5| 0 | 0.75  | 0   |
  | z   | 0  | 0  | 0  | 0  | -0.5  | -4  |
] $ )
Nouvelle solution : $x_1 = 0, x_2 = 4, z = -4$.
