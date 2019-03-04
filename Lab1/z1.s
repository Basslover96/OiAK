.data
a = 18
b = 5
exit = 60

.bss
.text

.globl main

main:

movq $a, %r9
movq $b, %r10

cmpq %r10, %r9
jl greaterB
movq %r9, %rax
movq %r10 , %rbx
jmp loop

greaterB:
movq %r10, %rax
movq %r9 , %rbx

loop:
movq $0, %rdx
divq %rbx
movq %rbx, %rax
movq %rdx, %rbx
cmpq $0, %rbx
jne loop
movq %rax, %r9

movq $exit, %rax
movq %r9, %rdi
syscall
