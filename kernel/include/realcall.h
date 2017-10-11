#ifndef __REALCALL_H__
#define __REALCALL_H_

typedef struct __attribute__((packed)) {
    void *realfunc;
    void *params;
} realcall_t;

#endif
