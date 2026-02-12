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
  header-titel: "T.H 202 301 89 ",
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


= Synchronization, why do we need it anyway?

Let's immediately start by a display of a problem:

1. Thread A reads 5
2. Thread B reads 5.
3. Thread A adds 1 $arrow$ writes 6.
4. Thread B adds 1 $arrow$ writes 6.

*The result is 6,but it should be 7.* One update was lost. This depends entirely on the scheduler order of execution (short time scheduler), and it is quite unpredictable.

We can fix this by locks, just like in SQL to prevent dirty reads etc.

So the idea is *Mutual exclusion:* If I write, you can't read nor write until im done. We need a piece of code that lets only one thread enter at a time.

We are going to talk about *three main tools* for Synchronization. We're going to start with the first layer, which is the hardware, then the OS primitive and finally the High-Level Abstraction.


- Level 1: The Hardware "Atomic" Instructions

This is the lowest level. The CPU provides special instructions that cannot be interrupted.
  - ```C test_and_set()```: "Check if the door is locked AND lock it" in one single, uninterruptible motion.
  - ```C compare_and_swap()```: "if the value is 0, change it to 1." Used to build lock-free data structures. It compares the current value of a memory location with an expected value and, if they are identical, updates the location with a new value.
