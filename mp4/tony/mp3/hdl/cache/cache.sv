/* MODIFY. Your cache design. It contains the cache
controller, cache datapath, and bus adapter. */
import rv32i_types::*;

module cache #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
    input clk,
    input rst,
    // signals between cpu and cache
    input rv32i_word mem_address,
    output rv32i_word mem_rdata,    // mem -> cache -> cpu
    input rv32i_word mem_wdata,
    input logic mem_read,
    input logic mem_write,
    input logic [3:0] mem_byte_enable,
    output logic mem_resp,    // mem -> cache -> cpu

    // signal between cache and cacheline adaptor (memory interface)
    output rv32i_word pmem_address,
    input logic [255:0] pmem_rdata,
    output logic [255:0] pmem_wdata,
    output logic pmem_read,
    output logic pmem_write, 
    input logic pmem_resp
);

logic tag1_ld, tag2_ld, valid1_ld, valid2_ld;
logic dirty1_ld, dirty2_ld, lru_ld;
logic valid1_in, valid2_in, dirty1_in, dirty2_in, lru_in;
logic [1:0] dirty_write;
logic [23:0] tag1_mem, tag2_mem;
logic valid1_out, valid2_out, dirty1_out, dirty2_out, lru_out;
logic cache_out_select;

logic [255:0] cacheline_o;
logic [255:0] mem_wdata256;
logic [31:0] mem_byte_enable256;
logic [1:0] write1_select, write2_select;
logic bus_select1, bus_select2;

assign pmem_wdata = cacheline_o;

cache_control control
(
    .clk(clk),
    .rst(rst),
    .mem_address(mem_address),
    // cpu -> cache_control
    .cpu_read(mem_read),
    .cpu_load(mem_write),
    .mem_resp(mem_resp),
    
    // cache_control -> cpu


    // cache_control -> memory
    .pmem_read(pmem_read),
    .pmem_write(pmem_write),
    .dirty_write(dirty_write),
    // memory -> cache controller
    .pmem_resp(pmem_resp),

    .tag1_mem(tag1_mem),
    .tag2_mem(tag2_mem),
    .valid1_out(valid1_out), 
    .valid2_out(valid2_out), 
    .dirty1_out(dirty1_out), 
    .dirty2_out(dirty2_out),
    .lru_out(lru_out),

    .tag1_ld(tag1_ld), 
    .tag2_ld(tag2_ld), 
    .valid1_ld(valid1_ld), 
    .valid2_ld(valid2_ld), 
    .dirty1_ld(dirty1_ld), 
    .dirty2_ld(dirty2_ld), 
    .lru_ld(lru_ld),
    .valid1_in(valid1_in), 
    .valid2_in(valid2_in), 
    .dirty1_in(dirty1_in), 
    .dirty2_in(dirty2_in), 
    .lru_in(lru_in),

    .write1_select(write1_select),
    .write2_select(write2_select),
    .bus_select1(bus_select1),
    .bus_select2(bus_select2),
    .cache_out_select(cache_out_select)
);

cache_datapath datapath
(
    .clk(clk),
    .rst(rst),
    .address(mem_address),
    .tag1_ld(tag1_ld),
    .tag2_ld(tag2_ld), 
    .valid1_ld(valid1_ld), 
    .valid2_ld(valid2_ld), 
    .dirty1_ld(dirty1_ld), 
    .dirty2_ld(dirty2_ld), 
    .lru_ld(lru_ld),
    .valid1_in(valid1_in), 
    .valid2_in(valid2_in), 
    .dirty1_in(dirty1_in), 
    .dirty2_in(dirty2_in), 
    .lru_in(lru_in),
    .pmem_rdata(pmem_rdata),
    .mem_byte_enable256(mem_byte_enable256),
    .mem_wdata256(mem_wdata256),
    .dirty_write(dirty_write),
    
    .tag1_mem(tag1_mem), 
    .tag2_mem(tag2_mem),
    .valid1_out(valid1_out), 
    .valid2_out(valid2_out),
    .dirty1_out(dirty1_out),
    .dirty2_out(dirty2_out),
    .lru_out(lru_out),
    .pmem_wdata(cacheline_o),
    .pmem_address(pmem_address),

    .write1_select(write1_select),
    .write2_select(write2_select),
    .bus_select1(bus_select1),
    .bus_select2(bus_select2),
    .cache_out_select(cache_out_select)
);

bus_adapter bus_adapter
(
    .mem_wdata256(mem_wdata256),
    .mem_rdata256(cacheline_o),
    .mem_wdata(mem_wdata),
    .mem_rdata(mem_rdata),
    .mem_byte_enable(mem_byte_enable),
    .mem_byte_enable256(mem_byte_enable256),
    .address(mem_address)
);

endmodule : cache
