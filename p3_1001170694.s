@ Jalyn Gilliam
@ 1001170694
@
@ Project 3
@ Dr. McMurrough
@
@ 1) populate an array with 10 random values
@ 2) find min and max value
@ 3) search the array
@

/******************************************************************************
 * @file rand_array.s
 * @author Christopher D. McMurrough
 ******************************************************************************/

.global main
.func main

main:
	BL _seedrand            @ seed random number generator with current time
	MOV R0, #0              @ initialze index variable
writeloop:			@ POPULATES ARRAY WITH 10 ELEMENTS
	CMP R0, #10            @ check to see if we are done iterating
	BEQ writedone           @ exit loop if done
	LDR R1, =a              @ get address of a
	LSL R2, R0, #2          @ multiply index*4 to get array offset
	ADD R2, R1, R2          @ R2 now has the element address
	PUSH {R0}               @ backup iterator before procedure call
	PUSH {R2}               @ backup element address before procedure call
	BL _getrand             @ get a random number
	POP {R2}                @ restore element address
	STR R0, [R2]            @ write the address of a[i] to a[i]
	POP {R0}                @ restore iterator
	ADD R0, R0, #1          @ increment index
	B   writeloop           @ branch to next loop iteration
writedone:			@ COMPLETES ARRAY POPULATION
	MOV R0, #0              @ initialze index variable
readloop:			@ READS ARRAY TO PRINT
	CMP R0, #10            @ check to see if we are done iterating
	BEQ readdone            @ exit loop if done
	LDR R1, =a              @ get address of a
	LSL R2, R0, #2          @ multiply index*4 to get array offset
	ADD R2, R1, R2          @ R2 now has the element address
	LDR R1, [R2]            @ read the array at address
	PUSH {R0}               @ backup register before printf
	PUSH {R1}               @ backup register before printf
	PUSH {R2}               @ backup register before printsf
	MOV R2, R1              @ move array value to R2 for printf
	MOV R1, R0              @ move array index to R1 for printf
	BL  _printf             @ branch to print procedure with return
	POP {R2}                @ restore register
	POP {R1}                @ restore register
	POP {R0}                @ restore register
	ADD R0, R0, #1          @ increment index
	B   readloop            @ branch to next loop iteration
readdone:			@ HANDLES THE LOGIC FOR FINDING MIN AND MAX
	MOV R0, #0				@ resets to 0 for min and max
	MOV R1, #0				@ resets to 0 for min and max
	MOV R2, #0				@ resets to 0 for min and max
	LDR R1, =a				@ loads starting array address of a into R1
	LSL R2, R0, #2			@ multiply index by 4 to get the array offset
	ADD R2, R2, R1			@ starting array address + offset
	LDR R1, [R2]            @ gets the address in R2 and loads into R1
	MOV R11, R1             @ stores min value
	MOV R10, R2             @ stores min address
	MOV R8, R1              @ stores max value
	MOV R7, R2              @ stores max address
	B _minmaxloop			@ branch to min max loops

_minmaxloop:		@ HANDLES FINDING THE MIN AND MAX LOOP
	CMP R0, #10				@ check if end of loop
	BEQ _minmaxprint		@ end loop, if above line is true
	LDR R3, =a				@ loads starting address of a into R3
	LSL R4, R0, #2			@ multiply index by 4 to get the array offset
	ADD R4, R3, R4			@ starting array address + offset
	LDR R3, [R4]			@ gets the address in R4 and loads into R3
	CMP R11, R3				@ compares current min with current array position
	MOVGT R11, R3			@ stores array value, if it is less than current min value
	CMP R8, R3				@ compares current max with current array position
	MOVLT R8, R3			@ stores array value, if it is greater than current max value
	ADD R0, R0, #1			@ iterator for the loop
	B _minmaxloop			@ back to top

_minmaxprint:		@ HANDLES PRINTING MIN AND MAX NUMBERS
	MOV R1, R11             @ stores min value into R1
	LDR R0, =printMin		@ print min
	BL printf				@ call printf
	MOV R1, R8              @ stores max value into R1
	LDR R0, =printMax		@ print max
	BL printf				@ call printf
	B _exit

_exit:				@ HANDLES EXITING STEPS
	MOV R7, #4				@ write syscall, 4
	MOV R0, #1				@ output stream to monitor, 1
	MOV R2, #21				@ print string length
	LDR R1, =exit_str       @ string at label exit_str:
	SWI 0                   @ execute syscall
	MOV R7, #1              @ terminate syscall, 1
	SWI 0                   @ execute syscall

_printf:			@ PRINT FUNCTION FOR THE ARRAY
	PUSH {LR}               @ store the return address
	LDR R0, =printf_str     @ R0 contains formatted string address
	BL printf               @ call printf
	POP {PC}                @ restore the stack pointer and return

_seedrand:			@ SETS SEED FOR RAND FUNCTION
	PUSH {LR}               @ backup return address
	MOV R0, #0              @ pass 0 as argument to time call
	BL time                 @ get system time
	MOV R1, R0              @ pass sytem time as argument to srand
	BL srand                @ seed the random number generator
	POP {PC}                @ return

_getrand:			@ RUNS RAND FUNCTION AND SLIMS NUMBER DOWN
	PUSH {LR}               @ backup return address
	BL rand                 @ get a random number
	MOV R1, R0				@ slimming number in range 0 - 999
	MOV R2, #1000			@ slimming number in range 0 - 999
	BL _mod_unsigned		@ slimming down count in range 0 - 999
	POP {PC}                @ return

_mod_unsigned:		@ HELPER FUNCTION TO SLIM DOWN NUMBER IN RANGE 0 - 999
	cmp R2, R1				@ check to see if R1 >= R2
	MOVHS R0, R1			@ swap R1 and R2 if R2 > R1
	MOVHS R1, R2			@ swap R1 and R2 if R2 > R1
	MOVHS R2, R0			@ swap R1 and R2 if R2 > R1
	MOV R0, #0				@ initialize return value
	B _modloopcheck			@ check to see if
	_modloop:
		ADD R0, R0, #1		@ increment R0
		SUB R1, R1, R2		@ subtract R2 from R1
	_modloopcheck:
		CMP R1, R2			@ check for loop termination
		BHS _modloop		@ continue loop if R1 >= R2
		MOV R0, R1			@ move remainder to R0
		MOV PC, LR			@ return

	.data

.balign 4
a:              .skip       40
printf_str:     .asciz      "a[%d] = %d\n"
printMin:     .asciz      "MINIMUM VALUE = %d\n"
printMax:     .asciz      "MAXIMUM VALUE = %d\n"
debug_str:		.asciz		"R%-2d   0x%08X  %011d \n"
exit_str:       .ascii      "Terminating program.\n"
