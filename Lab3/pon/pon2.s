# Funkcja rekurencyjna - argumenty i wynik przekazywane przez rejestry
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

movq $N0, %r8
movq $N1, %r9
movq $N, %r10
xor %rcx, %rcx
call calculate

xor %rax, %rax
movq $OUTPUT, %rdi
movq $N, %rsi
movq %rbx, %rdx
call printf

# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall

.type calculate, @function
calculate:
cmpq $1, %r10
jl return0
je return1

subq $1, %r10
call calculate
addq $1, %r10

movq %rbx, %rax
movq $-2, %rbx
xor %rdx, %rdx
mulq %rbx

addq %rax, %rcx

sub $2, %r10
call calculate
addq $2, %r10

movq %rbx, %rax
movq $3, %rbx
xor %rdx, %rdx
mulq %rbx

addq %rax, %rcx
movq %rcx, %rbx

jmp end

return0:
movq %r8, %rbx
jmp end

return1:
movq %r9, %rbx

end:
ret
