module cloak_74ls74 (
    input  wire clk,
    input  wire reset,
    input  wire preset_n,
    input  wire clear_n,
    input  wire clk_en,
    input  wire d,
    output wire q,
    output wire q_n
);

reg q_reg;

assign q = q_reg;
assign q_n = ~q_reg;

always_ff @(posedge clk) begin
    if (reset || !clear_n) begin
        q_reg <= 1'b0;
    end else if (!preset_n) begin
        q_reg <= 1'b1;
    end else if (clk_en) begin
        q_reg <= d;
    end
end

endmodule
