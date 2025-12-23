global  ft_list_remove_if
extern  free

section .text
; void ft_list_remove_if(t_list **begin_list, void *data_ref,
; int (*cmp)(), void (*free_fct)(void *))
; rdi=begin_list, rsi=data_ref, rdx=cmp, rcx=free_fct

ft_list_remove_if:
    test rdi, rdi
    jz   .ret
    test rdx, rdx           ; cmp must exist
    jz   .ret

    push r12
    push r13
    push r14
    push r15
    push rbx                ; 5 pushes => stack aligned (SysV)

    mov  r12, rdi           ; r12 = begin_list**
    mov  r13, rsi           ; r13 = data_ref
    mov  r14, rdx           ; r14 = cmp
    mov  r15, rcx           ; r15 = free_fct (may be NULL)

    mov  rbx, [r12]         ; curr = *begin_list
    xor  r11d, r11d         ; prev = NULL

.loop:
    test rbx, rbx           ; curr = NULL?
    jz   .done

    ; if (cmp(curr->data, data_ref) == 0)
    mov  rdi, [rbx]         ; curr->data
    mov  rsi, r13           ; data_ref
    call r14
    cmp  eax, 0
    jne  .keep

    ; remove curr
    mov  r10, [rbx + 8]     ; next = curr->next

    test r11, r11
    jne  .unlink_mid
    mov  [r12], r10         ; *begin_list = next
    jmp  .free_node

.unlink_mid:
    mov  [r11 + 8], r10     ; prev->next = next

.free_node:
    test r15, r15
    jz   .skip_free_fct
    mov  rdi, [rbx]         ; free_fct(curr->data)
    call r15
.skip_free_fct:
    mov  rdi, rbx           ; free(curr)
    call free wrt ..plt

    mov  rbx, r10           ; curr = next (prev unchanged)
    jmp  .loop

.keep:
    mov  r11, rbx           ; prev = curr
    mov  rbx, [rbx + 8]     ; curr = curr->next
    jmp  .loop

.done:
    pop  rbx
    pop  r15
    pop  r14
    pop  r13
    pop  r12
.ret:
    ret
