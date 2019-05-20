# include <stdio.h>

extern double ex(double x, int iterations);

int main(){
    int iterations;
    double x;
    printf("Insert x: ");
    scanf("%lf", &x);
    printf("Insert number of iterations: ");
    scanf("%d", &iterations);
    printf("The result is: %lf\n", ex(x, iterations));
    return 0;
}
