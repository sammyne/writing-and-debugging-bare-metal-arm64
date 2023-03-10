ARM64GNU ?= aarch64-linux-gnu-

AS := $(ARM64GNU)as
LD := $(ARM64GNU)ld
OBJDUMP := $(ARM64GNU)objdump
OBJCOPY := $(ARM64GNU)objcopy

.PHONY: all
all: kernel.bin

.PHONY: clean
clean:
	@rm -rf *.bin *.dtb *.elf *.o

debug: kernel.elf
	@gdb-multiarch 												\
		-ex "set architecture aarch64" 			\
		-ex "target remote localhost:1234" 	\
		-ex "disassemble" 									\
		-ex "q" 														\
		$< 

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

kernel.bin: kernel.elf
	$(OBJCOPY) -O binary $< $@

kernel.elf: main.o linker.ld
	$(LD) -T linker.ld	-o $@ $<

main.o: main.s
	$(AS) -o $@ $^

run: kernel.bin
	qemu-system-aarch64 															\
		-M virt 																				\
		-cpu cortex-a72 																\
		-m 128M 																				\
		-nographic 																			\
		-device loader,file=kernel.bin,addr=0x40100000 	\
		-device loader,addr=0x40100000,cpu-num=0

run-elf: kernel.elf
	qemu-system-aarch64 												\
		-M virt 																	\
		-cpu cortex-a72 													\
		-m 128M 																	\
		-nographic 																\
		-device loader,file=kernel.elf 						\
		-device loader,addr=0x40100000,cpu-num=0

run-elf-for-debug: kernel.elf
	qemu-system-aarch64 												\
		-M virt 																	\
		-cpu cortex-a72 													\
		-m 128M 																	\
		-nographic 																\
		-device loader,file=kernel.elf 						\
		-device loader,addr=0x40100000,cpu-num=0	\
		-s -S
