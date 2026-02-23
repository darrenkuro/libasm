.global _ft_strcpy

.text
.align 2
; char *ft_strcpy(char *dest, const char *src)
; x0 = dest, x1 = src
_ft_strcpy:
    mov  x2, x0              ; save dest for return

.Lscp_loop:
    ldrb w3, [x1], #1        ; w3 = *src++
    strb w3, [x0], #1        ; *dest++ = w3
    cbnz w3, .Lscp_loop      ; if not null, continue

    mov  x0, x2              ; return original dest
    ret
