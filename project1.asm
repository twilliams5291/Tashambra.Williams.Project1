	.data
	
in_string:	.space	8
num_arr:	.word	8
newline:	.asciiz	"\n"
error_msg:	.asciiz	"Invalid hexadecimal number."
	
	.text
	
	
main:
	li $v0, 8			 #Read in string
	la $a0, in_string	 #8-byte buffer
	li $a1, 9			 #Limit to 8 characters + null character
	syscall
	
	move $t0, $a0
	la $a0, newline
	li $v0, 4
	syscall
	
	move $a0, $t0
	la $a1, num_arr
	li $s0, 1			 #Comparison constant for True
	li $s1, 48			 #0 ascii value
	li $s2, 65			 #'A' ascii value
	li $s3, 97			 #'a' ascii value
	li $s4, 87			 #Hex lower offset value
	li $s5, 55			 #Hex upper offset value
	la $s6, num_arr		 #Array of converted characters
	li $s7, 10			 #Loop termination value
	add $t5, $0, $0		 #Final number var
	li $t8, 0		 	 #Character counter
	add $t9, $t9, $0	 #Array Counter

	
loop:
	lb $t0, 0($a0)	 		#Load the first character
	beq	$zero, $t0, hex_val #End loop at end of string
	beq	$s7, $t0, hex_val
	beq $s6, $a0, hex_val
	li $t1, 32
	beq $t1, $t0, ignore
	
	slt $t1, $t0, $s1	 #Check if character is less than '0'
	beq  $t1, $s0, error #If so then throw an error and end
	
	slt $t1, $t0, $s2	 #Check if character is a letter
	slti $t2, $t0, 58	 #Check if character is a number
	bne $t1, $t2, error	 #If it is between letters and numbers then throw an error and end
	
	beq $t2, $s0, save_num	#Save number in array
	
	slti $t1, $t0, 103	 #Make sure character is less than or equal to 'g'
	bne $t1, $s0, error	 #If not then throw an error and end
	
	slt $t1, $t0, $s3	 #Check if letter is lowercase
	slti $t2, $t0, 71	 #Check if letter is uppercase
	bne $t1, $t2, error	 #if neither then throw an error and end
	
	beq $t1, $zero, save_lower
	beq $t2, $s0, save_upper
	
ignore:					 #Ignore spaces and increment to next character in buffer
	addi $a0, $a0, 1
	j loop


save_num:				 #Save number by subtracting 0 ascii value (0)
	sub $t0, $t0, $s1
	sw $t0, 0($a1)
	
	addi $a1, $a1, 4
	addi $t8, $t8, 1
	addi $a0, $a0, 1
	
	j loop
	

save_lower:				 #Save lowercase letter by subtracting 'a' ascii value (87)
	sub $t0, $t0, $s4
	sw $t0, 0($a1)
	
	addi $a1, $a1, 4
	addi $t8, $t8, 1
	addi $a0, $a0, 1
	
	j loop
	

save_upper:				 #Save uppercase letter by subtracting 'A' ascii value (65)
	sub $t0, $t0, $s5
	sw $t0, 0($a1)
	
	addi $a1, $a1, 4
	addi $t8, $t8, 1
	addi $a0, $a0, 1
	
	j loop

	
hex_val:				 #Convert translated numbers to appropriate hexadecimal number
	lw $t0, 0($s6)		 #Load first decimal number from array
	beq $t8, $zero, end  #End the loop when we have gone through all the numbers
	
	sll $t5, $t5, 4		 #Multiply whatever is in $t5 by 16
	add $t5, $t5, $t0	 #Add the latest number from $t0 to $t5
		
	addi $t8, $t8, -1	 #Decrement the counter
	addi $s6, $s6, 4	 #Go to next number in array (by byte)
	
	j hex_val			 #Continue loop
	

error:
	and $a0, $a0, $zero	 #Clear $a0
	la $a0, error_msg	 #Load error message address into $a0
	li $v0, 4			 #Print message
	syscall
	
	li $v0, 10			 #Exit
	syscall


end:

	li $t0, 10000		#Use 10000 to split $t5 to output the unsigned halves
	divu $t5, $t0		#Divide $t5 by 10000
	
	mflo $a0			#Print the upper bits represented as the quotient when dividing by 10000
	li $v0, 1
	syscall
	
	mfhi $a0			#Print the low bits represented as the remainder when dividing by 10000			
	li $v0, 1
	syscall
	
	li $v0, 10			#Exit
	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	