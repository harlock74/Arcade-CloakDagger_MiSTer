module cloak_tdp_ram #(
    parameter AW = 8,
    parameter DW = 8
) (
    input                clk,
    input      [AW-1:0]  a_addr,
    input      [DW-1:0]  a_din,
    input                a_we,
    output     [DW-1:0]  a_dout,
    input      [AW-1:0]  b_addr,
    input      [DW-1:0]  b_din,
    input                b_we,
    output     [DW-1:0]  b_dout
);

`ifndef SIMULATION
altsyncram ram (
    .clock0(clk),
    .clock1(clk),
    .address_a(a_addr),
    .address_b(b_addr),
    .data_a(a_din),
    .data_b(b_din),
    .wren_a(a_we),
    .wren_b(b_we),
    .rden_a(1'b1),
    .rden_b(1'b1),
    .q_a(a_dout),
    .q_b(b_dout),
    .aclr0(1'b0),
    .aclr1(1'b0),
    .addressstall_a(1'b0),
    .addressstall_b(1'b0),
    .byteena_a(1'b1),
    .byteena_b(1'b1),
    .clocken0(1'b1),
    .clocken1(1'b1),
    .clocken2(1'b1),
    .clocken3(1'b1),
    .eccstatus()
);

defparam
    ram.intended_device_family = "Cyclone V",
    ram.lpm_type = "altsyncram",
    ram.operation_mode = "BIDIR_DUAL_PORT",
    ram.numwords_a = 1 << AW,
    ram.numwords_b = 1 << AW,
    ram.widthad_a = AW,
    ram.widthad_b = AW,
    ram.width_a = DW,
    ram.width_b = DW,
    ram.width_byteena_a = 1,
    ram.width_byteena_b = 1,
    ram.address_reg_b = "CLOCK1",
    ram.outdata_reg_a = "UNREGISTERED",
    ram.outdata_reg_b = "UNREGISTERED",
    ram.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
    ram.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ",
    ram.power_up_uninitialized = "FALSE";
`else
reg [DW-1:0] mem [0:(1<<AW)-1];
reg [DW-1:0] a_q;
reg [DW-1:0] b_q;

always_ff @(posedge clk) begin
    if (a_we) mem[a_addr] <= a_din;
    if (b_we) mem[b_addr] <= b_din;
    a_q <= mem[a_addr];
    b_q <= mem[b_addr];
end

assign a_dout = a_q;
assign b_dout = b_q;
`endif

endmodule
