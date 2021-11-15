/* MODIFY. The cache datapath. It contains the data,
valid, dirty, tag, and LRU arrays, comparators, muxes,
logic gates and other supporting logic. */

module cache_datapath #(
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

    input logic [31:0] address,
    input logic tag1_ld, tag2_ld, valid1_ld, valid2_ld, 
    input logic dirty1_ld, dirty2_ld, lru_ld,
    input logic valid1_in, valid2_in, dirty1_in, dirty2_in, lru_in,
    input logic [255:0] pmem_rdata,
    input logic [31:0] mem_byte_enable256,
    input logic [255:0] mem_wdata256,
    input logic [1:0] write1_select, write2_select,
    input logic bus_select1, bus_select2, cache_out_select, 
    input logic [1:0] dirty_write,

    output logic [23:0] tag1_mem, tag2_mem,
    output logic valid1_out, valid2_out, dirty1_out, dirty2_out,
    output logic lru_out,
    output logic [255:0] pmem_wdata,
    output logic [31:0] pmem_address
);

logic [31:0] data1_byte_enable, data2_byte_enable;
logic [255:0] data1_in, data2_in, data1_out, data2_out;
// logic [23:0] lru_tag;
// assign lru_tag = (lru_in == 1'b0) ? tag1_mem : tag2_mem;

array #(
    .s_index(s_index),
    .width(s_tag)
)
tag_1(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(tag1_ld),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(address[31:8]),
    .dataout(tag1_mem)
);

array #(
    .s_index(s_index),
    .width(s_tag)
)
tag_2(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(tag2_ld),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(address[31:8]),
    .dataout(tag2_mem)
);

array #(
    .s_index(s_index),
    .width(1)
)
valid_1(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(valid1_ld),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(valid1_in),
    .dataout(valid1_out)
);

array #(
    .s_index(s_index),
    .width(1)
)
valid_2(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(valid2_ld),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(valid2_in),
    .dataout(valid2_out)
);

array #(
    .s_index(s_index),
    .width(1)
)
dirty_1(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(dirty1_ld),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(dirty1_in),
    .dataout(dirty1_out)
);

array #(
    .s_index(s_index),
    .width(1)
)
dirty_2(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(dirty2_ld),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(dirty2_in),
    .dataout(dirty2_out)
);

array #(
    .s_index(s_index),
    .width(1)
)
lru(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .load(lru_ld),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(lru_in),
    .dataout(lru_out)
);

data_array way1(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .write_en(data1_byte_enable),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(data1_in),
    .dataout(data1_out)
);

data_array way2(
    .clk(clk),
    .rst(rst),
    .read(1'b1),
    .write_en(data2_byte_enable),
    .rindex(address[7:5]),
    .windex(address[7:5]),
    .datain(data2_in),
    .dataout(data2_out)
);

// MUXES
always_comb begin
    unique case (cache_out_select)
        1'b0: pmem_wdata = data1_out;
        1'b1: pmem_wdata = data2_out;
        default: pmem_wdata = data1_out;
    endcase
    unique case (write1_select)
        2'b00: data1_byte_enable = 32'b00000000000000000000000000000000;
        2'b01: data1_byte_enable = 32'b11111111111111111111111111111111;
        2'b11: data1_byte_enable = mem_byte_enable256;
        default: data1_byte_enable = 32'b00000000000000000000000000000000;
    endcase
    unique case (write2_select)
        2'b00: data2_byte_enable = 32'b00000000000000000000000000000000;
        2'b01: data2_byte_enable = 32'b11111111111111111111111111111111;
        2'b11: data2_byte_enable = mem_byte_enable256;
        default: data2_byte_enable = 32'b00000000000000000000000000000000;
    endcase
    unique case (dirty_write)
        2'b00: pmem_address = {address[31:5], 5'b00000};   //default
        // 1'b1: pmem_address = {lru_tag, address[7:0]};
        2'b01: pmem_address = {tag1_mem, address[7:5], 5'b00000};  //write to mem
        2'b11: pmem_address = {tag2_mem, address[7:5], 5'b00000};  //write to mem
        default: pmem_address = {address[31:5], 5'b00000};
    endcase
    unique case (bus_select1)
        1'b0:
            // cacheline adaptor
            data1_in = pmem_rdata;
        1'b1: 
            // bus adaptor
            data1_in = mem_wdata256;
        default:
            data1_in = pmem_rdata;
    endcase
    unique case (bus_select2)
        1'b0:
            // cacheline adaptor
            data2_in = pmem_rdata;
        1'b1: 
            // bus adaptor
            data2_in = mem_wdata256;
        default:
            data2_in = pmem_rdata;
    endcase
end

endmodule : cache_datapath
