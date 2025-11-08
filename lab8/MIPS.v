`timescale 1ns / 1ps
module MIPS(
    input clk,
    input reset,
    output [31:0] io_write_data,
    output io_write_en,
    input [31:0] io_read_data,
    output [3:0] io_addr
    );
    
    reg  [31:0] PC;
    wire [31:0] PC_plus4;
    wire [31:0] PC_branch;
    wire [31:0] PC_calc;
    wire [31:0] PC_jump;
    wire [31:0] PC_next;
    
    wire [31:0] instr;
    wire [31:0] signImm;
    wire [4:0]  reg_write_dst;
    
    wire [31:0] aluA;
    wire [31:0] aluB;
    wire [31:0] aluResult;
    wire zero;
    
    wire [31:0] dm_write_data;
    wire [31:0] dm_read_data;
    wire [31:0] data_to_reg;
    wire memWrite;
    
    
    // Controls
    wire pc_src; //
    wire jump; //
    wire branch; //
    wire regDst; //
    wire regWrite; //
    wire aluSrc;  //
    wire [5:0] aluCtrl; //
    wire mem_to_reg;  //
    
    // IO
    wire isIO;  //
    wire dataMemWrite;  //
    wire [31:0] readMemIO;
    
    assign PC_plus4  = PC + 4;    
    assign PC_branch = PC_plus4 + (signImm << 2);
    assign PC_calc   = pc_src? PC_branch : PC_plus4;
    assign PC_jump   = {PC_plus4[31:28], instr[25:0], 2'b00};
    assign PC_next   = jump? PC_jump : PC_calc;    
    
    always @(posedge clk, posedge reset) begin
      if(reset) PC <= 32'h0000_2FFC;
      else PC <= PC_next;
    end
    
    instruction_memory im0(
      .i_addr(PC[7:2]),
      .instr(instr)
    );
    
    assign signImm = {{16{instr[15]}}, instr[15:0]};
    assign reg_write_dst = regDst? instr[15:11] : instr[20:16];
    
    register_file rf0(
    .clk(clk),
    .we(regWrite),                  // write enable
    .waddr(reg_write_dst),            // write address
    .raddr1(instr[25:21]),          // read address 1
    .raddr2(instr[20:16]),          // read address 2
    .wdata(data_to_reg),             // write data
    .rdata1(aluA),                  // read data 1
    .rdata2(dm_write_data)              // read data 2
    );
    
    assign aluB = aluSrc? signImm : dm_write_data;
    // add, sub, and, or, xor, nor, slt (32-bit ext)
    // 0000, 0010, 0100, 0101, 0110, 0111, 1010

    ALU alu0(
    .alu_op(aluCtrl[3:0]),
    .A(aluA),
    .B(aluB), 
    .Result(aluResult),
    .Zero(zero)
    );
    
    assign pc_src = branch & zero;
    
    data_memory dm0(
	.clk(clk), 
	.d_addr(aluResult[7:2]),
	.write_enable(memWrite),
	.write_data(dm_write_data),
	.read_data(dm_read_data)
    );
    
    control_unit cu0(
    .op(instr[31:26]), 
    .funct(instr[5:0]),
    .branch(branch),
    .jump(jump), 
    .regDst(regDst), // Different encodings in I and R types
    .regWrite(regWrite),
    .aluSrc(aluSrc),
    .aluCtrl(aluCtrl),
    .memWrite(memWrite),
    .memtoReg(mem_to_reg)
    );
    
    // Memeory-mapped I/O between 32'h0000_7ff0 and 32'h0000_7fff
    
    assign isIO = (aluResult[31:4] == 28'h0000_7ff);
    assign dataMemWrite = memWrite & (!isIO); 
    assign io_write_data = dm_write_data;
    assign io_addr = aluResult[3:0];
    assign io_write_en = memWrite & isIO;
    
    assign readMemIO = isIO? io_read_data: dm_read_data;
    assign data_to_reg = mem_to_reg? readMemIO : aluResult;
    
endmodule
