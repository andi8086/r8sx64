
.intel_syntax noprefix
.code32
.section .text

.global _start
.global k_gdt_descriptor
.global realcall
.global retfromrealcall16

.global load_page_dir
.global enable_paging

.global load_idt

.global int_divzero
.global int_singlestep
.global int_nmi
.global int_break
.global int_overflow
.global int_bounds
.global int_invalop
.global int_nocop
.global int_doublefault
.global int_copsegov
.global int_invalidtss
.global int_segnotpres
.global int_stackfault
.global int_gep
.global int_pagefault
.global int_reserved0F
.global int_mathfault
.global int_aligncheck
.global int_machinecheck
.global int_simde
.global int_virte
.global int_ctrle

.global isr0

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

load_page_dir:
    push ebp
    mov ebp, esp
    mov eax, [esp+8]
    mov cr3, eax
    mov esp, ebp
    pop ebp
    ret

load_idt:
    push ebp
    mov ebp, esp
    mov eax, [esp+8]
    lidt [eax]
    
    int 0x20

    mov esp, ebp
    pop ebp
    ret

enable_paging:
    push ebp
    mov ebp, esp
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax
    mov esp, ebp
    pop ebp
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

int_divzero:
    iret

int_singlestep:
    iret

int_nmi:
    iret

int_break:
    iret

int_overflow:
    iret

int_bounds:
    iret

int_invalop:
    iret

int_nocop:
    iret

int_doublefault:
    iret

int_copsegov:
    iret

int_invalidtss:
    iret

int_segnotpres:
    iret

int_stackfault:
    iret

int_gep:
    iret

int_pagefault:
    iret

int_reserved0F:
    iret

int_mathfault:
    iret

int_aligncheck:
    iret

int_machinecheck:
    iret

int_simde:
    iret

int_virte:
    iret

int_ctrle:
    iret

int_16:
    iret

int_17:
    iret

int_18:
    iret

int_19:
    iret

int_1a:
    iret

int_1b:
    iret

int_1c:
    iret

int_1d:
    iret

int_1e:
    iret

int_1f:
    iret

int_20:
    mov edx, 0xEEEEAAAA
    iret

isr0: .long offset int_divzero
      .long offset int_singlestep
      .long offset int_nmi
      .long offset int_break
      .long offset int_overflow
      .long offset int_bounds
      .long offset int_invalop
      .long offset int_nocop
      .long offset int_doublefault
      .long offset int_copsegov
      .long offset int_invalidtss
      .long offset int_segnotpres
      .long offset int_stackfault
      .long offset int_gep
      .long offset int_pagefault
      .long offset int_reserved0F
      .long offset int_mathfault
      .long offset int_aligncheck
      .long offset int_machinecheck
      .long offset int_simde
      .long offset int_virte
      .long offset int_ctrle
      .long offset int_16
      .long offset int_17
      .long offset int_18
      .long offset int_19
      .long offset int_1a
      .long offset int_1b
      .long offset int_1c
      .long offset int_1d
      .long offset int_1e
      .long offset int_1f
      .long offset int_20

