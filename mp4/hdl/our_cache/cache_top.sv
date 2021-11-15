import rv32i_types::*;

module cache_top (
    input clk,
    input rst,

    input rv32i_word imem_address,
    input logic imem_read,
    output rv32i_word imem_rdata,
    output logic imem_resp,

    input rv32i_word dmem_address,
    input rv32i_word dmem_wdata, // signal used by RVFI Monitor
    input logic [3:0] dmem_byte_enable, 
    input logic dmem_read,
    input logic dmem_write,
    output rv32i_word dmem_rdata,
    output logic dmem_resp,
    

    // signal between arbiter and cacheline adaptor (memory interface)
    output rv32i_word pmem_address,
    input logic [63:0] pmem_rdata,
    output logic [63:0] pmem_wdata,
    output logic pmem_read,
    output logic pmem_write, 
    input logic pmem_resp
);

// signals used for caches and arbiter
rv32i_word ipmem_address;
logic [255:0] ipmem_rdata;
logic ipmem_read;
logic ipmem_resp;
rv32i_word dpmem_address;
logic [255:0] dpmem_wdata; 
logic dpmem_read;
logic dpmem_write;
logic [255:0] dpmem_rdata;
logic dpmem_resp;

logic [31:0] address_i, address_o;
logic [255:0] line_i, line_o;
logic read_i, write_i, resp_o;

// Signals between Arbiter and L2
logic [31:0] l2_pmem_address;
logic [255:0] l2_pmem_rdata;
logic [255:0] l2_pmem_wdata;
logic l2_pmem_read;
logic l2_pmem_write;
logic l2_pmem_resp;

cache inst_cache(
    .clk(clk),
    .rst(rst),
    // signals between cpu and cache
    .mem_address(imem_address),
    .mem_rdata(imem_rdata),    // mem -> cache -> cpu
    .mem_wdata(),
    .mem_read(imem_read),
    .mem_write(1'b0),
    .mem_byte_enable(),
    .mem_resp(imem_resp),    // mem -> cache -> cpu

    // signal between cache and cacheline adaptor (memory interface)
    .pmem_address(ipmem_address),
    .pmem_rdata(ipmem_rdata),
    .pmem_wdata(),
    .pmem_read(ipmem_read),
    .pmem_write(), 
    .pmem_resp(ipmem_resp)
);

cache data_cache(
    .clk(clk),
    .rst(rst),
    // signals between cpu and cache
    .mem_address(dmem_address),
    .mem_rdata(dmem_rdata),    // mem -> cache -> cpu
    .mem_wdata(dmem_wdata),
    .mem_read(dmem_read),
    .mem_write(dmem_write),
    .mem_byte_enable(dmem_byte_enable),
    .mem_resp(dmem_resp),    // mem -> cache -> cpu

    // signal between cache and cacheline adaptor (memory interface)
    .pmem_address(dpmem_address),
    .pmem_rdata(dpmem_rdata),
    .pmem_wdata(dpmem_wdata),
    .pmem_read(dpmem_read),
    .pmem_write(dpmem_write), 
    .pmem_resp(dpmem_resp)
);

arbiter arbiter
(
    .clk(clk),
    .rst(rst),
    
    .ipmem_address(ipmem_address),
    .ipmem_read(ipmem_read),
    .ipmem_rdata(ipmem_rdata),
    .ipmem_resp(ipmem_resp),
    .dpmem_address(dpmem_address),
    .dpmem_wdata(dpmem_wdata), 
    .dpmem_read(dpmem_read),
    .dpmem_write(dpmem_write),
    .dpmem_rdata(dpmem_rdata),
    .dpmem_resp(dpmem_resp),

    // L2 connection
    .pmem_address(l2_pmem_address),
    .pmem_rdata(l2_pmem_rdata),
    .pmem_wdata(l2_pmem_wdata),
    .pmem_read(l2_pmem_read),
    .pmem_write(l2_pmem_write), 
    .pmem_resp(l2_pmem_resp)
);

l2_cache l2_cache
(
    .clk(clk),
    .rst(rst),
    
    // Arbiter <-> L2
    .l2_address(l2_pmem_address),
    .l2_rdata(l2_pmem_rdata),
    .l2_wdata(l2_pmem_wdata),
    .l2_read(l2_pmem_read),
    .l2_write(l2_pmem_write),
    .l2_resp(l2_pmem_resp),

    // L2 <-> Cacheline Adaptor
    .pmem_address(address_i),
    .pmem_rdata(line_o),
    .pmem_wdata(line_i),
    .pmem_read(read_i),
    .pmem_write(write_i),
    .pmem_resp(resp_o)    
);

cacheline_adaptor cacheline_adaptor
(
    .clk(clk),
    .reset_n(~rst),

    // Port to L2 Cache
    .address_i(address_i),
    .line_i(line_i),
    .line_o(line_o),
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
endmodule : cache_top