// Simulation-only interface stub. Quartus uses rtl/t65/T65.vhd.
module T65 (
    input [1:0] Mode,
    input BCD_en,
    input Res_n,
    input Enable,
    input Clk,
    input Rdy,
    input Abort_n,
    input IRQ_n,
    input NMI_n,
    input SO_n,
    output R_W_n,
    output Sync,
    output EF,
    output MF,
    output XF,
    output ML_n,
    output VP_n,
    output VDA,
    output VPA,
    output [23:0] A,
    input [7:0] DI,
    output [7:0] DO,
    output [63:0] Regs,
    output DEBUG,
    output NMI_ack
);

assign R_W_n = 1'b1;
assign {Sync, EF, MF, XF, ML_n, VP_n, VDA, VPA, NMI_ack} = 9'b0;
assign A = 24'b0;
assign DO = 8'b0;
assign Regs = 64'b0;
assign DEBUG = 1'b0;

wire _unused = &{1'b0, Mode, BCD_en, Res_n, Enable, Clk, Rdy, Abort_n,
                 IRQ_n, NMI_n, SO_n, DI};

endmodule
