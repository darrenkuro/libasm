.global _ft_strdup

.text
.align 2
; char *ft_strdup(const char *s)
; x0 = s
_ft_strdup:
    stp  x29, x30, [sp, #-16]!
    mov  x29, sp
    str  x19, [sp, #-16]!

    mov  x19, x0             ; x19 = s (callee-saved)

    bl   _ft_strlen           ; x0 = strlen(s)
    add  x0, x0, #1          ; +1 for null terminator
    bl   _malloc              ; x0 = malloc(len + 1)
    cbz  x0, .Lsd_done       ; if NULL, return NULL

    mov  x1, x19             ; src = original s
    bl   _ft_strcpy           ; ft_strcpy(dest=x0, src=x1), returns dest

.Lsd_done:
    ldr  x19, [sp], #16
    ldp  x29, x30, [sp], #16
    ret
