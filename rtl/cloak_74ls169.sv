module cloak_74ls169 (
    input        clk,
    input        clk_en,
    input        reset,
    input        load_n,
    input        enp_n,
    input        ent_n,
    input        up,
    input  [3:0] d,
    output [3:0] q,
    output       tc
);

reg [3:0] q_reg;

wire count_en = !enp_n && !ent_n;
wire terminal_match = up ? (q_reg == 4'hF) : (q_reg == 4'h0);

assign q = q_reg;
assign tc = !(count_en && terminal_match);

always_ff @(posedge clk) begin
    if (reset)
        q_reg <= 4'd0;
    else if (clk_en) begin
        if (!load_n)
            q_reg <= d;
        else if (count_en)
            q_reg <= up ? q_reg + 1'd1 : q_reg - 1'd1;
    end
end

endmodule
