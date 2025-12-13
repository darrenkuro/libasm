section .text
global	ft_write
extern	__errno_location

ft_write:			; rdi, rsi, rdx for parameters
	mov		rax, 1	; rax - 64bits, eax - 32, using eax also works, 1 - write syscall
	syscall
	cmp		rax, 0	; rax - 0, check for neg, sets the flags
	js		errno	; check sign flag (SF) which is assigned by syscall if it's neg; in this case, jl works too
	ret

errno:
	neg		rax				; get the positive errno, how it is defined
	push	rax				; push & pop are stack ops for temp data, do not use register, implicitly QWORD
	call	__errno_location; external func to get errno addr to rax
	pop		QWORD [rax]		; pop the QWORD (8 bytes) to where rax is pointing to
	mov		rax, -1			; reset to -1
	ret
