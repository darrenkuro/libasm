section	.text
global	ft_strdup
extern	ft_strlen
extern	ft_strcpy
extern	malloc

ft_strdup:
	push	rdi       ; save *s
	call	ft_strlen ; rax = strlen(s)
    add     rax, 1    ; +1 for null terminator
	mov		rdi, rax  ; rdi = size
	call	malloc
    test    rax, rax  ; malloc returned null?
	jz		.fail
	mov		rdi, rax  ; dest = allocated buffer
	pop		rsi       ; src = original str
	call	ft_strcpy
	ret

.fail:
    pop     rdi       ; restore saved argument
	xor     rax, rax
	ret
