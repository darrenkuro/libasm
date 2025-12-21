global  ft_strdup
extern  ft_strlen
extern  ft_strcpy
extern  malloc

section .text
; char *ft_strdup(char const *_Nonnull s)
ft_strdup:
	push rdi      ; save *s
	call ft_strlen; rax = strlen(s)
	add  rax, 1   ; +1 for null terminator
	mov  rdi, rax ; rdi = size
	call malloc
	test rax, rax ; malloc returned null?
	jz   .fail
	mov  rdi, rax ; dest = allocated buffer
	pop  rsi      ; src = original str
	call ft_strcpy
	ret

.fail:
	pop rdi       ; restore saved argument
	xor rax, rax  ; return 0 (null)
	ret
