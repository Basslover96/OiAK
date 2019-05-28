.data

.bss

.text

.global fastSSE, getCycle

.type fastSSE, @function
fastSSE:
pushq %rbp
movq %rsp, %rbp

xor %r8, %r8

loop:
movups (%rdi, %r8, 4), %xmm0
movups (%rdi, %r8, 4), %xmm1
addps %xmm1, %xmm0
movups %xmm0, (%rdi, %r8, 4)

addq $4, %r8
cmpq %rsi, %r8
jl loop

movq %rbp, %rsp
popq %rbp
ret

.type getCycle, @function
getCycle:
pushq %rbp
movq %rsp, %rbp

rdtsc
shl $32, %rdx
orq %rdx, %rax

movq %rbp, %rsp
popq %rbp
ret
