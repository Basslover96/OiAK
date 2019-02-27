# Wpisanie do bufora ciągu znaków i wypisanie jego zawartości na ekranie.
# Kompilacja gcc -no-pie -g -o zad1 zad1.s

.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
EXIT_CODE = 0
TEXT_TO_PRINT_LENGTH = 512
TEXT: .ascii "Insert some text:\n"
TEXT_LENGTH = .-TEXT
WRITE_TEXT: .ascii "Your text is: \n"
WRITE_TEXT_LENGTH = .-WRITE_TEXT

.bss
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
movq $TEXT_TO_PRINT, %rsi
movq $TEXT_TO_PRINT_LENGTH, %rdx
syscall

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

