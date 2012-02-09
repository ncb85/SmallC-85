;
;------------------------------------------------------------------
;	Small-C  Run-time Library
;
;	V4d	As of July 16, 1980 (gtf)
;		   Added EXIT() function
;------------------------------------------------------------------
;
;Fetch a single byte from the address in HL and sign extend into HL
CCGCHAR: MOV	A,M
CCSXT:	MOV	L,A
	RLC
	SBB	A
	MOV	H,A
	RET
;Fetch a full 16-bit integer from the address in HL
CCGINT: MOV	A,M
	INX	H
	MOV	H,M
	MOV	L,A
	RET
;Store a single byte from HL at the address in DE
CCPCHAR: MOV	A,L
	STAX	D
	RET
;Store a 16-bit integer in HL at the address in DE
CCPINT: MOV	A,L
	STAX	D
	INX	D
	MOV	A,H
	STAX	D
	RET
;Inclusive "or" HL and DE into HL
CCOR:	MOV	A,L
	ORA	E
	MOV	L,A
	MOV	A,H
	ORA	D
	MOV	H,A
	RET
;Exclusive "or" HL and DE into HL
CCXOR:	MOV	A,L
	XRA	E
	MOV	L,A
	MOV	A,H
	XRA	D
	MOV	H,A
	RET
;"And" HL and DE into HL
CCAND:	MOV	A,L
	ANA	E
	MOV	L,A
	MOV	A,H
	ANA	D
	MOV	H,A
	RET
;Test if HL = DE and set HL = 1 if true else 0
CCEQ:	CALL	CCCMP
	RZ
	DCX	H
	RET
;Test if DE ~= HL
CCNE:	CALL	CCCMP
	RNZ
	DCX	H
	RET
;Test if DE > HL (signed)
CCGT:	XCHG
	CALL	CCCMP
	RC
	DCX	H
	RET
;Test if DE <= HL (signed)
CCLE:	CALL	CCCMP
	RZ
	RC
	DCX	H
	RET
;Test if DE >= HL (signed)
CCGE:	CALL	CCCMP
	RNC
	DCX	H
	RET
;Test if DE < HL (signed)
CCLT:	CALL	CCCMP
	RC
	DCX	H
	RET
; Signed compare of DE and HL
; Performs DE - HL and sets the conditions:
;	Carry reflects sign of difference (set means DE < HL)
;	Zero/non-zero set according to equality.
CCCMP:	MOV	A,E
	SUB	L
	MOV	E,A
	MOV	A,D
	SBB	H
	LXI	H,1
	JM	CCCMP1
	ORA	E	;"OR" resets carry
	RET
CCCMP1: ORA	E
	STC		;set carry to signal minus
	RET
;Test if DE >= HL (unsigned)
CCUGE:	CALL	CCUCMP
	RNC
	DCX	H
	RET	
;Test if DE < HL (unsigned)
CCULT:	CALL	CCUCMP
	RC
	DCX	H
	RET
;Test if DE > HL (unsigned)
CCUGT:	XCHG
	CALL	CCUCMP
	RC
	DCX	H
	RET
;Test if DE <= HL (unsigned)
CCULE:	CALL	CCUCMP
	RZ
	RC
	DCX	H
	RET
;Routine to perform unsigned compare
;carry set if DE < HL
;zero/nonzero set accordingly
CCUCMP: MOV	A,D
	CMP	H
	JNZ	.+5
	MOV	A,E
	CMP	L
	LXI	H,1
	RET
;Shift DE arithmetically right by HL and return in HL
CCASR:	XCHG
	MOV	A,H
	RAL
	MOV	A,H
	RAR
	MOV	H,A
	MOV	A,L
	RAR
	MOV	L,A
	DCR	E
	JNZ	CCASR+1
	RET
;Shift DE arithmetically left by HL and return in HL
CCASL:	XCHG
	DAD	H
	DCR	E
	JNZ	CCASL+1
	RET
;Subtract HL from DE and return in HL
CCSUB:	MOV	A,E
	SUB	L
	MOV	L,A
	MOV	A,D
	SBB	H
	MOV	H,A
	RET
;Form the two's complement of HL
CCNEG:	CALL	CCCOM
	INX	H
	RET
;Form the one's complement of HL
CCCOM:	MOV	A,H
	CMA
	MOV	H,A
	MOV	A,L
	CMA
	MOV	L,A
	RET
;Multiply DE by HL and return in HL
CCMULT: MOV	B,H
	MOV	C,L
	LXI	H,0
CCMULT1: MOV	A,C
	RRC
	JNC	.+4
	DAD	D
	XRA	A
	MOV	A,B
	RAR
	MOV	B,A
	MOV	A,C
	RAR
	MOV	C,A
	ORA	B
	RZ
	XRA	A
	MOV	A,E
	RAL
	MOV	E,A
	MOV	A,D
	RAL
	MOV	D,A
	ORA	E
	RZ
	JMP	CCMULT1
;Divide DE by HL and return quotient in HL, remainder in DE
CCDIV:	MOV	B,H
	MOV	C,L
	MOV	A,D
	XRA	B
	PUSH	PSW
	MOV	A,D
	ORA	A
	CM	CCDENEG
	MOV	A,B
	ORA	A
	CM	CCBCNEG
	MVI	A,16
	PUSH	PSW
	XCHG
	LXI	D,0
CCDIV1: DAD	H
	CALL	CCRDEL
	JZ	CCDIV2
	CALL	CCCMPBCDE
	JM	CCDIV2
	MOV	A,L
	ORI	1
	MOV	L,A
	MOV	A,E
	SUB	C
	MOV	E,A
	MOV	A,D
	SBB	B
	MOV	D,A
CCDIV2: POP	PSW
	DCR	A
	JZ	CCDIV3
	PUSH	PSW
	JMP	CCDIV1
CCDIV3: POP	PSW
	RP
	CALL	CCDENEG
	XCHG
	CALL	CCDENEG
	XCHG
	RET
CCDENEG: MOV	A,D
	CMA
	MOV	D,A
	MOV	A,E
	CMA
	MOV	E,A
	INX	D
	RET
CCBCNEG: MOV	A,B
	CMA
	MOV	B,A
	MOV	A,C
	CMA
	MOV	C,A
	INX	B
	RET
CCRDEL: MOV	A,E
	RAL
	MOV	E,A
	MOV	A,D
	RAL
	MOV	D,A
	ORA	E
	RET
CCCMPBCDE: MOV	A,E
	SUB	C
	MOV	A,D
	SBB	B
	RET
;