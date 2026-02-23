.global _ft_strlen

.text
.align 2
; size_t ft_strlen(const char *s)
; x0 = s
_ft_strlen:
    mov  x1, #0              ; i = 0

.Lsl_loop:
    ldrb w2, [x0, x1]        ; w2 = s[i]
    cbz  w2, .Lsl_done       ; if (s[i] == 0) done
    add  x1, x1, #1          ; i++
    b    .Lsl_loop

.Lsl_done:
    mov  x0, x1              ; return i
    ret
