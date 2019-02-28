org 0x7c00
jmp 0x0000:start

data:
	hello db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 3, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 1, 3, 9, 9, 8, 1, 9, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 9, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 8, 8, 9, 15, 15, 15, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 15, 15, 9, 9, 3, 8, 0, 0, 0, 0, 8, 8, 8, 8, 8, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

start:

	call reset_registers
	call iniciar_video
	jmp drawImg

reset_registers:

	xor ax, ax
	mov ds, ax
	mov cx, ax
	mov dx, ax
	
	mov si, hello

	ret
	
iniciar_video:

	mov ah, 4FH
	mov al, 02H
	mov bx, 10H
	int 10h

	mov al, 13h
	mov ah, 0
	int 10h
	
	ret

start_vivi:
	mov al, 13h
	mov ah, 0
	int 10h

writePixel:
	mov ah, 0ch
	int 10h
	ret

drawImg:
	call start_vivi
	mov dx, 0
	.for1: 
		cmp dl, 16
		je .endfor1
		mov cx, 0
		.for2:
			cmp cl, 16
			je .endfor2
			lodsb
			call writePixel
			inc cx
			jmp .for2
		.endfor2:
		inc dx
		jmp .for1
	.endfor1:
	ret


end:
	jmp $

times 510 - ($ - $$) db 0
dw 0xaa55
