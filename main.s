# main.s

.global _reset
_reset:
	# Set up stack pointer
	LDR X2, =stack_top
	MOV SP, X2
	# Magic number
	MOV X13, #0x1337
	ldr x10, UARTDR
	mov w9, '!'
	strb w9, [x10]
	# Loop endlessly
	B . 

UARTDR:
	.quad 0x9000000
