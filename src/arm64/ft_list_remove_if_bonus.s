.global _ft_list_remove_if

.text
.align 2
; void ft_list_remove_if(t_list **begin_list, void *data_ref,
;     int (*cmp)(), void (*free_fct)(void *))
; x0 = begin_list, x1 = data_ref, x2 = cmp, x3 = free_fct
_ft_list_remove_if:
    cbz  x0, .Lri_ret
    cbz  x2, .Lri_ret         ; cmp must exist

    stp  x29, x30, [sp, #-16]!
    mov  x29, sp
    stp  x19, x20, [sp, #-16]!
    stp  x21, x22, [sp, #-16]!
    stp  x23, x24, [sp, #-16]!
    str  x25, [sp, #-16]!

    mov  x19, x0              ; x19 = begin_list**
    mov  x20, x1              ; x20 = data_ref
    mov  x21, x2              ; x21 = cmp
    mov  x22, x3              ; x22 = free_fct (may be NULL)

    ldr  x23, [x19]           ; curr = *begin_list
    mov  x24, #0              ; prev = NULL

.Lri_loop:
    cbz  x23, .Lri_done

    ldr  x0, [x23]            ; curr->data
    mov  x1, x20              ; data_ref
    blr  x21                   ; cmp(curr->data, data_ref)
    cbnz w0, .Lri_keep

    ; remove curr
    ldr  x25, [x23, #8]       ; next = curr->next (callee-saved)

    cbnz x24, .Lri_unlink_mid
    str  x25, [x19]           ; *begin_list = next
    b    .Lri_free_node

.Lri_unlink_mid:
    str  x25, [x24, #8]       ; prev->next = next

.Lri_free_node:
    cbz  x22, .Lri_skip_free
    ldr  x0, [x23]            ; free_fct(curr->data)
    blr  x22

.Lri_skip_free:
    mov  x0, x23              ; free(curr)
    bl   _free

    mov  x23, x25             ; curr = next (prev unchanged)
    b    .Lri_loop

.Lri_keep:
    mov  x24, x23             ; prev = curr
    ldr  x23, [x23, #8]       ; curr = curr->next
    b    .Lri_loop

.Lri_done:
    ldr  x25, [sp], #16
    ldp  x23, x24, [sp], #16
    ldp  x21, x22, [sp], #16
    ldp  x19, x20, [sp], #16
    ldp  x29, x30, [sp], #16
.Lri_ret:
    ret
