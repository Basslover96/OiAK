# include <stdio.h>

char test_string[] = "1234567890";
int test_len = 10;
int modifier = 3;

int main(){

    asm(
    "xor %%r8, %%r8\n"
    "xor %%rbx, %%rbx\n"
    "movq $10, %%r10\n"
    "loop:\n"
    "movb (%0, %%r8, 1), %%bl\n"
    "subb $'0', %%bl\n"
    "cmpb $0, %%bl\n"
    "jl save\n"
    "cmpb $9, %%bl\n"
    "jg save\n"
    "add %2, %%rbx\n"
    "xor %%rdx, %%rdx\n"
    "movq %%rbx, %%rax\n"
    "movq %%r10, %%rcx\n"
    "divq %%r10\n"
    "movq %%rdx, %%rbx\n"
    "addb $'0', %%bl\n"
    "save:\n"
    "movb %%bl, (%0, %%r8, 1)\n"
    "incq %%r8\n"
    "cmp %1, %%r8\n"
    "jne loop\n"
    :
    :"r"(&test_string), "r"(test_len), "r"(modifier)
    :"%rax","%rbx","%rdx","%r8","%r10");
    printf("The result string is: %s\n", test_string);
    return 0;
}