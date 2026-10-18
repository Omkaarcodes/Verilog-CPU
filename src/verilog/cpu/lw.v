module lw (
    input  wire [31:0] rs1_val,
    input  wire [11:0] imm,
    input  wire [4:0] rd_addr,
    input  wire [31:0] mem_rdata,

    output wire [31:0] mem_addr,
    output wire        mem_read_en,
    output wire [31:0] rd_val,
    output wire        reg_write_en
);

   assign mem_addr = rs1_val + {{20{imm[11]}}, imm};
   assign mem_read_en = 1'b1;

   assign reg_write_en = (rd_addr != 5'b0) ? 1'b1 : 1'b0;
   assign rd_val = (rd_addr != 5'b0) ? mem_rdata : 32'b0;

endmodule