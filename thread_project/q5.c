#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

void merge(int l, int m, int r);
int *array;
int tam;
pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;

typedef struct area{
    int low;
    int high;
}area, *ptr_thread_arg;

void MergeSort(int l, int r){
    int middle;
    if(l < r){
        middle = l + (r-l)/2; //Evita overflow. Melhor do que fazer (l+r)/2
        MergeSort(l, middle);
        MergeSort(middle + 1, r);
        merge(l, middle, r);
    }
}

void merge(int l, int m, int r){
    int i;
    int j;
    int k;
    int n1 = m - l + 1;
    int n2 = r - m;
    //utilizando os arrays temporarios para o mergesort
    int L[n1], R[n2];
    //realizando a copia dos dados dos array principal para os arrays temporarios
    for(i = 0; i < n1; i++){
        L[i] = array[i + l];
    }
    for(j = 0; j < n2; j++){
        R[j] = array[m + j + 1];
    }
    i = 0, j = 0, k = l;
    while(i < n1 && j < n2){
        if(L[i] <= R[j]){
            array[k] = L[i];
            i++;
        }else{
            array[k] = R[j];
            j++;
        }
        k++;
    }
    while(i < n1){
        array[k] = L[i];
        i++;
        k++;
    }
    while(j < n2){
        array[k] = R[j];
        j++;
        k++;
    }
}

void* merge_sort_threads(void *arg){
    ptr_thread_arg argumento = (ptr_thread_arg)arg;
    pthread_t novathread1;
    pthread_t novathread2;
    int low, mid, high;
    int erro1, erro2;
    low = argumento->low;
    mid = argumento->low + (argumento->high - argumento->low)/2;
    high = argumento->high;
    area a1;
    area a2;
    a1.low = low;
    a1.high = mid;
    a2.low = mid + 1;
    a2.high = high;
    if(low < high){
        erro1 = pthread_create(&novathread1, NULL, merge_sort_threads, &a1);
        pthread_join(novathread1, NULL);
        erro2 = pthread_create(&novathread2, NULL, merge_sort_threads, &a2);
        pthread_join(novathread2, NULL);
        merge(low, mid, high);
    }
}

int main(){
    pthread_t thread1;
    area areadecontrole;
    int erro;
    int i = 0;
    printf("Selecione o tamanho do array:\n");
    scanf("%d", &tam);
    array = (int *)malloc(sizeof(int) * tam);
    printf("Insira os valores que o array de inteiros deve conter:\n");
    for(i = 0; i < tam; i++){
        scanf("%d", &array[i]);
    }
    areadecontrole.low = 0;
    areadecontrole.high = tam - 1;
    //Apos isso, realizamos a criação de 1 thread
    erro = pthread_create(&thread1, NULL, merge_sort_threads, &areadecontrole);
    if(erro != 0){
            printf("Houve um erro ao criar a thread de indice %d\n", i);
            exit(1);
    }
    pthread_join(thread1, NULL);
    //printando o array ordenado
    printf("Array ordenado:\n");
    for(i = 0; i < tam; i++){
        printf("%d ", array[i]);
    }
    printf("\n");
    return 0;
}
