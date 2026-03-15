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

```C 
// Variables partagées [cite: 101]
int turn;           // Indique à qui est le tour [cite: 102, 103]
boolean flag[2];    // Indique si le processus est prêt à entrer [cite: 102, 104]

// Structure pour le processus i (j est l'autre) [cite: 105]
do {
    flag[i] = true;                 // Je suis prêt [cite: 107]
    turn = j;                       // Je cède poliment le tour à l'autre [cite: 108]
    
    // J'attends SI l'autre est prêt ET que c'est son tour [cite: 109, 110]
    while (flag[j] && turn == j);   
    
    /* SECTION CRITIQUE */          // [cite: 111]
    
    flag[i] = false;                // J'ai fini, je ne suis plus prêt [cite: 112]
    
    /* REMAINDER SECTION */         // [cite: 113]
} while (true);                     // [cite: 114]
```

```C 
// Variables partagées
boolean waiting[n]; // Initialisé à false pour les n processus
boolean lock = false;

// Structure pour le processus i
do {
    waiting[i] = true; // [cite: 199]
    key = true;        // [cite: 200]
    
    // Attente active : on tourne tant qu'on attend ET que le verrou est pris
    while (waiting[i] && key) { // [cite: 202]
        key = test_and_set(&lock); // [cite: 203]
    }
    
    waiting[i] = false; // [cite: 204]
    
    /* --- SECTION CRITIQUE --- */ // [cite: 205]
    
    // --- EXIT SECTION : La magie "Sans Famine" ---
    j = (i + 1) % n; // [cite: 206]
    
    // Chercher le prochain processus P[j] qui attend dans le cercle
    while ((j != i) && !waiting[j]) { // [cite: 208]
        j = (j + 1) % n; // [cite: 209]
    }
    

    if (j == i) { // [cite: 210]
        // Si personne d'autre n'attend, on libère le verrou
        lock = false; // [cite: 211]
    } else { // [cite: 212]
        // Sinon, on réveille le prochain processus en attente (P[j])
        // SANS libérer le verrou (on lui passe directement la clé !)
        waiting[j] = false; // 
    }
    
    /* --- REMAINDER SECTION --- */ 
    
} while (true); // [cite: 214]
```
Pourquoi c'est la version "Sans Famine" (pour tes notes) : Au lieu de relâcher le verrou dans la nature (ce qui pourrait laisser un processus rapide le reprendre éternellement), le processus qui sort de la section critique scanne les autres processus (de i+1 jusqu'à revenir à i). S'il trouve un processus qui attend, il lui donne l'accès directement en changeant son waiting[j] à false, sans même relâcher le lock. Tout le monde est garanti d'avoir son tour au maximum après N−1 passages

```C 
do {
    while(test_and_set(&lock)); // Attente active (Spinning)
    
    /* critical section */
    
    lock = false;
    
    /* remainder section */
} while (true);
```

```C 
do {
    // Tente de passer lock de 0 à 1.
    // Tant que lock != 0 (donc occupé), la boucle tourne.
    while (compare_and_swap(&lock, 0, 1) != 0); 
    
    /* critical section */
    
    lock = 0; // Libération
    
    /* remainder section */
} while (true);
```
