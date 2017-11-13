	.data
	
in_string:	.space	8
num_arr:	.word	8
newline:	.asciiz	"\n\n"
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
	