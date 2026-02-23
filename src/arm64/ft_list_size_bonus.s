.global _ft_list_size

.text
.align 2
; int ft_list_size(t_list *begin_list)
; x0 = begin_list
; t_list: { void *data [+0], struct s_list *next [+8] }
_ft_list_size:
    mov  w1, #0               ; size = 0

.Lls_loop:
    cbz  x0, .Lls_done        ; if (begin == NULL) done
    add  w1, w1, #1           ; size++
    ldr  x0, [x0, #8]        ; begin = begin->next
    b    .Lls_loop

.Lls_done:
    mov  w0, w1               ; return size
    ret
