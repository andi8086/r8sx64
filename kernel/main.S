
.intel_syntax noprefix
.code32
.section .text

.global _start
.global k_gdt_descriptor
.global realcall
.global retfromrealcall16
.type _start,@function

.extern kmain

_start:
    mov eax, 0x10
    mov ds, eax

    lea eax, k_gdt
    mov [k_gdt_offset], eax
    lgdt [k_gdt_descriptor]

    mov eax, 0x10
    mov ds, eax
    mov es, eax
    mov fs, eax
    mov gs, eax
    mov eax, 0x18
    mov ss, eax
    mov esp, 0x7BFF
    mov ebp, esp

    mov eax, 0xDEADBEEF

    call kmain
_hold:
    nop
    jmp _hold

realcall:
    pushad
    push es
    
    mov eax, esp
    mov [stack_pointer], eax

    # Disable IRQs
    # TODO
    
    jmp 0x20:realcall16

retfromrealcall16:

    mov eax, 0x10
    mov ds, eax
    mov es, eax
    mov fs, eax
    mov gs, eax
    mov eax, 0x18
    mov ss, eax   

    mov eax, [stack_pointer]
    mov esp, eax
    
    pop es
    popad
    ret


stack_pointer: .fill 4
os_version: .byte 0x01

k_gdt:
gdtentry0:  .word 0, 0
            .word 0, 0

gdtentry1:  .word 0x5FFF, 0x0000
            .byte 0, 0b10011001, 0b01000000, 0

gdtentry2:  .word 0xFFFF, 0x0000
            .byte 0, 0b10010011, 0b11001111, 0

gdtentry_ss: .word 0x5FFF, 0x7C00
             .byte 0, 0b10010111, 0b01000000, 0

gdtentry_cs16: .word 0xFFFF, 0x0000
               .byte 0, 0b10011001, 0b000000, 0

gdtentry_ds16: .word 0xFFFF, 0x0000
               .byte 0, 0b10010011, 0b000000, 0

gdt_size = $ - k_gdt

k_gdt_descriptor: .word gdt_size - 1
                k_gdt_offset: .fill 4
