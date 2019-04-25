#include<bits/stdc++.h>
#include<pthread.h>
#define buffer 5
using namespace std;

typedef struct elem{
    int value;
    struct elem *prox;
} Elem;

typedef struct blockingQueue{
    unsigned int sizeBuffer, statusBuffer;
    Elem *head, *last;
} blockingQueue;

typedef struct args{
    int id;
    blockingQueue *queue;
} argum;

pthread_t *prod_thread;
pthread_t *cons_thread;
pthread_mutex_t mutex_cons = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_prod = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t empty = PTHREAD_COND_INITIALIZER;
pthread_cond_t filled = PTHREAD_COND_INITIALIZER;
int prod_qt, cons_qt;

blockingQueue *newBlockingQueue(unsigned int SizeBuffer){
    blockingQueue *queue = new blockingQueue;
    queue->sizeBuffer = SizeBuffer;
    queue->statusBuffer = 0;
    return queue;
}

void putBlockingQueue(blockingQueue *Q, int newValue){
    pthread_mutex_lock(&mutex_prod);
    if(Q->statusBuffer == Q->sizeBuffer){
        printf("Fila cheia, aguardando retirada por um consumidor.\n");
        while(Q->statusBuffer == Q->sizeBuffer){
            pthread_cond_wait(&empty, &mutex_prod);
        }
    }
    /* criação do novo elemento */
    Elem *elemento = new Elem;
    elemento->value = newValue;
    elemento->prox = NULL;
    // caso o buffer esteja vazio, digo que meu elemento é o topo e fim
    if(Q->statusBuffer == 0){
        Q->head = elemento;
        Q->last = elemento;
    }else{
        // caso o buffer nao esteja vazio, o proximo elemento do meu ultimo
        // anteriormente é o meu novo elemento, assim como o ultimo elemento
        // agora é esse ultimo elemento que inseri
        Q->last->prox = elemento;
        Q->last = elemento;
    }

    Q->statusBuffer = Q->statusBuffer + 1;
    if(Q->statusBuffer == 1) pthread_cond_broadcast(&filled);
    
    pthread_mutex_unlock(&mutex_prod);
}

int takeBlockingQueue(blockingQueue *Q){
    int valor;
    pthread_mutex_lock(&mutex_cons);
    if(Q->statusBuffer == 0){
        printf("Fila vazia, aguardando insercao por um produtor.\n");
        while(Q->statusBuffer == 0){
            pthread_cond_wait(&filled, &mutex_cons);
        }
    }
    Elem *elemento = Q->head;
    Q->head = Q->head->prox;
    Q->statusBuffer = Q->statusBuffer - 1;
    valor = elemento->value;
    free(elemento);

    if(Q->statusBuffer == Q->sizeBuffer - 1) pthread_cond_broadcast(&empty);
    pthread_mutex_unlock(&mutex_cons);

    return valor;
}

void *produtor(void *argsN){
    argum *argumentos = (argum *) argsN;
    printf("Produtor %d inicializado\n", argumentos->id);
    int qt = buffer;
    for(int x = 0; x < qt; x++){
        putBlockingQueue(argumentos->queue, x);
        printf("O produtor %d produziu %d\n", argumentos->id, x);
    }
    printf("Produtor %d encerrado\n", argumentos->id);
    prod_qt--;
}

void *consumidor(void *argsN){
    argum *argumentos = (argum *) argsN;
    int removedElement;
    printf("Consumidor %d inicializado\n", argumentos->id);
    while(prod_qt > 0 || argumentos->queue->statusBuffer > 0){
        removedElement = takeBlockingQueue(argumentos->queue);
        printf("O consumidor %d consumiu %d\n", argumentos->id, removedElement);
    }
    printf("Consumidor %d encerrado\n", argumentos->id);
    cons_qt--;
}

int main(){
    blockingQueue *queue;
    queue = newBlockingQueue(buffer); // criando uma fila de tamanho 'buffer', no define
    printf("Digite a quantidade de threads produtoras: ");
    cin >> prod_qt;
    printf("Digite a quantidade de threads consumidoras: ");
    cin >> cons_qt;
    prod_thread = (pthread_t *) malloc(prod_qt * sizeof(pthread_t));
    cons_thread = (pthread_t *) malloc(cons_qt * sizeof(pthread_t));

    for(int x = 0; x < prod_qt; x++){
        argum *argumentos = new argum;
        argumentos->queue = queue;
        argumentos->id = x;
        pthread_create(&prod_thread[x], NULL, produtor, argumentos);
    }
    for(int x = 0; x < cons_qt; x++){
        argum *argumentos = new argum;
        argumentos->queue = queue;
        argumentos->id = x;
        pthread_create(&cons_thread[x], NULL, consumidor, argumentos);
    }
    while(cons_qt > 0 || prod_qt > 0){

    }
}
