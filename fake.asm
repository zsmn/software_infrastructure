;; falta consertar os cents

org 0x7c00
jmp 0x0000:start

aux dw 0

flag db 0

qt_100 db 0
qt_50 db 0
qt_20 db 0
qt_10 db 0
qt_5 db 0
qt_2 db 0
qt_1 db 0
qt_0_50 db 0
qt_0_25 db 0
qt_0_10 db 0
qt_0_05 db 0
qt_0_01 db 0

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
    cmp al, 44 ; ','
    je .extra
    cmp al, 0x0d ; enter
    je .troll

    inc cl
    call putchar
    stosb

    jmp exec

    .extra:
        call putchar
        jmp generate

    .troll:
        jmp generate

generate:
    lodsb
    sub al, 48
    mov dh, 0
    mov dl, al

    dec cl
    cmp cl, 0
    je .select

    .every:
        xor ax, ax
        mov bx, 10
        
        cmp cl, 0
        je .select

        mov ax, dx
        mul bx
        mov dx, ax
        xor ax, ax
        lodsb
        sub al, 48
        add dx, ax
        dec cl
        jmp .every
    
    .select:
        cmp byte[flag], 0
        je calc_dol
        cmp byte[flag], 1
        je calc_cent

esquemas:
    push dx
    call reset_register
    pop dx

    mov word[aux], dx
    mov ax, dx
    xor dx, dx

    ret

eliminar_dif:
    mul cx
    sub word[aux], ax
    mov dx, word[aux]
    ret

div_add:
    div cx
    add ax, '0'
    ret

xor_sub:
    xor ah, ah
    sub ax, '0'
    ret

calc_dol:
    call esquemas
    mov cx, 100
    call div_add
    mov byte[qt_100], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 50
    call div_add
    mov byte[qt_50], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 20
    call div_add
    mov byte[qt_20], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 10
    call div_add
    mov byte[qt_10], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 5
    call div_add
    mov byte[qt_5], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 2
    call div_add
    mov byte[qt_2], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 1
    call div_add
    mov byte[qt_1], al
    call xor_sub
    call eliminar_dif

    mov byte[flag], 1

    jmp exec

calc_cent:

    call esquemas
    mov cx, 50
    call div_add
    mov byte[qt_0_50], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 25
    call div_add
    mov byte[qt_0_25], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 10
    call div_add
    mov byte[qt_0_10], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 5
    call div_add
    mov byte[qt_0_05], al
    call xor_sub
    call eliminar_dif

    call esquemas
    mov cx, 1
    call div_add
    mov byte[qt_0_01], al
    call xor_sub
    call eliminar_dif

    jmp printarporratoda

ajuda:
    call putchar
    call endl
    xor ax, ax
    ret

printarporratoda:
    call endl
    mov al, byte[qt_100]
    call ajuda
    mov al, byte[qt_50]
    call ajuda
    mov al, byte[qt_20]
    call ajuda
    mov al, byte[qt_10]
    call ajuda
    mov al, byte[qt_5]
    call ajuda
    mov al, byte[qt_2]
    call ajuda
    mov al, byte[qt_1]
    call ajuda
    mov al, byte[qt_0_50]
    call ajuda
    mov al, byte[qt_0_25]
    call ajuda
    mov al, byte[qt_0_10]
    call ajuda
    mov al, byte[qt_0_05]
    call ajuda
    mov al, byte[qt_0_01]
    call putchar

tests:
    mov al, 'k'
    call putchar
    jmp end

end:
    jmp $
    times 510 - ($-$$) db 0
    dw 0xaa55
