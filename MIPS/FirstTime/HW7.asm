.text
.globl main
main:	
startO:	la $a0, nameAsk  # Ask for name String
	li $v0, 4
	syscall
	
	li $v0, 8	#Get the name of the person
	la $a0, name
	li $a1, 30
	move $t0, $a0
	syscall
	
loop:		lb $t1, ($t0)
		beq $t1, '\n', end
		ble $t1, 'a', inc
		bge $t1, 'z', inc
		bge $t1, 'a', change
	
change:		sub $t1,$t1,32
		sb $t1, ($t0)
		addi $t0, $t0, 1
		j loop

inc:		addi $t0, $t0, 1
		j loop

	
end:	la $a0, nameWritten #Print out HI
	li $v0, 4
	syscall
	
	move $a0, $t1
	la $a0, name 	#Print out name given
	li $v0, 4
	syscall
	
	la $a0, play 	#Print out game
	li $v0, 4
	syscall
	
	la $a0, digits 	#Print out phone question
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	
	blt $v0, 100, invalid
	bgt $v0, 999, invalid
	j valid
	
invalid:	la $a0, oRange
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		blt $v0, 100, invalid
		bgt $v0, 999, invalid
		
valid:	li $t2, 80
	mul $t3, $v0, $t2
	move $a0, $t3
	li $v0, 1
	syscall
	jal newLine
	
	addi $t3, $t3, 1
	move $a0, $t3
	li $v0, 1
	syscall
	jal newLine
	
	li $t2, 250
	mul $t3, $t3, $t2
	move $a0, $t3
	li $v0, 1		#t3 has first 3
	syscall
	jal newLine
	
	la $a0, lastDig	#last 4 digets of phone
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	
	blt $v0, 1000, invalids
	bgt $v0, 9999, invalids
	j valids
	
invalids:	la $a0, oRange
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		blt $v0, 1000, invalids
		bgt $v0, 9999, invalids

valids:		move $t5, $v0
		add $t4, $t5, $t3
		move $a0, $t4
		li $v0, 1
		syscall
		jal newLine
	
		add $t4, $t4, $t5
		move $a0, $t4
		li $v0, 1
		syscall
		jal newLine
	
		subi $t4, $t4, 250
		move $a0, $t4
		li $v0, 1
		syscall
		jal newLine
	
		li $t2, 2
		div $t4, $t4, $t2
		move $a0, $t4
		li $v0, 1
		syscall
		
		la $a0, space
		li $v0, 4
		syscall
		
		la $a0, name
		li $v0, 4
		syscall
		
		la $a0, doYou		# Do you reconinize
		li $v0, 4
		syscall
		jal newLine
		
		la $a0, memWord		#Memory Word
		li $v0, 4
		syscall
		
		la $a0, name
		li $v0, 1
		syscall
		jal newLine
		
		la $a0, aSubZ
		li $v0, 4
		syscall

		la $t6, array
		lw $t7, ($t6)		# $t7 is min and has a[0]
		move $a0, $t7		
		li $v0, 1
		syscall
		jal newLine
		
		la $a0, aSubOne
		li $v0, 4
		syscall
		
		li $a0, 0
		
		add $t6, $t6, 4		#increment to a[1]
		lw $t7, ($t6)
		move $a0, $t7
		li $v0, 1
		syscall
		jal newLine
		
		la $a0, seed		#Set seeds
		li $v0, 4
		syscall
		
		li $v0, 5
		syscall
		
		li $a0, 5		#set seed
		move $a1, $v0
		li $v0, 40
		syscall
		
		li $a0, 5		#Random generator
		li $a1, 10000
		li $v0, 42
		syscall
		
		subi $a0, $a0, 5000
		sw $a0, numB
		
		la $t6, numB
		lw $t7, ($t6)		# $t7 is min and has a[0]
		lw $t8, ($t6)		# $t8 is max and has a[1]
		la $t2, counter
		add $t6, $t6, 4
		add $t2,$t2,-1

		
		
		la $a0,startOver		#start over
		li $v0,4
		syscall	
		
		li $v0, 8			#Y/N
		la $a0, start
		li $a1, 30
		move $t0, $a0
		syscall
		
		lb $t1, ($t0)
		beq $t1, 'Y', startO
		beq $t1, 'y', startO
		
	li $v0, 10
	syscall
	
newLine: 	la $a0, new
		li $v0, 4
		syscall
		jr $ra
			
.data 
nameAsk: .asciiz "What is your name? (Maximum of 30) "
name: .space 30
nameWritten: .asciiz "HI "
new: .asciiz "\n"
space: .asciiz " "
play: .asciiz "Let’s play a number game.\n"
digits: .asciiz "Enter the first 3 digits of your phone number (not area code): "
oRange: .asciiz "Number out of range. Please enter another number.\n"
lastDig: .asciiz "Enter the last 4 digits of your phone number: "
doYou: .asciiz "do you recongnize the answer?"
memWord: .asciiz "Memory word is: "
aSubZ: .asciiz "A[0]:"
aSubOne: .asciiz  "A[1]:"
array: .word 0,0
numB: .space 25
counter: .word 25
seed: .asciiz "Enter an seed integer for random number generator: "
min: .asciiz "Smallest: "
max: .asciiz "Biggest: "
startOver: .asciiz "Do you want to start over (Y/N)?"
start: .space 2