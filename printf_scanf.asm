section .data
	hello db 'Eae vivi, digita um numero: ', 0xa
	helloSize equ $-hello
	ansa db 'Numero que vivi digitou: '
	ansaSize equ $-ansa

section .bss
	num resb 5

section .text
	global main
main:
	mov eax, 4 ; sys_write
	mov ebx, 1
	mov ecx, hello ; msg
	mov edx, helloSize ; bytes da msg
	int 80h ; chama kernel
	
	mov eax, 3 ; sys_read
	mov ebx, 2
	mov ecx, num ; salva em num
	mov edx, 5 ; qt de bytes
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, ansa
	mov edx, ansaSize
	int 80h
	
	mov eax, 4 ; sys_write
	mov ebx, 1
	mov ecx, num
	mov edx, 5
	int 80h
	
	mov eax, 1
	mov ebx, 0
	int 80h
