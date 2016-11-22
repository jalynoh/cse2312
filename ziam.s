/******************************************************************************
 * @file p2_1001106856.s
 * @Pragram 2
 *
 * Simple Program using ARM assembly to find the GCD
 *
 *
 * @author Syed Zaim Zanaruddin
 * @ID:1001106858
 * @CSE 2313
 * @Dr.Mcmurrough
 ******************************************************************************/

    .global main
	.func main
main:
	BL _prompt_operand
	BL _read
	MOV R1, R0
	MOV R2, #0
	BL _prompt_operand
	BL _read
	MOV R2, R0
	BL _gcd
	MOV R1, R0
	BL _write
	BAL main

_prompt_operand:
	MOV R5, R1
	MOV R7, #4
	MOV R0, #1
	CMP R2, #0
	MOVNE R2, #17
	LDRNE R1, =value1_prompt
	MOVEQ R2, #17
	LDREQ R1, =value2_prompt
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

_gcd:
	MOV R4, LR
	MOV R6, R1
	MOV R8, R2
	BL _loopcheck
	_loop:
		SUB R2, R2, #1
		MOV R1, R6
	_loopcheck:
		BL _mod_unsigned
		CMP R0, #0
		MOVEQ R1, R8
		BLEQ _mod_unsigned
		CMP R0, #0
		BLNE _loop
	MOV R0, R2
	MOV PC, R4

_mod_unsigned:
	MOV R7, LR
	CMP R2, R1
	MOVHS R0, R1
	MOVHS R1, R2
	MOVHS R2, R0
	B _modloopcheck
	_modloop:
		SUB R1, R1, R2
	_modloopcheck:
		CMP R1, R2
		BHS _modloop
	MOV R0, R1
	MOV PC, R7

_write:
	MOV R4, LR
	LDR R0, =print_value
	BL  printf
	MOV PC, R4

.data
value1_prompt:	.ascii	  "Enter Value_1: "
value2_prompt:	.ascii	  "Enter Value_2: "
format_int:		.asciz	  "%d"
print_value:		.asciz	  "The GCD is: %d\n\n"
