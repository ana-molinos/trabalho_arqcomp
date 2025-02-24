segment .data
; Variáveis de 8 bytes
a: dq 2
ind: dq 0
cnt: dq 0
cnt2: dq 0
mini: dq 0
maxi: dq 0
min_pos: dq 0
max_pos: dq 0
fmt: dq "%lld ",10,0
fmt_in: dq "%lld", 0

; Strings
fmt_out_max: db "O maior número está na posição %lld e é o %lld. ", 0
fmt_out_min: db "O menor número está na posição %lld e é o %lld. ", 0

fmt_even: db "Esse valor é par!", 10, 0
fmt_odd: db "Esse valor é ímpar!", 10, 0

; Arrays de tamanho 21 (?)
segment .bss
array resq 21
array2 resq 21

segment .text
global main
extern printf
extern scanf

main:
push RBP

mov RAX, 0 ; Armazena em [a]
mov RCX, 0 ; Armazena em [cnt] (registrador do contador para utilizar no loop)
mov RBX, 0 ; Armazena em [b]

; Loop para preencher o array com as entradas do teclado
INPUT_ARRAY:
	cmp RCX, 5 ; Testa se o array já foi totalmente preenchido
	jz DONE
	mov [cnt], RCX
	mov RAX, 0
        ; Lê do teclado para a variável a
        mov RDI, fmt_in
	mov RSI, a
	call scanf
	; Põe o conteúdo de a e de cnt nos registradores respectivos e armazena o número lido nas duas arrays
        mov RAX, [a]
	mov RCX, [cnt]
	mov [array+RCX*8], RAX
	mov [array2+RCX*8], RAX
	; Incrementa o contador e repete o loop de maneira recursiva
	inc RCX	
	jmp INPUT_ARRAY 

; Limpa os registradores
DONE:
	mov RAX, 0
	mov RCX, 0
	mov RBX, 0	

; Ordenação por Bubble Sort

; Loop externo, percorre cada elemento do array
OUTER_LOOP:
	cmp RCX, 5
	jge END_LOOP ; Saí do loop caso o contador seja >=5, pois o array já foi todo percorrido
	mov [cnt], RCX
	mov RAX, [array+RCX*8]

; Loop interno que compara cada elemento com seu vizinho direito
INNER_LOOP:
	inc RCX
	cmp RCX, 5
	jz OK ; Saí do loop caso o contador seja >=5, pois o array já foi todo percorrido
	cmp RAX, [array+RCX*8] ; Compara RAX (array[i]) com o próximo elemento array[i+1]	
	jle INNER_LOOP ; Comparação verdadeira (vizinhos em ordem crescente), o loop continua		
	xchg RAX, [array+RCX*8] ; Comparação falsa (vizinhos em ordem decrescente), xchg realiza a troca entre os dois elementos
	jmp INNER_LOOP

; Finaliza o loop interno (é necessário recuperar o valor do contador do loop externo de [cnt]) e retorna ao loop externo
OK:
	mov RCX, [cnt]
	mov [array+RCX*8], RAX
	inc RCX
	jmp OUTER_LOOP

; Finaliza o loop externo
END_LOOP:
	mov RAX, 0
	mov RBX, 0
	mov RCX, 0
	mov RAX, [array+RCX*8]
	mov [mini], RAX ; Armazena o primeiro elemento do array ordenado (menor elemento)

	mov RCX, 4	
	mov RAX, [array+RCX*8]
	mov [maxi], RAX ; Armazena o último elemento do array ordenado (maior elemento)
	

	mov RCX, 0
	mov RAX, 0
	mov RBX, 0	

FIND_MAX:
	cmp RCX, 5 ; Se chegou ao final do array ORIGINAL, significa que o maior elemento estava na ultima posição
	mov [cnt], RCX	
	jz PRINT_MAX
	mov RAX, [maxi]
	mov RBX, [array2+RCX*8]
	cmp RAX, RBX ; Compara o elemento maxi com o elemento da array original
	jz PRINT_MAX ; Se forem iguais, significa que encontrou sua posição e pode imprimi-la
	mov RCX, [cnt]
	inc RCX
	jmp FIND_MAX

PRINT_MAX:
	; Imprime o valor máximo e sua posição
        mov RAX, [maxi]
	mov RDI, fmt_out_max
	mov RSI, RCX
	mov RDX, RAX
	call printf
        ; Atualiza RAX e RBX para que a label PRINT_PARITY cheque se o valor máximo é par
	mov RCX, 0
	mov RAX, [maxi]
	mov RBX, 2
        call PRINT_PARITY
    

FIND_MIN:
	cmp RCX, 5 ; Se chegou ao final do array ORIGINAL, significa que o maior elemento estava na ultima posição
	mov [cnt], RCX	
	jz PRINT_MIN
	mov RAX, [mini]
	mov RBX, [array2+RCX*8]
	cmp RAX, RBX ; Compara o elemento maxi com o elemento da array original
	jz PRINT_MIN ; Se forem iguais, significa que encontrou sua posição e pode imprimi-la
	mov RCX, [cnt]
	inc RCX
	jmp FIND_MIN

PRINT_MIN:
	mov RAX, [mini]
	mov RDI, fmt_out_min
	mov RSI, RCX
	mov RDX, RAX
	call printf
        ; Atualiza RAX e RBX para que a label PRINT_PARITY cheque se o valor mínimo é par
        mov RAX, [mini] 
	mov RBX, 2

PRINT_PARITY:
        mov RDX, 0    ; Zera RDX (RDX armazenará o resto da divisão)
        idiv RBX      ; Divide RAX por RBX (RAX / 2), quociente em RAX, resto em RDX
        cmp RDX, 1    ; Compara RDX (resto da divisão) com 1
        jge ELSE      ; Se RDX >= 1 (resto diferente de 0), pula para ELSE
        
        mov RDI, fmt_even ; Define o formato para "par"
        jmp LAST          ; Pula para LAST

        ELSE: 
            mov RDI, fmt_odd  ; Define o formato para "ímpar"
            jmp LAST          ; Pula para LAST
            
        LAST:
            mov RAX , 0    ; Zera RAX e RBX antes de chamar printf
            mov RBX, 0
            call printf    ; Chama printf com os argumentos definidos
        ret


END:
	mov RAX, 0
	pop RBP
ret