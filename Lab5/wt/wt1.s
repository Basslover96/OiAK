# Liczenie e^x z rozszerzenia szeregu Taylora

.data
silnia: .double 0.0

.text

.type ex, @function
.global ex
ex:
pushq %rbp
movq %rsp, %rbp

# XMM0 - x
# RDI - liczba kroków

finit
sub $8, %rsp
movsd %xmm0, (%rsp)
fldl (%rsp)
fld1
fld1
fld1
fld1
movq $0, %r8

# ST4 - X
# ST3 - Wynik (1.0 na starcie)
# ST2 - Wyraz ciągu (1.0 na starcie)
# ST1 - Mianownik ułamka (1.0 na starcie)
# ST0 - Licznik ułamka (1.0 na starcie)

loop:
cmpq %rdi, %r8
je end
incq %r8

fmul %st(4), %st # Licznik w ST0

fldl silnia # (silnia w ST0, Licznik w ST1, ...)
fld1 # (1.0 w ST0, silnia w ST1, Licznik w ST2, ...)
fadd %st, %st(1) # Silnia + 1 w ST1
fstp %st # (Silnia + 1 w ST0, Licznik w ST1, Mianownik w ST2, ...)
fmul %st, %st(2) # Nowa wartość mianownika w ST2
fstpl silnia # Silnia + 1 zapisana w pamięci

fst %st(2)
fxch %st(2)
fdiv %st(1), %st # Licznik / Mianownik = Wyraz ciągu
fxch %st(2)
fxch %st(3)
fadd %st(2), %st
fxch %st(3)

jmp loop

end:
fxch %st(3) # Wynik do ST0
fstpl (%rsp)
movsd (%rsp), %xmm0

movq %rbp, %rsp
popq %rbp
ret
