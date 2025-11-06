#
# Calculate sum from A to B.
#
# Authors: 
#	X Y, Z Q 
#
# Group: ...
#

.text
main:
	#
	# Your code goes here...
	#
	addi $t0, $zero, 5
	addi $t1, $zero, 10
	add  $t2, $zero, $zero # Sum
	add  $t7, $zero, $zero # Iterator
L0:	beq  $t0, $t1, L1
	add  $t2, $t2, $t0
	addi $t0, $t0, 1 
	j L0
L1: 	add  $t2, $t2, $t0
	# Put your sum S into register $t2
end:	
	j	end	# Infinite loop at the end of the program. 
