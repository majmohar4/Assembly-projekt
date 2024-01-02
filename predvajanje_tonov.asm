.include "m328pdef.inc"
.equ nek_preskejler = 0x03  ; Prescaler
	.equ time = 105
.org 0x0000           
    rjmp reset

.org 0x0016           ; nappiše na interrupt naslov
    rjmp odstevaj


reset:
    ldi r16, 0x00
	sts TCCR1A, r16 ; nastavi na nacin CTC
	ldi r16, 0x04
	sts TCCR1B, r16 ; nastavi na prescale

    ldi r16, low(time)
    sts OCR1AL, r16    ; vpiše vrednost, s katero primerja
    ldi r16, high(time)
    sts OCR1AH, r16

	ldi r16, 0b0000_0010 ; prižge primerjanje z A
	sts TIMSK1, r16 ; naloži v TIMSK1

    sei
    rjmp start
	.org 0x0100
odstevaj: ; stvar k se zgodi vsake neki ?asa (glede na timer)
	and r16, r16
	brne minus
    reti


start: ; vpiši tone, ki jih želiš predvajati
	ldi r16, 0x01
	ldi r21, 0x10
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x02
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x03
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x04
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x05
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x06
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x07
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x08
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x09
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x10
	call predvajaj_ton
	ldi r16, 0x01
	ldi r21, 0x11
	call predvajaj_ton
	rjmp loop
loop:
	nop
	nop
	rjmp loop

minus: ; samo odšteje ?as (kot urica)
	dec r16
	reti

predvajaj_ton: ; v r21 daš notr frekvenco
	push r22
	push r23
	push r24

	sbi DDRB, 5 ; output pin 13
	call p
	pop r24
	pop r23
	pop r22
	ret
	p: ;ponavlja, dokler ?asa ne odšteje do 0
		call ton
		and r16, r16
		brne p
		ret
	ton: ; predvaja frekvenco s pomo?jo prižiganja in ugašanja porta in delaya vmes
		sbi PORTB, 5
		mov r22, r21
		call delay1
		cbi PORTB, 5
		mov r22, r21
		call delay1
		ret
	delay1: ; delay, dolo?en s frekvenco
		ldi r24, 0x00
		ldi r23, 0x00
		d1:                     
		sbci r24, 0
		sbci r23, 1
		sbci r22, 0
		brcc d1
		ret