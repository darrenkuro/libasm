section .text
global  ft_list_size

ft_list_size:           ; rdi *begin
    xor rax, rax        ; size

.loop:
	test rdi, rdi       ; if (begin / rdi == NULL)
	jz   .ret
	add  rax, 1         ; better than inc, sets CF
	mov  rdi, [rdi + 8] ; begin = begin->next
	                    ; rdi: data, rdi + 8: next
	jmp  .loop

.ret:
	ret
