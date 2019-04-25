#include<bits/stdc++.h>
#include<pthread.h>
using namespace std;

typedef struct{
    int i, k;
} args;

pthread_barrier_t barrier;
pthread_t *threads;

double **mat_coeficientes;
double **mat_indices;
double *mat_results;
int n_eq, n_it, n_proc;

void *calc_iteration(void *argms){
    args *argumentos = (args *) argms;
    double sum = 0;
    for(int j = 0; j < n_eq; j++){
        if(argumentos->i != j) sum += mat_coeficientes[argumentos->i][j] * mat_indices[argumentos->k - 1][j];
    }
    pthread_barrier_wait(&barrier);
    mat_indices[argumentos->k][argumentos->i] = (1.0/mat_coeficientes[argumentos->i][argumentos->i]) * (mat_results[argumentos->i] - sum);
    /* debugging */
    cout << mat_results[argumentos->i] << " " << sum << endl;
    cout << "mat_indices[" << argumentos->i << "] = " << mat_indices[argumentos->k][argumentos->i] << endl;
    return NULL;
}

int main(){
    int k = 0;

    cout << "Digite o numero de equacoes: ";
    cin >> n_eq;
    cout << "Digite o numero de iteracoes para o algoritmo: ";
    cin >> n_it;
    cout << "Digite quantos nucleos o seu processador possui: ";
    cin >> n_proc;

    threads = (pthread_t *) malloc(n_proc * sizeof(pthread_t));
    mat_coeficientes = (double **) malloc(n_eq * sizeof(double *));
    for(int x = 0; x < n_eq; x++){
        mat_coeficientes[x] = (double *) malloc(n_eq * sizeof(double));
    }
    n_it += 1; // pra contar com o caso base
    mat_indices = (double **) malloc(n_it * sizeof(double *));
    for(int x = 0; x < n_it; x++){
        mat_indices[x] = (double *) malloc(n_eq * sizeof(double));
    }
    mat_results = (double *) malloc(n_eq * sizeof(double));

    cout << "Digite agora a matriz A" << endl;
    for(int x = 0; x < n_eq; x++){
        for(int y = 0; y < n_eq; y++){
            cin >> mat_coeficientes[x][y];
        }
    }
    cout << "Digite agora o resultado das equacoes" << endl;
    for(int x = 0; x < n_eq; x++){
        cin >> mat_results[x];
    }

    // caso base, todos os valores das variaveis inicialmente são 1
    for(int x = 0; x < n_eq; x++){
        mat_indices[0][x] = 1;
    }
    n_it -= 1; // descontando o caso base

    int contador = 0, fiz = 0;
    /* metodo de jacobi iterativo */
    while(k++ < n_it){
        contador = 0;
        int i;
        for(i = 0; i < n_eq; i++){
            if(++contador == n_proc){
                pthread_barrier_init(&barrier, NULL, n_proc);
                for(int x = 1; x <= n_proc; x++){
                    args *argm = new args;
                    argm->i = i-x;
                    argm->k = k;
                    pthread_create(&threads[x-1], NULL, calc_iteration, argm);
                }
                for(int x = 0; x < n_proc; x++){
                    pthread_join(threads[x], NULL);
                }
                pthread_barrier_destroy(&barrier);
                contador = 0;
            }
        }
        // caso tenha sobrado alguma incognita a ser calculada
        if(contador != 0){
            pthread_barrier_init(&barrier, NULL, contador);
            for(int x = 1; x <= contador; x++){
                args *argm = new args;
                argm->i = i-x;
                argm->k = k;
                pthread_create(&threads[x-1], NULL, calc_iteration, argm);
            }
            for(int x = 0; x < n_proc; x++){
                pthread_join(threads[x], NULL);
            }
            pthread_barrier_destroy(&barrier);
        }
    }

    cout << "Resultados do metodo de jacobi com " << n_it << " iteracoes e " << n_proc << " nucleos atuando:" << endl;
    for(int x = 0; x < n_eq; x++){
        cout << "x" << x+1 << " = " << mat_indices[n_it][x] << endl;
    }
}
