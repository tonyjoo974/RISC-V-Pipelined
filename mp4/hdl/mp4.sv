import rv32i_types::*;

module mp4
(
    input clk,
    input rst,
    input [63:0] pmem_rdata,
    input logic pmem_resp,
    output rv32i_word pmem_address,
    output [63:0] pmem_wdata, // signal used by RVFI Monitor
    output logic pmem_read,
    output logic pmem_write
);


// cpu to cache
rv32i_word imem_rdata;
rv32i_word dmem_rdata;
logic imem_resp;
logic dmem_resp;
rv32i_word imem_address;
rv32i_word dmem_address;
rv32i_word dmem_wdata; // signal used by RVFI Monitor
logic [3:0] dmem_byte_enable; 
logic imem_read;
logic dmem_read;
logic dmem_write;


cache_top cache_top(
    .clk(clk),
    .rst(rst),
    .imem_rdata(imem_rdata),
    .dmem_rdata(dmem_rdata),
    .imem_resp(imem_resp),
    .dmem_resp(dmem_resp),
    .imem_address(imem_address),
    .dmem_address(dmem_address),
    .dmem_wdata(dmem_wdata), // signal used by RVFI Monitor
    .dmem_byte_enable(dmem_byte_enable), 
    .imem_read(imem_read),
    .dmem_read(dmem_read),
    .dmem_write(dmem_write),

    // signal between cache and cacheline adaptor (memory interface)
    .pmem_address(pmem_address),
    .pmem_rdata(pmem_rdata),
    .pmem_wdata(pmem_wdata),
    .pmem_read(pmem_read),
    .pmem_write(pmem_write), 
    .pmem_resp(pmem_resp)
);

// Keep cpu named `cpu` for RVFI Monitor
// Note: you have to rename your mp3 module to `cpu`
cpu cpu(
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


endmodule : mp4