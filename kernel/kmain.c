#include <stdint.h>
#include "idt.h"

extern void realcall(void); 

extern void load_page_dir(void *page_dir);
extern void enable_paging(void);


uint32_t page_directory[1024] __attribute__((aligned(4096)));
uint32_t first_page_table[1024] __attribute__((aligned(4096)));

idt_desc_t idt_desc;
idt_entry_t idt[33];

void setup_idt(void)
{
    int i;
    uint32_t offset;
    for (i = 0; i < 33; i++)
    {
        offset = *((uint32_t *) &isr0 + i);
        idt[i].offset_1 = offset & 0xFFFF;
        idt[i].offset_2 = offset >> 16;
        idt[i].zero = 0;
        idt[i].type_attr = IDT_P | 0 << IDT_DPL | IDT_TYPE_INT386;
        idt[i].selector = 0x08;
    }
    idt_desc.limit = 0x107;
    idt_desc.base = idt;
}

void setup_paging(void)
{

    int i;
    for (i = 0; i < 1024; i++) {
        page_directory[i] = 0x00000002;
    }
    
    for (i = 0; i < 1024; i++) {
        first_page_table[i] = (i * 0x1000) | 3;
    }

    page_directory[0] = ((unsigned int)first_page_table) | 3;

}


void kmain(void)
{

    setup_paging();
    load_page_dir(page_directory);
    enable_paging();
    
    setup_idt();
    load_idt(&idt_desc);
    realcall();
    asm("int $0x20");
    while(1);

}
