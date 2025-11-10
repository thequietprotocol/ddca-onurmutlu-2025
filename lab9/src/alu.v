 
// Instrs & alu_op: 
//  add,     sub,    and,     or,     xor,    nor,    slt (32-bit ext)
// 100000, 100010, 100100, 100101,  100110, 100111, 101010
//   srl,   multu , mflo
// 000010  011001  010010
module ALU #(parameter WIDTH=32)(
    input clk,
    input reset,
    input [5:0] alu_op,
    input [5:0] shamt,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B, 
    output reg [WIDTH-1:0] Result,
    output Zero
);

  reg [WIDTH-1:0] bit_out;
  reg [WIDTH-1:0] HI, LO; //For lower bits of multiply
  wire [WIDTH-1:0] arith_out, adder_out;
  wire slt;
  
  always @(*) begin
    case(alu_op[1:0])
      2'b00: bit_out =  (A & B);
      2'b01: bit_out =  (A | B);
      2'b10: bit_out =  (A ^ B);
      2'b11: bit_out = ~(A | B);
      default: bit_out = {WIDTH{1'b0}}; 
    endcase
  end

  wire [WIDTH-1:0] B_in = alu_op[1]? ~B: B;
  assign adder_out = A + B_in + {{(WIDTH-1){1'b0}}, alu_op[1]};
  assign arith_out = alu_op[3]? {{(WIDTH-1){1'b0}}, slt}:adder_out;

  // For signed comparison  
  assign slt = (A[WIDTH-1] ^ B[WIDTH-1])? A[WIDTH-1]: adder_out[WIDTH-1];
  
  always @(posedge clk, posedge reset) begin
  	if(reset) {HI, LO} <= 64'd0;
  	else {HI, LO} <= A * B;  // Note to self: Always computing, high energy use if not gated/DSP-use by optimizer
  end
  
  always @(*) begin
  	case(alu_op)
  		6'b000_010: Result = B >> shamt;
  		6'b010_010: Result = LO;
  		default: Result = (alu_op[2])? bit_out: arith_out;
  	endcase
  end
  
  assign Zero = ~(|Result);

endmodule
