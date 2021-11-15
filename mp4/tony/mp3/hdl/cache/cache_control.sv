/* MODIFY. The cache controller. It is a state machine
that controls the behavior of the cache. */

module cache_control (
    input clk,
    input rst,
    input logic [31:0] mem_address,
    // memory -> cache controller
    input logic pmem_resp,

    input logic [23:0] tag1_mem, tag2_mem,
    input logic valid1_out, valid2_out, dirty1_out, dirty2_out,
    input logic lru_out,

    // cpu -> cache_control
    input logic cpu_read, cpu_load,
    
    // cache_control -> cpu
    output logic mem_resp,

    // cache_control -> memory
    output logic pmem_read,
    output logic pmem_write,
    output logic [1:0] dirty_write,

    output logic tag1_ld, tag2_ld, valid1_ld, valid2_ld, 
    output logic dirty1_ld, dirty2_ld, lru_ld,
    output logic valid1_in, valid2_in, dirty1_in, dirty2_in, lru_in,
    output logic [1:0] write1_select, write2_select,
    output logic bus_select1, bus_select2, cache_out_select
);

logic hit0, hit1, dirty, rd_or_wr; 
// logic way_num;
// assign way_num = ((mem_address[31:8] == tag2_mem) && valid2_out);
assign hit0 = ((mem_address[31:8] == tag1_mem) & valid1_out);
assign hit1 = ((mem_address[31:8] == tag2_mem) & valid2_out);
assign dirty = (dirty1_out == 1 && lru_out == 0) | (dirty2_out == 1 && lru_out == 1);
assign rd_or_wr = (cpu_read ^ cpu_load);

enum int unsigned {
    /* List of states */
    idle = 0,
    decode = 1,
    allocate = 2,
    write_back = 3
} state, next_states;


function void set_defaults();
    tag1_ld = 1'b0;
    tag2_ld = 1'b0;
    valid1_ld = 1'b0;
    valid2_ld = 1'b0;
    dirty1_ld = 1'b0;
    dirty2_ld = 1'b0;
    lru_ld = 1'b0;
    valid1_in = 1'b0;
    valid2_in = 1'b0;
    dirty1_in = 1'b0;
    dirty2_in = 1'b0;
    lru_in = 1'b0;
    mem_resp = 1'b0;
    pmem_read = 1'b0;
    pmem_write = 1'b0;
    write1_select = 2'b00;
    write2_select = 2'b00;
    bus_select1 = 1'b0;
    bus_select2 = 1'b0;
    cache_out_select = 1'b0;
    dirty_write = 2'b00;
endfunction

always_comb
begin : state_actions
    /* Default output assignments */
    set_defaults();
    /* Actions for each state */
    case (state)
        // The first state necessary to wait for read/write request from the CPU.
        idle: ;
        // The second state necessary to check if the requested read/write is a hit or miss.
        decode:
        begin
            if (hit0 & rd_or_wr) begin
                if (cpu_load) begin
                    tag1_ld = 1'b1;
                    dirty1_ld = 1'b1;
                    dirty1_in = 1'b1;
                    write1_select = 2'b11;
                end
                else begin
                    write1_select = 2'b00;    
                end
                mem_resp = 1'b1;
                lru_in = 1'b1;
                lru_ld = 1'b1;
                bus_select1 = 1'b1;
                cache_out_select = 1'b0;
            end
            if (hit1 & rd_or_wr) begin
                if (cpu_load) begin
                    tag2_ld = 1'b1;
                    dirty2_ld = 1'b1;
                    dirty2_in = 1'b1;
                    write2_select = 2'b11;
                end
                else begin
                    write2_select = 2'b00;
                end
                mem_resp = 1'b1;
                lru_in = 1'b0;
                lru_ld = 1'b1;
                bus_select2 = 1'b1;
                cache_out_select = 1'b1;
            end      
        end      
        allocate:
        begin
            pmem_read = 1'b1;
            if (lru_out == 0) begin
                bus_select1 = 1'b0;
                valid1_in = 1'b1;
                valid1_ld = 1'b1;
                dirty1_in = 1'b0;
                dirty1_ld = 1'b1;
                tag1_ld = 1'b1;
                write1_select = 2'b01;
            end
            else begin
                bus_select2 = 1'b0;
                valid2_in = 1'b1;
                valid2_ld = 1'b1;
                dirty2_in = 1'b0;
                dirty2_ld = 1'b1;
                tag2_ld = 1'b1;    
                write2_select = 2'b01;            
            end
        end
        write_back:
        begin
            pmem_write = 1'b1;
            cache_out_select = lru_in;
            if (lru_out == 1'b0) begin
                cache_out_select = 1'b0;
                dirty_write = 2'b01;
                bus_select1 = 1'b0;
            end
            else begin
                cache_out_select = 1'b1;
                dirty_write = 2'b11;
                bus_select2 = 1'b0;
            end
        end
    endcase
end

always_comb
begin : next_state_logic
    unique case (state)
        idle: begin
            if (rd_or_wr) begin
                next_states = decode;
            end
            else next_states = idle;
        end
        decode: begin
            if(!hit0 && !hit1) begin
                if(dirty)
                    next_states = write_back;
                else
                    next_states = allocate;
            end
            else next_states = idle;
        end
        allocate: begin
            if(pmem_resp == 1)
                next_states = idle;
            else next_states = allocate;
        end
        write_back: 
        begin
            if(pmem_resp == 1)
                next_states = allocate;
            else next_states = write_back;
        end
        default: next_states = idle;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    if (rst)
        state <= decode;
    else
        state <= next_states;
end
endmodule : cache_control
