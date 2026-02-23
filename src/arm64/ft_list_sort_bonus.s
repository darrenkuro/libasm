.global _ft_list_sort

.text
.align 2
; void ft_list_sort(t_list **begin_list, int (*cmp)())
; x0 = begin_list, x1 = cmp
; Bubble sort swapping data pointers
_ft_list_sort:
    cbz  x0, .Lso_ret         ; if (!begin_list) return
    cbz  x1, .Lso_ret         ; if (!cmp) return

    stp  x29, x30, [sp, #-16]!
    mov  x29, sp
    stp  x19, x20, [sp, #-16]!
    stp  x21, x22, [sp, #-16]!
    str  x23, [sp, #-16]!

    ldr  x19, [x0]            ; x19 = *begin_list (head)
    cbz  x19, .Lso_done       ; if (!*begin_list) return

    mov  x20, x1              ; x20 = cmp
    mov  w21, #1              ; w21 = swapped = 1

.Lso_outer:
    cbz  w21, .Lso_done       ; if !swapped, done
    mov  w21, #0              ; swapped = 0
    mov  x22, x19             ; cur = head

.Lso_inner:
    ldr  x23, [x22, #8]       ; x23 = cur->next (callee-saved)
    cbz  x23, .Lso_outer      ; if !cur->next, next pass

    ldr  x0, [x22]            ; cur->data
    ldr  x1, [x23]            ; cur->next->data
    blr  x20                   ; cmp(cur->data, cur->next->data)
    cmp  w0, #0
    b.le .Lso_no_swap

    ; swap data pointers
    ldr  x9, [x22]            ; tmp = cur->data
    ldr  x10, [x23]           ; cur->next->data
    str  x10, [x22]           ; cur->data = cur->next->data
    str  x9, [x23]            ; cur->next->data = tmp
    mov  w21, #1              ; swapped = 1

.Lso_no_swap:
    mov  x22, x23             ; cur = cur->next
    b    .Lso_inner

.Lso_done:
    ldr  x23, [sp], #16
    ldp  x21, x22, [sp], #16
    ldp  x19, x20, [sp], #16
    ldp  x29, x30, [sp], #16
.Lso_ret:
    ret
