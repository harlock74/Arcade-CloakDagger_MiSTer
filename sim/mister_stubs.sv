module pll (
    input refclk,
    input rst,
    output outclk_0
);
assign outclk_0 = refclk;
wire _unused = rst;
endmodule

module hps_io #(
    parameter CONF_STR = "",
    parameter CONF_STR_BRAM = 0
) (
    input clk_sys,
    inout [48:0] HPS_BUS,
    output EXT_BUS,
    output gamma_bus,
    output forced_scandoubler,
    output [1:0] buttons,
    output [127:0] status,
    input status_menumask,
    output [10:0] ps2_key,
    output [15:0] joystick_0,
    output [15:0] joystick_1,
    output ioctl_download,
    output ioctl_wr,
    output [24:0] ioctl_addr,
    output [7:0] ioctl_dout,
    output [7:0] ioctl_index
);

assign HPS_BUS = 'z;
assign {EXT_BUS, gamma_bus, forced_scandoubler} = 0;
assign buttons = 0;
assign status = 0;
assign ps2_key = 0;
assign joystick_0 = 0;
assign joystick_1 = 0;
assign ioctl_download = 0;
assign ioctl_wr = 0;
assign ioctl_addr = 0;
assign ioctl_dout = 0;
assign ioctl_index = 0;

wire _unused = &{1'b0, clk_sys, status_menumask, CONF_STR[0], CONF_STR_BRAM};

endmodule
