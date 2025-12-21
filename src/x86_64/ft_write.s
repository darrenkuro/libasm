global  ft_write          ; Export the symbol so C code can link to it
extern  __errno_location

section .text
; ssize_t ft_write(int fd, void const *buf, size_t count)
ft_write:                 ; rdi, rsi, rdx for parameters
	mov  eax, 1           ; eax is the smallest encoding with gurantee safety
	syscall               ; 1 - write syscall
	test eax, eax         ; check sign
	js   .errno           ; jump if signed (neg)
	ret

.errno:
	neg  eax              ; get the positive errno, how it is defined
	mov  edi, eax         ; save errno in edi (knowing errno_location signature)
	                      ; if using stack, need to ensure alignment
	call __errno_location ; external func to get errno addr to rax
	mov  [rax], edi       ; restore errno to location, DWORD implictly due to edi
	mov  rax, -1          ; set return value to -1
	ret
