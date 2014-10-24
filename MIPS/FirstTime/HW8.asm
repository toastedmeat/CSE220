# Eric Loo, ID: 108818998


.text
.globl main

main:		#Ask for the number
		la $a0, prompt
		jal printStr
		
		#Get the number
		li $v0, 5
		syscall
		
		#Set the seed
		move $a1, $v0
		li $a0, 8
		li $v0, 40
		syscall
		
		#Loop while less then 100
		li $t0, 0
		la $t1, A
		sub $t1,$t1,400
		
for:		bgt $t0, 99, exit
		#lw $t2, extra
		#Generate random numbers
		li $a1, 401
		li $v0, 42
		syscall
		
		addi $a0, $a0, -200
		
		#put the random number into $t1
		
		sw $a0, 0($t1)
		#sb $a0, ($t1)
		
		#print out the random number and a new line
		li $v0, 1
		syscall
		jal printNL
		
		#increment %t1 to the next space
		add $t1,$t1,4
		
		#increment t0 and jump to the beggining
		addi $t0, $t0, 1
		j for
		
exit:
start:		#Prompt for row dimensions 1-10
		la $a0, rowPrompt
		jal printStr
		li $v0, 5
		syscall
		
		#Check for range 1 - 10
		blez $v0, rowError
		bgt $v0, 10, rowError
		j valid
# If the number is not within the range of 1-10
rowError:	
		#Print out invalid number
		la $a0, invalid		
		jal printStr
		
		#Get a new number
		li $v0, 5
		syscall
		
		#check for invalid again if not go to valid
		blez $v0, rowError
		bgt $v0, 10, rowError
		j valid
		
valid:		
		#Save the row's gotten from the user to ROWS
		sw $v0, ROWS
		
		#test to make sure the number went into rows
		#lw $t0, ROWS
		#move $a0, $t0
		#li $v0, 1
		#syscall
		
		#print out the prompt to ask for cols
		la $a0, colPrompt
		jal printStr
		
		#get the number
		li $v0, 5
		syscall
		
#Check for range 1 - 10
		blez $v0, colError
		bgt $v0, 10, colError
		j validCol
# If the number is not within the range of 1-10
colError:	
		#Print out invalid number
		la $a0, invalidCol
		jal printStr
		
		#Get a new number
		li $v0, 5
		syscall
		
		#check for invalid again if not go to validCol
		blez $v0, colError
		bgt $v0, 10, colError
		j validCol
validCol:
		#Save the Col's gotten from the user to Col
		sw $v0, COLS

		#prompts for row number
		la $a0, whichRow
		jal printStr
		
		#get the number
		li $v0, 5
		syscall
		
		#Get the correct row beggining
		mul $v0, $v0, 4
		lw $t0, COLS
		mul $v0, $v0, $t0
		
		#Test to make sure i have the right number
		#move $a0, $v0
		#li $v0, 1
		#syscall
		
		#store it into s0
		move $s0, $v0
		
		#print the row
		jal printRow
		jal printNL
		
		#save the sum
		move $s1, $v0
		
		#print out the row sum
		la $a0, rowSum
		jal printStr
		move $a0, $s1
		li $v0, 1
		syscall
		jal printNL
		
		#prompts for col number
		la $a0, whichColumn
		jal printStr
		
		#get the number
		li $v0, 5
		syscall
		
		#Get the correct row beggining
		mul $v0, $v0, 4
		
		#store it into s0
		move $s0, $v0
		
		#print the row
		jal printCol
		jal printNL
		
		#save the sum
		move $s1, $v0
		
		#print out the row sum
		la $a0, colSum
		jal printStr
		move $a0, $s1
		li $v0, 1
		syscall
		jal printNL
		
		
		


		la $a0, continue
		jal printStr
		
		li $v0, 8			#Y/N
		la $a0, restart
		li $a1, 30
		move $t0, $a0
		syscall
		
		lb $t1, ($t0)
		beq $t1, 'Y', start
		beq $t1, 'y', start

		li $v0, 10
		syscall
# A function to print a string stored in $a0
printStr: 	li $v0, 4
		syscall
		jr $ra
#Print a new line
printNL:	addi $sp, $sp, -4
		sw $a0, 0($sp)
		
		li $a0, '\n' 
		li $v0, 11
		syscall
		
		lw $a0, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
#Print a Space
printSpace:	addi $sp, $sp, -4
		sw $a0, 0($sp)
		
		li $a0, ' ' 
		li $v0, 11
		syscall
		
		lw $a0, 0($sp)
		addi $sp, $sp, 4
		jr $ra
#print the values of this specific row of the matrix. Return the sum of the row and the minimum value.
printRow:	add $sp, $sp -4
		#Load A into $t0
		li $t0, 0
		lw $t1, COLS
		la $t4, A
		add $t1, $t1, -1
		sub $t4,$t4,400
		add $t4,$t4,$s0
		
forRows:	bgt $t0, $t1, finishRows
		lw $t2, ($t4)
		move $a0, $t2
		li $v0, 1
		syscall
		
		move $t3, $t2
		add $t5, $t5, $t3
		
		sw $ra, 0($sp)
		jal printSpace
		lw $ra, 0($sp)
		
		add $t4, $t4, 4
		add $t0, $t0, 1
		j forRows
		
finishRows:	add $sp, $sp, 4
		move $v0, $t5
		jr $ra
		
#print the values of this specific Col of the matrix. Return the sum of the Col.
printCol:	add $sp, $sp -4
		#Load A into $t0
		li $t0, 0
		lw $t1, ROWS
		la $t4, A
		add $t1, $t1, -1
		sub $t4,$t4,400
		mul $t6, $t0, $s0
		add $t4,$t4, $t6
		
forCols:	bgt $t0, $t1, finishCols
		lw $t2, ($t4)
		move $a0, $t2
		li $v0, 1
		syscall
		
		add $t5, $t5, $t2
		
		sw $ra, 0($sp)
		jal printSpace
		lw $ra, 0($sp)
		
		add $t0, $t0, 1
		mul $t6,$s0,$t0
		add $t4,$t4, $t6
		j forCols
		
finishCols:	add $sp, $sp, 4
		move $v0, $t5
		jr $ra

		
		
		
		

.data
.align 2
ROWS: .word 0
COLS: .word 0
.align 2
A: .space 100
restart: .space 2
.align 2
prompt: .asciiz "“Enter a seed integer for random number generation: "
rowPrompt: .asciiz "Enter the row dimension of the matrix: "
invalid: .asciiz "Invalid number enter 1-10: "
invalidCol: .asciiz "Invalid number enter 1-10: "
colPrompt: .asciiz "Enter the column dimension of the matrix: "
whichRow: .asciiz "Which row? "
whichColumn: .asciiz "Which column? "
continue: .asciiz "Continue? (Y/N): "
rowSum: .asciiz "Row sum = "
colSum: .asciiz "Col sum = "