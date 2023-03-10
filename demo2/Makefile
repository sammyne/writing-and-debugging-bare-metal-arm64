ARM64GNU ?= aarch64-linux-gnu-

AS := $(ARM64GNU)as
LD := $(ARM64GNU)ld
OBJDUMP := $(ARM64GNU)objdump
OBJCOPY := $(ARM64GNU)objcopy

.PHONY: all
all: run

.PHONY: clean
clean:
	@rm -rf *.bin *.dtb *.elf *.o

dump: kernel.elf
	$(OBJDUMP) -d $<

dump-plo11: dump.dtb
	@dtc $< | grep -A6 "pl011@9000000 {"

dump.dtb: kernel.elf
	@qemu-system-aarch64 												\
		-M virt,dumpdtb=$@ 												\
		-cpu cortex-a72 													\
		-m 128M 																	\
		-nographic 																\
		-device loader,file=$< 										\
		-device loader,addr=0x40100000,cpu-num=0

kernel.elf: main.o linker.ld
	@$(LD) -T linker.ld	-o $@ $<

main.o: main.s
	@$(AS) -o $@ $^

run: kernel.elf
	@qemu-system-aarch64 												\
		-M virt 																	\
		-cpu cortex-a72 													\
		-m 128M 																	\
		-nographic 																\
		-device loader,file=$< 										\
		-device loader,addr=0x40100000,cpu-num=0
