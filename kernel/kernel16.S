.code16
.intel_syntax noprefix
.global realcall16
.type realcall16, @function

.extern retfromrealcall16
.extern k_gdt_descriptor
.extern pic_init_real
.extern pic_mask_all_real

realcall16:
    # real mode function offset is in EDI

    # here we are in 16-bit protected mode
    # return to real mode
    cli

    # load 16-bit mode data selectors
    mov eax, 0x28
    mov ds, eax
    mov es, eax
    mov ss, eax
    mov fs, eax
    mov gs, eax

    # push new CS
    mov ax, 0
    push ax 

    mov bx, offset enter_realmode
    push bx

    # first deactivate paging
    mov eax, cr0
    and eax, 0x7FFFFFFF
    mov cr0, eax

    # 2nd disable protected mode
    and al, 0xFE
    mov cr0, eax

    # will return to 0x0000:enter_realmode and flush CS
    retf

enter_realmode:

    mov ax, 0x0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, 0x1000

    call pic_init_real

    mov eax, offset r_idt_descriptor
    lidt [eax]

    # do real mode stuff here
    sti

    mov ax, di
    # SI is pointer to parameters
    call ax

    # return to protected mode

    cli

    # mask all IRQs
    call pic_mask_all_real

    lgdt [k_gdt_descriptor]

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp 0x08:retfromrealcall16  


# IDT descriptor for real mode IVT

r_idt_descriptor: .word 0x3FF
                r_idt_offset: .long 0x00000000

