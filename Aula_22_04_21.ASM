;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    MARÇO DE 2021                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		DADO		;ARMAZENA O DADO PARA A EEPROM

		POSICAO
		POSICAO_2
		POSICAO_3
		POSICAOM
		PIVO
		PIVO_2
		PIVO_3
		AUX1
		AUX2
		AUX3
		

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZAÇÃO DA EEPROM, DE ACORDO COM A DESCRIÇÃO NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDEREÇO ZERO DA EEPROM, DADOS EM ORDEM ALEATÓRIA
	ORG 0x2100
	DE  0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X89,0X1E,0X39,0X9F,0XC2,0XAB,0X33,0X63,0X48


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;O DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE UM DADO NA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;O DADO A SER ESCRITO DEVE ESTAR ARMAZENADO NA VARIÁVEL DADO
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUPÇÕES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUPÇÕES
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
	BTFSC	FSR,4
	GOTO	REPETE_LEITURA
	RETURN
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	MOVLW	0x3E	
	MOVWF	POSICAO
	MOVLW	0x48	
	MOVWF	POSICAO_2
	MOVLW	0x50	
	MOVWF	POSICAO_3
	MOVLW	0x40	
	MOVWF	POSICAOM
;	MOVLW	0x4E	
;	MOVWF	POSICAOM_2
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	CALL	INICIALIZA
	GOTO	PIVO_1	;PARTE 1 DO QUICKSORT, PEGAR O PRIMEIRO PIVO

PIVO_1	;SETA O PIVO DE ARRAY PRINCIPAL
    ;CLRF    W_TEMP
    MOVF   POSICAO, W
    MOVWF   FSR	    ;FSR RECEBE ENDEREÇO 0X37
    MOVF   INDF,W    ;W RECEBE CONTEUDO DO ENDEREÇO 0X37
    MOVWF   PIVO    ;PIVO RECEBE W
    GOTO    LACO_1  ;PARTE 2: TESTAR TODO O ARRAY QUAIS SÃO MENORES OU 
		    ;MAIORES QUE O PIVO E COLOCAR EM ARRAYS ADEQUADOS
		
LACO_1	    ;LABEL PARA VARRER TODO O ENDERECO 0X30
    DECF    W_TEMP
    DECF   POSICAO	;DECREMENTA O ENDERECO
    MOVF   POSICAO, W
    MOVWF   FSR
    BTFSC   FSR,4	;TESTA SE ENDEREÇO DE MEMORIA AINDA ESTA EM 0X30
    GOTO    LACO_2	;CASO ESTEJA EM 0X30
    GOTO    LOW_1	;CASO NAO ESTEJA MAIS

LOW_TESTE
    
LACO_2	    ;TESTA QUAIS VALORES SÃO MAIORES OU MENOS QUE O PIVO 
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
    MOVWF   FSR		;FSR RECEBE ENDEREÇO 0X2(X)
    MOVF   INDF,W	;W RECEBE CONTEUDO DO ENDEREÇO DE FSR
    MOVWF   PIVO_2	;PIVO RECEBE W
    GOTO    LOW_ARRAY
    
LOW_ARRAY   ;LABEL PARA VARRER ENDERECO 0X20   
    DECF    POSICAO_2	;DECREMENTA O ENDERECO
    ;CLRF    W_TEMP
    MOVF   POSICAO_2,W	;MOVE PARA WORK
    MOVWF   FSR		;FSR RECEBE WORK
    BTFSC   FSR,3	;TESTA SE ENDEREÇO DE MEMORIA AINDA ESTA EM 0X48
    GOTO    ADD_MAIN_0X30_L;CASO ESTEJA 
    GOTO    TESTE_ULTIMO_L	;CASO NAO ESTEJA MAIS

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
    INCF    POSICAO
    MOVF   POSICAO,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF	;MOVE WORK PARA CONTEUDO DE FSR
    GOTO    LOW_ARRAY 

TESTE_ULTIMO_L	;TESTE SE É O ÚLTIMO ELEMENTO A SER ORDENADO
    ;CLRF    W_TEMP
    MOVF   POSICAO,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    BTFSC   FSR, 4	;VERIFICA SE NÃO HÁ ELEMENTOS EM 0X30
    GOTO    SET_PIVO_1_PIVO_1;CASO SIM
    GOTO    SET_PIVO_ARRAY;CASO NÃO
    
SET_PIVO_1_PIVO_1   ;SETA PIVO AO ARRAY PRINCIPAL CASO AINDA TENHA ELEMENTOS EM 0X30
    MOVF   POSICAOM,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR
    MOVF    PIVO_2,W
    MOVWF   INDF
    INCF    POSICAOM
    MOVF   POSICAO,W	
    MOVWF   FSR
    MOVF    INDF,W
    MOVWF   AUX1
    MOVF   POSICAOM,W
    MOVWF   FSR
    MOVF    AUX1,W
    MOVWF   INDF
    INCF    POSICAOM 
    MOVF   POSICAOM,W
    MOVWF   FSR
    MOVF    PIVO,W
    MOVWF   INDF
    INCF    POSICAOM
    GOTO    HIGH_1  
    
SET_PIVO_ARRAY	;SETA PIVO AO ARRAY PRINCIPAL CASO NÃO TENHA NADA EM 0X30
    MOVF   POSICAOM,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR
    MOVF    PIVO_2,W
    MOVWF   INDF
    INCF    POSICAOM
    MOVF   POSICAOM,W
    MOVWF   FSR
    MOVF    PIVO,W
    MOVWF   INDF
    INCF    POSICAOM
    GOTO    HIGH_1
    
    
HIGH_1	    ;SETA O PIVO DE HIGH_ARRAY
    ;CLRF    W_TEMP
    DECF   POSICAO_3
    MOVF   POSICAO_3,W	
    MOVWF   FSR		;FSR RECEBE ENDEREÇO 0X5(X)
    MOVF   INDF,W	;W RECEBE CONTEUDO DO ENDEREÇO DE FSR
    MOVWF   PIVO_3	;PIVO RECEBE W
    GOTO    HIGH_ARRAY    

HIGH_ARRAY   ;LABEL PARA VARRER ENDERECO 0X50
    DECF    POSICAO_3	;DECREMENTA O ENDERECO
    MOVF   POSICAO_3,W	;MOVE PARA WORK
    MOVWF   FSR		;FSR RECEBE WORK
    BTFSC   FSR,4	;TESTA SE ENDEREÇO DE MEMORIA AINDA ESTA EM 0X50
    GOTO    ADD_MAIN_0X30_H;CASO ESTEJA EM 0X50
    GOTO    PIVO_1_1;CASO NAO ESTEJA MAIS	


PIVO_1_1
    DECF    POSICAO
    INCF    POSICAO_3
    INCF    POSICAO_2
    MOVF   PIVO_3,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   AUX3
    GOTO    PIVO_1
    
ADD_MAIN_0X30_H   ;SETA OS VALORES NA MEMORIA 0X40 OU NA MEMORIA 0X30
    MOVF   INDF,W	;MOVE CONTEUDO DE FSR PARA WORK
    MOVWF   AUX1	;AUX1 RECEBE WORK
    SUBWF   PIVO_3,W	;SUBTRAI VALOR DE WORK	
    BTFSC   STATUS,C	;TESTA O BIT C DE STATUS, SE ZERO PULA A PROXIMA LINHA
    GOTO    ADD_L_ARRAY ;SE PIVO MENOR QUE WORK  
    GOTO    ADD_TO_AUX;SE PIVO MAIOR QUE WORK

ADD_L_ARRAY	;SETA NA MEMORIA 0X30 VALORES MENORES QUE O PIVO
    MOVF   POSICAO_2,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF
    INCF   POSICAO_2
    GOTO   HIGH_ARRAY   
    

ADD_TO_AUX  ;MOVE VALOR MAIOR PARA AUXILIAR_2
    MOVF   POSICAO,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    MOVF   AUX1,W	;MOVE VALOR DE AUX1 PARA WORK
    MOVWF   INDF
    INCF   POSICAO
    GOTO    HIGH_ARRAY
    
    MOVF   AUX1,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   AUX2
    GOTO    HIGH_ARRAY

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

TESTE_LOW
    ;DECF   POSICAO_2
    MOVF   POSICAO_2,W	
    MOVWF   FSR		;FSR RECEBE ENDEREÇO 0X2(X)
    MOVF   INDF,W	;W RECEBE CONTEUDO DO ENDEREÇO DE FSR
    MOVWF   PIVO_2	;PIVO RECEBE W
    ;GOTO    LOW_ARRAY_2

 
    
TESTE_ULTIMO	;TESTE SE É O ÚLTIMO ELEMENTO A SER ORDENADO
    ;CLRF    W_TEMP
    MOVF   POSICAO,W	;MOVE ENDERCO DE PSC_2 PARA WORK
    MOVWF   FSR		;MOVE WORK PARA FSR
    BTFSC   FSR, 4	;VERIFICA SE NÃO HÁ ELEMENTOS EM 0X30
    GOTO    SET_PIVO_PIVO_1;CASO NÃO
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
