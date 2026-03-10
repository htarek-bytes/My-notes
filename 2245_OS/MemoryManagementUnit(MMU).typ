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


= The fundamental problem: The CPU generates adresses, RAM has adresses, how do we link them?

Exemple: 
- The process sees: address 346
- The RAM sees: address 14346

*What links them ->* The MMU (Memory management unit)

The MMU is the traducer. Without it, each process believe that it owns ALL of the RAM (*freaking chaos*).

CPU -> [logical adress] -> MMU -> [physical address] -> RAM

Little example to test myself:
- *" With a relocation register of 14000, what is the physical adress of the logical address 346?"*
  - *Answer:* *14000 + 346 = 14346*

== What is binding? and why do prefer it to execution?

== Swapping

== Contiguous allocation + fragmentation

FREE MEMORY : [100KB] [500KB] [200KB] [300KB]
REQUEST : 212KB

First-fit  → takes 500KB (premier assez grand)
Best-fit   → takes 300KB (le plus petit qui suffit)  
Worst-fit  → takes 500KB (le plus grand)

First-fit & Best-fit > Worst-fit in practice

- * The fragmentation is the real trap in exams! *

- Fragmentation means we have lots of small spaces everywhere (kind of like gruyere) -> This is *external fragmentation*

Process needs 600KB
OS allocates by blocks fixed at 1MB
→ 400KB wasted inside of the allocated block (Unused) 

- *Visual mnemotechnics:*
  - External = mémoire libre mais inutilisable (trop morcelée) → dehors du processus
  - internal = mémoire allouée mais gaspillée                  → DEDANS du processus

=== Another idea: Segmentation

Instead of one single block per process, we *split the program into logical segments* :
  - Code 
  - Stack 
  - Heap
  - Data ,etc

- *EACH segment has its own BASE + a LIMIT*:

logical address : \<SegID, offset>
physical address : base[SegID] + offset
Verification : offset \< limit[SegID]

If we think about it for a second, we also need to store the table itself that stores the segments (the segment table), where for each segment, it stores:
  - its base
  - its limit

SegID | Base   | Limit
  0   | 1400   | 600     ← code
  1   | 6300   | 14      ← stack
  2   | 3200   | 100     ← data 

When the cpu wants to access a segment, it looks at the segment table. We retrieve that the offset is strictly under the limit, we take the offset and we add to it its base number. 
