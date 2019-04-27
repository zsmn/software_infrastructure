#include<bits/stdc++.h>
#include<pthread.h>
#define lim 5
#define qt_consumidores 5
#define qt_produtores 5
using namespace std;

pthread_mutex_t mutexzim = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t empty = PTHREAD_COND_INITIALIZER;
pthread_cond_t filler = PTHREAD_COND_INITIALIZER;
pthread_t threads_consumidoras[qt_consumidores];
pthread_t threads_produtoras[qt_produtores];

typedef struct elem{
    int value;
    struct elem *prox;
} elemento;

typedef struct blockingQueue{
    unsigned int sizeBuffer, statusBuffer;
    elemento *head, *last;
} blockingQueue;

typedef struct arguments{
    unsigned int id;
    blockingQueue *queue;
} args;

blockingQueue *newBlockingQueue(unsigned int sizeBuffer){
    blockingQueue *queue = new blockingQueue;
    queue->sizeBuffer = sizeBuffer;
    queue->statusBuffer = 0;
    queue->head = NULL;
    queue->last = NULL;

    return queue;
}

void putBlockingQueue(blockingQueue *Q, int newValue){
    pthread_mutex_lock(&mutexzim);
    if(Q->statusBuffer == Q->sizeBuffer){
        pthread_cond_wait(&empty, &mutexzim);
    }

    if(Q->statusBuffer < Q->sizeBuffer){
        // generating new element
        elemento *newElem = new elemento;
        newElem->value = newValue;
        newElem->prox = NULL;
        // adjusting the last element
        if(Q->statusBuffer == 0){
            Q->head = newElem;
            Q->last = newElem;
        }else{
            Q->last->prox = newElem;
            Q->last = newElem;
        }
        // adding in statusBufer and calling consumers
        Q->statusBuffer = Q->statusBuffer + 1;
    }

    if(Q->statusBuffer == 1) pthread_cond_broadcast(&filler);
    pthread_mutex_unlock(&mutexzim);

}

int takeBlockingQueue(blockingQueue *Q){
    int result = -1e9;
    pthread_mutex_lock(&mutexzim);
    if(Q->statusBuffer == 0) pthread_cond_wait(&filler, &mutexzim);
    
    if(Q->statusBuffer > 0){
        // getting the first element value
        result = Q->head->value;
        // free the element and set to te next one
        elemento *auxElem = new elemento;
        auxElem = Q->head;
        Q->head = Q->head->prox;
        free(auxElem);
        // sub in the statusBuffer and calling producers
        Q->statusBuffer = Q->statusBuffer - 1;
    }

    if(Q->statusBuffer == Q->sizeBuffer - 1) pthread_cond_broadcast(&empty);
    pthread_mutex_unlock(&mutexzim);
    
    return result;
}

void *producer(void *ar){
    args *argumentos = (args *) ar;
    printf("O produtor %d iniciou!\n", argumentos->id);
    // fica em loop produzindo sempre que possivel e mandando o sinal de filled para que as threads consumidoras
    // possam consumir o que foi produzido
    while(true){
        for(int x = 0; x < lim; x++){
            putBlockingQueue(argumentos->queue, x);
            printf("Produtor %d produziu: %d\n", argumentos->id, x);
            pthread_cond_signal(&filler);
        }
    }
    printf("Produtor %d encerrado.\n", argumentos->id);
    pthread_exit(NULL);
}

void *consumer(void *ar){
    args *argumentos = (args *) ar;
    printf("Consumidor %d iniciou!\n", argumentos->id);
    // fica em loop consumindo sempre que possível e mandando o sinal de empty para que as threads produtoras
    // possam produzir mais alguma coisa
    while(true){
        int valor = takeBlockingQueue(argumentos->queue);
        if(valor == -1e9) continue;
        printf("Consumidor %d consumiu: %d\n", argumentos->id, valor);
        pthread_cond_signal(&empty);
    }
    printf("Consumidor %d encerrado.\n", argumentos->id);
    pthread_exit(NULL);
}

int main(){
    /* aqui para exemplos eu criei uma fila usando a função newBlockingQueue, com um limite "lim" definido no
    default, de mesma forma também crio "qt_consumidores" threads consumidoras e "qt_produtores" threads
    produtoras, que atuam nessa fila criada. */
    blockingQueue *queue = newBlockingQueue(lim);
    for(int x = 0; x < qt_consumidores; x++){
        args *argumentos = new args;
        argumentos->queue = queue;
        argumentos->id = x;
        pthread_create(&threads_consumidoras[x], NULL, consumer, argumentos);
    }
    for(int x = 0; x < qt_produtores; x++){
        args *argumentos = new args;
        argumentos->queue = queue;
        argumentos->id = x;
        pthread_create(&threads_produtoras[x], NULL, producer, argumentos);
    }
    for(int x = 0; x < qt_consumidores; x++) pthread_join(threads_consumidoras[x], NULL);
    for(int x = 0; x < qt_produtores; x++) pthread_join(threads_produtoras[x], NULL);

    pthread_exit(NULL);
}
