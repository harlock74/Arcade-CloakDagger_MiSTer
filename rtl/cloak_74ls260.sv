module cloak_74ls260 (
    input  wire [1:0] a,
    input  wire [1:0] b,
    input  wire [1:0] c,
    input  wire [1:0] d,
    input  wire [1:0] e,
    output wire [1:0] y
);

assign y = ~(a | b | c | d | e);

endmodule
