.data
two : .double 2.0

.text

.type arctgx, @function
.global arctgx
arctgx:
pushq %rbp
movq %rsp, %rbp

finit
sub $8, %rsp
movsd %xmm0, (%rsp)
fldl (%rsp)
fst %st(1)
fst %st(2)
fst %st(3)
fld1
fxch %st(1)

# ST4 - X
# ST3 - Wynik - X na starcie
# ST2 - Wyraz ciągu - X na starcie
# ST1 - Mianownik ułamka - 1.0 na starcie
# ST0 - Licznik ułamka - X na starcie

movq $0, %r8

loop:
cmpq %rdi, %r8
je end
incq %r8


fchs # Zmiana znaku licznika
fmul %st(4), %st
fmul %st(4), %st


fxch %st(1)
faddl two
fxch %st(1)

fst %st(2)
fdiv %st(1), %st
fadd %st, %st(3)
fxch %st(2)

jmp loop

end:
fxch %st(3) # Wynik do ST0
fstpl (%rsp)
movsd (%rsp), %xmm0

movq %rbp, %rsp
popq %rbp
ret
