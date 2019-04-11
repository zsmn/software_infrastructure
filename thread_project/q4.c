#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
#define n 2

pthread_mutex_t mutex_sum;
pthread_mutex_t mutexes[n+1];
pthread_t threads[n];

int votos[n];
int totalVotos = 0;
int votosBranco = 0;

void *thread(void *ind){
    char str[100];
    int candidatoAt;
    FILE *arq;
    sprintf(str, "%d.in", *((int *) ind));
    printf("Oi! Eu sou a thread %d e to lendo o arquivo %d\n", *((int *) ind), *((int *) ind));
    arq = fopen(str, "r");
    while(fscanf(arq, "%d", &candidatoAt) != EOF){
        pthread_mutex_lock(&mutex_sum);
        totalVotos = totalVotos + 1;
        pthread_mutex_unlock(&mutex_sum);
        
        pthread_mutex_lock(&mutexes[candidatoAt]);
        printf("Sou a thread %d e computei um voto do candidato %d\n", *((int *) ind), candidatoAt);
        if(candidatoAt > 0) votos[candidatoAt-1]++;
        else votosBranco++;
        pthread_mutex_unlock(&mutexes[candidatoAt]);
    }
}

int main(){
    long *ind[n];
    int x, bestCand = 0, bestVoto = 0;
    for(x = 0; x < n; x++){
        ind[x] = (long *) malloc(sizeof(long));
        *ind[x] = x+1;
        pthread_create(&threads[x], NULL, thread, (void *) ind[x]);
    }
    for(x = 0; x < n; x++){
        pthread_join(threads[x], NULL);
    }
    printf("Total de votos computados: %d\n", totalVotos);
    printf("Porcentagem de votos em branco: %.2lf %%\n", ((double)votosBranco/(double)totalVotos)*100.0);
    for(x = 0; x < n; x++){
        if(votos[x] > bestVoto){
            bestCand = x;
            bestVoto = votos[x];
        }
        printf("Porcentagem de votos do candidato %d: %.2lf %%\n", x+1, ((double)votos[x]/(double)totalVotos)*100.0);
    }
    printf("O candidato vencedor foi o %d com %d votos\n", bestCand+1, bestVoto);
}
