.data
SYSEXIT = 60
FORMAT: .asciz "%d"

.bss
.comm INTEGER_INPUT, 4

.text
.globl main

main:

xor %rax, %rax
mov $FORMAT, %rdi
mov $INTEGER_INPUT, %rsi
call scanf

# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall
