# Zamiana z systemu 7 na 10 i wypisanie na ekran.
# Kompilacja gcc -no-pie -g -o program2 program2.s
# Wynik echo $?

.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_CODE = 0
TEXT_TO_CHANGE_LENGTH = 256

TEXT: .ascii "Insert number in base 7:\n"
TEXT_LENGTH = .-TEXT

WRITE_TEXT: .ascii "Your number in base 10 is: \n"
WRITE_TEXT_LENGTH = .-WRITE_TEXT

.bss
.comm TEXT_TO_CHANGE, 256

.text
.globl main

main:

# Prośba o wpisanie tekstu.
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $TEXT, %rsi
movq $TEXT_LENGTH, %rdx
syscall

# Wczytanie tekstu do bufora.
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $TEXT_TO_CHANGE, %rsi
movq $TEXT_TO_CHANGE_LENGTH, %rdx
syscall

sub $2, %rax
movq %rax, %r9 # Długość ciągu znaków w R9

cmpq $0, %r9
jl end

xor %r10, %r10 # Wynik finalny w R10
xor %r11, %r11 # Aktualna potęga w R11
xor %r12, %r12 # Licznik dla potęgi

loop:
xor %rbx, %rbx
movb TEXT_TO_CHANGE(, %r9, 1), %bl
sub $'0', %rbx  # W RBX kolejna cyfra ciągu od prawej strony.

xor %rax, %rax

cmpq $0, %rbx # Jeżeli cyfra ciągu == 0 to koniec pętli.
je add_to_result

movq $1, %rax # Wynik lokalny w RAX

loop1:
cmpq $0, %r12 
je add_to_result

movq $7, %rcx
mulq %rcx
dec %r12
jmp loop1

add_to_result:
mulq %rbx
addq %rax, %r10
inc %r11
movq %r11, %r12
dec %r9
cmp $0, %r9
jl end
jmp loop

end:
# Zakończenie działania programu. Wynik w R10.
movq $SYSEXIT, %rax
movq %r10, %rdi
syscall
