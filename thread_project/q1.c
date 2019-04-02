#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>

#define n 10

int global_counter = 0;

pthread_t threads[n];
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

long *taskids[n];

void *inc(void *threadid){
    int *tid = (int *)threadid;
    while(global_counter < 1e6){
        pthread_mutex_lock(&mutex);
        // caso ao setar a prioridade pra essa thread eu ja
        // tenha alcançado o valor maximo, desbloquei o meu
        // mutex e encerro a thread.
        if(global_counter >= 1e6){
            pthread_mutex_unlock(&mutex);
            break;
        }
        
        // caso contrario, incremento e vejo se consegui chegar
        // no valor maximo, printo e libero o mutex, dessa forma
        // garanto que as proximas threads também irão parar
        global_counter++;
        if(global_counter >= 1e6){
            printf("Thread %d has reached the goal! =D", *tid);
        }
        pthread_mutex_unlock(&mutex);
    }
}

int main(){
    int x;
    /* criação das threads */
    for(x = 0; x < n; x++){
        taskids[x] = (long *) malloc(sizeof(long));
        *taskids[x] = x;
        pthread_create(&threads[x], NULL, inc, (void *) taskids[x]);
    }
    /* dando join nas threads */
    for(x = 0; x < n; x++){
        pthread_join(threads[x], NULL);
    }

    pthread_exit(NULL);
}
