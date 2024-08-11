; sam8 -- para maquinas x86
    ; Programa que ilustra como fazer o plot
    ; de pixeis no ecran.
    ; utiliza modo grÃ¡fico de resoluÃ§Ã£o mÃ©dia
    ; 320x200 color mode

STACK    SEGMENT PARA STACK    ; define o seg. de pilha
    DB 64 DUP ('MYSTACK ')
STACK ENDS

MYDATA SEGMENT PARA 'DATA'
INFO    DB    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
ANS    DB    ?
XCOORD1 DW ? ;coord carro 1 vermelho
YCOORD1 DW ? ;coord carro 1 vermelho
XCOORD2 DW ? ;coord carro 2 vermelho
YCOORD2 DW ? ;coord carro 2 vermelho
FLAG DW ?

TITULO0  DB  "*************************************************", 0Ah, '$'
TITULO1  DB  "*********** Selecione uma das opcoes ************", 0Ah, '$'
TITULO2  DB  "*************************************************", 0Ah, '$'

msgComecJogo  DB  "[1] Comecar Jogo", 0Ah, '$'
msgTreino  DB  "[2] Treino", 0Ah, '$'
msgSair  DB  "[3] Sair", 0Ah, '$'

fname1 db "Roadbook.txt",0
fhand dw ?
text db 1024 dup(?)

road_lin dw 200 dup (?)
road_col dw 200 dup (?)

road_linBaixo dw 200 dup (?)

MYDATA    ENDS


MYCODE    SEGMENT PARA 'CODE' ; define o segmento cod. para o MASM
MYPROC    PROC    FAR    ; nome do procedimento MYPROC
ASSUME    CS:MYCODE,DS:MYDATA,SS:STACK
    PUSH    DS     ; guarda na pilha o SEG. DS 
    SUB     AX,AX     ; garante zero no AX 
    PUSH AX ; guarda zero na pilha
    MOV    AX,MYDATA ; coloca em AX a posicao dos DADOS
    MOV    DS,AX    ; coloca essa posicao no reg. DS

    LEA DX, TITULO0			;Copia a mensagem "TITULO0" para o endereÃ§o DX
    MOV AH, 09h				;prepara para escrever no ecra
    INT 21h					;escreve no ecra

    LEA DX, TITULO1			;Copia a mensagem "TITULO1" para o endereÃ§o DX
    MOV AH, 09h				;prepara para escrever no ecra
    INT 21h					;escreve no ecra

    LEA DX, TITULO2			;Copia a mensagem "TITULO0" para o endereÃ§o DX
    MOV AH, 09h				;prepara para escrever no ecra
    INT 21h					;escreve no ecra

    LEA DX, msgComecJogo	;Copia a mensagem "msgComecJogo" para o endereÃ§o DX
    MOV AH, 09h				;prepara para escrever no ecra
    INT 21h					;escreve no ecra

    LEA DX, msgTreino		;Copia a mensagem "msgTreino" para o endereÃ§o DX
    MOV AH, 09h				;prepara para escrever no ecra
    INT 21h					;escreve no ecra

    LEA DX, msgSair			;Copia a mensagem "msgSair" para o endereÃ§o DX
    MOV AH, 09h				;prepara para escrever no ecra
    INT 21h					;escreve no ecra

    CALL ficheiro           ;le e guarda o conteudo do ficheiro num array
    CALL firstLine          ;guarda o primeiro e segundo numero da primeira linha num array

    MOV AH,01h	;leitura de um caracter
	INT 21h		;invoca a interrupÃ§Ã£o do 21h do DOS
	SUB AL,30h	;Conversao de ASCII para hexadecimal   

	CMP AL,01h
	JE Jogo 

	CMP AL,02h
	JE Treino 

	CMP AL,03h
	JE Sair 

	CMP AL,03h
	JG tryAgain 
	

    RET    
    
MYPROC    ENDP    ; fim do procedimento MYPROC     

Treino PROC Near
	; rotina que faz o plot de 3 pontos perto do centro de ecran
    MOV    AH, 00h    ; prepara para definir o modo graf.
    MOV    AL, 04h    ; modo graf. 320x200 color mode
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    MOV    AH,11    ; prepara configuraÃ§Ã£o da palete de cores
    MOV    BH,00    ; inicializa a cor de background
    MOV    BL,01    ; background azul
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    MOV    AH,11    ; prepara configuraÃ§Ã£o da palete de cores
    MOV    BH,01    ; prepara configuraÃ§Ã£o do foreground
    MOV    BL,00    ; verde, vermelho e amarelo
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    XOR BX,BX     

    call corVermelha

    MOV    DX,22h    ; selecciona a linha 
    MOV    CX,10h    ; selecciona a coluna 
	call guardaCoord1 

    CALL DrawRectang

    moverT:
	CALL conversao
	loop moverT
	
	MOV    ah,01h    ; apenas espera
    INT    21h    ; por uma tecla
	
	
    MOV    AH, 00h    ; prepara para definir o modo graf.
    MOV    AL, 02h    ; repor modo texto. 80x25
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS
Treino ENDP

Sair PROC near
	
Sair ENDP

tryAgain PROC near
	RET
tryAgain ENDP

Jogo PROC near
	; rotina que faz o plot de 3 pontos perto do centro de ecran
    MOV    AH, 00h    ; prepara para definir o modo graf.
    MOV    AL, 04h    ; modo graf. 320x200 color mode
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    MOV    AH,11    ; prepara configuraÃ§Ã£o da palete de cores
    MOV    BH,00    ; inicializa a cor de background
    MOV    BL,01    ; background azul
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    MOV    AH,11    ; prepara configuraÃ§Ã£o da palete de cores
    MOV    BH,01    ; prepara configuraÃ§Ã£o do foreground
    MOV    BL,00    ; verde, vermelho e amarelo
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    XOR BX,BX     

    call corVermelha

    MOV    DX,22h    ; selecciona a linha 
    MOV    CX,10h    ; selecciona a coluna 
	call guardaCoord1 

    CALL DrawRectang
	
    MOV DX,43h
    MOV CX,10h
	call guardaCoord2

	MOV    AL,05    ; cor dos pontos verde, configura
    MOV    AH,12    ; configura INT10h para plot do pixel
	
    CALL DrawRectang
	
	mover:
	CALL conversao
	loop mover
	
	MOV    ah,01h    ; apenas espera
    INT    21h    ; por uma tecla
	
	
    MOV    AH, 00h    ; prepara para definir o modo graf.
    MOV    AL, 02h    ; repor modo texto. 80x25
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    RET 
Jogo ENDP

ficheiro PROC near 
        MOV ah,3dh    ; 3dh funcao para abrir o ficheiro
    MOV al,0      ; 0 para leitura
    LEA dx,fname1 ; dx aponta para o nome do ficheiro
    int 21h       ;
    MOV fhand,ax  ; guarda o handle do ficheiro
    MOV si, 0
    
Ler:

    MOV ah,3fh    ; 3fh funcao para ler do ficheiro
    MOV bx,fhand  ; bx recebe o valor do file handle 
    MOV cx,1      ; le um byte
    LEA dx,text[si]
    INT 21h       ; se chegou ao fim o al passa a 0

    CMP al,cl     ; compara se ja chegou ao fim, se 0 = 0
    JNE fechaFile
    INC SI        ; Incrementa o SI(source index)
    JMP Ler     

fechaFile:
    MOV AH,3EH    ; fecha o ficheiro
    INT 21H
    INC si
    MOV text[si], "$"
    MOV ah,09h
    LEA dx, text
    INT 21h
    
    RET          
ficheiro ENDP

firstLine Proc near   
readCoords:    
    mov si,0    ;vai para o primeiro caracter do ficheiro
    mov di,0 
    mov cl, 4   ;diz que o shl vai ser com 4 bits

    mov BL, text[si]    ;BL vai ter o valor do primeiro caracter em ASCII
    sub BL, 30h         ;Tira-se 30h para ter o valor em hexadecimal
    mov DX, bx          ;mete-se o valor em dx
    inc si
   
loopNum:                
    
    shl DX, cl          ;movimenta dx 1 numero para a esquerda em 4 bits
    mov BL, text[si]    ;BL vai ter o valor do proximo caracter
    sub BL, 30h         ;Tira-se 30h para ter o valor em hexadecimal
    ADD DX, bx          ;Mete-se o valor em dx
    
    inc si              ;vai para o proximo caracter
    CMP text[si], 20h   ;Compara se e um espaco
    JE espaco           ;se for 20h que e o valor do espaco em ASCII vai para a label 'espaco' 
    
    CMP text[si], 0Dh   ;Compara se e um espaco
    JE enter            ;se for 0Dh que e o valor do enter em ASCII vai para a label 'enter'  

    JMP loopNum         ;volta para cima

espaco:
    inc si              ;aumenta um caracter mas descartar o espaco
    MOV CX, 10h

    
    MOV road_lin[di], DX
    XOR BX,BX           ;limpa o registo usado para guardar a coordenada da linha
    XOR DX,DX           ;limpa s registo usado para guardar a coordenada da linha
    mov CL, 4
    JMP loopNum         ;vai para a label de cima para obter a proxima coordenada da linha    
    
enter:
    MOV road_linBaixo[di], DX
    RET       
firstLine ENDP

DrawRectang PROC near

    XOR BX,BX     ;limpa a variÃ¡vel que tem o nÃºmero de vezes que foi ao procedimento
    CALL linhaHorizontal

    XOR BX,BX
    CALL linhaVertical

    XOR BX,BX     ;limpa a variÃ¡vel que tem o nÃºmero de vezes que foi ao procedimento
    SUB DX,10h 
    SUB CX, 14h ;tira 14h que vai ser o que o procedimento linhaHorizontal vai mexer 
    CALL linhaVertical

    XOR BX,BX
    CALL linhaHorizontal
	
	;MOV DX,71h
    ;MOV CX,9Eh
    RET

DrawRectang ENDP

linhaHorizontal PROC Near
    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    CMP BX,14h         ;verifica se o procedimento jÃ¡ ocorreu 10 vezes
    JE FimH             ;se jÃ¡ ocorreu salta para a label 'Fim'

    INC BX     ;aumenta o contador de idas ao procedimento
    INC CX  ;aumenta a coluna 1 pixel

    JMP linhaHorizontal  ;se ainda nÃ£o ocorreu 10 vezes salta para cima

FimH: 
    RET

linhaHorizontal ENDP

linhaVertical PROC near

    INT    10h    ; invoca a interrupÃ§Ã£o 10h da BIOS

    CMP BX,10h         ;verifica se o procedimento jÃ¡ ocorreu 10 vezes
    JE FimV             ;se jÃ¡ ocorreu salta para a label 'Fim'

    INC BX     ;aumenta o contador de idas ao procedimento
    INC DX  ;aumenta a linha 1 pixel

    JMP linhaVertical  ;se ainda nÃ£o ocorreu 10 vezes salta para cima

FimV: 
    RET

linhaVertical ENDP

conversao PROC Near
	xor ax, ax  

    MOV    ah,08h    ; apenas espera
    INT    21h    ; por uma tecla
    
    CMP al, 77h
    JE teclaW

    CMP al, 61h
    JE teclaA

    CMP al, 73h
    JE teclaS

    CMP al, 64h
	JE teclaD
	
	CMP al, 69h
	JB Fim
	
	CMP al, 6Ch
	JA Fim
	
	call carro2 ; procedimento para verificar teclas do carro 2(verde)
	
    JMP Fim 

teclaW:
	call passaCoord1
	call corAzul	
	call DrawRectang	
	call passaCoord1
	DEC DX
	call guardaCoord1
	call corVermelha
	call DrawRectang  
	jmp Fim
	
teclaA:
	call passaCoord1
	call corAzul
	call DrawRectang
	call passaCoord1
	DEC CX	
	call guardaCoord1
	call corVermelha
	call DrawRectang  
	jmp Fim
	
teclaS:
	call passaCoord1
	call corAzul
	call DrawRectang
	call passaCoord1
	INC DX
	call guardaCoord1
	call corVermelha
	call DrawRectang 
	jmp Fim

teclaD:
	call passaCoord1
	call corAzul
	call DrawRectang
	call passaCoord1
	INC CX	
	call guardaCoord1
	call corVermelha
	call DrawRectang
	jmp Fim

Fim:

    RET    

conversao ENDP

carro2 PROC Near
	CMP al, 69h
    JE teclaI

    CMP al, 6Ah
    JE teclaJ

    CMP al, 6Bh
    JE teclaK

    CMP al, 6Ch
	JE teclaL
	
	teclaI:
	call passaCoord2
	call corAzul	
	call DrawRectang	
	call passaCoord2
	DEC DX
	call guardaCoord2
	call corVerde
	call DrawRectang  
	jmp FimCarro
	
teclaJ:
	call passaCoord2
	call corAzul
	call DrawRectang
	call passaCoord2
	DEC CX	
	call guardaCoord2
	call corVerde
	call DrawRectang  
	jmp FimCarro

teclaK:
	call passaCoord2
	call corAzul
	call DrawRectang
	call passaCoord2
	INC DX
	call guardaCoord2
	call corVerde
	call DrawRectang 
	jmp FimCarro
	
teclaL:
	call passaCoord2
	call corAzul
	call DrawRectang
	call passaCoord2
	INC CX	
	call guardaCoord2
	call corVerde
	call DrawRectang
	
	FimCarro:
	
	RET
carro2 ENDP

passaCoord1 PROC Near
	MOV DX, XCOORD1 ;atribui novo valor a coluna do carro 1 (vermelho)
    MOV CX, YCOORD1	;atribui novo valor a linha do carro 1 (vermelho)
	RET
passaCoord1 ENDP

guardaCoord1 PROC Near
	MOV XCOORD1, DX ;guarda valor atual da coluna do carro 1 (vermelho)
	MOV YCOORD1, CX ;guarda valor atual da linha do carro 1 (vermelho)
	RET
guardaCoord1 ENDP

passaCoord2 PROC Near
	MOV DX, XCOORD2 ;atribui novo valor a coluna do carro 2 (verde)
    MOV CX, YCOORD2 ;atribui novo valor a linha do carro 2 (verde)
	RET
passaCoord2 ENDP

guardaCoord2 PROC Near
	MOV XCOORD2, DX ;guarda valor atual da coluna do carro 2 (verde)
	MOV YCOORD2, CX ;guarda valor atual da linha do carro 2 (verde)
	RET
guardaCoord2 ENDP

corVermelha PROC Near
	MOV    AL,02    ; cor dos pontos verde, configura
    MOV    AH,12    ; configura INT10h para plot do pixel
	RET
corVermelha ENDP

corAzul PROC Near
	MOV    AL,00    ; cor dos pontos verde, configura
    MOV    AH,12    ; configura INT10h para plot do pixel
	RET
corAzul ENDP

corVerde PROC Near
	MOV    AL,05    ; cor dos pontos verde, configura
    MOV    AH,12    ; configura INT10h para plot do pixel
	RET
corVerde ENDP

RET    ; retorna o controlo ao DOS

MYCODE    ENDS    ; fim do seg. de codigo
            
    END    ; fim de todo o programa