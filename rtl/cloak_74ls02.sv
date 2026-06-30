module cloak_74ls02 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [3:0] y
);

assign y = ~(a | b);

endmodule
