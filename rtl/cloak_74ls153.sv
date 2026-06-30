module cloak_74ls153 (
    input  wire [1:0] sel,
    input  wire       enable1_n,
    input  wire       enable2_n,
    input  wire [3:0] c1,
    input  wire [3:0] c2,
    output wire       y1,
    output wire       y2
);

assign y1 = enable1_n ? 1'b0 : c1[sel];
assign y2 = enable2_n ? 1'b0 : c2[sel];

endmodule
