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


= Demo 2

Ce qui change c'est comment on explore (comment on choisit nos noeud cest tout)

Si ton but n'est pas dans les etats que tu peux atteidre -> cannot solve the problem

On applique soit BFS (Trouve toujours la solution optimale) ou DFS jusqu'a atteindre le but.

Non informed as in the machine doesn't know how close we're to the solution.


Exemple chess;

- Etat initial: All pieces are their corresponding starting position
- But: L'etat ou le roi ennemi ne peut plus bouger tout en etant en echec.
- Transitions: Fonction qui prend l'etat actuel, donc la case, et nous ramene vers une nouvelle case


On applique soit BFS ou DFS jusqu'a atteindre le but, dependamment du probleme.

BFS n'atteindra jamais un etat but (de notre vivant du moins hahaha)

DFS atteindra probablement un etat but mais vu qu'il y'a 2 joueurs, il faut aussi tenir compte du tour de l'autre joueur.

Autre ex Google maps:

- Initial: intersection la plus proche de l'utilisateur
- But: Intersection la plus proche de la destination
- Cout: Distance entre l'Intersection courante et la prochaine
- Etat: P, (Latitue,Longitude) $in I$ ou I est l'ensemble des positions des intersection


BFS ou DFS?

BFS sera bcp trop long ici, si la destination est assez loin. Rayon immense

DFS est mieux mais ne garanti pas du tout l'optimlaite de la solution.

- A\*, 

- Does it know if its getting clsoer to the goal or not ( informed vs non informed)
