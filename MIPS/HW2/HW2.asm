# Homework 2
# Eric Loo
# ID#: 10818998
# Due 9/26/2014

.text

.macro space()
li $t0, ' '
move $a0, $t0
li $v0, 11
syscall
.end_macro

.macro newLine()
li $t0, '\n'
move $a0, $t0
li $v0, 11
syscall
.end_macro

.globl main

main:
	li $v0, 4
	la $a0, prompt
	syscall			#Print the Prompt for user input
	
	#j removed		#Skip the removal of \n character with hard coded string
	
	li $v0, 8
	la $a0, fileName
	li $a1, 256
	syscall
	
	li $t1, '\n'
	move $t2, $zero
	li $t0, 0
skip:			# To remove the new line symbol in the string path
	lb $t3, fileName($t0)
	beq $t3, $t1, removeNL
	addi $t0, $t0, 1
	j skip
	
removeNL:	
	sb $t2, fileName($t0)
removed:
	la $a0, fileName
	li $v0, 4
	syscall
	
	li $v0, 13
	la $a0, fileName
	li $a1, 0
	li $a2, 0
	syscall			# Attempt to open the file with the string provided
	
	move $s0, $v0		#Save the file descriptor
	
	bgez $v0, fileCorrect
badFile:
	li $v0, 4
	la $a0, fileNameError
	syscall			#Print the Error message
	
	li $v0, 16		#close file
	move $a0, $s0
	syscall
	
	j main
fileCorrect:
	li $v0, 4
	la $a0, correctFile
	syscall			#Print the correct file message
	newLine()
	li $t0, 0
startRead:
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall

	blez $v0, finish
	
	li $v0, 1
	lb $a0, buff($t0)
	syscall
	bgez $a0, badFile
	newLine()
	
	li $t0, 0		#get out of the BOM
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall
	
	li $t0, 0		#get out of the BOM
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall
readAgain:
	li $t0, 0
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall

	blez $v0, finish
	
	lb $a0, buff($t0)
	move $s3, $a0		#save the value
	
	andi $a0, $a0, 128
	ror $a0, $a0, 7

	bgtz $a0, twoBytesOr
oneBytej:
	space()
	li $v0, 4
	la $a0, oneByte
	syscall			#Print the correct file message
	
	move $a0, $s3
	li $v0, 34
	syscall
	space()
	
	j finishByte
twoBytesOr:
	space()
	move $a0, $s3
	andi $a0, $a0, 248
	ror $a0, $a0, 6
	
	li $t1, 3
	bgt $t1, $a0, threeByteOr
	
twoBytej:	
	space()
	li $v0, 4
	la $a0, twoBytes
	syscall			#Print the correct file message
	
	move $a0, $s3
	li $v0, 34
	syscall
	space()
	
	space()
	li $t0, 0
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall
	
	li $v0, 34
	syscall
	space()

	blez $v0, finish
	
	j finishByte
threeByteOr:
	space()
	move $a0, $s3
	andi $a0, $a0, 248
	ror $a0, $a0, 3
	
	li $t1, 28
	
	bgt $a0, $t1, fourBytej
threeBytej:
	space()
	li $v0, 4
	la $a0, threeBytes
	syscall			#Print the correct file message
	
	move $a0, $s3
	li $v0, 34
	syscall
	space()
	
	li $t0, 0		#second byte
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall
	
	li $v0, 34
	syscall
	space()

	blez $v0, finish
	
	li $t0, 0		#third byte
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall
	
	li $v0, 34
	syscall
	space()

	blez $v0, finish
	
	
	j finishByte
fourBytej:
	space()
	li $v0, 4
	la $a0, fourBytes
	syscall			#Print the correct file message
	
	move $a0, $s3
	li $v0, 34
	syscall
	space()
	
	li $t0, 0		#second byte
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall
	
	li $v0, 34
	syscall
	space()

	blez $v0, finish
	
	li $t0, 0		#third Byte
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall
	
	li $v0, 34
	syscall
	space()

	blez $v0, finish
	
	li $t0, 0		#fourth byte
	li $v0, 14
	move $a0, $s0
	la $a1, buff
	li $a2, 1
	syscall
	
	li $v0, 34
	syscall
	space()

	blez $v0, finish

	j finishByte
finishByte:
	newLine()
	j readAgain
finish:
	li $v0, 16		#close file
	move $a0, $s0
	syscall
	
	li $v0, 10		#End the program gracefully
	syscall

.data
prompt:	.asciiz	"Enter a string, which is the path to the file:"
fileNameError: .asciiz "Error in file path or BOM does not exist.\n"
correctFile: .asciiz "\nFile opened correctly, Proceed"
#fileName: .asciiz "utf-8-special.txt"
oneByte: .asciiz "1 byte "
twoBytes: .asciiz "2 byte "
threeBytes: .asciiz "3 byte "
fourBytes: .asciiz "4 byte "
fileName: .space 256
buff: .space 1000