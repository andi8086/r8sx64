.code16
.intel_syntax noprefix
.global realcall16
.type realcall16, @function

.extern retfromrealcall16
.extern k_gdt_descriptor

realcall16:

    # here we are in 16-bit protected mode
    # return to real mode


    mov eax, 0x28
    mov ds, eax
    mov es, eax
    mov ss, eax
    mov fs, eax
    mov gs, eax      
    
    mov ax, 0
    push ax 

    mov bx, offset enter_realmode
    push bx
    
    mov eax, cr0
    and eax, 0x7FFFFFFF
    mov cr0, eax
    and al, 0xFE
    mov cr0, eax
    retf    

enter_realmode:

    mov ax, 0x0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, 0x1000

    mov eax, offset r_idt_descriptor
    lidt [eax]

    # do real mode stuff here

    # video mode 12, + 0x80 for keeping screen
    mov al, 0x92
    mov ah, 0
    int 0x10

    # return to protected mode

    lgdt [k_gdt_descriptor]

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp 0x08:retfromrealcall16  


# IDT descriptor for real mode IVT

r_idt_descriptor: .word 0x3FF
                r_idt_offset: .long 0x00000000

