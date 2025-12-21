global  ft_read
extern  __errno_location

section .text
; ssize_t ft_read(int fd, void *buf, size_t count)
ft_read:                 ; rdi, rsi, rdx for parameters
	mov  eax, 0          ; 0 - read syscall
	syscall
	test eax, eax        ; sign check
	js   .errno          ; jump if signed (neg)
	ret

.errno:
	neg  eax              ; get the positive errno, how it is defined
	mov  edi, eax         ; save errno in edi (knowing errno_location signature)
	                      ; if using stack, need to ensure alignment
	call __errno_location wrt ..plt
	mov  [rax], edi       ; restore errno to location, DWORD implictly due to edi
	mov  rax, -1          ; set return value to -1
	ret
