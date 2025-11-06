#
# Sum of Absolute Differences Algorithm
#
# Authors: 
#	X Y, Z Q 
#
# Group: ...
#

.text


main:


# Initializing data in memory... 
# Store in $s0 the address of the first element in memory
	# lui sets the upper 16 bits of thte specified register
	# ori the lower ones
	# (to be precise, lui also sets the lower 16 bits to 0, ori ORs it with the given immediate)
	     lui     $s0, 0x0000 # Address of first element in the vector
	     ori     $s0, 0x0000
	     addi   $t0, $0, 5	# left_image[0]	
	     sw      $t0, 0($s0)
	     addi   $t0, $0, 16	# left_image[1]		
	     sw      $t0, 4($s0)
	     
	     # TODO1: initilize the rest of the memory.
	     # .....
	     addi   $t0, $0, 7	# left_image[2]		
	     sw      $t0, 8($s0)
	     addi   $t0, $0, 1	# left_image[3]		
	     sw      $t0, 12($s0)
	     addi   $t0, $0, 1	# left_image[4]		
	     sw      $t0, 16($s0)
	     addi   $t0, $0, 13	# left_image[5]		
	     sw      $t0, 20($s0)
	     addi   $t0, $0, 2	# left_image[6]		
	     sw      $t0, 24($s0)
	     addi   $t0, $0, 8	# left_image[7]		
	     sw      $t0, 28($s0)
	     addi   $t0, $0, 10	# left_image[8]		
	     sw      $t0, 32($s0)
	     addi  $t0, $0, 4 	#right_image[0]
	     sw	     $t0, 36($s0) 
	     addi $t0, $0, 15    #right_image[1]
	     sw      $t0, 40($s0)
	     addi   $t0, $0, 8	# right_image[2]		
	     sw      $t0, 44($s0)
	     addi   $t0, $0, 0	# right_image[3]		
	     sw      $t0, 48($s0)
	     addi   $t0, $0, 2	# right_image[4]		
	     sw      $t0, 52($s0)
	     addi   $t0, $0, 12	# right_image[5]		
	     sw      $t0, 56($s0)
	     addi   $t0, $0, 3	# right_image[6]		
	     sw      $t0, 60($s0)
	     addi   $t0, $0, 7	# right_image[7]		
	     sw      $t0, 64($s0)
	     addi   $t0, $0, 11	# right_image[8]		
	     sw      $t0, 68($s0)
	     

	# TODO4: Loop over the elements of left_image and right_image
	
	addi $s1, $0, 0 # $s1 = i = 0
	addi $s2, $0, 9	# $s2 = image_size = 9

loop:

	# Check if we have traverse all the elements 
	# of the loop. If so, jump to end_loop:
	
	
	# ....
	
	beq $s1, $s2, end_loop
	# Load left_image{i} and put the value in the corresponding register
	# before doing the function call
	# ....
	sll $t1, $s1, 2
	add $s3, $s0, $t1
	lw $a0, 0($s3)
	
	# Load right_image{i} and put the value in the corresponding register
	
	# ....
	addi $t2, $s3, 36 # because right_array is 36 bytes away from left_image in memory
	lw $a1, 0($t2)
	# Call abs_diff
	
	# ....
	jal abs_diff
	
	#Store the returned value in sad_array[i]
	
	# ....
	addi $t3, $s3, 72 # because sad_array is 72 bytes away from left_image in memory
	sw $v0, 0($t3)
	
	# Increment variable i and repeat loop:
	
	# ...
	addi $s1, $s1, 1
	j loop

	
end_loop:

	#TODO5: Call recursive_sum and store the result in $t2
	#Calculate the base address of sad_array (first argument
	#of the function call)and store in the corresponding register   
	
	# ...
	
	addi $a0, $s0, 72
	
	# Prepare the second argument of the function call: the size of the array
	
	#..... 
	
	addi $a1, $0, 9
	
	# Call to funtion
	
	# ....
	jal recur_sum
	
	#Store the returned value in $t2
	
	# .....
	add $t2, $v0, $0

end:	
	j	end	# Infinite loop at the end of the program. 




# TODO2: Implement the abs_diff routine here, or use the one provided
abs_diff:    sub $t0, $a0, $a1
	     slt $t1, $t0, $zero
	     beq $t1, $zero, L0
	     sub $t0, $zero, $t0 # If -ve, make +ve
L0: 	     add $v0, $zero, $t0
	     jr $ra  

# TODO3: Implement the recursive_sum routine here, or use the one provided
recur_sum:   beq $a1, $zero, base
	     addi $sp, $sp, -12
	     sw $ra, 8($sp) # Save Return Address
	     sw $a0, 4($sp) # Save array base address
	     sw $a1, 0($sp) # Save array size
	     # ------ State Saved --------
	     
	     addi $a0, $a0, 4 # Next element address
	     addi $a1, $a1, -1 # Size decremented 
	     jal recur_sum # Recursively call the function for the remaining array elements
	     
	     # Recursive calls done, now we need to do actual sum $v0 + $t0, returning from the jr instr below
	     
	     # To restore state: 
	     lw $a1, 0($sp)
	     lw $a0, 4($sp)
	     lw $ra, 8($sp)
	     addi $sp, $sp, 12
	     
	     lw $t0, 0($a0) # base value of this "sub-array"
	     add $v0, $v0, $t0 # $v0 = 0 + arr[last] -> $v0 = $v0 + arr[last-1] -> ...
	     jr $ra
	     
base: 	     add $v0, $0, $0
	     jr $ra # Return
