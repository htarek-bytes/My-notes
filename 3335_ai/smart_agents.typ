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
  header-titel: "T.H 202 301 89",  
  eq-numbering: "(1.1)",
  eq-chapterwise: true,
)

#maketitle(
  title: "Smart Agents",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)


= What's an agent?
An agent is any entity that's capable of perceiving its environment through sensors and acts on theses inputs through actuators (a word that describes the concrete action).

Basically, any abstraction that can perceive information through inputs and act on them is an agent;
- A computer
- A roomba vacuum robot

= Agents & environment

First, let's define keyword that are important to understand what follows.

1. Percepts: *They are not the input devices* but the *specific pieces of data*, the "sensory inputs"
- Sensors (The device): The hardware or mechanism that gathers information (camera, microphone, temperature sensors)
- Percept (The input): Single image frame, a soundwave recorded throught the microphone, a temperature reading.

= The right thing, what's the right thing from the agent's perspective?
- What does it mean to do the right thing?
  - Well, the right thing is defined from the *P* in *PEAS*:
    For each possible percept sequence, the agent has to select an action that maximizes the performance criterions.
== What is PEAS?

*PEAS* stands for Performance, Environment, Actuators, Sensors.

Before even starting the process of building the agent, before even thinking of writing any lines of codes. We have to define *constraints*, theses constraints that describe everything about our agent are abstracted by the acronym *PEAS*.

#pagebreak()
Example of the usage of *PEAS*:

A smart roomba vacuum:
1. *Performance*: Maximize the number of dust to suck, Minimize the energy consumption, being safe to be around in a house
2. *Environment*: The houses, the humans in the house, the pets, the furnitures.
3. *Actuators*: Suck air, move right left forward and backward, turn itself off or go charge after being done.
4. *Sensors*: LiDAR sensor, OpenCV camera.

- So *P* is basically a concrete set of criterions that measure performance, how is a sucessful task defined?
- Then *E* is the place at which the agent operates; a road, a hospital, a chess board
- *A* defines the concrete tools that the agent use do to modify/act on its environment
- Finally *S* represents another set of tools that the agent uses to get percepts (sensory inputs).

= The environment types; the gaming terrain!

This is where it gets interesting, the complexity of the code you're gonna write (if/else vs neuronal networks) depends entirely on the environment's properties. *Why?* Well, because the more factors the environment has, the harder it will be for the smart agent to work on it, thus complexifying its implementation.

- *Static, predictable environment* : In this case, the code will be easier to implement. A static environment is an environment that doesn't change while your process information, not when the agent uses its actuators, because in this case that would be normal, an action has effect, obviously. 
  - Examples: 
      1. A file system is a static environment, the file you're going to read/write on won't suddenly move, it has a fixed path.
      2. A chessboard, the next optimal move will vary but the board itself (the environment), won't. There will always be 64 slots to move the pieces on.
      3. Any game that goes turn by turn. 

*What is the pattern here? for a static environment?* It is the fact that the *environment won't change until you execute an action*

- *Dynamic, less predictable environment*: The environment changes while the agent is thinking. *Dynamic specifically means the world changes independently of you, the agent*. The clock is ticking, the enemies are doing something, the cars are moving, the rain is till pouring down,*whether you do something, or not*.


