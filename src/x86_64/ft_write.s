global  ft_write    ; Export the symbol so C code can link to it
extern  __errno_location

section .text
; ssize_t ft_write(int fd, const void *buf, size_t count)
ft_write:           ; rdi, rsi, rdx for parameters
	mov  eax, 1
	syscall         ; 1 - write syscall; rax signed, all 64 bits!
	cmp  rax, 0     ; rax - 0
	jl   .errno     ; if (rax < 0); jump if less (SF != OF)
	ret

.errno:
	neg  rax              ; get the positive errno (how it is defined)
	mov  edi, eax         ; int (4 bytes) errno in edi

    sub  rsp, 8           ; stack alignment before call
    ; external func to get errno addr to rax
	call __errno_location wrt ..plt
    add  rsp, 8           ; restore stack

	mov  DWORD [rax], edi ; restore errno to location
	mov  rax, -1          ; set return value to -1
    ret
