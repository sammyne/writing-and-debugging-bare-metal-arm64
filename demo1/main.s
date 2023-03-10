# main.s

.global _reset
_reset:
	# Set up stack pointer
	ldr x2, =stack_top
	mov sp, x2
	# Magic number
	mov x13, #0x1337
	# Loop endlessly
	b . 
