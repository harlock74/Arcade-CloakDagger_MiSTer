module cloak_74ls244 (
    input  wire       enable1_n,
    input  wire       enable2_n,
    input  wire [7:0] a,
    output wire [7:0] y
);

assign y[3:0] = enable1_n ? 4'hF : a[3:0];
assign y[7:4] = enable2_n ? 4'hF : a[7:4];

endmodule
