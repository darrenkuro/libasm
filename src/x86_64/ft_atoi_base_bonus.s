section .text
global ft_atoi_base

; int ft_atoi_base(char *str, char *base)
ft_atoi_base: ; rdi = *str, rsi = *base
    push r12       ; digit
    push r13       ; neg
    push r14       ;
    push r15       ;
    sub  rsp, 8    ; stack alignment
    mov  r14, rdi  ; r14 = *str
    mov  r15, rsi  ; r15 = *base

    test rdi, rdi
    jz .invalid
    test rsi, rsi
    jz .invalid

    ; validate_base(base)
    mov  rdi, rsi
    call validate_base
    test eax, eax
    jz   .invalid
    mov  r12d, eax ; r12d = digit
    mov  r13d, 1   ; r13d = neg = 1
    mov  rdi, r14  ; restore *str to rdi

.skip_ws:          ; skip whitespaces
    movzx eax, BYTE [rdi]
    cmp   al, ' '
    je    .ws_next
    cmp   al, 9     ; if *s < 9
    jb    .signs
    cmp   al, 13    ; if *s > 13
    ja    .signs
.ws_next:
    add   rdi, 1
    jmp   .skip_ws

.signs:
    movzx eax, BYTE [rdi]
    cmp   al, '+'   ; if *s == '+'
    je    .sign_next
    cmp   al, '-'   ; if *s != '-'
    jne   .convert  ; neither [+-], break
    neg   r13d      ; *s == '-'
.sign_next:
    add   rdi, 1
    jmp   .signs

.convert:
    mov  rsi, r15   ; restore *base to rsi
    mov  edx, r12d  ; digit
    call read_num

    imul eax, r13d
    jmp  .done

.invalid:
    xor eax, eax    ; set return to 0

.done:
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    ret

; int validate_base(char *base)
validate_base:    ; rdi = *base, returns eax
    sub  rsp, 264 ; checked[256] + alignment
    xor  eax, eax ; count = 0

.vb_loop:
    movzx ecx, BYTE [rdi]
    test cl, cl
    jz   .vb_done
    cmp  cl, '+'
    je   .vb_fail
    cmp  cl, '-'
    je   .vb_fail
    cmp  cl, 32
    jbe  .vb_fail
    cmp  cl, 127
    je   .vb_fail
    xor  edx, edx  ; i = 0

.vb_check:
    cmp  edx, eax
    jge  .vb_store  ; if i >= count, break
    mov  r8b, [rsp + rdx] ; r8b = checked[i]
    cmp  r8b, cl
    je   .vb_fail
    add  edx, 1    ; i++
    jmp  .vb_check

.vb_store:
    mov  [rsp + rdx], cl
    add  eax, 1    ; count++
    add  rdi, 1    ; base++
    jmp  .vb_loop

.vb_done:
    cmp  eax, 2
    jb   .vb_fail
    add  rsp, 264
    ret

.vb_fail:
    xor  eax, eax
    add  rsp, 264
    ret

; int read_num(char *str, char *base, int digit)
read_num: ; rdi, rsi, rdx
    xor eax, eax   ; num = 0

.rn_loop1:
    movzx ecx, BYTE [rdi]
    test  cl, cl
    jz    .rn_ret
    xor   r8d, r8d ; i =0

.rn_loop2:
    mov  r9b, [rsi + r8d] ; r9 = base[i]
    cmp  r9b, cl
    je   .rn_next
    test r9b, r9b
    jz   .rn_ret
    add  r8d, 1
    jmp  .rn_loop2

.rn_next:
    imul eax, edx  ; num*=digit
    add  eax, r8d  ; num+=i
    add  rdi, 1    ; str++
    jmp  .rn_loop1

.rn_ret:
    ret
