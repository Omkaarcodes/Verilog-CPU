

// =============================================================================
// Module: add
// Description: RV32I ADD (Register-Register Add).
//              Computes: rd_val = rs1_val + rs2_val
//              Format: R-type (opcode = 7'b0110011, funct3 = 3'b000, funct7 = 7'b0000000)
//
// Invariants:
// - Supports full 32-bit signed and unsigned two's complement addition.
// - If rd == 5'd0, register x0 invariant is preserved (hardwired zero).
// =============================================================================

module add (
    input  wire [31:0] rs1_val,       // Operand A from register rs1
    input  wire [31:0] rs2_val,       // Operand B from register rs2
    input  wire [4:0]  rd_addr,       // Destination register address
    output wire [31:0] rd_val,        // Result data committed to register file
    output wire        reg_write_en,  // Write enable (0 if rd is x0)
    output wire        zero_flag,     // High if result is exactly 0
    output wire        overflow_flag  // Signed overflow indicator
);

    wire [31:0] sum;
    assign sum = rs1_val + rs2_val;

    // Zero detection:
    assign zero_flag = (sum == 32'h00000000);

    // Two's complement signed overflow detection:
    // Overflow occurs if operands have the same sign, but the sum has an opposite sign.
    assign overflow_flag = (rs1_val[31] == rs2_val[31]) && (sum[31] != rs1_val[31]);

    // Architectural Invariant: Register x0 cannot be written:
    assign reg_write_en = (rd_addr != 5'd0);
    assign rd_val       = (rd_addr == 5'd0) ? 32'h00000000 : sum;

endmodule