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
  title: "Understanding electricity through analogies",
  authors: ("Tarik Hireche : 202 301 89" ,),
  date: datetime.today().display("[day]. [month repr:long] [year]"),
)
#set text(size: 8pt)
#nonum( $ "Rapport écrit par Tarik Hireche" $)
#set text(size: 11pt)

= Data transmission in CS & Electricity analogies

== The stuff we're moving 

An electron (The smallest particle of charge) would be analagous to a bit, the fundamental atomic unit in CS.

A coulomb is a bucket/group of electrons, analogous to a packet of bits:

- So a coulomb is just a standardized group size for electrons. Just as 1 KB = 1024 Bytes. Well a single Coulomb $= 6.24 times 10^(18) "electrons approx 6.24 quintillion electrons"$ (that's HUGE),
- Therefore a Coulomb is just a unit of quantity of electrons.

== The flow (movement of the "stuff")

In computer science, when we speak about bandwidth, example to describe the speed of our internet, we are talking about how much data gets transferred per second right?
- Ex: $1"GB/S"$ simply means 1 gigabyte of data, so 1024 MB (where 1 MB = 1024 KB & 1 KB = 1024 Bytes & 1 Byte = 8 bits)
- So bandwidth is what? A volume of information over time, in our example, the volume was 1GB over 1 second of time unit.

Well to the describe bandwidth in electricity, we talk about Amps. Amps is an abstraction of a how many Coulombs (Our bucket of fundamental particles of charge -> electrons) flow per second. We have the following equality : $ 1 "Amp" = 1 "Coulomb/second" $

It's like renaming $1 "GB/second"$ to another invented word like micmac, so we'd have:
- $1 "GB/second" = "mimac"$, but we didn't abstract that in CS since we have different levels of volumes per second (1mb/s, 1kb/s etc)

- In electricity, $ 1 "Amp" = 1 "Coulomb/second" $, so $6.24 times 10^(18) "electrons" $ flowing through a conductive element per second. We call this *current*, so current is *the number of Amps* that we have flowing through our cable, which in turn as we said, is just the number of Coulombs per second.


== What about resistance? How does that relate to computer science?

It would be analogous to latency or throttling. Basically anything that slows down the transfer of Coulombs per second (Bits per seconds in CS, basically the bitrate), so Amps, it's the concept of opposition to flow:

When latency and throttling are the things that slow down our bandwidth/bitrate, A thin cable, a resistance will get you a lower current (fewer electrons flowing per second at the lowest level of abstraction).

So a resistance will restrict/limit the flow of electric charge which can be expressed as we said, either in Amps or Coulombs per seconds (As they are equivalent measures of electric current).

To compute/know how much resistance there is for a specific amount of voltage V and a specific amount of current I (Amps). *R*, the resistance is equal to:
$ R = V/I $ 

So the resistance increases when the voltage is getting higher and higher than the current. Conceptually, voltage can be seen as a pressure (difference of potential between ground and positive, ie: if ground is set at 0 and positive at 5V, then we have $5-0 "Volts"$)


== Voltage (Volts)

It is analagous to clock speed (Hz) in a CPU, this is the "pressure" or "push". The higher the clock speed, the more instructions we can execute per second.

Clock speed (Frequency): Increases the *number of cycles per seconds*, the *pulses* are more *frequent*.

A higher frequency means that our clock *pulses* at a higher rate per second, however, since a *clock pulse is a cycle* then a higher amount of cycles per second means we can execute more instructions per seconds, now how many instructions per seconds?

Let's pick a quick example, let's say that our ADD operation takes 5 clock cycles to get executed (very unrealistic, but juste for the sake of the example):

Now let's say that we have a CPU that functions at a clock speed of 5GHz:

- That means that our clock completes a full cycle (Rising edge + Falling edge then rising edge again) *5 billion times* every single second. 
- Therefore we have, 5 billion cycles per second, now if our add instruction takes 5 cycles, how much time would our CPU take to exectute our ADD instruction?

$ (5 000 000 000 "cycles")/ (1 "second") = (5 "cycles") / (X "second(s)") $
$ X "second(s)" = (5 "cycles") / (5 000 000 000 times 1 "second(s)") $
$ X = 1000 times 10^(-12) "seconds" $
$ X = 0,0000000001 "seconds" $

We can imagine that if we had a higher clock speed, the result would be even smaller, so we can execute more instructions as the clock speed gets higher.

This is relative to the *architecture* of the cpu. In some architectures, an instruction can take 1 cycle, or 2, or 4... it is really relative to the architecture.

*The boxer analogy*: 
- The Voltage is *how hard* he punches the bag.
- The frequency is *how fast* he punches the bag.
- So the voltage can be high but with a low frequency, or, the voltage can be low but with a very high frequency.

Important point: A higher frequency has not correlation with how fast the current is flowing. Electrons are actually pretty slow, they move by a few millimiters per seconds.
*en why is the feedback of electricity almost instant? ie: turning a light, a pc, your phone screen*. 

We can think of the wire as a pipe full of marbles (electrons), when applying pressure in the pipe (Voltage), each marble (electron) pushes the next one in front of it. Because, the wire is already full of electrons, each electron pushes the next. 

This push propagates along the wire at nearly *the speed of light*, even though, individually, each electron moves slowly. *It is not the electrons moving that causes such a speed, instead it is the push that is being transmitted extremely quickly*.

*Can we infer anything about current from voltage?* -> *Absolutely NOT*
Not until we know one more variable: *Resistance* -> The *size of the pipe* to know if that high pressure will actually result in a massive flow or just a tiny littletrickle.

Remember : $ I("current")  = V("Voltage")/R("Resistance") $

For the same amount of voltage, a thicker wire (lower resistance), will allow it to carry more electrons to flow through than a thinner wire of the same material.

So a thicker, highly conductive wire will benefit more from the *same amount of voltage* than a thinner, highly conductive wire. The current,ie: the number of *Amps* will be drastically higher than in the thinner one.

So: $ V = I times R $

In electricity, the higher the voltage, the more current you can push but the number of electrons you're actually pushing *depends on the resistance* (size of the pipe).

Coming back to our examples:
- If voltage pushes current and current is the amount of Amps (Coulombs/s), then in cs the higher the clock speed (the voltage) the more instructions you can push (execute)per second.

A clock cycle, is a pulse (Rising edge), and this pulse is measure in Hz (Pulse per second). So *Cycles are simply the frequency of the Voltage*.

- In physics: Alternating Current Voltage (AC voltage), like from a wall socket, isn't a steady push -> it pushes in waves (measured in Hz), it pushes Amps at 60 hz for example, so 60 Coulombs every second are pushed through the cable. So we base ourselves on the frequency of voltage to know how much current can flow through.

- In CS: The clock speed is also not steady (Rising vs falling edge), it's also a pulse. If we say that our CPU has a clock speed of *3 GHz*, then our clock pulses 3 billion times a second. *A pulse IS a Cycle*, that means we have *3 billion cycles per second*, so we can use those to executre more instructions!

#pagebreak()
== The "Ohm's Law" of the CPU

In physics:

The current, so the number of Amps is :

$ "Current(I)" = "Voltage(V)"/"Resistance(R)" $

So in our CPU, 

$ "instructions Per Second (IPS)" = "Clock Speed (GHz)"/"# of Cycles per instructions" $

== What about Wattage? (Watts); The Power

To understand electricty we need to distinguish between *Current (Amps)* and *Power (Watts)*.

1. The Distinction : *Flow (Current) vs Impact (Power)*

- Current (Amps) is just the traffic count, we're counting how many Coulombs are flowing through our cable every second, how many electrons are actually passy by every single second.

- Power (Watts)
