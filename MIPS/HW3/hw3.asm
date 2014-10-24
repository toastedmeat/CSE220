# Homework #3
# name: Eric Loo
# sbuid: 10818998


.text
	
toRadians:

  # Allocate space on the stack to hold the value
  # Store the argument $ra on the stack to preserve the value
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  
  la $t0, pi
  l.s $f5, 0($t0)
  
  mul.s $f0, $f12, $f5
  
  li $t0, 0x43340000
  mtc1 $t0, $f5
  
  div.s $f0, $f0, $f5
  
  # Return the $ra register to original value
  # Move the stack back to its initial position
  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra
  
  
arcLength:

  # Allocate space on the stack to hold the value
  # Store the argument $ra on the stack to preserve the value
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  
  mov.s $f31, $f13
  
  jal toRadians
  
  mov.s $f30, $f0
  
  mul.s $f0, $f31, $f30
  
  # Return the $ra register to original value
  # Move the stack back to its initial position
  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra
  
atof:

  # Allocate space on the stack to hold the value
  # Store the argument $ra on the stack to preserve the value
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  
  setup:
  move		$s0, $a0
  move    	$t1, $a0
  
  li		$t0, 10		#set t0 to 10
  mtc1		$t0, $f5	
  cvt.s.w	$f5, $f5	#make it a float
  
  li      	$t0,0           
  mtc1    	$t0,$f6         
  cvt.s.w 	$f6,$f6         # For Integer part

  li      	$t0,0           
  mtc1    	$t0,$f7         
  cvt.s.w 	$f7,$f7         # For after .
  
  li 		$t3, 0		# Sign Counter
  li		$t4, 0		# Count the places after the .
  li		$t5, 0		# fraction counter
  
start:
  lb		$t2, 0($t1)
  li		$v0, 2
  syscall
  
checkSign:
  li		$t0, '-'
  bne		$t2, $t0, checkDot
  li		$t3, 1		#If negative put 1 into t3 so we know
  b		inc

checkDot:
  li		$t0, '.'
  bne		$t2, $t0, checkFinish
  
checkFinish:
  li		$t0, '\n'
  beq		$t2, $t0, finishRead
  
procInt:
  addi    	$t2,$t2,-48	# subtract 48 from char to convert it to a number.
  mtc1    	$t2,$f10            
  cvt.s.w 	$f10,$f10           
  mul.s   	$f6,$f6,$f5         
  add.s   	$f6,$f6,$f10        
  b       	inc
  
procDec:
  addi		$t2, $t2 , -48        
  mtc1    	$t2, $f10            
  cvt.s.w 	$f10, $f10           
  mul.s   	$f7, $f7,$f5       
  add.s   	$f7, $f7,$f10        
  addi    	$t4, $t4, 1	# Increment Fractions Digits Counter
  b       	inc
inc:
  addi   	$t1, $t1, 1	# move the address to the next spot
  b       	start
  
finishRead:
  beq     	$t5, $zero, skipDec      # If no dec skip
  li      	$t0, 1              
  mtc1    	$t0, $f20	# move 1 into f20  
  cvt.s.w 	$f20, $f20           
  
decCalc:
  mul.s   	$f18, $f18, $f5	#$f18 X 10
  addi    	$t4, $t4, -1	# Decrement Fraction Digits Counter
  bgtz 		$t4, decCalc
  div.s   	$f7, $f7, $f20	# Fraction Part / FractionsDigits X 10
  add.s   	$f6, $f6, $f7

skipDec:
  li		$t7, 1
  bne     	$t3, $t7, notNeg	#if t3 is 1 negate 
  neg.s   	$f5, $f5
notNeg:
  mov.s   	$f0, $f5

  # Return the $ra register to original value
  # Move the stack back to its initial position
  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra
  
print_parts:

  # Allocate space on the stack to hold the value
  # Store the argument $ra on the stack to preserve the value
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  
  la $a0, sign
  li $v0, 4
  syscall
  
  la $a0, nL
  li $v0, 4
  syscall
  
  la $a0, exponent
  li $v0, 4
  syscall
  
  la $a0, nL
  li $v0, 4
  syscall
  
  la $a0, fraction
  li $v0, 4
  syscall
  
  la $a0, nL
  li $v0, 4
  syscall
  # Return the $ra register to original value
  # Move the stack back to its initial position
  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra
  
  
print_binary_product:

  # Allocate space on the stack to hold the value
  # Store the argument $ra on the stack to preserve the value
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  
  la $a0, binaryProduct
  li $v0, 4
  syscall
  
  la $a0, nL
  li $v0, 4
  syscall
  # Return the $ra register to original value
  # Move the stack back to its initial position
  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra
  
  
arcLengthS:

  # Allocate space on the stack to hold the value
  # Store the argument $ra on the stack to preserve the value
  addi $sp, $sp, -4
  sw $ra, 0($sp)

  # Return the $ra register to original value
  # Move the stack back to its initial position
  lw $ra, 0($sp)
  addi $sp, $sp, 4

  jr $ra
  
product:
  move $t0, $a0		#number of variables in the list
  bltz $t0, endLTZ
  li	$t1, 1
  beq	$t0, $t1, endSingle

  # Allocate space on the stack to hold the value
  # Store the argument $ra on the stack to preserve the value
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  
  
  # Return the $ra register to original value
  # Move the stack back to its initial position
  lw $ra, 0($sp)
  addi $sp, $sp, 4
endSingle:
	addi $t0, $t0 , -48
	mtc1 $t0, $f0
	cvt.s.w	$f0, $f0
  	jr $ra
endLTZ:
  mtc1 $zero, $f0
  jr $ra
  
.data
sign:	.asciiz		"Sign: "
exponent:	.asciiz		"Exponent: "
fraction:	.asciiz		"Fraction: "
binaryProduct:	.asciiz		"Binary Product: "
nL:	.asciiz		"\n"