.global _ft_strcmp

.text
.align 2
; int ft_strcmp(const char *s1, const char *s2)
; x0 = s1, x1 = s2
_ft_strcmp:
.Lsc_cmp:
    ldrb w2, [x0], #1        ; w2 = *s1++
    ldrb w3, [x1], #1        ; w3 = *s2++
    cmp  w2, w3
    b.ne .Lsc_done            ; if different, done
    cbnz w2, .Lsc_cmp         ; if not null, continue

.Lsc_done:
    sub  w0, w2, w3           ; return difference
    ret
