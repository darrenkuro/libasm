<h1 align="center">Libasm</h1>

<p align="center">
    <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square&logo=opensourceinitiative&logoColor=white" alt="License"/>
    <img src="https://img.shields.io/badge/status-development-brightgreen?style=flat-square&logo=git&logoColor=white" alt="Status">
    <!-- <img src="https://img.shields.io/badge/score-125%2F100-3CB371?style=flat-square&logo=42&logoColor=white" alt="Score"/> -->
    <!-- <img src="https://img.shields.io/badge/date-May%2026%2C%202023-ff6984?style=flat-square&logo=Cachet&logoColor=white" alt="Date"/> -->
</p>

> A collection of simple functions implemented in assembly for both macOS and Linux.

---

## 🚀 Overview

Libasm is a small library written entirely in assembly, re-implementing a subset of standard C library functions such as strlen, strcpy, strcmp, strdup, read, and write. The goal of this project is to gain a deeper understanding of low-level system operations and learn the basics of assembly.

## 🧰 Tech Stack: ![Assembly](https://img.shields.io/badge/-Assembly-000000?style=flat-square&logo=assemblyscript&logoColor=white) ![Make](https://img.shields.io/badge/-Make-000000?style=flat-square&logo=gnu&logoColor=white)

## 📦 Features

---

## 🛠️ Configuration

### Prerequisites

### Installation & Usage

### Examples & Demo

### Development

---

## 📝 Notes & Lessons

- In ASM, call = push & jmp, ret = pop & jmp; in terms of labels, there is no difference between a portion and a "function", they are all just addresses. Only the global ones are exported and visible to outside of the file, think of everything else like `static`.
- The 128 bytes below rsp are guaranteed not to be clobbered by interrupts, and the compiler is allowed to use them without adjusting rsp.
- `wrt ..plt` [`with respect to the Procedure Linkage Table`], NASM syntax; for PIE (position independent executable), all external functions (i.e. libc) should have this.

### Calling convention (AMD64 System V ABI)

#### Registers

- Caller-saved registers: **%rax, %rdi, %rsi, %rdx, %rcx, %r8-11**. (The caller must save them before calling another function if it cares about their values.)
- Callee-saved registers: **%rbx, %rbp, %r12-15**. (The callee must save their values on entry and restore them before returning if it wants to use them.)
  | | 64 bit | 32 bit | 16 bit | 8 bit |
  | ----------------------- | ------ | ------ | ------ | ----- |
  | | QWORD | DWORD | WORD | BYTE |
  | A (accumulator) | `RAX` | `EAX` | `AX` | `AL` |
  | B (base, addressing) | `RBX` | `EBX` | `BX` | `BL` |
  | C (counter, iterations) | `RCX` | `ECX` | `CX` | `CL` |
  | D (data) | `RDX` | `EDX` | `DX` | `DL` |
  | | `RDI` | `EDI` | `DI` | `DIL` |
  | | `RSI` | `ESI` | `SI` | `SIL` |
  | Numbered (n=8..15) | `Rn` | `RnD` | `RnW` | `RnB` |
  | Stack pointer | `RSP` | `ESP` | `SP` | `SPL` |
  | Frame pointer | `RBP` | `EBP` | `BP` | `BPL` |

- QWORD: mostly addr & pointer, size_t, ssize_t; DWORD: int, unsigned int, errno, syscall number; BYTE: char; WORD: short (rare)
- Parameters: `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`.
- imm (immediate value), coded inside the instruction; imm8 (1-byte), imm32 (4-bytes), etc.
- REX prefix, 1 byte indicator 0b0100xxxx used only in x86-64 mode, extending the old x86 instruction encoding so the CPU can use 64-bit operands, access more registers (r8-r15). 0x40-0x4F. 0100WRXB, each bit has a meaning; w = width, 1 is 64 bits, B is reg + 8 (r8-r15). REX.W = 0x48 Meaning 64-bit operand size. e.g. `48 b8` will be `mov r, imm64` (read next 8 bytes) vs `b8` will be `mov r, imm32` (read next 4 bytes). At most one REX prefix per instruction, if multiple, last one wins; REX must come after legacy prefixes and before opcode.
- Compiler optimizes often, give strict `mov  eax, strict DWORD 1` vs `mov  rax, strict QWORD 1` then you can see the difference in machine code.
- Writing to `al` modifies only 8 bits, writing to `ax` only 16 bits, rest remain unchanged; writing to `eax` modifies all 64 bites (via zero-extension). Full width writes (4 bytes) better than partial (2/1), even though you can technically do `xor rax, rax; mov al, strict BYTE 1` = `mov eax, 1`.
- `31 c0` = `xor eax, eax`. So `48 31 c0` = `xor rax, rax`. Incidentally, anything written to `eax` will zero extend to the full register, so both of these are functionally identical on x86-64.
- Stack operations are all full width (8 bytes).
- Sign extension, when expanding to 64 bits for instance from 32, preserving the sign bits so value is perserved. `movsx` move with sign extension vs `movzx` move with zero extension.

#### Instructions

- [ reg ] means reading data on reg as an address

```asm
xor  rax, rax     ; clear rax
mov  rax, rdi     ; rax = rdi
mov  rax, [rdi]   ; rax = *rdi
mov  [rsp], rax   ; *rsp = rax

lea  rax, [rdi+8] ; rax = rdi + 8, load addr, does not touch memory

leave             ; = mov rsp, rbp, pop rbp

add  rax, 1       ; preferred over inc/dec! (It update CF)
sub  rsp, 16
imul rax, rdi     ; rax *= rdi
cqo               ; sign-extend rax → rdx
idiv rdi          ; rax = rax / rdi, rdx = remainder

test rdi, rdi     ; rdi & rdi; is rdi == 0?
cmp  rdi, rax     ; rdi - rax
jz   label        ; = je (equal, zero), ZF
jnz  label        ; = jne (not equal, not zero), !ZF
js   label        ; if negative, SF; vs. jns (if not neg)
jg/jge; jl/jle    ; >, >=; <, <= (signed) greater/less
ja/jae; jb/jbe    ; >, >=; <, <= (unsigned) above/below

```

#### Flags

- Flags are `single-bit` values stored in a special CPU register `RFLAGS`. They are set automatically by the ALU, used by jmp, set, cmov, etc.
- `CF` Carry Flag, unsigned overflow. `ja/jae/jb/jbe`
- `ZF` Zero Flag, is 0? `je/jz/jne/jnz`
- `SF` Sign Flag, is neg? Copy of most significant bit. `js/jns`
- `OF` Overflow Flag, signed; compare to unsigned, one less bit. `jl/jg/jle/jge`

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 📫 Contact

Darren Kuro – [darren0xa@gmail.com](mailto:darren0xa@gmail.com)
GitHub: [@darrenkuro](https://github.com/darrenkuro)
