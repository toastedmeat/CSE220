# Homework #1
# name: Eric Loo
# sbuid: 108818998

# #3, They would print out the ascii number equivalent.  so AbCd would be 100679965

.text
.globl main
main:
	li $a0, 0x30
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

