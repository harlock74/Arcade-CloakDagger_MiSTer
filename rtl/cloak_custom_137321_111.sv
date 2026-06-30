module cloak_custom_137321_111 (
    input  wire [7:0] pabd,
    input  wire       customwr_n,
    input  wire [7:0] cus_fallback,
    input  wire       bvblank_fallback,
    input  wire       b256h_fallback,
    output wire [7:0] cus,
    output wire       bvblank,
    output wire       b256h
);

// Atari custom 137321-111 is not internally documented in the schematic. This
// boundary preserves the visible package pins while downstream timing remains
// driven by the current counter-derived fallback nets.
assign cus = cus_fallback;
assign bvblank = bvblank_fallback;
assign b256h = b256h_fallback;

wire _unused = &{1'b0, pabd, customwr_n};

endmodule
