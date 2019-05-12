# include <stdio.h>

char test_string[] = "1234567890";
int test_len = 10;
int modifier = 3;

int main(){

    asm(
    "mov $0, %%rcx\n"
    "xor %%rbx, %%rbx\n"
    "mov $10, %%r10\n"
    "loop:\n"
    "mov (%0, %%rcx, 1), %%bl\n"
    "sub $'0', %%bl\n"
    "cmp $0, %%bl\n"
    "jl save\n"
    "cmp $9, %%bl\n"
    "jg save\n"
    "add modifier, %%rbx\n"
    "xor %%rdx, %%rdx\n"
    "mov %%rbx, %%rax\n"
    "div %%r10\n"
    "mov %%rdx, %%rbx\n"
    "add $'0', %%bl\n"
    "save:\n"
    "mov %%bl, (%0, %%rcx, 1)\n"
    "inc %%rcx\n"
    "cmp test_len, %%ecx\n"
    "jne loop\n"
    :
    :"D"(test_string)
    :"%rax","%rbx","%rcx","%rdx","%r8","%r10");
    printf("The result string is: %s\n", test_string);
    return 0;
}