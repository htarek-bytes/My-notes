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
  title: "Cours #2: Note",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)


= Interface types

An OS can have many types of interfaces, for example:
- Command line (CLI)
- Graphical User interface (GUI)
- System calls: Relationship between the OS and softwares
- System program: Allows the user to interact directly with the OS, this is for commands given directly to the OS in contrast with system calls.

== CLI: More powerful that GUI

- Sometiems implemented directly in the kernel, other times by system program
- Normally called a "shell"
- Commands *are programs integrated in the shell*
- Some commands belong to the shell, while others get launched by the shell.

== GUI: Less powerful, more friendly

- We have windows, icons that represent files, directories, programs, actions, etc.
- Example of GUI on linux : KDE, GNOME, Cinnamon, etc. (mine is GNOME on fedora)

- We can have other types of GUIs, such as touch screen GUIs

== System calls interface

- It's an interface of programmation for the services provided by the others
- Generally accessible through an API, few examples : Win32 API for Windows, POSIX API for systems that are POSIX_based, including all versions of UNIX,Linux and Mac OS X
  - We also have Java API for the Java virtual machine (JVM), created everytime we launch a java program.

=== Example of a sequence of system calls:
- \$ \c\a\t \f\i\le > \n\e\w\f\i\le, cat for (concatenaion), it displays a file, the ">" symbol redirects the content that displays into a file we name "newfile".
  - Just for this call, under the hood, we have a long sequence of system calls.
  - The user types the command, the system has to accept it, it then has to look into the *inodes table* to see if the file exists.
  - The inodes table lives on the hdd in UNIX style file systems, an inode (*index node*) is a small, fixed-size data structure that describes a file. *it does not store the filename.* it stores the file's *metadata*: size,permissions,owner,timestamps, and *most importantly $arrow space$ pointers to the data block in the HDD/SSD.*

- Generally, a number is associated with each system call:
  - The system call interface maintains an index table based on theses numbers

- File managers, Peripheral managers, etc. Each manager englobes its own suit of commands for which the manager specializes in.
- Communications: create or delete connections, send receive emssages from the host or to the process name (communication socket??)
- Protection : control the access to resources, getting and defining authorizations, authorize or refuse the users access to certain resources. (think about chmod command)
- xyz

- Reminder: ALL PROCESS HAVE THEIR OWN CODES and A KERNEL CODE associated,*the mode bit changes only during a system call/ interrupt / exception*, not for every instruction. 

- Some examples system calls associated to specific managers:
  - Control of process *focus on this all the way to the intra exam, threads, process, etc.)*
  - xyz 
  - xyz
=== Transmitting parameters

- Often, more information are required than simply the identity of the system call that we want
  - The exact type and quantity of information will vary in function of the OS and the specific call
- Three methods are generally used to trasmit parameters to the OS:
  1. The simplest one : give the parameters in in the registers, in the *CPU*, a general register. 
    - In certain cases, there can be more parameters than registers
  2. Parameters are stored in a block, or a table, in memory, and the adress of the block is given in parameter in a register:
    - this is the approach taken by Linux and Solaris 
  3. Parameters given on a stacl : xyz

- Eample \#1: "Hello World"
  - "printf("Greentings)" (in user mode), printf is part of the standard C library, the standard C library makes a system call, switches in kernel mode by changing the mode bit, executes the abstracted lines of codes associated to displaying stuff on the screen and comes back to user mode by changing the bit mode again.

== Systems programs

- The system programs are programs that come with the OS, they provide an environement practical for the development and execution of programs.

- *IMPORTANT NUANCE*: is chmod a system call or a system program? -> *it is a system program but it USES a system call*
  - The difference lies here: *if you can type it in a terminal and it runs: it's a PROGRAM*
  - *A system call is a kernel entry point (low-level, privildged), accessed through an API*

=== System program
  - Runs in *User mode*, *Lives as an executable* (in a path, example : /bin/chmod,/bin/ls, etc.).
  - Can be launched from the shell
  - *Has no direct power*
  - *Uses libraries (libc)*

- General information: We're going to start with process, threads, synchronization, ordonancement (schedulling), interblocages.
