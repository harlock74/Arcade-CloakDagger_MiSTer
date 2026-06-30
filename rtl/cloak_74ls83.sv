module cloak_74ls83 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       c0,
    output wire [3:0] sum,
    output wire       c4
);

wire [4:0] result = {1'b0, a} + {1'b0, b} + {4'd0, c0};

assign sum = result[3:0];
assign c4 = result[4];

endmodule
