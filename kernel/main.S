
.intel_syntax noprefix
.code32
.section .text

.global _start
.type _start,@function

_start:
    mov eax, 0xDEADBEEF
    nop
    jmp _start

