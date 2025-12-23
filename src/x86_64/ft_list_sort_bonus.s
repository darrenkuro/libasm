global ft_list_sort

section .text
; void ft_list_sort(t_list **begin_list, int (*cmp)())
; (*cmp)(list_ptr->data, list_other_ptr->data)
ft_list_sort:
    push r12             ; *begin_list
    push r13             ; swapped
    push r14             ; cur
    push r15             ; cmp
    push rbx

    test rdi, rdi        ; if (!begin_list)
    jz   .done           ; return
    test rsi, rsi        ; if (!cmp)
    jz   .done           ; return
    mov  r12, [rdi]      ; r12 = *begin_list
    test r12, r12        ; if (!*begin_list)
    jz   .done           ; return

    mov  r13d, 1         ; swapped = 1
    mov  r15, rsi        ; cmp

.outer_loop:
    test r13d, r13d      ; swapped = 0?
    jz   .done           ; return
    xor  r13d, r13d      ; swapped = 0
    mov  r14, r12        ; cur = *begin_list (r12)

.inner_loop:
    mov  rbx, [r14 + 8]  ; rbx = cur->next
    test rbx, rbx        ; !cur->next
    jz   .outer_loop

    mov  rdi, [r14]      ; cur->data
    mov  rsi, [rbx]      ; cur->next->data
    call r15
    cmp  eax, 0          ; if cmp > 0
    jg   .swap           ; swap
    mov  r14, rbx        ; cur = cur->next
    jmp  .inner_loop

.swap:
    mov  r8, [r14]       ; r8 [tmp] = cur->data
    mov  r9, rbx         ; r9 = cur->next
    mov  r10, [r9]       ; r10 = cur->next->data
    mov  [r14], r10      ; cur->data = cur->next->data
    mov  [r9], r8        ; cur->next->data = tmp
    mov  r13d, 1         ; swapped = 1
    mov  r14, rbx        ; cur = cur->next
    jmp  .inner_loop

.done:
    pop  rbx
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
