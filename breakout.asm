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

	; mov ax,0x0002 ; Insure correct video mode
	inc ax
	inc ax
	int 0x10

	mov ax, 0xB800
	mov es, ax ; Video memory

	; Stack
	mov sp, 0x7C00

	; Clearing variable memory
	mov di, END_VARIABLES-START_VARIABLES-1
	mov bp, START_VARIABLES
.clear:
	mov byte [bp+di], 1
	dec di
	jns .clear

loop:
.delay:
	; Wait frames
	xor ah, ah
	int 0x1A
	cmp dx, [OLD_TIME] ; 18.2 clock ticks per second
	je .delay
	mov [OLD_TIME], dx

	; Clear screen
	xor ax, ax
	xor di, di
	mov cx, SCREEN_WIDTH * SCREEN_HEIGHT * 2
	rep stosb

	; Draw paddles
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

.drawPaddle:
	mov di, [PADDLE_X]
	mov ax, 2
	mul di
	mov di, ax

	mov ax, PADDLE_COLOR
	add di, SCREEN_WIDTH * 2 * 20 - 32
	mov cx, 160 / 8
	rep stosb

.input:
	mov ah, 0x02
	int 0x16

	mov bl, [PADDLE_X]

	test al, 0x08
	jne .right
	test al, 0x04
	je .endKeys

.left:
	cmp bl, 0
	je .endKeys
	sub bl, 1
	jmp .endKeys

.right:
	cmp bl, SCREEN_WIDTH - 10
	je .endKeys
	add bl, 1

.endKeys:
	mov byte [PADDLE_X], bl

	call ball

	jmp loop

ball:
	ret

OLD_TIME: equ 16

; Boot stuff
times 510 - ($-$$) db 0
dw 0xaa55

; Place where I store my vars
[absolute 0x7E00]
START_VARIABLES:
	PADDLE_X resb 1
	PADDLES  resb PADDLE_COUNT * PADDLE_ROWS
END_VARIABLES:
