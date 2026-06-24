module pokey_tb;
reg clk = 0;
reg reset = 1;
reg ce = 0;
reg cs = 0;
reg we = 0;
reg [3:0] addr = 0;
reg [7:0] din = 0;
wire [7:0] dout;
wire signed [15:0] audio;
integer cycles;
integer changes;
reg signed [15:0] previous;

always #5 clk = ~clk;

pokey_compat dut (
    .clk(clk), .reset(reset), .ce_1m25(ce), .cs(cs), .we(we),
    .addr(addr), .din(din), .allpot(8'hFF), .dout(dout), .audio(audio)
);

task write_reg(input [3:0] reg_addr, input [7:0] value);
begin
    @(negedge clk);
    cs = 1;
    we = 1;
    addr = reg_addr;
    din = value;
    @(negedge clk);
    cs = 0;
    we = 0;
end
endtask

initial begin
    repeat (4) @(negedge clk);
    reset = 0;

    write_reg(4'h0, 8'd1);
    write_reg(4'h1, 8'hAF);
    write_reg(4'h9, 8'd0);

    previous = audio;
    changes = 0;
    for (cycles = 0; cycles < 300; cycles = cycles + 1) begin
        @(negedge clk);
        ce = 1;
        @(negedge clk);
        ce = 0;
        if (audio != previous) changes = changes + 1;
        previous = audio;
    end

    if (changes == 0) $fatal(1, "POKEY produced no changing audio");
    $display("POKEY audio test passed with %0d transitions", changes);
    $finish;
end
endmodule
