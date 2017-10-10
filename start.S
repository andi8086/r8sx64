# R8SX64 Boot-Sector
# Copyright (c)2000 by Andreas J. Reichel (Gesimex)
# Copyright (c)2017 by Andreas J. Reichel (gcc port)

# Changes to Gesimex version:
#   - do not load kernel to 0x00000000 to keep BIOS data area
#     this might be helpful for V86 mode

.code16
.intel_syntax noprefix

.section .text
.global _start
.type _start, @function

heads = 2
sectors_per_track = 18

_start:
    jmp start
    nop
    .fill 8     #
    .word 512   # number of bytes per sector
    .byte 1     # sectors per cluster
    .word 1     # reserved sectors
    .byte 2     # number of fat copies
    .word 224   # number of root entries
    .word 2880  # number of sectors in file system
    .byte 0xf0  # media descriptor for 1.44M floppy
    .word 9     # sectors per FAT
    .word 12    # sectors per track
    .fill 34    # spacer for drive params
start:
    cli
    mov ax, 0x7C0
    mov ds, ax
    mov ax, 0x1050
    mov es, ax
    mov ss, ax
    mov sp, 8192
    sti
    mov di, 0
    mov si, 0
    mov cx, 512
    cld
    rep movsb
    push es
    mov ax, offset main
    push ax
    retf    

main:
    cli
    mov ax, es 
    mov ds, ax
    sti
    call enable_a20
    call load_kernel
    cli   
 
    # mask interrupts in PICs
    mov dx, 0x21
    mov al, 0xF
    out dx, al
    mov dx, 0xA1
    mov al, 0xF
    out dx, al

    mov ax, 0x1050
    mov es, ax
    mov ds, ax
    mov si, offset gdt
    call calc_pm_address
    mov gdt_lw, ax
    mov gdt_hw, dx
    lgdt ds:[gdt_descriptor]
    mov eax, cr0
    or al, 1
    mov cr0, eax
    
    # 32-bit far call to 0008:00000100
    .byte 0x66
    .byte 0xea
    .word 0x500
    .word 0
    .word 0x08


load_kernel:
    # load to 0x0500

    mov ax, 0x50
    mov es, ax
    xor bx, bx

    # begin with absolute sector 33
    mov ax, 33
readbootfile:
    push ax
        push bx
            call conv_to_rel_sector
        pop bx
        push bx
            int 0x13
        pop bx
        add bx, 512
    pop ax
    inc ax
    cmp ax, 160
    jb readbootfile
    ret

conv_to_rel_sector:
    xor dx, dx
    mov bx, sectors_per_track
    div bx
    mov byte ptr ds:[rsec], dl
    inc byte ptr ds:[rsec]
    xor dx, dx
    mov bx, heads
    div bx
    and ax, 1023
    mov word ptr ds:[rcyl], ax
    mov byte ptr ds:[rhead], dl
    mov dh, byte ptr ds:[rhead]
    mov cx, word ptr ds:[rcyl]
    xchg cl, ch
    ror cl, 2
    or cl, byte ptr ds:[rsec]
    mov al, 1
    mov ah, 2
    mov dl, 0
    ret



wait_8042:
    in al, 0x64
    test al, 2
    jnz wait_8042
    ret

enable_a20:
    cli
    call wait_8042
    mov al, 0xAD
    out 0x64, al
    
    call wait_8042
    mov al, 0xD0
    out 0x64, al

    call wait_8042
    in al, 0x60
    push ax

    call wait_8042
    mov al, 0xD1
    out 0x64, al

    call wait_8042
    pop ax
    or al, 2
    out 0x60, al

    call wait_8042
    mov al, 0xAE
    out 0x64, al
    
    call wait_8042
    sti
    ret

calc_pm_address:
    mov ax, es
    mov dh, 0
    mov dl, ah
    shr dl, 4
    shl ax, 4
    add ax, si
    adc dx, 0
    ret

rhead: .byte 0
rcyl: .word 0
rsec: .byte 0

gdt:
gdtentry0:  .word 0, 0
            .word 0, 0

gdtentry1:  .word 0xFFFF, 0x0000
            .byte 0, 0b10011001, 0b11001111, 0

gdtentry2:  .word 0xFFFF, 0x0000
            .byte 0, 0b10010011, 0b11001111, 0

gdt_size = $ - gdt

gdt_descriptor: .word gdt_size - 1
                gdt_lw: .word 0
                gdt_hw: .word 0

.org 0x1FD
crc_sum: .byte 0xFF

.org 0x1FE
signature: .byte 0x55, 0xaa

