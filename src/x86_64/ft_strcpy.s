global  ft_strcpy

section .text
; char *ft_strcpy(char *dest, const char *src);
ft_strcpy:
	mov  rax, rdi  ; ret = dest

.copy:
	mov  dl, [rsi] ; BYTE implied
	mov  [rdi], dl ; BYTE implied
	add  rsi, 1    ; src++
	add  rdi, 1    ; dest++
	test dl, dl    ; null byte?
	jnz  .copy
	ret
