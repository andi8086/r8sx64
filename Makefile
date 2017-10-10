all: image

boot.bin: boot.elf
	objcopy -O binary -j .text boot.elf boot.bin

boot.elf: start.o
	gcc -m32 -T linker.ld -Wl,-N -o boot.elf -ffreestanding -nostdlib start.o

start.o: start.S
	as --32 -march=i386 -o start.o start.S


kernel.bin: kernel.elf
	objcopy -O binary -j .text kernel.elf kernel.bin

kernel.elf: main.o
	gcc -fno-pie -m32 -T kernel.ld -Wl,-N -o kernel.elf -ffreestanding -nostdlib main.o kernel/main.c kernel16.o

main.o: kernel/main.S
	as --32 -march=i386 -o main.o kernel/main.S
	as --32 -march=i386 -o kernel16.o kernel/kernel16.S

image: kernel.bin boot.bin
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	mkdosfs -F 12 -r 224 -s 1 -S 512 floppy.img
	mcopy -i floppy.img kernel.bin ::/
	dd conv=notrunc if=boot.bin of=floppy.img bs=512 count=1
	bochs -f bochs.rc

clean:
	rm boot.bin boot.elf start.o main.o kernel.elf floppy.img kernel.bin \
		kernel16.o

.PHONY: clean all image
