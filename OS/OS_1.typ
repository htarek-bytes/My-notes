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
  header-titel: "T.H 202 301 89 | Power Architecture",
  eq-numbering: "(1.1)",
  eq-chapterwise: true,
)

#maketitle(
  title: "IFT-2245 | General notes",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)

= The foundation : Hardware

Before even jumping into OS theory, one should understand what is it built upon, right?

By default, a computer is mainly a CPU, the central processing unit. It is the brains of the computer, it sequentially fetches, decodes and executes instructions... until it shuts down.

The CPU lives in it's own bubble (RAM + the CPU itself).

== The problem : the outside world 

=== a full hands on computer needs to interact with external stuff, the peripherals 

We're talking about your keyboard, your hard disk drive, SSD, network etc.

=== The speed choc: The lambo against the snail

The CPU is blazingly fast, we're talking nanoseconds fast. In fact, it is so fast that it has to wait for its inside and outside neighbours.

Its outside neighbours (the peripherals), are extremely slow compared to the CPU (milliseconds or even seconds).

Therefore, if the CPU needs to read a specific data on your HDD to continue its computing process, there's a huge, HUGE temporal gap between the two.

=== A solution but a bad one: Polling

Before the invention of the concept of interruptions, we literally used a super loop:

An always true loop that gets triggered when the CPU orders the disk to read a specific data. After the order, the CPU would literally ask in a loop :
- "Is it over?" -> Nope.
- "Is it over?" -> Nope.
- "Is it over?" -> Nope.
- "Is it over?" -> Nope.

=== It is absolutely catastrophic. Why?

Because, the most precious resource in a computer is the CPU's time. With active polling, the whole brain is freaking stuck waiting for the snail to finish its walk. Isn't that a huge waste of potential? *The whole system is frozen, waiting*

=== A solution that revolutionized computers: Interruption mecanisms

In order to free our blazing fast lambo of this constant surveillance, engineers added a physical component, *a literal wire, that goes from the CPU*, to the device controler.

So *interruption* is *NOT a software concept*, it is *material, physically implemented*. It can be seen as an electric bell at the CPU's door, that rings to get its attention when required.

== How do interrupts work?

1. The launch:
- The CPU goes and orders the disk controler: "I need this file, search it for me while I do something else while you do it".
2. The freedom! (yay):
- The CPU can finally explore its full potential, that is, being blazingly fast.
- So it goes back to doing some CPU stuff; computing for another process, executing a thread, displaying an graphical interface, etc
- *It does NOT surveil the disk*
3. The event:
- The snail finally finished its freaking walk. So the snails manager, the disks controler *sends an electrical current that flows through the interrupt wire*.
4. The lambo's reaction:
- The CPU receives the electrical signal, some coulombs flowing being pushed by voltage in the wire.
- Materially,


Let's get more into interruptions:

- An interruption causes a transfert of control to the what ever thing calls it , generally through an interruption vector, by vector, we mean a table that has for every routine; its corresponding address, that contains the addresses of the different routine services.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

An interruption vector can be simply abstracted as a table of 2 columns one with the number of the perppherals and the corresponding code.

- The CPU saves the adress of the interrupted instructions to come back to it after being done with the interrupt.
- The *whole* OS is guided by interruptions.

- How the CPU deals with interruptions
- The OS preserves the anterior state before an interruption to come back to it later.

- *Table of peripherals state*: Contains the type, address and state of each peripherals. So the CPU maintains this table, as we could have simultaneaous interruptions.


== I/O system

- One of the OS's objective, is to abstract the material from its user (you don't need to know that your ram is 3200 MHz DDR4 to open google chrome).

- The I/O system has to:

xyz

== Storage
- Disk's surface is divided in pists, where the pists themselves are divided in sectors, cylinders ?
- an arm moves mechanically to the right sector to read/write data.

- When creating a file and putting lots of data, how does the CPU deal with injecting that data when adjacent data around the file itself are unrelated.

- Let's look into disks algorithms that optimizes time:
xyz

Pourquoi on a l'impression que certains programmes doivent se "reveiller" lorsqu'on n'a pas utise un programme depuis un bout de temps par exemple, le programme est ouvert mais on ne l'utilise plus du tout, on ouvre un autre programme mais la ram est pleine, alors on a ce qu'on appelle la virtualisation memoire, on utilise un espace dans le HDD qu'on appelle SWAP, la cle pour comprendre ici est la ram & HDD -> On prend literallement une image de la ram et onon the HDD there is something called a swap, the os will take the memory spaces that you didn't use for a long time and put them in there, when alt 

En user mode, lorsqu'on execute un programme, le processus (dans le programme) demarre une minuterie (qui dure quelques ms), apres la fin de cette minuterie, le noyau prend le controle pour s'assurer que tout va bien (ex: eviter une boucle infinie), si le code du processus est flawed, une minuterie sauve l'os, elle lui redonne le controle pour faire fonctionner le systeme.


Ex:

User process executing -> calls system call -> execute system call (mode bit = 0) -> execute system all, done (mode bit =1, usermode) -> return from system call
It is invisible to the user, everytime your screen gets updated there is literally some code from the kernel mode to interact with the physical components (screen in this case)

fun fact, the majority of computers in the world are running on linux because there are something that windows can simply not do. As a matter of fact, all 500 super computers in the world run on linux.

== OS and the services it offers

THe os offers services:
1. User interface: GUI,batch,command line
2. Environment of execution for programmes
3. I/O services
4. Folder and file gestion
5. Error detections
6. Accounting (audit en francais), garde des logs de tout ce qui se passe sur l'ordi. (generally disabled, always enabled in computer for finance: to monitor a theft for example)
