global ft_list_sort

section .text
; void ft_list_sort(t_list **begin_list, int (*cmp)())
; (*cmp)(list_ptr->data, list_other_ptr->data)
ft_list_sort:
    push r12
    push r13
    push r14
    push r15
    push rbx

    test rdi, rdi    ; if (!begin_list)
    jz   .ret        ; return
    mov  r12, [rdi]  ; r12 = *begin_list
    test r12, r12    ; if (!*begin_list)
    jz   .ret        ; return

    mov  r13d, 1     ; swapped = 1
    mov  r15, rsi    ; cmp

.outer_loop:
    test r13d, r13d  ; swapped = 0?
    jz   .ret        ; return
    xor  r13d, r13d  ; swapped = 0
    mov  r14, r12    ; cur = *begin_list (r12)

.inner_loop:
    mov  rax, [r14 + 8] ;
    test rax, rax    ; cur->next
    jz   .outer_loop

    mov  rdi, [r14]
    mov  rsi, [rax]
    call r15
    test eax, eax
    jg   .swap
    mov  r14, [r14 + 8]
    jmp  .inner_loop

.swap:
    mov  r8,  [r14]        ; tmp = cur->data
    mov  r9,  [r14 + 8]    ; r9 = cur->next
    mov  r10, [r9]         ; r10 = cur->next->data
    mov  [r14], r10        ; cur->data = cur->next->data
    mov  [r9],  r8         ; cur->next->data = tmp
    mov  r13d, 1           ; swapped = 1
    mov  r14, [r14 + 8]    ; cur = cur->next
    jmp  .inner_loop

.ret:
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    ret
