module pokey_compat (
    input             clk,
    input             reset,
    input             ce_1m25,
    input             cs,
    input             we,
    input       [3:0] addr,
    input       [7:0] din,
    input       [7:0] allpot,
    output      [7:0] dout,
    output     [15:0] audio
);

`ifndef SIMULATION
wire [7:0] pokey_dout;
wire [3:0] channel0;
wire [3:0] channel1;
wire [3:0] channel2;
wire [3:0] channel3;
wire [5:0] channel_sum =
    {2'd0, channel0} + {2'd0, channel1} +
    {2'd0, channel2} + {2'd0, channel3};

pokey #(.CUSTOM_KEYBOARD_SCAN(2)) pokey_core (
    .CLK(clk),
    .ENABLE_179(ce_1m25),
    .ADDR(addr),
    .DATA_IN(din),
    .WR_EN(cs && we),
    .RESET_N(!reset),
    .keyboard_scan_enable(1'b0),
    .keyboard_scan(),
    .keyboard_scan_update(),
    .keyboard_response(2'b11),
    .POT_IN(8'hFF),
    .SIO_IN1(1'b1),
    .DATA_OUT(pokey_dout),
    .CHANNEL_0_OUT(channel0),
    .CHANNEL_1_OUT(channel1),
    .CHANNEL_2_OUT(channel2),
    .CHANNEL_3_OUT(channel3),
    .IRQ_N_OUT(),
    .SIO_OUT1(),
    .SIO_OUT2(),
    .SIO_OUT3(),
    .SIO_CLOCKIN_IN(1'b1),
    .SIO_CLOCKIN_OUT(),
    .SIO_CLOCKIN_OE(),
    .SIO_CLOCKOUT(),
    .POT_RESET()
);

// Arcade boards connect switches directly to ALLPOT rather than RC paddles.
assign dout = (addr == 4'h8) ? allpot : pokey_dout;
assign audio = {channel_sum, 10'd0};
`else
reg [7:0] audf[0:3];
reg [7:0] audc[0:3];
reg [7:0] count[0:3];
reg [3:0] tone;
integer i;
wire [5:0] sim_sum =
    (tone[0] ? {2'd0, audc[0][3:0]} : 6'd0) +
    (tone[1] ? {2'd0, audc[1][3:0]} : 6'd0) +
    (tone[2] ? {2'd0, audc[2][3:0]} : 6'd0) +
    (tone[3] ? {2'd0, audc[3][3:0]} : 6'd0);

always_ff @(posedge clk) begin
    if (reset) begin
        tone <= 0;
        for (i = 0; i < 4; i = i + 1) begin
            audf[i] <= 0;
            audc[i] <= 0;
            count[i] <= 0;
        end
    end else begin
        if (cs && we && addr < 8) begin
            if (!addr[0]) audf[addr[2:1]] <= din;
            else audc[addr[2:1]] <= din;
        end
        if (ce_1m25) begin
            for (i = 0; i < 4; i = i + 1) begin
                if (count[i] == 0) begin
                    count[i] <= audf[i];
                    tone[i] <= ~tone[i];
                end else count[i] <= count[i] - 1'd1;
            end
        end
    end
end

assign dout = (addr == 4'h8) ? allpot : 8'hFF;
assign audio = {sim_sum, 10'd0};
`endif

endmodule
