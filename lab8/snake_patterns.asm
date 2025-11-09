.data
#pattern: .word 0x00200000,0x00004000,0x00000080,0x00000001,0x00000002,0x00000004,0x00000008,0x00000400,0x00020000,0x01000000,0x02000000,0x04000000
pattern: .word 0x00e3838e, 0x01c7071c, 0x038e0e38, 0x070c5c31, 0x0628d8a3, 0x0461d187
loopcnt0: .word 0x002626a0
loopcnt1: .word 0x00131350
loopcnt2: .word 0x00098968
loopcnt3: .word 0x0004c4b4

.text
   addi $t5, $zero, 24       # initialize the length of the display pattern (in bytes)
   addi $s1, $zero, 1
   addi $s2, $zero, 2
   addi $s3, $zero, 3
start:   
   addi $t4,$0,0

forward:
   beq $t5,$t4, start
   lw $t0,0($t4)
   sw  $t0, 0x7ff0($0) # send the value to the display
   lw $t6, 0x7ff8($0) #load the direction
   beq $t6, $0, bw
   addi $t4, $t4, 4
   j speed 
bw:
   beq $t4, $0, wrap_to_end
   addi $t4, $t4, -4
   j speed
wrap_to_end:
   addi $t4, $0, 20

speed:
   lw $t1, 0x7ff4($0) # load the input speed value 00,01,10,11
   addi $t2, $0, 0 # clear $t2 counter
   beq $t1, $0, speed0 
   beq $t1, $s1, speed1
   beq $t1, $s2, speed2
   lw $t3, loopcnt3
   j wait
speed2:
   lw $t3, loopcnt2
   j wait
speed1:
   lw $t3, loopcnt1
   j wait   
speed0:
   lw $t3, loopcnt0
wait:
   beq $t2,$t3,forward
   addi  $t2, $t2, 1     # increment counter
   j wait
