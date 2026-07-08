module cloak_core_tb;

reg clk = 0;
reg reset = 1;
always #10 clk = ~clk;

cloak_core dut (
    .clk(clk),
    .reset(reset),
    .joystick_0(16'd0),
    .joystick_1(16'd0),
    .coin(1'b0),
    .service(1'b0),
    .start1(1'b0),
    .start2(1'b0),
    .test(1'b0),
    .dips(8'd0),
    .ioctl_addr(25'd0),
    .ioctl_data(8'd0),
    .ioctl_wr(1'b0),
    .ioctl_index(8'd0),
    .ce_pix(),
    .hsync(),
    .vsync(),
    .hblank(),
    .vblank(),
    .red(),
    .green(),
    .blue(),
    .audio()
);

initial begin
    repeat (10) @(posedge clk);
    reset <= 0;
    repeat (2000) @(posedge clk);
    $finish;
end

endmodule
