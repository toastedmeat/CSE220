#Eric Loo ID #: 108818998
.text

.macro newLine()
la $a0, '\n'
li $v0, 11
syscall
.end_macro

.macro space()
la $a0, ' '
li $v0, 11
syscall
.end_macro

.macro hashTag()
la $a0, '#'
li $v0, 11
syscall
.end_macro

.macro printStr(%string)
add $sp, $sp, -4
sw $v0, 0($sp)

la $a0, %string
li $v0, 4
syscall

lw $v0, 0($sp)
add $sp, $sp, 4

.end_macro

.macro printNum(%num)
add $sp, $sp, -4
sw $v0, 0($sp)

move $a0, %num
li $v0, 1
syscall

lw $v0, 0($sp)
add $sp, $sp, 4

.end_macro

.macro printChar(%char)
add $sp, $sp, -4
sw $v0, 0($sp)

la $a0, %char
li $v0, 11
syscall

lw $v0, 0($sp)
add $sp, $sp, 4

.end_macro



.globl main

main:	
	printStr(prompt1)
error:	li $v0, 8
	la $a0, fileName
	li $a1, 32
	move $t0, $a0
	syscall
	
loop:	lb $t1, ($t0)
	beq $t1, '\0', end
	beq $t1, '\n', change
	bne $t1, '\n', noCng
	
change:	la $t1, '\0'
	sb $t1, ($t0)
	addi $t0, $t0, 1
	j loop
noCng: 	addi $t0, $t0, 1
	j loop
	
end:	li $v0, 13
	la $a0, fileName
	li $a1, 0
	syscall
	move $s0, $v0
	
	li $v0, 14
	move $a0, $s0
	la $a1, fileName
	li $a2, 1
	syscall
	
	move $t0, $v0
	
	li $v0, 16
	move $a0, $s0
	syscall
	
	bgez $t0, next
	printStr(errorPrompt)
	bltz $t0, error
	
next:	
	printStr(prompt2)
	li $v0, 5
	syscall
	
	beq $v0, 1, one
	beq $v0, 2, two
	j next


one:	
	li $v0, 14
	move $a0, $s0
	la $a1, fileName
	li $a2, 1024
	syscall
	
	move $a0, $v0
	li $v0, 1
	syscall
	#jal parenCount
	
	printChar('(')
	printChar(':')
	space()
	printNum($t0)
	newLine()
	printChar(')')
	printChar(':')
	space()
	printNum($t1)
	newLine()
	printChar('[')
	printChar(':')
	space()
	printNum($t2)
	newLine()
	printChar(']')
	printChar(':')
	space()
	printNum($t3)
	newLine()
	printChar('{')
	printChar(':')
	space()
	printNum($t4)
	newLine()
	printChar('}')
	printChar(':')
	space()
	printNum($t5)
	newLine()
	printChar('<')
	printChar(':')
	space()
	printNum($t6)
	newLine()
	printChar('>')
	printChar(':')
	space()
	printNum($t7)
	newLine()
	
	
	j endPt1
	
two:
	printStr(bal)
	
endPt1:	

	li $v0, 10
	syscall
#parenCount
parenCount:
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	move $t8, $v0
loopP:	
	lb $t9, ($t8)
	beq $t9, '\0', endP
	beq $t9, '(', noChgP0
	beq $t9, ')', noChgP1
	beq $t9, '[', noChgP2
	beq $t9, ']', noChgP3
	beq $t9, '{', noChgP4
	beq $t9, '}', noChgP5
	beq $t9, '<', noChgP6
	beq $t9, '>', noChgP7
	
changeP:	
	la $t9, '\0'
	sb $t9, ($t8)
	addi $t8, $t8, 1
	j loopP
noChgP0: 
	add $t0, $t0, 1
	addi $t8, $t8, 1
	j loopP
noChgP1: 
	add $t1, $t1, 1
	addi $t8, $t8, 1
	j loopP
noChgP2: 
	add $t2, $t2, 1
	addi $t8, $t8, 1
	j loopP
noChgP3: 
	add $t3, $t3, 1
	addi $t8, $t8, 1
	j loopP
noChgP4: 
	add $t4, $t4, 1
	addi $t8, $t8, 1
	j loopP
noChgP5: 
	add $t5, $t5, 1
	addi $t8, $t8, 1
	j loopP
noChgP6: 
	add $t6, $t6, 1
	addi $t8, $t8, 1
	j loopP
noChgP7: 
	add $t7, $t7, 1
	addi $t8, $t8, 1
	j loopP
	
endP:
	jr $ra
	
	

.data
fileName: 	.space 32
.align 2
fout: 		.asciiz "testout.txt"
prompt1: 	.asciiz "Enter input filename: "
errorPrompt:	.asciiz "Bad file name, Enter a new one: "
prompt2:	.asciiz "Enter 1 to count the frequency of each farenthesis in the file, 2 to check for balanced parenthesis: "
bal:		.asciiz "Balanced"
not:		.asciiz "Not balanced"
