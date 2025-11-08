`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    output [6:0] LED,
    output reg [3:0]  AN
    );    

// MIPS interface
  wire [31:0] IOWriteData;
  wire  [3:0] IOAddr;
  wire        IOWriteEn;
  wire [31:0] IOReadData;

  reg   [27:0] DispReg;        
  reg   [6:0]  DispDigit;      
// Signals for composing the input
  wire  [1:0]  IOin;           // output of the multiplexer

    reg [18:0] led_refresh_counter;
    always @ (posedge clk, posedge reset)
     if (reset) led_refresh_counter = 0;
	  else  led_refresh_counter = led_refresh_counter + 1;

   always @ (*)  
	   begin
		   case (led_refresh_counter[18:17])
			  2'b00:   begin AN = 4'b1110; DispDigit = DispReg[6:0];  end   // LSB
			  2'b01:   begin AN = 4'b1101; DispDigit = DispReg[13:7];  end   // 2nd digit
			  2'b10:   begin AN = 4'b1011; DispDigit = DispReg[20:14]; end   // 3rd digit
			  2'b11:   begin AN = 4'b0111; DispDigit = DispReg[27:21];end   // MSB, default
			endcase  
		end
   assign LED = ~DispDigit;

  always @ (posedge clk, posedge reset)
    if (reset) DispReg = 28'h0; 
	else if (IOWriteEn) DispReg = IOWriteData[27:0]; 
	 
// Instantiate the processor
MIPS processor (
    .clk(clk), 
    .reset(reset), 
    .io_write_data(IOWriteData), 
    .io_addr(IOAddr), 
    .io_write_en(IOWriteEn), 
    .io_read_data(IOReadData)
    );

endmodule
