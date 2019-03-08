org 0x7c00
jmp 0x0000:start

entrada db 'foi'
entrada2 db 'fuck'
entrada3 db 'V'
;jenifer db 10

start:
    call reset_register
    jmp self_loop

reset_register:
    xor ax, ax
    mov dx, ax
    xor cl, cl
   ; xor es, es
    xor dl, dl;
    xor bx, bx
    ret

getchar:
    mov ah, 0
    int 16h
    ret

_putchar:
    mov ah, 0eh
    int 10h

    ret

deleta:
    cmp cl, 0;
    je self_loop;
    dec cl;
    dec di
    mov byte[di], 0

    mov al, 0x08
    call _putchar
    mov al, ''
    call _putchar
    mov al, 0x08
    call _putchar



    jmp self_loop;

self_loop:
    call getchar;
    cmp al, 0x0d;
    je transnum;
    cmp al, 0x08;
    je deleta;
    inc cl;
    call _putchar;
    sub al, 48;
    stosb
    
    
    
    jmp self_loop;

endl:
    mov al, 0x0a
    call _putchar
    mov al, 0x0d
    call _putchar
    ret

transnum:
    call endl;
    lodsb
    mov dh, 0
    mov dl, al;
    ;cmp al, 5
    ;je shupa
    dec cl
    cmp cl, 0;
    je calcular;
    jmp gambi;

gambi:
    xor ax, ax
    mov bx, 10
    cmp cl,0;
    je calcular;
    mov ax, dx
    mul bx
    mov dx, ax
    xor ax, ax
    lodsb
    add dx, ax
    dec cl;
    jmp gambi;
calcular:
    ;cmp dl , 5
    ;je shupa
    xor bx, bx;
    mov bx, dx;
    xor ax,ax;
    xor cx, cx;
    jmp resultado;

resultado:
    mov ax, bx ;meu n ta no bx e no ax
    mul ax; ax = n*n
    add ax, bx ; ax = (n*n)+n
    mov cx, 2; cx = 2; 
    div cx; ax = ((n*n)+n)/2
    mov cx, bx; cx = n
    mov bx , 2; bx = 2
    add bx, cx ; bx = n+2
    mul bx; ax = (((n*n)+n)/2)*(n+2)
    mov bx, cx;
    mov cx, 3;
    div cx; ax = ((((n*n)+n)/2)*(n+2))/3
    mov bx, ax
    mov cx, ax
    mov dx, ax
    jmp mostrar

mostrar:
    cmp bx, 27720;
    je delicia;
    jmp fuck;

shupa:
    xor si, si
    mov si, entrada;
    jmp printa;

delicia:
    xor si, si
    mov si, entrada3
    jmp printa2

fuck:
    xor si, si
    mov si, entrada2;
    jmp printa;

printa:
    lodsb
    cmp al, 0;
    je exit;
    mov ah, 0eh;
    int 10h
    jmp printa;

printa2:
    lodsb
    mov ah, 0eh;
    int 10h
    jmp exit;

exit:
    jmp $
    times 510 - ($-$$) db 0
    dw 0xaa55

    ; es gs fs
   ; xor bx,bx;
   ; je calcular;
   ; mov bx, 10;
   ; mul dx;
   ; lodsb;
   ; mov bl, al
   ; add dx, bx
