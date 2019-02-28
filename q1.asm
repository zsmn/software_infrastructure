org 0x7c00
jmp 0x0000:start

res_col: resw 0
res_line: resw 0

start:
	call reset_registers
	call iniciar_video
	jmp draw_outer_loop

reset_registers:
	xor ax, ax
	mov ds, ax
	mov cx, ax
	mov dx, ax

	ret
	
iniciar_video:
	mov ah, 4FH
	mov al, 02H
	mov bx, 10H
	int 10h
	
	ret

draw_outer_loop:
	cmp word [res_line], 15 ; se fizer as 16 linhas (considera começando de 0)
	je end ; se for igual vai pra end

	add word [res_line], 1 ; adiciona +1 a res_line

draw_inner_loop:
	cmp word [res_col], 15 ; se fizer as 16 colunas (considera começando de 0)
	je reset_inner_loop ; se for igual jumpa pra reset

	add word [res_col], 1 ; adiciona +1 a res_col

	mov ah, 0CH ; write pixel
	mov al, 8 ; color
	mov cx, word [res_col]; coluna
	mov dx, word [res_line] ; linha
	int 10h

	jmp draw_inner_loop ; fica chamando no loop

reset_inner_loop:
	mov word [res_col], 0 ; reseta res_col pra 0
	jmp draw_outer_loop ; chama o outer loop

end:
	jmp $


times 510 - ($ - $$) db 0
dw 0xaa55
