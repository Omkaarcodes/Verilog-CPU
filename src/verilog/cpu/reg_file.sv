module reg_file (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [4:0]  rs1_addr_i,
    input  logic [4:0]  rs2_addr_i,
    input  logic [4:0]  rd_addr_i,
    input  logic [31:0] rd_data_i,
    input  logic        wr_en_i,
    output logic [31:0] rs1_data_o,
    output logic [31:0] rs2_data_o,
    output logic [31:0] reg_crossbar_o [0:31]
);

    logic [31:0] regs [1:31];

    assign rs1_data_o = (rs1_addr_i == 5'b0) ? 32'b0 :
                        ((wr_en_i && rd_addr_i == rs1_addr_i) ? rd_data_i : regs[rs1_addr_i]);
    assign rs2_data_o = (rs2_addr_i == 5'b0) ? 32'b0 :
                        ((wr_en_i && rd_addr_i == rs2_addr_i) ? rd_data_i : regs[rs2_addr_i]);

    always_comb begin
        reg_crossbar_o[0] = 32'b0;
        for (int i = 1; i < 32; i++) begin
            reg_crossbar_o[i] = regs[i];
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 1; i < 32; i++) begin
                regs[i] <= 32'b0;
            end
        end else if (wr_en_i && (rd_addr_i != 5'b0)) begin
            regs[rd_addr_i] <= rd_data_i;
        end
    end

endmodule