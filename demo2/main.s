# main.s

.global _reset
_reset:
	ldr x10, uartdr
	mov w9, '!'
	strb w9, [x10]
	b . 

# 从 dump.dtb 文件解析出 UART0 地址的教程参见这里
#  https://blog.csdn.net/jklinux/article/details/78574811
uartdr: 
	.quad 0x9000000
