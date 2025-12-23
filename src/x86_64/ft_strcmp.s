global  ft_strcmp

section .text
; int ft_strcmp(const char *s1, const char *s2);
ft_strcmp:
.cmp:
	movzx eax, BYTE [rdi] ; eax = (unsigned char)*s1
	movzx ecx, BYTE [rsi] ; ecx = (unsigned char)*s2
	cmp   eax, ecx
	jne   .done           ; difference found
	test  eax, eax
	jz    .done           ; both are '\0'
	add   rdi, 1
	add   rsi, 1
	jmp   .cmp

.done:
	sub   eax, ecx        ; return difference
	ret
