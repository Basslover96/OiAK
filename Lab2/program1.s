.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSOPEN  = 2
SYSCLOSE = 3
SYSEXIT = 60
FREAD = 0
FWRITE = 1
FILE: .asciz "data"
FILE_OUT: .asciz "output"
.bss
.comm FROM_FILE, 1024
.comm BASE_S, 516
.comm BASE_E, 1369 
.text
.globl main

main:
# Otwarcie pliku
movq $SYSOPEN, %rax
movq $FILE, %rdi
movq $FREAD, %rsi
movq $0644, %rdx
syscall

movq %rax, %r9

movq $SYSREAD, %rax
movq %r9, %rdi
movq $FROM_FILE, %rsi
movq $1024, %rdx
syscall

movq %rax, %r10 # Wczytano znaków
dec %r10

movq $SYSCLOSE, %rax
movq %r9, %rdi
syscall

movq %r10, %r11 # Licznik
xor %r12, %r12 # Licznik wyjściowy

loop:
movb FROM_FILE(,%r11,1), %al
cmpb $'A', %al
jge letter

sub $'0', %al
jmp next

letter:
sub $55, %al

next:
decq %r11
xor %ebx, %ebx
cmpq $0, %r11
jl source_file_end

movb FROM_FILE(,%r11,1), %bl

cmpb $'A', %bl
jge letter2

sub $'0', %bl
jmp to_buffer 

letter2:
sub $55, %bl
jmp to_buffer

source_file_end:
movb $0, %bl

to_buffer:
shl $4, %bl
addb %bl, %al
movb %al, BASE_S(,%r12, 1)
incq %r12
decq %r11
cmpq $0, %r11
jl to_base_eight
jmp loop

xor %r15, %r15 # Licznik ciągu wyjściowego
to_base_eight:
xor %r13, %r13 # Licznik po BASE_S
loop1:
xor %rax, %rax
movb BASE_S(,%r13,1), %al
inc %r13
xor %rbx, %rbx
movb BASE_S(,%r13,1), %bl
shl $8, %rbx
inc %r13
xor %rcx, %rcx
movb BASE_S(,%r13,1), %cl
shl $16, %rcx
orq %rcx, %rbx
orq %rbx, %rax
xor %r14, %r14 # Licznik 0-7

loop2:
xor %rbx, %rbx
movb %al, %bl
andb $0x7, %bl
addb $'0', %bl
movb %bl, BASE_E(,%r15,1)
inc %r15
inc %r14
inc %r13
cmp $516, %r13
je print
cmp $8, %r14
je loop1
shrq $3, %rax
jmp loop2

print:
movb $'\n', BASE_E(,%r15,1)

movq $SYSOPEN, %rax
movq $FILE_OUT, %rdi
movq $FWRITE, %rsi
movq $0644, %rdx
syscall

movq %rax, %r9

movq $SYSWRITE, %rax
movq %r9, %rdi
movq $BASE_E, %rsi
movq $1377, %rdx
syscall

movq $SYSCLOSE, %rax
movq %r9, %rdi
syscall

exit:
movq $SYSEXIT, %rax
movq %r9, %rdi
syscall
