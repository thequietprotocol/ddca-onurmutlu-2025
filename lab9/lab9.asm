
.text
main:	lw $t0, 0x7ff4($0)
	lw $t1, 0x7ff8($0)
	
        # Using Gaussian sum
        # Checking if (num1 <= num2) or (num1 >= num2)
        sub $t5, $t0, $t1  # num1 - num2
        slt $t5, $0, $t5   # (num1-num2) > 0 ?
        beq $t5, $0, L1    # if no, jump
        addi $t6, $t0, 0    # if yes, exchange num1 and num2
	addi $t0, $t1, 0
	addi $t1, $t6,  0
	
        # For 1, 2, 3 ... num1-1
L1:     addi $t2, $t0, -1
        multu $t2, $t0    # (num1-1) * (num1)
        mflo $t3  # LO -> t3
        srl $t3, $t3, 1   # div by 2
        
        # For 1, 2, 3 ... num2
        addi $t2, $t1, 1 
        multu $t2, $t1    # num2 * (num2+1)
        mflo $t4 
        srl $t4, $t4, 1   # div by 2
     
        sub $t4, $t4, $t3
        sw $t4, 0x7ff0($0)
end:    j main
