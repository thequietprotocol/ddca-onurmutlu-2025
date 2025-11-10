
// The unit that does the instruction decoding and generates nearly all the control signals
// Combinational logic

module control_unit(
    input [5:0] op, 
    input [5:0] funct,
    output branch,
    output jump, 
    output regDst, // Different encodings in I and R types
    output regWrite,
    output aluSrc,
    output [5:0] aluCtrl,
    output memWrite,
    output memtoReg
);

localparam [5:0] op_rtype = 6'b000_000;
localparam [5:0] op_lw    = 6'b100_011;
localparam [5:0] op_sw    = 6'b101_011;
localparam [5:0] op_beq   = 6'b000_100;
localparam [5:0] op_addi  = 6'b001_000;
localparam [5:0] op_j     = 6'b000_010;

assign branch   = (op == op_beq);
assign jump     = (op == op_j);
assign regDst   = (op == op_rtype);
assign regWrite = (op == op_rtype) | (op == op_lw) | (op == op_addi);
assign aluSrc   = (op == op_lw) | (op == op_sw) |(op == op_addi);
assign memWrite = (op == op_sw);
assign memtoReg = (op == op_lw);

assign aluCtrl  = aluSrc? 6'b100_000 : (branch? 6'b100_010 : funct);

endmodule
