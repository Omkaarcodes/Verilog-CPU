

module addi_neg (
    input  wire [31:0] rs1_val,       // Value read from source register rs1
    input  wire [11:0] imm,           
    input  wire [4:0]  rd_addr,       // Destination register address
    output wire [31:0] rd_val,       
    output wire  reg_write_en,  // Write enable (0 if rd is x0)
    output wire  is_valid_neg   // Asserted if immediate is strictly negative
);

    // Immediate sign-extension for negative values
    wire [31:0] imm_extended;
    assign imm_extended = {{20{imm[11]}}, imm[11:0]};

    // Flag whether the input immediate is indeed negative:
    assign is_valid_neg = (imm[11] == 1'b1);

    wire [31:0] sub_result;
    assign sub_result = rs1_val + imm_extended;

    // Architectural Invariant: Register x0 is hardwired to zero.
    assign reg_write_en = (rd_addr != 5'd0);
    assign rd_val       = (rd_addr == 5'd0) ? 32'h00000000 : sub_result;

endmodule