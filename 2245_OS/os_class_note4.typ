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


= 


- *exec()* remplace le code du processus forked par celui qu'on passe en argument -> plusieurs versions de exec, seule difference: Comment on passe les arguments (execv une liste, execv un tableau);
- *Variables d'environement*: I guess that, at the lowest level, an environement variable is nothing but a sequence of chars stored somewhere in user space memory once the os boots up into RAM. Did some cool digging and, it is indeed a specific memory zone: the user space, specifically on to of the stack of the process , under the form of "KEY=VALUE". The key: in maj by convention, example PATH, EDITOR. Then for the value: it is what the program is going to read examople : a path toward /user/bin, or nvim.

- At the moment where the program launches the ```bash execve``` command, the kernel copies the data of the environent from the parent. It pastes them at the very top of the allocated memory given to the new process (in its user space!). Then then kernel gets the hell out and bam, the child process can read its variable!



The memory layout would be like that:


- *HIGH MEMORY*(high addresses: *0xFF...*):
  - ```C argv```
  - ```C envp```  *environment variable* \<--------- THEY'RE HERE 
  - Stack (The stack grows towards low memory)
  - empty space (....)
  - Heap (That grows towards the top)
  - Data/BSS (Global variables)
  - Text (Binary code of the actual program)
== The parent child-bond: Heritage

A critical concept is that when a parent process, say my terminal, launches another process, say my... my C code. Well, the child inherits *its parent's environement through a COPY*. That means it is basically a clone. Although, if you modify an env variable, it wont affect its parent (my terminal).

#pagebreak()

== Good example: PATH

The PATH variable is, I guess... the most known variable? It's simply a list of directories.

- *The proglem*: When I type the ```bash ls``` command or ```bash python``` in my terminal, how does my computer know where the executable file ```bash ls```?? He cannot possibly scan through the whole HDD, that'd be crazy slow.


- *The Solution*: (```bash PATH```), it looks at the ```bash $PATH``` variable, content:
  - ```bash $/usr/local/bin:/user/bin:bin```, it can also be separated with ";", so it first looks into /usr/local/bin, nope? then /user/bin, bingo.




=  interprocess communication (IPC): faire communiquer les processus entre eux

Processes in a system can be independant or cooperative.
v- An independant process cannot affect or be affected by the execution of another process, it's isolated
- The cooperative process can affect or  be affected by other processes, including sharing data

== How do we link them?
a) We transmit *messages* through the kernel, the message will necessarily pass through the kernel memory (can generate unnecessary overhead)
b) Shared memory: A shared memory between processes A and B which they can both access (has to be setup by the user but is generally more efffective)
== Can a link be associated to more than one process
- The productor-consummer problem: *one sends, one receives*
  - It's a paradigm for cooperative processes, le productor process produces information that are consummed by the consumer process 

- *Shared memory*: Bounded-Buffer 
  - Shared data through a circular array
  
```C 
#define BUFFER_SIZE 10
typedef struct {
  ...
} item;

item buffer[BUFFER_SIZE];
int in = 0;
int out = 0;
```

- The writer, producter's code to write messages:

```C 
item next_produced;
while(true) {
  while ((in + 1) % BUFFER_SIZE == out); // As long as the next case is the out parameter, we didn't read the item yet

  buffer[in] = next_produced;
  in = (in + 1) % BUFFER_SIZE;
}
```

Let a table with 10 cases. At first both in and out point to index 0.
We write a message to the case where in points to (so, zero), now in advances by one and points to index 1.
out now still points to index 0. We keep writing with in until it points to the next free case, the index 9.
Since it's a circular array, (in + 1 ) % BUFFER_SIZE gives us zero, but this is equal to out. so we cannot do anything, the array is full. 

if in != out, we read the case at which out points to. we increase out by one.

```C 
item next_consumed;
while (true) {
  while (in == out); //do nothing
  next_consumed = buffer[ou];
  out = (out + 1) % BUFFER_SIZE; // Consume the item in the next command
}
```
- *Combien de items peut etre dans le buffer*? A: BUFFER_SIZE - 1, c'est juste l'algorithme
- *Access simultane? - Beaucoup d'issue de synchronisation?*

== Create the shared memory space: POSIX Shared memory
We use shm_open (sharedMemoryOpen): take 3 parameters:
  1. A name for the shared memory space that the process need to access it 
  2. Il le creer s'il n'existe pas et donne permission de read write.
  
we use ftruncate (shared_memory variable, sizeInBytes)

Now the process can write in the shared memory with sprintf

sprintf(sharedMemoryPtr, "Writing what ever we want");


- *Advantages of using shared memory*:
  -  Less overhead (surcharge) as the kernel is not solicited, it is limited to the configuration of shared memory's region
  - less overhead bc we dont need to copy in the kernel memory space to transmit message.
== Direct communication between processes
Can be unidirectional (only one can write and read, other just reads) or bidrectional.
- Normal tubes vs named tubes, we can also do it physically by implementation a physical wire 

== Indirect communication: the process's mail boxes 

Same concept as mail boxes, each process has a mailbox that we can send data into, the receiver process can then access its mailbox to read the data

== Synchronisation 

Messages transmission can either be blocking or non blocking, is the sender blocked until the receiver reads the message?

The blockage is considered as *synchrone*:


*Non blockage * is considered as *asyncronous* 
== is a link unidirectional or bidirectional
