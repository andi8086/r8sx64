.code16
.intel_syntax noprefix
.section .text

.global set_video_mode
.global print_video_text

set_video_mode:
    mov ax, [si]
    int 0x10
    ret

blahblah: .string "blabla"

print_video_text:
    mov ah, 0x0B
    mov bh, 0x00
    mov bl, 0xFF # Set background color
    int 0x10


    mov bp, offset blahblah
    mov ah, 0x13
    mov al, 0x01
    
    xor bh, bh

    mov bl, 0x85 # magenta
    mov cx, 6   # number of letters
    mov dh, 5   # row
    mov dl, 5   # col
    int 0x10


    
    ret
    
