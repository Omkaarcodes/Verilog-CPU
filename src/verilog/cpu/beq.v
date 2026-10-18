```verilog
module beq_zero (
    input  wire [31:0] current_pc,    // Current PC
    input  wire [31:0] rs1_val,       // Value of rs1
    input  wire [31:0] rs2_val,       // Value of rs2 (x0 = 0)
    input  wire        imm_12,        // Branch immediate bit 12
    input  wire        imm_11,        // Branch immediate bit 11
    input  wire [5:0]  imm_10_5,      // Branch immediate bits 10:5
    input  wire [3:0]  imm_4_1,       // Branch immediate bits 4:1
    output wire        branch_taken,  // 1 when rs1 == rs2
    output wire [31:0] target_pc,     // Branch target address
    output wire [31:0] next_pc,       // Next PC
    output wire        reg_write_en   // Register write enable
);

    // Bit 0 is always 0 for branch instructions.
    wire [31:0] b_imm_sext;
    
    assign b_imm_sext = {{19{imm_12}}, imm_12, imm_11, imm_10_5, imm_4_1, 1'b0};

    assign branch_taken = (rs1_val == rs2_val);

    assign target_pc = current_pc + b_imm_sext;
    assign next_pc   = branch_taken ? target_pc : (current_pc + 32'd4);

    assign reg_write_en = 1'b0;

endmodule

