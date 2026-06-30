module cloak_74ls273 (
    input  wire       clk,
    input  wire       reset,
    input  wire       clk_en,
    input  wire [7:0] d,
    output wire [7:0] q
);

reg [7:0] q_reg;

assign q = q_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        q_reg <= 8'd0;
    end else if (clk_en) begin
        q_reg <= d;
    end
end

endmodule
