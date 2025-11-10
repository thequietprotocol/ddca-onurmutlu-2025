
module register_file #(
    parameter WIDTH = 32,           // bits per register
    parameter DEPTH = 32            // number of registers
)(
    input  wire                   clk,
    input  wire                   we,       // write enable
    input  wire [$clog2(DEPTH)-1:0] waddr,  // write address
    input  wire [$clog2(DEPTH)-1:0] raddr1, // read address 1
    input  wire [$clog2(DEPTH)-1:0] raddr2, // read address 2
    input  wire [WIDTH-1:0]       wdata,    // write data
    output reg  [WIDTH-1:0]       rdata1,   // read data 1
    output reg  [WIDTH-1:0]       rdata2    // read data 2
);
    // Tell Vivado to use distributed (LUT) RAM
    (* ram_style = "distributed" *)
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge clk) begin
        if (we && (waddr != {$clog2(DEPTH){1'b0}}))
            mem[waddr] <= wdata;
    end

    // Asynchronous read ports
    always @(*) begin
        rdata1 = (raddr1 == {$clog2(DEPTH){1'b0}})? {WIDTH{1'b0}}: mem[raddr1];
        rdata2 = (raddr2 == {$clog2(DEPTH){1'b0}})? {WIDTH{1'b0}}: mem[raddr2];
    end
endmodule
