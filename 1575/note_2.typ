#import "@preview/rubber-article:0.3.1": *
#import "@preview/colorful-boxes:1.4.2": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/tablem:0.3.0": tablem, three-line-table

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

Note du cours du Mercredi 21 Janvier 2026

$ "Min" z = sum_(j=1)^(n) c_j x_j $
$ "s.a" sum_(j=1)^(n) a_j x_j = b_i $
#nonum($ "where" i =1,...,m "and" j = 1,...,n "with" x_j >= 0 $)

$ "Min" z = c_1 x_1 + c_2 x_2 + ... + c_n x_n $

$ "sa" a_11 x_1 + a_12 x_2 + ... + a_1n x_n = b_1 $
#nonum($ --- "                "--- $)
#nonum($ --- "                "--- $)
$ a_(m,1) x_1 + a_(m,2) x_2 + ... + a_(m,n) x_n = b_m $

a) Input variable
b) Output variable
  i) if $a_(i,s) <= 0 , i = 1,...,m $ . Then the problem is unbounded inferiorly (no optimal solution)
    $ x_1 + a_(i,s) x_s = b_1  arrow space x_1 = b_1 - a_(i,s) x_s $

  ii) if $a_(i,s) > 0$ for at least one index $i$, then $x_s$ is increased until one dependant variable cancels out to zero. Like:
    $ x_i = b_i - a_(i,s) x_s $
    $ "if" x_s = b_i/a_(i,s) "then" x_i = 0 space ("Ratio") $
The biggest value that $x_s$ can take is:
$ "Min" i=,1...,m "of" space { b_i/a_(i,s) "such that" a_(i,s) > 0 } $

#pagebreak()

$ #tablem[
  | * * | *$x_s$* | *$x_j$* | ** |
  | :------: | :----------: | :--------: | :-------: |
  | $x_i$   | $a_(i,s)$ | $a_(i,j)$   | $b_i$       |
  | $x_r$  | $a_(r,s)$  | $a_(r,j)$   | $b_r$      |
] $ 

$ #line(length: 5cm) $

c) Pivot 
- for the line r

$ overline(a)_(r,j) = a_(r,j)/a_(r,s) , j=1...,n $
$ overline(b)_r = b_r/a_(r,s) $

- For any ligne $i != r, space i=1,...,m $

$ overline(a)_(i,j) = a_(i,j) - a_(i,s) a_(r,j)/a_(r,s) space j = 1,..,n $
$ overline(b)_i = b_i - a_(i,s) b_r/a_(r,s) $

For the objective:
$ overline(c)_j = c_j - c_s a_(r,j)/a_(a_r,s) $
$ - overline(z)_0 = - z_0 - c_s b_r/a_(r,s) $
