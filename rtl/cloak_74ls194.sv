module cloak_74ls194 (
    input  wire       clk,
    input  wire       reset,
    input  wire       clear_n,
    input  wire       clk_en,
    input  wire [1:0] mode,
    input  wire       sr,
    input  wire       sl,
    input  wire [3:0] d,
    output wire [3:0] q
);

reg [3:0] q_reg;

assign q = q_reg;

always_ff @(posedge clk) begin
    if (reset || !clear_n) begin
        q_reg <= 4'd0;
    end else if (clk_en) begin
        case (mode)
            2'b01: q_reg <= {sr, q_reg[3:1]};
            2'b10: q_reg <= {q_reg[2:0], sl};
            2'b11: q_reg <= d;
            default: q_reg <= q_reg;
        endcase
    end
end

endmodule
