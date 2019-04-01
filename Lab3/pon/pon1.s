# NWW - argumenty przez rejestry

.data
SYSEXIT = 60
FIRST = 3
SECOND = 10
OUTPUT: .asciz "The LCM of numbers %d and %d is %d.\n"
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
call lcm

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

cmpq $0, %rcx
jz return

xor %rdx, %rdx
movq %rbx, %rax
divq %rcx

movq %rcx, %rbx
movq %rdx, %rcx
call gcd

return:

ret

.type lcm, @function
lcm:
call gcd

movq $FIRST, %rax
movq $SECOND, %rcx
mulq %rcx
divq %rbx
movq %rax, %rbx
ret
