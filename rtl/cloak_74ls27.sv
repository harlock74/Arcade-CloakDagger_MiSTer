module cloak_74ls27 (
    input  wire [2:0] a,
    input  wire [2:0] b,
    input  wire [2:0] c,
    output wire [2:0] y
);

assign y = ~(a | b | c);

endmodule
