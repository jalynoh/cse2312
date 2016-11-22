@ Program 2 - CMD
@ Aun Hashmi
@ 1000907809

.global main
.func main

main:
	BL _prompt
	BL _read
	MOV R1, R0
	MOV R2, #0
	BL _prompt
	BL _read
	MOV R2, R0
	PUSH {R1}
	PUSH {R2}
	BL _GCDenom
	POP {R2}
	POP {R1}
	MOV R3, R0
	BL _print
	BAL main

_prompt:
	MOV R5, R1
	MOV R7, #4
	MOV R0, #1
	CMP R2, #0
	MOVNE R2, #17
	LDRNE R1, =num1_prompt
	MOVEQ R2, #17
	LDREQ R1, =num2_prompt
	SWI 0
	MOV R1, R5
	MOV PC,LR

_read:					
	MOV R4, LR
	MOV R5, R1
	MOV R6, R3
	SUB SP, SP, #4
	LDR R0, =format_int
	MOV R1, SP
	BL scanf
	LDR R0, [SP]
	ADD SP, SP, #4
	MOV R3, R6
	MOV R1, R5
	MOV PC, R4

_GCDenom:				@ Subtract 1 until number divides into 1 evenly
	MOV R4, LR
	MOV R6, R1
	MOV R8, R2
	BL _gcdloopcheck
	_gcdloop:
		SUB R2, R2, #1		@ subtract 1 from R2
		MOV R1, R6
	_gcdloopcheck:
		BL _mod_unsigned
		CMP R0, #0			@ compare 0 less/= R0 [remainder]
		MOVEQ R1, R8
		BLEQ _mod_unsigned
		CMP R0, #0			@ compare R0 greater/= 0
		BLNE _gcdloop
	MOV R0, R2
	MOV PC, R4				@ return to main func.

_mod_unsigned:
	MOV R7, LR				@ move LR to R7
	CMP R2, R1
	MOVHS R0, R1
	MOVHS R1, R2
	MOVHS R2, R0			@ if R2 > R1, swap R2 and R1
	B _modloopcheck
	_modloop:
		SUB R1, R1, R2		@ subtract r2 from r1
	_modloopcheck:
		CMP R1, R2
		BHS _modloop
	MOV R0, R1
	MOV PC, R7				@ return to top

_print:
	MOV R4, LR
	LDR R0, =print
	BL  printf
	MOV PC, R4

.data
num1_prompt:	.ascii	  "Enter Number1 :  "
num2_prompt:	.ascii	  "Enter Number2 :  "
format_int:		.asciz	  "%d"
print:			.asciz	  "The GCD of %d and %d is %d\n"
