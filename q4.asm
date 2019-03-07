org 0x7c00
jmp 0x0000:start

bytevar db 1
bytemask db 1

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
    ; caso pressione enter
    cmp al, 0x0d
    je printar
    ; caso pressione backspace
    cmp al, 0x08
    je _delchar

    inc cl
    call _putchar
    stosb

    jmp self_loop

printar:
    call _endl
    .tentativa:
        lodsb
        ; caso seja o fim
        cmp cl, 0
        je exit
        dec cl
        ; caso seja um espaço
        cmp al, 32
        je .casoEsp
        ; faz o not do bytevar (0 ou 1)
        ; caso bytevar seja 1, transforma em maiuscula
        cmp byte [bytevar], 1
        je .transfM

        .casoNormal:
            call _putchar
            xor byte [bytevar], bytemask
            jmp .tentativa

        .casoEsp:
            call _putchar
            jmp .tentativa

        .transfM:
            sub al, 32
            call _putchar

        xor byte [bytevar], bytemask
        jmp .tentativa

exit:
    jmp $
    times 510 - ($-$$) db 0
    dw 0xaa55
