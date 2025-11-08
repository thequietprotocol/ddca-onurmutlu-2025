
module data_memory(
	input clk, 
	input  [5:0] d_addr,
	input  write_enable,
	input  [31:0] write_data,
	output [31:0] read_data
);

reg [31:0] datas [0:63];
initial
  begin
    $readmemh("data_mem_h.txt", datas);
  end

assign read_data = datas[d_addr];

always @(posedge clk) begin
  if(write_enable) datas[d_addr] <= write_data;
end

endmodule
