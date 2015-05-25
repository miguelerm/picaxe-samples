    symbol start_button       = pinC.0 ' boton start en pin C0
    symbol stop_button        = pinC.2 ' boton stop en pin C2
    symbol mas_button         = pinC.3 ' boton mas en pin C3
    symbol menos_button       = pinC.4 ' boton menos en pin C4
    symbol valor              = b0     ' el valor establecido con botones (mas/menos) se almacena en b0
    symbol intensidad         = w4     ' el valor que se envia con la funcion pwm se almacena en w0
    symbol led_variable_pin   = C.5    ' el LED que varia su intensidad se conecta al pin C5
    symbol led_fijo_pin       = B.7    ' el LED indicador (de intensidad fija) se conecta al pin B7

    symbol centenas           = b1
    symbol decenas            = b2
    symbol unidades           = b3
    
		' se inicializan tanto valor como intensidad a cero.
    valor      = 0
    intensidad = 0
		
    pwmout led_variable_pin, 1023, 100
    pwmduty led_variable_pin, 0

main:
    pause 100
    ' se escribe un punto en la pantalla mienstras esta esperando.
    sertxd(".") 
    ' Esperando a que el pull-up se active con 0 logico, si se activa se ejecuta la rutina 
    ' "activar"; de lo contrario se regresa al inicio de la rutina "main" para dejar enciclado 
    ' el programa esperando hasta que se presione el boton start.
    if start_button = 0 then activar
    goto main

activar:
    ' se enciende el led fijo con un cero logico
    low led_fijo_pin 
    ' se escribe un mensaje en la consola de que se ha activado el programa.
    sertxd(13, 10, "Activo", 13, 10)
    ' se ejecuta la rutina escuchar hasta que se detenga el programa.
    goto escuchar
            
escuchar:
    pause 100
    ' si se presiona el boton mas se suma uno al "valor"
    ' si se presiona el boton menos se resta uno al "valor"
		' si el valor no puede excederse de 10 ni ser menor que cero.
    if mas_button = 1 and valor < 10 then 
		    valor = valor + 1
        ' se convierte el valor a ascii.
        bintoascii valor, centenas, decenas, unidades
        ' se muestra el valor en la consola
        sertxd("Valor: ", decenas, unidades, 13, 10)
    elseif menos_button = 1 and valor > 0 then 
        valor = valor - 1
        ' se convierte el valor a ascii.
        bintoascii valor, centenas, decenas, unidades
        ' se muestra el valor en la consola
        sertxd("Valor: ", decenas, unidades, 13, 10)
    endif
			
    ' se convierte con una regla de tres el valor que se encuentra
    ' entre 0 a 10 a una intensidad comprendida de 0 a 255
    intensidad = valor * 1023 / 10
		
    pwmduty led_variable_pin, intensidad
    ' si el usuario presiona el boton stop (con 1 logico) se desactiva el programa,
    ' de lo contrario se regresa a la rutina "escuchar" para enciclar el programa.
    if stop_button = 1 then desactivar
    goto escuchar
         
desactivar:
    ' se escribe el mensaje "Inactivo" en la consola.
    sertxd("Inactivo", 13, 10)
    ' Se apaga el led fijo con un 1 logico.
		valor = 0
		intensidad = 0;
		pwmduty led_variable_pin, intensidad
    high led_fijo_pin
    ' Se apaga el led variable con un 0 logico.
    low led_variable_pin
    ' se regresa al main a esperar que se presione el boton start.
    goto main
