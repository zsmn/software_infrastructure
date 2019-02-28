org 0x7c00
jmp 0x0000:start

hello db 'ABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDA'
start:

	call reset_registers
	call iniciar_video
	jmp draw_outer_loop

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
	
	ret

draw_outer_loop:
	cmp cx, 16 ; se fizer as 16 linhas (considera começando de 0)
	je end ; se for igual vai pra end

	add cx, 1 ; adiciona +1 a res_line

draw_inner_loop:
	lodsb
	
	cmp dx, 16 ; se fizer as 16 colunas (considera começando de 0)
	je reset_inner_loop ; se for igual jumpa pra reset

	add dx, 1 ; adiciona +1 a res_col

	; ideia: fazer dois 'prints' de pixel especificos
	; onde um deles vai printar caso a asc2 esteja entre '0' e '9'
	; e outro quando estiver entre 'A' e 'F'
	; (fazer codigo em c++ pra a conversão!)
	cmp al, 'A'
	jae print_pixel_aschigher

	call print_pixel_asclower

	jmp draw_inner_loop ; fica chamando no loop

print_pixel_asclower:
	mov ah, 0CH ; write pixel
	sub al, '0' ; color, subtraindo 48 (asc2 = '0')
	int 10h

	ret

print_pixel_aschigher:
	mov ah, 0CH ; write pixel
	sub al, '7' ; color, subtraindo 55 (asc2 = '7')
	int 10h

	jmp draw_inner_loop

reset_inner_loop:

	mov dx, 0 ; reseta res_col pra 0
	jmp draw_outer_loop ; chama o outer loop

end:
	jmp $

times 510 - ($ - $$) db 0
dw 0xaa55
