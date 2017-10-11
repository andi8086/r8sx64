.code16
.intel_syntax noprefix
.section .text

.global pic_mask_all_real
.global pic_init_real
.global pic_init_32

pic_mask_all_real:
    
    # Mask all IRQs
    mov al, 0xF
    out 0x21, al
    out 0xA1, al

    ret

pic_init_real:
   
    call pic_mask_all_real
 
    # Init, Edge, Cascade, 4th Init Step
    mov al, 0b00010001
    out 0x20, al
    out 0xA0, al

    # Master IRQ0 on int $08
    mov al, 0x08
    out 0x21, al
    # Slave IRQ8 on int $70
    mov al, 0x70
    out 0xA1, al

    # Master has slave input on #2
    mov al, 0b00000100
    out 0x21, al
    # Slave is on Master's input #2
    mov al, 0x02
    out 0xA1, al

    # FNM, Master/Slave by HW, Not AEOI, x86 Mode
    mov al, 0b00000001
    out 0x21, al
    out 0xa1, al

    # Unmask all
    mov al, 0
    out 0x21, al
    out 0xA1, al

    ret

.code32

pic_init_32:
    
    # Mask all IRQs
    mov al, 0xF
    out 0x21, al
    out 0xA1, al
 
    # Init, Edge, Cascade, 4th Init Step
    mov al, 0b00010001
    out 0x20, al
    out 0xA0, al

    # Master IRQ0 on int $21
    mov al, 0x21
    out 0x21, al
    # Slave IRQ8 on int $29
    mov al, 0x29
    out 0xA1, al

    # Master has slave input on #2
    mov al, 0b00000100
    out 0x21, al
    # Slave is on Master's input #2
    mov al, 0x02
    out 0xA1, al

    # FNM, Master/Slave by HW, Not AEOI, x86 Mode
    mov al, 0b00000001
    out 0x21, al
    out 0xa1, al

    ret

