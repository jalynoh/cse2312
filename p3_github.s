/*
 *int min=max=a[0];
 *for(i=1; i < 9; i++){
 *    if(min > a[i]){
 *        min = a[i];
 *    }
 *    if(max < a[i]){
 *        max = a[i];
 *    }
 *   i++;
 *}
 *C-Code to find search value
 *int input;
 *scanf("%d", &input);
 *for(i=0; i<9; i++){
 *    if(input == a[i]){
 *        return i; // index of found value
 *    }
 *}
 *return -1;
 */

.global main
.func main

main:
	BL _seedrand            @ seed random number generator with current time
	MOV R0, #0              @ initialze index variable
	writeloop:
		CMP R0, #10             @ check to see if we are done iterating
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
	writedone:
		MOV R0, #0              @ initialze index variable
		readloop:
		CMP R0, #10             @ check to see if we are done iterating
		BEQ readdone            @ exit loop if done
		LDR R1, =a              @ get address of a
		LSL R2, R0, #2          @ multiply index*4 to get array offset
		ADD R2, R1, R2          @ R2 now has the element address
		LDR R1, [R2]            @ read the array at address
		PUSH {R0}               @ backup register before printf
		PUSH {R1}               @ backup register before printf
		PUSH {R2}               @ backup register before printf
		MOV R2, R1              @ move array value to R2 for printf
		MOV R1, R0              @ move array index to R1 for printf
		BL  _printf             @ branch to print procedure with return
		POP {R2}                @ restore register
		POP {R1}                @ restore register
		POP {R0}                @ restore register
		ADD R0, R0, #1          @ increment index
		B   readloop            @ branch to next loop iteration
	readdone:
		MOV R0, #0              @reset values
		MOV R1, #0              @reset values
		MOV R2, #0              @reset values
		LDR R1, =a              @ get address of a
		LSL R2, R0, #2          @ multiply index*4 to get array offset
		ADD R2, R1, R2          @ R2 now has the element address
		LDR R1, [R2]            @ read the array at address and dereference b/ []
		MOV R12, R0             @ min index
		MOV R11, R1             @ min value
		MOV R10, R2             @ min address
		MOV R9, R0              @ max index
		MOV R8, R1              @ max value
		MOV R7, R2              @ max address
		B _loop1                @ branches to find min and max

_search:
	BL  _prompt             @ branch to prompt procedure with return
	BL  _scanf              @ branch to scan procedure with return
	MOV R6, #-1             @index return value. Initially set to -1
	MOV R5, R0              @ user input and value that we need to find
	MOV R0, #0              @Prepare R0 for loop by resetting to 0
	MOV R1, #0              @reset values
	MOV R2, #0              @reset values
_searchLoop:
	CMP R0, #10         @index starts at 0 and when it reaches 9 we exit for now
	BEQ _printf_index
	@BLEQ search
	LDR R1, =a          @ get address of a
	LSL R2, R0, #2      @ multiply index*4 to get array offset
	ADD R2, R1, R2      @ R2 now has the element address
	LDR R1, [R2]        @ read the array at address and dereference b/ []
	CMP R5, R1
	MOVEQ R6, R0
	BEQ _printf_index
	@BLEQ search
	ADD R0, R0, #1      @increment index
	B _searchLoop

_loop1:
CMP R0, #10             @if the index equals 9 we break out of the loop
BEQ _minMaxDisplay      @exit program for now, will update this to jump to search function
LDR R3, =a              @get address of a
LSL R4, R0, #2          @ multiply index*4 to get array offset
ADD R4, R3, R4          @ R4 now has the element address
LDR R3, [R4]            @ read the array at address and dereference it to get value a[i]
CMP R11, R3
MOVGT R12, R0           @copy index to R9, use later in print statement (MIN)
MOVGT R11, R3           @if R1 (min) is greater than R4 a[i] mov R4 to R1 (MIN)
CMP R8, R3
MOVLT R9, R0            @INDEX OF MAX
MOVLT R8, R3            @VALUE OF MAX
ADD R0, R0, #1          @increment index
B _loop1                @go back to loop1

_minMaxDisplay:
@MOV R2, R11            @ move array value to R2 for printf (value)
@MOV R1, R12            @ move array index to R1 for printf (index)
MOV R1, R11             @THIS IS DONE TO MEET REQUIREMENTS FROM HW
BL  _printf_min         @ branch to print procedure with return
@MOV R2, R8             @ move array value to R2 for printf (value)
@MOV R1, R9             @ move array index to R1 for printf (index)
MOV R1, R8              @HW ONLY WANTS THE VALUES NOT THE INDEXS
BL  _printf_max         @ branch to print procedure with return
B _search

_printf:
PUSH {LR}               @ store the return address
LDR R0, =printf_str     @ R0 contains formatted string address
BL printf               @ call printf
POP {PC}                @ restore the stack pointer and return
_printf_min:
PUSH {LR}               @ store the return address
LDR R0, =printf_min     @ R0 contains formatted string address
BL printf               @ call printf
POP {PC}                @ restore the stack pointer and return

_printf_max:
PUSH {LR}               @ store the return address
LDR R0, =printf_max     @ R0 contains formatted string address
BL printf               @ call printf
POP {PC}                @ restore the stack pointer and return

_printf_index:
MOV R1, R6              @move result index to R0
LDR R0, =printf_index   @ R0 contains formatted string address
BL printf               @ call printf
B _search

_prompt:
PUSH {R1}               @ backup register value
PUSH {R2}               @ backup register value
PUSH {R7}               @ backup register value
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #21             @ print string length
LDR R1, =prompt_str     @ string at label prompt_str:
SWI 0                   @ execute syscall
POP {R7}                @ restore register value
POP {R2}                @ restore register value
POP {R1}                @ restore register value
MOV PC, LR              @ return

_scanf:
PUSH {LR}               @ store the return address
PUSH {R1}               @ backup regsiter value
LDR R0, =format_str     @ R0 contains address of format string
SUB SP, SP, #4          @ make room on stack
MOV R1, SP              @ move SP to R1 to store entry on stack
BL scanf                @ call scanf
LDR R0, [SP]            @ load value at SP into R0
ADD SP, SP, #4          @ remove value from stack
POP {R1}                @ restore register value
POP {PC}                @ restore the stack pointer and return

_seedrand:
PUSH {LR}               @ backup return address
MOV R0, #0              @ pass 0 as argument to time call
BL time                 @ get system time
MOV R1, R0              @ pass sytem time as argument to srand
BL srand                @ seed the random number generator
POP {PC}                @ return

_getrand:
PUSH {LR}               @ backup return address
BL rand                 @ get a random number
MOV R1, R0              @set value for mod evaulation
MOV R2, #1000           @set second value for mod evaluation
BL _mod_unsigned        @call modulus
POP {PC}                @ return

_mod_unsigned:
cmp R2, R1              @ check to see if R1 >= R2
MOVHS R0, R1            @ swap R1 and R2 if R2 > R1
MOVHS R1, R2            @ swap R1 and R2 if R2 > R1
MOVHS R2, R0            @ swap R1 and R2 if R2 > R1
MOV R0, #0              @ initialize return value
B _modloopcheck         @ check to see if
_modloop:
ADD R0, R0, #1      @ increment R0
SUB R1, R1, R2      @ subtract R2 from R1
_modloopcheck:
CMP R1, R2          @ check for loop termination
BHS _modloop        @ continue loop if R1 >= R2
MOV R0, R1              @ move remainder to R0
MOV PC, LR              @ return

.data

.balign 4
a:              .skip       40
printf_str:     .asciz      "a[%d] = %d\n"
printf_min:     .asciz      "MINIMUM VALUE = %d\n"
printf_max:     .asciz      "MAXIMUM VALUE = %d\n"
printf_index:     .asciz    "%d\n"
number:         .word       0
format_str:     .asciz      "%d"
prompt_str:     .asciz      "ENTER SEARCH VALUE: "
