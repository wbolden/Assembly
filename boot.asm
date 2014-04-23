
[BITS 16]
[ORG 0x7C00]

MOV	 	SI, HelloString	;Moves address of SI to first memory location of HelloString
CALL 	PrintString			
;JMP	$					;infinite loop


JMP 	0x0000:start		;start in 0x7C00:0x0000 (0x0000:0x7C00)
start:

		;actual stuff will go here

						;------------------------------------
PrintCharacter:			;Prints a single character held in AL
						;------------------------------------
	MOV 	AH, 0x0E		;BIOS - will print character
	MOV 	BH, 0x00		;page number
	MOV 	BL, 0xA9		;lightgrey font color

	INT 	0x10			;BIOS video interrupt, character in AL is printed
RET
						;-----------------------------
PrintString:			;Prints a string of characters
						;-----------------------------
						
						;-------------------------------------------------------------------
next_character:			;Increments through the memory locations of the string to be printed
						;-------------------------------------------------------------------
;	MOV		AL, [SI]		;Copys a byte from the memory location of SI to AL
;	INC		SI				;increment SI

	LODSB					;Accomplishes the above two instructions
	OR		AL, AL			;
	JZ		exit_function	;if AL is 0, exit_function
	CALL	PrintCharacter	;else, print another character
	
	JMP		next_character	;Move on to next character
	
exit_function:
RET

reset_word:
	MOV		SI, HelloString
	JMP		next_character

;Data
HelloString DB 'Hello World From the BIOS!', 0

TIMES 0x200 - 2 - ($ - $$) DB 0	;fills remaining (0x200 - 2 - length) bytes with zeros
DW	0xAA55						;fills last word with 0xAA55, bootable

