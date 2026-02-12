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

#pagebreak()
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

#pagebreak()
== Create the shared memory space: POSIX Shared memory
We use shm_open (sharedMemoryOpen): take 3 parameters:
  1. A name for the shared memory space that the process *needs* to access the space.
  2. It creates the space if it doesn't exist and gives it READ/WRITE permission.
  
we use ftruncate (shared_memory variable, sizeInBytes)

Now the process can write in the shared memory with sprintf

sprintf(sharedMemoryPtr, "Writing what ever we want");


- *Advantages of using shared memory*:
  -  Less overhead (surcharge) as the kernel is not solicited, it is limited to the configuration of shared memory's region
  - less overhead bc we dont need to copy in the kernel memory space to transmit message.


- *What is a handle?* : The ticket is the handle!

  - We can think of it as a receipt number, just like the one you'd get if you buy something at a store. Now, in this case, a handle is given to a program when the program asks for a resource (for example -? Creating a new thread)

The OS creates the thread inside the vault, locks it up, and hands your program a ticket with a number on it , like \#32.

How does the OS, more precisely the kernel, deals with this?
  1. *The process table:* Our program (process) has a private lookup table in the kernel
  2. *The index:*
== Direct communication between processes
Can be unidirectional (only one can write and read, other just reads) or bidrectional.
- Normal pipes vs named pipes, we can also do it physically by implementation a physical wire 

== Indirect communication: the process's mail boxes 

Same concept as mail boxes, each process has a mailbox that we can send data into, the receiver process can then access its mailbox to read the data

== Synchronisation 

Messages transmission can either be blocking or non blocking, is the sender blocked until the receiver reads the message?

The blockage is considered as *synchrone*


*Non blockage * is considered as *asyncronous* 
#pagebreak()

== is a link unidirectional or bidirectional


== Named pipe vs ordinary non named tubes 

Named pipe are FIFO files, they are bidirectional (opposing non named pipe).

- Ordinary pipes need a parent-child relationship, for the child to have the descriptors stored in the table. 
- no fork needed here, as the file is created on the HDD, the processes can write in it and read too.
  - can be created with mkfifo TubeName. It's literally a file. We can also code it in C. We literally use the C function "mkfifo()"


== Remote Procedure Calls

- Basically calling a function that will run on another computer, the call, along with its arguments etc, will be transported across the network.
  1. The client call the Procedure
  2. Stub builds message to send across network
  3. unpacks it when received by the other computer
  4. executes and sends back return value.


== Summary on IPC (interprocess communication)

- Each process is a program in execution
- Each process has a state
- Each process is represented by its process control bloc (PCB)
- The OS *chooses* which process to put in the "ready queue" (long term scheduling) and which process in the ready queue will be executed by the CPU (one layer inside now...and it is called; short term scheduling) 

- POSIX functions that control the creation are fork(), wait(), and exec\*().

- Processes *can communicate with each others* with shared memory or message transmissions using named pipes. We can also use sockets or RPC.
      

= So what the heck is the difference between a shared memory space and a pipe?

*Named Pipes (FIFOS)* and *Shared Memory* both use the filesystem as a kind of "meeting point" (The name/path). *They both look like files, but they behave completely differently*.


== The core difference: Space vs. Time

Yep. Space vs. Time, anchor this in your head. Let's dig into it:

1. *Shared Memory (SHM)* is *Spatial*

  - *Analogy:* Your paper notebook in your backpack. You write whatever you want on it and 10 minutes later, it will still be there. You can erase it, overwrite any character you want, read it 1000 times, its a storage space.
  - *The cost:* It's freaking messy. If *two people write at the exact same time, you get gibberish!.* You need a lock (semaphore) to manage it.


2. *Pipes (tubes* are *Temporal (flow)*
  - *Analaogy:* A water Hose. Your pour water (data) into one end. It travels through and comes out the other.
  - *Crucial Constraint:* Once the water comes out (the data arrives), it's gone from the hose (pipe). *You cannot "re-read" a byte from a pipe*. You cannot "seek" (rewind) the hose. It is *strictly First-In, First-Out (FIFO)*.
  - *The benefit:* It is self-cleaning and self-synchronizing. You don't need locks as the OS ensuire the data flows smoothly.


== Ordinary vs Named Pipes

1. Ordinary Pipe : ```C pipe()```
  - *Visibility:* *Inivisible*. It has no name. It exists only in the kernel's memory.
  - *Relationship:* *Family only*. The pipe can only be used between a parent and a child process, created via a ```C fork()```.
  - *Lifespan:* *Dies automatically when the processes die.*


1. Named Pipe: ```C mkfifo```
  - *Visibility:* *Visible*. It appears asa file in our directory.
  - *Relationship:* *Public.* Any unrelated program can open it if they know the path.

  - *Lifespan:* Well it's a *public mailbox*, so it persists on the disk until we explicitely delete it unsing unlink.

== Directionality

*Named Pipes (FIFOs) are strictly unidrectional on Linux/Unix.*

If we open a named pipe, we must decide: "Am I the *Reader* or the *Writer*?". We generally cannot be both on the same pipe.

Both *Standard pipes* (anonymous) and *Named Pipes* (FIFOS) work exactly the same way regarding direction.

- *Standard Pipe:* Data goes in fd[1] (Write end) -> Data comes out fd[0] (Read end).
- *Named pipe:* Process A opens fifo as O_WRONLY -> Process B opens fifo as O_RDONLY.

- *But... Why?*
  We can think of this like a water slide right? Water, the data, flows down. If you try to climb back up (write back) on the same slide while the water is coming down, you slide (crash).
  There is no "separation" of traffic inside a single pipe. It is just a stream of bytes, *kind of like UART (Serial connection)*.

Just like *UART*, a Pipe is a *Byte Stream*, not *message stream* (symbols flowing).

Just like *UART*, we need a *Protocol*, because we don't know how to read the data. We cannot just read, we might partially read data and get corrupted information! 

We need delimiters like \n or a null terminator like \0 or a length header (sending the size first). Exactly like we'd do on an arduino or an stm32.

- *The "Bidirectional" Illusion*

We might see code where a process opens a named pipe with O_RDWR (Read/Write).

*DO NOT DO THIS!* It's a mf trap haha! 

If you write "hello" into a pipe and the ntry to read from that #emph([same]) pipe, you will likely read your *own "Hello" back!* *You are talking to yourself*

- So... *How do we actual get bidirectional communication*? (The standard way)


