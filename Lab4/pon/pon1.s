.data
SYSEXIT = 60
FORMAT: .asciz "%d %f %lf"
FORMAT_O: .asciz "%lf\n"

.bss
.comm INTEGER_INPUT, 4
.comm FLOAT_INPUT, 4
.comm DOUBLE_INPUT, 8

.text
.globl main

main:

xor %rax, %rax
movq $FORMAT, %rdi
movq $INTEGER_INPUT, %rsi
movq $FLOAT_INPUT, %rdx
movq $DOUBLE_INPUT, %rcx
call scanf

movq $2, %rax
xor %rdx, %rdx
xor %rcx, %rcx
movl INTEGER_INPUT(,%rcx,4), %edi
movss FLOAT_INPUT, %xmm0
movlps DOUBLE_INPUT, %xmm1
call calculate

movq $1, %rax
movq $FORMAT_O, %rdi
subq $8, %rsp
call printf
addq $8, %rsp


# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall
