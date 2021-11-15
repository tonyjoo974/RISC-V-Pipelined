import rv32i_types::*;

module mp3
(
    input clk,
    input rst,
    input pmem_resp,
    input [63:0] pmem_rdata,
    output logic pmem_read,
    output logic pmem_write,
    output rv32i_word pmem_address,
    output [63:0] pmem_wdata
);

logic mem_resp, mem_read, mem_write;
logic [3:0] mem_byte_enable;
rv32i_word mem_address, mem_rdata, mem_wdata;
logic [31:0] address_i, address_o;
logic [255:0] line_i, line_o;
logic read_i, write_i, resp_o;
// Keep cpu named `cpu` for RVFI Monitor
// Note: you have to rename your mp3 module to `cpu`
cpu cpu(
    .clk(clk),
    .rst(rst),
    .mem_resp(mem_resp),
    .mem_rdata(mem_rdata),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),
    .mem_address(mem_address),
    .mem_wdata(mem_wdata)
);

// Keep cache named `cache` for RVFI Monitor
cache cache(
    .clk(clk),
    .rst(rst),
    // signals between cpu and cache
    .mem_address(mem_address),
    .mem_rdata(mem_rdata),    // mem -> cache -> cpu
    .mem_wdata(mem_wdata),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),
    .mem_resp(mem_resp),    // mem -> cache -> cpu

    // signal between cache and cacheline adaptor (memory interface)
    .pmem_address(address_i),
    .pmem_rdata(line_o),
    .pmem_wdata(line_i),
    .pmem_read(read_i),
    .pmem_write(write_i), 
    .pmem_resp(resp_o)
);

// From MP1
cacheline_adaptor cacheline_adaptor
(
    .clk(clk),
    .reset_n(~rst),

    // Port to LLC (Lowest Level Cache)
    .line_i(line_i),
    .line_o(line_o),
    .address_i(address_i),
    .read_i(read_i),
    .write_i(write_i),
    .resp_o(resp_o),

    // Port to memory
    .burst_i(pmem_rdata),
    .burst_o(pmem_wdata),
    .address_o(pmem_address),
    .read_o(pmem_read),
    .write_o(pmem_write),
    .resp_i(pmem_resp)
);

endmodule : mp3
