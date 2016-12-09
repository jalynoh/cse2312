@ Jalyn Gilliam
@ 1001170694
@
@ Final Exam
@ Dr. McMurrough
@
@ 1) scan for input values
@ 2) ABS(-5.7) = |-5.7| = 5.7
@		input 'a'
@ 3) SQUARE_ROOT(71.2) = sqrt(71.2) = 8.4380092
@		input 's'
@ 4) POW(1.5, 4) = 1.5**4 = 5.0625
@		input 'p'
@ 5) INVERSE(0.3) = 1/0.3 = 3.333333
@		input 'i'

.global main
.func main

main:
	BL _vscanf				@ jump to vault scanf
	VMOV S1, R0				@ move return value to FPU registers
	BL _getchar				@ operation input
	MOV R9, R0 				@ move operation character for later use
	BL _scanop				@ decifier operation input
	VCVT.F64.U32 D4, S0		@ convert the result to double precision
	VMOV R1, R2, D4			@ split double VFP register into two ARM registers
	BL _printf				@ print result
	B main					@ continuous loop

_vscanf:
	PUSH {LR}				@ store original function return value
	SUB SP,SP,#4			@ make room on stack
	LDR R0, =format_str		@ R0 contains address of format string
	MOV R1, SP 				@ move SP to R1 to store entry on stack
	BL scanf				@ call scanf from stdlib
	LDR R0, [SP]			@ load value at SP into R0
	ADD SP, SP, #4			@ restore the stack pointer
	POP {PC}				@ return to calling function

_getchar:
	MOV R7, #3
	MOV R0, #0
	MOV R2, #1
	LDR R1, =read_char
	SWI 0
	LDR R0, [R1]
	AND R0, #0xFF
	MOV PC, LR 				@ return to calling function

_scanop:
	PUSH {LR}				@ store original function return value
	CMP R9, #'a'			@ if R9 operation == absolute value
	BEQ _abs				@ if R9 operation == absolute value
	CMP R9,#'s'				@ if R9 operation == square root
	BEQ _sqrt				@ if R9 operation == square root
	CMP R9,#'p'				@ if R9 operation == power
	BEQ _pow				@ if R9 operation == power
	CMP R9,#'i'				@ if R9 operation == inverse
	BEQ _inv				@ if R9 operation == inverse
	POP {PC}				@ return to calling function

_printf:
	PUSH {LR}				@ store original function return value
	LDR R0, = printf_str	@ load string formating into R0
	BL printf 				@ call printf from stdlib
	POP {PC}				@ return to calling function

_abs:
	@ 0 - S1 = S1
_sqrt:
	VSQRT.F32 S0, S1
	MOV PC, LR
_pow:
	@ ask for another input
	@ multiplication loop
_inv:
	@VDIV.F32 S0, S1, #1		@ divide by 1
	@MOV PC, LR 				@ return to calling function


.data
format_str:		.asciz		"%f"
read_char:		.asciz		 " "
printf_str:		.asciz		"%f\n"