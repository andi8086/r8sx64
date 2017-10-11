#include <stdint.h>
#include <video.h>

gd_put_pixel(uint16_t x, uint16_t y, uint8_t c)
{
    uint16_t offset;

    offset = y * 320 + x;
    
    uint8_t *mem = 0xA0000;

    *(mem + offset) = c;
}


