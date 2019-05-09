.data

.text
.type caesar, @function
.globl caesar
caesar:
pushq %rbp
movq %rsp, %rbp

xor %r8, %r8
xor %rbx, %rbx
movq %rdx, %r9
movq $10, %r10

loop:
movb (%rdi, %r8, 1), %bl # Znak do bl
subb $'0', %bl
cmpb $0, %bl
jl save
cmpb $9, %bl
jg save
addq %r9, %rbx
xor %rdx, %rdx
movq %rbx, %rax
movq %r10, %rcx
divq %r10
movq %rdx, %rbx
addb $'0', %bl
save:
movb %bl, (%rdi, %r8, 1)
incq %r8
cmpq %rsi, %r8
jne loop

movq %rbp, %rsp
popq %rbp
ret
