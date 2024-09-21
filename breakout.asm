org 0x7C00
bits 16
cpu 8086

SCREEN_WIDTH	equ 80
SCREEN_HEIGHT	equ 25
PADDLE_COLOR    equ 0b11101110
PADDLE_COUNT    equ 8
PADDLE_ROWS     equ 6

	; Init routine
	xor ax, ax
	mov ss, ax
	mov ds, ax

	mov ax, 0xB800
	mov es, ax ; Video memory

	; Stack
	mov sp, 0x7C00

	; Clear screen
	mov al, 0x00
	mov cx, SCREEN_WIDTH * SCREEN_HEIGHT
	xor di, di
	rep stosb

	; Clearing variable memory
	xor ax, ax
	inc ax
	mov bp, START_VARIABLES
	mov di, END_VARIABLES-START_VARIABLES-1
	; Use a manual loop since the destination is in ds
.clear:
	mov [bp+di], al
	dec cx
	jns .clear

	; Draw paddles
loop:

	mov di, (PADDLE_COUNT * 20 * PADDLE_ROWS) - 20

.drawPaddles:
	mov al, PADDLE_COLOR
	mov bl, [ds:PADDLES]
	mul bl
	call drawPaddle

	dec di
	jns .drawPaddles

	jmp loop

drawPaddle: ; The color is in ax, pos in di
	push di

	mov cx, 160 / 8
	rep stosb

	pop di

	ret

; Boot stuff
times 510 - ($-$$) db 0
dw 0xaa55

; Place where I store my vars
[absolute 0xFA00]
START_VARIABLES:
	PADDLE_X resw 1
	PADDLES  resb PADDLE_COUNT * PADDLE_ROWS
END_VARIABLES:
