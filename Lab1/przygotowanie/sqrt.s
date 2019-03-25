.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_CODE = 0

NUMBER = 33

.bss
.text
.globl main

main:
movq $0, %rbx # Wynik w %rbx
xor %rcx, %rcx # Aktualna suma w %rcx
loop:
incq %rbx
movq $2, %rax
mulq %rbx
subq $1, %rax
addq %rax, %rcx
cmpq $NUMBER, %rcx
jl loop

cmpq $NUMBER, %rcx
je exit

movq %rbx, %r9
movq %rcx, %r10
inc %r9
movq $2, %rax
mulq %r9
subq $1, %rax
addq %rax, %r10


exit:
movq $SYSEXIT, %rax
movq %rbx, %rdi
syscall
