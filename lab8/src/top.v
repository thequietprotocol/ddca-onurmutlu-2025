`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input [1:0] sp_switch,
    input dr_switch,
    output [6:0] LED,
    output reg [3:0]  AN
    );    

// MIPS interface
  wire [31:0] IOWriteData;
  wire  [3:0] IOAddr;
  wire        IOWriteEn;
  reg [31:0] IOReadData;

  reg   [27:0] DispReg;        
  reg   [6:0]  DispDigit;      
// Signals for composing the input
  reg  [1:0]  speed;           // output of the multiplexer
  reg direction;
  

    reg [15:0] led_refresh_counter;

   always @ (*)  
	   begin
		   case (led_refresh_counter[15:14])
			  2'b00:   begin AN = 4'b1110; DispDigit = DispReg[6:0];  end   // LSB
			  2'b01:   begin AN = 4'b1101; DispDigit = DispReg[13:7];  end   // 2nd digit
			  2'b10:   begin AN = 4'b1011; DispDigit = DispReg[20:14]; end   // 3rd digit
			  2'b11:   begin AN = 4'b0111; DispDigit = DispReg[27:21];end   // MSB, default
			endcase  
		end
   assign LED = ~DispDigit;
   
   always @(*) begin
     case(IOAddr)
        4'h4: IOReadData = {30'd0, speed};
        4'h8: IOReadData = {31'd0, direction};
        default: IOReadData = 32'd0;
     endcase
   end 
   
// Clock Division
    reg [1:0] div_clk;
    wire new_clk;
    always @(posedge clk, posedge reset)
     if (reset) div_clk <= 2'd0;
     else div_clk <= div_clk + 2'd1;
    assign new_clk = &div_clk;

// Clocked

  always @(posedge new_clk, posedge reset) begin
    if (reset) begin
        speed <= 2'd0;
        direction <= 1'd0;
    end
    else begin
        speed <= sp_switch;      // Register the switch input
        direction <= dr_switch;
    end
end
  

    always @ (posedge new_clk, posedge reset)
     if (reset) led_refresh_counter = 0;
	  else  led_refresh_counter = led_refresh_counter + 1;
	  
  always @ (posedge new_clk, posedge reset)
    if (reset) DispReg = 28'h0; 
	else if (IOWriteEn) DispReg = IOWriteData[27:0]; 
	 
// Instantiate the processor
MIPS processor (
    .clk(new_clk), 
    .reset(reset), 
    .io_write_data(IOWriteData), 
    .io_addr(IOAddr), 
    .io_write_en(IOWriteEn), 
    .io_read_data(IOReadData)
    );

endmodule
