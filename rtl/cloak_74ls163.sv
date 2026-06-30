module cloak_74ls163 (
    input  wire       clk,
    input  wire       reset,
    input  wire       clk_en,
    input  wire       clear_n,
    input  wire       load_n,
    input  wire       enp,
    input  wire       ent,
    input  wire [3:0] d,
    output wire [3:0] q,
    output wire       ripple
);

reg [3:0] q_reg;

wire count_en = enp && ent;

assign q = q_reg;
assign ripple = count_en && (q_reg == 4'hF);

always_ff @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'd0;
    end else if (clk_en) begin
        if (!clear_n) begin
            q_reg <= 4'd0;
        end else if (!load_n) begin
            q_reg <= d;
        end else if (count_en) begin
            q_reg <= q_reg + 1'd1;
        end
    end
end

endmodule
