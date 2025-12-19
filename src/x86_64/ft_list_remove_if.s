section .text
global  ft_list_remove_if
extern  free

	;    void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)()
	;    void (*free_fct)(void *))
	ft_list_remove_if:       ; rdi = begin_list, rsi = data_ref, rdx = cmp, rcx = free_fct
	test rdi, rdi; if (!begin_list) return
	jz   .ret
	mov  r8, [rdi]; if (!*begin_list) return
	test r8, r8
	jz   .ret

	push rdi; begin_list
	push rsi; data_ref
	push rdx; cmp
	push rcx; free_fct

	mov r8, [rdi]; curr = *being_list
	xor r9, r9; prev = NULL

.loop:
	test r8, r8; curr = NULL?
	jz   .done

	;    call cmp(curr->data, data_ref)
	mov  rdi, [r8]; curr->data
	mov  rsi, [rsp+24]; data_ref
	call [rsp+16]; cmp

	test eax, eax
	jne  .keep

	mov r10, r8; tmp = curr
	mov r11, [r8+8]; next = curr->next

	test r9, r9
	jne  .unlink_mid

	;   removing head
	mov rdi, [rsp+32]; begin_list
	mov [rdi], r11
	jmp .free_node

.unlink_mid:
	mov [r9+8], r11

.free_node:
	mov  r8, r11; curr = next
	mov  rdi, [r10]
	call [rsp]; free_fct
	mov  rdi, r10
	call free

	jmp .loop

.keep:
	mov r9, r8; prev = curr
	mov r8, [r8+8]; curr = curr->next
	jmp .loop

.done:
	add rsp, 32; clean stack

.ret:
	ret

	; {
	; t_list *curr
	; t_list *prev
	; t_list *tmp

	; if (!begin_list || !*begin_list)
	; return

	; curr = *begin_list
	; prev = (void *) 0
	; while (curr)
	; {
	; if (cmp(curr->data, data_ref) == 0)
	; {
	; tmp = curr
	; if (prev)
	; prev->next = curr->next
	; else
	; *begin_list = curr->next
	; curr = curr->next
	; free_fct(tmp->data)
	; free(tmp)
	; }
	; else
	; {
	; prev = curr
	; curr = curr->next
	; }
	; }
	; }
