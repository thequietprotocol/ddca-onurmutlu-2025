`timescale 1ns / 1ps

module alu_tb;
    reg clk;
    reg reset;
    reg [5:0] alu_op;
    reg [5:0] shamt;
    reg [31:0] A, B;
    wire [31:0] Result;
    wire Zero;

    ALU A0(clk, reset, alu_op, shamt, A, B, Result, Zero);
    
    initial begin
     clk = 0;
     forever #5 clk = ~clk;
    end

    initial begin
        reset  = 1'b1;
        alu_op = 6'd0;
        shamt  = 6'd0;
        A      = 32'd0;
        B      = 32'd0;
        
        #20;
        reset = 0;
        #20;
        
        $display("\n------ ALU TestBench ------");
        $display("\n----- ADD -----");
        A = 32'd15; B = 32'd10; alu_op = 6'b100_000;
        #10;
        $display("ADD: %d + %d = %d (Expected: 25), Zero = %b", A, B, Result, Zero);
        A = 32'd0; B = 32'd0;
        #10;
        $display("ADD: %d + %d = %d (Expected: 0), Zero = %b", A, B, Result, Zero);
        
        $display("\n--- Testing SUB ---");
        A = 32'd20; B = 32'd8; alu_op = 6'b100010;
        #10;
        $display("SUB: %d - %d = %d (Expected: 12), Zero = %b", A, B, Result, Zero);
        A = 32'd5; B = 32'd5;
        #10;
        $display("SUB: %d - %d = %d (Expected: 0), Zero = %b", A, B, Result, Zero);
        $display("\n--- Testing AND ---");
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; alu_op = 6'b100100;
        #10;
        $display("AND: 0x%h & 0x%h = 0x%h (Expected: 0x0F000F00), Zero = %b", A, B, Result, Zero);
        
        // Test OR (100101)
        $display("\n--- Testing OR ---");
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; alu_op = 6'b100101;
        #10;
        $display("OR:  0x%h | 0x%h = 0x%h (Expected: 0xFF0FFF0F), Zero = %b", A, B, Result, Zero);
        
        // Test XOR (100110)
        $display("\n--- Testing XOR ---");
        A = 32'hFF00FF00; B = 32'h0F0F0F0F; alu_op = 6'b100110;
        #10;
        $display("XOR: 0x%h ^ 0x%h = 0x%h (Expected: 0xF00FF00F), Zero = %b", A, B, Result, Zero);
        
        // Test NOR (100111)
        $display("\n--- Testing NOR ---");
        A = 32'h0000000F; B = 32'h000000F0; alu_op = 6'b100111;
        #10;
        $display("NOR: ~(0x%h | 0x%h) = 0x%h (Expected: 0xFFFFFF00), Zero = %b", A, B, Result, Zero);
        
        // Test SLT (101010) - Set Less Than
        $display("\n--- Testing SLT (Set Less Than) ---");
        A = 32'd5; B = 32'd10; alu_op = 6'b101010;
        #10;
        $display("SLT: %d < %d = %d (Expected: 1), Zero = %b", A, B, Result, Zero);
        
        A = 32'd15; B = 32'd10;
        #10;
        $display("SLT: %d < %d = %d (Expected: 0), Zero = %b", A, B, Result, Zero);
        
        // Test with negative numbers (signed comparison)
        A = 32'hFFFFFFF6; B = 32'd5; // -10 < 5
        #10;
        $display("SLT: %d < %d = %d (Expected: 1), Zero = %b", $signed(A), B, Result, Zero);
        
        // Test SRL (000010) - Shift Right Logical
        $display("\n--- Testing SRL (Shift Right Logical) ---");
        A = 32'h0; B = 32'hF0F0F0F0; shamt = 6'd4; alu_op = 6'b000010;
        #10;
        $display("SRL: 0x%h >> %d = 0x%h (Expected: 0x0F0F0F0F), Zero = %b", B, shamt, Result, Zero);
        
        B = 32'h80000000; shamt = 6'd1;
        #10;
        $display("SRL: 0x%h >> %d = 0x%h (Expected: 0x40000000), Zero = %b", B, shamt, Result, Zero);
        
        // Test MULTU (011001) and MFLO (010010)
        $display("\n--- Testing MULTU and MFLO ---");
        A = 32'd12; B = 32'd10; alu_op = 6'b011001;
        #10; // Wait for multiply to complete
        $display("MULTU: %d * %d computed", A, B);
        
        // Move from LO
        alu_op = 6'b010010;
        #10;
        $display("MFLO: Result = %d (Expected: 120), Zero = %b", Result, Zero);
        
        // Test larger multiplication
        A = 32'd65536; B = 32'd65536; alu_op = 6'b011001;
        #10;
        $display("MULTU: %d * %d computed", A, B);
        
        alu_op = 6'b010010;
        #10;
        $display("MFLO: Result = %d (Expected: 4294967296 mod 2^32 = 0), Zero = %b", Result, Zero);
        
        // Test overflow case
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; alu_op = 6'b011001;
        #10;
        $display("MULTU: 0x%h * 0x%h computed", A, B);
        
        alu_op = 6'b010010;
        #10;
        $display("MFLO: Result = 0x%h (Low 32 bits), Zero = %b", Result, Zero);
        
        $display("\nxxxxxx End xxxxxx");
        #20;
        $finish;
    
    end
endmodule
