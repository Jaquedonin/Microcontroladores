;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    MAR�O DE 2021                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		DADO		;ARMAZENA O DADO PARA A EEPROM

		POSICAO
		POSICAO_2
		POSICAO_3
		POSICAOM
		PIVO
		PIVO_2
		PIVO_3
		AUX1
		

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZA��O DA EEPROM, DE ACORDO COM A DESCRI��O NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDERE�O ZERO DA EEPROM, DADOS EM ORDEM ALEAT�RIA
	ORG 0x2100
	DE	0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X89,0X1E,0X39,0X9F,0XC2,0XAB,0X33,0X63,0X48


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDERE�O � INDICADO EM W
;O DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE UM DADO NA EEPROM, CUJO ENDERE�O � INDICADO EM W
;O DADO A SER ESCRITO DEVE ESTAR ARMAZENADO NA VARI�VEL DADO
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUP��ES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUP��ES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

INICIALIZA
	CLRF	W_TEMP
	MOVLW	0X30
	MOVWF	FSR
REPETE_LEITURA
	MOVFW	W_TEMP
	CALL	LE_EEPROM
	MOVWF	INDF
	INCF	W_TEMP
	INCF	FSR
	BTFSS	FSR,3
	GOTO	REPETE_LEITURA
	RETURN
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	MOVLW	0x37	
	MOVWF	POSICAO
	MOVLW	0x48	
	MOVWF	POSICAO_2
	MOVLW	0x50	
	MOVWF	POSICAO_3
	MOVLW	0x40	
	MOVWF	POSICAOM
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	CALL	INICIALIZA
	GOTO	PIVO_1	;PARTE 1 DO QUICKSORT, PEGAR O PRIMEIRO PIVO

PIVO_1	;SETA O PIVO DE ARRAY PRINCIPAL
    ;CLRF    W_TEMP
    MOVF   POSICAO, W
    MOVWF   FSR	    ;FSR RECEBE ENDERE�O 0X37
    MOVF   INDF,W    ;W RECEBE CONTEUDO DO ENDERE�O 0X37
    MOVWF   PIVO    ;PIVO RECEBE W
    GOTO    LACO_1  ;PARTE 2: TESTAR TODO O ARRAY QUAIS S�O MENORES OU 
		    ;MAIORES QUE O PIVO E COLOCAR EM ARRAYS ADEQUADOS
		
LACO_1	    ;LABEL PARA VARRER TODO O ENDERECO 0X30
    DECF    W_TEMP
    DECF   POSICAO	;DECREMENTA O ENDERECO
    MOVF   POSICAO, W
    MOVWF   FSR
    BTFSC   FSR,4	;TESTA SE ENDERE�O DE MEMORIA AINDA ESTA EM 0X30
    GOTO    LACO_2	;CASO ESTEJA EM 0X30
    GOTO    LOW_1	;CASO NAO ESTEJA MAIS

SET_PIVO_ARRAY	;SETA PIVO AO ARRAY PRINCIPAL
    MOVF   POSICAOM,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR
    MOVF    PIVO_2,W
    MOVWF   INDF
    INCF    POSICAOM
    MOVF   POSICAOM,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR
    MOVF    PIVO,W
    MOVWF   INDF
    INCF    POSICAOM
    GOTO    HIGH_1
    
LACO_2	    ;TESTA QUAIS VALORES S�O MAIORES OU MENOS QUE O PIVO 
    MOVF   INDF,W	;MOVE CONTEUDO DE FSR PARA WORK
    MOVWF   AUX1	;AUX1 RECEBE WORK
    SUBWF   PIVO,W	;SUBTRAI VALOR DE WORK	
    BTFSC   STATUS,C	;TESTA O BIT C DE STATUS, SE ZERO PULA A PROXIMA LINHA
    GOTO    ADD_LOW_ARRAY ;SE PIVO MENOR QUE WORK  
    GOTO    ADD_HIGH_ARRAY;SE PIVO MAIOR QUE WORK

ADD_LOW_ARRAY	;SETA NA MEMORIA 0X20 VALORES MENORES QUE O PIVO
    ;CLRF    W_TEMP
    MOVF   POSICAO_2,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF	;MOVE WORK PARA CONTEUDO DE FSR
    INCF    POSICAO_2	;INCREMENTA POSICAO_1
    GOTO    LACO_1

ADD_HIGH_ARRAY	;SETA OS VALORES NA MEMORIA 0X50, ARRAY DOS MAIORES QUE O PIVO
    ;CLRF    W_TEMP
    MOVF   POSICAO_3,W	;MOVE ENDERCO DE PSC_3 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF	;MOVE WORK PARA CONTEUDO DE FSR
    INCF    POSICAO_3	;INCREMENTA POSICAO_1
    GOTO    LACO_1
	
LOW_1	    ;SETA O PIVO DE LOW_ARRAY
    ;CLRF    W_TEMP
    DECF    POSICAO_2
    MOVF   POSICAO_2,W	
    MOVWF   FSR		;FSR RECEBE ENDERE�O 0X2(X)
    MOVF   INDF,W	;W RECEBE CONTEUDO DO ENDERE�O DE FSR
    MOVWF   PIVO_2	;PIVO RECEBE W
    GOTO    LOW_ARRAY
    
LOW_ARRAY   ;LABEL PARA VARRER ENDERECO 0X20
    
    DECF    POSICAO_2	;DECREMENTA O ENDERECO
    ;CLRF    W_TEMP
    MOVF   POSICAO_2,W	;MOVE PARA WORK
    MOVWF   FSR		;FSR RECEBE WORK
    BTFSC   FSR,3	;TESTA SE ENDERE�O DE MEMORIA AINDA ESTA EM 0X49
    GOTO    ADD_MAIN_0X30_L;CASO ESTEJA 
    GOTO    SET_PIVO_ARRAY	;CASO NAO ESTEJA MAIS

ADD_MAIN_0X30_L   ;SETA OS VALORES NA MEMORIA 0X40 OU NA MEMORIA 0X30
    MOVF   INDF,W	;MOVE CONTEUDO DE FSR PARA WORK
    MOVWF   AUX1	;AUX1 RECEBE WORK
    SUBWF   PIVO_2,W	;SUBTRAI VALOR DE WORK	
    BTFSC   STATUS,C	;TESTA O BIT C DE STATUS, SE ZERO PULA A PROXIMA LINHA
    GOTO    ADD_MAIN_LOW;SE PIVO MENOR QUE WORK  
    GOTO    ADD_0X30_ARRAY;SE PIVO MAIOR QUE WORK
    
ADD_MAIN_LOW
    ;CLRF    W_TEMP
    MOVF   POSICAOM,W	;MOVE ENDERCO DE PSC_M PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF	;MOVE WORK PARA CONTEUDO DE FSR
    INCF    POSICAOM	;INCREMENTA POSICAO_1
    GOTO    LOW_ARRAY
    
ADD_0X30_ARRAY	;ADD AO ARRAY 0X30 OS VALORES MAIORES QUE O PIVO
    ;CLRF    W_TEMP
    MOVF   POSICAO,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF	;MOVE WORK PARA CONTEUDO DE FSR
    INCF    POSICAO	;INCREMENTA POSICAO_1
    GOTO    LOW_ARRAY 
 
HIGH_1	    ;SETA O PIVO DE HIGH_ARRAY
    ;CLRF    W_TEMP
    DECF    POSICAO_3
    MOVF   POSICAO_3,W	
    MOVWF   FSR		;FSR RECEBE ENDERE�O 0X5(X)
    MOVF   INDF,W	;W RECEBE CONTEUDO DO ENDERE�O DE FSR
    MOVWF   PIVO_3	;PIVO RECEBE W
    GOTO    HIGH_ARRAY    

HIGH_ARRAY   ;LABEL PARA VARRER ENDERECO 0X50
    DECF    POSICAO_3	;DECREMENTA O ENDERECO
    ;CLRF    W_TEMP
    MOVF   POSICAO_3,W	;MOVE PARA WORK
    MOVWF   FSR		;FSR RECEBE WORK
    BTFSC   FSR,4	;TESTA SE ENDERE�O DE MEMORIA AINDA ESTA EM 0X50
    GOTO    ADD_MAIN_0X30_H;CASO ESTEJA EM 0X50
    GOTO    TESTE_ULTIMO;CASO NAO ESTEJA MAIS	

ADD_MAIN_0X30_H   ;SETA OS VALORES NA MEMORIA 0X40 OU NA MEMORIA 0X30
    MOVF   INDF,W	;MOVE CONTEUDO DE FSR PARA WORK
    MOVWF   AUX1	;AUX1 RECEBE WORK
    SUBWF   PIVO_3,W	;SUBTRAI VALOR DE WORK	
    BTFSC   STATUS,C	;TESTA O BIT C DE STATUS, SE ZERO PULA A PROXIMA LINHA
    GOTO    ADD_MAIN_HIGH ;SE PIVO MENOR QUE WORK  
    GOTO    ADD_0X30_ARRAY_H;SE PIVO MAIOR QUE WORK
     
ADD_MAIN_HIGH	;SETA OS VALORES NA MEMORIA 0X40
    ;CLRF    W_TEMP
    MOVF   POSICAOM,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF	;MOVE WORK PARA CONTEUDO DE FSR
    INCF    POSICAOM	;INCREMENTA POSICAO_1
    GOTO    HIGH_ARRAY

ADD_0X30_ARRAY_H    ;ADD AO ARRAY 0X30 OS VALORES MAIORES QUE O PIVO
    ;CLRF    W_TEMP
    INCF    POSICAO
    MOVF   POSICAO,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF	;MOVE WORK PARA CONTEUDO DE FSR
    GOTO    HIGH_ARRAY

TESTE_ULTIMO	;TESTE SE � O �LTIMO ELEMENTO A SER ORDENADO
    ;CLRF    W_TEMP
    MOVF   POSICAO,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    BTFSC   FSR, 4	;VERIFICA SE N�O H� ELEMENTOS EM 0X30
    GOTO    SET_PIVO_PIVO_1;CASO N�O
    GOTO    SET_PIVO_ULTIMO;CASO SIM
    
SET_PIVO_PIVO_1	;SETA PIVO AO ARRAY PRINCIPAL ORDENADO E VOLTA PARA PIVO_1
    MOVF   POSICAOM,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR
    MOVF    PIVO_3,W
    MOVWF   INDF
    INCF    POSICAOM
    GOTO    PIVO_1
    
SET_PIVO_ULTIMO	;CASO ESTEJA NO ULTIMO ELEMENTA PARA SER ORDENADO
    MOVF   POSICAOM,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR
    MOVF    PIVO_3,W
    MOVWF   INDF
    GOTO    FINALMENTE_FIM
    
    
FINALMENTE_FIM
    GOTO    FINALMENTE_FIM
	
FIM
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
