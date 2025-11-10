## Digital Design and Computer Architecture, Spring 2025, ETH Zürich

*** I am not actually a student of Professor Mutlu. This is done at my own time based on the lab materials at the 
lecture website: https://safari.ethz.ch/ddca/spring2025/doku.php?id=labs ***

The part number in the tcl script reflects the FPGA Board being used: Basys 3, same as the one being used in the labs. 

The tcl script has the -jobs value set to 8 since my PC supports 8 logical cores but can be tweaked to the system used to build the 
project. It consists of commands all the way to program the FPGA board if the board is already connected and recognized by the PC. 

Command used for building the labs as vivado projects from within each lab folder: vivado -mode batch ./source built.tcl

For lab 9, two 4-bit inputs are taken and the sum of numbers between them are found (check the assembly file) using the Gaussian formula. 
To solve the challenge question, result is routed to the 4 digit 7-segment display on Basys 3. But this is done as binary itself for quick evaluation, avoiding 
the handling of binary to BCD conversion. This limits the sum displayed only upto 15 (1111) beyond which only the lower 4 bits of 
the actual sum are seen.

<H4>Examples</H4>

num1 = 0000, num2 = 0101 (switches) -> the 7 segment display [1 1 1 1] (1+2+3+4+5)

num1 = 0000, num2 = 0110 -> 1 [0 1 0 1]

Due to the logic in the assembly code (whose MIPS encoding is written in hex format in the instr_mem_h.txt file), num1 > num2 also works. 

num1 = 0101, num2 = 0000 -> [1 1 1 1] same as above. 

Lab assignments completed on: 10.11.2025
