## Digital Design and Computer Architecture, Spring 2025, ETH Zürich

The part number in the tcl script reflects the FPGA Board being used: Basys 3, same as the one being used in the labs. 

The tcl script has the -jobs value set to 8 since my PC supports 8 logical cores but can be tweaked to the system used to build the 
project. It consists of commands all the way to program the FPGA board if the board is already connected and recognized by the PC. 

Command used for building the labs as vivado projects from within each lab folder: vivado -mode batch ./source built.tcl
