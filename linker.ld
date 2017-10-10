ENTRY(_start);
SECTIONS
{
    . = 0x7C00;
    .text :
    {
        start.o(.text)
    }
}
