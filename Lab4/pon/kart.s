.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
W = 5
STAR: .asciz "*"
STAR_LEN = .-STAR
NEW_LINE: .asciz "\n"
NEW_LINE_LEN = .-NEW_LINE

.bss

.text
.globl main

main:
movq $W, %rax
movq $2, %rbx
mulq %rbx
subq $1, %rax

movq $0, %r12 # Czy rośnie
movq %rax, %r10 # Wysokość
movq $W, %r8 # Licznik w linii
movq $W, %r9 # Długość linii
loop:
call write
decq %r8
cmpq $0, %r8
jne loop
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $NEW_LINE, %rsi
movq $NEW_LINE_LEN, %rdx
syscall
decq %r10
cmpq $0, %r10
je end
cmpq $1, %r12
je increase
decq %r9
cmpq $0, %r9
je add_two
jmp next
add_two:
inc %r9
increase:
movq $1, %r12
incq %r9
next:
movq %r9, %r8
jmp loop

end:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall

.type write, @function
write:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $STAR, %rsi
movq $STAR_LEN, %rdx
syscall
ret
