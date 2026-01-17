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
  title: "Intra Automne 2016 IFT-1575 pratique",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)


= Question 3. (15 points)

Solve the following problem with the simplex algorithm:

$ "Min" z = -x_1 - x_2 $
s.a 

$ x_1 + 0 x_2 - 3/2 x_3 + 1/2 x_4 = 1/2 $
$ 0 x_1 + x_2 + 1/2 x_3 - 1/2 x_4 = 1/2 $
$ x_1,x_2,x_3,x_4 >= 0 $

We can see that $Z$, the function to minimize is in function of two variables:
  - $x_1$ and $x_2$. 
Therefore, locally, theses variables are independant to $Z$ but they are dependant in their own equations. Meaning:
  - In this case equation, $x_1 + 0 x_2 - 3/2 x_3 + 1/2 x_4 = 1/2 $, our dependant variable $arrow$  $x_1$:
      
    - is implictely in function of $x_2$,$x_3$ and $x_4$. Rewriting it in function of the independant variables, gives us:
      - $x_1 = 1/2 + 3/2 x_3 - 1/2 x_4 = 1/2(3 x_3 - x_4 +1)$
  - As for our second dependant variable, $x_2$, we can also rewrite it in function of the others independant variables:
      - $x_2 = 1/2 - 1/2 x_3 + 1/2 x_4 = 1/2(x_4 - x_3 + 1)$

Alright, we have rewritten our equation in a more meaningful way. We can now clearly see our two sets of variables. The first one, let's call $A$, the set of dependant variables and the second one $B$, the set of independant variables are:

$A = {x_1, x_2}$, $B = {x_3,x_4}$ 

We will be swapping the variables between theses two sets until the objective $Z$ is optimal.

#pagebreak()
== Starting the loop, while(!optimal)

1. *function A*: ```python Select_Input_variabe()```;
  - In this case, it is a minimization problem, therefore we need to minimize $Z$, and to minimize $Z$, we need to select the *independant* variable that builds our *dependant* variables to make them as small as possible as $Z$, the objective function, is in function of the variables in the set $A$.

  - Okay, let's rewrite our two functions that characterize our dependant variables:
      - $x_1 = 1/2 + 3/2 x_3 - 1/2 x_4 = 1/2(3 x_3 - x_4 +1)$
      - $x_2 = 1/2 - 1/2 x_3 + 1/2 x_4 = 1/2(x_4 - x_3 + 1)$

  - Now, since we have to *minimize* $Z$, let's pick the independant variable that will have the most impact for pulling down $Z$'s value.
      - for $x_1$: the smallest coefficient is the one associated to $x_4$ and it is $-1/2$.
      - for $x_2$: the smallest coefficient is the one associated to $x_3$ and it is also $-1/2$

  - So we need to pick: $"Min"(-1/2 x_3, -1/2 x_4)$. Since both have the same coefficient, either will do. Let's pick $x_3$.
