module cloak_74ls174 (
    input  wire       clk,
    input  wire       reset,
    input  wire       clear_n,
    input  wire       clk_en,
    input  wire [5:0] d,
    output wire [5:0] q
);

reg [5:0] q_reg;

assign q = q_reg;

always_ff @(posedge clk) begin
    if (reset || !clear_n) begin
        q_reg <= 6'd0;
    end else if (clk_en) begin
        q_reg <= d;
    end
end

endmodule
