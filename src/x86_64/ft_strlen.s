global  ft_strlen

section .text
; size_t ft_strlen(const char *s);
ft_strlen:
	xor rax, rax           ; set rax to 0

.check:
	cmp BYTE [rdi + rax], 0; [rdi]: *s, s[i] == *(s + i)
	je  .ret
	add rax, 1             ; preferred over inc
	jmp .check

.ret:
	ret
