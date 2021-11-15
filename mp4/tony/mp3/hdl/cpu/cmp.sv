import rv32i_types::*;

module cmp
(
    input branch_funct3_t cmpop,
    input rv32i_word a,
    input rv32i_word b,
    output logic out
);

always_comb
begin
    unique case (cmpop)
        beq:  out = (a == b);
        bne:  out = (a != b);
        blt:  out = ($signed(a) < $signed(b));
        bge:  out = ($signed(a) >= $signed(b));
        bltu:  out = (a < b);
        bgeu:  out = (a >= b);
    endcase
end

endmodule : cmp
