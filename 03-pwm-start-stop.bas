init:       symbol start_button       = pinC.0 ' boton start en pin C0
            symbol stop_button        = pinC.2 ' boton stop en pin C2
            symbol control_intensidad = C.1    ' el potenciometro se lee en el pin C1
            symbol valor              = w0     ' el valor del potenciometro se almacena en w0
            symbol led_variable_pin   = C.5    ' el LED que varia su intensidad se conecta al pin C5
            symbol led_fijo_pin       = B.7    ' el LED indicador (de intensidad fija) se conecta al pin B7

main:       pause 100
            ' se escribe un punto en la pantalla mienstras esta esperando.
            sertxd(".") 
            ' Esperando a que el pull-up se active con 0 logico, si se activa se ejecuta la rutina 
            ' "activar"; de lo contrario se regresa al inicio de la rutina "main" para dejar en ciclado 
            ' el programa esperando hasta que se presione el boton start.
            if start_button = 0 then activar
            goto main

activar:    ' se enciende el led fijo con un cero logico
            low led_fijo_pin 
            ' se escribe un mensaje en la consola de que se ha activado el programa.
            sertxd(13, 10, "Activado", 13, 10)
            ' se ejecuta la rutina escuchar hasta que se detenga el programa.
            goto escuchar
            
escuchar:   ' se lee el valor que indique el potenciometro y se almacena en la variable "valor"
            readadc control_intensidad, valor
            ' se especifica el valor enviadolo como Pulse Width Modulation al led, con 20 ciclos.
            pwm led_variable_pin, valor, 20
            ' si el usuario presiona el boton stop (con 1 logico) se desactiva el programa,
            ' de lo contrario se regresa a la rutina "escuchar" para enciclar el programa.
            if stop_button = 1 then desactivar
            goto escuchar
         
desactivar: ' se escribe el mensaje "Inactivo" en la consola.
            sertxd("Inactivo", 13, 10)
            ' Se apaga el led fijo con un 1 logico.
            high led_fijo_pin
            ' Se apaga el led variable con un 0 logico.
            low led_variable_pin
            ' se regresa al main a esperar que se presione el boton start.
            goto main
