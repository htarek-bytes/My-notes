#import "@preview/rubber-article:0.3.1": *
#import "@preview/easytable:0.1.0": easytable,elem
#import elem: *
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
  header-titel: "T.H 202 301 89 | Power Architecture",
  eq-numbering: "(1.1)",
  eq-chapterwise: true,
)

#maketitle(
  title: "IFT-2245 | General notes",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)

= Simplex algorithm: example with two iterations

- We stop when no independant variable is negative, if not, we continue 
If there's a solution that is optimal in a linear problem, then there is a solution that has a form with some variables that are equal to zero and there is a finite number of solution.

We ask ourselves if there is an independant variable that is negative -> why?

n variables, m constrainsts ( n > m)

n - m variables fixed at 0.3
$ binom(n, n-m) = n!/(n! n-m!) $
This is an algebric representation of the simplex algorithm, but there is also a table representation.

== problem

$ "Max" 8x+6y $
- $x+3y <=30 "oursins" $
- $2x+3y<=24 "crevettes" $
- $x+3y <= 18 "huitres" $
- $x,y>=0$

$"Min" z= -8x -6y$
- $5x +3y +u = 30$
- $2x+3y + p = 24$
- $ x+3y + h = 18$
- $x,y,p,h>=0$

== First iteration 

$ u = 30 -5x -3y $
$ p = 24 -2x -3y $
$ h = 18 -x -3y $
$ #line(length: 3cm) $
$ 0 -8x -6y $

$ x = 0 ,y = 0, u = 30, p = 24, h = 18, z = 0 $

a) Input variable: $x$
- $ u=30-5x arrow u >= space arrow.l.r.double.long x <= 6 $
b) Output variable: $u$
- $ p = 24-2x arrow space p>= 0 arrow.l.r.double.long space x <= 12 $
c) pivot
$ h = 18-x space arrow h>= 0 arrow.l.r.double.long space u <= 18 $

== Second iteration

$ x = 6 - 3/5y - 1/5u $
$ p = 12- 9/5y +2/5 $
$ h = 12 - $
$ #line(length: 3cm) $
$ z = -48 -6/5 + 8/5 $
a) Input variable: $y$
b) Output variable: $x$
c) pivot


With: 
$ x = 6, y=0, u=0, p = 12, h=12, z=-48 $
$ #line(length: 5cm) $
$ x = 6 - 3/5y space arrow space x>=0 arrow.l.r.double.long space y <= 10 $
$ p = 12 - 9/5y space arrow p>=0 arrow.l.r.double.long space y<= 20/3 $
$ h = 12 - 12/5y space arrow h>=0 arrow.l.r.double.long space y<= 5 $

#pagebreak()
== Solve and see if we keep iterating

System of equation where we express x,y,y in function of u and h.

$ x = 3-1/4 u + 1/4h $
$ p = 3+1/4u +3/4h $
$ y = 5+ 1/12u - 5/12h $
$ #line(length: 3cm) $
$ z= -54 + 3/2u +1/2h $
With:
$ x=3, y=5,u=0,p=3,h=0,z=-54 $

$ x= 6 - 3/5 (5+1/12u -5/12h) - 1/5u $
$ p = 12 -9/5 (5+1/12u - 5/12h) + 2/5u $
$ z = -48 - 6/5(5 +1/12u - 5/12h)+ 8/5u $
= Table form

