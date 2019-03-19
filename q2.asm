org 0x7c00 
jmp 0x0000:start

um db '1', 13, 10, 0

data:
    answer times 11 db 0
    base times 11 db 0
    expoente times 11 db 0

start:
    mov di, base
    xor ax, ax ; zerando o conteudo do registrador ax
    mov ds, ax
    mov es, ax
    call get_string
    call dale
    mov si, base
    call stoi ; a funcao stoi vai ser responsavel p/ converter string to int
    push ax ; salvando a base -- numero e nao string na pilha
    
    ; ISSO AQUI SO SERVE PRA PRINTAR A BASE QUE EU ARMAZENEI
    mov si, base
    call printstring
    call dale
    
    ; ISSO AQUI SERVE PARA LER O EXPOENTE E PRINTAR ELE NA LINHA DEBAIXO
    xor di, di
    mov di, expoente
    xor si, si
    xor ax, ax
    call get_string
    call dale
    mov si, expoente
    call stoi ; a funcao stoi vai ser responsavel p/ converter string to int
    push ax   ; salvando o expoente -- numero e nao string na pilha

    ; ISSO AQUI VAI SERVIR PARA PRINTAR O EXPOENTE QUE EU ARMAZENEI
    mov si, expoente
    call printstring
    call dale

    ;PRONTO TANTO BASE COMO EXPOENTE SALVOU OS DADOS DIREITINHO -- gloria
    xor ax, ax
    mov bx, ax
    mov cx, ax
    mov ax, 1
    pop cx 
    pop bx 
    add cx, cx

    ;testando para ver se o expoente eh 0 ou 1 (casos base)
    ;cmp cx, 0
    ;je casozero
    
    ;caso geral : tem que fazer as contas
    lp:
        cmp cx, 0
        je finished
        mul bx
        dec cx
        loop lp
    ; apos tudo isso o resultado da potenciacao vai ta guardado em ax
    finished:
        mov di, answer
        call tostring
        mov si, answer
        call printstring
        call dale
        jmp done

reverse:
    mov si, answer
    mov di, si
    xor cx, cx
    .hope:
        lodsb ; al = *si (ultimo caractere)
        cmp al, 0
        je .endhope
        inc cl
        push ax
        jmp .hope
    .endhope:
    .dale2:
        pop ax
        stosb
        loop .dale2
    ret

tostring:
    push di ; salvando o ponteiro pra minha resposta na pilha
    .halo:
        cmp ax, 0
        je .endloop1
        xor dx, dx
        mov bx, 10
        div bx ; dividindo o conteudo de ax por 10. Ex: ax = 9999 -> ax = 999, dx = 9
        xchg ax, dx                                                ; ax = 9    dx = 999
        add ax, 48
        stosb
        xchg ax, dx ;to carregando cada caractere da string em DI so que de tras pra frente
        jmp .halo
    .endloop1:
        pop si
        cmp si, di
        jne .notokay
        mov al, 48
        stosb
        .notokay:
            mov al, 0
            stosb
            call reverse
            ret
stoi:
    xor cx, cx
    xor ax, ax
    .loop1:
        push ax
        lodsb ; al igual a *si
        mov cl, al
        pop ax
        cmp cl, 0 ;serve para ver se eu cheguei ao final da minha string
        je .endloop1
        sub cl, 48   ; '9' - '0' eh igual a 9
        mov bx, 10
        mul bx
        add ax, cx
        jmp .loop1
    .endloop1:
        ret

printstring:
    .loop:
        lodsb ; bota o caractere em AL
        cmp al, 0 ; se tiver chegado ao final da string acabou
        je .endloop

        mov ah, 0x0e
        int 10h
        jmp .loop
    .endloop:
        ret

get_string:
    xor cl, cl ;limpa o registrador de contagem
    .loop:
        mov ah, 0
        int 16h ;interrrupcao para poder ler o caractere

        cmp al, 0x08 ; compara pra ver se foi o backspace que foi pressionado
        je .backspace


        cmp al, 0x0d ; compara pra ver se foi o enter que foi pressionado
        ; se sim, entao acabou a leitura
        je .endloop

        mov ah, 0x0e ; funcao pra printar o caractere pressionado
        int 10h

        stosb ; carrega o caracter que estava em AL para o registrador DI
        inc cl
        jmp .loop
    .endloop:
        mov al, 0
        stosb 
        ret

.backspace:
    cmp cl, 0 ; se eu tiver no inicio da string eu ignoro o enter que foi pressionado
    je .loop  ; e volto pra leitura de dados
    
    dec di
    mov byte[di], 0
    dec cl

    mov ah, 0x0e
    mov al, 0x08
    int 10h

    mov al, ' '
    int 10h

    mov al, 0x08
    int 10h

    jmp .loop

dale:
    mov al, 0
    stosb

    mov ah, 0x0e
    mov al, 0x0d
    int 0x10
    mov al, 0x0a
    int 0x10

    ret

casozero:
    xor si, si
    mov si, um
    call printstring
    jmp done

casoum:
    mov si, base
    call printstring
    jmp done
done:
    jmp $
    times 510-($-$$) db 0    
    dw 0xaa55    
; preenche o resto do setor com zeros         
; coloca a assinatura de boot no final
; do setor (x86 : little endian)
