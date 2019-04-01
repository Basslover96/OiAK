# Funkcja rekurencyjna - argumenty i wynik przekazywane przez stos
.data
SYSEXIT = 60
N0 = -1
N1 = 2
N = 5
OUTPUT: .asciz "The result is %d.\n"
.bss

.text
.globl main

main:

movq $N, %r8
pushq %r8
call calculate
addq $8, %rsp

xor %rax, %rax
movq $OUTPUT, %rdi
movq %rbx, %rsi
call printf

# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall

.type calculate, @function
calculate:
push %rbp
movq %rsp, %rbp
movq 16(%rbp), %r8


cmpq $1, %r8
je return1
jl return0

xor %rcx, %rcx
decq %r8
pushq %rcx
pushq %r8
call calculate
popq %r8
popq %rcx

movq %rbx, %rax
movq $-2, %rbx
xor %rdx, %rdx
mulq %rbx
addq %rax, %rcx

decq %r8
pushq %rcx
pushq %r8
call calculate
popq %r8
popq %rcx

movq %rbx, %rax
movq $3, %rbx
xor %rdx, %rdx
mulq %rbx
addq %rax, %rcx

movq %rcx, %rbx
jmp end

return0:
movq $N0, %rbx
jmp end

return1:
movq $N1, %rbx

end:
movq %rbp, %rsp
pop %rbp
ret
