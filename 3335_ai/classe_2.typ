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


= Agents to Solve problems

- An agent of problem resolution is an agent that is oriented towards a goal and decides what to do by finding sequences of *actions* that lead to desirable states.

- The computing process that he puts in practice is called *the search*
- They use atomical representations: World's states are considered as wholes. 


== Informed algorithms vs non informed lgorithmes

- Example:
  - You're on a trip to relax in romania.
    - *formulate the goal*: Go to Bucarest
    - *formulate the problem:* 
        - *states:* Being in other cities
        - *Actions*: Drive to the available cities based on where you currently are 
    - *find solution*: Find a sequence of cities that are optimal to go to Bucarest.


- *Structure of the agent*:
  1. Formulate the goal
  2. Formulate the problem:
    1. States for each possible way to be in that problem:
    2. Actions
  3. Find a solution

=== Pacman Example
1. States space:
  - The set of possible states in which the environment can be in 
2. Initial state:
  - Where the agent (pacman) starts
3. Goal test:
  - In general, one condition, sometimes the description of the state
  - Asks: *is the current state which we're also part of the set of goals* 
    - It's a question that can be answer with *True or False*.
4. Successor function: 
  - Function that chooses the Next possible state to choose with the cost associated. 

- *A search state ONLY contains the strictly necessary details to PLANIFY the next action*: so for pacman, the color of the background, the size of screen doesn't matter.
  -What matters is:
    - You position (x,y)
    - Actions: NSEW (north south east west)
    - Successor: Update only the the position
    - Goal test : (x,y) = END

- *Problem*: Eat all the white dots
  - xyz

- *PATTERN IS*: Abstract as much as you can, removing unnecessary detailts to only leave what you need to decide the next state.

== Graph state space (cannot always be constructed fully, it can be super big)

  - The state space graph is just a mathematical representaio nof the entire problem, *where each state appears ONLY once*. it includes all possible configuration and transitions, effectively serving as a map of the entire system.
  - But the search tree is an exploration of the state space *starting from an initual state*. Unlike the graph, *STATES CAN APPEAR MULTIPLE TIMES in a search tree*. Each node in the tree represents a specific *path* from the start state, rather than just the state itself.

  - Each node of the serach tree  corresponds to a *WHOLE COMPLETE PATH* in the graph of the states space.
  - We build both in demand but we try to minimize constructing it as much as possible.

- *THE VACUUM EXAMPLE*:
  - States: Dirtyness and position
  - Actions: go left,right, clean
  - Goal test: Is the room clean
  - Cost of path: total time spent

- * Robotics assemblage*:
  - Formulate the problem: 
    1. States space: The set of all possible configurations of the robot's environment, including the robot's configuration and the status and location of all parts.
      - A state could be defined by a tuple or vectures of features describing:
        - The robot's current position (coordinates, joint angles)
        - which parts have been assembled, their locations and orientations
        - Whether the robot is holding a part or tool.
    2. Initial state: The specific state where the assembly process beginds:
    3. Goal test: A function that checks whether a given state satisfies the goal condition(s), *it returns True if reached, False otherwise*
    4. Actions: The set of possible actions the robot can perform in any given state.
        - Move(location(coordinates,angles))
        - PickUP(part):
        - Place(part,location)
        - Fasten(joint)
    5. Transition model: A function that descibres the result of performing a specific action in a specific state, returning the next state (*kind of like the arrow an an automaton with finite states*)
        - Result(Current_state, action:PickUp(Part_A)) returns a new state where part_A is no longer in its initial location but is now the in the robot's gripper.
    6. Path cost: A function that assigns a numeric costs to a sequence of actions. The total path cost is typically the sum of the costs of individuals actions, makes sense.
        - For this example, Costs can defined to encourage efficient assembly:
            - Time taken for an action.
            - Energy consumption
            - Distance trveled by the robot arm, monetary costs of using a tool

= Resolution of problem by research

- Hypotheses of base research:
  - The environment is statique
  - The environment is discretizable
  - The environment is observable
  - THe actions are deterministic 

- In an continuous environment, it is smart and a good thing to sometimes abstract details to reduce it to a static environment.



```py
function Search-Tree(proble, strategy) returns solution or failure
  Initialize the seach tree using the initial proble state
  Do loop:
    if no candidate to expand the search tree then return failure
    choose a leaf node to develop based on "strategy"
    xyz

```



= The fundamental disctinction: STATE vs node

This usually is the distinction that students confuse apparently! And honestly, I AM confused lol. Let's dig into it.

Let's start with the *state*: It is a *physical configuration,setting at a certain instant of time T*. For example: the pizza is 50% eaten, the pacman is at position (5,2), the car is at 87 km/h. So it's an instant information, makes me think of a derivative, it translates an instanenous information on a continuous interval of information.

Now lets continue with the *node*: fundamentally, abstracting any details, from any subject we're talking about.What is a freaking node? A data structure, right? It is a data structure. What does a data structure do? It structures data, structures in a way that is efficient for a given problem. Nodes are part of graphs. In this specific domain, AI, we use it in an algorithm and they contain:
  - A state, but *more importantly; a PATH to GET to that STATE*; the parent of that node, the actions made, the cost associated C(x), and the depth of the node in the graph.

*Absolutely super duper muper luuuuper important KEY concept:* In a *graph of states*, one state *appears ONLY once*. In a *research tree*, one *state can appear in multiple nodes if there are multiple paths to get to it*.
  - makes me think of any MST algorithm. It will, in the end, find the most optimal path from all node to all other single nodes; from any node it that MST, if you want to get to a specific node ,say node B, you can there in multiple ways; From node A, from node V or node K. In every path, the node B will appear again because it is the final state that we desire to go at.

= The Search motor (General tree search)

All *non informed research algorithms xyz*
