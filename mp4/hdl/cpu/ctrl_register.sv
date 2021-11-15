import rv32i_types::*;

module ctrl_register
(
    input clk,
    input rst,
    input load,
    input rv32i_control_word in,
    output rv32i_control_word out
);

rv32i_control_word data = 1'b0;

always_ff @(posedge clk)
begin
    if (rst)
    begin
        data <= '0;
    end
    else if (load)
    begin
        data <= in;
    end
    else
    begin
        data <= data;
    end
end

always_comb
begin
    out = data;
end

endmodule : ctrl_register