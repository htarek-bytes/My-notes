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
  title: "Titre",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)


= Threads: wtf are they?

== Why do we need em?

- Well until now, we've spoken about fork() right? How we recopy the entirety of the parent PCB inside of the child, it's a full cloning process. It can kind of be costy.
  - *Sometimes, we want to divide a process into multiple threads of execution*
    - *Why?* Well because this can be really useful... particularly when there are multiple processors available in order to use paralellism. 

- So, a *new Process control block* is created after a fork. We taking the contents of the adressing space of the parent and we put it inside of a new *PCB*. It can be *heavy*.


== Processes vs. Threads

- A process, as we said, has its own *process control block* (where it stores the state of the process, registers states, files used and opened etc)

- Well , a thread is kind of a fork but we *do not create a new PCB*.

- Think of the process as a square, we divide the square into three equal rectangles. $T_1,T_2 "and" T_3$.
  - Each rectangle is a *thread*, and each thread has its own set of *registers, stack, ptr towards next instruction (PC)*


Process ABC.exe:

```
----------------------------------------
|     T1     |     T2     |     T3      |
| registers  | registers  | registers   |
|     Stack  |  Stack     |   Stack     |
|            |            |             |
-----------------------------------------
|       Code + Data + file              |
|                                       |
-----------------------------------------
```
#pagebreak()
- Instead of:

Process ABC.exe with no threads used.
```----------------------------------------
|                                       |
|                                       |
|         Registers + stack             |
|                                       |
|                                       |
-----------------------------------------
|       Code + Data + file              |
|                                       |
---------------------------------------```

Using no thread is kind of like using one single thread, where we're not using any paralellism at all since everything is inside on single big thread (the program).

== How to use threads?

We could create multiple threads and each give them a computing task to do. So we parallely execute stuff, this is called multithreading.

*Servers use this a lot*:

- A server, is a program that opened a socket, it's waiting for connections on certain ports.
- Imagine you have a web server running:
  - When a client connects:
    1. We created a thread to deal with the requests of that client
      - So each client has his own sub-process that takes care of him.
    2. Main program is permanently listening.
