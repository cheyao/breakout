org 0x7C00
bits 16
cpu 8086

	mov ax, 0
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov sp, 0x7C00

loop:
	jmp loop
