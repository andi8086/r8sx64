ENTRY(_start);
SECTIONS
{
    . = 0x00000500;
    .text :
    {
        main.o(.text)
    }
}
