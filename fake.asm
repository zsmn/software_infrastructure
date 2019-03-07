org 0x7c00
jmp 0x0000:start

aux dw 0
teste db 0
piroca db 0

start:
    call reset_register
    jmp self_loop

reset_register:
    xor ax, ax
    mov dx, ax
    xor cl, cl
    ret
    ; resetando os registradores

_putchar:
    mov ah, 0eh
    int 10h

    ret

_getchar:
    mov ah, 0
    int 16h
    ret

_endl:
    mov al, 0x0a
    call _putchar
    mov al, 0x0d
    call _putchar
    ret

_delchar:
    cmp cl, 0
    je self_loop

    dec cl
    dec di
    mov byte[di], 0

    mov al, 0x08
    call _putchar
    mov al, ''
    call _putchar
    mov al, 0x08
    call _putchar

self_loop:
    call _getchar
    cmp al, 0x0d; caso pressione enter
    je gerar_num
    cmp al, 0x08; caso pressione backspace
    je _delchar
    cmp al, 44; caso pressione a virgula ignora
    je .extra

    inc cl
    call _putchar
    stosb

    jmp self_loop

    .extra:
        call _putchar
    
    jmp self_loop
    
gerar_num:
    call _endl
    lodsb
    sub al, 48
    mov dh, 0
    mov dl, al
    dec cl
    
    cmp cl, 0
    je calcular

    jmp gamb1

gamb1:
    xor ax, ax
    mov bx, 10
    
    cmp cl, 0
    je calcular

    mov ax, dx
    mul bx
    mov dx, ax
    xor ax, ax

    lodsb
    sub al, 48
    add dx, ax
    dec cl
    jmp gamb1

calcular:
    cmp dx, 12424
    je printar_teste

    jmp calcular

printar_teste:
    mov al, 'v'
    call _putchar

exit:
    jmp $
    times 510 - ($-$$) db 0
    dw 0xaa55
