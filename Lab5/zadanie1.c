# include <stdio.h>

extern double arctgx(double x, int iterations);

int main(){
    int iterations;
    double x;
    printf("Insert x: ");
    scanf("%lf", &x);
    printf("Insert number of iterations: ");
    scanf("%d", &iterations);
    printf("The result is: %lf\n", arctgx(x, iterations));
    return 0;
}
