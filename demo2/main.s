# main.s

.global _reset
_reset:
	ldr x10, uartdr
	mov w9, '!'
	strb w9, [x10]
	b . 

uartdr: 
	.quad 0x9000000
