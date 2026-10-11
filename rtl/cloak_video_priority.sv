// Cloak & Dagger Master PCB Sheet 4B video-priority and colour-address path.
//
// This is a functional reconstruction of the confirmed 9K/8C/1L/8D/8E
// priority gates, the 10H/10J 74LS153 selectors, and the used 11J 74LS157
// channels.  The upstream playfield, bitmap and motion renderers remain
// independent of this boundary.
module cloak_video_priority (
    input  logic [3:0] pbit,
    input  logic [2:0] bmap,
    input  logic [3:0] mbit,
    input  logic       bitmap_half,
    input  logic [5:0] paba,
    input  logic       colram_n,
    output logic [1:0] colsel,
    output logic [5:0] cola
);

// 9K pin 5 is high when all four motion bits are zero.  The confirmed fan-out
// reaches both 8E pin 1 and inverter 8C pin 3.
logic motion_zero_9k;
logic motion_present_8c;
logic bitmap_zero_1l;
logic priority_term_8d;

assign motion_zero_9k    = ~(mbit[3] | mbit[2] | mbit[1] | mbit[0]);
assign motion_present_8c = ~motion_zero_9k;
assign bitmap_zero_1l    = ~(bmap[2] | bmap[1] | bmap[0]);
assign priority_term_8d  = motion_present_8c | bitmap_zero_1l;

// 8E produces the two selector levels.  The confirmed LS153 assignment is
// pin 14=COLSEL0 and pin 2=COLSEL1, so {COLSEL1,COLSEL0} is C0..C3.
assign colsel[1] = ~(motion_zero_9k   & colram_n);
assign colsel[0] = ~(priority_term_8d & colram_n);

// 10H/10J select C0=playfield, C1=bitmap, C2=motion, C3=CPU.
wire [3:0] selected_low =
    (colsel == 2'b00) ? pbit :
    (colsel == 2'b01) ? {bitmap_half, bmap} :
    (colsel == 2'b10) ? mbit : paba[3:0];

// 11J switches the two upper colour-RAM address bits between the CPU address
// and the video selector levels.  Its select input is the low-true /COLRAM.
assign cola = !colram_n ? paba : {colsel, selected_low};

endmodule
