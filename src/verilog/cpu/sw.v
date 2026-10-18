module sw (
    input  wire [31:0] rs1_val,
    input  wire [11:0] imm,
    output  wire [31:0] mem_wdata,
    input wire [31:0] rs2_val,

    output wire [31:0] mem_addr,
    output wire        mem_write_en
    
);

assign mem_addr = rs1_val + {{20{imm[11]}}, imm};
assign mem_wdata = rs2_val;

assign mem_write_en = 1'b1;
endmodule