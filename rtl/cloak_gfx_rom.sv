module cloak_gfx_rom #(
    parameter AW = 13
) (
    input                 clk,
    input      [AW-1:0]   download_addr,
    input       [7:0]     download_data,
    input                 download_we,
    input      [AW-1:0]   video_addr,
    output      [7:0]     video_data
);

`ifndef SIMULATION
wire [7:0] unused_download_q;

altsyncram rom (
    .clock0(clk),
    .clock1(clk),
    .address_a(download_addr),
    .address_b(video_addr),
    .data_a(download_data),
    .data_b(8'd0),
    .wren_a(download_we),
    .wren_b(1'b0),
    .rden_a(1'b1),
    .rden_b(1'b1),
    .q_a(unused_download_q),
    .q_b(video_data),
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
    rom.intended_device_family = "Cyclone V",
    rom.lpm_type = "altsyncram",
    rom.operation_mode = "BIDIR_DUAL_PORT",
    rom.numwords_a = 1 << AW,
    rom.numwords_b = 1 << AW,
    rom.widthad_a = AW,
    rom.widthad_b = AW,
    rom.width_a = 8,
    rom.width_b = 8,
    rom.width_byteena_a = 1,
    rom.width_byteena_b = 1,
    rom.address_reg_b = "CLOCK1",
    rom.outdata_reg_a = "UNREGISTERED",
    rom.outdata_reg_b = "UNREGISTERED",
    rom.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
    rom.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ",
    rom.power_up_uninitialized = "FALSE";
`else
reg [7:0] mem [0:(1<<AW)-1];
reg [7:0] video_q;

always_ff @(posedge clk) begin
    if (download_we) mem[download_addr] <= download_data;
    video_q <= mem[video_addr];
end

assign video_data = video_q;
`endif

endmodule
