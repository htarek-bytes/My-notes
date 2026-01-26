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
  title: "Informed Searched",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)


= Reminder: Reseach

== Research problem
1. States
2. Actions and their associated costs
3. Successor function
4. Initial state and goal test

== Research tree
1. Nodes : represent the plans to get to the States
2. The plans have a cost associated (somme of the cost of each individual action)

== Research algorithm

= Reminder BFS:

= Reminder DFS

== UCS: Is the the best we can do?

- Reminder: UCS eplores the contours of ascending costs? 
- *it calculates and prioritizes nodes based purely on the actual, accumulated cost from the starting node*. 
  - *It is a blind/uninformed search*, meaning it doesn't use any heuristic to guide its search direction.
- The good side: UCS is complete and optimal (can find the goal state if it exists, optimal as in, it find the shorted sequential states to choose such as the sum of their costs are the lowest we could've picked)

- The bad one: 
  - *It explores in every possible direction*, Can we bound?
  - *No information about goal location * -> Uninformed search?


= A better, more optimal solution: Use information about the goal's location

The idea is simple, we expand our candidate with a chosen node based on some metric that we define. The first one, an estimate which includes the distance to the goal.

== The general approach of informed search:
  - *Best-first search*: The nodes selected for expansion are based on an *evaluation function f(n)*
  - *f(n)* includes the estimate of distance to goal (*NEW IDEA THAT'S THE KEY compared to UCS*)

== Implementation?
  - We sort the frontier queue by this new function f(n)


Let's talk about it for a bit to make sure we've understood here. The uniform Cost Search, or UCS, estimates the *desirability* of expanding a node, using an evaluation function $f(n)$ that focuses solely on the cost incurred to reach that node, so basically the accumulated costs of each previous chosen node *from the initial node*.

For UCS, the evaluation funtion is defined as $ f(n) = g(n) $. Where $g(n)$, *represents the ACTUAL ACCUMULATED COSTS* of the path from the SOURCE NODE to our current node (n).

- The heuristic component: Unlike informed searches like A\*, UCS does *NOT* use a heuristic function $h(n)$ to estimate the remaining distance to the goal. Effectively, *UCS treats* $h(n)= 0 forall "a nodes" n$

SO UCS : it uses *global minimization* of the total costs from the start.
        - It uses a priority queue to selection the absolute cheapest known path in the entire frontier, even if that path is in a completely different branch of the search tree.
        - We minimize on the costs given by $f(n)$. We have $f(n)=g(n)$ because the current "sore", for a node is exactly equal to the "actual costs spent to get there (g)". The algorithm looks at how much it has already paid to reach a point.



in A\* search , the relationship is $f(n) = g(n) + h(n)$


Just spoke to Mr. Bang and I am spot on:

- A greedy algorithm optimizes locally: so it only uses $h(n)$, the function that gives you an estimate "distance/costs" from where you *ARE RIGHT NOW* to the next node, it is quite literally the definition of a greedy algorithm. It ommits from using the accumulated costs $g(n)$.

- An search algorithm that isn't guided by anything else than what it already knows: The current accumulated distance from a source node S to the current node n. And that function is $g(n)$. To select the next node, it uses a priority queue, often a min-heap to manage its frontier as *UCS stores all discovered but unexpanded nodes in a priority queue*. The *priority value* attributed to each node in that queue is $f(n) = g(n)$, the *node with the cheapest path from the start*. We could see it as $f(n) = g(n) + h(n) " where " h(n)=0 $

- An search algorithm that is informed, guided is one that uses both of theses function to work : $g(n) + h(n)$. It still uses a priority queue, but the formula used to *set the priority in that queue changes*. The priority is set based on $g(n) + h(n)$

#pagebreak()
= A\*, uses $f(n) = g(n) + h(n)$

- It is the most known from for best first search.
- Key idea: Avoid developping paths that are already cost heavy. Instead, prioritize first the paths with more potential. *Now, what data do we use to define that?*

A\* orders by the sum given by the function : $f(n) = g(n) + h(n)$, with a priority queue of course, a min-heap.


Before digging into it, lets define some notation to work with:

- h\*(n) us the real, actual cost computed.
- h(n) is the *estimated*, *simplified* version.

1. The relaxed costs (h): We removed the constraints. The world is easier to move through, paths are short.
2. True optimal cost (h\*): The constraints are back. The world is now harder to navigate through, paths are longer.3. Actual path found (g): This is the path our algorithm is currently exploring, which might be even *longer* than the optimal one if the algorithm is still searching.

== So... what's the logical shortcut here?
I guess we can think as constraints as *friction*, this way:
- h\*(n) is a race with annoying obstacles, uphill climbs
- g(n) is the same race on a flat, frictionless vacuum (much easier right).


The vacuum version (h), will always have a faster time (lower cost), than the real version h\*. That's why we say:
 $ h(n) <= h*(n) $

There is a computability problem here, the "perfect" solution... where our estimate is exactly the true costs (ie: $h(n) = h*(n)$) is usually impossible to compute efficiently, I guess if we could calculate h\* easily, we wouldn't need a search algorithm in the first place lmao.



We need that heuristic to keep our "big spider web" of search logic intact, we have to look at the mathematical contract A\* makes with the user. Which is that it promises you an optimal (shortest) path, and to keep it, the algorithm needs to be "optimistic" (admissible) because of how it handles the *Fringe* (The list of paths it hasn't explored yet).

If our heuristic is optimisitic, ($h<=h*$), it acts as a lower bound. 

Remember than in our AI agents context : *Optimism (admimissibility) = Completeness + Optmimality*. 
