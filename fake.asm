;;so ta faltando fazer os centavos

org 0x7c00
jmp 0x0000:start

aux dw 0
aux2 dw 0

putchar:
    mov ah, 0eh
    int 10h
    ret

getchar:
    mov ah, 0
    int 16h
    ret

endl:
    mov al, 0x0a
    call putchar
    mov al, 0x0d
    call putchar
    ret

reset_register:
    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx
    ret

start:
    call reset_register
    jmp exec

exec:
    call getchar
    cmp al, 0x0d ; enter
    je generate

    inc cl
    call putchar
    stosb

    jmp exec

generate:
    call endl
    lodsb
    sub al, 48
    mov dh, 0
    mov dl, al

    dec cl
    cmp cl, 0
    je calc_dol

    .every:
        xor ax, ax
        mov bx, 10
        
        cmp cl, 0
        je calc_dol

        mov ax, dx
        mul bx
        mov dx, ax
        xor ax, ax
        lodsb
        sub al, 48
        add dx, ax
        dec cl
        jmp .every

esquemas:
    call endl
    push dx
    call reset_register
    pop dx

    mov word[aux], dx
    mov ax, dx
    xor dx, dx

    ret

printar_coisa:
    add ax, '0'
    call putchar
    xor ah, ah
    sub ax, '0'
    ret

eliminar_dif:
    mul cx
    sub word[aux], ax
    mov dx, word[aux]
    ret

calc_dol:
    call esquemas
    mov cx, 100
    div cx
    call printar_coisa
    call eliminar_dif

    call esquemas
    mov cx, 50
    div cx
    call printar_coisa
    call eliminar_dif

    call esquemas
    mov cx, 20
    div cx
    call printar_coisa
    call eliminar_dif

    call esquemas
    mov cx, 10
    div cx
    call printar_coisa
    call eliminar_dif

    call esquemas
    mov cx, 5
    div cx
    call printar_coisa
    call eliminar_dif

    call esquemas
    mov cx, 2
    div cx
    call printar_coisa
    call eliminar_dif

    call esquemas
    mov cx, 1
    div cx
    call printar_coisa
    call eliminar_dif

    jmp end

debug:
    call reset_register
    mov al, 'T'
    call putchar

end:
    jmp $
    times 510 - ($-$$) db 0
    dw 0xaa55
