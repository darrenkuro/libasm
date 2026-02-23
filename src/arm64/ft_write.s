.global _ft_write

.text
.align 2
; ssize_t ft_write(int fd, const void *buf, size_t count)
; x0 = fd, x1 = buf, x2 = count
_ft_write:
    mov  x16, #4              ; write syscall number
    svc  #0x80
    b.cs .Lwr_error           ; carry set = error, x0 = errno
    ret

.Lwr_error:
    stp  x29, x30, [sp, #-16]!
    mov  x29, sp
    str  x19, [sp, #-16]!

    mov  x19, x0             ; save errno value
    bl   ___error             ; get errno location -> x0
    str  w19, [x0]           ; *errno_ptr = errno value

    ldr  x19, [sp], #16
    ldp  x29, x30, [sp], #16
    mov  x0, #-1             ; return -1
    ret
