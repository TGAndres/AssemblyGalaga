title "Proyecto: Galaga" ;codigo opcional. Descripcion breve del programa, el texto entrecomillado se imprime como cabecera en cada página de código
	.model small	;directiva de modelo de memoria, small => 64KB para memoria de programa y 64KB para memoria de datos
	.386			;directiva para indicar version del procesador
	.stack 128 		;Define el tamano del segmento de stack, se mide en bytes
	.data			;Definicion del segmento de datos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Definición de constantes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Valor ASCII de caracteres para el marco del programa
marcoEsqInfIzq 		equ 	200d 	;'╚'
marcoEsqInfDer 		equ 	188d	;'╝'
marcoEsqSupDer 		equ 	187d	;'╗'
marcoEsqSupIzq 		equ 	201d 	;'╔'
marcoCruceVerSup	equ		203d	;'╦'
marcoCruceHorDer	equ 	185d 	;'╣'
marcoCruceVerInf	equ		202d	;'╩'
marcoCruceHorIzq	equ 	204d 	;'╠'
marcoCruce 			equ		206d	;'╬'
marcoHor 			equ 	205d 	;'═'
marcoVer 			equ 	186d 	;'║'
;Atributos de color de BIOS
;Valores de color para carácter
cNegro 			equ		00h
cAzul 			equ		01h
cVerde 			equ 	02h
cCyan 			equ 	03h
cRojo 			equ 	04h
cMagenta 		equ		05h
cCafe 			equ 	06h
cGrisClaro		equ		07h
cGrisOscuro		equ		08h
cAzulClaro		equ		09h
cVerdeClaro		equ		0Ah
cCyanClaro		equ		0Bh
cRojoClaro		equ		0Ch
cMagentaClaro	equ		0Dh
cAmarillo 		equ		0Eh
cBlanco 		equ		0Fh
;Valores de color para fondo de carácter
bgNegro 		equ		00h
bgAzul 			equ		10h
bgVerde 		equ 	20h
bgCyan 			equ 	30h
bgRojo 			equ 	40h
bgMagenta 		equ		50h
bgCafe 			equ 	60h
bgGrisClaro		equ		70h
bgGrisOscuro	equ		80h
bgAzulClaro		equ		90h
bgVerdeClaro	equ		0A0h
bgCyanClaro		equ		0B0h
bgRojoClaro		equ		0C0h
bgMagentaClaro	equ		0D0h
bgAmarillo 		equ		0E0h
bgBlanco 		equ		0F0h
;Valores para delimitar el área de juego
lim_superior 	equ		1
lim_inferior 	equ		23
lim_izquierdo 	equ		1
lim_derecho 	equ		39
;Valores de referencia para la posición inicial del jugador
ini_columna 	equ 	lim_derecho/2
ini_renglon 	equ 	22

;Valores para la posición inicial del enemigo
ini_columna_enemigo 	equ 	lim_derecho/2
ini_renglon_enemigo 	equ 	3

;Valores para la posición de los controles e indicadores dentro del juego
;Lives
lives_col 		equ  	lim_derecho+7
lives_ren 		equ  	4

;Scores
hiscore_ren	 	equ 	11
hiscore_col 	equ 	lim_derecho+7
score_ren	 	equ 	13
score_col 		equ 	lim_derecho+7

;Botón STOP
stop_col 		equ 	lim_derecho+10
stop_ren 		equ 	19
stop_izq 		equ 	stop_col-1
stop_der 		equ 	stop_col+1
stop_sup 		equ 	stop_ren-1
stop_inf 		equ 	stop_ren+1

;Botón PAUSE
pause_col 		equ 	stop_col+10
pause_ren 		equ 	19
pause_izq 		equ 	pause_col-1
pause_der 		equ 	pause_col+1
pause_sup 		equ 	pause_ren-1
pause_inf 		equ 	pause_ren+1

;Botón PLAY
play_col 		equ 	pause_col+10
play_ren 		equ 	19
play_izq 		equ 	play_col-1
play_der 		equ 	play_col+1
play_sup 		equ 	play_ren-1
play_inf 		equ 	play_ren+1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;////////////////////////////////////////////////////
;Definición de variables
;////////////////////////////////////////////////////
titulo 			db 		"GALAGA"
scoreStr 		db 		"SCORE"
hiscoreStr		db 		"HI-SCORE"
livesStr		db 		"LIVES"
blank			db 		"     "
player_lives 	db 		3
player_score 	dw 		0
player_hiscore 	dw 		0

player_col		db 		ini_columna 	;posicion en columna del jugador
player_ren		db 		ini_renglon 	;posicion en renglon del jugador

enemy_col		db 		ini_columna 	;posicion en columna del enemigo
enemy_ren		db 		3 				;posicion en renglon del enemigo

col_aux 		db 		0  		;variable auxiliar para operaciones con posicion - columna
ren_aux 		db 		0 		;variable auxiliar para operaciones con posicion - renglon
aux 			dw 		0	

conta_mov_bala	dw 		0 		;Contador para mover las balas
conta_enemigo   db      0 		;Contador para que dispare la nave roja
contador		dw 		0 		;Contador para mover la nave roja
num_impactos    dw    	0 		;Contador para saber cuántas veces ha sido impactada la nave blanca

hay_bala 		db 		0,0,0,0 ;booleno de las 4 balas blancas posibles
col_bala 		db 		0,0,0,0 ;columna en la que están las 4 balas blancas posibles
ren_bala 		db 		0,0,0,0 ;renglón en el que están las 4 balas blancas posibles

hay_bala_r 		db 		0,0,0,0 ;booleno de las 4 balas rojas posibles
col_bala_r 		db 		0,0,0,0 ;columna en la que están las 4 balas rojas posibles
ren_bala_r 		db 		0,0,0,0 ;renglón en el que están las 4 balas rojas posibles

conta 			db 		0 		

;; Variables de ayuda para lectura de tiempo del sistema
tick_ms			dw 		55 		;55 ms por cada tick del sistema, esta variable se usa para operación de MUL convertir ticks a segundos
mil				dw		1000 	;1000 auxiliar para operación DIV entre 1000
diez 			dw 		10 		;10 auxiliar para operaciones
sesenta			db 		60 		;60 auxiliar para operaciones
status 			db 		0 		;0 stop, 1 play, 2 pause
ticks 			dw		0 		;Variable para almacenar el número de ticks del sistema y usarlo como referencia

;Variables que sirven de parámetros de entrada para el procedimiento IMPRIME_BOTON
boton_caracter 	db 		0
boton_renglon 	db 		0
boton_columna 	db 		0
boton_color		db 		0
boton_bg_color	db 		0


;Auxiliar para calculo de coordenadas del mouse en modo Texto
ocho			db 		8
;Cuando el driver del mouse no está disponible
no_mouse		db 	'No se encuentra driver de mouse. Presione [enter] para salir$'

bool_play		db 		0 	; Variable para saber si el juego esta en ejecución o no.
var_patron3 	db 		1
var_patron2		db 		1 	; Para saber en qué etiqueta del patrón 2 se quedó
var_patron1		db 		1

cadena1 		db    "  ___   _   __  __ ___" 
cadena2 		db   " / __| /_\ |  \/  | __|"
cadena3 		db  "| (_ |/ _ \| |\/| | _|  |"
cadena4 		db   " \___/_/ \_|_|  |_|___|",0Dh,0Ah,"$"

cadena5 		db  "  _____   _____ ___" 
cadena6 		db " / _ \ \ / / __| _ \"
cadena7 		db "| (_) \ V /| _||   /"
cadena8 		db " \___/ \_/ |___|_|_\"


boolGameOver 	db 		0
call_aux 		dw 		0

;////////////////////////////////////////////////////

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;Macros;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
;clear - Limpia pantalla
clear macro
	mov ax,0003h 	;ah = 00h, selecciona modo video
					;al = 03h. Modo texto, 16 colores
	int 10h		;llama interrupcion 10h con opcion 00h. 
				;Establece modo de video limpiando pantalla
endm

;posiciona_cursor - Cambia la posición del cursor a la especificada con 'renglon' y 'columna' 
posiciona_cursor macro renglon,columna
	mov dh,renglon	;dh = renglon
	mov dl,columna	;dl = columna
	mov bx,0
	mov ax,0200h 	;preparar ax para interrupcion, opcion 02h
	int 10h 		;interrupcion 10h y opcion 02h. Cambia posicion del cursor
endm 

;inicializa_ds_es - Inicializa el valor del registro DS y ES
inicializa_ds_es 	macro
	mov ax,@data
	mov ds,ax
	mov es,ax 		;Este registro se va a usar, junto con BP, para imprimir cadenas utilizando interrupción 10h
endm

;muestra_cursor_mouse - Establece la visibilidad del cursor del mouser
muestra_cursor_mouse	macro
	mov ax,1		;opcion 0001h
	int 33h			;int 33h para manejo del mouse. Opcion AX=0001h
					;Habilita la visibilidad del cursor del mouse en el programa
endm

;posiciona_cursor_mouse - Establece la posición inicial del cursor del mouse
posiciona_cursor_mouse	macro columna,renglon
	mov dx,renglon
	mov cx,columna
	mov ax,4		;opcion 0004h
	int 33h			;int 33h para manejo del mouse. Opcion AX=0001h
					;Habilita la visibilidad del cursor del mouse en el programa
endm

;oculta_cursor_teclado - Oculta la visibilidad del cursor del teclado
oculta_cursor_teclado	macro
	mov ah,01h 		;Opcion 01h
	mov cx,2607h 	;Parametro necesario para ocultar cursor
	int 10h 		;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

;apaga_cursor_parpadeo - Deshabilita el parpadeo del cursor cuando se imprimen caracteres con fondo de color
;Habilita 16 colores de fondo
apaga_cursor_parpadeo	macro
	mov ax,1003h 		;Opcion 1003h
	xor bl,bl 			;BL = 0, parámetro para int 10h opción 1003h
  	int 10h 			;int 10, opcion 01h. Cambia la visibilidad del cursor del teclado
endm

;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
;Los colores disponibles están en la lista a continuacion;
; Colores:
; 0h: Negro
; 1h: Azul
; 2h: Verde
; 3h: Cyan
; 4h: Rojo
; 5h: Magenta
; 6h: Cafe
; 7h: Gris Claro
; 8h: Gris Oscuro
; 9h: Azul Claro
; Ah: Verde Claro
; Bh: Cyan Claro
; Ch: Rojo Claro
; Dh: Magenta Claro
; Eh: Amarillo
; Fh: Blanco
; utiliza int 10h opcion 09h
; 'caracter' - caracter que se va a imprimir
; 'color' - color que tomará el caracter
; 'bg_color' - color de fondo para el carácter en la celda
; Cuando se define el color del carácter, éste se hace en el registro BL:
; La parte baja de BL (los 4 bits menos significativos) define el color del carácter
; La parte alta de BL (los 4 bits más significativos) define el color de fondo "background" del carácter
imprime_caracter_color macro caracter,color,bg_color
	mov ah,09h				;preparar AH para interrupcion, opcion 09h
	mov al,caracter 		;AL = caracter a imprimir
	mov bh,0				;BH = numero de pagina
	mov bl,color 			
	or bl,bg_color 			;BL = color del caracter
							;'color' define los 4 bits menos significativos 
							;'bg_color' define los 4 bits más significativos 
	mov cx,1				;CX = numero de veces que se imprime el caracter
							;CX es un argumento necesario para opcion 09h de int 10h
	int 10h 				;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm

;imprime_caracter_color - Imprime un caracter de cierto color en pantalla, especificado por 'caracter', 'color' y 'bg_color'. 
; utiliza int 10h opcion 09h
; 'cadena' - nombre de la cadena en memoria que se va a imprimir
; 'long_cadena' - longitud (en caracteres) de la cadena a imprimir
; 'color' - color que tomarán los caracteres de la cadena
; 'bg_color' - color de fondo para los caracteres en la cadena
imprime_cadena_color macro cadena,long_cadena,color,bg_color
	mov ah,13h				;preparar AH para interrupcion, opcion 13h
	lea bp,cadena 			;BP como apuntador a la cadena a imprimir
	mov bh,0				;BH = numero de pagina
	mov bl,color 			
	or bl,bg_color 			;BL = color del caracter
							;'color' define los 4 bits menos significativos 
							;'bg_color' define los 4 bits más significativos 
	mov cx,long_cadena		;CX = longitud de la cadena, se tomarán este número de localidades a partir del apuntador a la cadena
	int 10h 				;int 10h, AH=09h, imprime el caracter en AL con el color BL
endm

;lee_mouse - Revisa el estado del mouse
;Devuelve:
;;BX - estado de los botones
;;;Si BX = 0000h, ningun boton presionado
;;;Si BX = 0001h, boton izquierdo presionado
;;;Si BX = 0002h, boton derecho presionado
;;;Si BX = 0003h, boton izquierdo y derecho presionados
; (400,120) => 80x25 =>Columna: 400 x 80 / 640 = 50; Renglon: (120 x 25 / 200) = 15 => 50,15
;;CX - columna en la que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
;;DX - renglon en el que se encuentra el mouse en resolucion 640x200 (columnas x renglones)
lee_mouse	macro
	mov ax,0003h
	int 33h
endm

;comprueba_mouse - Revisa si el driver del mouse existe
comprueba_mouse 	macro
	mov ax,0		;opcion 0
	int 33h			;llama interrupcion 33h para manejo del mouse, devuelve un valor en AX
					;Si AX = 0000h, no existe el driver. Si AX = FFFFh, existe driver
endm
;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;Fin Macros;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

	.code
inicio:					;etiqueta inicio
	inicializa_ds_es
	comprueba_mouse		;macro para revisar driver de mouse
	xor ax,0FFFFh		;compara el valor de AX con FFFFh, si el resultado es zero, entonces existe el driver de mouse
	jz imprime_ui		;Si existe el driver del mouse, entonces salta a 'imprime_ui'
	;Si no existe el driver del mouse entonces se muestra un mensaje
	lea dx,[no_mouse]
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.
	jmp teclado		;salta a 'teclado'
imprime_ui:
	clear 					;limpia pantalla
	oculta_cursor_teclado	;oculta cursor del mouse
	apaga_cursor_parpadeo 	;Deshabilita parpadeo del cursor
	call DIBUJA_UI 			;procedimiento que dibuja marco de la interfaz
	muestra_cursor_mouse 	;hace visible el cursor del mouse

	cmp [boolGameOver], 1
	je mostrar_gameover
	jmp mouse_no_clic

mostrar_gameover:
	call IMPRIME_GAMEOVER

;En "mouse_no_clic" se revisa que el boton izquierdo del mouse no esté presionado
;Si el botón está suelto, continúa a la sección "mouse"
;si no, se mantiene indefinidamente en "mouse_no_clic" hasta que se suelte

mouse_no_clic:
	lee_mouse
	test bx,0001h
	jnz mouse_no_clic
;Lee el mouse y avanza hasta que se suelte el boton izquierdo

mouse: 
	lee_mouse
conversion_mouse:
	;Leer la posicion del mouse y hacer la conversion a resolucion
	;80x25 (columnas x renglones) en modo texto
	mov ax,dx 			;Copia DX en AX. DX es un valor entre 0 y 199 (renglon)
	div [ocho] 			;Division de 8 bits
						;divide el valor del renglon en resolucion 640x200 en donde se encuentra el mouse
						;para obtener el valor correspondiente en resolucion 80x25
	xor ah,ah 			;Descartar el residuo de la division anterior
	mov dx,ax 			;Copia AX en DX. AX es un valor entre 0 y 24 (renglon)

	mov ax,cx 			;Copia CX en AX. CX es un valor entre 0 y 639 (columna)
	div [ocho] 			;Division de 8 bits
						;divide el valor de la columna en resolucion 640x200 en donde se encuentra el mouse
						;para obtener el valor correspondiente en resolucion 80x25
	xor ah,ah 			;Descartar el residuo de la division anterior
	mov cx,ax 			;Copia AX en CX. AX es un valor entre 0 y 79 (columna)

	;Aquí se revisa si se hizo clic en el botón izquierdo
	test bx,0001h 		;Para revisar si el boton izquierdo del mouse fue presionado
	jz testplay 		

	;Si el mouse fue presionado en el renglon 0
	;se va a revisar si fue dentro del boton [X]
	cmp dx,0
	je boton_x

	cmp dx, 19d ;primera fila de los botones
	jge botones ;salta si se presionó en esa fila o posterior

	jmp mouse_no_clic

testplay:
	cmp [bool_play], 0
	jz mouse
	jmp play

botones:
	cmp dx, 21d ;ultima fila de los botones
	jbe	botones1 ;salta si se presionó en esa fila o anterior
	jmp mouse_no_clic

botones1:
	cmp cx, 69d ;primera columna del botón de play
	jge boton_play ;salta si la columna es posterior o igual a la primera de play
	cmp cx, 59
	jge boton_pausa ;salta si la columna es posterior o igual a la primera de pausa
	cmp cx, 49
	jge boton_reiniciar ;salta si la columna es posterior o igual a la primera de reiniciar
	jmp mouse_no_clic

boton_play:
	cmp cx, 71 ;última columna del botón de play
	jbe setBool_play ;salta si la columa es anterior o igual a la última de play
	jmp mouse_no_clic

setBool_play:
	mov [bool_play], 1d
	mov [boolGameOver], 0
	call BORRA_GAMEOVER
	jmp play

boton_pausa:
	cmp cx, 61 ;última columna del botón de pausa
	jbe clearBool_play ;salta si la columa es anterior o igual a la última de pausa
	jmp mouse_no_clic

clearBool_play:
	mov [bool_play], 0d
	jmp mouse_no_clic

boton_reiniciar:
	cmp cx, 51 ;última columna deiniciar
	jbe reiniciar ;salta si la columa es anterior o igual a la última de reiniciar
	jmp mouse_no_clic

reiniciar:
	mov player_lives,1
	call IMPACTAR_BLANCA

boton_x:
	jmp boton_x1

;Lógica para revisar si el mouse fue presionado en [X]
;[X] se encuentra en renglon 0 y entre columnas 76 y 78
boton_x1:
	cmp cx,76
	jge boton_x2
	jmp mouse_no_clic
boton_x2:
	cmp cx,78
	jbe salir
	jmp mouse_no_clic

play:
	;Aquí se monitorean las interrupciones para mover la nave, disparar, recibir y hacer daño, etc.
	;Se implementa el movimiento de las balas.
	;Ya que se ejecuta cuando no se está presionando el mouse.
	;El monitoreo de los botones sucede después de esto, una vez que ya se descartó que se esté moviendo la nave,
	;disparando, recibiendo daño, haciendo daño, etc. Porque se regresa al mouse

; En 'controlesUsuario' hacemos la verificación de las entradas de la flecha izquierda o derecha
; para que el usuario pueda mover la nave blanca, a partir del valor ASCII de estas teclas.
controlesUsuario:
    mov ah, 01h ; Revisa el buffer del teclado
    int 16h
    jz llamar_disparo_enemigo ; Salta si no hay tecla presionada

    ; Si hay una tecla presionada, la leemos
    mov ah, 00h
    int 16h

    inc conta_enemigo ;Con cualquier tecla presionada, el contador para la próxima bala enemiga aumenta

    cmp al,'a' ;izquierda
    je flecha_izquierda
    cmp al,'A' ;izquierda
    je flecha_izquierda
    cmp al, 'd' ;derecha
    je flecha_derecha
    cmp al, 'D' ;derecha
    je flecha_derecha
    cmp al, 'o' ;tecla s
    je disparar
    cmp al, 'O' ;tecla s
    je disparar

llamar_disparo_enemigo:
    cmp conta_enemigo, 20
    je dispara_enemigo

llamar_enemigo:
	inc [contador]
	cmp [contador], 1FFFh
	jne llamar_mov_balas
	mov [contador], 0

	call MOVER_ENEMIGO

llamar_mov_balas:
	inc [conta_mov_bala]
	cmp [conta_mov_bala], 0FFFh
	jne mouse
	mov [conta_mov_bala],0
	call AVANZAR_BALAS_AMIGAS
	call AVANZAR_BALAS_ENEMIGAS
    jmp mouse

; Primero se delimita el movimiento de la nave hacia la izquierda, para que en caso de que se presione
; nuevamente la flecha izquierda entonces salte nuevamente a la etiqueta 'controlesUsuario', a la espera
; de que se vuelva a presionar alguna flecha.
; En dado caso de que la nave no rebase el área de juego en la interfaz, se llama a 'MOVER_IZQUIERDA'
; para actualizar la posición de la nave.
flecha_izquierda:
	cmp [player_col], 4d
	jb llamar_disparo_enemigo

	call MOVER_IZQUIERDA
	jmp llamar_disparo_enemigo


; Misma lógica que la etiqueta 'flecha izquierda' pero ahora se delimita a la derecha.
; En dado caso de que la nave no rebase el área de juego en la interfaz, se llama a 'MOVER_DERECHA'
; para actualizar la posición de la nave.
flecha_derecha:
	cmp [player_col], 36d
	ja llamar_disparo_enemigo

	call MOVER_DERECHA
	jmp llamar_disparo_enemigo

disparar:
    call DISPARAR_BALA_AMIGA
    jmp llamar_disparo_enemigo

dispara_enemigo:
    mov conta_enemigo, 0
    call DISPARAR_BALA_ENEMIGA
    jmp llamar_enemigo


;Si no se encontró el driver del mouse, muestra un mensaje y el usuario debe salir tecleando [enter]
teclado:
	mov ah,08h
	int 21h
	cmp al,0Dh		;compara la entrada de teclado si fue [enter]
	jnz teclado 	;Sale del ciclo hasta que presiona la tecla [enter]

salir:				;inicia etiqueta salir
	clear 			;limpia pantalla
	mov ax,4C00h	;AH = 4Ch, opción para terminar programa, AL = 0 Exit Code, código devuelto al finalizar el programa
	int 21h			;señal 21h de interrupción, pasa el control al sistema operativo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;PROCEDIMIENTOS;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	MOVER_IZQUIERDA proc
		call BORRA_JUGADOR
		dec [player_col]
		call IMPRIME_JUGADOR
		ret
	endp

	MOVER_DERECHA proc
		call BORRA_JUGADOR
		inc [player_col]
		call IMPRIME_JUGADOR
		ret
	endp

	ENEMIGO_IZQUIERDA proc
		call BORRA_ENEMIGO
		dec [enemy_col]
		call IMPRIME_ENEMIGO
		ret
	endp

	ENEMIGO_DERECHA proc
		call BORRA_ENEMIGO
		inc [enemy_col]
		call IMPRIME_ENEMIGO
		ret
	endp

	ENEMIGO_ARRIBA proc
		call BORRA_ENEMIGO
		dec [enemy_ren]
		call IMPRIME_ENEMIGO
		ret
	endp

	ENEMIGO_ABAJO proc
		call BORRA_ENEMIGO
		inc [enemy_ren]
		call IMPRIME_ENEMIGO
		ret
	endp

	PATRON3 proc
		cmp [var_patron1], 1d
		je inicio3

		cmp [var_patron1], 2d
		je izquierda3

		cmp [var_patron1], 3d
		je seguir_izquierda3

		cmp [var_patron1], 4d
		je derecha3

		cmp [var_patron1], 5d
		je seguir_derecha3

		cmp [var_patron1], 6d
		je abajo3

		cmp [var_patron1], 7d
		je arriba3

		inicio3:
			cmp [player_lives], 3d
			je izquierda3
			jmp salir3

		izquierda3:
			cmp [enemy_col], 4d
			ja seguir_izquierda3
			jmp derecha3

		seguir_izquierda3:
			call ENEMIGO_IZQUIERDA

			mov [var_patron1], 6
			cmp [enemy_col], 17d
			je salir3

			mov [var_patron1], 2
			jmp salir3

		derecha3:
			cmp [enemy_col], 36d
			jb seguir_derecha3
			jmp izquierda3

		seguir_derecha3:
			call ENEMIGO_DERECHA

			mov [var_patron1], 6
			cmp [enemy_col], 28d
			je salir3

			mov [var_patron1], 4
			jmp salir3

		abajo3:
			cmp [enemy_ren], 19d
			ja arriba3

			call ENEMIGO_ABAJO
			mov [var_patron1], 6
			jmp salir3

		arriba3:
			cmp [enemy_ren], 4d
			jb inicio3

			call ENEMIGO_ARRIBA
			mov [var_patron1], 7
			jmp salir3

		salir3:
			ret
	endp

	PATRON2 proc
		cmp [var_patron2], 1
		je inicio2

		cmp [var_patron2], 2
		je derecha2

		cmp [var_patron2], 3
		je arriba2

		cmp [var_patron2], 4
		je seguir_derecha2

		cmp [var_patron2], 5
		je abajo2

		cmp [var_patron2], 6
		je abajo2_1

		cmp [var_patron2], 7
		je izquierda2

		cmp [var_patron2], 8
		je seguir_izquierda2

		cmp [var_patron2], 9
		je arriba2_1

		inicio2:
			cmp [player_lives], 2d
			je derecha2
			jmp salir2

		derecha2:
			cmp [enemy_col], 36d
			jb seguir_derecha2
			jmp abajo2

		arriba2:
			cmp [enemy_ren], 4d
			jb inicio2

			call ENEMIGO_ARRIBA 
			mov [var_patron2], 3
			jmp salir2

		seguir_derecha2:
			call ENEMIGO_DERECHA

			mov [var_patron2], 3
			cmp [enemy_col], 35d
			je salir2

			mov [var_patron2], 2
			jmp salir2

		abajo2:
			cmp [enemy_ren], 10d
			ja izquierda2

			call ENEMIGO_ABAJO
			mov [var_patron2], 5

			jmp salir2

		abajo2_1:
			cmp [enemy_ren], 19d
			ja arriba2_1

			call ENEMIGO_ABAJO
			mov [var_patron2], 6
			jmp salir2

		izquierda2:
			cmp [enemy_col], 4d
			ja seguir_izquierda2
			jmp derecha2

		seguir_izquierda2:
			call ENEMIGO_IZQUIERDA

			mov [var_patron2], 6
			cmp [enemy_col], 20d
			je salir2

			cmp [enemy_col], 5d
			je salir2

			mov [var_patron2], 7
			jmp salir2

		arriba2_1:
			cmp [enemy_ren], 11d
			jb izquierda2

			call ENEMIGO_ARRIBA
			mov [var_patron2], 9
			jmp salir2

		salir2:
			ret
	endp


	PATRON1 proc
		cmp [var_patron3], 1
		je inicio1

		cmp [var_patron3], 2
		je derecha1

		cmp [var_patron3], 3
		je seguir_derecha1

		cmp [var_patron3], 4
		je izquierda1

		cmp [var_patron3], 5
		je arriba1_3

		cmp [var_patron3], 6
		je seguir_izquierda1

		cmp [var_patron3], 7
		je abajo1

		cmp [var_patron3], 8
		je arriba1

		cmp [var_patron3], 9
		je abajo1_1

		cmp [var_patron3], 10
		je abajo1_2

		cmp [var_patron3], 11
		je arriba1_2


		inicio1:
			cmp [player_lives], 1
			je derecha1
			
		derecha1:
			cmp [enemy_col], 36
			jb seguir_derecha1
			jmp izquierda1

		seguir_derecha1:
			call ENEMIGO_DERECHA

			mov [var_patron3], 10
			cmp [enemy_col], 26d
			je salir1

			mov [var_patron3], 2
			jmp salir1

		izquierda1:
			cmp [enemy_col], 4
			ja seguir_izquierda1
			jmp abajo1_1

		arriba1_3:
			cmp [enemy_ren], 10d
			jb derecha1

			call ENEMIGO_ARRIBA
			mov [var_patron3], 5
			jmp salir1

		seguir_izquierda1:
			call ENEMIGO_IZQUIERDA

			mov [var_patron3], 7
			cmp [enemy_col], 20
			je salir1

			mov [var_patron3], 4
			jmp salir1

		abajo1:
			cmp [enemy_ren], 19
			ja arriba1

			call ENEMIGO_ABAJO
			mov [var_patron3], 7
			jmp salir1

		arriba1:
			cmp [enemy_ren], 4d
			jb izquierda1

			call ENEMIGO_ARRIBA
			mov [var_patron3], 8
			jmp salir1

		abajo1_1:
			cmp [enemy_ren], 10
			ja derecha1

			call ENEMIGO_ABAJO
			mov [var_patron3], 9
			jmp salir1

		abajo1_2:
			cmp [enemy_ren], 19
			ja arriba1_3

			call ENEMIGO_ABAJO
			mov [var_patron3], 10
			jmp salir1

		arriba1_2:
			cmp [enemy_ren], 4
			jb derecha1

			call ENEMIGO_ARRIBA
			mov [var_patron3], 11
			jmp salir1

		salir1:
			ret

		ret
	endp

	MOVER_ENEMIGO proc
		cmp [player_lives], 3d
		je enemigo_patron3

		cmp [player_lives], 2d
		je enemigo_patron2

		cmp [player_lives], 1d
		je enemigo_patron1

		enemigo_patron3:
			call PATRON3
			ret

		enemigo_patron2:
			call PATRON2
			ret

		enemigo_patron1:
			call PATRON1
			ret

		ret
	endp


	DIBUJA_UI proc
		;imprimir esquina superior izquierda del marco
		posiciona_cursor 0,0
		imprime_caracter_color marcoEsqSupIzq,cAmarillo,bgNegro
		
		;imprimir esquina superior derecha del marco
		posiciona_cursor 0,79
		imprime_caracter_color marcoEsqSupDer,cAmarillo,bgNegro
		
		;imprimir esquina inferior izquierda del marco
		posiciona_cursor 24,0
		imprime_caracter_color marcoEsqInfIzq,cAmarillo,bgNegro
		
		;imprimir esquina inferior derecha del marco
		posiciona_cursor 24,79
		imprime_caracter_color marcoEsqInfDer,cAmarillo,bgNegro
		
		;imprimir marcos horizontales, superior e inferior
		mov cx,78 		;CX = 004Eh => CH = 00h, CL = 4Eh 
	marcos_horizontales:
		mov [col_aux],cl
		;Superior
		posiciona_cursor 0,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro
		;Inferior
		posiciona_cursor 24,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro
		
		mov cl,[col_aux]
		loop marcos_horizontales

		;imprimir marcos verticales, derecho e izquierdo
		mov cx,23 		;CX = 0017h => CH = 00h, CL = 17h 
	marcos_verticales:
		mov [ren_aux],cl
		;Izquierdo
		posiciona_cursor [ren_aux],0
		imprime_caracter_color marcoVer,cAmarillo,bgNegro
		;Inferior
		posiciona_cursor [ren_aux],79
		imprime_caracter_color marcoVer,cAmarillo,bgNegro
		;Limite mouse
		posiciona_cursor [ren_aux],lim_derecho+1
		imprime_caracter_color marcoVer,cAmarillo,bgNegro

		mov cl,[ren_aux]
		loop marcos_verticales

		;imprimir marcos horizontales internos
		mov cx,79-lim_derecho-1 		
	marcos_horizontales_internos:
		push cx
		mov [col_aux],cl
		add [col_aux],lim_derecho
		;Interno superior 
		posiciona_cursor 8,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro

		;Interno inferior
		posiciona_cursor 16,[col_aux]
		imprime_caracter_color marcoHor,cAmarillo,bgNegro

		mov cl,[col_aux]
		pop cx
		loop marcos_horizontales_internos

		;imprime intersecciones internas	
		posiciona_cursor 0,lim_derecho+1
		imprime_caracter_color marcoCruceVerSup,cAmarillo,bgNegro
		posiciona_cursor 24,lim_derecho+1
		imprime_caracter_color marcoCruceVerInf,cAmarillo,bgNegro

		posiciona_cursor 8,lim_derecho+1
		imprime_caracter_color marcoCruceHorIzq,cAmarillo,bgNegro
		posiciona_cursor 8,79
		imprime_caracter_color marcoCruceHorDer,cAmarillo,bgNegro

		posiciona_cursor 16,lim_derecho+1
		imprime_caracter_color marcoCruceHorIzq,cAmarillo,bgNegro
		posiciona_cursor 16,79
		imprime_caracter_color marcoCruceHorDer,cAmarillo,bgNegro

		;imprimir [X] para cerrar programa
		posiciona_cursor 0,76
		imprime_caracter_color '[',cAmarillo,bgNegro
		posiciona_cursor 0,77
		imprime_caracter_color 'X',cRojoClaro,bgNegro
		posiciona_cursor 0,78
		imprime_caracter_color ']',cAmarillo,bgNegro

		;imprimir título
		posiciona_cursor 0,37
		imprime_cadena_color [titulo],6,cAmarillo,bgNegro

		call IMPRIME_TEXTOS

		call IMPRIME_BOTONES

		call IMPRIME_DATOS_INICIALES

		call IMPRIME_SCORES

		call IMPRIME_LIVES

		ret
	endp

	IMPRIME_TEXTOS proc
		;Imprime cadena "LIVES"
		posiciona_cursor lives_ren,lives_col
		imprime_cadena_color livesStr,5,cGrisClaro,bgNegro

		;Imprime cadena "SCORE"
		posiciona_cursor score_ren,score_col
		imprime_cadena_color scoreStr,5,cGrisClaro,bgNegro

		;Imprime cadena "HI-SCORE"
		posiciona_cursor hiscore_ren,hiscore_col
		imprime_cadena_color hiscoreStr,8,cGrisClaro,bgNegro
		ret
	endp

	IMPRIME_BOTONES proc
		;Botón STOP
		mov [boton_caracter],254d		;Carácter '■'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],stop_ren 	;Renglón en "stop_ren"
		mov [boton_columna],stop_col 	;Columna en "stop_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		;Botón PAUSE
		mov [boton_caracter],19d 		;Carácter '‼'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],pause_ren 	;Renglón en "pause_ren"
		mov [boton_columna],pause_col 	;Columna en "pause_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		;Botón PLAY
		mov [boton_caracter],16d  		;Carácter '►'
		mov [boton_color],bgAmarillo 	;Background amarillo
		mov [boton_renglon],play_ren 	;Renglón en "play_ren"
		mov [boton_columna],play_col 	;Columna en "play_col"
		call IMPRIME_BOTON 				;Procedimiento para imprimir el botón
		ret
	endp

	IMPRIME_SCORES proc
		;Imprime el valor de la variable player_score en una posición definida
		call IMPRIME_SCORE
		;Imprime el valor de la variable player_hiscore en una posición definida
		call IMPRIME_HISCORE
		ret
	endp

	IMPRIME_SCORE proc
		;Imprime "player_score" en la posición relativa a 'score_ren' y 'score_col'
		mov [ren_aux],score_ren
		mov [col_aux],score_col+20
		mov bx,[player_score]
		call IMPRIME_BX
		ret
	endp

	IMPRIME_HISCORE proc
	;Imprime "player_score" en la posición relativa a 'hiscore_ren' y 'hiscore_col'
		mov [ren_aux],hiscore_ren
		mov [col_aux],hiscore_col+20
		mov bx,[player_hiscore]
		call IMPRIME_BX
		ret
	endp

	;BORRA_SCORES borra los marcadores numéricos de pantalla sustituyendo la cadena de números por espacios
	BORRA_SCORES proc
		call BORRA_SCORE
		call BORRA_HISCORE
		ret
	endp

	BORRA_SCORE proc
		posiciona_cursor score_ren,score_col+20 		;posiciona el cursor relativo a score_ren y score_col
		imprime_cadena_color blank,5,cBlanco,bgNegro 	;imprime cadena blank (espacios) para "borrar" lo que está en pantalla
		ret
	endp

	BORRA_HISCORE proc
		posiciona_cursor hiscore_ren,hiscore_col+20 	;posiciona el cursor relativo a hiscore_ren y hiscore_col
		imprime_cadena_color blank,5,cBlanco,bgNegro 	;imprime cadena blank (espacios) para "borrar" lo que está en pantalla
		ret
	endp

	;Imprime el valor del registro BX como entero sin signo (positivo)
	;Se imprime con 5 dígitos (incluyendo ceros a la izquierda)
	;Se usan divisiones entre 10 para obtener dígito por dígito en un LOOP 5 veces (una por cada dígito)
	IMPRIME_BX proc
		mov ax,bx
		mov cx,5
	div10:
		xor dx,dx
		div [diez]
		push dx
		loop div10
		mov cx,5
	imprime_digito:
		mov [conta],cl
		posiciona_cursor [ren_aux],[col_aux]
		pop dx
		or dl,30h
		imprime_caracter_color dl,cBlanco,bgNegro
		xor ch,ch
		mov cl,[conta]
		inc [col_aux]
		loop imprime_digito
		ret
	endp

	IMPRIME_DATOS_INICIALES proc
		call DATOS_INICIALES 		;inicializa variables de juego
		;imprime la 'nave' del jugador
		;borra la posición actual, luego se reinicia la posición y entonces se vuelve a imprimir
		call BORRA_JUGADOR
		mov [player_col], ini_columna
		mov [player_ren], ini_renglon
		;Imprime jugador
		call IMPRIME_JUGADOR

		;Borrar posicion actual del enemigo y reiniciar su posicion

		;Imprime enemigo
		call IMPRIME_ENEMIGO

		ret
	endp

	;Inicializa variables del juego
	DATOS_INICIALES proc
		mov [player_score],0
		mov [player_lives],3
		ret
	endp

	;BORRA_LIVES para limpiar la parte de cuántas vidas quedan
	BORRA_LIVES proc
		mov al, lives_col+20
		posiciona_cursor lives_ren,al 		
		imprime_cadena_color blank,5,cBlanco,bgNegro
		add al,2
		posiciona_cursor lives_ren,al	
		imprime_cadena_color blank,5,cBlanco,bgNegro 
		add al,2
		posiciona_cursor lives_ren,al 		
		imprime_cadena_color blank,5,cBlanco,bgNegro 
	endp

	;Imprime los caracteres ☻ que representan vidas. Inicialmente se imprime el número de 'player_lives'
	IMPRIME_LIVES proc
		xor cx,cx
		mov di,lives_col+20
		mov cl,[player_lives]
	imprime_live:
		push cx
		mov ax,di
		posiciona_cursor lives_ren,al
		imprime_caracter_color 2d,cCyanClaro,bgNegro
		add di,2
		pop cx
		loop imprime_live
		ret
	endp

	IMPRIME_GAMEOVER proc
		mov [ren_aux], 8
		mov [col_aux], 8

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena1,23,cAmarillo,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena2,23,cAmarillo,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena3,24,cAmarillo,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena4,23,cAmarillo,bgNegro 
		inc [ren_aux]

		inc [col_aux]
		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena5,20,cAmarillo,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena6,20,cAmarillo,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena7,20,cAmarillo,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena8,21,cAmarillo,bgNegro 
		inc [ren_aux]

		ret
	endp

	;Imprime la nave del jugador, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central inferior
	PRINT_PLAYER proc
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		add [ren_aux],2
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		inc [ren_aux]
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		
		add [col_aux],3
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		inc [ren_aux]
		
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cBlanco,bgNegro
		ret
	endp

	BORRA_GAMEOVER proc
		mov [ren_aux], 8
		mov [col_aux], 8

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena1,23,cNegro,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena2,23,cNegro,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena3,24,cNegro,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena4,23,cNegro,bgNegro 
		inc [ren_aux]

		inc [col_aux]
		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena5,20,cNegro,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena6,20,cNegro,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena7,20,cNegro,bgNegro 
		inc [ren_aux]

		posiciona_cursor ren_aux,col_aux
		imprime_cadena_color cadena8,21,cNegro,bgNegro 
		inc [ren_aux]

		ret
	endp

	;Borra la nave del jugador, que recibe como parámetros las variables ren_aux y col_aux, que indican la posición central de la barra
	DELETE_PLAYER proc
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		add [ren_aux],2
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		inc [ren_aux]
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		
		add [col_aux],3
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		inc [ren_aux]
		
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 219,cNegro,bgNegro
		ret
	endp

	;Imprime la nave del enemigo
	PRINT_ENEMY proc

		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cRojo,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]

	    mov ah, 08h		
	    int 10h
	    cmp ah, 0Fh 	; Si impactó en algo de color blanco fondo negro
	    je impacto_blanca_choque
	    jmp continuacion
	    
	    impacto_blanca_choque:
	    	cmp al,219 ;Si impactó en el caracter con el que se hace la nave blanca
	    	jne continuacion
	    	pop [call_aux]
	    	call IMPACTAR_BLANCA
	    	push [call_aux]
	    	ret

		continuacion:
			imprime_caracter_color 178,cRojo,bgNegro
			sub [ren_aux],2
			dec [col_aux]
			posiciona_cursor [ren_aux],[col_aux]
			imprime_caracter_color 178,cRojo,bgNegro
			inc [ren_aux]
			posiciona_cursor [ren_aux],[col_aux]
			imprime_caracter_color 178,cRojo,bgNegro
			dec [ren_aux]
			
			dec [col_aux]
			posiciona_cursor [ren_aux],[col_aux]
			imprime_caracter_color 178,cRojo,bgNegro
			
			add [col_aux],3
			posiciona_cursor [ren_aux],[col_aux]
			imprime_caracter_color 178,cRojo,bgNegro
			inc [ren_aux]
			posiciona_cursor [ren_aux],[col_aux]
			imprime_caracter_color 178,cRojo,bgNegro
			dec [ren_aux]
			
			inc [col_aux]
			posiciona_cursor [ren_aux],[col_aux]
			imprime_caracter_color 178,cRojo,bgNegro
		ret
	endp

	DELETE_ENEMY proc
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		sub [ren_aux],2
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		dec [ren_aux]
		
		dec [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		
		add [col_aux],3
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		inc [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		dec [ren_aux]
		
		inc [col_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color 178,cNegro,bgNegro
		ret
	endp

	;procedimiento IMPRIME_BOTON
	;Dibuja un boton que abarca 3 renglones y 5 columnas
	;con un caracter centrado dentro del boton
	;en la posición que se especifique (esquina superior izquierda)
	;y de un color especificado
	;Utiliza paso de parametros por variables globales
	;Las variables utilizadas son:
	;boton_caracter: debe contener el caracter que va a mostrar el boton
	;boton_renglon: contiene la posicion del renglon en donde inicia el boton
	;boton_columna: contiene la posicion de la columna en donde inicia el boton
	;boton_color: contiene el color del boton
	IMPRIME_BOTON proc
	;background de botón
		mov ax,0600h 		;AH=06h (scroll up window) AL=00h (borrar)
		mov bh,cRojo	 	;Caracteres en color amarillo
		xor bh,[boton_color]
		mov ch,[boton_renglon]
		mov cl,[boton_columna]
		mov dh,ch
		add dh,2
		mov dl,cl
		add dl,2
		int 10h
		mov [col_aux],dl
		mov [ren_aux],dh
		dec [col_aux]
		dec [ren_aux]
		posiciona_cursor [ren_aux],[col_aux]
		imprime_caracter_color [boton_caracter],cRojo,[boton_color]
	ret 			;Regreso de llamada a procedimiento
	endp	 			
	
	BORRA_JUGADOR proc
		mov al,[player_col]
		mov ah,[player_ren]
		mov [col_aux],al
		mov [ren_aux],ah
		call DELETE_PLAYER
		ret
	endp

	IMPRIME_JUGADOR proc
		mov al,[player_col]
		mov ah,[player_ren]
		mov [col_aux],al
		mov [ren_aux],ah
		call PRINT_PLAYER
		ret
	endp

	IMPRIME_ENEMIGO proc
		mov al,[enemy_col]
		mov ah,[enemy_ren]
		mov [col_aux],al
		mov [ren_aux],ah
		call PRINT_ENEMY
		ret
	endp

	BORRA_ENEMIGO proc
		mov al, [enemy_col]
		mov ah, [enemy_ren]
		mov [col_aux], al
		mov [ren_aux], ah
		call DELETE_ENEMY
		ret
	endp

	IMPACTAR_BLANCA proc
		dec player_lives
		cmp player_lives,0
		je terminar_juego
		;Si aún hay vidas, solo actualizarlas
		call BORRA_LIVES
		call IMPRIME_LIVES
		
		call BORRA_JUGADOR
		mov [col_aux], ini_columna
		mov [ren_aux], ini_renglon
		mov [player_col], ini_columna
		mov [player_ren], ini_renglon
		call IMPRIME_JUGADOR

		call BORRA_ENEMIGO
		mov [col_aux],ini_columna_enemigo
		mov [ren_aux],ini_renglon_enemigo
		mov [enemy_col],ini_columna_enemigo
		mov [enemy_ren],ini_renglon_enemigo
		call IMPRIME_ENEMIGO

		ret
		
		;A partir de aquí solo sucede si se acaban
		terminar_juego:
			pop ax ; limpiar el ip anterior, porque ahora tendrá que saltar a inicio
			mov player_lives, 3
			mov ax,player_score
			cmp player_hiscore, ax ;Comparar la puntación de esta partida con la mejor puntuación
			jg reiniciar_score

		nuevo_highscore: ;Esta etiqueta se salta si el score no es mayor al highscore
			mov player_hiscore,ax

		reiniciar_score:
			mov player_score, 0
			mov [boolGameOver], 1
			mov [bool_play], 0
			
			call BORRA_ENEMIGO
			mov [col_aux],ini_columna_enemigo
			mov [ren_aux],ini_renglon_enemigo
			mov [enemy_col],ini_columna_enemigo
			mov [enemy_ren],ini_renglon_enemigo
			call IMPRIME_ENEMIGO
			jmp inicio ;Se regresa acá para que vuelva a todo
	endp

	IMPACTAR_ROJA proc
		inc num_impactos
		inc player_score
		call BORRA_SCORE
		call IMPRIME_SCORE
		cmp num_impactos, 3 ;Si ya impactó 3 veces, se reinicia la nave roja
		je reaparecer_roja
		ret
		; Reinicia la ubicación de la nave roja, y la imprime
		reaparecer_roja:
			call BORRA_ENEMIGO
			mov [col_aux],ini_columna_enemigo
			mov [ren_aux],ini_renglon_enemigo
			mov [enemy_col],ini_columna_enemigo
			mov [enemy_ren],ini_renglon_enemigo
			call IMPRIME_ENEMIGO
			mov num_impactos, 0
		ret
	endp

	AVANZAR_BALAS_ENEMIGAS proc
    	mov si,0

    	moverR:
    		cmp [hay_bala_r+si],0
    		je siguienteR

	    	;BORRA BALA
			posiciona_cursor [ren_bala_r+si],[col_bala_r+si] 	
			imprime_cadena_color blank,1,cBlanco,bgNegro
			;sube la posición de bala
			inc [ren_bala_r+si]
	        
			;Ver si impactó
			posiciona_cursor [ren_bala_r+si],[col_bala_r+si]
	        mov ah, 08h
	        int 10h
	        cmp ah, 0Fh ;Si impactó en algo de color blanco fondo negro
	        je impacto_blanca

	        cmp [ren_bala_r+si], 23
	        jge terminarR
	        jmp imprimirR
	    
	    impacto_blanca:
	    	cmp al,219 ;Si impactó en el caracter con el que se hace la nave blanca
	    	jne imprimirR
	    	call IMPACTAR_BLANCA
	    	jmp terminarR
	    
	    terminarR:
	    	mov [hay_bala_r+si],0
	    	jmp siguienteR

	    imprimirR:
	    	;IMPRIME BALA
			imprime_caracter_color 111,cRojo,bgNegro
		
		siguienteR:
			inc si
			cmp si,4
			jne moverR
    	ret
    endp

    DISPARAR_BALA_ENEMIGA proc
    	lea bx, [hay_bala_r]

    	mov si,0
    	mov ah, [bx+si]
    	cmp ah,0
    	je inicializarR
    	inc si
    	mov ah, [bx+si]
    	cmp ah,0
    	je inicializarR
    	inc si
    	mov ah, [bx+si]
    	cmp ah,0
    	je inicializarR
    	inc si
    	mov ah, [bx+si]
    	cmp ah,0
    	je inicializarR
    	ret

    	inicializarR:
			mov ah, [enemy_ren]
			mov al, [enemy_col]
			lea bx, [ren_bala_r]
			mov [ren_bala_r+si], ah
			mov [col_bala_r+si], al
			inc [ren_bala_r+si]
			inc [ren_bala_r+si]
			inc [ren_bala_r+si]	
			mov [hay_bala_r+si],1
		ret
	endp

    AVANZAR_BALAS_AMIGAS proc
    	mov si,0

    	mover:
    		cmp [hay_bala+si],0
    		je siguiente

	    	;BORRA BALA
			posiciona_cursor [ren_bala+si],[col_bala+si] 	
			imprime_cadena_color blank,1,cBlanco,bgNegro
			
			;sube la posición de bala
			dec [ren_bala+si]
	        
	        ;Ver si impactó
	        posiciona_cursor [ren_bala+si],[col_bala+si]
	        mov ah, 08h
	        int 10h
	        cmp ah, 04h ;Si impactó en algo de fondo negro y con letra roja
	        je impacto_roja

	        cmp [ren_bala+si], 2
	        je terminar
	        jmp imprimir
	    
	    impacto_roja:
	    	cmp al,178 ;Si impactó en el caracter con el que se hace la nave roja
	    	jne imprimir
	    	call IMPACTAR_ROJA
	    	jmp terminar

	    terminar:
	    	mov [hay_bala+si],0
	    	jmp siguiente

	    imprimir:
	    	;IMPRIME BALA
			imprime_caracter_color 111,cBlanco,bgNegro
		
		siguiente:
			inc si
			cmp si,4
			jne mover
    	ret
    endp

    DISPARAR_BALA_AMIGA proc
    	lea bx, [hay_bala]

    	mov si,0
    	mov ah, [bx+si]
    	cmp ah,0
    	je inicializar
    	inc si
    	mov ah, [bx+si]
    	cmp ah,0
    	je inicializar
    	inc si
    	mov ah, [bx+si]
    	cmp ah,0
    	je inicializar
    	inc si
    	mov ah, [bx+si]
    	cmp ah,0
    	je inicializar
    	ret

    	inicializar:
			mov ah, [player_ren]
			mov al, [player_col]
			lea bx, [ren_bala]
			mov [ren_bala+si], ah
			mov [col_bala+si], al
			dec [ren_bala+si]
			dec [ren_bala+si]
			dec [ren_bala+si]	
			mov [hay_bala+si],1
			;call AVANZAR_BALAS_AMIGAS
		ret
	endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;FIN PROCEDIMIENTOS;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end inicio			;fin de etiqueta inicio, fin de programa
