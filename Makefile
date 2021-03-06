COMPILEFLAGS = -fno-pie -m32 -Wl,-N -ffreestanding -nostdlib

CFLAGS = -I kernel/include $(COMPILEFLAGS)
ASFLAGS = --32 -march=i386

KOBJS = main.o kmain.o kernel16.o pic8259.o video16.o video.o

all: image

boot.bin: boot.elf
	objcopy -O binary -j .text $^ $@

kernel.bin: kernel.elf
	objcopy -O binary $^ $@

boot.elf: start.o
	gcc $(CFLAGS) -T $(basename $@).ld -o $@ start.o

%.o: %.S
	as $(ASFLAGS) -o $@ $^

%.o: kernel/%.c
	gcc -c $(CFLAGS) -o $@ $^

%.o: kernel/%.S
	as $(ASFLAGS) -o $@ $^

kernel.elf: $(KOBJS)
	gcc $(CFLAGS) -T $(basename $@).ld -o $@ $^

image: kernel.bin boot.bin
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	mkdosfs -F 12 -r 224 -s 1 -S 512 floppy.img
	mcopy -i floppy.img kernel.bin ::/
	dd conv=notrunc if=boot.bin of=floppy.img bs=512 count=1
	bochs -f bochs.rc

clean:
	@rm -f *.bin *.o *.elf *.img

.PHONY: clean all image
