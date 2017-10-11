#ifndef __IDT_H__
#define __IDT_H__

#include <stdint.h>

typedef struct __attribute__((packed)) {
    uint16_t limit;
    void *base;
} idt_desc_t;

typedef struct __attribute__((packed)) {
    uint16_t offset_1;
    uint16_t selector;
    uint8_t zero;
    uint8_t type_attr;
    uint16_t offset_2;
} idt_entry_t;

#define IDT_TYPE_INT8086 0x06
#define IDT_TYPE_INT386 0x0E
#define IDT_P 0x80
#define IDT_DPL 5
#define IDT_S 0x10

extern void *isr0;

extern void load_idt(void *idt_desc);

#endif
