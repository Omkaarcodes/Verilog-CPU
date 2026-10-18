`timescale 1ns / 1ps


module sub (
    input  wire [31:0] rs1_val,       // Minuend from register rs1
    input  wire [31:0] rs2_val,       // Subtrahend from register rs2
    input  wire [4:0]  rd_addr,       // Destination register address
    output wire [31:0] rd_val,        // Result data committed to register file
    output wire        reg_write_en,  // Write enable (0 if rd is x0)
    output wire        zero_flag,     // High if result is exactly 0
    output wire        negative_flag  // High if result is negative (MSB == 1)
);

    wire [31:0] diff;
    assign diff = rs1_val - rs2_val;

    // Status flags:
    assign zero_flag     = (diff == 32'h00000000);
    assign negative_flag = diff[31];

    // Architectural Invariant: Register x0 cannot be overwritten:
    assign reg_write_en = (rd_addr != 5'd0);
    assign rd_val       = (rd_addr == 5'd0) ? 32'h00000000 : diff;

endmodule