# Zamiana dużych liter na małe i odwrotnie. Inne znaki pomijamy.
# Kompilacja gcc -no-pie -g -o zad2 zad2.s

.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_CODE = 0
TEXT_TO_CHANGE_LENGTH = 512
TEXT_TO_PRINT_LENGTH = 512

TEXT: .ascii "Insert some text:\n"
TEXT_LENGTH = .-TEXT

WRITE_TEXT: .ascii "Your text after change is: \n"
WRITE_TEXT_LENGTH = .-WRITE_TEXT

.bss
.comm TEXT_TO_CHANGE, 512
.comm TEXT_TO_PRINT, 512

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
movq $TEXT_TO_CHANGE, %rdx
syscall

# Licznik
dec %rax
movq $0, %rdi

loop_start:
movb TEXT_TO_CHANGE(, %rdi, 1), %bl
cmpb $'a', %bl
# Kod litery <'a' - skok do sprawdzenia, czy znak jest dużą literą.
jl maybe_big_letter
cmpb $'z', %bl
# Kod litery >'z' - skok do końca pętli
jg end_loop

# Mała litera
andb $0xDF, %bl
movb %bl, TEXT_TO_PRINT(, %rdi, 1)
jmp end_loop

maybe_big_letter:
cmpb $'A', %bl
# Kod litery <'A' - inny znak - skok do przepisania
jl other_sign
cmpb $'Z', %bl
# Kod litery >'Z' - inny znak - skok do przepisania
jg other_sign

# Duża litera
xorb $0x20, %bl
movb %bl, TEXT_TO_PRINT(, %rdi, 1)
jmp end_loop

other_sign:
movb %bl, TEXT_TO_PRINT(, %rdi, 1)

end_loop:
inc %rdi
cmp %rax, %rdi
jl loop_start

# Dopisanie znaku końca linii do tekstu wynikowego.
movb $'\n', TEXT_TO_PRINT(, %rdi, 1)

# Wiadomość dla użytkownika.
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $WRITE_TEXT, %rsi
movq $WRITE_TEXT_LENGTH, %rdx
syscall

# Wypisanie tekstu z bufora.
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $TEXT_TO_PRINT, %rsi
movq $TEXT_TO_PRINT_LENGTH, %rdx
syscall

# Zakończenie działania programu.
movq $SYSEXIT, %rax
movq $EXIT_CODE, %rdi
syscall
