
module addi_pos (
    input  wire [31:0] rs1_val,       // Value read from source register rs1
    input  wire [11:0] imm,           // 12-bit immediate operand (imm[11] = 0)
    input  wire [4:0]  rd_addr,       // Destination register address
    output wire [31:0] rd_val,        // Result data to be committed to register file
    output wire        reg_write,  // Write enable (0 if rd is x0)
    output wire        is_valid_pos   // Asserted if immediate is strictly positive/non-negative
);

 
    wire [31:0] imm_ext;
     wire [31:0] sum_result;

    assign imm_ext = {{20{imm[11]}}, imm[11:0]};

    // Flag whether the input immediate is non-negative:
    assign is_valid_pos = (imm[11] == 1'b0);

   
    assign sum_result = rs1_val + imm_ext;


    assign reg_write = (rd_addr != 5'd0);
    assign rd_val       = (rd_addr == 5'd0) ? 32'h00000000 : sum_result;

endmodule