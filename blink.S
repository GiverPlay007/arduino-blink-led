#include   "avr/io.h"       ; Inclui a bilbioteca do AVR

.global blink               ; Torna a label blink global

blink: 
  CALL  delay_1s
  SBI   (PORTB-0x20), 5     ; Datasheet informa sobre 32 bytes (0x20) de offset dos registradores
  CALL  delay_1s
  CBI   (PORTB-0x20), 5     ; Porta 5 do registrador B equivale à porta 13
  JMP   blink

delay_1s:
  LDI   r20, 200
  CALL  delay_ms            ; Pequena gambiarra para contornar o
  CALL  delay_ms            ; limite de 8 bits dos registradores
  CALL  delay_ms            ; Não sei fazer de outra forma .-.
  CALL  delay_ms
  CALL  delay_ms
  ret

delay_ms:
  ldi 31, 3200 >> 8        ; O loop leva 5 ciclos de clock para rodar
  ldi 30, 3200 & 255       ; então, repetimos 3200 loops (16 MHz de clock)

delay_loop:                ; Exemplo obtido no fórum do Arduino
  sbiw r30, 1              ; Subtrai 1
  brne delay_loop          ; e repete enquanto r30 não for 0
  subi r20, 1              ; Os milissegundos para delay estão no r20
  brne delay_ms
  ret