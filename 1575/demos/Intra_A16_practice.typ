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
#pagebreak()
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

    *Decision*: The minimum ratio is 1, coming from $x_2$, we have found our output variable! :\]
  - *Output variable:* $x_2$


3. *function C:* ```python Pivot_Operation```($x_("in") = x_3 ,x_("out") = x_2$

  On this step, if I remember correctly, I have to rewrite the whole system by substituting the input variable that we've found ($x_3$) with its corresponding equation in the system

  - $x_1 = 1/2 + 3/2 x_3 - 1/2 x_4 = 1/2(3 x_3 - x_4 +1)$
  - $x_2 = 1/2 - 1/2 x_3 + 1/2 x_4 = 1/2(x_4 - x_3 + 1)$

  Why are we doing this? And what do we mean by input variable and output variable?
A common confusion that I also was a culprit of, is to think that the terms #emph([Input Variable]) and #emph([Output variable]) are the input and output of a function $f(x)$, like our objective function. No!, we are talking about the *BASE*.

  *But what's the base?* The base is simply the list of the variables that are *allowed to be active* (different than zero).
    - In our system, we have a total of 4 variables ($x_1,x_2,x_3,x_4$)
    - But this base can only contain *2 places*, why 2 and not 10501951 or 3? or 5?
      - Because the number of places is *equal to the number of constraints*.
      - In our case *we have TWO constraints* that limit our system, so we have *2 places in our base*, if we had 100 constraints, we'd have 100 places. $Z$ could have 1 BILLION variables, it doesn't matter. *What matter is the number of constraints*.

  *In linear algebra, the logic is GEOMETRIC*! Meaning that *it is the constraints that define a literal polygon*. The *Objective function* just gives us the direction.
  
  Alright, let's rewrite the system by isolating $x_3$ in the $x_2$ equation, *why not the $x_1$ equation?* Because we rewrite the *input* variable in function of the *output* variable. *Why again?* Because we saw that the $x_1$ resource can never be exhausted by $x_3$ not matter how much it uses it.

  - Alright, from the $x_2$ equation we have: 
    - $x_2 = 1/2 - 1/2 x_3 + 1/2 x_4$, let's write $x_3$ in function of $x_2$.
     $ 1/2 x_3 = 1/2 - x_2 + 1/2 x_4 $
  Multiplying by 2 gives us:

  $ x_3 = 2/2 - 2 x_2 + 2/2 x_4 $
  $ x_3 = 1 - 2 x_2 + x_4 $
  
  We didn't finish substituting it everywhere, we missed $x_1$.
  
  - $x_1 = 1/2 + 3/2 x_3 - 1/2 x_4$
  substitute the new $x_3$ equation in it.
  - $x_1 = 1/2 + 3/2[1 - 2 x_2 + x_4] - 1/2 x_4$
  - $x_1 = 1/2 + 3/2 - 3 x_2 + 3/2 x_4 - 1/2 x_4$
  - $x_1 = 4/2 - 3 x_2 + x_4 (3/2 - 1/2) $
  - $x_1 = 2 - 3x_2 + x_4$

Now in $Z = -1 - x_3$, replace $x_3$ with what we have just found.

$ Z = -1 - [1 -2 x_2 + x_4] $
$ Z = -1 -1 + 2x_2 - x_4 $
$ Z = -2 + 2x_2 - x_4 $  

  Now if we remember, $x_4$ is asleep, we set it at zero when we chose our input variable. And $x_2$ is also at zero because we have used up this resource, we use 1 $x_3$ and we found that the ratio was $1$ to exhaust $x_2$. 

  Therefore : $ Z = -2 $
  
  But, *are we done?*. Nope! What is the stopping rule if we remember correctly? Well sicnce its a minimization problem, we stop when our objective function has no negative coefficient that we can use to pull it down. In our case, $Z$'s current value is at 2 but it can still be lowered (potentially) by $x_4$ as its coefficient is $-1$ (negative).



== Second iteration
  
  First of all things, rewrite the system in *its current state*.
  
  - *Objective function*: $Z= -2 +2x_2 - x_4$
  *What are our resources now?* The resources come from the pivot step.
  We isolated $x_3$ with the equation of $x_2$ then we injected it everywhere.
  - We have found that $x_3 = 1 -2x_2 + x_4$ and that
  - $x_1 = 2 - 3x_2 + x_4$

1. *Choose the lowest most negative coefficient as our input variable*

  $Z$ is now equal to $ Z = -2 + 2x_2 - x_4 $

  Our only choice is $x_4$, so $x_("in") = x_4 $

2. *Ratio test*: finding the output variable $x_("out")$
  
  We have two equations:
  - $ x_3 = 1 -2 x_2 + x_4$
  - $ x_1 = 2 - 3x_2 + x_4$

  Since we chose our input variable to be $x_4$, $x_2$ will be set at 0, leaving us with:
  

  - $ x_3 = 1 + x_4$
  - $ x_1 = 2 + x_4$

  *We can stop here!* As we can see, *there are no negative coefficient*. Meaning that there are *no limited resources!!!*The entry variable $x_4$ is the action, it has positives coefficients in all of the equations of the base variables $x_1,x_3$, the resources. $x_4$ doesn't consume any resource, in fact it increases them. Nothing stops how far $x_4$ can be actionned. Since $x_4$ can improve the objective $Z$, we can improve $Z$ indefinitely ($-inf$). 











