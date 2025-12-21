global  ft_list_size

section .text
; int ft_list_size(t_list *begin_list)
ft_list_size:           ; rdi *begin
	xor eax, eax        ; size

.loop:
	test rdi, rdi       ; if (*begin / rdi == NULL)
	jz   .ret
	add  eax, 1         ; better than inc, sets CF
	mov  rdi, [rdi + 8] ; begin = begin->next
	                    ; rdi + 0: data, rdi + 8: next
	jmp  .loop

.ret:
	ret
