.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
EXIT_CODE = 0

NUMBER = 101

PRIME: .ascii "It's a prime number!\n"
PRIME_LENGTH = .-PRIME

NOT_PRIME: .ascii "It's not a prime number!\n"
NOT_PRIME_LENGTH = .-NOT_PRIME

.bss

.text

.globl main

main:

xor %rbx, %rbx # Wynik w %rbx
xor %rcx, %rcx
loop:
inc %rcx
xor %rdx, %rdx # Zerowanie %rdx
movq $NUMBER, %rax 
divq %rcx
cmpq $0, %rdx
jne loop
inc %rbx
cmp $NUMBER, %rcx
je end
jmp loop

end:
cmp $2, %rbx
jne not_prime_number

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $PRIME, %rsi
movq $PRIME_LENGTH, %rdx
syscall
jmp exit 

not_prime_number:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $NOT_PRIME, %rsi
movq $NOT_PRIME_LENGTH, %rdx
syscall

exit:
movq $SYSEXIT, %rax
movq %r10, %rdi
syscall

