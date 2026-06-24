module cloak_core (
    input             clk,
    input             reset,
    input      [15:0] joystick_0,
    input      [15:0] joystick_1,
    input             coin,
    input             service,
    input             start1,
    input             start2,
    input             test,
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

assign hblank = (hcnt >= 9'd256);
assign vblank = (vcnt < 9'd24) || (vcnt >= 9'd256);
assign hsync  = ~((hcnt >= 9'd272) && (hcnt < 9'd304));
assign vsync  = ~((vcnt >= 9'd0) && (vcnt < 9'd3));

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

        if (ce_main && !mrw && ma == 16'h3C00) main_irq_n <= 1'b1;
        if (ce_slave && !srw && sa == 16'h1000) slave_irq_n <= 1'b1;
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

wire char_download_we =
    ioctl_wr && ioctl_index == 0 &&
    ioctl_addr >= 25'h1A000 && ioctl_addr < 25'h1C000;
wire motion_download_we =
    ioctl_wr && ioctl_index == 0 &&
    ioctl_addr >= 25'h1C000 && ioctl_addr < 25'h1E000;

wire [12:0] char_download_addr = ioctl_addr[12:0];
wire [12:0] motion_download_addr = ioctl_addr[12:0];
wire [12:0] char_video_addr;
wire [12:0] motion_video_addr;
wire [7:0] char_video_data;
wire [7:0] motion_video_data;

cloak_gfx_rom char_graphics (
    .clk(clk),
    .download_addr(char_download_addr),
    .download_data(ioctl_data),
    .download_we(char_download_we),
    .video_addr(char_video_addr),
    .video_data(char_video_data)
);

cloak_gfx_rom motion_graphics (
    .clk(clk),
    .download_addr(motion_download_addr),
    .download_data(ioctl_data),
    .download_we(motion_download_we),
    .video_addr(motion_video_addr),
    .video_data(motion_video_data)
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

reg [7:0] motion_ram[0:255];
reg [8:0] palette_ram[0:6'h3F];

wire [7:0] main_ram_q;
wire [7:0] playfield_cpu_q;
wire [7:0] playfield_video_q;
wire [7:0] shared_main_q;
wire [7:0] shared_slave_q;
wire [7:0] nvram_q;
wire [7:0] slave_ram_q;

wire m_main_ram_cs = ma < 16'h0400;
wire m_play_cs     = ma >= 16'h0400 && ma < 16'h0800;
wire m_shared_cs   = ma >= 16'h0800 && ma < 16'h1000;
wire m_pokey1_cs   = ma >= 16'h1000 && ma < 16'h1010;
wire m_pokey2_cs   = ma >= 16'h1800 && ma < 16'h1810;
wire m_nvram_cs    = ma >= 16'h2800 && ma < 16'h2A00;
wire m_motion_cs   = ma >= 16'h3000 && ma < 16'h3100;
wire m_palette_cs  = ma >= 16'h3200 && ma < 16'h3280;
wire m_rom_cs      = ma >= 16'h4000;

wire s_local_cs    = sa < 16'h0800;
wire s_shared_cs   = sa >= 16'h0800 && sa < 16'h1000;
wire s_graph_cs    = sa >= 16'h0008 && sa < 16'h0010;
wire s_rom_cs      = sa >= 16'h2000;

wire [9:0] playfield_video_addr = {vcnt[7:3], hcnt[7:3]};

cloak_tdp_ram #(.AW(10), .DW(8)) main_work_ram (
    .clk(clk),
    .a_addr(ma[9:0]), .a_din(mdo),
    .a_we(ce_main && !mrw && m_main_ram_cs), .a_dout(main_ram_q),
    .b_addr(10'd0), .b_din(8'd0), .b_we(1'b0), .b_dout()
);

cloak_tdp_ram #(.AW(10), .DW(8)) playfield_ram (
    .clk(clk),
    .a_addr(ma[9:0]), .a_din(mdo),
    .a_we(ce_main && !mrw && m_play_cs), .a_dout(playfield_cpu_q),
    .b_addr(playfield_video_addr), .b_din(8'd0),
    .b_we(1'b0), .b_dout(playfield_video_q)
);

cloak_tdp_ram #(.AW(11), .DW(8)) communication_ram (
    .clk(clk),
    .a_addr(ma[10:0]), .a_din(mdo),
    .a_we(ce_main && !mrw && m_shared_cs), .a_dout(shared_main_q),
    .b_addr(sa[10:0]), .b_din(sdo),
    .b_we(ce_slave && !srw && s_shared_cs), .b_dout(shared_slave_q)
);

cloak_tdp_ram #(.AW(9), .DW(8)) nonvolatile_ram (
    .clk(clk),
    .a_addr(ma[8:0]), .a_din(mdo),
    .a_we(ce_main && !mrw && m_nvram_cs), .a_dout(nvram_q),
    .b_addr(9'd0), .b_din(8'd0), .b_we(1'b0), .b_dout()
);

cloak_tdp_ram #(.AW(11), .DW(8)) slave_work_ram (
    .clk(clk),
    .a_addr(sa[10:0]), .a_din(sdo),
    .a_we(ce_slave && !srw && s_local_cs && !s_graph_cs),
    .a_dout(slave_ram_q),
    .b_addr(11'd0), .b_din(8'd0), .b_we(1'b0), .b_dout()
);

reg bitmap_select;
reg bitmap_clear;
reg [15:0] clear_addr;
reg [7:0] bitmap_x;
reg [7:0] bitmap_y;

wire [15:0] graph_addr = {bitmap_y, bitmap_x};
wire [3:0] bmp0_cpu_q;
wire [3:0] bmp1_cpu_q;
wire [3:0] bmp0_vid_q;
wire [3:0] bmp1_vid_q;
wire [15:0] bitmap_video_addr = {vcnt[7:0], hcnt[7:0] + 8'd7};

wire bmp_write = ce_slave && !srw && s_graph_cs && sa[2:0] != 3 && sa[2:0] != 7;
wire [15:0] bmp_cpu_addr = bitmap_clear ? clear_addr : graph_addr;
wire bmp0_we = bitmap_clear ? !bitmap_select : (bmp_write && !bitmap_select);
wire bmp1_we = bitmap_clear ?  bitmap_select : (bmp_write &&  bitmap_select);

cloak_dpram #(.AW(16), .DW(4)) bitmap0 (
    .clk(clk), .a_addr(bmp_cpu_addr), .a_din(bitmap_clear ? 4'd0 : sdo[3:0]),
    .a_we(bmp0_we), .a_dout(bmp0_cpu_q),
    .b_addr(bitmap_video_addr), .b_dout(bmp0_vid_q)
);

cloak_dpram #(.AW(16), .DW(4)) bitmap1 (
    .clk(clk), .a_addr(bmp_cpu_addr), .a_din(bitmap_clear ? 4'd0 : sdo[3:0]),
    .a_we(bmp1_we), .a_dout(bmp1_cpu_q),
    .b_addr(bitmap_video_addr), .b_dout(bmp1_vid_q)
);

task automatic adjust_bitmap(input [2:0] offset);
begin
    case (offset)
        3'h0: begin bitmap_x <= bitmap_x - 1'd1; bitmap_y <= bitmap_y + 1'd1; end
        3'h1: bitmap_y <= bitmap_y - 1'd1;
        3'h2: bitmap_x <= bitmap_x - 1'd1;
        3'h4: begin bitmap_x <= bitmap_x + 1'd1; bitmap_y <= bitmap_y + 1'd1; end
        3'h5: bitmap_y <= bitmap_y + 1'd1;
        3'h6: bitmap_x <= bitmap_x + 1'd1;
        default: ;
    endcase
end
endtask

integer i;
always_ff @(posedge clk) begin
    if (reset) begin
        bitmap_select <= 0;
        bitmap_clear <= 0;
        clear_addr <= 0;
        bitmap_x <= 0;
        bitmap_y <= 0;
        for (i = 0; i < 64; i = i + 1) palette_ram[i] <= 9'h1FF;
    end else begin
        if (bitmap_clear) begin
            clear_addr <= clear_addr + 1'd1;
            if (clear_addr == 16'hFFFF) bitmap_clear <= 0;
        end

        if (ce_main && !mrw) begin
            if (m_motion_cs) motion_ram[ma[7:0]] <= mdo;
            if (m_palette_cs)
                palette_ram[ma[5:0]] <= {ma[6], mdo};
        end

        if (ce_slave && !srw) begin
            if (s_graph_cs) begin
                if (sa[2:0] == 3) bitmap_x <= sdo;
                else if (sa[2:0] == 7) bitmap_y <= sdo;
                else adjust_bitmap(sa[2:0]);
            end

            if (sa == 16'h1200) begin
                bitmap_select <= sdo[0];
                if (sdo[1]) begin
                    bitmap_clear <= 1;
                    clear_addr <= 0;
                end
            end
        end

        if (ce_slave && srw && s_graph_cs) adjust_bitmap(sa[2:0]);
    end
end

// -------------------------------------------------------------------------
// Inputs and POKEYs
// MiSTer left stick = movement, buttons 1-4 = fire down/up/right/left.
// -------------------------------------------------------------------------

wire [7:0] p1 = {
    ~joystick_0[1], ~joystick_0[0], ~joystick_0[3], ~joystick_0[2],
    ~joystick_0[4], ~joystick_0[5], ~joystick_0[6], ~joystick_0[7]
};
wire [7:0] p2 = 8'hFF;
wire [7:0] starts = {start1, start2, 2'b11, 4'b1111};
wire [7:0] system_in = {
    ~joystick_0[8], 1'b1, ~service, 1'b1, ~coin, 1'b1, ~test, ~vblank
};

wire [7:0] pokey1_dout;
wire [7:0] pokey2_dout;
wire [15:0] pokey1_audio;
wire [15:0] pokey2_audio;
pokey_compat pokey1 (
    .clk(clk), .reset(reset), .ce_1m25(ce_pokey),
    .cs(m_pokey1_cs && ce_main), .we(!mrw), .addr(ma[3:0]),
    .din(mdo), .allpot(starts), .dout(pokey1_dout), .audio(pokey1_audio)
);

pokey_compat pokey2 (
    .clk(clk), .reset(reset), .ce_1m25(ce_pokey),
    .cs(m_pokey2_cs && ce_main), .we(!mrw), .addr(ma[3:0]),
    .din(mdo), .allpot(dips), .dout(pokey2_dout), .audio(pokey2_audio)
);

wire [16:0] pokey_mix =
    {1'b0, pokey1_audio} + {1'b0, pokey2_audio};
assign audio = pokey_mix[16:1];

// CPU read muxes
wire [7:0] graph_dout = bitmap_select ? {4'd0, bmp0_cpu_q} : {4'd0, bmp1_cpu_q};

assign mdi =
    m_main_ram_cs ? main_ram_q :
    m_play_cs     ? playfield_cpu_q :
    m_shared_cs   ? shared_main_q :
    m_pokey1_cs   ? pokey1_dout :
    m_pokey2_cs   ? pokey2_dout :
    (ma == 16'h2000) ? p1 :
    (ma == 16'h2200) ? p2 :
    (ma == 16'h2400) ? system_in :
    m_nvram_cs    ? nvram_q :
    m_motion_cs   ? motion_ram[ma[7:0]] :
    m_rom_cs      ? main_rom_q :
    8'hFF;

assign sdi =
    s_graph_cs  ? graph_dout :
    s_local_cs  ? slave_ram_q :
    s_shared_cs ? shared_slave_q :
    s_rom_cs    ? slave_rom_q :
    8'hFF;

// -------------------------------------------------------------------------
// Video: playfield, displayed bitmap, then motion objects.
// -------------------------------------------------------------------------

wire [7:0] tile_code = playfield_video_q;
wire [2:0] tile_x = hcnt[2:0];
wire [2:0] tile_y = vcnt[2:0];

assign char_video_addr =
    {1'b0, tile_code, 4'b0} +
    {9'd0, tile_y, 1'b0} +
    (tile_x[2] ? 13'd1 : 13'd0) +
    (!tile_x[1] ? 13'h1000 : 13'd0);

reg tile_nibble_high;
always_ff @(posedge clk) tile_nibble_high <= tile_x[0];

wire [3:0] tile_pixel =
    tile_nibble_high ? char_video_data[7:4] : char_video_data[3:0];

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

wire [7:0] render_sy = 8'd240 - motion_ram[{2'b00, render_sprite}];
wire [7:0] render_sx = motion_ram[{2'b11, render_sprite}];
wire [7:0] render_attr = motion_ram[{2'b01, render_sprite}];
wire [6:0] render_code = render_attr[6:0];
wire       render_flipx = render_attr[7];
wire [2:0] render_logical_x = {render_pair, 1'b0};
wire [2:0] render_physical_x =
    render_flipx ? (3'd7 - render_logical_x) : render_logical_x;
wire [7:0] render_line_delta = render_y - render_sy;
wire [3:0] render_line = render_line_delta[3:0];

assign motion_video_addr =
    {1'b0, render_code, 5'b0} +
    {8'd0, render_line, 1'b0} +
    (render_physical_x[2] ? 13'd1 : 13'd0) +
    (!render_physical_x[1] ? 13'h1000 : 13'd0);

wire [3:0] pending_pixel0 =
    pending_first_high ? motion_video_data[7:4] : motion_video_data[3:0];
wire [3:0] pending_pixel1 =
    pending_first_high ? motion_video_data[3:0] : motion_video_data[7:4];

always_ff @(posedge clk) begin
    if (reset) begin
        display_line_bank <= 0;
        render_active <= 0;
        render_sprite <= 63;
        render_pair <= 0;
        render_pending <= 0;
    end else begin
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
                    sprite_line0[pending_sx + pending_x] <= pending_pixel0;
                else
                    sprite_line1[pending_sx + pending_x] <= pending_pixel0;
            end
            if (pending_pixel1 != 0) begin
                if (display_line_bank)
                    sprite_line0[pending_sx + pending_x + 1'd1] <= pending_pixel1;
                else
                    sprite_line1[pending_sx + pending_x + 1'd1] <= pending_pixel1;
            end
        end

        render_pending <= render_active && (render_line_delta < 8'd16);
        if (render_active) begin
            pending_sx <= render_sx;
            pending_x <= render_logical_x;
            pending_first_high <= render_physical_x[0];

            if (render_pair == 2'd3) begin
                render_pair <= 2'd0;
                if (render_sprite == 6'd0) render_active <= 0;
                else render_sprite <= render_sprite - 1'd1;
            end else render_pair <= render_pair + 1'd1;
        end

        if (ce_5m && hcnt == 9'd319) display_line_bank <= ~display_line_bank;
    end
end

wire [3:0] bitmap_pixel = bitmap_select ? bmp0_vid_q : bmp1_vid_q;
wire [3:0] sprite_pixel = display_line_bank ?
                          sprite_line1[hcnt[7:0]] : sprite_line0[hcnt[7:0]];

wire [5:0] palette_index =
    (sprite_pixel != 0) ? {2'b10, sprite_pixel} :
    (bitmap_pixel[2:0] != 0) ?
        {2'b01, bitmap_video_addr[7], bitmap_pixel[2:0]} :
        {2'b00, tile_pixel};

wire [8:0] palette_word = palette_ram[palette_index];
wire [2:0] pr = ~palette_word[8:6];
wire [2:0] pg = ~palette_word[5:3];
wire [2:0] pb = ~palette_word[2:0];
wire active_video = !hblank && !vblank;
assign red   = active_video ? {pr, pr, pr[2:1]} : 8'd0;
assign green = active_video ? {pg, pg, pg[2:1]} : 8'd0;
assign blue  = active_video ? {pb, pb, pb[2:1]} : 8'd0;

wire _unused = &{1'b0, joystick_1[0], sync_prom[0][0]};

endmodule
