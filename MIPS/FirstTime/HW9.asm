#Eric Loo ID: 108818998


.text

.macro printArgs(%ARG1, %ARG2)
add $sp, $sp, -8
sw %ARG1, 0($sp)
sw %ARG2, 4($sp)

hashTag()

lw %ARG1, 0($sp)
lw %ARG2, 4($sp)

add $a0, $0, %ARG1
li $v0, 1
syscall

sw %ARG1, 0($sp)
sw %ARG2, 4($sp)

space()

hashTag()

lw %ARG1, 0($sp)
lw %ARG2, 4($sp)

add $a0, $0, %ARG2
li $v0, 1
syscall

sw %ARG1, 0($sp)
sw %ARG2, 4($sp)

space()

lw %ARG1, 0($sp)
lw %ARG2, 4($sp)

add $sp, $sp, 8
move $a0, $sp
li $v0, 34
syscall

la $a0, '\n'
li $v0, 11
syscall
.end_macro

.macro PRINTS()
add $t0, $0, 0

loop:
hashTag()
la $a0, 'S'
syscall

add $a0, $0, $t0
li $v0, 1
syscall
space()
beq $t0, 0, first
beq $t0, 1, second
beq $t0, 2, third
beq $t0, 3, fourth
beq $t0, 4, fifth
beq $t0, 5, six
beq $t0, 6, sev
beq $t0, 7, eight

first:
move $a0, $s0
li $v0, 1
syscall
space()
add $t0, $t0, 1
j loop

second:
move $a0, $s1
li $v0, 1
syscall
space()
add $t0, $t0, 1
j loop

third:
move $a0, $s2
li $v0, 1
syscall
space()
add $t0, $t0, 1
j loop

fourth:
move $a0, $s3
li $v0, 1
syscall
space()
add $t0, $t0, 1
j loop

fifth:
move $a0, $s4
li $v0, 1
syscall
space()
add $t0, $t0, 1
j loop

six:
move $a0, $s5
li $v0, 1
syscall
space()
add $t0, $t0, 1
j loop

sev:
move $a0, $s6
li $v0, 1
syscall
space()
add $t0, $t0, 1
j loop

eight:
move $a0, $s7
li $v0, 1
syscall
space()
add $t0, $t0, 1

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

.globl main
main:
	li $a0, 231
	li $a1, 999
	printArgs($a0, $a1)
	
	li $a0, 222
	li $a1, 921
	printArgs($a0, $a1)
	
	
	li $s0, 122
	PRINTS()
	
	li $v0, 10
	syscall
.data
