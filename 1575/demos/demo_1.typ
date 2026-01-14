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


= Exo \#1 

// #image("/home/trkbytes/Projects/Self-Learning/1575/pictures/demo1_exo1.png")

Problem modelisation: We always need to understand first whether we are minimizing or maximizing.
The steps to *ALWAYS* follow:
I. Name the variables:
 1. Actions: what can you decide to do or not to do:
    - Coulee atelier 1 : $x_1$
    - coulee atelier 2: $x_2$
2. Objective: What's the goal
    - Miniize $2800 times x_1 + 2400 times x_2$
3. Constraints
- Satisfaction of demand:
    - $100x_1 + 80x_2 >= 2000$ model A
    - $250x_1 + 400x_2 => 6000$ model B 
    - $750x_1 + 400x_2 >= 12000$ model C
- The hidden constaint: non negativity, so we need to add:
    - $x_1,x_2 >= 0$

We rewrite the model and make it clear (always). Always in this form
== Modele: Min $2800x_1 + 2400x_2$
under the constraints (s.a; sujet a):
    - $100x_1 + 80x_2 >= 2000$ model A
    - $250x_1 + 400x_2 => 6000$ model B 
    - $750x_1 + 400x_2 >= 12000$ model C
    - $x_1,x_2 >= 0$

New model knowing that we have a loss of 10%:
    - $90x_1 + 72x_2 >= 1800$ model A
    - $225x_1 + 360x_2 => 5400$ model B 
    - $675x_1 + 360x_2 >= 10800$ model C
    - $x_1,x_2 >= 0$
#pagebreak()
= Exo \#2 

1. variables
  - $x_(i,j) $
    - Recolte (fraction) du secteur i durant l'annee j. 3 secteurs donc $i= 1,2,3$, 2 annees donc $j=1,2$
2. Objectif: Maximiser la Recolte
    - Maximiser $1200x_(1,1)+ 1300x_(1,2) + 1500 x_(2,1)+ 1650x_(2,2) + 800x_(3,1) + 850x_(3,2)$
3. Contraintes:
  - $arrow$ Hectares, borne superieure:
    - $300x_(1,1) + 350x_(2,1) + 200x_(3,1) <= 600 "annee 1"$
    - $300x_(1,2) + 350_x(2,2) + 200x_(3,2) <= 600 "annee 2"$ 
  - $arrow$ Borne inferieure:
    - $300x_(1,1) + 350x_(2,1) + 200x_(3,1) >= 200 "annee 1"$
    - $300x_(1,2) + 350_x(2,2) + 200x_(3,2) >= 200 "annee 2"$ 
  - $arrow$ Somme recolte/secteur
    - $x_(1,1) + x_(1,2) <= 1 "secteur 1"$
    - $x_(2,1) + x_(2,2) <= 1 "secteur 2"$
    - $x_(3,1) + x_(3,2) <= 1 "secteur 3"$
  Ne pas oublier la non negativite!!!!! ET la portee des indices!
  - $arrow$ non negativite:
    - $x_(i,j) >= 0 "avec" i = 1,2,3 "et" j = 1,2$

== Reecrire le modele apres avoir fait la modelisation

== Max $1200x_(1,1)+ 1300x_(1,2) + 1500 x_(2,1)+ 1650x_(2,2) + 800x_(3,1) + 850x_(3,2)$
s.a:

  - $300x_(1,1) + 350x_(2,1) + 200x_(3,1) <= 600 "annee 1"$
  - $300x_(1,2) + 350_x(2,2) + 200x_(3,2) <= 600 "annee 2"$ 
  - $300x_(1,1) + 350x_(2,1) + 200x_(3,1) >= 200 "annee 1"$
  - $300x_(1,2) + 350_x(2,2) + 200x_(3,2) >= 200 "annee 2"$ 
  - $x_(i,j) >= 0 "avec" i = 1,2,3 "et" j = 1,2$
