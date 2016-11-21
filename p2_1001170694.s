@ Jalyn Gilliam
@ 1001170694
@
@ Project 2
@ Dr. McMurrough
@

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
	PUSH {R1}			@ store original values for printing
	PUSH {R2}			@ store original values for printing
	BL _gcd
	POP {R2}			@ retrieve original values
	POP {R1}			@ retrieve original values
	MOV R3, R0			@ move R0(num2 from _mod_unsigned) to R1
	BL _write_result	@ print R1(num2 from _mod_unsigned)
	BAL main			@ branch back up to main

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

_gcd:						@ keeps subtracting 1 until it finds a number that divides into R1(num1) evenly
	MOV R4, LR				@ store LR(main return address) in R4
	MOV R6, R1				@ store R1(original num1) in R6
	MOV R8, R2				@ store R2(original num2) in R8
	BL _gcdloopcheck		@ branch to _gcdloopcheck
	_gcdloop:				@ only activates if the remainder from _mod_unsigned != 0
		SUB R2, R2, #1		@ subtract 1 from R2
		MOV R1, R6			@ move R6(original num1) back into R1
	_gcdloopcheck:
		BL _mod_unsigned	@ branch to _mod_unsigned
		CMP R0, #0			@ compare 0 >= R0(remainder from _mod_unsigned)
		MOVEQ R1, R8		@ move R8(original num2) to R1, if R0(remainder from _mod_unsigned) == 0
		BLEQ _mod_unsigned	@ branch to _mod_unsigned, if R0(remainder from _mod_unsigned) == 0
		CMP R0, #0			@ compare R0(remainder from _mod_unsigned) >= 0
		BLNE _gcdloop		@ branch to _gcdloop, if R0(remainder from _mod_unsigned) != 0
	MOV R0, R2				@ move R2(num2 from _mod_unsigned) into R0
	MOV PC, R4				@ return to main->_gcd

_mod_unsigned:
	MOV R7, LR				@ move LR(_gcdloopcheck address) to R7
	CMP R2, R1				@ compare R1(num1) >= R2(num2)
	MOVHS R0, R1			@ swap R2 and R1, if R2 > R1
	MOVHS R1, R2			@ swap R2 and R1, if R2 > R1
	MOVHS R2, R0			@ swap R2 and R1, if R2 > R1
	B _modloopcheck			@ branch to _modloopcheck
	_modloop:
		SUB R1, R1, R2		@ subtract R2(num2) from R1(num1)
	_modloopcheck:			@ _modloopcheck checks if R1 and R2 are equal
		CMP R1, R2			@ compare R2(num2) >= R1(num1)
		BHS _modloop		@ branch to _modloop if R1 > R2
	MOV R0, R1				@ move remainder to R0
	MOV PC, R7				@ return to _gcd->_gcdloopcheck

_write_result:
	MOV R4, LR
	LDR R0, =print_result
	BL  printf
	MOV PC, R4

.data
num1_prompt:	.ascii	  "Enter Number1 :  "
num2_prompt:	.ascii	  "Enter Number2 :  "
format_int:			.asciz	  "%d"
print_result:		.asciz	  "The GCD of %d and %d is %d\n"
