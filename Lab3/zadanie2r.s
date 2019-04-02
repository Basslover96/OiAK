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
movq $3, %r8
movq $-2, %r9
movq $N0, %r10
movq $N1, %r11

movq $N, %r12
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
cmpq $1, %r12
je returnN1
jl returnN0

xor %rcx, %rcx
decq %r12
pushq %rcx
call calculate
popq %rcx
incq %r12

movq %rbx, %rax
xor %rdx, %rdx
mulq %r8
addq %rax, %rcx

subq $2, %r12
pushq %rcx
call calculate
popq %rcx
addq $2, %r12

movq %rbx, %rax
xor %rdx, %rdx
mulq %r9
addq %rax, %rcx
movq %rcx, %rbx
jmp end

returnN1:
movq %r11, %rbx
jmp end

returnN0:
movq %r10, %rbx

end:
ret
