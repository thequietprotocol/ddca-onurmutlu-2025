
module top(
    input clk, 
    input reset, 
    input left, 
    input right,
    output LA, LB, LC,
    output RA, RB, RC
);

parameter res=3'd0,l1=3'd1,l2=3'd2,l3=3'd3,r1=3'd4,r2=3'd5,r3=3'd6;
reg [2:0] state, next_state;

wire state_en;
clk_div c0(.clk(clk), .reset(reset), .flag(state_en));

always @(*) begin 
  case(state)
    res: next_state = (left && !right)? l1: ( (!left && right)? r1: res);
    l1: next_state = l2;
    l2: next_state = l3;
    l3: next_state = res;
    r1: next_state = r2;
    r2: next_state = r3;
    r3: next_state = res;
  endcase
end

always @(posedge clk) begin
  if(reset) state <= res;
  else if(state_en) state <= next_state;
end

assign LA = (state == l1) || (state == l2) || (state == l3);
assign LB = (state == l2) || (state == l3);
assign LC = (state == l3);

assign RA = (state == r1) || (state == r2) || (state == r3);
assign RB = (state == r2) || (state == r3);
assign RC = (state == r3);


endmodule