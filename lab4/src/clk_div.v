
module clk_div(
    input clk,
    input reset, 
    output flag
);

reg [24:0] counter;

always @(posedge clk) begin
  if(reset) counter <= 25'd0;
  else counter <= counter + 25'd1;
end

assign flag = &counter;

endmodule