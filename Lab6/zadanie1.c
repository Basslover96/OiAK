#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void fastSSE(float* data1, int length);
extern unsigned long long getCycle();

void slowC(float* data, int length){
    for(int i = 0; i < length; i++){
        data[i] += data[i];
    }
}

int main(){

    unsigned long long startC, endC, startASM, endASM, diffC, diffASM;

    //Generacja danych testowych
    float dataC[32];
    int length = sizeof(dataC)/sizeof(dataC[0]);
    srand(time(NULL));
    for(int i = 0; i < length; i++){
        dataC[i] = rand()%100+1;
    }

    //Ten sam zestaw danych dla asm
    float dataASM[32];
    for(int i = 0; i < length; i++){
        dataASM[i] = dataC[i];
    }

    printf("DATA FOR C:\n");
    for(int i = 0; i < length; i++){
        printf("%f ", dataC[i]);
    }
    startC = getCycle();
    slowC(dataC,length);
    endC = getCycle();
    printf("\nDATA FOR C AFTER CHANGE:\n");
    for(int i = 0; i < length; i++){
        printf("%f ", dataC[i]);
    }

    printf("\n");

    printf("\nDATA FOR ASM:\n");
    for(int i = 0; i < length; i++){
        printf("%f ", dataASM[i]);
    }
    startASM = getCycle();
    fastSSE(dataASM,length);
    endASM = getCycle();
    printf("\nDATA FOR ASM AFTER CHANGE:\n");
    for(int i = 0; i < length; i++){
        printf("%f ", dataASM[i]);
    }
    printf("\n\n");

    printf("Clocks for C: %llu\n",endC-startC);
    printf("Clocks for ASM: %llu\n",endASM-startASM);
    return 0;
}
