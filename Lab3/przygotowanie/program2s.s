# Algorytm Euklidesa - arguemnty przez stos

.data
SYSEXIT = 60
FIRST = 20
SECOND = 10
OUTPUT: .asciz "The GCD of numbers %d and %d is %d.\n"
.bss

.text
.globl main

main:

movq $FIRST, %rbx
movq $SECOND, %rcx

cmp %rcx, %rbx
jge calculate

movq $SECOND, %rbx
movq $FIRST, %rcx

calculate:
pushq %rcx
pushq %rbx
call gcd
addq $16, %rsp

xor %rax, %rax
movq $OUTPUT, %rdi
movq $FIRST, %rsi
movq $SECOND, %rdx
movq %rbx, %rcx
call printf

# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall

.type gcd, @function
gcd:
pushq %rbp
movq %rsp, %rbp

movq 16(%rbp), %rbx
movq 24(%rbp), %rcx

cmpq $0, %rcx
jz return

xor %rdx, %rdx
movq %rbx, %rax
divq %rcx

pushq %rdx
pushq %rcx
call gcd
addq $16, %rsp

return:
movq %rbp, %rsp
popq %rbp
ret
