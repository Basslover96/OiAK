.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
TEXT: .ascii "Insert string to check:\n"
TEXT_LEN = .-TEXT
OUTPUT: .asciz "The result index is %d. \n"

.bss
.comm TEXT_TO_CHECK, 1024

.text
.globl main

main:

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $TEXT, %rsi
movq $TEXT_LEN, %rdx
syscall

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $TEXT_TO_CHECK, %rsi
movq $1024, %rdx
syscall

movq %rax, %r8
movq $TEXT_TO_CHECK, %rax
call check

xor %rax, %rax
movq $OUTPUT, %rdi
movq %rbx, %rsi
call printf

# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall

.type check, @function
check:
movq $-1, %r10
subq $1, %r8

first:
incq %r10
cmpq %r8, %r10
jge check_failed
movb (%rax, %r10, 1), %cl 
cmpb $'a', %cl
je second
jmp first

second:
incq %r10
cmpq %r8, %r10
jge check_failed
movb (%rax, %r10, 1), %cl 
cmpb $'a', %cl
je third
jmp first

third:
incq %r10
movb (%rax, %r10, 1), %cl 
cmpb $'a', %cl
je found
jmp first

check_failed:
movq $-1, %rbx
jmp end

found:
sub $2, %r10
movq %r10, %rbx

end:
ret
