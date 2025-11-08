 
// Instrs: 
// add, sub, and, or, xor, nor, slt (32-bit ext)
// 0000, 0010, 0100, 0101, 0110, 0111, 1010


module ALU #(parameter WIDTH=32)(
    input [3:0] alu_op,
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B, 
    output [WIDTH-1:0] Result,
    output Zero
);

  reg [WIDTH-1:0] bit_out;
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

  assign Result = alu_op[2]? bit_out: arith_out;
  assign Zero = ~(|Result);

endmodule
