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
  header-titel: "T.H 202 301 89 | M.K.S 202 283 77 ",
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

#nonum($ "Soit les operateurs travaillant aux jours j, ainsi que leur couts associes " c_i x_(i,j) " avec" i = 1,...,6  "et" j = 1,...,5 $)

#nonum($ "Avec" x_(i,j) = "Le nombre d'heures travaillees par l'operateur" i "au jour" j $)

 - Les operateurs 1,2,3 et 4 doivent travailler un minimum de 8 heures par semaine. Donc:
    $ "Pour" i in {1,2,3,4} sum_(j=1)^5 x_(i,j) <= 8 "heures par semaine" $
- Les operateurs 5 et 6, eux, doivent travailler un minimum de 7 heures par semaine. Donc:
    $  "Pour" i in {5,6} sum_(j=1)^5 x_(i,j) <= 7 "heures par semaine" $
- L'ordinateur doit etre accompagne d'un operateur tous les jours de 8:00 AM a 22:00 , donc 14 heures par jour.
  - $ 14 "heures" times 5 = 70 "heures par semaine"$ 
  $ "Pour chaque jour" j in {1,2,3,4,5}: sum_(i=1)^6 x_(i,j) = 14 "heures" $

#pagebreak()
- On cherche ici a minimiser le cout total des operations en respectant toutes ces contraintes.
  - donc: $ "Min" sum_(j)^5 sum_(i)^6 c_i x_(i,j) $
#nonum($ "s.a" $)
    $ "Pour" i in {1,2,3,4} sum_(j=1)^5 x_(i,j) >= 8 "heures par semaine" $
    $  "Pour" i in {5,6} sum_(j=1)^5 x_(i,j) >= 7 "heures par semaine" $
    $ "Pour chaque jour" j in {1,2,3,4,5}: sum_(i=1)^6 x_(i,j) = 14 "heures" $
#nonum($ "Soit" H_(i,j), "le nombre maximal d'heures disponibles pour un operateur i au jour j, selon la table, alors: " $)
$ 0 <= x_(i,j) <= H_(i,j) " " forall i in {1...6}, forall j in {1...5}  $
