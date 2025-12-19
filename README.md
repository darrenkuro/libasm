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
- Caller-saved registers: **%rax, %rdi, %rsi, %rdx, %rcx, %rsp, %r8-11**. (The caller must save them before calling another function if it cares about their values.)
- Callee-saved registers: **%rbx, %rbp, %r12-15**. (The callee must save their values on entry and restore them before returning if it wants to use them.)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 📫 Contact

Darren Kuro – [darren0xa@gmail.com](mailto:darren0xa@gmail.com)
GitHub: [@darrenkuro](https://github.com/darrenkuro)
