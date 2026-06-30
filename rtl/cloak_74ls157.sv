module cloak_74ls157 (
    input  wire       sel,
    input  wire       enable_n,
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [3:0] y
);

assign y = enable_n ? 4'h0 : (sel ? b : a);

endmodule
