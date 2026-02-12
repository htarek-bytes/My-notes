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

- Btw, global variables are shared between all threads (no need for a shared memory space!).
- Uses less memory space than if we fork a whole process, we do not duplicate any PCB, we just keep a context of execution specific to each thread, we only need to copy theses data.
- So we save space!
- An open file for one thread is also open for the others, can be used by all.

== How to use threads?

We could create multiple threads and each give them a computing task to do. So we parallely execute stuff, this is called multithreading.

*Servers use this a lot*:

- A server, is a program that opened a socket, it's waiting for connections on certain ports.
- Imagine you have a web server running:
  - When a client connects:
    1. We created a thread to deal with the requests of that client
      - So each client has his own sub-process that takes care of him.
    2. Main program is permanently listening.


= Amdahl's law

It identifies performance gains resulting from the increase of the number of available cores to a program that contains:
  1. The sequential portion of instruction that cannot be paralelized *S*
  2. The paralelizable portion is 100% - *S*
  3. The number of processors *N* (The *cores*)

Example: if the application is 75% paralel and 25% sequential
  1. Doubling the number of cores from 1 to 2 impacts the acceleration by 1.6x
  2. Quadrupling the cores (from 1 to 4) speeds up by 2.29x

The speed up is:

$ "speed up" <= 1/(S+ ((1-S)/N)) $

As N approaches infinity, the acceleration approaches $1/S$

- The sequential portion of a program has a disproportionnate effect on the performances we get by adding more cores.

== Multicore programmation (To enable multithreading)

Multicore systems (or multi processors) put the responsability to adapt the programs to support multithreading on the programmer.

The challenges are:
1. *divide the activities* in distinct tasks and simultaneous
2. *Balance*: We need to obtain an equivalent amount of work for each task
3. *Division of data*: to avoid data collision
4. *Data dependances*: *SYNCHRONIZATION* for data dependance.

== Two types of Threads : user thread vs. kernel Thread (more used today)

- *Kernel threads*
