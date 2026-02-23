.global _ft_atoi_base

.text
.align 2
; int ft_atoi_base(char *str, char *base)
; x0 = str, x1 = base
_ft_atoi_base:
    stp  x29, x30, [sp, #-16]!
    mov  x29, sp
    stp  x19, x20, [sp, #-16]!
    stp  x21, x22, [sp, #-16]!

    cbz  x0, .Lab_invalid
    cbz  x1, .Lab_invalid

    mov  x19, x0              ; x19 = str
    mov  x20, x1              ; x20 = base

    ; validate_base(base)
    mov  x0, x1
    bl   validate_base
    cbz  w0, .Lab_invalid

    mov  w21, w0              ; w21 = base_len
    mov  w22, #1              ; w22 = sign = 1
    mov  x0, x19              ; x0 = str

    ; skip whitespace
.Lab_skip_ws:
    ldrb w2, [x0]
    cmp  w2, #' '
    b.eq .Lab_ws_next
    cmp  w2, #9               ; tab
    b.lo .Lab_signs            ; below 9 = not whitespace
    cmp  w2, #13              ; carriage return
    b.hi .Lab_signs            ; above 13 = not whitespace
.Lab_ws_next:
    add  x0, x0, #1
    b    .Lab_skip_ws

    ; parse signs
.Lab_signs:
    ldrb w2, [x0]
    cmp  w2, #'+'
    b.eq .Lab_sign_next
    cmp  w2, #'-'
    b.ne .Lab_convert          ; neither +/-, start converting
    neg  w22, w22              ; flip sign
.Lab_sign_next:
    add  x0, x0, #1
    b    .Lab_signs

    ; convert digits
.Lab_convert:
    mov  x1, x20              ; base
    mov  w2, w21              ; base_len
    bl   read_num

    mul  w0, w0, w22          ; apply sign
    b    .Lab_done

.Lab_invalid:
    mov  w0, #0

.Lab_done:
    ldp  x21, x22, [sp], #16
    ldp  x19, x20, [sp], #16
    ldp  x29, x30, [sp], #16
    ret

; ── internal: int validate_base(char *base) ──
; Returns base length (>= 2) or 0 on invalid
; Leaf function (no bl calls)
.align 2
validate_base:
    sub  sp, sp, #272          ; checked[256] + 16 alignment
    mov  w1, #0                ; count = 0

.Lvb_loop:
    ldrb w2, [x0]
    cbz  w2, .Lvb_done
    cmp  w2, #'+'
    b.eq .Lvb_fail
    cmp  w2, #'-'
    b.eq .Lvb_fail
    cmp  w2, #32
    b.ls .Lvb_fail             ; <= space (control chars + space)
    cmp  w2, #127
    b.eq .Lvb_fail             ; DEL

    ; check for duplicates
    mov  w3, #0                ; i = 0
.Lvb_check:
    cmp  w3, w1
    b.ge .Lvb_store            ; i >= count, no dup
    ldrb w4, [sp, x3]         ; checked[i]
    cmp  w4, w2
    b.eq .Lvb_fail             ; duplicate found
    add  w3, w3, #1
    b    .Lvb_check

.Lvb_store:
    strb w2, [sp, x3]         ; checked[count] = char
    add  w1, w1, #1           ; count++
    add  x0, x0, #1           ; base++
    b    .Lvb_loop

.Lvb_done:
    cmp  w1, #2
    b.lt .Lvb_fail             ; base must have >= 2 chars
    mov  w0, w1                ; return count
    add  sp, sp, #272
    ret

.Lvb_fail:
    mov  w0, #0
    add  sp, sp, #272
    ret

; ── internal: int read_num(char *str, char *base, int base_len) ──
; Leaf function (no bl calls)
.align 2
read_num:
    mov  w3, #0                ; num = 0

.Lrn_outer:
    ldrb w4, [x0]             ; *str
    cbz  w4, .Lrn_ret
    mov  w5, #0                ; i = 0

.Lrn_inner:
    ldrb w6, [x1, x5]         ; base[i]
    cmp  w6, w4                ; base[i] == *str?
    b.eq .Lrn_found
    cbz  w6, .Lrn_ret          ; end of base, char not found
    add  w5, w5, #1
    b    .Lrn_inner

.Lrn_found:
    mul  w3, w3, w2            ; num *= base_len
    add  w3, w3, w5            ; num += i
    add  x0, x0, #1           ; str++
    b    .Lrn_outer

.Lrn_ret:
    mov  w0, w3                ; return num
    ret
