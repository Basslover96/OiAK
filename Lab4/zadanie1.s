.data
SYSEXIT = 60
FORMAT: .asciz "%d %f"
FORMAT_O: .asciz "%lf\n"
FORMAT_1: .asciz "%d\n"

.bss
.comm INTEGER_INPUT, 4
.comm FLOAT_INPUT, 4

.text
.globl main

main:

xor %rax, %rax
movq $FORMAT, %rdi
movq $INTEGER_INPUT, %rsi
movq $FLOAT_INPUT, %rdx
call scanf

movq $1, %rax
xor %rdx, %rdx
xor %rcx, %rcx
movl INTEGER_INPUT(,%rcx,4), %edi
movss FLOAT_INPUT, %xmm0
call calculate

movq $1, %rax
movq $FORMAT_O, %rdi
subq $8, %rsp
call printf
addq $8, %rsp

movq $0, %rax
movq $FORMAT_1, %rdi
xor %rcx, %rcx
xor %rsi, %rsi
movl INTEGER_INPUT(,%rcx,4), %esi
call printf

# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall
