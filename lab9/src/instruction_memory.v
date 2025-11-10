
module instruction_memory(
	input  [5:0]  i_addr, 
	output [31:0] instr
);

reg [31:0] instructions [0:63];

initial
  begin
    $readmemh("instr_mem_h.txt", instructions);
  end

assign instr = instructions[i_addr];

endmodule
