#import "@preview/rubber-article:0.3.1": *
#import "@preview/colorful-boxes:1.4.2": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

// Initialisation de Codly
#show: codly-init.with()

// Configuration pour éviter les débordements visuels
#show raw: set text(size: 8pt)

#show raw.where(block:true): set text(1em /1.5)
#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#counter(math.equation).update(())
#show selector(heading.where(level: 4)) : set heading(numbering: none)

#set text(size: 8pt)

- *Producteur-Consommateur (Bounded Buffer)*
  ```C
#include <semaphore.h>
#include <unistd.h>
#include <pthread.h>
#include <stdio.h>

#define taille 3                            // Taille maximale du tampon circulaire
sem_t plein, vide, mutex;                   // Déclaration des sémaphores de synchronisation
int tampon[taille];                         // Tampon partagé (Bounded buffer)
pthread_t cons, prod;                       // Déclaration des threads
void* consommateur(void *);
void* producteur(void *);

int main(int argc, char *argv[]){
    sem_init(&plein,0,0);                   // Init plein: 0 élément au départ
    sem_init(&vide,0,taille);               // Init vide: 3 places libres au départ
    sem_init(&mutex,0,1);                   // Init mutex: 1 (accès exclusif libre)
    pthread_create(&cons, NULL, consommateur, NULL); // Création du thread consommateur
    pthread_create(&prod, NULL, producteur, NULL);   // Création du thread producteur

    pthread_join(prod,NULL);                // Le main attend la fin du producteur
    pthread_join(cons,NULL);                // Le main attend la fin du consommateur

    printf("Fin des threads\n");
    return 0;
}
void* consommateur(void *){
    int ic=0, nbcons=0, objet;              // ic = index, nbcons = compteur d'arrêts
    do{
        sem_wait(&plein);                   // Attendre qu'il y ait un item disponible (P)
        sem_wait(&mutex);                   // Verrouiller l'accès exclusif au tampon (P)
        objet=tampon[ic];                   // [SECTION CRITIQUE] Lecture de la donnée
        sem_post(&mutex);                   // Déverrouiller l'accès au tampon (V)
        sem_post(&vide);                    // Signaler qu'une place s'est libérée (V)
        ic = (ic + 1) % taille;             // Avancer l'index circulairement (0, 1, 2, 0...)
        nbcons++;                           // Incrémenter la condition de sortie
        sleep(2);                           // Simuler le temps de traitement/consommation
    }while(nbcons<=5);                      // Boucle pour consommer 6 éléments (0 à 5)
    return NULL;
}
void* producteur(void *){
    int ip=0, nbprod=0, objet=0;            // ip = index, objet = donnée à insérer
    do{
        sem_wait(&vide);                    // Attendre qu'il y ait une place libre (P)
        sem_wait(&mutex);                   // Verrouiller l'accès exclusif au tampon (P)
        tampon[ip] = objet;                 // [SECTION CRITIQUE] Écriture de la donnée
        sem_post(&mutex);                   // Déverrouiller l'accès au tampon (V)
        sem_post(&plein);                   // Signaler qu'un nouvel item est dispo (V)
        objet++;                            // Générer la donnée suivante
        nbprod++;                           // Incrémenter la condition de sortie
        ip = (ip + 1) % taille;             // Avancer l'index circulairement (0, 1, 2, 0...)
    }while(nbprod <= 5);                    // Boucle pour produire 6 éléments (0 à 5)
    return NULL;
}
```

- *Le cycle de vie d'un processus (5 states)*:
  - New -> Ready -> In execution -> Waiting (or terminated)
  - Piege QCM: Une operation E/S met un processus en attente. La fin de son temps alloue (quantum) le remet a pret.

- *context switch:* C'est le fait de save le PCG d'un processus pour sauvegarder son etat et en charger un autre
  - point cle: C'est du gaspillage pur (overhead) pour le systeme; aucun travail n'est fait pendant ce tepms

- *Les 3 ordonnanceurs*:
  - Long terme: Gere le nombre de processus en memoire (degree de multiprogrammation). Il est tres lent 
  - Court terme:  Donne le CPU a un processus, il tourne en milliseconde (tres rapide)
  - Moyen terme: fait du "swapping", (sort des processus de la memoire vers le disk (swap) pour faire de la place).

- *Les 3 regles d'une section critique valide*:
   1. Exclusion mutuelle 2. Progres (Pas de report indefini) 3. Attente limitee (pas de famine)

*Mutex vs spinlock*: Le mutex endort le processus s'il est bloque (provoque un context switch couteux). Le spink lock fait une "attente-active" (tourne en boucle). Il gaspille du CPU, mais il est genial si l'attente est ultra-courte car il evite de payer le prix d'un context switch.

#pagebreak()
- *LECTEURS - ECRIVAINS (Priorite aux lecteurs)*

  ```C 
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#define N 3                                 // Nombre de threads lecteurs et rédacteurs
#define ACCES 4                             // Nombre d'accès (itérations) par thread
int NbL = 0;                                // read_count: Nombre de lecteurs actifs
sem_t Redact;                               // rw_mutex: Accès exclusif à la ressource partagée
sem_t mutex;                                // Protège l'accès à la variable partagée NbL
void * lecteur(void *);
void * redacteur(void *);
int main(int argc, char *argv[]){
    int i;
    int numred[N] = {0,1,2};                // Identifiants à passer aux threads rédacteurs
    int numlec[N] = {0,1,2};                // Identifiants à passer aux threads lecteurs
    pthread_t red[N];                       // Tableau pour stocker les IDs des rédacteurs
    pthread_t lec[N];                       // Tableau pour stocker les IDs des lecteurs
    sem_init(&mutex,0,1);                   // Init mutex: 1 (compteur NbL libre d'accès)
    sem_init(&Redact,0,1);                  // Init rw_mutex: 1 (ressource libre d'accès)
    for(i=0; i<N; i++){
        pthread_create(&lec[i], NULL, lecteur, &(numlec[i]));   // Création du thread lecteur
        pthread_create(&red[i], NULL, redacteur, &(numred[i])); // Création du thread rédacteur
    }
    for(i=0; i<N; i++){
        pthread_join(red[i], NULL);         // Le main attend la fin du rédacteur i
        pthread_join(lec[i], NULL);         // Le main attend la fin du lecteur i
    }
    printf("Fin des thread\n");
    return 0;
}
void * lecteur(void * num){
    int i=*(int *) num;                     // Cast et récupération de l'ID du lecteur
    int x=ACCES;                            // Initialise le compteur de boucle (4 itérations)
    do{
        sem_wait(&mutex);                   // Verrouille l'accès au compteur NbL (P)
        if(!NbL)                            // Si c'est le 1er lecteur (NbL == 0)...
            sem_wait(&Redact);              // ...il barre la porte d'accès aux rédacteurs
        NbL++;                              // Incrémente le nombre de lecteurs actifs
        sem_post(&mutex);                   // Déverrouille l'accès au compteur NbL (V)
        sleep(1);                           // [SECTION CRITIQUE] Lecture concurrente permise
        sem_wait(&mutex);                   // Verrouille l'accès au compteur NbL (P)
        NbL--;                              // Décrémente le nombre de lecteurs actifs
        if(!NbL)                            // Si c'est le dernier lecteur (NbL == 0)...
            sem_post(&Redact);              // ...il débloque la porte pour les rédacteurs
        sem_post(&mutex);                   // Déverrouille l'accès au compteur NbL (V)
        sleep(1);                           // Temps d'attente hors section critique
    }while(--x);                            // Décrémente x et continue tant que > 0
}
void * redacteur(void * num){
    int i = *(int *)num;                    // Cast et récupération de l'ID du rédacteur
    int x=ACCES;                            // Initialise le compteur de boucle (4 itérations)
    do{
        sem_wait(&Redact);                  // Demande l'accès EXCLUSIF total (bloque tout)
        sleep(1);                           // [SECTION CRITIQUE] Écriture exclusive en cours
        sem_post(&Redact);                  // Libère l'accès exclusif total
    }while(--x);                            // Décrémente x et continue tant que > 0
}
```
- *fork*: Si un thread appelle fork(), est-ce que ca duplique tous les thread? Non juste l'appelant en UNIX

- *Pthreads*


 -  pthread_create(&tid, attr, fonction, arg) : Lance un thread. Note bien le 4ème argument arg : on ne peut passer qu'un seul pointeur void\*. Si tu veux passer plusieurs arguments, tu dois créer une struct et passer son pointeur.

    pthread_join(tid, &status) : C'est l'équivalent du wait() pour les processus. Le thread appelant bloque jusqu'à ce que le thread tid ait fini.

    pthread_exit(valeur) : Arrête le thread proprement.

#pagebreak()
- *Dining philosophers (version moniteur complet)*

```C 
monitor DiningPhilosophers{
    enum { THINKING, HUNGRY, EATING } state[5];
    condition self[5];
    void pickup(int i) {
        state[i] = HUNGRY;
        test(i);
        if (state[i] != EATING) {
            self[i].wait();
        }
    }
    void putdown(int i) {
        state[i] = THINKING;
        // test left and right neighbors
        test((i+4)%5);
        test((i+1)%5);
    }
    void test(int i) {
        if ((state[(i+4)%5] != EATING) && 
            (state[i] == HUNGRY) && 
            (state[(i+1)%5] != EATING) ) {
            state[i] = EATING;
            self[i].signal();
        }
    }
    initialization_code() {
        for (int i=0; i<5; i++)
            state[i] = THINKING;
    }
}
```

- *Implementation d'un moniteur via semaphores*

```C  
// VARIABLES GLOBALES (Initialisation)
semaphore mutex;    // initialisé à 1 - contrôle l'accès au moniteur
semaphore next;     // initialisé à 0 - redonne le contrôle après un signal
int next_count = 0; // nombre de processus suspendus par les conditions
wait(mutex);
body of F; // REMPLACEMENT DE CHAQUE FONCTION "F" DU MONITEUR
if (next_count > 0)
    signal(next); else signal(mutex);
// POUR CHAQUE VARIABLE DE CONDITION "x"
semaphore x_sem;  // initialisé à 0
int x_count = 0;  // nombre de processus bloqués sur x
// IMPLÉMENTATION DE L'OPÉRATION "x.wait()"
x_count++;
if (next_count > 0)
    signal(next); else signal(mutex);
wait(x_sem);
x_count--;
// IMPLÉMENTATION DE L'OPÉRATION "x.signal()"
if (x_count > 0) {
    next_count++;
    signal(x_sem);
    wait(next);
    next_count--;
} // else fait rien
```

- *Les 3 modeles de multithreading*:
  - Plusieurs a un (many to one): Tous les threads utilisateurs sont mapped sur 1 seul thread noyau. Le probleme fatal est que si un seul thread fait un appel bloquant, *tout le processus bloque (les autres threads s'arretent aussi)* car le noyau ne voit qu'un seul thread. ZZero parallelisme
  - One to one: 1 thread user = 1 thread noyau 
    - C'est le modele linux/Windows actuel. L'avantage: Du vrai parallellisme, si un thread bloque, les autres continuent. Desavantage: Creer un thread user coute plus cher car il faut aussi crer un thread noyau 
  - Many-to-Many: On multiplexe M threads user sur N threads noyau ou M>=N. C'est le plus flexible mais le plus complexe a gerer


- *La loi d'Amdahl* (calcul/QCM)

$"speedup"<= 1/(S + ((1-S)/N))$
  C'est la formule qui dit "Ca ne sert a rien d'ajouter 1000 coeurs si ton code est sequentiel".

  - S: La portion de ton code qui obligatoirement sequentielle (ne peut pas etre parallelise)
  - N: le nombre de coeurs
  - Conclusion pour l'exam: Si S est grand, ajouter des coeur (N) ne change presque rien, la vitesse maximale theorique est 1/S.


#pagebreak()
    ```C 
#define BUFFER_SIZE 1024 // Max buffer to exchange string
int main(){
    const char *name = "My_Shared_Memory_Space";
    int sharedMemFileDescriptor;
    void *ptr; //opaque ptr toward the object in shared memory 
    // Creating the actual space
    sharedMemFileDescriptor = shm_open(name,O_RDONLY, 0666);
    // Setting the size of the file that is referenced by the FileDescriptor (a number)
    // In this case, we set it to a size of 1024 bytes, so a 1 kilo byte (1 KB)
    ftruncate(sharedMemFileDescriptor, BUFFER_SIZE);
    ptr = mmap(0,BUFFER_SIZE,PROT_READ, MAP_SHARED, sharedMemFileDescriptor, 0);
    printf("%s", (char *)ptr);
    shm_unlink(name);
    return 0;
}
//sender
int main(){
    const char *name = "My_Shared_Memory_Space";
    const char *firstMessage = "This is a sequence ";
    const char *secondMessage = "of bytes.";
    int sharedMemFileDescriptor;
    void *ptr; //opaque ptr toward the object in shared memory 
    
    
    // Creating the actual space
    sharedMemFileDescriptor = shm_open(name, O_CREAT | O_RDWR, 0666);
    
    // Setting the size of the file that is referenced by the FileDescriptor (a number)
    // In this case, we set it to a size of 1024 bytes, so a 1 kilo byte (1 KB)
    ftruncate(sharedMemFileDescriptor, BUFFER_SIZE);

    ptr = mmap(0,BUFFER_SIZE,PROT_WRITE, MAP_SHARED, sharedMemFileDescriptor, 0);

    sprintf(ptr, "%s", firstMessage);
    ptr += strlen(firstMessage);
    sprintf(ptr,"%s", secondMessage);
}


```

- *Famine vs Interblocage*:
  - Famine: Un processus n'a jamais son tour, mais le reste du systeme continue de fonctionner (a cause de l'ordonnanceur)
  - Interblocage: Une attente circulaire ou TOUT est bloque de facon permanente. (2 processes waitng for each others for example)

- *Moniteur vs Semaphore*:
  - Le monteur est une "bulle" de haut niveau qui encapsule les donnees et ou un seil processus entre a la fois.
    - Difference vitale: Un signal() sur un semaphore incremente un compteur (il est memorise). Un signal() sur une variable de condition dans un moniteur, s'il ny'a personne en attente, est perdu (il ne fait rien).

- *IPC: Memoire partagee vs message passing*
   - SHM: tres rapide, pas d'overhead du noyau apres creation, mais c'est au programmeur de coder la synchronisation manuellement (risky).
    - Message passing (Ex: Pipes): Plus lent (passe par le noyau), mais la synchronisation est souvent geree automatiquement par le systeme 

- *Les tubes nommes (FIFO)*: Sont de vrai fichiers sur le disque dur. Pas besoin de relation-parent enfant pour etre used comme pour les tubes ordinaires. Nmpt quel process qui connait le nom du fichier peut s'y brancher.

#pagebreak()
