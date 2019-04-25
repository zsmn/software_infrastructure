#include <bits/stdc++.h>
using namespace std;
#define sp ' '
int n=0;
typedef struct valpas{
	int il;
	int ic;
	int enl;
	int enc;
}valpas, *ptr_thread_arg;

char mat[1000][1000];
int l,co;
int linq;

void *solvete(void *arg){
	ptr_thread_arg all = (ptr_thread_arg)arg;
	int k=0;
	char atu = mat[all->il][all->ic];
	for(int i = all->il; i<=all->enl; i++){
		for(int j = all->ic; j<=all->enc; j++){
			if(mat[i][j] != atu){
				k=1;
				break;
			}
		}
		if(k)break;
	}
	char *ans;
	char *au = (char*)malloc(412345);
	if(k){

		//cout << 'D';
		strcat(au,"D");
		linq++;
		if(linq == 50){
			strcat(au,"\n");
			linq = 0;
		}
		pthread_t threads[4];
		int a,b,c,d, g, corx, cory;
		corx = all->enl - all->il;
		cory = all->enc - all->ic;
		a = all->il, b = all->ic, c = all->il + (corx/2), d = all->ic + (cory/2);
		if(a <= c && b <= d && c <= all->enl && d <= all->enc){
			valpas *proxi1 = new valpas;
			proxi1->il = a;
			proxi1->ic = b;
			proxi1->enl = c;
			proxi1->enc = d;
			pthread_create( &threads[0], NULL, solvete, proxi1);
			pthread_join(threads[0], (void**)&ans);
			strcat(au,ans);
		}
		a = all->il, b = all->ic + (cory/2)+1, c = all->il + (corx/2), d = all->enc;
		if(a <= c && b <= d && c <= all->enl && d <= all->enc){
			valpas *proxi2 = new valpas;
			proxi2->il = a;
			proxi2->ic = b;
			proxi2->enl = c;
			proxi2->enc = d;
			pthread_create( &threads[1], NULL, solvete, proxi2);
			pthread_join(threads[1], (void**)&ans);
			strcat(au,ans);
		}
		a = all->il+(corx/2)+1, b = all->ic, c = all->enl, d = all->ic+(cory/2);
		if(a <= c && b <= d && c <= all->enl && d <= all->enc){
			valpas *proxi3 = new valpas;
			proxi3->il = a;
			proxi3->ic = b;
			proxi3->enl = c;
			proxi3->enc = d;
			pthread_create( &threads[2], NULL, solvete, proxi3);
			pthread_join(threads[2], (void**)&ans);
			strcat(au,ans);
		}
		a = all->il+(corx/2)+1, b = all->ic+(cory/2)+1, c = all->enl, d = all->enc;
		if(a <= c && b <= d && c <= all->enl && d <= all->enc){
			valpas *proxi4 = new valpas;
			proxi4->il = a;
			proxi4->ic = b;
			proxi4->enl = c;
			proxi4->enc = d;
			pthread_create( &threads[3], NULL, solvete, proxi4);
			pthread_join(threads[3], (void**)&ans);
			strcat(au,ans);
		}
	}
	if(!k){
		char atual[2];
		atual[0]=atu;
		atual[1]='\0'; 
		strcat(au,atual);
		linq++;
		if(linq == 50){
			strcat(au,"\n");
			linq = 0;
		}
	}
	pthread_exit((void*)au);
	free(au);
}

int main(){
	int tc;
	cin >> tc;
	while(tc--){
		cin >> l >> co;
		for(int i=0; i<l; i++){
			cin >> mat[i];
		}
		linq=0;
		char *ans;
		valpas come;
		come.il = 0;
		come.ic = 0;
		come.enl = l-1;
		come.enc = co-1;
		pthread_t threadi;
		pthread_create( &(threadi), NULL, solvete, &come);
		pthread_join(threadi, (void**)&ans);
		printf("%s",ans);
		cout << endl;
		free(ans);
	}
	return 0;
}
