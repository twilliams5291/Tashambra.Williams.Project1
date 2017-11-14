	.data
	
in_string:	.space	8
num_arr:	.word	8
newline:	.asciiz	"	"
error_msg:	.asciiz	"\nInvalid hexadecimal number.\n"
	
	.text
	
main:
	li $v0, 8			 #Read in string
	la $a0, in_string	 #8-byte buffer
	li $a1, 9			 #Limit to 8 characters + null character
	syscall
	
	move $t0, $a0		#Save the string
	la $a0, newline		#Save the address of the newline
	li $v0, 4			#Print the newline for readability
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
	li $t8, -1		 	 #Character counter
	add $t9, $t9, $0	 #Array Counter
	
loop:
	lb $t0, 0($a0)	 		#Load the first character
	beq	$zero, $t0, hex_val #End loop at end of string
	beq	$s7, $t0, hex_val
	
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


save_num:
	sub $t0, $t0, $s1
	sw $t0, 0($a1)
	
	addi $a1, $a1, 4
	addi $t8, $t8, 1
	addi $a0, $a0, 1
	
	j loop
	

save_lower:
	sub $t0, $t0, $s4
	sw $t0, 0($a1)
	
	addi $a1, $a1, 4
	addi $t8, $t8, 1
	addi $a0, $a0, 1
	
	j loop
	

save_upper:
	sub $t0, $t0, $s5
	sw $t0, 0($a1)
	
	addi $a1, $a1, 4
	addi $t8, $t8, 1
	addi $a0, $a0, 1
	
	j loop
	