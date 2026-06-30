module cloak_93422 (
    input  wire       clk,
    input  wire [7:0] write_addr,
    input  wire [7:0] read_addr,
    input  wire [3:0] data_in,
    input  wire       we_n,
    input  wire       cs1_n,
    input  wire       cs2_n,
    input  wire       oe_n,
    output wire [3:0] data_out
);

reg [3:0] mem [0:255];
reg [3:0] data_q;

wire selected = !cs1_n && !cs2_n;

assign data_out = (selected && !oe_n) ? data_q : 4'hF;

always_ff @(posedge clk) begin
    if (selected && !we_n) begin
        mem[write_addr] <= data_in;
    end
    data_q <= mem[read_addr];
end

endmodule
