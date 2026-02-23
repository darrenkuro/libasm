.global _ft_list_push_front

.text
.align 2
; void ft_list_push_front(t_list **begin_list, void *data)
; x0 = begin_list, x1 = data
; t_list: { void *data [+0], struct s_list *next [+8] }
_ft_list_push_front:
    cbz  x0, .Lpf_ret         ; if (!begin_list) return

    stp  x29, x30, [sp, #-16]!
    mov  x29, sp
    stp  x19, x20, [sp, #-16]!

    mov  x19, x0              ; save begin_list
    mov  x20, x1              ; save data

    mov  x0, #16              ; malloc(sizeof(t_list))
    bl   _malloc
    cbz  x0, .Lpf_fail        ; malloc failed

    str  x20, [x0]            ; node->data = data
    ldr  x2, [x19]            ; x2 = *begin_list
    str  x2, [x0, #8]         ; node->next = *begin_list
    str  x0, [x19]            ; *begin_list = node

.Lpf_fail:
    ldp  x19, x20, [sp], #16
    ldp  x29, x30, [sp], #16
.Lpf_ret:
    ret
