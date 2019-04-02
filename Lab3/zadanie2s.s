.data
SYSEXIT = 60
N0 = 5
N1 = 2
N = 5
OUTPUT: .asciz "The result for N = %d is %d.\n"
.bss

.text
.globl main

main:

movq $N, %rbx
pushq %rbx
call calculate
popq %rbx

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
pushq %rbp
movq %rsp, %rbp
movq 16(%rbp), %r8 # N w rcx

cmpq $1, %r8
je returnN1
jl returnN0

xor %rcx, %rcx
decq %r8
pushq %rcx
pushq %r8
call calculate
popq %rbx
popq %rcx
incq %r8

movq %rbx, %rax
movq $3, %r9
xor %rdx, %rdx
mulq %r9
addq %rax, %rcx

subq $2, %r8
pushq %rcx
pushq %r8
call calculate
popq %rbx
popq %rcx
addq $2, %r8

movq %rbx, %rax
movq $-2, %r10
xor %rdx, %rdx
mulq %r10
addq %rax, %rcx
movq %rcx, %rbx
jmp end


returnN1:
movq $N1, %rbx
jmp end

returnN0:
movq $N0, %rbx

end:
movq %rbx, 16(%rbp)
movq %rbp, %rsp
popq %rbp
ret
