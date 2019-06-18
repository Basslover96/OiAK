.data
float: .float 1.11
zero: .float 0.00

.bss
.lcomm status, 2
.lcomm control, 2

.text

.global getStatus, getControl, setControl, checkError

.type getStatus, @function
getStatus:
pushq %rbp
movq %rsp, %rbp

xor %rax, %rax
fstsw status
mov status, %ax

movq %rbp, %rsp
popq %rbp
ret

.type getControl, @function
getControl:
pushq %rbp
movq %rsp, %rbp

xor %rax, %rax
fstcw control
mov control, %ax

movq %rbp, %rsp
popq %rbp
ret

.type setControl, @function
setControl:
pushq %rbp
movq %rsp, %rbp

fstcw control
mov control, %ax

cmpq $0, %rdi
je INVALID_OPERATION

cmpq $1, %rdi
je DENORMAL_OPERAND

cmpq $2, %rdi
je ZERO_DIVIDE

cmpq $3, %rdi
je OVERFLOW

cmpq $4, %rdi
je UNDERFLOW

cmpq $5, %rdi
je PRECISION

jmp END

INVALID_OPERATION:
cmpq $0, %rsi
jg SET_INVALID

and $0xFFFE, %ax # Set 0
jmp END

SET_INVALID:
or $0x1, %ax # Set 1
jmp END

DENORMAL_OPERAND:
cmpq $0, %rsi
jg SET_DENORMAL

and $0xFFFD, %ax # Set 0
jmp END

SET_DENORMAL:
or $0x2, %ax # Set 1
jmp END

ZERO_DIVIDE:
cmpq $0, %rsi
jg SET_ZERO

and $0xFFFB, %ax # Set 0
jmp END
SET_ZERO:
or $0x4, %ax # Set 1
jmp END

OVERFLOW:
cmpq $0, %rsi
jg SET_OVERFLOW
and $0xFFF7, %ax # Set 0
jmp END
SET_OVERFLOW:
or $0x8, %ax # Set 1
jmp END

UNDERFLOW:
cmpq $0, %rsi
jg SET_UNDERFLOW
and $0xFFEF, %ax
jmp END
SET_UNDERFLOW:
or $0x10, %ax # Set 1
jmp END

PRECISION:
cmpq $0, %rsi
jg SET_PRECISION
and $0xFFDF, %ax # Set 0
jmp END
SET_PRECISION:
or $0x20, %ax # Set 1
jmp END

END:
mov %ax, control
fldcw control
movq %rbp, %rsp
popq %rbp
ret

.type checkError, @function
checkError:
pushq %rbp
movq %rsp, %rbp

finit
flds float
fdiv zero

movq %rbp, %rsp
popq %rbp
ret
