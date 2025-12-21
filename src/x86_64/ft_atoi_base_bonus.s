section .text
global ft_atoi_base

; int validate_base(char *base)
validate_base:    ; rdi: *base
    push r12      ; count
    push r13      ; i
    push r14      ; alignment
    sub  rsp, 256 ; checked[255]

    xor  r12d, r12d ; count = 0

    movzx eax, byte [rdi]
    test al, al
    jz   .check

    xor  r13d, r13d ; i = 0
    cmp al, '+'
    je  .invalid
    cmp al, '-'
    je  .invalid
    cmp al, ' '
    je  .invalid
    cmp al, 31
    jbe .invalid

.check_dup:


.check:
    cmp  r12d, 1
    js   .invalid
    mov  rax, r12 ; rax = count
    jmp  .ret

.invalid:
    xor  rax, rax ; rax = 0

.ret:
    add  rsp, 256
    pop  r14
    pop  r13
    pop  r12
    ret

; int ft_atoi_base(char *str, char *base)
ft_atoi_base: ; rdi: *str, rsi: *base




	; int validate_base(char *base)
	; {
	; char checked[255]
	; int  count
	; int  i

	; count = 0
	; i = 0
	; while (*base)
	; {
	; i = 0
	; if (*base == '+' || *base == '-' || (*base >= 9 && *base <= 13)
	; || *base == ' ' || *base <= 31)
	; return (0)
	; while (i < count)
	; {
	; if (*base == checked[i])
	; return (0)
	; ++i
	; }
	; checked[i] = *base
	; ++count
	; ++base
	; }
	; if (count < 1)
	; return (0)
	; return (count)
	; }

	; int read_num(char *str, char *base, int digit)
	; {
	; int num
	; int i

	; num = 0
	; while (*str)
	; {
	; i = 0
	; while (base[i] != *str)
	; {
	; if (!base[i])
	; return (num)
	; ++i
	; }
	; num = num * digit + i
	; ++str
	; }
	; return (num)
	; }

	; int ft_atoi_base(char *str, char *base)
	; {
	; int digit
	; int neg

	; neg = 1
	; digit = validate_base(base)
	; if (digit == 0)
	; return (0)
	; while (*str == ' ' || (*str >= 9 && *str <= 13))
	; ++str
	; while (*str == '+' || *str == '-')
	; {
	; if (*str == '-')
	; neg = -neg
	; ++str
	; }
	; return (neg * read_num(str, base, digit))
	; }
