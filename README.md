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

### Calling convention (AMD64 System V ABI)

#### Registers

- Caller-saved registers: **%rax, %rdi, %rsi, %rdx, %rcx, %rsp, %r8-11**. (The caller must save them before calling another function if it cares about their values.)
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

#### Instructions

- [ reg ] means reading data on reg as an address

```asm
xor  rax, rax     ; clear rax
mov  rax, rdi     ; rax = rdi
mov  rax, [rdi]   ; rax = *rdi
mov  [rsp], rax   ; *rsp = rax

lea  rax, [rdi+8] ; rax = rdi + 8, load addr, does not touch memory

add  rax, 1       ; preferred over inc/dec! (flag reasons)
sub  rsp, 16
imul rax, rdi     ; rax *= rdi
cqo               ; sign-extend rax → rdx
idiv rdi          ; rax = rax / rdi, rdx = remainder

test rdi, rdi     ; rdi & rdi; is rdi == 0?
cmp  rdi, rax     ; rdi - rax
jz   label        ; = je (equal, zero), ZF
jnz  label        ; = jne (not equal, not zero), !ZF
js   label        ; if negative, SF; vs. jns (if not neg)
jg/jge; jl/jle    ; >, >=; <, <=

```

#### Flags

- ZF (zero), SF (sign), CF (carry), OF (overflow)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 📫 Contact

Darren Kuro – [darren0xa@gmail.com](mailto:darren0xa@gmail.com)
GitHub: [@darrenkuro](https://github.com/darrenkuro)
