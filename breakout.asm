org 0x7C00
bits 16
cpu 8086

SCREEN_WIDTH	equ 320
SCREEN_HEIGHT	equ 200

	; Init routine
	xor ax, ax
	mov ss, ax
	mov ds, ax

	mov ax, 0xA000
	mov es, ax ; Video memory

	; Set video mode
	mov ax, 0x0013
	int 0x10

	; Stack
	mov sp, 0x7C00

	; Clear screen
	mov al, 0x00
	mov cx, SCREEN_WIDTH * SCREEN_HEIGHT
	xor di, di
	rep stosb

loop:
	jmp loop

; Boot stuff
times 510 - ($-$$) db 0
dw 0xaa55
