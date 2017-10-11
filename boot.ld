ENTRY(_start);
SECTIONS
{
    . = 0x0;
    .text :
    {
        start.o(.text)
    }
}
