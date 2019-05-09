.data
STDOUT = 1
SYSWRITE = 1
SYSEXIT = 60
W = 6
H = 5
STAR: .asciz "*"
STAR_LEN = .-STAR
SPACE: .asciz " "
SPACE_LEN = .-SPACE
NEW_LINE: .asciz "\n"
NEW_LINE_LEN = .-NEW_LINE

.bss

.text
.globl main

main:

xor %r8, %r8 # Przesunięcie w linii
movq %r8, %r9 # Licznik pętli dla przesunięcia
movq $W, %r10 # Licznik pętli dla gwiazdek
movq $W, %r13 # Stała 
movq $H, %r12 # Wysokość

loop_space:
cmpq $0, %r12
je end
cmpq $0, %r9
je loop_stars
movq $SPACE, %rsi
movq $SPACE_LEN, %rdx
call write
decq %r9
jmp loop_space

loop_stars:
movq $STAR, %rsi
movq $STAR_LEN, %rdx
call write
decq %r10
cmpq $0, %r10
jne loop_stars

movq $NEW_LINE, %rsi
movq $NEW_LINE_LEN, %rdx
call write
decq %r12
movq %r13, %r10
incq %r8
movq %r8, %r9
jmp loop_space


end:
movq $SYSEXIT, %rax
movq $0, %rdx
syscall

.type write, @function
write:
# W %rsi ciąg do wypisania, w %rdx długość ciągu.
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
syscall
ret

