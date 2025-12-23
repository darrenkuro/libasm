global  ft_read
extern  __errno_location

section .text
; ssize_t ft_read(int fd, void *buf, size_t count)
ft_read:
	mov  eax, 0    ; 0 - read syscall
	syscall
	cmp  rax, 0
	jl   .errno    ; if (rax < 0)
	ret

.errno:
	neg  rax
	mov  edi, eax

    sub  rsp, 8    ; stack alignment
	call __errno_location wrt ..plt
    add  rsp, 8    ; restore stack

	mov  DWORD [rax], edi
	mov  rax, -1
	ret
