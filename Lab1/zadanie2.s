.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_CODE = 0
LENGTH = 256


INPUT: .ascii "Insert number in base 3:\n"
INPUT_LENGTH = .-INPUT

OUTPUT: .ascii "Your number in base 9 is: \n"
OUTPUT_LENGTH = .-OUTPUT

ERROR_MSG: .ascii "Wrong input!\n"
ERROR_MSG_LENGTH = .-ERROR_MSG

.bss
.comm BASE_THREE, 256
.comm BASE_NINE, 256

.text
.globl main

main:

# Prośba o wpisanie liczby.
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $INPUT, %rsi
movq $INPUT_LENGTH, %rdx
syscall

# Wczytanie liczby do bufora.
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $BASE_THREE, %rsi
movq $LENGTH, %rdx
syscall

sub $2, %rax 
movq %rax, %r9 # Długość ciągu - 1 w %r9

cmpq $0, %r9
jl end # Ciąg pusty -> koniec

xor %r10, %r10 # Wartość
xor %r11, %r11 # Aktualna potęga
xor %r12, %r12 # Licznik pętli

calculate_value:
xor %rbx, %rbx # W rbx aktualne przetwarzany znak
movb BASE_THREE(,%r11,1), %bl

# Sprawdzenie poprawności
cmpq $'0', %rbx
jl error 
cmpq $'2', %rbx
jg error

sub $'0', %rbx # W rbx cyfra w systemie 3

cmpq $0, %rbx
je next_iteration # cyfra 0 -> do następnej iteracji

xor %r12, %r12 # Zerowanie licznika pętli
movq $1, %rax # Wynik częściowy do %rax
movq $3, %rcx # Baza systemu do %rbx

loop1:
inc %r12
cmp %r11, %r12 
jg add_to_result # licznik pętli > aktualnej potęgi -> do wyniku
mulq %rcx
jmp loop1

add_to_result:
mulq %rbx
addq %rax, %r10
next_iteration:
inc %r11 # Zwiększenie aktualnej potęgi
cmp %r9, %r11 # potęga > długości ciągu - 1 -> koniec
jg convert_to_base_nine
jmp calculate_value

convert_to_base_nine:
movq $9, %rcx 
movq %r10, %rax # Wcześniej obliczona wartość do %rax
xor %r11, %r11 # Licznik pętli
loop2:
xor %rdx, %rdx
divq %rcx
addq $'0', %rdx
movb %dl, BASE_NINE(,%r11,1)
cmpq $0, %rax
je print_result
inc %r11
jmp loop2

print_result:
inc %r11
movb $'\n', BASE_NINE(,%r11,1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $OUTPUT, %rsi
movq $OUTPUT_LENGTH, %rdx
syscall

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $BASE_NINE, %rsi
movq $LENGTH, %rdx
syscall
jmp exit

error:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $ERROR_MSG, %rsi
movq $ERROR_MSG_LENGTH, %rdx
syscall

exit:
movq $SYSEXIT, %rax
movq %r10, %rdi
syscall
