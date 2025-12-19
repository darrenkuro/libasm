section .text
global ft_strlen

ft_strlen:
	xor		rax, rax ; set rax to 0

check:
	cmp 	byte [rdi + rax], 0 ; [rdi]: *s, s[i] == *(s + i)
	je		return ;
	inc 	rax    ; i++
	jmp		check

return:
	ret
