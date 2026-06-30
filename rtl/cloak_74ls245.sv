module cloak_74ls245 (
    input  wire       dir,
    input  wire       enable_n,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] a_out,
    output wire [7:0] b_out
);

assign a_out = (!enable_n && !dir) ? b : 8'hFF;
assign b_out = (!enable_n &&  dir) ? a : 8'hFF;

endmodule
