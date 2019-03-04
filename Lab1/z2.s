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
INPUT_LENGTH = 256


TEXT: .ascii "Insert number in base 3:\n"
TEXT_LENGTH = .-TEXT

WRITE_TEXT: .ascii "Your number in base 7 is: \n"
WRITE_TEXT_LENGTH = .-WRITE_TEXT

ERROR_MESSAGE: .ascii "Wrong input!\n"
ERROR_LENGTH = .-ERROR_MESSAGE

.bss
.comm TEXT_THREE, 256
.comm TEXT_SEVEN_REVERSED, 256
.comm TEXT_SEVEN, 256

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
movq $TEXT_THREE, %rsi
movq $INPUT_LENGTH, %rdx
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
movb TEXT_THREE(, %r9, 1), %bl

# Sprawdzenie poprawności wprowadzonej liczby.
cmp $'2', %rbx
jg error
cmp $'0', %rbx
jl error

sub $'0', %rbx  # W RBX kolejna cyfra ciągu od prawej strony.


xor %rax, %rax

cmpq $0, %rbx # Jeżeli cyfra ciągu == 0 to koniec pętli.
je add_to_result

movq $1, %rax # Wynik lokalny w RAX

loop1:
cmpq $0, %r12 
je add_to_result

movq $3, %rcx
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
jl to_seven
jmp loop


to_seven:
movq $0, %r9
movq %r10, %rax
loop2:
movq $0, %rdx
movq $7, %rcx
divq %rcx
addq $'0', %rdx
movb %dl, TEXT_SEVEN_REVERSED(,%r9,1)
cmpq $0, %rax
je reverse
inc %r9
jmp loop2

error:
# Komunikat o błędzie
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $ERROR_MESSAGE, %rsi
movq $ERROR_LENGTH, %rdx
syscall

reverse:
movq $0, %rax
movq %r9, %rbx
loop3:
movb TEXT_SEVEN_REVERSED(,%rbx,1), %cl
movb %cl, TEXT_SEVEN(,%rax,1)
inc %rax
dec %rbx
cmp $0, %rbx
jge loop3

end:
inc %r9
movb $'\n', TEXT_SEVEN(,%r9,1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $WRITE_TEXT, %rsi
movq $WRITE_TEXT_LENGTH, %rdx
syscall

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $TEXT_SEVEN, %rsi
movq $INPUT_LENGTH, %rdx
syscall

movq $SYSEXIT, %rax
movq %r10, %rdi
syscall
