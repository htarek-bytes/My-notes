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

Now, the next step is to *clean the objective function*, it is *MANDATORY*. Before starting the algorithm, we must express $Z$ only in terms of independant variables from set $B = {x_3,x_4}$ to avoid wrong reads of the actual costs of resources. So we need to substitute $x_1$ and $x_2$ into $Z$:

Let's rewrite $Z$ in function of theses variables, as they are the real resources used.

so $Z = -[1/2(3 x_3 - x_4 + 1)] - [1/2(x_4 - x_3 + 1)]$
#pagebreak()
Let's do some cleaning:

$ Z = -[ 3/2 x_3 - 1/2 x_4 + 1/2] -[-1/2 x_3  + 1/2 x_4 + 1/2] $
$ Z = -3/2 x_3 + 1/2 x_4 -1/2 + 1/2 x_3 - 1/2 x_4 - 1/2 $
$ Z = x_3(1/2 - 3/2) + x_4(1/2 - 1/2) - 1/2 - 1/2 $
$ Z = x_3(-2/2) + x_4(1/2 - 1/2) - 1 = -x_3 -1 $

So the objective function is:
$ Z = -x_3 - 1$

So in the end, our actions are $x_3 "and" x_4$, and they use resources $x_1,x_2$. 
#pagebreak()
== Starting the loop, while(!optimal)


1. *function A*: ```python Select_Input_variabe()```;
  - In this case, it is a minimization problem, therefore we need to minimize $Z$, and to minimize $Z$, *we look at the coefficients in the CLEANED $Z$ equation* $Z = -1 - x_3 + 0x_4$. We need to select the variable with *the most negative coefficient* as it is the one that will have the most impact in lowering the total costs of resources.

- Let's look at the coefficients of the independant variables:
  - for $x_3$ $arrow$ $-x_3$, the coefficient is $-1$
  - for $x_4$ $arrow$ $0x_4$, the coefficent is zero, no impact at all on the cost.

- The decision is kinda forced here. The variable $x_3$ is the only one that lowers $Z$. 

- *Therefore the input variable is*: $ x_("in") = x_3 $

2. *function B*: ```python Select_output_variable```($x_("in")$); The *ratio test*

Let's remember that our set $A$ constitutes the set of resources! Therefore $x_1$ and $x_2$ are physical, limited resources. We need to find the bound at which they will be exhausted to make sure to not go over it.

- We need to scan *all* of the dependant variables equations (so for the equations fo all elements of set $A$) and compute the ratios for each of them : $"Constant"/"coefficient"$.
    - $x_1 = 1/2 + 3/2 x_3 - 1/2 x_4 = 1/2(3 x_3 - x_4 +1)$
    - $x_2 = 1/2 - 1/2 x_3 + 1/2 x_4 = 1/2(x_4 - x_3 + 1)$

We need to find which physical resources ($x_1 "or" x_2$) will break (hit zero) first as we keep making the same action $x_3$, so as we increase $x_3$. We scan the dependant equations while assuming other independant variables, in this case $x_4$ stay at zero.

- *Analyzing first resource $x_1$* while $x_4 = 0$:
  - $x_1 = 1/2 + 3/2 x_3$
  - The coefficient of $x_3$ is $+3/2$, *positive*, therefore *it will never cancel with $1/2$, the constant*.
  - That means that the resource $x_1$ is not a bottleneck in our problem.

    $ "Ratio" = (1/2)/(3/2) = 1/2 times 2/3 = 1/3 $
- *Analyzing second resource $x_2$* while $x_4 =0$:
  - $x_2 = 1/2 - 1/2 x_3$
  - As we decide to make an action ($x_3$ increases), our resource $x_2$ that $x_3$ uses, decreases. *So there is a limit to $x_3$ on $x_2$*.
  - $"Ratio" = "Constant"/"Coefficient"$:
    
    $ "Ratio" = (1/2)/|(-1/2)| = 1$



- *Output variable:* 
