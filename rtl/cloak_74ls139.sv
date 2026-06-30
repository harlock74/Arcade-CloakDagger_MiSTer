module cloak_74ls139 (
    input  wire       enable_n,
    input  wire [1:0] sel,
    output wire [3:0] y_n
);

assign y_n = enable_n ? 4'hF : ~(4'b0001 << sel);

endmodule
