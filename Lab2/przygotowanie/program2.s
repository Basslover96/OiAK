.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
TEXT: .ascii "Insert hex number:\n"
TEXT_LENGTH = .-TEXT

.bss
.comm A_INPUT, 1025
.comm B_INPUT, 1025
.comm A_HEX, 512
.comm B_HEX, 512
.comm SUM, 512
.comm RESULT, 1025 

.text
.globl main

main:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $TEXT, %rsi
movq $TEXT_LENGTH, %rdx
syscall

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $A_INPUT, %rsi
movq $1025, %rdx
syscall

movq %rax, %r9
subq $2, %r9
movq %r9, %r11
xor %r12, %r12

convert_to_number_A:
movb A_INPUT(,%r11,1), %al
cmpb $'A', %al
jge letter_A

sub $'0', %al
jmp next_letter_A

letter_A:
sub $55, %al

next_letter_A:
decq %r11
xor %ebx, %ebx
cmpq $0, %r11
jl A_input_end

movb A_INPUT(,%r11,1), %bl

cmpb $'A', %bl
jge letter_2_A

sub $'0', %bl
jmp to_buffer_A

letter_2_A:
sub $55, %bl
jmp to_buffer_A

A_input_end:
movb $0, %bl

to_buffer_A:
shl $4, %bl
addb %bl, %al
movb %al, A_HEX(,%r12, 1)
incq %r12
decq %r11
cmpq $0, %r11
jge convert_to_number_A

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $TEXT, %rsi
movq $TEXT_LENGTH, %rdx
syscall

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $B_INPUT, %rsi
movq $1025, %rdx
syscall

movq %rax, %r10
subq $2, %r10
movq %r10, %r11
xor %r12, %r12

convert_to_number_B:
movb B_INPUT(,%r11,1), %al
cmpb $'A', %al
jge letter_B

sub $'0', %al
jmp next_letter_B

letter_B:
sub $55, %al

next_letter_B:
decq %r11
xor %ebx, %ebx
cmpq $0, %r11
jl B_input_end

movb B_INPUT(,%r11,1), %bl

cmpb $'A', %bl
jge letter_2_B

sub $'0', %bl
jmp to_buffer_B

letter_2_B:
sub $55, %bl
jmp to_buffer_B

B_input_end:
movb $0, %bl

to_buffer_B:
shl $4, %bl
addb %bl, %al
movb %al, B_HEX(,%r12, 1)
incq %r12
decq %r11
cmpq $0, %r11
jge convert_to_number_B

clc
pushf
xor %r13, %r13
add_loop:
xor %rax, %rax
xor %rbx, %rbx
movb A_HEX(,%r13,1), %al
movb B_HEX(,%r13,1), %bl
popf
adc %bl, %al
pushf
movb %al, SUM(,%r13,1)
inc %r13
cmpq $512, %r13
jne add_loop

xor %r14, %r14
movq $1024, %r15

print:
movb SUM(,%r14,1), %al
movb %al, %bl
andb $0xF, %bl
addb $'0', %bl
cmpb $'9', %bl
jle write_first
addb $7, %bl
write_first:
movb %bl, RESULT(,%r15,1)
decq %r15
shr $4, %al
movb %al, %bl
andb $0xF, %bl
addb $'0', %bl
cmpb $'9', %bl
jle write_second
addb $7, %bl
write_second:
movb %bl, RESULT(,%r15,1)
decq %r15
incq %r14
cmpq $512, %r14
jne print

jnc show_result
movq $0, %rax
movb $'1', RESULT(,%rax,1)

show_result:
movq $1025, %rax
movb $'\n', RESULT(,%rax,1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $RESULT, %rsi
movq $1026, %rdx
syscall

exit:
movq $SYSEXIT, %rax
movq %r9, %rdi
syscall
