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

= Reminder

There are multiple system BUSes on a MOBO where data flows.

RTOS objectives differs from the usual OS -> instructions need to be executed before a set time.

in RTOS -> processes have a deadline, not necessarily as fast as possible, there is this concept of priority and deadline

In general OS's, the OS tries to predict what the CPU will need in advance.

The process doesn't have direct access to external stockage, RAM is its middleman.

CPU and its peripherals can work simulteanously (peripherals have buffers). The CPU moves the data from/to memory to local buffers.
