main: readadc c.1, w3
      w3 = w3 * 50 / 255
      bintoascii w3, b1, b2, b3
      sertxd("El voltaje es: ", b2, ".", b3, "v", 13, 10)
      pause 1000
      goto main
