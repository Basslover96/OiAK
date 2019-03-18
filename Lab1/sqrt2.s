.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_CODE = 0

NUMBER = 30

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
decq %r9 # Mniejsza opcja
subq %rax, %r10 # Mniejsza wartość

movq $NUMBER, %r11
movq $NUMBER, %r12
sub %r10, %r11
sub %r12, %rcx
cmpq %r11, %rcx
jl exit

movq %r9, %rbx

exit:
movq $SYSEXIT, %rax
movq %rbx, %rdi
syscall
