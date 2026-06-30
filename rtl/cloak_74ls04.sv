module cloak_74ls04 (
    input  wire [5:0] a,
    output wire [5:0] y
);

assign y = ~a;

endmodule
