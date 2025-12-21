section .text
global  ft_list_remove_if
extern  free

; void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *))
; (*cmp)(list_ptr->data, data_ref);
; (*free_fct)(list_ptr->data);
ft_list_remove_if:  ; rdi = begin_list, rsi = data_ref, rdx = cmp, rcx = free_fct
	test rdi, rdi   ; if (!begin_list) return
	jz   .ret
	mov  r8, [rdi]  ; if (!*begin_list) return
	test r8, r8
	jz   .ret

    push r12
    push r13
    push r14
    push r15
	push rdi        ; begin_list  rsp +24
	push rsi        ; data_ref    rsp +16
	push rdx        ; cmp         rsp +8
	push rcx        ; free_fct    rsp +0

	mov r12, [rdi]   ; curr = *being_list
	xor r9, r9      ; prev = NULL

.loop:
	test r8, r8     ; curr = NULL?
	jz   .done

	; call cmp(curr->data, data_ref)
	mov  rdi, [r8]    ; curr->data
	mov  rsi, [rsp+16]; data_ref
	call [rsp+8]      ; cmp

	test eax, eax     ; if not equal
	jne  .next        ; next

	mov  r10, r8      ; tmp = curr
	mov  r11, [r8+8]  ; next = curr->next

	test r9, r9       ; if prev != NULL
	jne  .unlink_mid  ;

	;   removing head
	mov rdi, [rsp+24] ; begin_list
	mov [rdi], r11
	jmp .free_node

.unlink_mid:
	mov [r9+8], r11   ; prev->next = next

.free_node:
	mov  r8, r11      ; curr = next
	mov  rdi, [r10]   ; free_fct(tmp->data)
	call [rsp]
	mov  rdi, r10     ; free(tmp)
	call free
	jmp .loop

.next:
	mov r9, r8    ; prev = curr
	mov r8, [r8+8]; curr = curr->next
	jmp .loop

.done:
	add rsp, 32   ; clean stack

.ret:
	ret
