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


= Understand modelisation through an example:

 « Un vignoble produit du vin blanc et du vin rouge. Chaque litre de vin blanc
apporte un profit de 5\$ et chaque litre de vin rouge 3\$. Le vignoble ne peut
produire plus de 50 litres de vin blanc et 60 litres de vin rouge. Par ailleurs,
la production totale ne peut excéder 80 litres de vin. L’objectif est de
maximiser le profit total du vignoble. »

First, what are we modeling? We are modeling are linear program that optimizes a certain problem, it sums to optimizing a linear function. In the process of modelisation of a linear program, we have three components:
  1. The set of possible actions offered to the decider. Every possible action is associated with a *decision variable* that measures the amplitude of the action that we're making.
    
    - In our example, two actions are possible, we can either produce white wine or red wine. Therefore, we should create *two decision variables* associated with theses actions. Let's instantiate the first variable $"VR"$ for "Vin rouge" and $"VB"$ for Vin blanc".
  
  2. The objective. We can express the objective of the problem under the form of mathematical functions. In our text, we can read the following passage:
    - "Chaque litre de vin blanc apporte un profit de 5\$ et chaque litre de vin rouge 3\$ (...) L'objectif est de *maximiser* le profit total du vignoble".
    - Therefore we need to maximize the following linear function: 
$ "Maximize" 5"VB" + 3"VR" $

    - The constrainst: for every optimization problem, we have constrainsts to meet, otherwise it wouldn't be an optimization problem now, would it? In our example we have *constrainst on the production of wine*.
        - Quoting: "Le vignoble ne peut produire plus de 50 litres de vin blanc et 60 litres de vin rouge.(...) la production totalte ne peut excéder 80 litres de vin"
    - We can model this through other linear functions. so: $ "VB" <= 50 $ and $ "VR" <= 60 $ 
    - Now there's also a constrainst on the maximal production of wine: $ "VB" + "VR" <= 80 $

    - *Now the hidden constrainsts*, theses are just common sense. We cannot produce a negative amount of wine, can we? (as long as you don't drink it lol). Therefore: $ "VB","VR" >= 0 $

== Writing the model

After we determined the *decision variables*, the *objective function* and the *constraints*, we need to rewrite the mathematical translation we just did in a clean way:

  - $ "Max" 5"VB" + 3"VR" $
    $ "s.a" $
    $ "VB" <= 50 $
    $ "VR" <= 60 $
    $ "VB" + "VR" <= 80 $
    $ "with" "VB","VR" >= 0 $

= A few words on linear programmation

There is the word linear, so for any linear function $f(x)$ we have :

$ f(a x + y) = a f(x) + f(y) "by definition of linearity" $

Why am I reminding this? Well because from theses properties, it means we have to keep a proportionality $space arrow space$ Multiplying one of our variables by a certain scalar $k$ would mean that we also have to mutliply its contribution in the objective function and constraints by that same scalar *k* to keep proportionality.

== Other important hypothesis:

  1. *Divisibility*: The domain in which the variabels live is continuous
  2. *Determinism*: All of data of the problem are known with *certitude*, no partial information.

*In a real problem that we want to solve, if one of theses hypothesis are not satisfied, then the linear programmation model only constitutes an APPROXIMATION of reality*.

#pagebreak()
= The simplex algorithm: Kind of like a memory manager


== The data structures (The system's state)

Our system is *always divided in two sets of variables*;

  1. *dependant variables (the base)*: The ones isolated on the left of the $ space = space $ sign, they generally have a non-zero value.
  2. *indepedant variables (Outside of the base)*: The ones on the right of the $ space = space$ sign. Their values are always *zero* in the current state.

*So... what's the goal here?* $space arrow space$: Our goal is two *swap* the variables between theses two sets until the objective that we call, $Z$ is optimal.

Therefore if $AA$ is the set of dependant variables, and $BB$ the set of indepedant ones. Then we need to *swap* elements between theses two sets $AA space arrow.l.r.double.long space BB$ until the objective $Z$ is optimal (the objective function).


== The principal loop: while(!optimal)

A loop implies; *a condition check*, then if met, *an other iteration over that loop*.
This is exactly it. At each iteration, we execute theses 3 (conceptual) functions *in order*.

1. *function A*: ```python Select_Input_variable()``` (What variable will we boost?)


If we look at the our objective function $Z$. We *are searching for what indepedant variable* (on the right of the $space = space$ sign) *has the biggest impact*.

We can divide this step depending on the goal of the problem (Maximize $Z$ or minimize $Z$):

  - *if we are MINIMIZING* $Z$ ($space Z_("min")$):
      - Look at the coefficients of the variables
      - *THE RULE*: ALWAYS choose the variable with the coefficient that is the most negative.
      - The logic behind it: if $space Z = 10 -8x space$, increasing $x$ will decrease $Z$, which is exactly what we want in a minimization case, *this is what I mean, when I say * #emph([What variable will we boost?]). The $-8$ coefficient is the heaviest weight that will have, *the heaviest impact* on $Z $
      - *stopping condition*: everytime we pass through this function (```python Select_Input_variable()``` ), if all coefficients are positive ($>=0$), you cannot pull $Z$ down anymore, $space arrow$ END OF THE PROGRAM, you are at the optimum.

  - *if we are MAXIMIZING* $Z$ ($space Z_("max")$):
      - *THE RULE*: it's literally the symmetric opposite of the minimization case; ALWAYS choose the variable with the coefficient that is the most positive.
      - The logic behind it is exactly the same: if $space Z= 10 + 5x space$, increasing $x$ will in turn increase $Z$, exactly the goal.
      - *stopping condition*: Again, symmetric. You stop when all of the coefficient (on the right of the $ space = space$ sign) are all negative, you cannot pull $Z$ up anymore.

*output*: You found the *input variable* $x_("in")$ :)

#pagebreak()
2. *Function B:* ```python Select_Output_Variable```($x_"in"$) (The ratio test)

Now that we now what variable is our input $x_("in")$, we need to find what resource will break first (as we don't have unlimited resources in the real word, AND we do not allow negative values as we cannot have -5 liters of wine). So we need to find the resource that will get exhausted first.

*How?*, we scan *ALL* of the indepedant variables equations (ligne 1 to m). For each equation that looks like : $"Var"_("dependant") = "Constant" - "Coeff"x_("in")...$
      1. *Check the coefficient*:
            - If the coefficient in front of $x_("in")$ is *positive* (ex: $+3x_("in")$) or zero: *IGNORE IT*, why? Because this variable will never limit you, it's positive so it increases as $x_("in")$ increases.

            - if the coefficient in front of $x_("in")$ is *negative* (ex: $-5x_("in")$): This is a potential limit, why? because the dependant variable, a physical resource, is dependant of it. Therefore, as the variable associated with this coefficient increases, *the resource also decreases*.
      2. *Calculation of the ratio* (The limite)
\*: Right hand side of the equation
           $ "Ratio" = ("Available resources" "(RHS)"^*)/ "Absolute value of consumption per unit (Coeff)" = "Constant"/"Coeffcient" $
          - This literally means: *How long can I keep up with this resource until its empty?*, The car example : 
              - Tires: used at 10% per lap. 100% of the tire gum left.
                  - so the ratio to know how long the resource *the tire* will last will be :
                    
                    $arrow$ $"Ratio" = 100/10 = 10 "laps" $
              - Fuel: consumes 20L per lap. There is 60L 
                  - So how many laps can we do before we do not have this resource anymore? $arrow$ $"Ratio" = (60L "available")/ (20L "per lap consumed") = 3 "laps"$

              - Engine: it heats up by 5 degrees per lap. We have 50 degrees margin of safety.

                    $arrow$ $"Ratio" = (50 "degrees of margin")/5 "degrees per lap" = 10 "laps"$ before it reaches 50 degrees.

            - It makes change to *choose the minimum ratio* right? Because it is the resource that will get exhausted the earliest, if we choose another value than the minim ratio, well it doesn't matter ; the car will stop on the minimum bottleneck resource. *The smallest ratio represents the weakest link in our system*

          - Coming back to our algorithm, if $u$ represents a physical limited resource. And for example, $u = 30 - 5x$, $u$ will be exhausted when $5x = 30$, so the ratio is $30/5=6$. At 6 unity of resource used, the resource will be exhausted. 
