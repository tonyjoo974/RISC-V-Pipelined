import rv32i_types::*;

module cpu
(
    input clk,
    input rst,
    input rv32i_word imem_rdata,
    input rv32i_word dmem_rdata,
    input logic imem_resp,
    input logic dmem_resp,
    output rv32i_word imem_address,
    output rv32i_word dmem_address,
    output rv32i_word dmem_wdata, // signal used by RVFI Monitor
    output logic [3:0] dmem_byte_enable, 
    output logic imem_read,
    output logic dmem_read,
    output logic dmem_write
);



// rv32i_word imem_addr;
// rv32i_word dmem_addr;
// assign imem_address = {imem_addr[31:2], 2'd0};
// assign dmem_address = {dmem_addr[31:2], 2'd0};

// Keep datapath named `datapath` for RVFI Monitor
datapath datapath(
    .clk(clk),
    .rst(rst),
    .imem_rdata(imem_rdata),
    .dmem_rdata(dmem_rdata),
    .imem_resp(imem_resp),
    .dmem_resp(dmem_resp),
    .imem_address(imem_address),
    .dmem_address(dmem_address),
    .dmem_wdata(dmem_wdata), 
    .dmem_byte_enable(dmem_byte_enable), 
    .imem_read(imem_read),
    .dmem_read(dmem_read),
    .dmem_write(dmem_write)
);

endmodule : cpu
