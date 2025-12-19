section .text
global	ft_read
extern	__errno_location

ft_read:            ; rdi, rsi, rdx for parameters
	mov		rax, 0  ; 0 - read syscall
	syscall
	cmp		rax, 0  ; rax - 0 (sign check)
	js		.errno  ; jump if signed (neg)
	ret

.errno:
	neg		rax             ; get the positive errno, how it is defined
	push	rax				; push & pop are stack ops for temp data
                            ; do not use register, implicitly QWORD
	call	__errno_location; external func to get errno addr to rax
	pop		[rax]		    ; pop (rax pushed/errno) to where rax points
	mov		rax, -1			; reset to -1
	ret
