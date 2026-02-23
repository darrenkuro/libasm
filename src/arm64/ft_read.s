.global _ft_read

.text
.align 2
; ssize_t ft_read(int fd, void *buf, size_t count)
; x0 = fd, x1 = buf, x2 = count
_ft_read:
    mov  x16, #3              ; read syscall number
    svc  #0x80
    b.cs .Lrd_error           ; carry set = error, x0 = errno
    ret

.Lrd_error:
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
