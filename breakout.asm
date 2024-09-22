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
	mov di, END_VARIABLES-START_VARIABLES-1
	mov bp, START_VARIABLES
.clear:
	mov byte [bp+di], 1
	dec di
	jns .clear

	; Draw paddles

	mov byte [PADDLES + 5], 0

	mov di, PADDLE_COUNT * PADDLE_ROWS

.drawPaddles:
	; If the thing is 1, set color
	mov ax, PADDLE_COLOR
	mov bl, [PADDLES + di]
	mul bl

	push di

	; Use mul to calculate coridnates
	push ax
	mov ax, 20
	mul di
	mov di, ax
	pop ax

	mov cx, 160 / 8
	rep stosb

	pop di

	dec di
	jns .drawPaddles

loop:
	jmp loop

; Boot stuff
times 510 - ($-$$) db 0
dw 0xaa55

; Place where I store my vars
[absolute 0x7E00]
START_VARIABLES:
	PADDLE_X resw 1
	PADDLES  resb PADDLE_COUNT * PADDLE_ROWS
END_VARIABLES:
