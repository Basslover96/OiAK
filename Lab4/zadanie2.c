# include <stdio.h>

extern void caesar(char* string, int length, int modifier);

char test_string[] = "1234567890";
int test_len = 10;
int modifier = 3;

int main(){
    caesar(test_string, test_len, modifier);
    printf("The result string is: %s\n", test_string);
    return 0;
}