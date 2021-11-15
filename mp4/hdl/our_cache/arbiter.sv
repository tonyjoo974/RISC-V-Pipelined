import rv32i_types::*;

module arbiter
(
    input clk,
    input rst,
    
    input rv32i_word ipmem_address,
    input logic ipmem_read,
    output logic [255:0] ipmem_rdata,
    output logic ipmem_resp,
    
    input rv32i_word dpmem_address,
    input logic [255:0] dpmem_wdata, 
    input logic dpmem_read,
    input logic dpmem_write,
    output logic [255:0] dpmem_rdata,
    output logic dpmem_resp,

    output rv32i_word pmem_address,
    input logic [255:0] pmem_rdata,
    output logic [255:0] pmem_wdata,
    output logic pmem_read,
    output logic pmem_write, 
    input logic pmem_resp
);

enum int unsigned {
    /* List of states */
    idle,
    instruction,
    data
} state, next_states;

always_comb
begin : state_actions
    /* Default assignments */
    ipmem_rdata = pmem_rdata;
    dpmem_rdata = pmem_rdata;
    pmem_wdata = dpmem_wdata;
    
    /* Actions for each state */
    case (state)
        idle: 
        begin
            pmem_read = 1'b0;
            pmem_write = 1'b0;
            pmem_address = 32'd0;
            ipmem_resp = 1'b0;
            dpmem_resp = 1'b0;
        end
        instruction:
        begin
            pmem_read = ipmem_read;
            pmem_write = 1'b0;
            pmem_address = ipmem_address;
            ipmem_resp = pmem_resp;
            dpmem_resp = 1'b0;
            
        end      
        data:
        begin
            pmem_read = dpmem_read;
            pmem_write = dpmem_write;
            pmem_address = dpmem_address;
            ipmem_resp = 1'b0;
            dpmem_resp = pmem_resp;
        end

    endcase
end

always_comb
begin : next_state_logic
    next_states = state;
    unique case (state)
        idle: begin
            if (ipmem_read) next_states = instruction;
            else if (dpmem_read || dpmem_write) next_states = data;
        end
        instruction: begin
            if (pmem_resp) begin
                if ((dpmem_read || dpmem_write) && !(ipmem_read))
                    next_states = data;
                else
                    next_states = idle;
            end
        end
        data: begin
            if (pmem_resp) begin
                if ((ipmem_read) && (!(dpmem_read) && !(dpmem_write)))
                    next_states = instruction;
                else
                    next_states = idle;
            end
        end
        default: next_states = idle;
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
    if (rst)
        state <= idle;
    else
        state <= next_states;
end




endmodule : arbiter