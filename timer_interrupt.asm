.include "m328pdef.inc"
	.equ nek_preskejler = 0x04  ; Prescaler
	.equ cas = 390
.org 0x0000           ; Reset vector
	rjmp reset

.org 0x0016      ; Interrupt vector for TIMER1_COMPA
	rjmp timer_primerjava


reset:
	ldi r16, 0x00
	sts TCCR1A, r16 ; nastavi na naèin CTC
	ldi r16, nek_preskejler
	sts TCCR1B, r16 ; nastavi na prescale :265


	ldi r16, low(cas)
	sts OCR1AL, r16 ; notr da vrednost èasa za primerjavo
	ldi r16, high(cas)
	sts OCR1AH, r16

	ldi r16, 0b0000_0010 ; prižge primerjanje z A
	sts TIMSK1, r16 ; naloži v TIMSK1


	sei
	rjmp start
	.org 0x0100
timer_primerjava:
	push r16
	in r16, PORTB
	cpi r16, 0b0010_0000
	brne prizgi
	cbi PORTB, 5
	pop r16
	reti

start:
	sbi DDRB, 5
	sbi PORTB, 5
	rjmp loop

loop:
	in r16, portb
	rjmp loop

prizgi:
	sbi portb, 5
	pop r16
	reti