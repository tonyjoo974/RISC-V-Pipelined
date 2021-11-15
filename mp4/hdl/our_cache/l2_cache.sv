module l2_cache (
    input clk,
    input rst,

    // Arbiter <-> L2
    input logic [31:0] l2_address,
    output logic [255:0] l2_rdata,
    input logic [255:0] l2_wdata,
    input logic l2_read,
    input logic l2_write,
    output logic l2_resp,

    // L2 <-> Cacheline Adaptor
    input logic [255:0] pmem_rdata,
    input logic pmem_resp,
    output logic [31:0] pmem_address,
    output logic [255:0] pmem_wdata,
    output logic pmem_read,
    output logic pmem_write
);

logic tag1_ld, tag2_ld, valid1_ld, valid2_ld;
logic dirty1_ld, dirty2_ld, lru_ld;
logic valid1_in, valid2_in, dirty1_in, dirty2_in, lru_in;
logic [1:0] dirty_write;
logic [21:0] tag1_mem, tag2_mem;
logic valid1_out, valid2_out, dirty1_out, dirty2_out, lru_out;
logic cache_out_select;

logic [255:0] cacheline_o;
// logic [255:0] mem_wdata256;
// logic [31:0] mem_byte_enable256;
logic write1_select, write2_select;
logic bus_select1, bus_select2;

assign pmem_wdata = cacheline_o;
assign l2_rdata = cacheline_o;

l2_cache_control l2_control (
    .clk(clk),
    .rst(rst),

    .mem_address(l2_address),
    // cacheline <-> L2 cache_control
    .mem_resp(l2_resp),
    .l2_read(l2_read),
    .l2_write(l2_write),
    .pmem_resp(pmem_resp),
    .pmem_read(pmem_read),
    .pmem_write(pmem_write),

    // L2 datapath
    .tag1_mem(tag1_mem),
    .tag2_mem(tag2_mem),
    .valid1_out(valid1_out), 
    .valid2_out(valid2_out), 
    .dirty1_out(dirty1_out), 
    .dirty2_out(dirty2_out),
    .lru_out(lru_out),
    .dirty_write(dirty_write),
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

l2_cache_datapath l2_datapath
(
    .clk(clk),
    .rst(rst),
    .address(l2_address),
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
    .write1_select(write1_select),
    .write2_select(write2_select),
    .bus_select1(bus_select1),
    .bus_select2(bus_select2),
    .cache_out_select(cache_out_select),
    .dirty_write(dirty_write),

    .tag1_mem(tag1_mem), 
    .tag2_mem(tag2_mem),
    .valid1_out(valid1_out), 
    .valid2_out(valid2_out),
    .dirty1_out(dirty1_out),
    .dirty2_out(dirty2_out),
    .lru_out(lru_out),
    .pmem_address(pmem_address),
    .pmem_wdata(cacheline_o),
    .mem_wdata256(l2_wdata)
);

endmodule : l2_cache
