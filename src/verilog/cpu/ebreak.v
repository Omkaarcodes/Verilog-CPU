
module ebreak (
    input  wire [31:0] insn,          // Current instruction word
    output wire        is_ebreak,     // 1 if insn == 32'h00100073
    output wire        halt_cpu,      // Latched or active CPU stop signal
    output wire        pc_advance_en, // Program counter clock enable (0 freezes PC)
    output wire        reg_write_en,  // Force suppressed (0)
    output wire        mem_write_en   // Force suppressed (0)
);

    // EBREAK instruction encoding:
    // opcode = 7'b1110011, funct3 = 3'b000, funct12 = 12'b000000000001
    assign is_ebreak = (insn == 32'h00100073);

    // When ebreak is decoded, halt CPU and block all writes:
    assign halt_cpu       = is_ebreak;
    assign pc_advance_en  = ~is_ebreak;
    assign reg_write_en   = 1'b0;
    assign mem_write_en   = 1'b0;

endmodule