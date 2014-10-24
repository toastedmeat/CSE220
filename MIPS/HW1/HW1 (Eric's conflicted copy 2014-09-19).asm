# Homework #1
# name: Eric Loo
# sbuid: 108818998

.text
.globl main
main:

start:	la $a0, numask	#Ask for Integer
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall

	move $t0, $v0		# save  number in #t0
	move $t1, $v0		# and also in t1
	
	la $a0, twosComp	#Print first label for 2's
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, tab	#Print tab
	li $v0, 4
	syscall
	
	
	la $t7, num
	
binary: li $t2, 2	#load 2 into t2 for diving
	divu $t1, $t2
	mfhi	$t3	# / remainder
	mflo	$t4	# % remainer
	
	move $t1, $t3	#put new remainder into t1
	
	
	sw $t4, 0($t7)
	
	beqz $t1, done
	addi $t7, 4
	bgtz $t1, binary
	
done:
	lw $a0, 0($t7)
	li $v0, 34
	syscall
	addi ($t7), -4
	
	bne "\n", 0($t7), finPrt
	j done
finPrt:
	
	
	
	
	
	#end program
	li $v0, 10
	syscall

.data 
numask: .asciiz "Enter an integer number:"
template: .asciiz "REP_VALUE 		0xHEX_VALUE		BINARY_VALUE		TWOS_COMPLEMENT_VALUE"
twosComp: .asciiz "2's Compliment: 	"
tab: .asciiz "\t"
num: .space 80
