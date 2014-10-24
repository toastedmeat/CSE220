# Author: Peter Jensen
# Date:   September 6, 2012     
#
# A MIPS example that will convert an integer into a binary number.
# You may use this an an example of how to solve the last problem on
# homework assignment #3.


        .data

Prompt:
        .asciiz "Enter an integer: "

Output1:
        .asciiz "The decimal number "
        
Output2:
        .asciiz " is "

Output3:
        .asciiz " in binary."

        
        .text

# Get input from user.  First, issue a prompt using the
# system call that will print out a string of characters.

        la $a0, Prompt  # Put the address of the string in $a0
        li $v0, 4
        syscall

# Next, make the system call that will wait for the user to input
# an integer.

        li $v0, 5  # Code for input integer
        syscall

# Integer input comes back in $v0
# Save the inputted integer in a saved register - important!
# It cannot stay in $v0 as we need to reuse $v0.

        move $s0, $v0

# Next, begin to output the result message.  This is done in several
# steps, including outputting strings and the original integer.

# Output first string.
        
        la $a0, Output1
        li $v0, 4
        syscall

# Output original integer
        
        move $a0, $s0  # Remember, $s0 contains the input number.
        li $v0, 1
        syscall

# Output second string.
        
        la $a0, Output2
        li $v0, 4
        syscall

# Output the binary number.  (This is done by isolating one bit
# at a time, adding it to the ASCII code for '0', and outputting
# the character.  It is important that the bits are output in
# most-to-least significant bit order.
        

	move $t2, $s0      # Move the value to a different regsiter
        li $s1, 32         # Set up a loop counter
Loop:
        rol $t2, $t2, 1    # Roll the bits left by one bit - wraps highest bit to lowest bit (where we need it!)
        andi $t0, $t2, 1    # Mask off low bit (logical AND with 000...0001)
        addi $t0, $t0, 48   # Combine it with ASCII code for '0', becomes 0 or 1 
        
        move $a0, $t0      # Output the ASCII character
        li $v0, 11
        syscall
        
        addi $s1, $s1, -1   # Decrement loop counter
        bne $s1, $zero, Loop  # Keep looping if loop counter is not zero

# Output third string.
        
        la $a0, Output3
        li $v0, 4
        syscall
        
        
# Done, exit the program

        li $v0, 10  # This system call will terminate the program gracefully.
        syscall
        