org 00h    ; Define o ponto de origem do programa para o endereço 0x00 na memoria.

START:
	MOV DPTR, #LUT	 ; Inicializa o DPTR com o endereço do primeiro elemento da LUT
	MOV R1, #0        ; Inicializa o registrador R1 com 0
	MOV R0, #0        ; Inicializa o registrador R0 com 0

MAIN: 
	JNB P2.0, UPDATE_DISPLAY   ; Salta para UPDATE_DISPLAY se SW0 ligado a P2.0 estiver apertado
	JNB P2.1, UPDATE_DISPLAY   ; Salta para UPDATE_DISPLAY se SW1 ligado a P2.1 estiver apertado
	SJMP MAIN    ; Salta para MAIN

UPDATE_DISPLAY:
	CLR A    ; Limpa o acumulador A
	MOVC A, @A+DPTR   ; Move o conteudo da memoria apontada por DPTR para A
	MOV P1, A   ; Move o valor do acumulador A para o registrador P1 (possivelmente usado para saida no display)
	INC DPTR    ; Incrementa o DPTR para apontar para o proximo elemento na LUT
	JMP CHOOSE_DELAY   ; Salta para CHOOSE_DELAY

DELAY_1:
	MOV R0, #500   ; Move o valor 500 para R0
	ACALL DELAY_LOOP1   ; Chama a sub-rotina DELAY_LOOP1
	CJNE A, #090h, UPDATE_DISPLAY   ; Compara o acumulador A com 0x90, se forem diferentes, salta para UPDATE_DISPLAY
	ACALL RESET_POINTER   ; Chama a sub-rotina RESET_POINTER
	JMP MAIN   ; Salta incondicionalmente para MAIN

DELAY_LOOP1:
	MOV R1, #1000   ; Move o valor 1000 para R1
	DJNZ R1, $   ; Decrementa R1 ate R1 ser zero
	DJNZ R0, DELAY_LOOP1   ; Decrementa R0 e salta para DELAY_LOOP1 se R0 não for zero
	RET   ; Retorna da sub-rotina

DELAY_025:
	MOV R0, #250   ; Move o valor 250 para R0
	ACALL DELAY_LOOP025   ; Chama a sub-rotina DELAY_LOOP025
	CJNE A, #090h, UPDATE_DISPLAY   ; Compara o acumulador A com 0x90, se forem diferentes, salta para UPDATE_DISPLAY
	ACALL RESET_POINTER   ; Chama a sub-rotina RESET_POINTER
	JMP MAIN   ; Salta incondicionalmente para MAIN

DELAY_LOOP025:
	MOV R1, #500   ; Move o valor 500 para R1
	DJNZ R1, $   ; Decrementa R1 até R1 ser zero
	DJNZ R0, DELAY_LOOP025   ; Decrementa R0 e salta para DELAY_LOOP025 se R0 nao for zero
	RET   ; Retorna da sub-rotina

RESET_POINTER:
	MOV DPTR, #LUT   ; Move o endereço da LUT para DPTR
	RET   ; Retorna da sub-rotina

CHOOSE_DELAY:
	JNB P2.0, DELAY_025   ; Salta para DELAY_025 se o bit P2.0 nao estiver definido
	JNB P2.1, DELAY_1   ; Salta para DELAY_1 se o bit P2.1 nao estiver definido
	JMP CHOOSE_DELAY   ; Salta incondicionalmente para CHOOSE_DELAY

LUT:
	DB 0C0h, 0F9h, 0A4h, 0B0h, 099h, 092h, 082h, 0F8h, 080h, 090h, 000h   ; Tabela de pesquisa (LUT) com valores do display

