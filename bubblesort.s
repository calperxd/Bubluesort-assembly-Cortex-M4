; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
; Função main()
Start  
	
;preencher vetor

	LDR		R0,	=0x20000500				;definir endereço
	MOV		R1,	#0xFF					;pos0
	STR		R1,	[R0], #1
	MOV		R1,	#0xFE						;pos1
	STR		R1,	[R0], #1
	MOV		R1,	#0xFD						;pos2
	STR		R1,	[R0], #1
	MOV		R1,	#0xFC						;pos3
	STR		R1,	[R0], #1
	MOV		R1,	#0xFB						;pos4
	STR		R1,	[R0], #1
	MOV		R1,	#0xFA						;pos5
	STR		R1,	[R0], #1
;fim do preenchimento
;setup
	LDR		R0,	=0x20000500				;definir endereço inicial
	MOV		R3,	#0						;i=0
	MOV		R4,	#6						;tamanho do vetor
	
;função
loop	
	LDRB	R1, [R0]					;carrega a posição i
	LDRB	R2,	[R0,#1]					;carrega a posição i++
	ADD		R3, #1					;i++
	CMP		R3,R4						;R3-R4
	IT	EQ
	BLEQ	reset
	CMP		R1,R2						;R1 - R2
	BLHI	swap
	ADD		R0,		 #1					;endereço+1
	B		loop						;loop infinito



swap
	MOV		R5, R1							;R5 = R1, R5=aux
	MOV		R1,	R2							;R1 = R2
	MOV		R2,	R5							;R2 = R5
	STRB	R1,	[R0],#1
	STRB	R2,	[R0]
	BL		loop
reset
	LDR		R0, =0x20000500;			;definir endereço
	MOV		R3, #0						;i=0
	MOV		R4,	#5						;tamanho
	B		loop
	
fim
	
	NOP
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo