symbol boton    = pinC.3
symbol led      = C.5
symbol contador = w11

init: 
    contador = 0
    gosub leer
    hi2csetup i2cmaster, %11010000, i2cslow, i2cbyte
    goto check

mostrar_fecha:
    let b7 = bcdtobin b4
    bintoascii b7, b8, b9, b10
    sertxd(b9, b10, "/") 'dia

    let b7 = bcdtobin b5
    bintoascii b7, b8, b9, b10
    sertxd(b9, b10, "/") 'mes

    let b7 = bcdtobin b6
    bintoascii b7, b8, b9, b10
    sertxd(b9, b10, " a las ") 'a?o

    let b7 = bcdtobin b2
    bintoascii b7, b8, b9, b10
    sertxd(b9, b10, ":") 'horas

    let b7 = bcdtobin b1
    bintoascii b7, b8, b9, b10
    sertxd(b9, b10, ":") 'minutos

    let b7 = bcdtobin b0
    bintoascii b7, b8, b9, b10
    sertxd(b9, b10, 13, 10)	'segundos
	
    return
	
check_contador:
    if contador >= 500 then
        contador = 0
        gosub mostrar_fecha
    else
        contador = contador + 1
    endif

    return

guardar:
    write 0, b0
    write 1, b1
    write 2, b2
    write 3, b3
    write 4, b4
    write 5, b5
    write 6, b6
    return

leer:
    read 0, b0
    read 1, b1
    read 2, b2
    read 3, b3
    read 4, b4
    read 5, b5
    read 6, b6
    return

check:
    if boton = 1 then
        pause 200
        goto encender_led
    else
        gosub check_contador
        goto check
    endif

encender_led:
    low led
    hi2cin 0, (b0, b1, b2, b3, b4, b5, b6)
    gosub guardar
    gosub mostrar_fecha
    goto esperar_stop

esperar_stop:
    if boton = 1 then
        pause 200
        goto apagar_led
    else
        gosub check_contador
        goto esperar_stop
    endif

apagar_led:
    high led
    goto check
