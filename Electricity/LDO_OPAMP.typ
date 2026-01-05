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
  title: "Why use an LDO or an Op-Amp?",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)

= 1. The LDO (Voltage Regulation)
An LDO (Low-Dropout Regulator) is an electronic component that acts like a *smart filter*. Its goal is to clean a noisy input voltage and output a stable, specific voltage (e.g., 5V).

It typically takes an unstable DC input (from a wall adapter or battery) and uses an internal mechanism to "choke" the flow, dropping the voltage to the desired level.

== 1.1 The Internal Error Amplifier
The "brain" of the LDO is an internal Op-Amp acting as an *Error Amplifier*.
- It does not amplify the power going to the device.
- It amplifies the *difference* (error) between the actual output and the desired target.

It acts as a magnifier: it takes a tiny mistake (like a $0.0001 "V"$ drop) and magnifies it into a huge reaction (like a $3 "V"$ swing). This forces the hardware—specifically the Pass Transistor—to react immediately.

#colorbox(
  title: "The Control Loop Logic",
  color: "blue",
  radius: 2pt,
  width: 100%
)[
  *Scenario: The output voltage drops slightly.*
  - *Input to Op-Amp:* "Hey, the output is $0.0001 "V"$ too low."
  - *Output of Op-Amp:* "OPEN THE VALVE NOW!!"
  
  The Op-Amp shoots a strong signal to the gate of the *MOSFET*, lowering its resistance. This allows more current to flow, which in turn elevates the voltage back to the target.
]

== 1.2 How does it know the target? (The Bandgap)
Since the input is unstable, the LDO cannot use it as a reference. Instead, it contains a "Golden Ruler" called a *Bandgap Voltage Reference* (usually $approx 1.25 "V"$). The Error Amplifier constantly compares a fraction of the output against this unshakeable internal reference to ensure accuracy.
#pagebreak()
= 2. The External Op-Amp (Power Selection)
In the Arduino power tree, there is also a standalone Op-Amp. Unlike the one inside the LDO, this one is used as a *Comparator*.

- *Function:* It compares the VIN voltage against a threshold ($6.6 "V"$).
- *Decision:* - If VIN is present, it isolates the USB power line.
  - If VIN is absent, it connects the USB power line.
  
This ensures the board never fights between two power sources, prioritizing the external wall power to save the computer's USB port.
