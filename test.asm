org 0x7c00
jmp 0x0000:start

aa db 0

b dw "basquete", 0, 0, 0
f dw "futebol", 0, 0, 0
a dw "artes marciais", 0, 0, 0
v dw "volei", 0, 0, 0

p1 db 0
p2 db 0
p3 db 0

o1 dw '---'
o2 dw '---'
o3 dw '---'

carry_b:
    mov si, b
    ret

carry_f:
    mov si, f
    ret

carry_a:
    mov si, a
    ret

carry_v:
    mov si, v
    ret

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
    xor di, di
    xor si, si
    ret

printar_str:
    lodsb

    cmp al, 0
    je .retorno

    call putchar

    jmp printar_str

    .retorno:
        ret

printar_barra:
    mov ax, '|'
    call putchar
    ret

choose_01:
    cmp byte[p1], 0
    je .carry_o1

    cmp byte[p1], 'b'
    je .b
    cmp byte[p1], 'f'
    je .f
    cmp byte[p1], 'a'
    je .a
    cmp byte[p1], 'v'
    je .v
    
    .b:
        call carry_b
        ret
    .f:
        call carry_f
        ret
    .a:
        call carry_a
        ret
    .v:
        call carry_v
        ret
    
    .carry_o1:
        mov si, o1
        ret

choose_02:
    cmp byte[p2], 0
    je .carry_o2

    cmp byte[p2], 'b'
    je .b
    cmp byte[p2], 'f'
    je .f
    cmp byte[p2], 'a'
    je .a
    cmp byte[p2], 'v'
    je .v
    
    .b:
        call carry_b
        ret
    .f:
        call carry_f
        ret
    .a:
        call carry_a
        ret
    .v:
        call carry_v
        ret
    
    .carry_o2:
        mov si, o2
        ret

choose_03:
    cmp byte[p3], 0
    je .carry_o3

    cmp byte[p3], 'b'
    je .b
    cmp byte[p3], 'f'
    je .f
    cmp byte[p3], 'a'
    je .a
    cmp byte[p3], 'v'
    je .v
    
    .b:
        call carry_b
        ret
    .f:
        call carry_f
        ret
    .a:
        call carry_a
        ret
    .v:
        call carry_v
        ret

    .carry_o3:
        mov si, o3
        ret

show_at:
    call printa_03
    call printa_01
    call printa_02

    xor di, di
    xor si, si
    ret

printa_03:
    call choose_03
    call printar_str
    call printar_barra

    ret

printa_01:
    call choose_01
    call printar_str
    call printar_barra

    ret

printa_02:
    call choose_02
    call printar_str
    call printar_barra

    ret

start:
    call show_at
    call reset_register
    jmp exec

help:
    call show_at
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
        lodsb
        mov byte[aa], al
        jmp exec

    .troll:
        lodsb
        jmp generate

generate:

    cmp al, '1'
    je .put_1
    cmp al, '2'
    je .put_2
    cmp al, '3'
    je .put_3

    jmp end

    .put_1:
        mov dl, byte[aa]
        mov byte[p1], dl
        jmp .fim
    .put_2:
        mov dl, byte[aa]
        mov byte[p2], dl
        jmp .fim
    .put_3:
        mov dl, byte[aa]
        mov byte[p3], dl
        jmp .fim

    .fim:
        call endl
        jmp help

teste:
    mov al, 'k'
    call putchar
    jmp end

end:
    jmp $
    times 510 - ($-$$) db 0
    dw 0xaa55
