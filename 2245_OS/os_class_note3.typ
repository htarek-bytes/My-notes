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
  title: "Les processus",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)


Each function call we add the function call on the stack; 

ex: we call main() -> we push that on the stack, we execute it and meet return? We pop main back.
- Global data: Before the main , we can create constants and variables.
A process can be in multiple states:
  1. ready (first state that every process is in when launched *not executed yet*): Everything needed has been loaded in RAM
  2. *executing*: When the scheduler tells it "It's your turn bruv", it gets executed we called it "the chosen one, l'elu".
  3. *waiting*: If while it is executing, it asks for data and waits for it, the scheduler removes it from CPU and puts it in *waiting status*
    - When the data arrives, it comes back to *ready*
    - pre emptive scheduler vs non pre emptive (xyzz)??
  4. *Terminated*: pretty obvious

A process never gets executed more than 3-10 ms, the CPU's frequency is insanely fast and can do a lot in such such time. It cycles to the *ready state* and *waiting*


- There is one *PCB per process*:
  - it basically contains the id card of the process:
    - The current state
    - A Program counter that points to the next instruction to be executed
    - The content of all the registers that the process is currently using
    - Informations on the planification of the CPU, scheduling pointers queue.
    - Information on memory management (allocated memory that the process uses)
    - Timing information (When it got executed, cpu time)
    - information of I/O states -> Peripherals affected to the process, list of open files it uses
* This is a C struct, literally, in C*. It is stored in the memory space reserved for the *kernel*, the *kernel is the first thing that loads when we boot our OS*

- *CPU THREADS*
  - A process can have multiple *threads*, more *threads* -> *more PC counters associated with each of em*
  - Used to maximize CPU usage, performance, responsiveness

- *The scheduler* is not a process, then what is it? it's *the kernel's code*. It if it were a program then when it chooses what to execute, what would it do with itself, also a program? *That's why the scheduler is NOT a program*, *it is always running in the reserved kernel's memory space*.
- With timers, as we've seen, process will always go in *waiting status* for the kernel to take over, thus, letting the scheduler *schedule*. It is a hard coded behaviour. 


- The scheduler *uses mutliple queues* to maintain order: xyzz
  - Process queue: a queue, where each of its element is a pointer towards the corresponding process's *PCB*

Process of schedulling a process:

Process P0 -> Queue (P0:ready) -> CPU (P0:executing) -> waiting interruption routine (either timer is over or CPU got an interrupt) P0:ready  

Process P0 -> Queue (P0:ready) -> CPU (P0:executing) -> We can create another process from a living process with the fork() command, it clones itself (same code, same behaviour etc)
  - wait() is a system call that suspends (blocks) the execution of the parent process until one of its child processes terminates, it allows the parent to synchronize its actions with the child... like waiting for a task to complete before moving on

== How are PCBs used
- When the CPU has a context switch (changes process):
  - When it switches in saves in the process's corresponding Process Control Block (PCB) a snapshot of the current state of the process. The time taken for the context switch is time losts where the CPU doesn't do anything, we want to minimize that.
- The steps for a context switch: 
  1. we stop executing Process o (status: waiting) 
  2. Save its information in its PCB
  3. load PCB of process 1 
  4. Goes from waiting to *executing*
  5. goes back to step 1

== The first process that ever gets executed: systemd
  - it acts as the init system that brings up and *maintains* the user space services (PID 1 generally in linux).
  - *systemd owns PID1, and is started DIRECTLY BY THE KERNEL when it loads*
    - use pstree to visualize.

  - when we run ls command in terminal, the terminal executes it. *Always two steps: parent clones itself, child replaces its parentt's code with its own*
    - The parent shell process uses a combination of the fork(), exec() and wait() sytem alls to manage the execution of the new program
    1. fork(): The parent shell process calls the fork() system call to create a new identical child.
      - We now have two processes, the child makes a copy of its parent's memory space.
    2. exec(): Immediately after fork(), the child process calls an exec function to replace its entire memory image and program code with that of the ls command. The process child process then begins executing the ls program from its entry point. *the orginal shell program's ocde in the child is GONE (overwritten).*
        - *WE DO NOT RETURN FROM AN EXEC*: a *NEW* program is executed, if we put another instruction under *exec*, it *makes NO SENSE* an *exec* *WIPES* the child's current 
    3. Execution: The child process runs the ls command, interacts with the OS to read directory information and prints the output to standard output
    4. wait(): Concurrently, the parent shell process calls wait() or waithpid(). The parent gets a return code that indicates how its child executed. When typing ls, the return code of the child can be access with echo \$?, in this case it should return 0 (meaning everything went well).

=== fork()
  - Creates a background process that is the clone of the current process that calls fork():
    - We now have two processes, the parent and the child.
    - The PID of the child is 0 and the PID of the parent has its own PID

== exit(); how does a child process terminates? 
Resources are for it are freed, etc.

in  ```C 
int main(){
  pid_t pid;

  pid = fork();
  pid = fork();

  printf("Bonjour");
}
```
Bonjour will be printed four times how?
1. The current process (the parent : P0) will:
  1. Clone itself once : P2 
  2. Clone itself again: P3
  3. printf()

The current p
A parent call also terminate its child process if needed with abort().
What if the parent dies before the child? In posix system, it is configured by the user. In some, the child will also terminate, in others, the child *HAS to have parent* it will be adopted by systemd, *the kernel intervenes and recognize its orphaned state and reparents it*. A zombie process is a child process that has died but its parent is not has not been noticed (either because the parent did not use wait())
=== exec(): 4 types
Only things that changes is the how we give the arguments to exec, execl\*: takes a list of arguments, the v one in an array, the e one, another table will be included as en environment variable???
the p one uses the environment variable \$PATH to search for the executable.
*The PATH environment variable is a list of directories your OS searches for executable programs when you type a command, allowing you to run apps from ANY location without typing the full path, with directories separated by ";"*(echo \$PATH)

* if a command is not in the \$PATH environment variable, you have to manually specify the path*

It is literally a *variable* that the OS uses to quickly find stuff. *A globla system variable*
*Where does it live* In POSIX systems, like fedora, it is built dynamically every time you login or start anew shell session. In POSIX systems, *PATH* is not a single file you can open but more like a search list that contais multiple lists ~./bashrc, /etc/profile /usr/bin etc.
  - execl\* 
  - execv\*
  - exec\*e 
  - exec\* p

= Type of schedulers: 
  - Long term scheduler: deals with the queue of *ready* processes
    - selects which process have to be put in the *reay queue*
    - invoked very rarely
    - Controls the degree of multiprogrammation (The number of processes in memory)
  - Short term scheduler:
    - Chooses the process that has to be executed then allocates the processor to its
    - Sometimes, the only scheduler in the whole system
    - Invoked the most, very frequently -> has to be super fast:
  - Medium term scheduler:
    - Controls de degree of multiprogrammation
    - use *swap* space and does the actual *swap*, the last not used process will generally be the one *put in the swap*
      - The scheduler *is not a system call or called by user at all*, There are *timers* that are programmed to throw interrupts after some time has elpased. Timers are access using registers that are memory in RAM. When timer reaches 0, it will trigger an *interrupt*. *Interrupts are thrown by hardware (the CPU)*

- Random but pertinent: The code is compiled in assembly, but this assembly is specific to the CPU's architecture and it is the compilator's role to translate into the language that the CPU understands.
* MAKE FLASH CARDS FOR EACH EACH CHAPTER NOTES FOR EACH CLASS*


== High level classification (abstaction): two types of processes
  - I/O Bound processes: spends really low CPU time and more tim doing I/O
  - CPU Bound: lots of computing 
