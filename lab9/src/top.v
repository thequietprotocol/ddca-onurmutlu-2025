`timescale 1ns / 1ps

module top(
    input clk,
    input reset,
    input [3:0] num1_sw,
    input [3:0] num2_sw,
    output [6:0] LED,
    output reg [3:0]  AN
    );    

// MIPS interface
  wire [31:0] IOWriteData;
  wire  [3:0] IOAddr;
  wire        IOWriteEn;
  reg [31:0] IOReadData;

   reg  [3:0] DispReg;        // Assigned at I/O write handling below
   reg  DispVal;      
   reg [15:0] led_refresh_counter;
   parameter bin_0 = 7'b011_1111, bin_1 = 7'b000_0110;
   always @ (*)  begin
     case (led_refresh_counter[15:14])
       2'b00:   begin AN = 4'b1110; DispVal = DispReg[0];  end   
       2'b01:   begin AN = 4'b1101; DispVal = DispReg[1]; end    
       2'b10:   begin AN = 4'b1011; DispVal = DispReg[2]; end    
       2'b11:   begin AN = 4'b0111; DispVal = DispReg[3]; end    
    endcase  
   end
   assign LED = DispVal? (~bin_1): (~bin_0);
   
   reg  [3:0]  num1, num2;
   always @(*) begin
     case(IOAddr)
        4'h4: IOReadData = {28'd0, num1};
        4'h8: IOReadData = {28'd0, num2};
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

// -------------------- Clocked -----------------------
    always @(posedge new_clk, posedge reset) begin
      if (reset) begin
        num1 <= 2'd0;
	num2 <= 2'd0;
      end else begin
	num1 <= num1_sw;      // Register the switch input
	num2 <= num2_sw;
      end
    end

    always @ (posedge new_clk, posedge reset)
     if (reset) led_refresh_counter = 0;
     else  led_refresh_counter = led_refresh_counter + 1;  
     
    always @ (posedge new_clk, posedge reset)
      if (reset) DispReg = 4'h0; 
      else if (IOWriteEn) DispReg = IOWriteData[3:0]; 
	 
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
