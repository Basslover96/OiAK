# Sito Eratostenesa

.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
TEXT: .ascii "Insert upper border for prime numbers:\n"
TEXT_LEN = .-TEXT
PRINT_PRIME: .asciz "%ld "
NEW_LINE: .asciz "\n"
.bss
.comm PRIME_FLAGS, 65537
.comm PRIME_NUMBERS, 524588

.text
.globl main

main:

movq $0, %r8
movb $1, %al

fill_buffer_1:
movb %al, PRIME_FLAGS(,%r8,1)
incq %r8
cmpq $65536, %r8
jne fill_buffer_1

movq $0, %r8
movb $0, PRIME_FLAGS(,%r8,1)
incq %r8
movb $0, PRIME_FLAGS(,%r8,1)

call primes

xor %r10, %r10
decq %r9
show_primes:
xor %rax, %rax
movq PRIME_NUMBERS(,%r10,8), %rsi
movq $PRINT_PRIME, %rdi
push %r9
push %r10
call printf
pop %r10
pop %r9
incq %r10
cmpq %r9, %r10
jle show_primes

xor %rax, %rax
movq $NEW_LINE, %rdi
call printf

# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall

.type primes, @function
primes:

# Licznik po buforze flag
movq $1, %r8

find_lowest_prime:
incq %r8
cmpq $65536, %r8
jg save_primes
movb PRIME_FLAGS(,%r8,1), %al
cmpb $1, %al
jne find_lowest_prime

cross:
movq $2, %rcx 
cross_loop:
movq %r8, %rax
mulq %rcx
cmpq $65536, %rax
jg find_lowest_prime
movb $0, PRIME_FLAGS(,%rax,1)
incq %rcx
jmp cross_loop

save_primes:
movq $0, %r8
movq $0, %r9
xor %rdx, %rdx
save_loop:
movb PRIME_FLAGS(,%r8,1), %dl
cmpb $1, %dl
jne check_next
movq %r8, PRIME_NUMBERS(,%r9,8)
incq %r9
check_next:
incq %r8
cmpq $65536, %r8
jle save_loop

ret 
