#ifndef __VIDEO_H__
#define __VIDEO_H__

extern void set_video_mode(void);

typedef struct __attribute__((packed)) {
    uint16_t video_mode;
} p_set_video_mode_t;

extern void print_video_text(void);

typedef struct __attribute__((packed)) {
    uint16_t text_offset;
} p_print_video_text_t;

extern void gd_put_pixel(uint16_t x, uint16_t y, uint8_t c);

#endif
