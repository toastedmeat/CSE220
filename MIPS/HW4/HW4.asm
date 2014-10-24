# Homework #4
# name: Eric Loo
# sbuid: 108818998


.macro save
	addi $sp, $sp, -16	# Start Stack Save
  	sw $a0, 0($sp)
  	sw $a1, 4($sp)
  	sw $a2, 8($sp)
  	sw $a3, 12($sp)
.end_macro
	
.macro load
	lw $a0, 0($sp)		# End Stack Save
  	lw $a1, 4($sp)
  	lw $a2, 8($sp)
  	lw $a3, 12($sp)
  	addi $sp, $sp, 16
.end_macro

.macro nl
	addi $sp, $sp, -8	# Start Stack Save
  	sw $a0, 0($sp)
  	sw $v0, 4($sp)
	li $a0, '\n'
	li $v0, 11
	syscall
	lw $a0, 0($sp)
  	lw $v0, 4($sp)
  	addi $sp, $sp, 8
.end_macro

.macro space
	addi $sp, $sp, -8	# Start Stack Save
  	sw $a0, 0($sp)
  	sw $v0, 4($sp)
	li $a0, ' '
	li $v0, 11
	syscall
	lw $a0, 0($sp)
  	lw $v0, 4($sp)
  	addi $sp, $sp, 8
.end_macro

.text


remainder:
	addi $sp, $sp, -4
  	sw $ra, 0($sp)
	
	blt $a0, $a1, endRem	# end recursion if num is less then div
				
				# if not continue on send the function 
				# num - div and div
	sub $t0, $zero, $a1	# subtract to make a negative
	add $a0, $a0, $t0	# subtract div from num
	jal remainder
	
endRem:	
	lw $ra, 0($sp)
  	addi $sp, $sp, 4
  	move $v0, $a0
	jr $ra
	
printBase:
	addi $sp, $sp, -4
  	sw $ra, 0($sp)
	
	# Check for Valid Base
	li $t0, 9	
	bgt $a1, $t0, errorBase	#end if greater then 9
	li $t1, 2
	blt $a1, $t1, errorBase	#end if less then 2
	# End Check
	
	blt $a0, $a1, endBase
	
	addi $sp, $sp, -4	# Save the old number for when backtrack
  	sw $a0, 0($sp)
  	
	div $a0, $a1
	mflo $a0		# set $a0 to num/base

	jal printBase		# recursion
	
	lw $a0, 0($sp)		# Put the old number back from the stack for remainder
  	addi $sp, $sp, 4
	
endBase:
  	#remainder(num,base))
  	jal remainder
  	move $a0, $v0
  	li $v0, 1
  	syscall
  	
  	lw $ra, 0($sp)
  	addi $sp, $sp, 4
	jr $ra
errorBase:
	#Ends the program if there is an error in the base 9<Base<2
	lw $ra, 0($sp)
  	addi $sp, $sp, 4
  	
  	la $a0, errorInBase
  	li $v0, 4
  	syscall
  	
	jr $ra
	
strlen:
	addi $sp, $sp, -4
  	sw $ra, 0($sp)
  	
  	li $t1, 0	# Counter for strings
  	
nextB:	   
	lb $t0, ($a0)	# get a byte from string
	beqz $t0, ctEnd # zero means end of string
	addi $a0, $a0, 1# move pointer one character
	addi $t1, $t1, 1# Add 1 to the counter
	
	j nextB		# go round the loop again

ctEnd:	
	move $v0, $t1
  	# End of Function
  	lw $ra, 0($sp)
  	addi $sp, $sp, 4
	jr $ra
	
minimum:
	addi $sp, $sp, -4
  	sw $ra, 0($sp)

	ble $a0, $a1, nxtNum
	addu $v0, $a1, $zero
nxtNum:
	ble $v0, $a2, endMin
	addu $v0, $a2, $zero
endMin:
  	lw $ra, 0($sp)
  	addi $sp, $sp, 4
	jr $ra
	
levenshteinDistance:
	addi $sp, $sp, -20
  	sw $ra, 0($sp)
  	sw $s0, 4($sp)
  	sw $s1, 8($sp)
  	sw $s2, 12($sp)
  	sw $s3, 16($sp)
  	
  	# Start Function
  	
  	beqz $a1, endS1Zero	# If String 1 Length = 0 return String 2 Length
  	beqz $a3, endS2Zero	# If String 2 Length = 0 return String 1 Length
  	
  	
  	#test if last characters of the strings match
  	
  	li $s0, 0
	
	addi $t0, $a1, -1
	add $t0, $a0, $t0
	lb $t0, ($t0)

	addi $t1, $a3, -1
	add $t1, $a2, $t1
	lb $t1, ($t1)
	
	beq $t0, $t1, endCompareLast	# else set s0 to 1
  	li $s0, 1
endCompareLast:
  	
  	# return minimum of delete char from s, delete char from t, and delete
	# char from both
	
	# Start Stack Save
  	save			
  	addi $a1, $a1, -1	# Start
  	jal levenshteinDistance
  	load			
  	# End Stack Save
  	addi $v0, $v0, 1	# levenshteinDistance(s, lenS - 1, t, lenT) + 1
  	move $s1, $v0
  	
  	# Start Stack Save
	save  		
  	addi $a3, $a3, -1	# Start
  	jal levenshteinDistance
  	load
  	# End Stack Save
  	addi $v0, $v0, 1	# levenshteinDistance(s, lenS - 1, t, lenT) + 1
  	move $s2, $v0
  	
  	# Begin Stack Save
  	save
  	addi $a3, $a3, -1	# Start
  	addi $a1, $a1, -1
  	jal levenshteinDistance	# levenshteinDistance(s, lenS - 1, t, lenT - 1) + match)  	
  	load
  	# End Stack Save
  	add $v0, $v0, $s0	# levenshteinDistance(s, lenS - 1, t, lenT) + 1
  	move $s3, $v0
  	
  	move $a0, $s1
  	move $a1, $s2
  	move $a2, $s3
	jal minimum
  	j endLev
endS1Zero:
	move $v0, $a3
	j endLev
endS2Zero:
	move $v0, $a1
	j endLev
endLev:	# End of Function
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
  	addi $sp, $sp, 20
	jr $ra
	
rd100Chars:
	addi $sp, $sp, -4
  	sw $ra, 0($sp)

beginRead:
	save
	move $a0, $a1		# $a0 is now the string for entering 100
	li $v0, 4
	syscall
	load
	
	save
	li $v0, 8
	li $a1, 105
	syscall
	
	#la $a0, ($t0)		# $a0 is back to the address of the space m1
	jal strlen
	
	li $t2, 101
	load
	beq $t2, $v0, endRd
errorInLength:
	save
	la $a0, ($a2)		# $a0 is now the string for Error
	li $v0, 4
	syscall
	load
	j beginRead
	
endRd:	
	lw $ra, 0($sp)
  	addi $sp, $sp, 4
	jr $ra
	
printIntMatrix:
	addi $sp, $sp, -4
  	sw $ra, 0($sp)

	move $t1, $a0
	li $t5, 5
begin:
	beqz $t5, printEnd
	lw $t0, ($t1)
	move $a0, $t0
	li $v0, 1
	syscall
	space
	
	addi $t1, $t1, 4
	lw $t0, ($t1)
	move $a0, $t0
	li $v0, 1
	syscall
	space
	
	addi $t1, $t1, 4
	lw $t0, ($t1)
	move $a0, $t0
	li $v0, 1
	syscall
	space
	
	addi $t1, $t1, 4
	lw $t0, ($t1)
	move $a0, $t0
	li $v0, 1
	syscall
	space
	
	addi $t1, $t1, 4
	lw $t0, ($t1)
	move $a0, $t0
	li $v0, 1
	syscall
	space
	nl
	addi $t5, $t5, -1
	j begin
	
printEnd:
	lw $ra, 0($sp)
  	addi $sp, $sp, 4
	jr $ra
	
matrixMult:
	addi $sp, $sp, -4
  	sw $ra, 0($sp)
	
	lw $t0, i
	lw $t1, j
	lw $t2, k
	
	
	li $t3, 5
	bge $t0, $t3, endMult
	
	blt $t1, $t3, insideIf
	
outside:	
	li $t1, 0
	addi $t0, $t0, 1
	
	#jal matrixMult
	j endMult
	
doubleIf:
 	# result[i][j] += matrixA[i][k] * matrixB[k][j];
 	mul  $t4, $a0, $a1
 	addu $a2, $a2, $t4 
	addi $t2, $t2, 1
	#jal matrixMult
insideIf:
	blt $t2, $t3, doubleIf
	li $t2, 0
	addi $t1, $t1, 1
	#jal matrixMult
	j outside
endMult:
	sw $a2, result
	lw $ra, 0($sp)
  	addi $sp, $sp, 4
	jr $ra

.data
.align 2
errorInBase: .asciiz "Invalid Base!"
.align 2
m1: .space 101
.align 2
m2: .space 101
.align 2
result: .space 101
.align 2
i: .word 0
j: .word 0
k: .word 0