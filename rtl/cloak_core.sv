module cloak_core (
    input             clk,
    input             reset,
    input      [15:0] joystick_0,
    input      [15:0] joystick_1,
    input             fire1,
    input             fire2,
    input             coin_r,
    input             coin_l,
    input             coin_aux,
    input             cocktail,
    input             start1,
    input             start2,
    input             self_test,
    input       [7:0] dips,

    input      [24:0] ioctl_addr,
    input       [7:0] ioctl_data,
    input             ioctl_wr,
    input       [7:0] ioctl_index,

    output            ce_pix,
    output            hsync,
    output            vsync,
    output            hblank,
    output            vblank,
    output      [7:0] red,
    output      [7:0] green,
    output      [7:0] blue,
    output     [15:0] audio
);

// -------------------------------------------------------------------------
// Clock enables derived from the schematic's 10 MHz timing domain.
// The template PLL supplies 20 MHz, so all enables are exact integer divides.
// -------------------------------------------------------------------------

reg [4:0] div20;
reg [4:0] div16;
reg [2:0] div4;

wire ce_main  = (div20 == 5'd19); // 20 MHz / 20 = 1.000 MHz
wire ce_slave = (div16 == 5'd15); // 20 MHz / 16 = 1.250 MHz
wire ce_5m    = (div4 == 3'd3);   // 20 MHz / 4  = 5 MHz
wire ce_pokey = ce_slave;         // 10 MHz / 8 on the PCB

always_ff @(posedge clk) begin
    if (reset) begin
        div20 <= 5'd0;
        div16 <= 5'd0;
        div4 <= 3'd0;
    end else begin
        div20 <= ce_main  ? 5'd0 : div20 + 1'd1;
        div16 <= ce_slave ? 5'd0 : div16 + 1'd1;
        div4 <= ce_5m     ? 3'd0 : div4 + 1'd1;
    end
end

assign ce_pix = ce_5m;

// -------------------------------------------------------------------------
// Raster timing. The schematic uses a 5 MHz pixel chain and vertical PROM.
// 320 x 262 gives 59.64 Hz; the visible aperture matches MAME (256 x 232).
// -------------------------------------------------------------------------

reg [8:0] hcnt;
reg [8:0] vcnt;

always_ff @(posedge clk) begin
    if (reset) begin
        hcnt <= 9'd0;
        vcnt <= 9'd0;
    end else if (ce_5m) begin
        if (hcnt == 9'd319) begin
            hcnt <= 9'd0;
            vcnt <= (vcnt == 9'd261) ? 9'd0 : vcnt + 1'd1;
        end else hcnt <= hcnt + 1'd1;
    end
end

wire counter_hblank = hcnt >= 9'd256;
wire counter_vblank = (vcnt < 9'd24) || (vcnt >= 9'd256);
wire counter_hsync_n = ~((hcnt >= 9'd272) && (hcnt < 9'd304));
wire counter_vsync_n = ~((vcnt >= 9'd0) && (vcnt < 9'd3));
wire prom_frame_origin_vsync =
    (vcnt == 9'd259 && hcnt >= 9'd257) ||
    (vcnt == 9'd260) ||
    (vcnt == 9'd261 && hcnt <= 9'd318);
wire prom_frame_origin_vsync_n = ~prom_frame_origin_vsync;
wire prom_frame_origin_compsync = ~(prom_frame_origin_vsync ^ !counter_hsync_n);

// Active timing selectors. These currently preserve the stable behavioral
// timing; future schematic timing can be switched in one signal at a time.
wire active_hblank;
wire active_vblank;
wire active_hsync_n = counter_hsync_n;
wire active_vsync_n = counter_vsync_n;
wire active_hsync = !active_hsync_n;
wire active_vsync = !active_vsync_n;
wire [3:0] sync_4d_xor_y;
wire [5:0] sync_4b_inv_y;
wire [3:0] sync_4d_xor_4n_y;
wire [5:0] sync_4b_inv_4n_y;
wire compsync_from_4b = sync_4b_inv_y[0];
wire vsync_from_4b = sync_4b_inv_y[1];
wire compsync_from_4b_4n = sync_4b_inv_4n_y[0];
wire vsync_from_4b_4n = sync_4b_inv_4n_y[1];

// Sheet 7A 4D/4B sync output gates. These are observational until the upstream
// 4N/3N sync timing phase is verified against the fallback counters.
cloak_74ls86 u_4d_composite_sync_xor (
    .a ({3'b000, active_vsync}),
    .b ({3'b000, active_hsync}),
    .y (sync_4d_xor_y)
);

cloak_74ls04 u_4b_sync_output_inverters (
    .a ({4'b0000, active_vsync_n, sync_4d_xor_y[0]}),
    .y (sync_4b_inv_y)
);

assign hblank = active_hblank;
assign vblank = active_vblank;
assign hsync  = active_hsync_n;
assign vsync  = active_vsync_n;

// Sheet 3A/7A timing names. These are currently aliases of the behavioral
// counters; the custom sync PROM and XOR/inverter phase chain are still TODO.
wire b1h    = hcnt[0];
wire b2h    = hcnt[1];
wire b4h    = hcnt[2];
wire b8h    = hcnt[3];
wire b16h   = hcnt[4];
wire b32h   = hcnt[5];
wire b64h   = hcnt[6];
wire b128h  = hcnt[7];
wire counter_b256h = hcnt[8];
wire b256h;
wire b1v    = vcnt[0];
wire b2v    = vcnt[1];
wire b4v    = vcnt[2];
wire b8v    = vcnt[3];
wire b16v   = vcnt[4];
wire b32v   = vcnt[5];
wire b64v   = vcnt[6];
wire b128v  = vcnt[7];
wire bvblank;
wire bhblank = hblank;
wire bblank  = hblank || vblank;
wire b5m     = ce_5m;
wire bsm     = ce_5m;

// Sheet 7A sync-chain endpoint. The visible schematic drives HBLANK from the
// 3C latch area; the latch equation remains fallback until phase-verified.
wire hblank_from_3c = counter_hblank;
wire hblank_from_3c_latched;
wire hblank_n_from_3c_latched;
assign active_hblank = hblank_from_3c;

// Legal Verilog names for the schematic's starred horizontal aliases.
wire h4ss   = b4h;
wire h8ss   = b8h;
wire h16ss  = b16h;
wire h32ss  = b32h;
wire h64ss  = b64h;
wire h128ss = b128h;
wire sync_xor_common_from_6p = 1'b0;
wire [3:0] sync_6p_low_xor_y;
wire [3:0] sync_6p_high_xor_y;
wire [5:0] sync_10e_inv_y;
wire h4ss_from_10e_6p = sync_10e_inv_y[0];
wire h8ss_from_6p = sync_6p_low_xor_y[1];
wire h16ss_from_6p = sync_6p_low_xor_y[2];
wire h32ss_from_6p = sync_6p_low_xor_y[3];
wire h64ss_from_6p = sync_6p_high_xor_y[0];
wire h128ss_from_6p = sync_6p_high_xor_y[1];

// Sheet 3A 6P/adjacent LS86 gates generate starred horizontal aliases from a
// shared phase input. The active aliases above remain direct counter aliases
// until the custom timing/write block is traced.
cloak_74ls86 u_6p_sync_xor_low (
    .a ({b32h, b16h, b8h, b4h}),
    .b ({4{sync_xor_common_from_6p}}),
    .y (sync_6p_low_xor_y)
);

cloak_74ls86 u_6p_sync_xor_high (
    .a ({2'b00, b128h, b64h}),
    .b ({4{sync_xor_common_from_6p}}),
    .y (sync_6p_high_xor_y)
);

// Sheet 3A 10E inverts the 4H XOR output to produce 4H**.
cloak_74ls04 u_10e_sync_4h_inverter (
    .a ({5'b00000, sync_6p_low_xor_y[0]}),
    .y (sync_10e_inv_y)
);

// Sheet 6B/7A interconnect timing aliases crossing between boards.
wire e1h      = b1h;
wire e2h      = b2h;
wire e4h      = b4h;
wire e8h      = b8h;
wire e16h     = b16h;
wire e32h     = b32h;
wire e256h    = b256h;
wire evblank  = bvblank;
wire ehblank  = bhblank;

// -------------------------------------------------------------------------
// CPU buses
// -------------------------------------------------------------------------

wire [23:0] ma24;
wire [15:0] ma = ma24[15:0];
wire  [7:0] mdi;
wire  [7:0] mdo;
wire        mrw;

wire [23:0] sa24;
wire [15:0] sa = sa24[15:0];
wire  [7:0] sdi;
wire  [7:0] sdo;
wire        srw;

reg main_irq_n;
reg slave_irq_n;

wire m_main_ram_cs = ma < 16'h0400;
wire m_play_cs     = ma >= 16'h0400 && ma < 16'h0800;
wire m_shared_cs   = ma >= 16'h0800 && ma < 16'h1000;
wire m_pokey1_cs   = ma >= 16'h1000 && ma < 16'h1010;
wire m_pokey2_cs   = ma >= 16'h1800 && ma < 16'h1810;
wire m_nvram_cs    = ma >= 16'h2800 && ma < 16'h2A00;
wire m_motion_cs   = ma >= 16'h3000 && ma < 16'h3100;
wire m_palette_cs  = ma >= 16'h3200 && ma < 16'h3280;
wire m_rom_cs      = ma >= 16'h4000;

// Sheet 2A/10A decode names. These currently preserve the existing address
// behavior while making missing schematic strobes explicit.
wire pa_write            = ce_main && !mrw;
wire param               = m_play_cs;
wire pacmram             = m_shared_cs;
wire lfreq               = m_pokey1_cs;
wire hfreq               = m_pokey2_cs;
wire moram               = m_motion_cs;
wire colram              = m_palette_cs;
wire m_custom_write_cs   = ma == 16'h2600;
wire m_out_cs            = ma >= 16'h3800 && ma < 16'h3808;
wire m_watchdog_cs       = ma == 16'h3A00;
wire m_irq_reset_cs      = ma == 16'h3C00;
wire m_nvram_enable_cs   = ma == 16'h3E00;
wire m_coin_counter_r_cs = ma == 16'h3800;
wire m_coin_counter_l_cs = ma == 16'h3801;
wire m_cocktail_out_cs   = ma == 16'h3803;
wire m_start2_led_cs     = ma == 16'h3806;
wire m_start1_led_cs     = ma == 16'h3807;
wire customwr_n_from_decode = !(pa_write && m_custom_write_cs);
wire [7:0] custom_21m_cus_fallback = {
    b128v, b64v, b32v, b16v, b8v, b4v, b2v, b1v
};
wire [7:0] custom_21m_cus;
wire custom_21m_bvblank;
wire custom_21m_b256h;
wire bvblank_from_21m = custom_21m_bvblank;
wire b256h_from_21m = custom_21m_b256h;
wire bvblank_21m_matches_active = bvblank_from_21m == bvblank;
wire b256h_21m_matches_active = b256h_from_21m == b256h;
wire cusa_from_21m = custom_21m_cus[0];
wire cusb_from_21m = custom_21m_cus[1];
wire cusc_from_21m = custom_21m_cus[2];
wire cusd_from_21m = custom_21m_cus[3];
wire cuse_from_21m = custom_21m_cus[4];
wire cusf_from_21m = custom_21m_cus[5];
wire cusg_from_21m = custom_21m_cus[6];
wire cush_from_21m = custom_21m_cus[7];

// Sheet 3A 21/M Atari custom 137321-111 timing/write package. The package
// boundary is explicit, but its internal equations remain represented by the
// existing counter-derived fallback timing until documentation or measurement
// proves the exact custom behavior.
cloak_custom_137321_111 u_21m_custom_timing_write (
    .pabd             (mdo),
    .customwr_n       (customwr_n_from_decode),
    .cus_fallback     (custom_21m_cus_fallback),
    .bvblank_fallback (counter_vblank),
    .b256h_fallback   (counter_b256h),
    .cus              (custom_21m_cus),
    .bvblank          (custom_21m_bvblank),
    .b256h            (custom_21m_b256h)
);

assign bvblank = bvblank_from_21m;
assign b256h = b256h_from_21m;
assign active_vblank = bvblank;

wire s_local_cs = sa < 16'h0800;
wire s_shared_cs = sa >= 16'h0800 && sa < 16'h1000;
wire s_graph_cs = sa >= 16'h0008 && sa < 16'h0010;
wire s_rom_cs = sa >= 16'h2000;

// Sheet 6B/10B slave decode names, still backed by the existing broad decodes.
wire pb_write = ce_slave && !srw;
wire pbram = s_local_cs && !s_graph_cs;
wire pbcmram = s_shared_cs;
wire pbmem = s_local_cs || s_shared_cs || s_graph_cs || s_rom_cs;
wire pbirqres = sa == 16'h1000;
wire swap = sa == 16'h1200;
wire s_custom_write_cs = sa == 16'h1400;
// Sheet 6B 6H is a 74LS139 with active-low LDX/LDY outputs. Keep the
// schematic polarity visible, then derive positive convenience aliases.
wire ldx_decode_n = !(s_graph_cs && sa[2:0] == 3'h3);
wire ldy_decode_n = !(s_graph_cs && sa[2:0] == 3'h7);
wire ldx = !ldx_decode_n;
wire ldy = !ldy_decode_n;
wire drawren = s_graph_cs && !ldx && !ldy;

T65 main_cpu (
    .Mode(2'b00), .BCD_en(1'b1), .Res_n(~reset),
    .Enable(ce_main), .Clk(clk), .Rdy(1'b1), .Abort_n(1'b1),
    .IRQ_n(main_irq_n), .NMI_n(1'b1), .SO_n(1'b1),
    .R_W_n(mrw), .Sync(), .EF(), .MF(), .XF(), .ML_n(), .VP_n(),
    .VDA(), .VPA(), .A(ma24), .DI(mrw ? mdi : mdo), .DO(mdo),
    .Regs(), .DEBUG(), .NMI_ack()
);

T65 slave_cpu (
    .Mode(2'b00), .BCD_en(1'b1), .Res_n(~reset),
    .Enable(ce_slave), .Clk(clk), .Rdy(1'b1), .Abort_n(1'b1),
    .IRQ_n(slave_irq_n), .NMI_n(1'b1), .SO_n(1'b1),
    .R_W_n(srw), .Sync(), .EF(), .MF(), .XF(), .ML_n(), .VP_n(),
    .VDA(), .VPA(), .A(sa24), .DI(srw ? sdi : sdo), .DO(sdo),
    .Regs(), .DEBUG(), .NMI_ack()
);

// Four master IRQs and two slave IRQs per frame, held until software clears.
always_ff @(posedge clk) begin
    if (reset) begin
        main_irq_n <= 1'b1;
        slave_irq_n <= 1'b1;
    end else begin
        if (ce_5m && hcnt == 0 &&
            (vcnt == 9'd64 || vcnt == 9'd128 ||
             vcnt == 9'd192 || vcnt == 9'd256))
            main_irq_n <= 1'b0;

        if (ce_5m && hcnt == 0 && (vcnt == 9'd128 || vcnt == 9'd256))
            slave_irq_n <= 1'b0;

        if (pa_write && m_irq_reset_cs) main_irq_n <= 1'b1;
        if (pb_write && pbirqres) slave_irq_n <= 1'b1;
    end
end

// -------------------------------------------------------------------------
// ROM storage and MiSTer download map
//
// 00000-0BFFF master ROM (maps at CPU 4000-FFFF)
// 0C000-19FFF slave ROM  (maps at CPU 2000-FFFF)
// 1A000-1BFFF character ROMs
// 1C000-1DFFF motion-object ROMs
// 1E000-1E0FF vertical PROM (retained for future PROM-exact timing)
// -------------------------------------------------------------------------

(* ramstyle = "M10K" *) reg [7:0] main_rom [0:16'hBFFF];
(* ramstyle = "M10K" *) reg [7:0] slave_rom[0:16'hDFFF];
reg [7:0] sync_prom[0:8'hFF];
reg [7:0] main_rom_q;
reg [7:0] slave_rom_q;

// Sheet 7A 82S129 vertical timing PROM (3N). The MRA loads this at 0x1e000.
// Its registered outputs are not yet driving visible timing; that swap needs a
// separate phase check against the LS175/LS74 chain.
wire [7:0] vertical_prom_addr = {b128v, b64v, b32v, b16v, b8v, b4v, b2v, b1v};
wire [7:0] vertical_prom_data = sync_prom[vertical_prom_addr];
wire vertical_prom_o1 = vertical_prom_data[0];
wire vertical_prom_o2 = vertical_prom_data[1];
wire vertical_prom_o3 = vertical_prom_data[2];
wire vertical_prom_o4 = vertical_prom_data[3];
wire prom_o1_pre = vertical_prom_o1;
wire prom_o2_pre = vertical_prom_o2;
wire prom_o3_pre = vertical_prom_o3;
wire prom_o4_pre = vertical_prom_o4;

// Sheet 7A LS175/LS74 timing-register boundary. These provisional registers
// capture the PROM outputs on the behavioral 256H rising edge, but the stable
// counter-derived timing still drives the core until phase is verified.
reg b256h_d;
reg b1h_d;
reg hblank_3b_second_q_d;
reg sync_4n_q1;
reg sync_4n_q2;
reg sync_4n_q3;
reg sync_4n_q4;

wire b256h_rise = b5m && !b256h_d && b256h;
wire b1h_rise = b5m && !b1h_d && b1h;
wire hblank_3b_first_q;
wire hblank_3b_first_q_n;
wire hblank_3b_second_q;
wire hblank_3b_second_q_n;
wire hblank_3b_second_q_rise = b5m && !hblank_3b_second_q_d && hblank_3b_second_q;

// Sheet 7A 4N is a physical 74LS175. PROM pins O4/O3/O2/O1 feed D pins
// 4/5/12/13 respectively, so keep pin-oriented aliases rather than assigning
// semantic names before every visible output label is verified.
wire sync_4n_q1_pin2   = sync_4n_q1;
wire sync_4n_q1_n_pin3 = ~sync_4n_q1;
wire sync_4n_q2_pin7   = sync_4n_q2;
wire sync_4n_q2_n_pin6 = ~sync_4n_q2;
wire sync_4n_q3_pin10  = sync_4n_q3;
wire sync_4n_q3_n_pin11 = ~sync_4n_q3;
wire sync_4n_q4_pin15  = sync_4n_q4;
wire sync_4n_q4_n_pin14 = ~sync_4n_q4;

wire vsync_n_from_4n  = sync_4n_q3_pin10;
wire vsync_from_4n    = sync_4n_q3_n_pin11;
wire vblank_n_from_4n = sync_4n_q4_pin15;
wire vblank_from_4n   = sync_4n_q4_n_pin14;

wire prom_vsync_registered  = vsync_from_4n;
wire prom_vblank_registered = vblank_from_4n;
wire prom_hblank_registered = sync_4n_q2_pin7;
wire prom_256h_registered   = sync_4n_q1_pin2;

// Parallel observational copy of the Sheet 7A 4D/4B output gates fed from the
// 4N VSYNC labels. Active output stays on the fallback path until the full
// timing chain is proven phase-safe.
cloak_74ls86 u_4d_composite_sync_xor_from_4n (
    .a ({3'b000, vsync_from_4n}),
    .b ({3'b000, active_hsync}),
    .y (sync_4d_xor_4n_y)
);

cloak_74ls04 u_4b_sync_output_inverters_from_4n (
    .a ({4'b0000, vsync_n_from_4n, sync_4d_xor_4n_y[0]}),
    .y (sync_4b_inv_4n_y)
);

// Sheet 7A 3B/3C LS74 HBLANK chain. This is observational until the measured
// phase is known safe to drive active video timing.
cloak_74ls74 u_3b_hblank_2h_to_4h_latch (
    .clk      (clk),
    .reset    (reset),
    .preset_n (1'b1),
    .clear_n  (b4h),
    .clk_en   (b1h_rise),
    .d        (b2h),
    .q        (hblank_3b_first_q),
    .q_n      (hblank_3b_first_q_n)
);

cloak_74ls74 u_3b_hblank_5mhz_latch (
    .clk      (clk),
    .reset    (reset),
    .preset_n (1'b1),
    .clear_n  (1'b1),
    .clk_en   (b5m),
    .d        (hblank_3b_first_q),
    .q        (hblank_3b_second_q),
    .q_n      (hblank_3b_second_q_n)
);

cloak_74ls74 u_3c_hblank_256h_latch (
    .clk      (clk),
    .reset    (reset),
    .preset_n (1'b1),
    .clear_n  (1'b1),
    .clk_en   (hblank_3b_second_q_rise),
    .d        (b256h),
    .q        (hblank_from_3c_latched),
    .q_n      (hblank_n_from_3c_latched)
);

always_ff @(posedge clk) begin
    if (reset) begin
        b256h_d <= 1'b0;
        b1h_d <= 1'b0;
        hblank_3b_second_q_d <= 1'b0;
        sync_4n_q1 <= 1'b0;
        sync_4n_q2 <= 1'b0;
        sync_4n_q3 <= 1'b0;
        sync_4n_q4 <= 1'b0;
    end else if (ce_5m) begin
        b256h_d <= b256h;
        b1h_d <= b1h;
        hblank_3b_second_q_d <= hblank_3b_second_q;
        if (b256h_rise) begin
            sync_4n_q1 <= vertical_prom_o4; // 3N O4 -> 4N D1 pin 4
            sync_4n_q2 <= vertical_prom_o3; // 3N O3 -> 4N D2 pin 5
            sync_4n_q3 <= vertical_prom_o2; // 3N O2 -> 4N D3 pin 12
            sync_4n_q4 <= vertical_prom_o1; // 3N O1 -> 4N D4 pin 13
        end
    end
end

wire char_download_we =
    ioctl_wr && ioctl_index == 0 &&
    ioctl_addr >= 25'h1A000 && ioctl_addr < 25'h1C000;
wire char_download_we_5n = char_download_we && !ioctl_addr[12];
wire char_download_we_5r = char_download_we &&  ioctl_addr[12];
wire motion_download_we =
    ioctl_wr && ioctl_index == 0 &&
    ioctl_addr >= 25'h1C000 && ioctl_addr < 25'h1E000;
wire motion_download_we_6n = motion_download_we && !ioctl_addr[12];
wire motion_download_we_8r = motion_download_we &&  ioctl_addr[12];

wire [11:0] char_download_addr = ioctl_addr[11:0];
wire [11:0] motion_download_addr = ioctl_addr[11:0];
wire [12:0] char_video_addr;
wire [12:0] motion_video_addr;
wire [11:0] char_rom_addr = char_video_addr[11:0];
wire [7:0] char_rom_5n_data;
wire [7:0] char_rom_5r_data;
wire [15:0] char_rom_parallel_data = {char_rom_5r_data, char_rom_5n_data};
wire [7:0] char_video_data =
    char_video_addr[12] ? char_rom_5r_data : char_rom_5n_data;
wire [11:0] motion_rom_addr = motion_video_addr[11:0];
wire [7:0] motion_rom_6n_data;
wire [7:0] motion_rom_8r_data;
wire [15:0] motion_rom_parallel_data = {motion_rom_8r_data, motion_rom_6n_data};
wire [7:0] motion_video_data =
    motion_video_addr[12] ? motion_rom_8r_data : motion_rom_6n_data;

cloak_gfx_rom #(.AW(12)) char_graphics_5n (
    .clk(clk),
    .download_addr(char_download_addr),
    .download_data(ioctl_data),
    .download_we(char_download_we_5n),
    .video_addr(char_rom_addr),
    .video_data(char_rom_5n_data)
);

cloak_gfx_rom #(.AW(12)) char_graphics_5r (
    .clk(clk),
    .download_addr(char_download_addr),
    .download_data(ioctl_data),
    .download_we(char_download_we_5r),
    .video_addr(char_rom_addr),
    .video_data(char_rom_5r_data)
);

cloak_gfx_rom #(.AW(12)) motion_graphics_6n (
    .clk(clk),
    .download_addr(motion_download_addr),
    .download_data(ioctl_data),
    .download_we(motion_download_we_6n),
    .video_addr(motion_rom_addr),
    .video_data(motion_rom_6n_data)
);

cloak_gfx_rom #(.AW(12)) motion_graphics_8r (
    .clk(clk),
    .download_addr(motion_download_addr),
    .download_data(ioctl_data),
    .download_we(motion_download_we_8r),
    .video_addr(motion_rom_addr),
    .video_data(motion_rom_8r_data)
);

always_ff @(posedge clk) begin
    if (ma >= 16'h4000) main_rom_q <= main_rom[ma - 16'h4000];
    if (sa >= 16'h2000) slave_rom_q <= slave_rom[sa - 16'h2000];

    if (ioctl_wr && ioctl_index == 0) begin
        if (ioctl_addr < 25'h0C000)
            main_rom[ioctl_addr[15:0]] <= ioctl_data;
        else if (ioctl_addr < 25'h1A000)
            slave_rom[ioctl_addr - 25'h0C000] <= ioctl_data;
        else if (ioctl_addr < 25'h1E100)
            if (ioctl_addr >= 25'h1E000)
                sync_prom[ioctl_addr[7:0]] <= ioctl_data;
    end
end

// -------------------------------------------------------------------------
// Master/slave RAM and communication RAM
// -------------------------------------------------------------------------

reg [3:0] motion_ram_6l[0:255];
reg [3:0] motion_ram_6m[0:255];
reg [8:0] palette_ram[0:6'h3F];

// Sheet 4A motion RAM bus names. 6L/6M are the two 2101A-2 nibble RAMs that
// together produce MOD0..MOD7. Reads are still phase-expanded until the single
// physical MOA bus timing is implemented.
wire [7:0] moa_cpu = ma[7:0];
wire [7:0] mod_cpu_in = mdo;
wire [7:0] moa_cpu_mux;

// Sheet 4A 5L/5M LS157 motion RAM address muxes. The real PCB has one MOA bus;
// this core still exposes separate CPU/Y/ATTR/X phases until the object scanner
// is converted to a single timed bus.
cloak_74ls157 u_5m_moa_cpu_low (
    .sel      (1'b0),
    .enable_n (1'b0),
    .a        (moa_cpu[3:0]),
    .b        (4'd0),
    .y        (moa_cpu_mux[3:0])
);

cloak_74ls157 u_5l_moa_cpu_high (
    .sel      (1'b0),
    .enable_n (1'b0),
    .a        (moa_cpu[7:4]),
    .b        (4'd0),
    .y        (moa_cpu_mux[7:4])
);

wire [3:0] mod_cpu_low_from_6l = motion_ram_6l[moa_cpu_mux];
wire [3:0] mod_cpu_high_from_6m = motion_ram_6m[moa_cpu_mux];
wire [7:0] mod_cpu_bus_from_6m_6l =
    {mod_cpu_high_from_6m, mod_cpu_low_from_6l};
wire [7:0] mod_cpu_out;

// Sheet 4A 7H LS244 buffers MOD0..MOD7 back onto the CPU PABD bus during
// motion RAM reads. Internal tri-state is represented as pulled-high inactive.
cloak_74ls244 u_7h_mod_to_pabd_buffer (
    .enable1_n (!(moram && mrw)),
    .enable2_n (!(moram && mrw)),
    .a         (mod_cpu_bus_from_6m_6l),
    .y         (mod_cpu_out)
);

wire [7:0] main_ram_q;
wire [7:0] playfield_cpu_q;
wire [7:0] playfield_video_q;
wire [7:0] playfield_4lm_cpu_q;
wire [7:0] playfield_4lm_video_q;
wire [7:0] shared_main_q;
wire [7:0] shared_slave_q;
wire [7:0] nvram_q;
wire [5:0] cola_cpu_from_paba = ma[5:0];
wire       colram_bit8_from_paba6 = ma[6];
wire       colram_write_from_8d = pa_write && colram;
wire [7:0] slave_ram_q;

// Sheet 3B playfield address/data boundary names. The RAM is still a dual-port
// FPGA RAM, but CPU/video accesses now have schematic-style PFA/PFD/PFP names.
wire [10:0] pfa_cpu   = ma[10:0];
wire [10:0] pfa_video = {1'b0, b128v, b64v, b32v, b16v, b8v,
                         b128h, b64h, b32h, b16h, b8h};
wire cusd_from_timing = cusd_from_21m;
wire cuse_from_timing = cuse_from_21m;
wire cusf_from_timing = cusf_from_21m;
wire cusg_from_timing = cusg_from_21m;
wire cush_from_timing = cush_from_21m;
wire prt_from_timing = 1'b0;
wire bdel2h_from_7h;
wire bdel2h_n_from_7h;
wire pfa_bdel2h_provisional = bdel2h_from_7h;
wire [3:0] pfa_low_from_3m;
wire [3:0] pfa_mid_from_3l_3m;
wire [3:0] pfa_high_from_3n_3l;
wire [10:0] pfa_from_3n_3l_3m = {
    pfa_high_from_3n_3l[2:0],
    pfa_mid_from_3l_3m,
    pfa_low_from_3m
};
wire [9:0] playfield_video_addr = pfa_video[9:0];
wire [7:0] pfd_cpu_in = mdo;
wire [7:0] pfd_from_45h;
wire [7:0] pabd_from_45h;
wire param_n_from_decode = !param;
wire pawrite_n = !pa_write;
wire [3:0] pf_5f_or_y;
wire [3:0] pf_4j_and_y;
wire [3:0] pf_9f_and_y;
wire [3:0] pf_5h_nor_y;
wire [3:0] pf_8f_nand_y;
wire pfd_buffer_enable_n = pf_5f_or_y[0];
wire pf_ram_cs_from_4j = pf_4j_and_y[0];
wire pf_ram_write_phase_from_9f = pf_9f_and_y[0];
wire pf_ram_write_select_from_5h = pf_5h_nor_y[0];
wire pf_ram_we_from_8f = pf_8f_nand_y[0];
wire pf_ram_we_active_from_8f = !pf_ram_we_from_8f;

// Sheet 3A 5F LS32 combines PARAM* and BDEL2H into the active-low enable for
// the 4/5H data buffer. This remains observational while the decode polarity is
// verified against the CPU sheet.
cloak_74ls32 u_5f_playfield_buffer_enable_or (
    .a ({3'b000, param_n_from_decode}),
    .b ({3'b000, bdel2h_from_7h}),
    .y (pf_5f_or_y)
);

// Sheet 3A RAM control glue around 4L/M. The active RAM write path below still
// uses the stable compatibility expression until CS/OE/WE polarity is verified.
cloak_74ls08 u_4j_playfield_ram_cs_and (
    .a ({3'b000, param}),
    .b ({3'b000, bdel2h_from_7h}),
    .y (pf_4j_and_y)
);

cloak_74ls08 u_9f_playfield_write_phase_and (
    .a ({3'b000, bdel2h_from_7h}),
    .b ({3'b000, b1h}),
    .y (pf_9f_and_y)
);

cloak_74ls02 u_5h_playfield_write_select_nor (
    .a ({3'b000, param_n_from_decode}),
    .b ({3'b000, pawrite_n}),
    .y (pf_5h_nor_y)
);

cloak_74ls00 u_8f_playfield_ram_we_nand (
    .a ({3'b000, pf_ram_write_phase_from_9f}),
    .b ({3'b000, pf_ram_write_select_from_5h}),
    .y (pf_8f_nand_y)
);

// Sheet 3A 4/5H LS245 bridges the CPU PABD bus and playfield RAM PFD bus.
// The active RAM port still uses pfd_cpu_in/playfield_cpu_q directly until the
// PARAM/PABR/W enable gate chain is fully represented.
cloak_74ls245 u_45h_pabd_pfd_buffer (
    .dir      (mrw),
    .enable_n (pfd_buffer_enable_n),
    .a        (playfield_cpu_q),
    .b        (mdo),
    .a_out    (pfd_from_45h),
    .b_out    (pabd_from_45h)
);

// Sheet 3A 7H LS74 delays B2H on B1H to create the BDEL2H select timing used
// by the physical playfield address muxes.
cloak_74ls74 u_7h_playfield_bdel2h_latch (
    .clk      (clk),
    .reset    (reset),
    .preset_n (1'b1),
    .clear_n  (1'b1),
    .clk_en   (b1h_rise),
    .d        (b2h),
    .q        (bdel2h_from_7h),
    .q_n      (bdel2h_n_from_7h)
);

// Sheet 3B 3N/3L/3M LS157s form the physical PFA0..10 bus. These outputs are
// observational until the 7H BDEL2H access timing and custom CUS* generator are
// fully modelled.
cloak_74ls157 u_3m_pfa_low_mux (
    .sel      (pfa_bdel2h_provisional),
    .enable_n (1'b0),
    .a        (pfa_cpu[3:0]),
    .b        ({b64h, b32h, b16h, b8h}),
    .y        (pfa_low_from_3m)
);

cloak_74ls157 u_3l_3m_pfa_mid_mux (
    .sel      (pfa_bdel2h_provisional),
    .enable_n (1'b0),
    .a        (pfa_cpu[7:4]),
    .b        ({cusf_from_timing, cuse_from_timing, cusd_from_timing, h128ss}),
    .y        (pfa_mid_from_3l_3m)
);

cloak_74ls157 u_3n_3l_pfa_high_mux (
    .sel      (pfa_bdel2h_provisional),
    .enable_n (1'b0),
    .a        ({1'b0, pfa_cpu[10:8]}),
    .b        ({1'b0, prt_from_timing, cush_from_timing, cusg_from_timing}),
    .y        (pfa_high_from_3n_3l)
);

cloak_tdp_ram #(.AW(10), .DW(8)) main_work_ram (
    .clk(clk),
    .a_addr(ma[9:0]), .a_din(mdo),
    .a_we(pa_write && m_main_ram_cs), .a_dout(main_ram_q),
    .b_addr(10'd0), .b_din(8'd0), .b_we(1'b0), .b_dout()
);

cloak_tdp_ram #(.AW(10), .DW(8)) playfield_ram (
    .clk(clk),
    .a_addr(pfa_cpu[9:0]), .a_din(pfd_cpu_in),
    .a_we(pa_write && param), .a_dout(playfield_cpu_q),
    .b_addr(playfield_video_addr), .b_din(8'd0),
    .b_we(1'b0), .b_dout(playfield_video_q)
);

// Sheet 3A 4L/M HM6116-2 2K playfield RAM boundary. This separate observation
// RAM exposes the physical 11-bit PFA/PFD/CS/WE wiring but does not yet drive
// CPU reads or visible playfield fetches.
cloak_tdp_ram #(.AW(11), .DW(8)) playfield_ram_4lm_observe (
    .clk(clk),
    .a_addr(pfa_from_3n_3l_3m), .a_din(pfd_from_45h),
    .a_we(pf_ram_cs_from_4j && pf_ram_we_active_from_8f),
    .a_dout(playfield_4lm_cpu_q),
    .b_addr(pfa_from_3n_3l_3m), .b_din(8'd0),
    .b_we(1'b0), .b_dout(playfield_4lm_video_q)
);

cloak_tdp_ram #(.AW(11), .DW(8)) communication_ram (
    .clk(clk),
    .a_addr(ma[10:0]), .a_din(mdo),
    .a_we(pa_write && pacmram), .a_dout(shared_main_q),
    .b_addr(sa[10:0]), .b_din(sdo),
    .b_we(pb_write && pbcmram), .b_dout(shared_slave_q)
);

cloak_tdp_ram #(.AW(9), .DW(8)) nonvolatile_ram (
    .clk(clk),
    .a_addr(ma[8:0]), .a_din(mdo),
    .a_we(pa_write && m_nvram_cs), .a_dout(nvram_q),
    .b_addr(9'd0), .b_din(8'd0), .b_we(1'b0), .b_dout()
);

cloak_tdp_ram #(.AW(11), .DW(8)) slave_work_ram (
    .clk(clk),
    .a_addr(sa[10:0]), .a_din(sdo),
    .a_we(pb_write && pbram),
    .a_dout(slave_ram_q),
    .b_addr(11'd0), .b_din(8'd0), .b_we(1'b0), .b_dout()
);

reg bitmap_select;
reg bitmap_clear;
reg [15:0] clear_addr;
reg [7:0] out_latch;

wire bufsel = bitmap_select;
wire clrram = bitmap_clear;
wire coin_counter_r = out_latch[0];
wire coin_counter_l = out_latch[1];
wire cocktail_out   = out_latch[3];
wire start2_led     = out_latch[6];
wire start1_led     = out_latch[7];

// Sheet 8A 74LS169 X/Y counter boundary.
wire [2:0] graph_offset = sa[2:0];
wire graph_x0 = graph_offset[0];
wire graph_x1 = graph_offset[1];
wire graph_inv = graph_offset[2];
wire pbba0_graph = graph_x0;
wire pbba1_graph = graph_x1;
wire pbba2_graph = graph_inv;
// Sheet 6B: 6M (LS02) NORs PBBA0/PBBA1, then 5N (LS32) ORs that term with PBBA2 to form INV.
wire inv_graph = pbba2_graph || !(pbba0_graph || pbba1_graph);
// Sheet 6B: 5M (LS00) forms active-low DRAM from DECODE and NAND(PBBA0,PBBA1).
wire dram_decode_n = !(s_graph_cs && !(pbba0_graph && pbba1_graph));
wire x_counter_load = ldx;
wire y_counter_load = ldy;
wire xy_counter_count = !dram_decode_n;
wire dram_counter_access = xy_counter_count;
wire [7:0] x_counter_d = sdo;
wire [7:0] y_counter_d = sdo;
wire [3:0] xl_counter_q;
wire [3:0] xh_counter_q;
wire [3:0] yl_counter_q;
wire [3:0] yh_counter_q;
wire [7:0] x_counter_q = {xh_counter_q, xl_counter_q};
wire [7:0] y_counter_q = {yh_counter_q, yl_counter_q};
wire [7:0] bitmap_x = x_counter_q;
wire [7:0] bitmap_y = y_counter_q;
wire [3:0] xl_counter_d = x_counter_d[3:0];
wire [3:0] xh_counter_d = x_counter_d[7:4];
wire [3:0] yl_counter_d = y_counter_d[3:0];
wire [3:0] yh_counter_d = y_counter_d[7:4];
wire x_counter_count_en = !graph_x0;
wire y_counter_count_en = !graph_x1;
wire x_counter_count_up = graph_inv;
wire y_counter_count_up = inv_graph;
wire xl_counter_tc;
wire yl_counter_tc;
wire xh_counter_tc;
wire yh_counter_tc;
wire xl_counter_tc_n;
wire yl_counter_tc_n;
wire xh_counter_tc_n;
wire yh_counter_tc_n;
wire xh_counter_count_en = !xl_counter_tc_n;
wire yh_counter_count_en = !yl_counter_tc_n;
// Sheet 8A clocks the LS169 packages from 3E LS04, which inverts PBBPHI2.
// Keep the FPGA fabric synchronous and model that package clock as a slave tick.
wire ls169_counter_clk_en = ce_slave;
wire ldx_counter_load_n = !pb_write || ldx_decode_n;
wire ldy_counter_load_n = !pb_write || ldy_decode_n;
wire xl_load_n = ldx_counter_load_n;
wire xh_load_n = xl_load_n;
wire yl_load_n = ldy_counter_load_n;
wire yh_load_n = yl_load_n;
wire xl_enp_n = dram_decode_n;
wire xl_ent_n = pbba0_graph;
wire xh_enp_n = dram_decode_n;
wire xh_ent_n = xl_counter_tc_n;
wire yl_enp_n = dram_decode_n;
wire yl_ent_n = pbba1_graph;
wire yh_enp_n = dram_decode_n;
wire yh_ent_n = yl_counter_tc_n;

// Per-package LS169 pin aliases. These are the nets to compare against Sheet
// 8A pins for 5H, 4H, 5J, and 4J before changing the provisional equations.
wire u_5h_ld_n = xl_load_n;
wire u_5h_enp_n = xl_enp_n;
wire u_5h_ent_n = xl_ent_n;
wire u_5h_ud = x_counter_count_up;
wire [3:0] u_5h_p = xl_counter_d;
wire [3:0] u_5h_q;
wire u_5h_tc;

wire u_4h_ld_n = xh_load_n;
wire u_4h_enp_n = xh_enp_n;
wire u_4h_ent_n = xh_ent_n;
wire u_4h_ud = x_counter_count_up;
wire [3:0] u_4h_p = xh_counter_d;
wire [3:0] u_4h_q;
wire u_4h_tc;

wire u_5j_ld_n = yl_load_n;
wire u_5j_enp_n = yl_enp_n;
wire u_5j_ent_n = yl_ent_n;
wire u_5j_ud = y_counter_count_up;
wire [3:0] u_5j_p = yl_counter_d;
wire [3:0] u_5j_q;
wire u_5j_tc;

wire u_4j_ld_n = yh_load_n;
wire u_4j_enp_n = yh_enp_n;
wire u_4j_ent_n = yh_ent_n;
wire u_4j_ud = y_counter_count_up;
wire [3:0] u_4j_p = yh_counter_d;
wire [3:0] u_4j_q;
wire u_4j_tc;

assign xl_counter_q = u_5h_q;
assign xh_counter_q = u_4h_q;
assign yl_counter_q = u_5j_q;
assign yh_counter_q = u_4j_q;
assign xl_counter_tc_n = u_5h_tc;
assign xh_counter_tc_n = u_4h_tc;
assign yl_counter_tc_n = u_5j_tc;
assign yh_counter_tc_n = u_4j_tc;
assign xl_counter_tc = !xl_counter_tc_n;
assign xh_counter_tc = !xh_counter_tc_n;
assign yl_counter_tc = !yl_counter_tc_n;
assign yh_counter_tc = !yh_counter_tc_n;

cloak_74ls169 u_5h_x_low (
    .clk(clk),
    .clk_en(ls169_counter_clk_en),
    .reset(reset),
    .load_n(u_5h_ld_n),
    .enp_n(u_5h_enp_n),
    .ent_n(u_5h_ent_n),
    .up(u_5h_ud),
    .d(u_5h_p),
    .q(u_5h_q),
    .tc(u_5h_tc)
);

cloak_74ls169 u_4h_x_high (
    .clk(clk),
    .clk_en(ls169_counter_clk_en),
    .reset(reset),
    .load_n(u_4h_ld_n),
    .enp_n(u_4h_enp_n),
    .ent_n(u_4h_ent_n),
    .up(u_4h_ud),
    .d(u_4h_p),
    .q(u_4h_q),
    .tc(u_4h_tc)
);

cloak_74ls169 u_5j_y_low (
    .clk(clk),
    .clk_en(ls169_counter_clk_en),
    .reset(reset),
    .load_n(u_5j_ld_n),
    .enp_n(u_5j_enp_n),
    .ent_n(u_5j_ent_n),
    .up(u_5j_ud),
    .d(u_5j_p),
    .q(u_5j_q),
    .tc(u_5j_tc)
);

cloak_74ls169 u_4j_y_high (
    .clk(clk),
    .clk_en(ls169_counter_clk_en),
    .reset(reset),
    .load_n(u_4j_ld_n),
    .enp_n(u_4j_enp_n),
    .ent_n(u_4j_ent_n),
    .up(u_4j_ud),
    .d(u_4j_p),
    .q(u_4j_q),
    .tc(u_4j_tc)
);

// Sheet 7B bitmap clock/write boundary. The original DRAM timing is active-low
// RAS/CAS plus per-plane WRA/WRB strobes; the FPGA RAM still uses full-nibble
// writes until the row/column mux network is implemented.
wire ras_n = !b5m;
wire cas_n = !b5m;
wire row = b1h;
wire selrow = b2h;

// Sheet 8A DRAM address boundary. The PCB presents multiplexed DRADR0..7 row
// and column addresses; the FPGA RAM still uses a flat 16-bit substitute.
wire [7:0] dradr_cpu_row = y_counter_q;
wire [7:0] dradr_cpu_col = x_counter_q;
wire [7:0] dradr_video_row = vcnt[7:0];
wire [7:0] dradr_video_col = hcnt[7:0] + 8'd7;
wire [7:0] dradr_cpu_mux = selrow ? dradr_cpu_row : dradr_cpu_col;
wire [7:0] dradr_video_mux = selrow ? dradr_video_row : dradr_video_col;
wire [7:0] dradr_mux = row ? dradr_video_mux : dradr_cpu_mux;
wire [15:0] dradr_cpu = {dradr_cpu_row, dradr_cpu_col};
wire [3:0] bmp0_cpu_q;
wire [3:0] bmp1_cpu_q;
wire [3:0] bmp0_vid_q;
wire [3:0] bmp1_vid_q;
wire [15:0] dradr_video = {dradr_video_row, dradr_video_col};
wire [15:0] bitmap_video_addr = dradr_video;
wire [3:0] dra_cpu_in = bitmap_clear ? 4'd0 : sdo[3:0];
wire [3:0] drb_cpu_in = bitmap_clear ? 4'd0 : sdo[3:0];

wire bmp_write = pb_write && drawren;
wire [15:0] bmp_cpu_addr = bitmap_clear ? clear_addr : dradr_cpu;
wire bmp0_we = bitmap_clear ? !bitmap_select : (bmp_write && !bitmap_select);
wire bmp1_we = bitmap_clear ?  bitmap_select : (bmp_write &&  bitmap_select);
wire [3:0] dr_n = ~(4'b0001 << {graph_x1, graph_x0});
wire dr0_n = dr_n[0];
wire dr1_n = dr_n[1];
wire dr2_n = dr_n[2];
wire dr3_n = dr_n[3];
wire wra0 = bmp0_we;
wire wra1 = bmp0_we;
wire wra2 = bmp0_we;
wire wra3 = bmp0_we;
wire wrb0 = bmp1_we;
wire wrb1 = bmp1_we;
wire wrb2 = bmp1_we;
wire wrb3 = bmp1_we;
wire [3:0] wra = {wra3, wra2, wra1, wra0};
wire [3:0] wrb = {wrb3, wrb2, wrb1, wrb0};

cloak_dpram #(.AW(16), .DW(4)) bitmap0 (
    .clk(clk), .a_addr(bmp_cpu_addr), .a_din(dra_cpu_in),
    .a_we(bmp0_we), .a_dout(bmp0_cpu_q),
    .b_addr(bitmap_video_addr), .b_dout(bmp0_vid_q)
);

cloak_dpram #(.AW(16), .DW(4)) bitmap1 (
    .clk(clk), .a_addr(bmp_cpu_addr), .a_din(drb_cpu_in),
    .a_we(bmp1_we), .a_dout(bmp1_cpu_q),
    .b_addr(bitmap_video_addr), .b_dout(bmp1_vid_q)
);

integer i;
always_ff @(posedge clk) begin
    if (reset) begin
        bitmap_select <= 0;
        bitmap_clear <= 0;
        clear_addr <= 0;
        out_latch <= 8'd0;
        for (i = 0; i < 64; i = i + 1) palette_ram[i] <= 9'h1FF;
    end else begin
        if (bitmap_clear) begin
            clear_addr <= clear_addr + 1'd1;
            if (clear_addr == 16'hFFFF) bitmap_clear <= 0;
        end

        if (pa_write) begin
            if (moram) begin
                motion_ram_6l[moa_cpu_mux] <= mod_cpu_in[3:0];
                motion_ram_6m[moa_cpu_mux] <= mod_cpu_in[7:4];
            end
            if (colram_write_from_8d)
                palette_ram[cola_cpu_from_paba] <= {colram_bit8_from_paba6, mdo};

            // Sheet 5B 74LS259 output latch. These cabinet outputs are kept
            // internal for now so the current MiSTer behavior remains stable.
            if (m_out_cs)
                out_latch[ma[2:0]] <= mdo[7];
        end

        if (pb_write) begin
            if (swap) begin
                bitmap_select <= sdo[0];
                if (sdo[1]) begin
                    bitmap_clear <= 1;
                    clear_addr <= 0;
                end
            end
        end

    end
end

// -------------------------------------------------------------------------
// Inputs and POKEYs
// MiSTer left stick = left joystick, buttons 1-4 = right joystick.
// -------------------------------------------------------------------------

wire in1 = ma == 16'h2000;
wire in2 = ma == 16'h2200;
wire in3 = ma == 16'h2400;
wire in1_n = !in1;
wire in2_n = !in2;
wire in3_n = !in3;

wire pl1_left_left_to_9n  = ~joystick_0[1];
wire pl1_left_right_to_9n = ~joystick_0[0];
wire pl1_left_up_to_9n    = ~joystick_0[3];
wire pl1_left_down_to_9n  = ~joystick_0[2];
wire pl1_right_left_to_9n  = ~joystick_0[4];
wire pl1_right_right_to_9n = ~joystick_0[5];
wire pl1_right_up_to_9n    = ~joystick_0[6];
wire pl1_right_down_to_9n  = ~joystick_0[7];
wire [7:0] pl1_inputs_to_9n = {
    pl1_left_left_to_9n, pl1_left_right_to_9n,
    pl1_left_up_to_9n, pl1_left_down_to_9n,
    pl1_right_left_to_9n, pl1_right_right_to_9n,
    pl1_right_up_to_9n, pl1_right_down_to_9n
};

wire pl2_left_left_to_9p  = ~joystick_1[1];
wire pl2_left_right_to_9p = ~joystick_1[0];
wire pl2_left_up_to_9p    = ~joystick_1[3];
wire pl2_left_down_to_9p  = ~joystick_1[2];
wire pl2_right_left_to_9p  = ~joystick_1[4];
wire pl2_right_right_to_9p = ~joystick_1[5];
wire pl2_right_up_to_9p    = ~joystick_1[6];
wire pl2_right_down_to_9p  = ~joystick_1[7];
wire [7:0] pl2_inputs_to_9p = {
    pl2_left_left_to_9p, pl2_left_right_to_9p,
    pl2_left_up_to_9p, pl2_left_down_to_9p,
    pl2_right_left_to_9p, pl2_right_right_to_9p,
    pl2_right_up_to_9p, pl2_right_down_to_9p
};
wire [7:0] starts = {start1, start2, 2'b11, 4'b1111};
wire fire1_to_9r = ~fire1;
wire fire2_to_9r = ~fire2;
wire coin_aux_to_9r = ~coin_aux;
wire cocktail_to_9r = ~cocktail;
wire coin_r_to_9r = ~coin_r;
wire coin_l_to_9r = ~coin_l;
wire self_test_to_9r = ~self_test;
wire bvblank_to_9r = ~bvblank;
wire [7:0] system_inputs_to_9r = {
    fire1_to_9r, fire2_to_9r, coin_aux_to_9r, cocktail_to_9r,
    coin_r_to_9r, coin_l_to_9r, self_test_to_9r, bvblank_to_9r
};

wire [7:0] p1;
wire [7:0] p2;
wire [7:0] system_in;

// Sheet 5A 9N/9P/9R LS244 input buffers onto the master PABD bus.
cloak_74ls244 u_9n_in1_player1_buffer (
    .enable1_n (in1_n),
    .enable2_n (in1_n),
    .a         (pl1_inputs_to_9n),
    .y         (p1)
);

cloak_74ls244 u_9p_in2_player2_buffer (
    .enable1_n (in2_n),
    .enable2_n (in2_n),
    .a         (pl2_inputs_to_9p),
    .y         (p2)
);

cloak_74ls244 u_9r_in3_system_buffer (
    .enable1_n (in3_n),
    .enable2_n (in3_n),
    .a         (system_inputs_to_9r),
    .y         (system_in)
);

wire [7:0] pokey1_dout;
wire [7:0] pokey2_dout;
wire [15:0] pokey1_audio;
wire [15:0] pokey2_audio;
pokey_compat pokey1 (
    .clk(clk), .reset(reset), .ce_1m25(ce_pokey),
    .cs(lfreq && ce_main), .we(!mrw), .addr(ma[3:0]),
    .din(mdo), .allpot(starts), .dout(pokey1_dout), .audio(pokey1_audio)
);

pokey_compat pokey2 (
    .clk(clk), .reset(reset), .ce_1m25(ce_pokey),
    .cs(hfreq && ce_main), .we(!mrw), .addr(ma[3:0]),
    .din(mdo), .allpot(dips), .dout(pokey2_dout), .audio(pokey2_audio)
);

wire [16:0] pokey_mix =
    {1'b0, pokey1_audio} + {1'b0, pokey2_audio};
assign audio = pokey_mix[16:1];

// CPU read muxes
wire [7:0] graph_dout = bitmap_select ? {4'd0, bmp0_cpu_q} : {4'd0, bmp1_cpu_q};

assign mdi =
    m_main_ram_cs ? main_ram_q :
    param         ? playfield_cpu_q :
    pacmram       ? shared_main_q :
    lfreq         ? pokey1_dout :
    hfreq         ? pokey2_dout :
    in1           ? p1 :
    in2           ? p2 :
    in3           ? system_in :
    m_nvram_cs    ? nvram_q :
    moram         ? mod_cpu_out :
    m_rom_cs      ? main_rom_q :
    8'hFF;

assign sdi =
    s_graph_cs  ? graph_dout :
    pbram       ? slave_ram_q :
    pbcmram     ? shared_slave_q :
    s_rom_cs    ? slave_rom_q :
    8'hFF;

// -------------------------------------------------------------------------
// Video: playfield, displayed bitmap, then motion objects.
// -------------------------------------------------------------------------

wire [7:0] pfp_from_4k;

// Sheet 3B 4K LS273 latches PFD0..7 into PFP0..7 before character ROM
// addressing. Active playfield lookup still uses the compatibility direct path
// until the surrounding LDF/LDNIB/BYTLOAD timing is verified.
cloak_74ls273 u_4k_playfield_latch (
    .clk    (clk),
    .reset  (reset),
    .clk_en (ce_5m && !hblank),
    .d      (playfield_video_q),
    .q      (pfp_from_4k)
);

wire [7:0] pfp = playfield_video_q;
wire [7:0] tile_code = pfp;
wire [2:0] tile_x = {b4h, b2h, b1h};
wire [2:0] tile_y = {b4v, b2v, b1v};

assign char_video_addr =
    {1'b0, tile_code, 4'b0} +
    {9'd0, tile_y, 1'b0} +
    (tile_x[2] ? 13'd1 : 13'd0) +
    (!tile_x[1] ? 13'h1000 : 13'd0);

reg tile_nibble_high;
always_ff @(posedge clk) tile_nibble_high <= tile_x[0];

wire [3:0] pf_3f_and_y;
wire pf_nibload_from_3f = pf_3f_and_y[0];
wire pf_ldf_from_11f;
wire pf_ldnib_from_11f;
wire [5:0] pf_10e_inv_a;
wire [5:0] pf_10e_inv_y;
wire pf_b4h_n_from_10e = pf_10e_inv_y[0];
wire pf_b4h_from_10e = pf_10e_inv_y[1];
wire [3:0] pf_10d_nand_y;
wire pf_bytload_from_10d = pf_10d_nand_y[0];

// Sheet 3B 3F AND gate creates NIBLOAD from B1H/B2H.
cloak_74ls08 u_3f_playfield_nibload_and (
    .a ({3'b000, b1h}),
    .b ({3'b000, b2h}),
    .y (pf_3f_and_y)
);

// Sheet 3B 11F LS74 clocks the NIBLOAD term with B5M and exposes LDF/LDNIB.
cloak_74ls74 u_11f_playfield_load_latch (
    .clk      (clk),
    .reset    (reset),
    .preset_n (1'b1),
    .clear_n  (1'b1),
    .clk_en   (ce_5m),
    .d        (pf_nibload_from_3f),
    .q        (pf_ldf_from_11f),
    .q_n      (pf_ldnib_from_11f)
);

assign pf_10e_inv_a = {4'b0000, pf_b4h_n_from_10e, b4h};

// Sheet 3B 10E uses two inverter sections in the B4H path before 10D.
cloak_74ls04 u_10e_playfield_b4h_inverters (
    .a (pf_10e_inv_a),
    .y (pf_10e_inv_y)
);

// Sheet 3B 10D combines the restored B4H path with NIBLOAD to form BYTLOAD.
cloak_74ls00 u_10d_playfield_bytload_nand (
    .a ({3'b000, pf_b4h_from_10e}),
    .b ({3'b000, pf_nibload_from_3f}),
    .y (pf_10d_nand_y)
);

wire [15:0] pf_rom_from_5n_5r = char_rom_parallel_data;
wire [3:0] pbit3_parallel_from_rom = {
    pf_rom_from_5n_5r[15],
    pf_rom_from_5n_5r[11],
    pf_rom_from_5n_5r[7],
    pf_rom_from_5n_5r[3]
};
wire [3:0] pbit2_parallel_from_rom = {
    pf_rom_from_5n_5r[14],
    pf_rom_from_5n_5r[10],
    pf_rom_from_5n_5r[6],
    pf_rom_from_5n_5r[2]
};
wire [3:0] pbit1_parallel_from_rom = {
    pf_rom_from_5n_5r[13],
    pf_rom_from_5n_5r[9],
    pf_rom_from_5n_5r[5],
    pf_rom_from_5n_5r[1]
};
wire [3:0] pbit0_parallel_from_rom = {
    pf_rom_from_5n_5r[12],
    pf_rom_from_5n_5r[8],
    pf_rom_from_5n_5r[4],
    pf_rom_from_5n_5r[0]
};
wire [3:0] pbit3_shift_q;
wire [3:0] pbit2_shift_q;
wire [3:0] pbit1_shift_q;
wire [3:0] pbit0_shift_q;
wire pf_shift_clk_en = ce_5m;
wire pf_blank_clear_n = !bblank;
wire [5:0] pf_45e_inv_y;
wire pf_cocktail_n_from_45e = pf_45e_inv_y[0];
wire [3:0] pf_45f_nand_y;
wire pf_ls194_s0_pin9_from_45f = pf_45f_nand_y[0];
wire pf_ls194_s1_pin10_from_45f = pf_45f_nand_y[1];
wire [1:0] pf_ls194_mode_from_45f = {
    pf_ls194_s1_pin10_from_45f,
    pf_ls194_s0_pin9_from_45f
};

// Sheet 3B 4/5E and 4/5F steer the four LS194s between load and the two shift
// directions using LDNIB and COCKTAIL.
cloak_74ls04 u_45e_playfield_cocktail_inverter (
    .a ({5'b00000, cocktail_out}),
    .y (pf_45e_inv_y)
);

cloak_74ls00 u_45f_playfield_shift_mode_nands (
    .a ({2'b00, pf_ldnib_from_11f, pf_ldnib_from_11f}),
    .b ({2'b00, cocktail_out, pf_cocktail_n_from_45e}),
    .y (pf_45f_nand_y)
);

// Sheet 3B 4P/4R/3P/3R LS194s parallel-load character ROM bit planes and
// expose normal/flipped serial ends before the 4N cocktail mux. The active
// pixel path stays on the direct compatibility nibble until LDF/LDNIB/BYTLOAD
// timing is traced completely.
cloak_74ls194 u_4p_pbit3_shift (
    .clk     (clk),
    .reset   (reset),
    .clear_n (pf_blank_clear_n),
    .clk_en  (pf_shift_clk_en),
    .mode    (pf_ls194_mode_from_45f),
    .sr      (1'b0),
    .sl      (1'b0),
    .d       (pbit3_parallel_from_rom),
    .q       (pbit3_shift_q)
);

cloak_74ls194 u_4r_pbit2_shift (
    .clk     (clk),
    .reset   (reset),
    .clear_n (pf_blank_clear_n),
    .clk_en  (pf_shift_clk_en),
    .mode    (pf_ls194_mode_from_45f),
    .sr      (1'b0),
    .sl      (1'b0),
    .d       (pbit2_parallel_from_rom),
    .q       (pbit2_shift_q)
);

cloak_74ls194 u_3p_pbit1_shift (
    .clk     (clk),
    .reset   (reset),
    .clear_n (pf_blank_clear_n),
    .clk_en  (pf_shift_clk_en),
    .mode    (pf_ls194_mode_from_45f),
    .sr      (1'b0),
    .sl      (1'b0),
    .d       (pbit1_parallel_from_rom),
    .q       (pbit1_shift_q)
);

cloak_74ls194 u_3r_pbit0_shift (
    .clk     (clk),
    .reset   (reset),
    .clear_n (pf_blank_clear_n),
    .clk_en  (pf_shift_clk_en),
    .mode    (pf_ls194_mode_from_45f),
    .sr      (1'b0),
    .sl      (1'b0),
    .d       (pbit0_parallel_from_rom),
    .q       (pbit0_shift_q)
);

wire [3:0] pbit_n_from_ls194 = {
    pbit3_shift_q[3],
    pbit2_shift_q[3],
    pbit1_shift_q[3],
    pbit0_shift_q[3]
};
wire [3:0] pbit_f_from_ls194 = {
    pbit3_shift_q[0],
    pbit2_shift_q[0],
    pbit1_shift_q[0],
    pbit0_shift_q[0]
};
wire [3:0] pbit_from_4n;

// Sheet 3B 4N LS157 selects normal or flipped playfield bit order under the
// COCKTAIL output latch. This is still observational until the LS194 load/shift
// timing is complete.
cloak_74ls157 u_4n_playfield_cocktail_mux (
    .sel      (cocktail_out),
    .enable_n (1'b0),
    .a        (pbit_n_from_ls194),
    .b        (pbit_f_from_ls194),
    .y        (pbit_from_4n)
);

localparam USE_SCHEMATIC_PLAYFIELD_PIXEL = 1'b1;

wire [3:0] pbit_compat =
    tile_nibble_high ? char_video_data[3:0] : char_video_data[7:4];
wire [3:0] pbit_schematic = pbit_from_4n;
wire [3:0] pbit =
    USE_SCHEMATIC_PLAYFIELD_PIXEL ? pbit_schematic : pbit_compat;

reg [3:0] pbit_compat_d1;
reg [3:0] pbit_compat_d2;
always_ff @(posedge clk) begin
    if (reset) begin
        pbit_compat_d1 <= 4'd0;
        pbit_compat_d2 <= 4'd0;
    end else if (ce_5m && !hblank && !vblank) begin
        pbit_compat_d1 <= pbit_compat;
        pbit_compat_d2 <= pbit_compat_d1;
    end
end

wire [3:0] pf_pbit_compare_now_xor = pbit_from_4n ^ pbit_compat;
wire [3:0] pf_pbit_compare_d1_xor = pbit_from_4n ^ pbit_compat_d1;
wire [3:0] pf_pbit_compare_d2_xor = pbit_from_4n ^ pbit_compat_d2;
wire pf_pbit_compare_now_match = pf_pbit_compare_now_xor == 4'd0;
wire pf_pbit_compare_d1_match = pf_pbit_compare_d1_xor == 4'd0;
wire pf_pbit_compare_d2_match = pf_pbit_compare_d2_xor == 4'd0;

reg [3:0] sprite_line0[0:255];
reg [3:0] sprite_line1[0:255];
reg       display_line_bank;
reg       render_active;
reg [5:0] render_sprite;
reg [1:0] render_pair;
reg [7:0] render_y;
reg       render_pending;
reg [7:0] pending_sx;
reg [2:0] pending_x;
reg       pending_first_high;
reg       b2h_6k_d;
reg       b4h_8h_d;
reg       b8h_7f_d;
reg       bytload_d;

wire [7:0] moa_render_y    = {2'b00, render_sprite};
wire [7:0] moa_render_attr = {2'b01, render_sprite};
wire [7:0] moa_render_x    = {2'b11, render_sprite};
wire [7:0] moa_render_y_mux;
wire [7:0] moa_render_attr_mux;
wire [7:0] moa_render_x_mux;
wire [7:0] moa_render_mux  = moa_render_attr_mux;

cloak_74ls157 u_5m_moa_render_y_low (
    .sel      (1'b1),
    .enable_n (1'b0),
    .a        (4'd0),
    .b        (moa_render_y[3:0]),
    .y        (moa_render_y_mux[3:0])
);

cloak_74ls157 u_5l_moa_render_y_high (
    .sel      (1'b1),
    .enable_n (1'b0),
    .a        (4'd0),
    .b        (moa_render_y[7:4]),
    .y        (moa_render_y_mux[7:4])
);

cloak_74ls157 u_5m_moa_render_attr_low (
    .sel      (1'b1),
    .enable_n (1'b0),
    .a        (4'd0),
    .b        (moa_render_attr[3:0]),
    .y        (moa_render_attr_mux[3:0])
);

cloak_74ls157 u_5l_moa_render_attr_high (
    .sel      (1'b1),
    .enable_n (1'b0),
    .a        (4'd0),
    .b        (moa_render_attr[7:4]),
    .y        (moa_render_attr_mux[7:4])
);

cloak_74ls157 u_5m_moa_render_x_low (
    .sel      (1'b1),
    .enable_n (1'b0),
    .a        (4'd0),
    .b        (moa_render_x[3:0]),
    .y        (moa_render_x_mux[3:0])
);

cloak_74ls157 u_5l_moa_render_x_high (
    .sel      (1'b1),
    .enable_n (1'b0),
    .a        (4'd0),
    .b        (moa_render_x[7:4]),
    .y        (moa_render_x_mux[7:4])
);

wire [3:0] mod_render_y_low_from_6l = motion_ram_6l[moa_render_y_mux];
wire [3:0] mod_render_y_high_from_6m = motion_ram_6m[moa_render_y_mux];
wire [3:0] mod_render_attr_low_from_6l = motion_ram_6l[moa_render_attr_mux];
wire [3:0] mod_render_attr_high_from_6m = motion_ram_6m[moa_render_attr_mux];
wire [3:0] mod_render_x_low_from_6l = motion_ram_6l[moa_render_x_mux];
wire [3:0] mod_render_x_high_from_6m = motion_ram_6m[moa_render_x_mux];
wire [7:0] mod_render_y =
    {mod_render_y_high_from_6m, mod_render_y_low_from_6l};
wire [7:0] mod_render_attr =
    {mod_render_attr_high_from_6m, mod_render_attr_low_from_6l};
wire [7:0] mod_render_x =
    {mod_render_x_high_from_6m, mod_render_x_low_from_6l};
wire b2h_6k_rise = ce_5m && !b2h_6k_d && b2h;
wire [7:0] cls_from_6k;

// Sheet 4A 6K LS273 captures MOD into CLS on B2H. The physical latch boundary
// is now explicit; the simplified renderer still uses direct MOD bytes until
// the downstream 5K/6J adder and 6H latch chain is fully connected.
cloak_74ls273 u_6k_mod_latch (
    .clk    (clk),
    .reset  (reset),
    .clk_en (b2h_6k_rise),
    .d      (mod_render_y),
    .q      (cls_from_6k)
);

wire [7:0] render_sy = 8'd240 - mod_render_y;
wire [7:0] render_sx = mod_render_x;
wire [7:0] render_attr = mod_render_attr;
wire [6:0] render_code = render_attr[6:0];
localparam INVERT_MOTION_FLIPX = 1'b1;
wire       render_flipx = render_attr[7] ^ INVERT_MOTION_FLIPX;
wire [2:0] render_logical_x = {render_pair, 1'b0};
wire [2:0] render_physical_x =
    render_flipx ? (3'd7 - render_logical_x) : render_logical_x;
wire [7:0] render_line_delta = render_y - render_sy;
wire [3:0] render_line = render_line_delta[3:0];
wire       render_match_mame = (render_line_delta[7:4] == 4'd0);

wire [2:0] mopa_x = render_physical_x;
wire [3:0] mopa_line = render_line;
wire b4h_8h_rise = ce_5m && !b4h_8h_d && b4h;
wire [6:0] mopa_high_from_8h = mod_render_attr[6:0];
wire mopa_moflip_from_8h = mod_render_attr[7];
wire moflip = mopa_moflip_from_8h;

// Sheet 4A 6J/5K LS83 add current vertical position to object Y. In hardware
// the source is the 6K CLS latch; direct MOD keeps this step behaviour-equivalent
// until the object scan timing is converted to the real B2H/B4H phases.
wire [7:0] cls_for_5k_6j = mod_render_y;
wire [3:0] sum_from_6j;
wire [3:0] sum_from_5k;
wire       carry_from_6j;
wire       carry_from_5k;

cloak_74ls83 u_6j_motion_y_adder_low (
    .a   (cls_for_5k_6j[3:0]),
    .b   (render_y[3:0]),
    .c0  (1'b0),
    .sum (sum_from_6j),
    .c4  (carry_from_6j)
);

cloak_74ls83 u_5k_motion_y_adder_high (
    .a   (cls_for_5k_6j[7:4]),
    .b   (render_y[7:4]),
    .c0  (carry_from_6j),
    .sum (sum_from_5k),
    .c4  (carry_from_5k)
);

// Sheet 4A 5J LS20 decodes the high adder sum for the vertical match window.
wire match_from_5j_ls20_n = !(sum_from_5k[3] && sum_from_5k[2] &&
                              sum_from_5k[1] && sum_from_5k[0]);
wire match_from_6h = !match_from_5j_ls20_n;
localparam USE_MAME_MOTION_LINE_WINDOW = 1'b0;
wire render_match_active =
    USE_MAME_MOTION_LINE_WINDOW ? render_match_mame : match_from_6h;
wire [3:0] mopa_low_from_6h = sum_from_6j;
wire [5:0] state_from_6h;

cloak_74ls174 u_6h_match_mopa_latch (
    .clk    (clk),
    .reset  (reset),
    .clear_n(1'b1),
    .clk_en (b4h_8h_rise),
    .d      ({match_from_6h, moflip, mopa_low_from_6h}),
    .q      (state_from_6h)
);

wire       match_latched_from_6h = state_from_6h[5];
wire       moflip_latched_from_6h = state_from_6h[4];
wire [3:0] mopa_low_latched_from_6h = state_from_6h[3:0];
wire [7:0] mod_from_8h;

// Sheet 4A 8H LS273: MOD7 latches to MOFLIP, MOD6..0 latch to MOPA11..5.
// The physical latch is explicit, while the simplified renderer keeps using
// direct MOD attributes until all surrounding motion-address timing is modeled.
cloak_74ls273 u_8h_motion_addr_latch (
    .clk    (clk),
    .reset  (reset),
    .clk_en (b4h_8h_rise),
    .d      (mod_render_attr),
    .q      (mod_from_8h)
);

wire [6:0] mopa_high_latched_from_8h = mod_from_8h[6:0];
wire       mopa_moflip_latched_from_8h = mod_from_8h[7];
wire [6:0] mopa_code = mopa_high_from_8h;
wire flipm = moflip || match_from_6h;
wire m14h = moflip || !b4h;

assign motion_video_addr =
    {1'b0, mopa_code, 5'b0} +
    {8'd0, mopa_low_from_6h, 1'b0} +
    (mopa_x[2] ? 13'd1 : 13'd0) +
    (!mopa_x[1] ? 13'h1000 : 13'd0);

// Sheet 4A ROM/shift-register boundary. The two 2532 ROMs and four LS194s
// ultimately present two adjacent 4-bit MBJ pixels from one fetched byte.
wire [15:0] mrom_from_6n_8r = motion_rom_parallel_data;
wire m0 = mrom_from_6n_8r[0];
wire m1 = mrom_from_6n_8r[1];
wire m2 = mrom_from_6n_8r[2];
wire m3 = mrom_from_6n_8r[3];
wire m4 = mrom_from_6n_8r[4];
wire m5 = mrom_from_6n_8r[5];
wire m6 = mrom_from_6n_8r[6];
wire m7 = mrom_from_6n_8r[7];
wire m8 = mrom_from_6n_8r[8];
wire m9 = mrom_from_6n_8r[9];
wire ma_mrom = mrom_from_6n_8r[10];
wire mb_mrom = mrom_from_6n_8r[11];
wire mc_mrom = mrom_from_6n_8r[12];
wire md_mrom = mrom_from_6n_8r[13];
wire me_mrom = mrom_from_6n_8r[14];
wire mf_mrom = mrom_from_6n_8r[15];
wire [3:0] mbj0_shift_q;
wire [3:0] mbj1_shift_q;
wire [3:0] mbj2_shift_q;
wire [3:0] mbj3_shift_q;

// Sheet 4A 6P/6R/7P/7R LS194 group. These are loaded from the parallel
// M0..MF ROM bus; current MBJ behaviour remains on the compatibility path
// until BYTLOAD/FLIP/shift timing is fully traced.
cloak_74ls194 u_6r_mbj0_shift (
    .clk     (clk),
    .reset   (reset),
    .clear_n (1'b1),
    .clk_en  (render_pending),
    .mode    (2'b11),
    .sr      (1'b0),
    .sl      (1'b0),
    .d       ({mc_mrom, m8, m4, m0}),
    .q       (mbj0_shift_q)
);

cloak_74ls194 u_6p_mbj1_shift (
    .clk     (clk),
    .reset   (reset),
    .clear_n (1'b1),
    .clk_en  (render_pending),
    .mode    (2'b11),
    .sr      (1'b0),
    .sl      (1'b0),
    .d       ({md_mrom, m9, m5, m1}),
    .q       (mbj1_shift_q)
);

cloak_74ls194 u_7r_mbj2_shift (
    .clk     (clk),
    .reset   (reset),
    .clear_n (1'b1),
    .clk_en  (render_pending),
    .mode    (2'b11),
    .sr      (1'b0),
    .sl      (1'b0),
    .d       ({me_mrom, ma_mrom, m6, m2}),
    .q       (mbj2_shift_q)
);

cloak_74ls194 u_7p_mbj3_shift (
    .clk     (clk),
    .reset   (reset),
    .clear_n (1'b1),
    .clk_en  (render_pending),
    .mode    (2'b11),
    .sr      (1'b0),
    .sl      (1'b0),
    .d       ({mf_mrom, mb_mrom, m7, m3}),
    .q       (mbj3_shift_q)
);

wire [3:0] mbj_from_ls194 = {
    mbj3_shift_q[3], mbj2_shift_q[3], mbj1_shift_q[3], mbj0_shift_q[3]
};
wire [3:0] mbjf_from_ls194 = {
    mbj3_shift_q[0], mbj2_shift_q[0], mbj1_shift_q[0], mbj0_shift_q[0]
};
wire [3:0] mbj_from_7n;
wire flip_from_11f;
wire flip_n_from_11f;

// Sheet 4A parallel ROM columns before the LS194 shift chain. The compatibility
// renderer below still consumes one selected ROM byte, but the schematic path
// exposes four 4-bit pixels from M0..MF for each MOPA address.
wire [3:0] mrom_parallel_pixel0 = {m3, m2, m1, m0};
wire [3:0] mrom_parallel_pixel1 = {m7, m6, m5, m4};
wire [3:0] mrom_parallel_pixel2 = {mb_mrom, ma_mrom, m9, m8};
wire [3:0] mrom_parallel_pixel3 = {mf_mrom, me_mrom, md_mrom, mc_mrom};
wire [3:0] mrom_parallel_pair_pixel0 =
    mopa_x[1] ? mrom_parallel_pixel2 : mrom_parallel_pixel0;
wire [3:0] mrom_parallel_pair_pixel1 =
    mopa_x[1] ? mrom_parallel_pixel3 : mrom_parallel_pixel1;

// Sheet 4A 7N LS157 selects normal or flipped motion pixel bits. The selected
// bus is named now, but the compatibility path below still drives active video
// until LS194 load/shift timing is fully verified.
cloak_74ls157 u_7n_mbj_flip_select (
    .sel      (flip_from_11f),
    .enable_n (1'b0),
    .a        (mbj_from_ls194),
    .b        (mbjf_from_ls194),
    .y        (mbj_from_7n)
);

wire [3:0] mrom_pixel_low = motion_video_data[3:0];
wire [3:0] mrom_pixel_high = motion_video_data[7:4];

wire [3:0] pending_pixel0 =
    pending_first_high ? mrom_pixel_high : mrom_pixel_low;
wire [3:0] pending_pixel1 =
    pending_first_high ? mrom_pixel_low : mrom_pixel_high;

localparam USE_SCHEMATIC_MOTION_ROM_PIXELS = 1'b0;

// Sheet 4B names: current renderer bypasses the 8K/8M LS157 + 93422 + 9T
// chain, but keep the MBJ/LB boundary visible for the motion-buffer rewrite.
wire [3:0] mbj_pending0 =
    USE_SCHEMATIC_MOTION_ROM_PIXELS ? mrom_parallel_pair_pixel0 : pending_pixel0;
wire [3:0] mbj_pending1 =
    USE_SCHEMATIC_MOTION_ROM_PIXELS ? mrom_parallel_pair_pixel1 : pending_pixel1;
// Sheet 4A 1H/8F LS139 create motion-object hold/read strobes. The simplified
// renderer still treats IV as a line-bank alias, while Sheet 4B 9H VDBH is a
// horizontal pixel-phase selector for the two latched LB nibbles.
wire bytload = render_pending;
wire vdbh = !b1h;
wire iv = display_line_bank;
wire lof = bytload;
wire bytload_rise = ce_5m && !bytload_d && bytload;
wire b8h_7f_rise = ce_5m && !b8h_7f_d && b8h;
wire [3:0] moh_left_decode_n;
wire [3:0] moh_right_decode_n;
wire ivdbh_from_7f;
wire ivdsh_from_7f;

cloak_74ls139 u_1h_moh_left_decode (
    .enable_n (1'b0),
    .sel      ({1'b0, bytload}),
    .y_n      (moh_left_decode_n)
);

cloak_74ls139 u_8f_moh_right_decode (
    .enable_n (!bytload),
    .sel      ({iv, ivdbh_from_7f}),
    .y_n      (moh_right_decode_n)
);

wire mohli_decoded_n = moh_left_decode_n[0];
wire mohlo_decoded_n = moh_left_decode_n[1];
wire mohro_decoded_n = moh_right_decode_n[1];
wire mohri_decoded_n = moh_right_decode_n[2];
wire mohli_n = mohli_decoded_n;
wire mohld_n = mohlo_decoded_n;
wire mohri_n = mohri_decoded_n;
wire mohro_n = mohro_decoded_n;

// Sheet 4A 7F LS74 video timing latch. IVDBH/IVDSH are named here but not yet
// behaviour-driving; exact IV source and clock polarity still need pin tracing.
cloak_74ls74 u_7f_ivdb_latch (
    .clk      (clk),
    .reset    (reset),
    .preset_n (1'b1),
    .clear_n  (1'b1),
    .clk_en   (b8h_7f_rise),
    .d        (iv),
    .q        (ivdbh_from_7f),
    .q_n      (ivdsh_from_7f)
);

// Sheet 4A 11F LS74 latches FLIP from FLIPM on LOF. LOF is currently the
// simplified byte-load phase until the surrounding load/shift timing is traced.
cloak_74ls74 u_11f_flip_latch (
    .clk      (clk),
    .reset    (reset),
    .preset_n (1'b1),
    .clear_n  (1'b1),
    .clk_en   (bytload_rise),
    .d        (flipm),
    .q        (flip_from_11f),
    .q_n      (flip_n_from_11f)
);

wire [3:0] lb0_feedback_for_8k =
    display_line_bank ? sprite_line0[pending_sx + pending_x] :
                        sprite_line1[pending_sx + pending_x];
wire [3:0] lb1_feedback_for_8m =
    display_line_bank ? sprite_line0[pending_sx + pending_x + 1'd1] :
                        sprite_line1[pending_sx + pending_x + 1'd1];
wire [3:0] motion_buffer_data_from_8k;
wire [3:0] motion_buffer_data_from_8m;
wire [3:0] motion_buffer_left_ram_data;
wire [3:0] motion_buffer_right_ram_data;
wire [7:0] motion_buffer_left_addr_from_7j_7k;
wire [7:0] motion_buffer_right_addr_from_7l_7m;
wire [7:0] motion_buffer_display_read_addr = hcnt[7:0];
wire [7:0] motion_buffer_left_ram_write_addr;
wire [7:0] motion_buffer_right_ram_write_addr;
wire [7:0] motion_buffer_left_load_addr =
    pending_sx + {5'd0, pending_x};
wire [7:0] motion_buffer_right_load_addr =
    pending_sx + {5'd0, pending_x} + 8'd1;
wire       motion_buffer_left_low_ripple;
wire       motion_buffer_left_high_ripple;
wire       motion_buffer_right_low_ripple;
wire       motion_buffer_right_high_ripple;
wire       motion_buffer_left_load_n = mohlo_decoded_n;
wire       motion_buffer_left_clear_n = mohro_decoded_n;
wire       motion_buffer_right_load_n = mohli_decoded_n;
wire       motion_buffer_right_clear_n = mohri_decoded_n;
wire       motion_buffer_counter_count = 1'b1;
wire [3:0] lb0_from_8j;
wire [3:0] lb1_from_8l;
wire [3:0] lb0_from_8j_bank0;
wire [3:0] lb0_from_8j_bank1;
wire [3:0] lb1_from_8l_bank0;
wire [3:0] lb1_from_8l_bank1;
wire [7:0] lb_from_9t;
wire [3:0] lb0_from_9t;
wire [3:0] lb1_from_9t;
wire [3:0] mbit_from_9h;
wire motion_buffer_render_write = render_pending;
wire motion_buffer_clear_write = ce_5m && !hblank;
wire motion_buffer_write = motion_buffer_render_write || motion_buffer_clear_write;
wire motion_buffer_write_n = !motion_buffer_write;
wire motion_buffer_cs1_n = 1'b0;
wire motion_buffer_cs2_n = 1'b0;
wire motion_buffer_oe_n = 1'b0;
wire lb_latch_clk_en = bsm;
wire motion_buffer_read_bank = display_line_bank;
wire motion_buffer_write_bank = !display_line_bank;
wire motion_buffer_bank0_write_n =
    !(motion_buffer_write && !motion_buffer_write_bank);
wire motion_buffer_bank1_write_n =
    !(motion_buffer_write && motion_buffer_write_bank);

// FPGA bridge: preserve the compatibility line-buffer lifetime while the
// single-address 93422 timing is still being traced from the schematic.
assign motion_buffer_left_ram_write_addr =
    motion_buffer_render_write ? motion_buffer_left_load_addr :
                                 motion_buffer_display_read_addr;
assign motion_buffer_right_ram_write_addr =
    motion_buffer_render_write ? motion_buffer_right_load_addr :
                                 motion_buffer_display_read_addr;
assign motion_buffer_left_ram_data =
    motion_buffer_render_write ? motion_buffer_data_from_8k : 4'd0;
assign motion_buffer_right_ram_data =
    motion_buffer_render_write ? motion_buffer_data_from_8m : 4'd0;
assign lb0_from_8j =
    motion_buffer_read_bank ? lb0_from_8j_bank1 : lb0_from_8j_bank0;
assign lb1_from_8l =
    motion_buffer_read_bank ? lb1_from_8l_bank1 : lb1_from_8l_bank0;

// Sheet 4B 8K/8M LS157 select fresh MBJ pixels or line-buffer feedback before
// writing the 93422 motion buffers. Current sprite_line writes still use the
// compatibility path until the 93422 counters/RAMs are structurally present.
cloak_74ls157 u_8k_motion_buffer_data_mux (
    .sel      (ivdsh_from_7f),
    .enable_n (1'b0),
    .a        (mbj_pending0),
    .b        (lb0_feedback_for_8k),
    .y        (motion_buffer_data_from_8k)
);

cloak_74ls157 u_8m_motion_buffer_data_mux (
    .sel      (ivdbh_from_7f),
    .enable_n (1'b0),
    .a        (mbj_pending1),
    .b        (lb1_feedback_for_8m),
    .y        (motion_buffer_data_from_8m)
);

// Sheet 4B 7J/7K/7L/7M LS163A counters produce the 93422 buffer addresses.
// These are provisionally loaded from the same two-pixel X positions used by
// the temporary renderer; visible pixels still use direct array indexes.
cloak_74ls163 u_7j_motion_buffer_left_low_counter (
    .clk     (clk),
    .reset   (reset),
    .clk_en  (bsm),
    .clear_n (motion_buffer_left_clear_n),
    .load_n  (motion_buffer_left_load_n),
    .enp     (motion_buffer_counter_count),
    .ent     (1'b1),
    .d       (motion_buffer_left_load_addr[3:0]),
    .q       (motion_buffer_left_addr_from_7j_7k[3:0]),
    .ripple  (motion_buffer_left_low_ripple)
);

cloak_74ls163 u_7k_motion_buffer_left_high_counter (
    .clk     (clk),
    .reset   (reset),
    .clk_en  (bsm),
    .clear_n (motion_buffer_left_clear_n),
    .load_n  (motion_buffer_left_load_n),
    .enp     (motion_buffer_counter_count),
    .ent     (motion_buffer_left_low_ripple),
    .d       (motion_buffer_left_load_addr[7:4]),
    .q       (motion_buffer_left_addr_from_7j_7k[7:4]),
    .ripple  (motion_buffer_left_high_ripple)
);

cloak_74ls163 u_7l_motion_buffer_right_low_counter (
    .clk     (clk),
    .reset   (reset),
    .clk_en  (bsm),
    .clear_n (motion_buffer_right_clear_n),
    .load_n  (motion_buffer_right_load_n),
    .enp     (motion_buffer_counter_count),
    .ent     (1'b1),
    .d       (motion_buffer_right_load_addr[3:0]),
    .q       (motion_buffer_right_addr_from_7l_7m[3:0]),
    .ripple  (motion_buffer_right_low_ripple)
);

cloak_74ls163 u_7m_motion_buffer_right_high_counter (
    .clk     (clk),
    .reset   (reset),
    .clk_en  (bsm),
    .clear_n (motion_buffer_right_clear_n),
    .load_n  (motion_buffer_right_load_n),
    .enp     (motion_buffer_counter_count),
    .ent     (motion_buffer_right_low_ripple),
    .d       (motion_buffer_right_load_addr[7:4]),
    .q       (motion_buffer_right_addr_from_7l_7m[7:4]),
    .ripple  (motion_buffer_right_high_ripple)
);

// Sheet 4B 8J/8L 93422 motion-object buffer RAMs. The temporary renderer is
// still line-banked, so the FPGA bridge keeps two banks per schematic RAM until
// the real one-address scan/write timing can replace this compatibility aid.
cloak_93422 u_8j_motion_buffer_left_ram_bank0 (
    .clk      (clk),
    .write_addr(motion_buffer_left_ram_write_addr),
    .read_addr (motion_buffer_display_read_addr),
    .data_in  (motion_buffer_left_ram_data),
    .we_n     (motion_buffer_bank0_write_n),
    .cs1_n    (motion_buffer_cs1_n),
    .cs2_n    (motion_buffer_cs2_n),
    .oe_n     (motion_buffer_oe_n),
    .data_out (lb0_from_8j_bank0)
);

cloak_93422 u_8j_motion_buffer_left_ram_bank1 (
    .clk      (clk),
    .write_addr(motion_buffer_left_ram_write_addr),
    .read_addr (motion_buffer_display_read_addr),
    .data_in  (motion_buffer_left_ram_data),
    .we_n     (motion_buffer_bank1_write_n),
    .cs1_n    (motion_buffer_cs1_n),
    .cs2_n    (motion_buffer_cs2_n),
    .oe_n     (motion_buffer_oe_n),
    .data_out (lb0_from_8j_bank1)
);

cloak_93422 u_8l_motion_buffer_right_ram_bank0 (
    .clk      (clk),
    .write_addr(motion_buffer_right_ram_write_addr),
    .read_addr (motion_buffer_display_read_addr),
    .data_in  (motion_buffer_right_ram_data),
    .we_n     (motion_buffer_bank0_write_n),
    .cs1_n    (motion_buffer_cs1_n),
    .cs2_n    (motion_buffer_cs2_n),
    .oe_n     (motion_buffer_oe_n),
    .data_out (lb1_from_8l_bank0)
);

cloak_93422 u_8l_motion_buffer_right_ram_bank1 (
    .clk      (clk),
    .write_addr(motion_buffer_right_ram_write_addr),
    .read_addr (motion_buffer_display_read_addr),
    .data_in  (motion_buffer_right_ram_data),
    .we_n     (motion_buffer_bank1_write_n),
    .cs1_n    (motion_buffer_cs1_n),
    .cs2_n    (motion_buffer_cs2_n),
    .oe_n     (motion_buffer_oe_n),
    .data_out (lb1_from_8l_bank1)
);

// Sheet 4B 9T LS273 latches the two line-buffer nibbles into LB00..LB13 on BSM.
cloak_74ls273 u_9t_line_buffer_latch (
    .clk    (clk),
    .reset  (reset),
    .clk_en (lb_latch_clk_en),
    .d      ({lb1_from_8l, lb0_from_8j}),
    .q      (lb_from_9t)
);

assign lb0_from_9t = lb_from_9t[3:0];
assign lb1_from_9t = lb_from_9t[7:4];

// Sheet 4B 9H LS157 selects the final motion bits. The selected output is
// named here; visible video still uses the compatibility mbit path below.
cloak_74ls157 u_9h_mbit_select (
    .sel      (vdbh),
    .enable_n (1'b0),
    .a        (lb0_from_9t),
    .b        (lb1_from_9t),
    .y        (mbit_from_9h)
);

always_ff @(posedge clk) begin
    if (reset) begin
        display_line_bank <= 0;
        render_active <= 0;
        render_sprite <= 63;
        render_pair <= 0;
        render_pending <= 0;
        b2h_6k_d <= 0;
        b4h_8h_d <= 0;
        b8h_7f_d <= 0;
        bytload_d <= 0;
    end else begin
        if (ce_5m) b2h_6k_d <= b2h;
        if (ce_5m) b4h_8h_d <= b4h;
        if (ce_5m) b8h_7f_d <= b8h;
        if (ce_5m) bytload_d <= bytload;

        if (ce_5m && !hblank) begin
            if (display_line_bank) sprite_line0[hcnt[7:0]] <= 0;
            else                   sprite_line1[hcnt[7:0]] <= 0;
        end

        if (ce_5m && hcnt == 9'd256) begin
            render_active <= 1;
            render_sprite <= 63;
            render_pair <= 0;
            render_pending <= 0;
            render_y <= (vcnt == 9'd261) ? 8'd0 : vcnt[7:0] + 1'd1;
        end

        if (render_pending) begin
            if (pending_pixel0 != 0) begin
                if (display_line_bank)
                    sprite_line0[pending_sx + pending_x] <= mbj_pending0;
                else
                    sprite_line1[pending_sx + pending_x] <= mbj_pending0;
            end
            if (pending_pixel1 != 0) begin
                if (display_line_bank)
                    sprite_line0[pending_sx + pending_x + 1'd1] <= mbj_pending1;
                else
                    sprite_line1[pending_sx + pending_x + 1'd1] <= mbj_pending1;
            end
        end

        render_pending <= render_active && render_match_active;
        if (render_active) begin
            pending_sx <= render_sx;
            pending_x <= render_logical_x;
            pending_first_high <= mopa_x[0];

            if (render_pair == 2'd3) begin
                render_pair <= 2'd0;
                if (render_sprite == 6'd0) render_active <= 0;
                else render_sprite <= render_sprite - 1'd1;
            end else render_pair <= render_pair + 1'd1;
        end

        if (ce_5m && hcnt == 9'd319) display_line_bank <= ~display_line_bank;
    end
end

wire [3:0] dra_video = bmp0_vid_q;
wire [3:0] drb_video = bmp1_vid_q;
wire [3:0] bmap = bitmap_select ? dra_video : drb_video;
wire [3:0] lb_display = display_line_bank ?
                         sprite_line1[hcnt[7:0]] : sprite_line0[hcnt[7:0]];
wire [3:0] mbit_compat = lb_display;
wire [3:0] mbit_schematic = mbit_from_9h;
reg [3:0] mbit_schematic_d1;
reg [3:0] mbit_schematic_d2;
reg [3:0] mbit_schematic_d3;
localparam integer SCHEMATIC_MOTION_BUFFER_PHASE = 2;
wire [3:0] mbit_schematic_phase =
    SCHEMATIC_MOTION_BUFFER_PHASE == 3 ? mbit_schematic_d3 :
    SCHEMATIC_MOTION_BUFFER_PHASE == 2 ? mbit_schematic_d2 :
    SCHEMATIC_MOTION_BUFFER_PHASE == 1 ? mbit_schematic_d1 :
                                         mbit_schematic;
localparam USE_SCHEMATIC_MOTION_BUFFER = 1'b0;
wire [3:0] mbit =
    USE_SCHEMATIC_MOTION_BUFFER ? mbit_schematic_phase : mbit_compat;

always_ff @(posedge clk) begin
    if (reset) begin
        mbit_schematic_d1 <= 4'd0;
        mbit_schematic_d2 <= 4'd0;
        mbit_schematic_d3 <= 4'd0;
    end else if (ce_5m) begin
        mbit_schematic_d1 <= mbit_schematic;
        mbit_schematic_d2 <= mbit_schematic_d1;
        mbit_schematic_d3 <= mbit_schematic_d2;
    end
end

wire mbit_opaque = mbit != 0;
wire bmap_opaque = bmap[2:0] != 0;
wire [1:0] video_9k_nor_y;
wire [2:0] video_1l_nor_y;
wire [5:0] video_8c_inv_y;
wire [3:0] video_8d_or_y;
wire [3:0] video_8e_nand_y;
wire colram_n = !colram;
wire mbit_none_from_9k = video_9k_nor_y[0];
wire mbit_any_from_8c = video_8c_inv_y[0];
wire bmap_none_from_1l = video_1l_nor_y[0];
wire bmap_or_mbit_from_8d = video_8d_or_y[0];
wire colsel1_from_8e = video_8e_nand_y[0];
wire colsel0_from_8e = video_8e_nand_y[1];
wire [1:0] colsel_from_gates = {colsel1_from_8e, colsel0_from_8e};
wire [3:0] cola_low_from_10h_10j;
wire [3:0] cola_high_mux_from_11j;
wire [1:0] cola_high_from_11j;
wire [5:0] cola_from_mux_tree = {cola_high_from_11j, cola_low_from_10h_10j};

// Sheet 4B COLSEL gate chain. 9K detects absence of motion pixels, 1L detects
// absence of bitmap pixels, and 8C/8D/8E generate the LS153 source selects.
cloak_74ls260 u_9k_mbit_zero_nor (
    .a ({1'b0, mbit[3]}),
    .b ({1'b0, mbit[2]}),
    .c ({1'b0, mbit[1]}),
    .d ({1'b0, mbit[0]}),
    .e (2'b00),
    .y (video_9k_nor_y)
);

cloak_74ls27 u_1l_bmap_zero_nor (
    .a ({2'b00, bmap[2]}),
    .b ({2'b00, bmap[1]}),
    .c ({2'b00, bmap[0]}),
    .y (video_1l_nor_y)
);

cloak_74ls04 u_8c_mbit_zero_inverter (
    .a ({5'b00000, mbit_none_from_9k}),
    .y (video_8c_inv_y)
);

cloak_74ls32 u_8d_colsel0_or (
    .a ({3'b000, mbit_any_from_8c}),
    .b ({3'b000, bmap_none_from_1l}),
    .y (video_8d_or_y)
);

cloak_74ls00 u_8e_colsel_nands (
    .a ({2'b00, bmap_or_mbit_from_8d, mbit_none_from_9k}),
    .b ({2'b00, colram_n, colram_n}),
    .y (video_8e_nand_y)
);

// Sheet 4B 10H/10J LS153 pair selects COLA0..COLA3 from playfield, bitmap,
// motion, or CPU address bits.
cloak_74ls153 u_10j_cola1_cola0_mux (
    .sel       (colsel_from_gates),
    .enable1_n (1'b0),
    .enable2_n (1'b0),
    .c1        ({ma[1], mbit[1], bmap[1], pbit[1]}),
    .c2        ({ma[0], mbit[0], bmap[0], pbit[0]}),
    .y1        (cola_low_from_10h_10j[1]),
    .y2        (cola_low_from_10h_10j[0])
);

cloak_74ls153 u_10h_cola3_cola2_mux (
    .sel       (colsel_from_gates),
    .enable1_n (1'b0),
    .enable2_n (1'b0),
    .c1        ({ma[3], mbit[3], bmap[3], pbit[3]}),
    .c2        ({ma[2], mbit[2], bmap[2], pbit[2]}),
    .y1        (cola_low_from_10h_10j[3]),
    .y2        (cola_low_from_10h_10j[2])
);

// Sheet 4B 11J LS157 selects high color address bits. When COLRAM is active,
// CPU PABA4/5 address the palette RAM; otherwise COLSEL0/1 choose the source
// bank selected by the final video mux tree.
cloak_74ls157 u_11j_cola5_cola4_mux (
    .sel      (colram),
    .enable_n (1'b0),
    .a        ({2'b00, colsel_from_gates}),
    .b        ({2'b00, ma[5:4]}),
    .y        (cola_high_mux_from_11j)
);

assign cola_high_from_11j = cola_high_mux_from_11j[1:0];
wire [5:0] cola_video_from_mux_tree = cola_from_mux_tree;
wire [8:0] palette_word_from_cola = palette_ram[cola_video_from_mux_tree];

localparam USE_SCHEMATIC_COLOR_MUX = 1'b1;

wire [5:0] palette_index_compat =
    mbit_opaque ? {2'b10, mbit} :
    bmap_opaque ? {2'b01, bitmap_video_addr[7], bmap[2:0]} :
                  {2'b00, pbit};
wire [5:0] palette_index_schematic = cola_video_from_mux_tree;
wire [5:0] palette_index =
    USE_SCHEMATIC_COLOR_MUX ? palette_index_schematic : palette_index_compat;

wire [8:0] palette_word = palette_ram[palette_index];
wire bhblank_n_to_4j = !bhblank;
wire bvblank_n_to_4j = !bvblank;
wire [3:0] video_4j_blank_and_y;
wire blank_n_from_4j = video_4j_blank_and_y[0];
wire blank_from_9j = !blank_n_from_4j;
wire [8:0] color_ram_outputs = palette_word;
wire [8:0] color_ram_inverted_outputs = ~color_ram_outputs;
wire [5:0] cr_latch_low_q;
wire [5:0] cr_latch_high_q;
wire [8:0] cr_latched_outputs = {
    cr_latch_high_q[2:0],
    cr_latch_low_q[5:0]
};

// Sheet 5A 4J LS08 combines active-low HBLANK and BVBLANK into active-low
// BLANK, which clears the 10L/10K/10J color latches.
cloak_74ls08 u_4j_video_blank_and (
    .a ({3'b000, bhblank_n_to_4j}),
    .b ({3'b000, bvblank_n_to_4j}),
    .y (video_4j_blank_and_y)
);

// Sheet 5A 10L/10K/10J LS174 color output latch boundary. The PCB clears these
// latches with active-low BLANK and drives the analog ladders from inverted CR
// nodes after the color RAM outputs.
cloak_74ls174 u_10l_10k_color_latch_low (
    .clk    (clk),
    .reset  (reset),
    .clear_n(blank_n_from_4j),
    .clk_en (ce_5m),
    .d      (color_ram_inverted_outputs[5:0]),
    .q      (cr_latch_low_q)
);

cloak_74ls174 u_10j_color_latch_high (
    .clk    (clk),
    .reset  (reset),
    .clear_n(blank_n_from_4j),
    .clk_en (ce_5m),
    .d      ({3'd0, color_ram_inverted_outputs[8:6]}),
    .q      (cr_latch_high_q)
);

localparam USE_SCHEMATIC_COLOR_LATCH = 1'b1;

wire [8:0] rgb_bits_compat = ~palette_word;
wire [8:0] rgb_bits_schematic = cr_latched_outputs;
wire [8:0] rgb_bits =
    USE_SCHEMATIC_COLOR_LATCH ? rgb_bits_schematic : rgb_bits_compat;

wire [2:0] pr = rgb_bits[8:6];
wire [2:0] pg = rgb_bits[5:3];
wire [2:0] pb = rgb_bits[2:0];
wire active_video = !hblank && !vblank;
assign red   = active_video ? {pr, pr, pr[2:1]} : 8'd0;
assign green = active_video ? {pg, pg, pg[2:1]} : 8'd0;
assign blue  = active_video ? {pb, pb, pb[2:1]} : 8'd0;

wire _unused = &{
    1'b0, sync_prom[0][0],
    m_custom_write_cs, m_watchdog_cs, m_nvram_enable_cs,
    m_coin_counter_r_cs, m_coin_counter_l_cs, m_cocktail_out_cs,
    m_start2_led_cs, m_start1_led_cs,
    s_custom_write_cs, pbmem, bufsel, clrram,
    customwr_n_from_decode, custom_21m_cus_fallback, custom_21m_cus,
    custom_21m_bvblank, custom_21m_b256h,
    bvblank_from_21m, b256h_from_21m,
    bvblank_21m_matches_active, b256h_21m_matches_active,
    active_hsync, active_vsync,
    prom_frame_origin_vsync, prom_frame_origin_vsync_n,
    prom_frame_origin_compsync,
    sync_4d_xor_y, sync_4b_inv_y,
    sync_4d_xor_4n_y, sync_4b_inv_4n_y,
    compsync_from_4b, vsync_from_4b,
    compsync_from_4b_4n, vsync_from_4b_4n,
    cusa_from_21m, cusb_from_21m, cusc_from_21m, cusd_from_21m,
    cuse_from_21m, cusf_from_21m, cusg_from_21m, cush_from_21m,
    pfp_from_4k, char_rom_parallel_data,
    pf_3f_and_y, pf_ldf_from_11f, pf_ldnib_from_11f,
    pf_10e_inv_y, pf_10d_nand_y,
    pf_45e_inv_y, pf_45f_nand_y, pf_ls194_mode_from_45f,
    pf_shift_clk_en, pf_blank_clear_n,
    pbit_n_from_ls194, pbit_f_from_ls194, pbit_from_4n,
    pbit_compat_d1, pbit_compat_d2,
    pf_pbit_compare_now_xor, pf_pbit_compare_d1_xor, pf_pbit_compare_d2_xor,
    pf_pbit_compare_now_match, pf_pbit_compare_d1_match,
    pf_pbit_compare_d2_match,
    coin_counter_r, coin_counter_l, cocktail_out, start2_led, start1_led,
    b256h, bvblank, bhblank, bblank, b5m,
    h4ss, h8ss, h16ss, h32ss, h64ss, h128ss,
    sync_xor_common_from_6p, sync_6p_low_xor_y, sync_6p_high_xor_y,
    sync_10e_inv_y, h4ss_from_10e_6p, h8ss_from_6p, h16ss_from_6p,
    h32ss_from_6p, h64ss_from_6p, h128ss_from_6p,
    hblank_3b_first_q, hblank_3b_first_q_n,
    hblank_3b_second_q, hblank_3b_second_q_n,
    hblank_3b_second_q_rise,
    hblank_from_3c_latched, hblank_n_from_3c_latched,
    e1h, e2h, e4h, e8h, e16h, e32h, e256h, evblank, ehblank,
    vertical_prom_data[7:4],
    prom_o1_pre, prom_o2_pre, prom_o3_pre, prom_o4_pre,
    b256h_rise,
    prom_vsync_registered, prom_vblank_registered,
    prom_hblank_registered, prom_256h_registered,
    sync_4n_q1_n_pin3, sync_4n_q2_n_pin6,
    vsync_n_from_4n, vblank_n_from_4n,
    b1h_rise, ras_n, cas_n, row, selrow, dr0_n, dr1_n, dr2_n, dr3_n,
    cusd_from_timing, cuse_from_timing, cusf_from_timing,
    cusg_from_timing, cush_from_timing, prt_from_timing,
    param_n_from_decode, pawrite_n,
    pf_5f_or_y, pf_4j_and_y, pf_9f_and_y, pf_5h_nor_y, pf_8f_nand_y,
    pf_ram_cs_from_4j, pf_ram_write_phase_from_9f,
    pf_ram_write_select_from_5h, pf_ram_we_from_8f,
    pf_ram_we_active_from_8f,
    pfd_from_45h, pabd_from_45h, pfd_buffer_enable_n,
    bdel2h_n_from_7h, pfa_bdel2h_provisional,
    pfa_low_from_3m, pfa_mid_from_3l_3m, pfa_high_from_3n_3l,
    pfa_from_3n_3l_3m,
    playfield_4lm_cpu_q, playfield_4lm_video_q,
    moa_cpu_mux, moa_render_mux, render_code, cls_from_6k,
    USE_SCHEMATIC_MOTION_ROM_PIXELS,
    mbj_from_7n,
    mrom_parallel_pair_pixel0, mrom_parallel_pair_pixel1,
    mopa_line, carry_from_5k, render_line_delta, mopa_low_from_6h,
    mopa_high_latched_from_8h,
    mopa_moflip_latched_from_8h, match_latched_from_6h,
    moflip_latched_from_6h, mopa_low_latched_from_6h, flipm, m14h,
    lof, ivdbh_from_7f, ivdsh_from_7f, flip_from_11f, flip_n_from_11f,
    motion_buffer_data_from_8k, motion_buffer_data_from_8m,
    motion_buffer_left_addr_from_7j_7k, motion_buffer_right_addr_from_7l_7m,
    motion_buffer_display_read_addr,
    lb0_from_8j, lb1_from_8l, lb0_from_9t, lb1_from_9t, mbit_from_9h,
    motion_buffer_left_high_ripple, motion_buffer_right_high_ripple,
    mohro_decoded_n, mohri_decoded_n, moh_left_decode_n[3:2],
    moh_right_decode_n[3:2],
    video_9k_nor_y, video_1l_nor_y, video_8c_inv_y,
    video_8d_or_y, video_8e_nand_y,
    mbit_none_from_9k, mbit_any_from_8c, bmap_none_from_1l,
    bmap_or_mbit_from_8d, colsel_from_gates, cola_video_from_mux_tree,
    palette_word_from_cola, colram_bit8_from_paba6, colram_write_from_8d,
    bhblank_n_to_4j, bvblank_n_to_4j, video_4j_blank_and_y,
    blank_from_9j, blank_n_from_4j, cr_latched_outputs,
    graph_inv, x_counter_load, y_counter_load,
    x_counter_count_en, y_counter_count_en,
    x_counter_count_up, y_counter_count_up, xy_counter_count,
    pbba0_graph, pbba1_graph, pbba2_graph, dram_decode_n, dram_counter_access,
    xl_counter_q, xh_counter_q, yl_counter_q, yh_counter_q,
    xl_counter_d, xh_counter_d, yl_counter_d, yh_counter_d,
    xl_counter_tc, yl_counter_tc, xh_counter_tc, yh_counter_tc,
    xl_counter_tc_n, yl_counter_tc_n, xh_counter_tc_n, yh_counter_tc_n,
    xh_counter_count_en, yh_counter_count_en,
    xl_load_n, xh_load_n, yl_load_n, yh_load_n,
    xl_enp_n, xl_ent_n, xh_enp_n, xh_ent_n,
    yl_enp_n, yl_ent_n, yh_enp_n, yh_ent_n,
    u_5h_ld_n, u_5h_enp_n, u_5h_ent_n, u_5h_ud, u_5h_p, u_5h_q, u_5h_tc,
    u_4h_ld_n, u_4h_enp_n, u_4h_ent_n, u_4h_ud, u_4h_p, u_4h_q, u_4h_tc,
    u_5j_ld_n, u_5j_enp_n, u_5j_ent_n, u_5j_ud, u_5j_p, u_5j_q, u_5j_tc,
    u_4j_ld_n, u_4j_enp_n, u_4j_ent_n, u_4j_ud, u_4j_p, u_4j_q, u_4j_tc,
    dradr_cpu_mux, dradr_video_mux, dradr_mux,
    moflip, mohld_n, mohli_n, mohri_n, mohro_n, pfa_video[10], wra, wrb
};

endmodule
