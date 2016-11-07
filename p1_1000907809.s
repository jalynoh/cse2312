.global main
.func main

@ Aun Hashmi Programing Assignment#1 2312

main: @main function
	BL _scanner
	MOV R8,R0
	BL _getcharacter
	MOV R9,R0
	BL _scanner
	MOV R10,R0
	BL _getop
	MOV R1,R0
	BL _printf
	B main

_scanner:
	PUSH {LR}
	SUB SP,SP,#4
	LDR R0,=format_str
	MOV R1,SP
	BL scanner
	LDR R0,[SP]
	ADD SP,SP,#4
	POP {LR}
	MOV PC,LR @ moving values

_getcharacter:
	MOV R7,#3
	MOV R0,#0
	MOV R2,#1
	LDR R1,=read_character
	SWI 0
	LDR R0, [R1]
	AND R0, #0xFF
	MOV PC,LR

_getop:
	PUSH {LR}
	CMP R9, #'+'
	BEQ _summation
	CMP R9,#'-'
	BEQ _subtract
	CMP R9,#'M'
	BEQ _maximum
	CMP R9,#'*'
	BEQ _multiply
	POP {LR}
	MOV PC,LR @ moving values

_printf:
	PUSH {LR}
	LDR R0,=display_str
	MOV R1,R1
	BL printf
	POP {LR}
	MOV PC,LR @ moving values

_multiply:
    MOV R5,LR @ moving values
    MUL R0,R8,R10
    MOV PC,R5 @ moving values

_summation:
	MOV R5,LR @ moving values
	ADD R0,R8,R10
	MOV PC,LR @ moving values


_subtract:
	MOV R5,LR @ moving values
	SUB R0,R8,R10
	MOV PC,R5 @ moving values
    
_maximum: 
    MOV R5,LR @ moving values
    CMP  R10,R8
	MOVLE R0,R8
	MOVGT R0,R10
	MOV PC,R5 @ moving values

.data
format_str:         .asciz       "%d"
read_character:          .asciz       " "
display_str:        .asciz       "%d\n"
