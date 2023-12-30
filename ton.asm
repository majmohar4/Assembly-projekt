start:
	ldi r21, 0x11
	call predvajaj_ton
	ldi r21, 0x02
	call predvajaj_ton
	rjmp loop
loop:
	rjmp loop






predvajaj_ton: ; v r21 daš notr frekvenco
	push r16
	push r22
	push r23
	push r24

	sbi DDRB, 5 ; output pin 13
	ldi r16, 0
	call p
	pop r24
	pop r23
	pop r22
	pop r16
	ret
	p: ;loop za prbližn 1 sekundo
		call ton
		clz
		dec r16
		brne p
		ret
	ton:
		sbi PORTB, 5
		mov r22, r21
		call delay1
		cbi PORTB, 5
		mov r22, r21
		call delay1
		ret
	delay1:
		ldi r24, 0x00
		ldi r23, 0x00
		d1:                     
		sbci r24, 0
		sbci r23, 1
		sbci r22, 0
		brcc d1
		ret