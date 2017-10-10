#include <stdint.h>

uint8_t global_variable = 8;
extern void realcall(void); 


void kmain(void) {

    uint8_t a;

    global_variable = 15;

    realcall();
    while(1);

}
