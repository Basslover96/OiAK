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

movq %rax, %r9
dec %r9

# Zakończenie działania programu.
movq $SYSEXIT, %rax
movq %r9, %rdi
syscall
