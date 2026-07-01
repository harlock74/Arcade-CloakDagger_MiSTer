module motion_buffer_tb;

reg clk = 1'b0;
reg reset = 1'b1;
always #10 clk = ~clk;

reg [7:0] write_addr_left;
reg [7:0] write_addr_right;
reg [7:0] read_addr;
reg [3:0] data_left;
reg [3:0] data_right;
reg we_n;
reg latch_en;
reg vdbh;

wire [3:0] lb0_from_8j;
wire [3:0] lb1_from_8l;
wire [7:0] lb_from_9t;
wire [3:0] lb0_from_9t = lb_from_9t[3:0];
wire [3:0] lb1_from_9t = lb_from_9t[7:4];
wire [3:0] mbit_from_9h;

integer failures;

cloak_93422 u_8j_motion_buffer_left_ram (
    .clk       (clk),
    .write_addr(write_addr_left),
    .read_addr (read_addr),
    .data_in   (data_left),
    .we_n      (we_n),
    .cs1_n     (1'b0),
    .cs2_n     (1'b0),
    .oe_n      (1'b0),
    .data_out  (lb0_from_8j)
);

cloak_93422 u_8l_motion_buffer_right_ram (
    .clk       (clk),
    .write_addr(write_addr_right),
    .read_addr (read_addr),
    .data_in   (data_right),
    .we_n      (we_n),
    .cs1_n     (1'b0),
    .cs2_n     (1'b0),
    .oe_n      (1'b0),
    .data_out  (lb1_from_8l)
);

cloak_74ls273 u_9t_line_buffer_latch (
    .clk    (clk),
    .reset  (reset),
    .clk_en (latch_en),
    .d      ({lb1_from_8l, lb0_from_8j}),
    .q      (lb_from_9t)
);

cloak_74ls157 u_9h_mbit_select (
    .sel      (vdbh),
    .enable_n (1'b0),
    .a        (lb0_from_9t),
    .b        (lb1_from_9t),
    .y        (mbit_from_9h)
);

task automatic check_mbit;
    input [3:0] expected;
    input [80*8-1:0] label;
    begin
        if (mbit_from_9h !== expected) begin
            $display("FAIL %0s expected=%h actual=%h", label, expected, mbit_from_9h);
            failures = failures + 1;
        end
    end
endtask

task automatic write_pair;
    input [7:0] addr;
    input [3:0] left_value;
    input [3:0] right_value;
    begin
        @(negedge clk);
        write_addr_left = addr;
        write_addr_right = addr;
        data_left = left_value;
        data_right = right_value;
        we_n = 1'b0;
        @(posedge clk);
        #1;
        we_n = 1'b1;
    end
endtask

task automatic read_latch_pair;
    input [7:0] addr;
    begin
        @(negedge clk);
        read_addr = addr;
        latch_en = 1'b0;
        @(posedge clk);
        #1;
        @(negedge clk);
        latch_en = 1'b1;
        @(posedge clk);
        #1;
        latch_en = 1'b0;
    end
endtask

task automatic write_and_latch_pair_same_edge;
    input [7:0] addr;
    input [3:0] left_value;
    input [3:0] right_value;
    begin
        @(negedge clk);
        write_addr_left = addr;
        write_addr_right = addr;
        read_addr = addr;
        data_left = left_value;
        data_right = right_value;
        we_n = 1'b0;
        latch_en = 1'b1;
        @(posedge clk);
        #1;
        we_n = 1'b1;
        latch_en = 1'b0;
    end
endtask

initial begin
    failures = 0;
    write_addr_left = 8'd0;
    write_addr_right = 8'd0;
    read_addr = 8'd0;
    data_left = 4'd0;
    data_right = 4'd0;
    we_n = 1'b1;
    latch_en = 1'b0;
    vdbh = 1'b0;

    repeat (2) @(posedge clk);
    #1;
    reset = 1'b0;

    write_pair(8'h22, 4'ha, 4'h5);
    write_pair(8'h23, 4'h3, 4'hc);

    read_latch_pair(8'h22);
    vdbh = 1'b0;
    #1 check_mbit(4'ha, "addr22 left via 9H");
    vdbh = 1'b1;
    #1 check_mbit(4'h5, "addr22 right via 9H");

    @(negedge clk);
    read_addr = 8'h23;
    @(posedge clk);
    #1;
    vdbh = 1'b0;
    #1 check_mbit(4'ha, "9T holds addr22 left before next latch");
    vdbh = 1'b1;
    #1 check_mbit(4'h5, "9T holds addr22 right before next latch");

    read_latch_pair(8'h23);
    vdbh = 1'b0;
    #1 check_mbit(4'h3, "addr23 left via 9H");
    vdbh = 1'b1;
    #1 check_mbit(4'hc, "addr23 right via 9H");

    write_pair(8'h24, 4'h2, 4'h4);
    read_latch_pair(8'h24);
    vdbh = 1'b0;
    #1 check_mbit(4'h2, "addr24 initial left via 9H");
    vdbh = 1'b1;
    #1 check_mbit(4'h4, "addr24 initial right via 9H");

    write_and_latch_pair_same_edge(8'h24, 4'he, 4'h1);
    vdbh = 1'b0;
    #1 check_mbit(4'h2, "same-edge write/latch keeps old left");
    vdbh = 1'b1;
    #1 check_mbit(4'h4, "same-edge write/latch keeps old right");

    read_latch_pair(8'h24);
    vdbh = 1'b0;
    #1 check_mbit(4'he, "addr24 updated left after later latch");
    vdbh = 1'b1;
    #1 check_mbit(4'h1, "addr24 updated right after later latch");

    if (failures == 0)
        $display("Motion buffer harness compare passed");
    else
        $display("Motion buffer harness compare failures=%0d", failures);

    $finish;
end

endmodule
