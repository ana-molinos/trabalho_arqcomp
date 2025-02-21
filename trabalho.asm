segment .data
a: dq 0
cnt: dq 0
mini: dq 0
maxi: dq 0
min_pos: dq 0
max_pos: dq 0
fmt_in: dq "%lld", 0
fmt_out_max: dq "O maior numero esta na posicao %lld e eh %lld ", 10, 0
fmt_out_min: dq "O menor numero esta na posicao %lld e eh %lld ", 10, 0

segment .bss
array resq 5

segment .text
global main
extern printf
extern scanf
extern fflush

main:
    push RBP

    ; Inicializa o array com 5 elementos
    mov RCX, 0
INPUT_ARRAY: 
    cmp RCX, 5
    jz DONE
    mov [cnt], RCX

    ; Libera o buffer de saída antes de chamar scanf
    mov RDI, 0
    call fflush

    ; Lê o número do teclado
    mov RAX, 0
    mov RDI, fmt_in
    mov RSI, a
    call scanf

    ; Armazena o número lido no array
    mov RAX, [a]
    mov RCX, [cnt]
    mov [array+RCX*8], RAX
    inc RCX
    jmp INPUT_ARRAY 

DONE:
    ; Inicializa mini e maxi com o primeiro elemento do array
    mov RAX, [array]
    mov [mini], RAX
    mov [maxi], RAX
    mov RCX, 0

FIND_MIN_MAX:
    cmp RCX, 5
    jz PRINT_RESULTS
    mov RAX, [array+RCX*8]
    
    ; Verifica se é o menor
    cmp RAX, [mini]
    jge NOT_MIN
    mov [mini], RAX
    mov [min_pos], RCX
NOT_MIN:

    ; Verifica se é o maior
    cmp RAX, [maxi]
    jle NOT_MAX
    mov [maxi], RAX
    mov [max_pos], RCX
NOT_MAX:

    inc RCX
    jmp FIND_MIN_MAX

PRINT_RESULTS:
    ; Imprime o maior número
    mov RDI, fmt_out_max
    mov RSI, [max_pos]
    mov RDX, [maxi]
    call printf
    mov RDI, 0
    call fflush

    ; Imprime o menor número
    mov RDI, fmt_out_min
    mov RSI, [min_pos]
    mov RDX, [mini]
    call printf
    mov RDI, 0
    call fflush

END:
    mov RAX, 0
    pop RBP
ret