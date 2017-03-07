;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main, KEY_INT, IRQ_SWITCH
            
            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT        

Fila:       DC.B 1  ;Variable para la fila a mirar.
Estado:     DC.B 1  ;Variable para saber si el teclado esta o no activado.


; code section          
MyCode:     SECTION

;**************************************************************
;* Rutina de excepción por interrupción de IRQ
;* Habilita o no la activacion del teclad

IRQ_SWITCH:
            pshh              ;Guardar h en la pila para mantener consistencia
            
			lda   #80
irq_wait:   dbnza irq_wait								
            
            ;bclr  IRQSC_IRQIE,IRQSC ; Deshabilita IRQ para evitar falsas interrupciones
            bset  IRQSC_IRQACK,IRQSC ;Limpia bandera activada por IRQ
            brset 0,Estado,TurnOff ;Definir en que estado se encuentra el teclado
TurnOn:     bset  0,Estado    ;Activar el teclado
            bra   irq_fin
TurnOff:    bclr  0,Estado    ;Desactivar el teclado
irq_fin:    pulh              ;Recuperar h de la pila

            rti               ;Volver de la interrupción
            
            
;*Fin de interrupcion por IRQ
;*********************************************************
 ;*************************************************************
;*Rutina de excepcion por KBI

KEY_INT:    
            lda   #80
kbi_wait:   dbnza kbi_wait	

            bset KBISC_KBACK,KBISC ;Limpiar la bandera de bit de interrupción por teclado
            
            brset 0,Estado,start   ;Verificar que el teclado esté activado
            rti


start:		brclr 0,PTAD,fila0 ;Verificar cual de los cuatro kbi activó la interrupción, filas son entradas
			brclr 1,PTAD,fila1
			brclr 2,PTAD,fila2
			brclr 3,PTAD,fila3
			rti
fila0:      
            brclr 0,PTBD,f0c0 ;Verificar cual columna estaba activada en el momento en el cual se produjo la interrupción
            brclr 1,PTBD,f0c1
            brclr 2,PTBD,f0c2
            brclr 3,PTBD,f0c3
            rti
f0c0:       mov   #%00011110,PTBD ;Asignar el valor uno a la salida de unidades, dejar la columna cero en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti
f0c1:       mov   #%00101101,PTBD ;Asignar el valor dos a la salida de unidades, dejar la columna uno en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti            
f0c2:       mov   #%00111011,PTBD ;Asignar el valor tres a la salida de unidades, dejar la columna dos en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti            
f0c3:       mov   #%00000111,PTBD ;Asignar el valor cero a la salida de unidades, dejar la columna cuatro en bajo.
            bset  4,PTAD      ;Indicador de decimales en uno.
            rti	

fila1:      
            brclr 0,PTBD,f1c0 ;Verificar cual columna estaba activada en el momento en el cual se produjo la interrupción
            brclr 1,PTBD,f1c1
            brclr 2,PTBD,f1c2
            brclr 3,PTBD,f1c3
            rti
f1c0:       mov   #%01001110,PTBD ;Asignar el valor cuatro a la salida de unidades, dejar la columna cero en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti
f1c1:       mov   #%01011101,PTBD ;Asignar el valor cinco a la salida de unidades, dejar la columna uno en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti            
f1c2:       mov   #%01101011,PTBD ;Asignar el valor seis a la salida de unidades, dejar la columna dos en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti            
f1c3:       mov   #%00010111,PTBD ;Asignar el valor uno a la salida de unidades, dejar la columna cuatro en bajo.
            bset  4,PTAD      ;Indicador de decimales en uno.
            rti	            
            		
fila2:      
            brclr 0,PTBD,f2c0 ;Verificar cual columna estaba activada en el momento en el cual se produjo la interrupción
            brclr 1,PTBD,f2c1
            brclr 2,PTBD,f2c2
            brclr 3,PTBD,f2c3
            rti
f2c0:       mov   #%01111110,PTBD ;Asignar el valor siete a la salida de unidades, dejar la columna cero en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti
f2c1:       mov   #%10001101,PTBD ;Asignar el valor ocho a la salida de unidades, dejar la columna uno en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti            
f2c2:       mov   #%10011011,PTBD ;Asignar el valor nueve a la salida de unidades, dejar la columna dos en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti            
f2c3:       mov   #%00100111,PTBD ;Asignar el valor dos a la salida de unidades, dejar la columna cuatro en bajo.
            bset  4,PTAD      ;Indicador de decimales en uno.
            rti	        			
fila3:      
            brclr 0,PTBD,f3c0 ;Verificar cual columna estaba activada en el momento en el cual se produjo la interrupción
            brclr 1,PTBD,f3c1
            brclr 2,PTBD,f3c2
            brclr 3,PTBD,f3c3
            rti
f3c0:       mov   #%01001110,PTBD ;Asignar el valor cuatro a la salida de unidades, dejar la columna cero en bajo.
            bset  4,PTAD      ;Indicador de decimales en uno.
            rti
f3c1:       mov   #%00001101,PTBD ;Asignar el valor cero a la salida de unidades, dejar la columna uno en bajo.
            bclr  4,PTAD      ;Indicador de decimales en cero.
            rti            
f3c2:       mov   #%01011011,PTBD ;Asignar el valor cinco a la salida de unidades, dejar la columna dos en bajo.
            bset  4,PTAD      ;Indicador de decimales en uno.
            rti            
f3c3:       mov   #%00110111,PTBD ;Asignar el valor tres a la salida de unidades, dejar la columna cuatro en bajo.
            bset  4,PTAD      ;Indicador de decimales en uno.
            rti	              
            


            rti
;*Fin de excepcion por KBI
;**********************************************************************


main:
_Startup:
            LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            TXS
            sta   SOPT1       ;Desactivar watchdog
            jsr   configSalidas
            jsr   configIRQ	
            jsr   configKBI		
            mov   #1,Estado
            mov   #0,Fila
            mov   #%11101111,PTAD  ;Configurar estado inicial de los puertos PTAD, solo afectará a bit de decenas
            mov   #%00001111,PTBD  ;Configurar estado inicial de los puertos PTBD, apagará display y mantendra salidas de filas
			CLI			; enable interrupts

mainLoop:
            
            mov   #0,Fila     ;Verifica la fila cero del teclado
            bset  3,PTBD
            bclr  0,PTBD
            lda   #80
wait0:      dbnza wait0	
            
            
            mov   #1,Fila     ;Verifica la fila uno del teclado
            bset  0,PTBD            
            bclr  1,PTBD
            lda   #80
wait1:      dbnza wait1	
            
            
            mov   #2,Fila     ;Verifica la fila dos del teclado
            bset  1,PTBD           
            bclr  2,PTBD
            lda   #80
wait2:      dbnza wait2	
            
            mov   #3,Fila     ;Verifica la fila tres del teclado

            bset  2,PTBD            
            bclr  3,PTBD           
            lda   #80
wait3:      dbnza wait3	
            

            BRA    mainLoop

;************************************************
;Subrutina para configuracion de salidas
configSalidas:
;Configurar PTAD
            
            mov   #%00010000,PTADD ;Configurar entradas y salidas en PTADD
            ;         |||___--------Entradas de columnas
            ;         ||------------Salida de bit de decenas
            ;         |-------------Entrada de IRQ
            mov   #%11101111,PTAD  ;Configurar estado inicial de los puertos PTAD, solo afectará a bit de decenas
            lda   #%00101111
            sta   PTAPE ;Activar Pull-Up para las entradas
            lda   #%00010000
            sta   PTASE ;Activar Slew-Rate para las salidas
            lda   #%00010000
            sta   PTADS ;Activar High-Drive 
;Configurar PTBD
            
            mov   #%11111111,PTBDD ;Configurar entradas y salidas en PTBDD
            ;       |   |____-------Salidas de filas
            ;       |___------------Salidas de Display 
            mov   #%00001111,PTBD  ;Configurar estado inicial de los puertos PTBD, apagará display y mantendra salidas de filas
            lda   #%11111111
            sta   PTASE ;Activar Slew-Rate para las salidas
            lda   #%11111111
            sta   PTADS ;Activar High-Drive 
            
            rts               ;Terminar subrutina
;***************************************
 
;************************************************
;subrutina para configurar IRQ            
configIRQ: 

            bclr  IRQSC_IRQIE,IRQSC ; Deshabilita IRQ para evitar falsas interrupciones
            mov   #%00010111,IRQSC  ; Habilitar IRQ, su pin, su Pull-Up, limpiar la bandera 
                                    ;y activar evento de IRQ en flanco y nivel bajo  
            rts               ;Terminar subrutina
            
;*Fin de subrutina de configuracion de IRQ            
;**************************************************  

;****************************************************
;*Subrutina para configurar KBI
configKBI:
            bclr  KBISC_KBIE,KBISC  ;Desabilita KBI                                   
            bset  KBISC_KBIMOD,KBISC;Detección de flancos y nivel
            mov   #%00000000,KBIES  ;Deja activada los flancos de bajada sobre todas las entradas
            mov   #%00001111,KBIPE  ;Activa pines KBI 0 hasta 3 (PTAD 0 a 3)  
            bset  KBISC_KBACK,KBISC ;Limpia banderas           
            bset  KBISC_KBIE,KBISC  ;Habilita KBI  
            
            rts
            
 ;*Fin de subrutina de configuracion de KBI
 ;******************************************
 

