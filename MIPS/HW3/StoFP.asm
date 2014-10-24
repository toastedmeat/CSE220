#####################################################################################################
#####################################################################################################
## String To FP Procedure
##  
## INPUTS : A String That Is Terminated With Null Char.
##   $a0 = address of String
##
## Author : Manaf Abu.Rous
#####################################################################################################
#####################################################################################################

.data
pi: .float 3.1415926535897924
input: .space 50
prompt_float: .asciiz "Enter a floating point value: "
prompt_radius: .asciiz "Enter a radius: "
arclength: .asciiz "Arc length s: "


# Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_FLOAT 2
.eqv READ_STRING 8

.text
.globl main
main:
	li $v0, 1
	# Ask the user for value
	jal prompt_user

	# Store the return value from prompt user
	mov.s $f12, $f0
	li $v0, 2
	syscall 
	
		li $v0, 10
		syscall
		
prompt_user:

	# Push Address onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# Ask the user for a string
	li $v0, PRINT_STRING
	la $a0, prompt_float
	syscall

	li $v0, READ_STRING
	la $a0, input
	li $a1, 49 		# If you have a space of N this value should be (N-1), extra space holds the return character
	syscall

	# atof to be defined in your hw2.asm
	la $a0, input
	jal str2float
	
	# return value from atof is expected to be in $f0
	# leave it there to return

	# Get $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
str2float:

    move    $t1,$a0             # load Address Of Sttring In $t1

    li      $t0,10              # t0 = 10
    mtc1    $t0,$f2             # move $t0 to $f2
    cvt.s.w $f2,$f2             # f2 = 10 ( Used for Multiplication & Division )

    li      $t0,0               # t0 = 0
    mtc1    $t0,$f4             # move $t0 to $f4
    cvt.s.w $f4,$f4             # f4 = 0 = Integer Part. (Used To Generage The Integer Part Of The Number)

    li      $t0,0               # t0 = 0
    mtc1    $t0,$f6             # move $t0 to $f6
    cvt.s.w $f6,$f6             # f6 = 0 = Fraction Part. (Used To Generage The Fraction Part Of The Number)

    li      $t6,0               # $t6 = 0 = Exponent Part. (Used To Generage The Exponent Part Of The Number)

    li      $t3,0               # $t3 = 0 ( Used To Determine The Sign Of The Number, +ve = 0, -ve = 1 )
    li      $t4,0               # $t4 = 0 ( Used To Count The Number of Digits In a Fraction )
    li      $t5,0               # $t5 = 0 ( Used To Determine If The Next Char Is a Fraction , Yes = 1, No = 0)
    li      $t7,0               # $t5 = 0 ( Used To Determine If The Next Char Is an Exponent , Yes = 1, No = 0)

    #---------------------------------------------------------

    #------------------------------------------------------------------------------
    #  Loop for visiting the buffer Char by Char and Constructing an Integer String
    #------------------------------------------------------------------------------

readLoop:

    lb      $t2,0($t1)          # load byte (char) in $t2

    #--------------------------------------------------------------------
    # -------- Check For "-" Sign
    bne     $t2,0x2d,skipNeg    # check if char = "-" ? if yes > sign reg = 1.
    li      $t3,1               # $t3 = 1 ( Used To Determine The Sign Of The Number )
    j       NextChar
    skipNeg:    
    #--------------------------------------------------------------------

    #--------------------------------------------------------------------
    # -------- Check For "." Dot
    bne $t2,0x2e,skipDot        # check if char = "." ? if yes > Go Read Fraction
    li      $t5,1               # $t3 = 1 > Next Chars Are Fractinos
    j       NextChar
    skipDot:
    #--------------------------------------------------------------------

    #--------------------------------------------------------------------
    # -------- Check For "E" Exponent 
    bne $t2,0x45,skipE          # check if char = "E" ? if yes > Go Read Exponent
    li      $t7,1               # $t3 = 1 > Next Chars Are Exponent
    j       NextChar
    skipE:
    #--------------------------------------------------------------------

    #--------------------------------------------------------------------
    # -------- Check For Null Char ( End Of String) 
    beq     $t2,0x00,FinishNumber   # check if char = Null ? if yes > we are done with the number.
    #--------------------------------------------------------------------   

    #---------------------------------
    # Check What's The Current Char
    #---------------------------------
    beq     $t7,1,readExponent      # if $t7 = 1 (Next Char is Exponenet) Jump To ReadExponent
    beq     $t5,1,readFraction      # if $t7 = 1 (Next Char is Exponenet) Jump To ReadFraction

    #-------------------------------------------------------------------------
    # --------- Read Integer Part Of Char And Convert Them To Float
readInteger:
    subi    $t2,$t2,0x30        # subtract 0x30 from char to convert it to a number.
    mtc1    $t2,$f10            # move $t2 to $f6
    cvt.s.w $f10,$f10           # f6 = converte integer to a FP number.
    mul.s   $f4,$f4,$f2         # =((old)+2 X 10)   
    add.s   $f4,$f4,$f10        # =((old)+ 2)
    j       NextChar
    #-------------------------------------------------------------------------
    #-------------------------------------------------------------------------
    # --------- Read Fraction Part Of Char And Convert Them To Float
readFraction:
    subi    $t2,$t2,0x30        # subtract 0x30 from char to convert it to a number.
    mtc1    $t2,$f10                # move $t2 to $f6
    cvt.s.w $f10,$f10           # f6 = converte integer to a FP number.
    mul.s   $f6,$f6,$f2         # =((old)+2 X 10)   
    add.s   $f6,$f6,$f10            # =((old)+ 2)
    addi    $t4,$t4,1           # Increment Fractions Digits Counter
    j       NextChar
    #-------------------------------------------------------------------------
    #-------------------------------------------------------------------------
    # --------- Read Exponenet Part Of Char And Convert Them To Integer
readExponent:
    li      $t0,10
    subi    $t2,$t2,0x30        # subtract 0x30 from char to convert it to a number.
    mult    $t6,$t0             # =((old)+2 X 10)
    mflo    $t6 
    add     $t6,$t6,$t2         # =((old)+ 2)
    j       NextChar
    #-------------------------------------------------------------------------


NextChar:
    addiu   $t1,$t1,1           # increment the address for the next buffer byte.
    j       readLoop        

###################################### Finish Number Code ######################################

FinishNumber:   
    # Finalizing Fraction Part And Adding It To Integer Part ------------------
    beq     $t5,0,skipFrac      # If There's No Fraction Part Then Skip. ($t5 != 1) > Skip

    li      $t0,1               # $t0  = 1
    mtc1    $t0,$f20            # move $t0 (Counter) to $f20
    cvt.s.w $f20,$f20           # f20 = 1

FracLoop:       #-------- Loop To Multiply 10 By It Self (Fraction Ditigs Counter) Times 
                mul.s  $f20,$f20,$f2       # $f20 = $f20 X $f2 ($f20 = $f20 X 10)
                addi    $t4,$t4,-1          # Decrement Fraction Digits Counter
                bgtz $t4,FracLoop

    div.s   $f6,$f6,$f20        # $f6 = $f6 / $f20 ($f6 = Fraction Part / FractionsDigits X 10 )
    add.s   $f4,$f4,$f6         # $f4 = $f4 + $f6 ( $f4 = IntegerPart + Fraction Part )
    skipFrac:
    # -------------------------------------------------------------------------


    # Exponent Part -----------------------------------------------------------
    beq     $t7,0,skipExp       # If There's No Exponenet Part Then Skip. ($t7 != 1) > Skip
    beq     $t6,1,skipExp       # If The Exponent Is = 1 Then Skip
    addi    $t6,$t6,-1          # Correct Exponent.
    mov.s   $f18,$f4

ExpLoop:    #-------- Loop To Compute The Exponenet (Multiply Number By It Self (Expoenet) Times)
            mul.s   $f4,$f4,$f18        # $f4 = $f4 X $f4 ( Multiply Number By It Self )
            addi    $t6,$t6,-1          # Decrement Fraction Digits Counter
            bgtz $t6,ExpLoop

    skipExp:    
    # -------------------------------------------------------------------------


    # Checking Sign Register --------------------------------------------------
    bne     $t3,1,skipSign      # if $t3 != 1  Then Skip    
    neg.s   $f4,$f4             # $f4 = - $f4
    skipSign:   
    # -------------------------------------------------------------------------

    # Save The Number In $f0 To Be Returned
    mov.s   $f0,$f4             # $f0 = Converted String ( To Be Returned )

################################### End Of Finish Number Code ##################################
    jr      $ra         # Return

#####################################################################################################
#                                        End Of Procedure
#####################################################################################################
