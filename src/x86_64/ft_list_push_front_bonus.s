global  ft_list_push_front
extern  malloc

section .text
; void ft_list_push_front(t_list **begin_list, void *data)
ft_list_push_front:    ; rdi = begin_list, rsi = data
	test rdi, rdi      ; if (!begin_list)
	jz   .ret

	push rdi           ; save begin_list
	push rsi           ; save data

	mov  edi, 16       ; malloc(sizeof(t_list)) → malloc(16)
	call malloc
	test rax, rax
	jz   .fail         ; malloc failed

	pop rsi            ; restore data
	pop rdi            ; restore begin_list

	mov [rax], rsi     ; node->data = data

	mov rcx, [rdi]
	mov [rax + 8], rcx ; node->next = *begin_list

	mov [rdi], rax     ; *begin_list = node

.ret:
	ret

.fail:
	add rsp, 16        ; clean stack on malloc failure
	ret
