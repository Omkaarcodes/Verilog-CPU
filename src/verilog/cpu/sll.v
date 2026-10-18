

module sll (
    input  wire [31:0] rs1_val,       // Value to be shifted
    input  wire [31:0] rs2_val,       // Register containing shift amount in [4:0]
    input  wire [4:0]  rd_addr,       // Destination register address
    output wire [31:0] rd_val,        // Shifted result committed to register file
    output wire        reg_write_en,  // Register write enable (masked if rd == x0)
);

    // Logical Left Shift:
    wire [31:0] shift_result;
    assign shift_result = rs1_val << rs2_val[4:0];

    assign reg_write_en = (rd_addr != 5'd0);
    assign rd_val       = (rd_addr == 5'd0) ? 32'h00000000 : shift_result;

endmodule