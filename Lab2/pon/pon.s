.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSOPEN  = 2
SYSCLOSE = 3
SYSEXIT = 60
FILE_A_ASCII: .asciz "number_a"
FILE_B_ASCII: .asciz "number_b"
RESULT_ASCII: .asciz "result"

.bss
.comm NUMBER_A_ASCII, 1024
.comm NUMBER_B_ASCII, 1024
.comm NUMBER_A, 512
.comm NUMBER_B, 512
.comm SUM, 513
.comm RESULT, 1369 # Do policzenia dokładnie

.text
.globl main

main:
# Otwarcie pliku z liczbą A
movq $SYSOPEN, %rax
movq $FILE_A_ASCII, %rdi
movq $00, %rsi
movq $0444, %rdx
syscall

movq %rax, %r8 # Identyfikator pliku z liczbą A

# Wczytanie liczby A do bufora
movq $SYSREAD, %rax
movq %r8, %rdi
movq $NUMBER_A_ASCII, %rsi
movq $1024, %rdx
syscall

movq %rax, %r9 # Liczba wczytanych znaków liczby A w R9
dec %r9 

# Zamknięcie pliku z liczbą A
movq $SYSCLOSE, %rax
movq %r8, %rdi
syscall

# Otwarcie pliku z liczbą B
movq $SYSOPEN, %rax
movq $FILE_B_ASCII, %rdi
movq $00, %rsi
movq $0444, %rdx
syscall

movq %rax, %r8 # Identyfikator pliku z liczbą B

# Wczytanie liczby B do bufora
movq $SYSREAD, %rax
movq %r8, %rdi
movq $NUMBER_B_ASCII, %rsi
movq $1024, %rdx
syscall

movq %rax, %r10 # Liczba wczytanych znaków liczby B w R10
dec %r10

# Zamknięcie pliku z liczbą B
movq $SYSCLOSE, %rax
movq %r8, %rdi
syscall

# Licznik od końca NUMBER_A_ASCII
movq %r9, %r11 
# Licznik od początku NUMBER_A
xor %r12, %r12 

convert_to_number_A:
movb NUMBER_A_ASCII(,%r11,1), %al
cmpb $'A', %al
jge letter_A

subb $'0', %al
jmp next_A

letter_A:
subb $55, %al

next_A:
decq %r11
cmpq $0, %r11
jl number_A_end
movb NUMBER_A_ASCII(,%r11,1), %bl
cmpb $'A', %bl
jge next_letter_A

subb $'0', %bl
jmp to_buffer_A

next_letter_A:
subb $55, %bl
jmp to_buffer_A

number_A_end:
movb $0, %bl

to_buffer_A:
shl $4, %bl
addb %bl, %al
movb %al, NUMBER_A(,%r12, 1)
incq %r12
decq %r11
cmpq $0, %r11
jge convert_to_number_A

# Licznik od końca NUMBER_B_ASCII
movq %r10, %r11 
# Licznik od początku NUMBER_B
xor %r12, %r12 

convert_to_number_B:
movb NUMBER_B_ASCII(,%r11,1), %al
cmpb $'A', %al
jge letter_B

subb $'0', %al
jmp next_B

letter_B:
subb $55, %al

next_B:
decq %r11
cmpq $0, %r11
jl number_B_end
movb NUMBER_B_ASCII(,%r11,1), %bl
cmpb $'A', %bl
jge next_letter_B

subb $'0', %bl
jmp to_buffer_B

next_letter_B:
subb $55, %bl
jmp to_buffer_B

number_B_end:
movb $0, %bl

to_buffer_B:
shl $4, %bl
addb %bl, %al
movb %al, NUMBER_B(,%r12, 1)
incq %r12
decq %r11
cmpq $0, %r11
jge convert_to_number_B

# Dodawanie 64b i flaga CF
clc # Czyszczenie przeniesienia
pushf # Rejestr flag na stos
xor %r13, %r13
add_loop:
movq NUMBER_A(,%r13, 8), %rax
movq NUMBER_B(,%r13, 8), %rbx
popf
adcq %rbx, %rax
pushf
movq %rax, SUM(,%r13,8)
addq $8, %r13
cmpq $512, %r13
jne add_loop

popf
movb $0, SUM(,%r13,1)
jnc convert_sum_to_ascii
movb $1, SUM(,%r13,1)

convert_sum_to_ascii:
xor %r14, %r14 # Licznik od początku sumy
movq $1367, %r15 # Licznik od końca wyjścia
merge_3B:
xor %rax, %rax
xor %rbx, %rbx
xor %rcx, %rcx
# Trzy bajty do %rax
movb SUM(,%r14, 1), %al
incq %r14
movb SUM(,%r14, 1), %bl
shl $8, %rbx
incq %r14
movb SUM(,%r14, 1), %cl 
shl $16, %rcx
orq %rcx, %rbx
orq %rbx, %rax

xor %r8, %r8
convert_24b_and_save:
xor %rbx, %rbx
movb %al, %bl
and $0x7, %bl
shr $3, %rax
addb $'0', %bl
movb %bl, RESULT(,%r15,1)
decq %r15
inc %r8
cmpq $8, %r8
jl convert_24b_and_save
incq %r14
cmpq $513, %r14
jne merge_3B

movq $1368, %rax
movb $'\n', RESULT(,%rax,1)

# Otwarcie pliku z wynikiem
movq $SYSOPEN, %rax
movq $RESULT_ASCII, %rdi
movq $0101, %rsi
movq $0644, %rdx
syscall

movq %rax, %r8

# Zapisanie wyniku do pliku
movq $SYSWRITE, %rax
movq %r8, %rdi
movq $RESULT, %rsi
movq $1369, %rdx
syscall

# Zamknięcie pliku z wynikiem
movq $SYSCLOSE, %rax
movq %r8, %rdi
syscall

# Zakończenie działania programu
exit:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall
