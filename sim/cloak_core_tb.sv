module cloak_core_tb;

reg clk = 0;
reg reset = 1;
always #10 clk = ~clk;

localparam integer SIM_FRAME_PIXELS = 320 * 262;
localparam integer SIM_FRAME_CLOCKS = SIM_FRAME_PIXELS * 4;

reg [15:0] tb_joystick_0 = 16'h00A5;
reg [15:0] tb_joystick_1 = 16'h005A;
reg tb_fire1 = 1'b1;
reg tb_fire2 = 1'b0;
reg tb_coin_r = 1'b1;
reg tb_coin_l = 1'b0;
reg tb_coin_aux = 1'b1;
reg tb_cocktail = 1'b0;
reg tb_self_test = 1'b0;
wire [7:0] tb_pl1_expected = {
    ~tb_joystick_0[1], ~tb_joystick_0[0],
    ~tb_joystick_0[3], ~tb_joystick_0[2],
    ~tb_joystick_0[4], ~tb_joystick_0[5],
    ~tb_joystick_0[6], ~tb_joystick_0[7]
};
wire [7:0] tb_pl2_expected = {
    ~tb_joystick_1[1], ~tb_joystick_1[0],
    ~tb_joystick_1[3], ~tb_joystick_1[2],
    ~tb_joystick_1[4], ~tb_joystick_1[5],
    ~tb_joystick_1[6], ~tb_joystick_1[7]
};
wire [7:0] tb_system_expected = {
    ~tb_fire1, ~tb_fire2, ~tb_coin_aux, ~tb_cocktail,
    ~tb_coin_r, ~tb_coin_l, ~tb_self_test, ~dut.bvblank
};

cloak_core dut (
    .clk(clk),
    .reset(reset),
    .joystick_0(tb_joystick_0),
    .joystick_1(tb_joystick_1),
    .fire1(tb_fire1),
    .fire2(tb_fire2),
    .coin_r(tb_coin_r),
    .coin_l(tb_coin_l),
    .coin_aux(tb_coin_aux),
    .cocktail(tb_cocktail),
    .start1(1'b0),
    .start2(1'b0),
    .self_test(tb_self_test),
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

integer pf_samples;
integer pf_known_samples;
integer pf_now_matches;
integer pf_d1_matches;
integer pf_d2_matches;
integer pf_d3_matches;
integer pf_n_now_matches;
integer pf_n_d1_matches;
integer pf_n_d2_matches;
integer pf_n_d3_matches;
integer pf_f_now_matches;
integer pf_f_d1_matches;
integer pf_f_d2_matches;
integer pf_f_d3_matches;
integer colsel_known_samples;
integer colsel_expected_matches;
integer cola_known_samples;
integer cola_expected_matches;
integer palette_index_known_samples;
integer palette_index_cola_matches;
integer color_latch_known_samples;
integer color_latch_now_matches;
integer color_latch_d1_matches;
integer color_latch_d2_matches;
integer rgb_bits_known_samples;
integer rgb_bits_latch_matches;
integer blank_gate_known_samples;
integer blank_gate_expected_matches;
integer input_buffer_known_samples;
integer input_buffer_expected_matches;
integer custom_timing_known_samples;
integer custom_timing_expected_matches;
integer hblank_boundary_known_samples;
integer hblank_boundary_expected_matches;
integer hblank_latched_known_samples;
integer hblank_latched_q_matches;
integer hblank_latched_qn_matches;
integer hblank_latched_q_mismatches;
integer hblank_latched_qn_mismatches;
integer hblank_3b_first_transitions;
integer hblank_3b_second_transitions;
integer hblank_3c_q_transitions;
integer hblank_3c_qn_transitions;
integer hblank_3b_second_rise_count;
integer hblank_3b_first_high_samples;
integer hblank_3b_second_high_samples;
integer hblank_3c_q_high_samples;
integer hblank_3c_qn_high_samples;
integer hblank_latched_first_q_h;
integer hblank_latched_first_q_v;
integer hblank_latched_last_q_h;
integer hblank_latched_last_q_v;
integer hblank_latched_first_qn_h;
integer hblank_latched_first_qn_v;
integer hblank_latched_last_qn_h;
integer hblank_latched_last_qn_v;
integer sync_gate_known_samples;
integer vsync_4b_expected_matches;
integer compsync_4b_expected_matches;
integer sync_gate_4n_known_samples;
integer vsync_4b_4n_expected_matches;
integer compsync_4b_4n_expected_matches;
integer sync_gate_4n_vsync_mismatches;
integer sync_gate_4n_compsync_mismatches;
integer sync_gate_4n_first_vsync_h;
integer sync_gate_4n_first_vsync_v;
integer sync_gate_4n_last_vsync_h;
integer sync_gate_4n_last_vsync_v;
integer sync_gate_4n_first_compsync_h;
integer sync_gate_4n_first_compsync_v;
integer sync_gate_4n_last_compsync_h;
integer sync_gate_4n_last_compsync_v;
integer sync_gate_4n_wrap_known_samples;
integer vsync_4b_4n_wrap_matches;
integer compsync_4b_4n_wrap_matches;
integer prom_timing_known_samples;
integer prom_vsync_q_matches;
integer prom_vsync_qn_matches;
integer prom_vblank_q_matches;
integer prom_vblank_qn_matches;
integer prom_hblank_q_matches;
integer prom_hblank_qn_matches;
integer prom_256h_q_matches;
integer prom_256h_qn_matches;
integer sync_4n_label_known_samples;
integer sync_4n_vsync_matches;
integer sync_4n_vsync_n_matches;
integer sync_4n_vblank_matches;
integer sync_4n_vblank_n_matches;
integer motion_parallel_known_samples;
integer motion_parallel_pair0_matches;
integer motion_parallel_pair1_matches;
integer motion_buffer_known_samples;
integer motion_buffer_now_matches;
integer motion_buffer_d1_matches;
integer motion_buffer_d2_matches;
integer motion_buffer_d3_matches;
integer motion_buffer_write_samples;
integer motion_buffer_render_write_samples;
integer motion_buffer_clear_write_samples;
integer motion_buffer_schematic_we_samples;
integer motion_buffer_bridge_we_overlap_samples;
integer motion_buffer_bridge_only_we_samples;
integer motion_buffer_schematic_only_we_samples;
integer motion_buffer_schematic_only_blank_samples;
integer motion_buffer_schematic_only_render_samples;
integer motion_buffer_schematic_only_visible_samples;
integer motion_buffer_9t_clk_samples;
integer motion_buffer_9t_we_overlap_samples;
integer motion_buffer_9t_bridge_overlap_samples;
integer motion_buffer_9t_blank_samples;
integer motion_buffer_9t_visible_samples;
integer motion_buffer_control_known_samples;
integer motion_buffer_cs_oe_active_samples;
integer motion_buffer_cs_oe_inactive_samples;
integer motion_buffer_data_nonzero_samples;
integer motion_buffer_left_data_nonzero_samples;
integer motion_buffer_right_data_nonzero_samples;
integer motion_buffer_mbj0_nonzero_samples;
integer motion_buffer_mbj1_nonzero_samples;
integer motion_buffer_8k_mbj_matches;
integer motion_buffer_8m_mbj_matches;
integer motion_buffer_8k_feedback_matches;
integer motion_buffer_8m_feedback_matches;
integer motion_buffer_addr_known_samples;
integer motion_buffer_addr_expected_matches;
integer motion_buffer_addr_adjacent_matches;
integer motion_buffer_counter_addr_known_samples;
integer motion_buffer_counter_addr_exact_matches;
integer motion_buffer_counter_addr_prev_matches;
integer motion_buffer_counter_addr_next_matches;
integer motion_buffer_counter_addr_cross_matches;
integer motion_buffer_counter_left_load_active;
integer motion_buffer_counter_right_load_active;
integer motion_buffer_counter_left_clear_active;
integer motion_buffer_counter_right_clear_active;
integer motion_buffer_moh_known_samples;
integer motion_buffer_moh_left_load_bsm;
integer motion_buffer_moh_right_load_bsm;
integer motion_buffer_moh_left_clear_bsm;
integer motion_buffer_moh_right_clear_bsm;
integer motion_buffer_moh_left_load_render;
integer motion_buffer_moh_right_load_render;
integer motion_buffer_moh_left_clear_render;
integer motion_buffer_moh_right_clear_render;
integer motion_buffer_raw_lb_nonzero_samples;
integer motion_buffer_raw_b1h_nonzero;
integer motion_buffer_raw_b1h_n_nonzero;
integer motion_buffer_raw_b2h_nonzero;
integer motion_buffer_raw_b4h_nonzero;
integer motion_buffer_compat_raw_missing;
integer motion_buffer_compat_raw_missing_first_h;
integer motion_buffer_compat_raw_missing_first_v;
integer motion_buffer_compat_raw_missing_last_h;
integer motion_buffer_compat_raw_missing_last_v;
integer motion_buffer_compat_latched_missing;
integer motion_buffer_compat_schematic_missing;
integer motion_buffer_lb_nonzero_samples;
integer motion_buffer_mbit_nonzero_samples;
integer motion_buffer_compat_nonzero_samples;
integer motion_buffer_compat_d1_nonzero_samples;
integer motion_buffer_compat_d1_schematic_missing;
integer motion_buffer_compat_d1_schematic_value_mismatch;
integer motion_buffer_compat_d1_missing_first_h;
integer motion_buffer_compat_d1_missing_first_v;
integer motion_buffer_compat_d1_missing_last_h;
integer motion_buffer_compat_d1_missing_last_v;
integer motion_buffer_compat_d1_missing_raw_present;
integer motion_buffer_compat_d1_missing_latched_present;
integer motion_buffer_compat_d1_missing_mem_current;
integer motion_buffer_compat_d1_missing_mem_prev;
integer motion_buffer_compat_d1_missing_mem_next;
integer motion_buffer_compat_d1_missing_mem_other_bank;
integer motion_buffer_compat_d1_missing_mem_other_side;
integer motion_buffer_compat_d1_missing_mem_other_side_match;
integer motion_buffer_compat_d1_missing_mem_other_side_prev;
integer motion_buffer_compat_d1_missing_mem_other_side_next;
integer motion_buffer_compat_d1_missing_mem_other_side_prev_match;
integer motion_buffer_compat_d1_missing_mem_other_side_next_match;
integer motion_buffer_compat_d1_missing_selected_window_match;
integer motion_buffer_compat_d1_missing_other_window_match;
integer motion_buffer_compat_d1_missing_8k_mbj;
integer motion_buffer_compat_d1_missing_8k_feedback;
integer motion_buffer_compat_d1_missing_8m_mbj;
integer motion_buffer_compat_d1_missing_8m_feedback;
integer motion_buffer_compat_d1_missing_ivdsh_high;
integer motion_buffer_compat_d1_missing_ivdbh_high;
integer motion_buffer_mbit_nonzero_compat_now;
integer motion_buffer_mbit_nonzero_compat_d1;
integer motion_buffer_mbit_nonzero_compat_d2;
integer motion_buffer_mbit_nonzero_compat_d3;
integer motion_buffer_single_addr_nonzero_samples;
integer motion_buffer_single_addr_now_matches;
integer motion_buffer_single_addr_d1_matches;
integer motion_buffer_single_addr_d2_matches;
integer motion_buffer_single_addr_d3_matches;
integer motion_buffer_single_addr_d1_missing;
integer motion_buffer_single_addr_fills_bridge_missing;
integer motion_buffer_sel_b1h_nonzero;
integer motion_buffer_sel_b1h_matches;
integer motion_buffer_sel_b1h_n_nonzero;
integer motion_buffer_sel_b1h_n_matches;
integer motion_buffer_sel_b2h_nonzero;
integer motion_buffer_sel_b2h_matches;
integer motion_buffer_sel_b2h_n_nonzero;
integer motion_buffer_sel_b2h_n_matches;
integer motion_buffer_sel_b4h_nonzero;
integer motion_buffer_sel_b4h_matches;
integer motion_buffer_mbit_first_h;
integer motion_buffer_mbit_first_v;
integer motion_buffer_mbit_last_h;
integer motion_buffer_mbit_last_v;
integer init_i;
integer motion_window_i;
integer motion_offset_i;
integer motion_buffer_other_window_match_offset [0:16];

reg [1023:0] prom_hex_path;
reg [3:0] pbit_compat_d3_tb;
reg [3:0] mbit_compat_d1_tb;
reg [3:0] mbit_compat_d2_tb;
reg [3:0] mbit_compat_d3_tb;
reg [1:0] colsel_expected;
reg [5:0] cola_expected;
reg [8:0] color_inverted_d1;
reg [8:0] color_inverted_d2;
reg hblank_3b_first_q_d;
reg hblank_3b_second_q_tb_d;
reg [3:0] motion_buffer_selected_mem_current;
reg [3:0] motion_buffer_selected_mem_prev;
reg [3:0] motion_buffer_selected_mem_next;
reg [3:0] motion_buffer_selected_mem_other_bank;
reg [3:0] motion_buffer_selected_mem_other_side;
reg [3:0] motion_buffer_selected_mem_other_side_prev;
reg [3:0] motion_buffer_selected_mem_other_side_next;
reg motion_buffer_selected_window_has_match;
reg motion_buffer_other_window_has_match;
reg hblank_3c_q_d;
reg hblank_3c_qn_d;
reg [3:0] motion_buffer_sel_b1h;
reg [3:0] motion_buffer_sel_b1h_n;
reg [3:0] motion_buffer_sel_b2h;
reg [3:0] motion_buffer_sel_b2h_n;
reg [3:0] motion_buffer_sel_b4h;
reg [3:0] motion_buffer_raw_b1h;
reg [3:0] motion_buffer_raw_b1h_n;
reg [3:0] motion_buffer_raw_b2h;
reg [3:0] motion_buffer_raw_b4h;

always @(posedge clk) begin
    if (reset) begin
        pf_samples <= 0;
        pf_known_samples <= 0;
        pf_now_matches <= 0;
        pf_d1_matches <= 0;
        pf_d2_matches <= 0;
        pf_d3_matches <= 0;
        pf_n_now_matches <= 0;
        pf_n_d1_matches <= 0;
        pf_n_d2_matches <= 0;
        pf_n_d3_matches <= 0;
        pf_f_now_matches <= 0;
        pf_f_d1_matches <= 0;
        pf_f_d2_matches <= 0;
        pf_f_d3_matches <= 0;
        colsel_known_samples <= 0;
        colsel_expected_matches <= 0;
        cola_known_samples <= 0;
        cola_expected_matches <= 0;
        palette_index_known_samples <= 0;
        palette_index_cola_matches <= 0;
        color_latch_known_samples <= 0;
        color_latch_now_matches <= 0;
        color_latch_d1_matches <= 0;
        color_latch_d2_matches <= 0;
        rgb_bits_known_samples <= 0;
        rgb_bits_latch_matches <= 0;
        blank_gate_known_samples <= 0;
        blank_gate_expected_matches <= 0;
        input_buffer_known_samples <= 0;
        input_buffer_expected_matches <= 0;
        custom_timing_known_samples <= 0;
        custom_timing_expected_matches <= 0;
        hblank_boundary_known_samples <= 0;
        hblank_boundary_expected_matches <= 0;
        hblank_latched_known_samples <= 0;
        hblank_latched_q_matches <= 0;
        hblank_latched_qn_matches <= 0;
        hblank_latched_q_mismatches <= 0;
        hblank_latched_qn_mismatches <= 0;
        hblank_3b_first_transitions <= 0;
        hblank_3b_second_transitions <= 0;
        hblank_3c_q_transitions <= 0;
        hblank_3c_qn_transitions <= 0;
        hblank_3b_second_rise_count <= 0;
        hblank_3b_first_high_samples <= 0;
        hblank_3b_second_high_samples <= 0;
        hblank_3c_q_high_samples <= 0;
        hblank_3c_qn_high_samples <= 0;
        hblank_latched_first_q_h <= -1;
        hblank_latched_first_q_v <= -1;
        hblank_latched_last_q_h <= -1;
        hblank_latched_last_q_v <= -1;
        hblank_latched_first_qn_h <= -1;
        hblank_latched_first_qn_v <= -1;
        hblank_latched_last_qn_h <= -1;
        hblank_latched_last_qn_v <= -1;
        sync_gate_known_samples <= 0;
        vsync_4b_expected_matches <= 0;
        compsync_4b_expected_matches <= 0;
        sync_gate_4n_known_samples <= 0;
        vsync_4b_4n_expected_matches <= 0;
        compsync_4b_4n_expected_matches <= 0;
        sync_gate_4n_vsync_mismatches <= 0;
        sync_gate_4n_compsync_mismatches <= 0;
        sync_gate_4n_first_vsync_h <= -1;
        sync_gate_4n_first_vsync_v <= -1;
        sync_gate_4n_last_vsync_h <= -1;
        sync_gate_4n_last_vsync_v <= -1;
        sync_gate_4n_first_compsync_h <= -1;
        sync_gate_4n_first_compsync_v <= -1;
        sync_gate_4n_last_compsync_h <= -1;
        sync_gate_4n_last_compsync_v <= -1;
        sync_gate_4n_wrap_known_samples <= 0;
        vsync_4b_4n_wrap_matches <= 0;
        compsync_4b_4n_wrap_matches <= 0;
        prom_timing_known_samples <= 0;
        prom_vsync_q_matches <= 0;
        prom_vsync_qn_matches <= 0;
        prom_vblank_q_matches <= 0;
        prom_vblank_qn_matches <= 0;
        prom_hblank_q_matches <= 0;
        prom_hblank_qn_matches <= 0;
        prom_256h_q_matches <= 0;
        prom_256h_qn_matches <= 0;
        sync_4n_label_known_samples <= 0;
        sync_4n_vsync_matches <= 0;
        sync_4n_vsync_n_matches <= 0;
        sync_4n_vblank_matches <= 0;
        sync_4n_vblank_n_matches <= 0;
        motion_parallel_known_samples <= 0;
        motion_parallel_pair0_matches <= 0;
        motion_parallel_pair1_matches <= 0;
        motion_buffer_known_samples <= 0;
        motion_buffer_now_matches <= 0;
        motion_buffer_d1_matches <= 0;
        motion_buffer_d2_matches <= 0;
        motion_buffer_d3_matches <= 0;
        motion_buffer_write_samples <= 0;
        motion_buffer_render_write_samples <= 0;
        motion_buffer_clear_write_samples <= 0;
        motion_buffer_schematic_we_samples <= 0;
        motion_buffer_bridge_we_overlap_samples <= 0;
        motion_buffer_bridge_only_we_samples <= 0;
        motion_buffer_schematic_only_we_samples <= 0;
        motion_buffer_schematic_only_blank_samples <= 0;
        motion_buffer_schematic_only_render_samples <= 0;
        motion_buffer_schematic_only_visible_samples <= 0;
        motion_buffer_9t_clk_samples <= 0;
        motion_buffer_9t_we_overlap_samples <= 0;
        motion_buffer_9t_bridge_overlap_samples <= 0;
        motion_buffer_9t_blank_samples <= 0;
        motion_buffer_9t_visible_samples <= 0;
        motion_buffer_control_known_samples <= 0;
        motion_buffer_cs_oe_active_samples <= 0;
        motion_buffer_cs_oe_inactive_samples <= 0;
        motion_buffer_data_nonzero_samples <= 0;
        motion_buffer_left_data_nonzero_samples <= 0;
        motion_buffer_right_data_nonzero_samples <= 0;
        motion_buffer_mbj0_nonzero_samples <= 0;
        motion_buffer_mbj1_nonzero_samples <= 0;
        motion_buffer_8k_mbj_matches <= 0;
        motion_buffer_8m_mbj_matches <= 0;
        motion_buffer_8k_feedback_matches <= 0;
        motion_buffer_8m_feedback_matches <= 0;
        motion_buffer_addr_known_samples <= 0;
        motion_buffer_addr_expected_matches <= 0;
        motion_buffer_addr_adjacent_matches <= 0;
        motion_buffer_counter_addr_known_samples <= 0;
        motion_buffer_counter_addr_exact_matches <= 0;
        motion_buffer_counter_addr_prev_matches <= 0;
        motion_buffer_counter_addr_next_matches <= 0;
        motion_buffer_counter_addr_cross_matches <= 0;
        motion_buffer_counter_left_load_active <= 0;
        motion_buffer_counter_right_load_active <= 0;
        motion_buffer_counter_left_clear_active <= 0;
        motion_buffer_counter_right_clear_active <= 0;
        motion_buffer_moh_known_samples <= 0;
        motion_buffer_moh_left_load_bsm <= 0;
        motion_buffer_moh_right_load_bsm <= 0;
        motion_buffer_moh_left_clear_bsm <= 0;
        motion_buffer_moh_right_clear_bsm <= 0;
        motion_buffer_moh_left_load_render <= 0;
        motion_buffer_moh_right_load_render <= 0;
        motion_buffer_moh_left_clear_render <= 0;
        motion_buffer_moh_right_clear_render <= 0;
        motion_buffer_raw_lb_nonzero_samples <= 0;
        motion_buffer_raw_b1h_nonzero <= 0;
        motion_buffer_raw_b1h_n_nonzero <= 0;
        motion_buffer_raw_b2h_nonzero <= 0;
        motion_buffer_raw_b4h_nonzero <= 0;
        motion_buffer_compat_raw_missing <= 0;
        motion_buffer_compat_raw_missing_first_h <= -1;
        motion_buffer_compat_raw_missing_first_v <= -1;
        motion_buffer_compat_raw_missing_last_h <= -1;
        motion_buffer_compat_raw_missing_last_v <= -1;
        motion_buffer_compat_latched_missing <= 0;
        motion_buffer_compat_schematic_missing <= 0;
        motion_buffer_lb_nonzero_samples <= 0;
        motion_buffer_mbit_nonzero_samples <= 0;
        motion_buffer_compat_nonzero_samples <= 0;
        motion_buffer_compat_d1_nonzero_samples <= 0;
        motion_buffer_compat_d1_schematic_missing <= 0;
        motion_buffer_compat_d1_schematic_value_mismatch <= 0;
        motion_buffer_compat_d1_missing_first_h <= -1;
        motion_buffer_compat_d1_missing_first_v <= -1;
        motion_buffer_compat_d1_missing_last_h <= -1;
        motion_buffer_compat_d1_missing_last_v <= -1;
        motion_buffer_compat_d1_missing_raw_present <= 0;
        motion_buffer_compat_d1_missing_latched_present <= 0;
        motion_buffer_compat_d1_missing_mem_current <= 0;
        motion_buffer_compat_d1_missing_mem_prev <= 0;
        motion_buffer_compat_d1_missing_mem_next <= 0;
        motion_buffer_compat_d1_missing_mem_other_bank <= 0;
        motion_buffer_compat_d1_missing_mem_other_side <= 0;
        motion_buffer_compat_d1_missing_mem_other_side_match <= 0;
        motion_buffer_compat_d1_missing_mem_other_side_prev <= 0;
        motion_buffer_compat_d1_missing_mem_other_side_next <= 0;
        motion_buffer_compat_d1_missing_mem_other_side_prev_match <= 0;
        motion_buffer_compat_d1_missing_mem_other_side_next_match <= 0;
        motion_buffer_compat_d1_missing_selected_window_match <= 0;
        motion_buffer_compat_d1_missing_other_window_match <= 0;
        motion_buffer_compat_d1_missing_8k_mbj <= 0;
        motion_buffer_compat_d1_missing_8k_feedback <= 0;
        motion_buffer_compat_d1_missing_8m_mbj <= 0;
        motion_buffer_compat_d1_missing_8m_feedback <= 0;
        motion_buffer_compat_d1_missing_ivdsh_high <= 0;
        motion_buffer_compat_d1_missing_ivdbh_high <= 0;
        for (motion_offset_i = 0; motion_offset_i < 17;
             motion_offset_i = motion_offset_i + 1)
            motion_buffer_other_window_match_offset[motion_offset_i] <= 0;
        motion_buffer_mbit_nonzero_compat_now <= 0;
        motion_buffer_mbit_nonzero_compat_d1 <= 0;
        motion_buffer_mbit_nonzero_compat_d2 <= 0;
        motion_buffer_mbit_nonzero_compat_d3 <= 0;
        motion_buffer_single_addr_nonzero_samples <= 0;
        motion_buffer_single_addr_now_matches <= 0;
        motion_buffer_single_addr_d1_matches <= 0;
        motion_buffer_single_addr_d2_matches <= 0;
        motion_buffer_single_addr_d3_matches <= 0;
        motion_buffer_single_addr_d1_missing <= 0;
        motion_buffer_single_addr_fills_bridge_missing <= 0;
        motion_buffer_sel_b1h_nonzero <= 0;
        motion_buffer_sel_b1h_matches <= 0;
        motion_buffer_sel_b1h_n_nonzero <= 0;
        motion_buffer_sel_b1h_n_matches <= 0;
        motion_buffer_sel_b2h_nonzero <= 0;
        motion_buffer_sel_b2h_matches <= 0;
        motion_buffer_sel_b2h_n_nonzero <= 0;
        motion_buffer_sel_b2h_n_matches <= 0;
        motion_buffer_sel_b4h_nonzero <= 0;
        motion_buffer_sel_b4h_matches <= 0;
        motion_buffer_mbit_first_h <= -1;
        motion_buffer_mbit_first_v <= -1;
        motion_buffer_mbit_last_h <= -1;
        motion_buffer_mbit_last_v <= -1;
        pbit_compat_d3_tb <= 4'd0;
        mbit_compat_d1_tb <= 4'd0;
        mbit_compat_d2_tb <= 4'd0;
        mbit_compat_d3_tb <= 4'd0;
        color_inverted_d1 <= 9'd0;
        color_inverted_d2 <= 9'd0;
        hblank_3b_first_q_d <= 1'b0;
        hblank_3b_second_q_tb_d <= 1'b0;
        hblank_3c_q_d <= 1'b0;
        hblank_3c_qn_d <= 1'b1;
    end else if (dut.ce_5m) begin
        hblank_3b_first_q_d <= dut.hblank_3b_first_q;
        hblank_3b_second_q_tb_d <= dut.hblank_3b_second_q;
        hblank_3c_q_d <= dut.hblank_from_3c_latched;
        hblank_3c_qn_d <= dut.hblank_n_from_3c_latched;
        if (dut.hblank_3b_first_q != hblank_3b_first_q_d)
            hblank_3b_first_transitions <= hblank_3b_first_transitions + 1;
        if (dut.hblank_3b_second_q != hblank_3b_second_q_tb_d)
            hblank_3b_second_transitions <= hblank_3b_second_transitions + 1;
        if (dut.hblank_from_3c_latched != hblank_3c_q_d)
            hblank_3c_q_transitions <= hblank_3c_q_transitions + 1;
        if (dut.hblank_n_from_3c_latched != hblank_3c_qn_d)
            hblank_3c_qn_transitions <= hblank_3c_qn_transitions + 1;
        if (dut.hblank_3b_second_q_rise)
            hblank_3b_second_rise_count <= hblank_3b_second_rise_count + 1;
        if (dut.hblank_3b_first_q)
            hblank_3b_first_high_samples <= hblank_3b_first_high_samples + 1;
        if (dut.hblank_3b_second_q)
            hblank_3b_second_high_samples <= hblank_3b_second_high_samples + 1;
        if (dut.hblank_from_3c_latched)
            hblank_3c_q_high_samples <= hblank_3c_q_high_samples + 1;
        if (dut.hblank_n_from_3c_latched)
            hblank_3c_qn_high_samples <= hblank_3c_qn_high_samples + 1;

        if (!$isunknown({dut.prom_vsync_registered,
                         dut.prom_vblank_registered,
                         dut.prom_hblank_registered,
                         dut.prom_256h_registered,
                         dut.active_vsync,
                         dut.active_vblank,
                         dut.counter_hblank,
                         dut.b256h})) begin
            prom_timing_known_samples <= prom_timing_known_samples + 1;
            prom_vsync_q_matches <= prom_vsync_q_matches +
                ((dut.prom_vsync_registered == dut.active_vsync) ? 1 : 0);
            prom_vsync_qn_matches <= prom_vsync_qn_matches +
                ((~dut.prom_vsync_registered == dut.active_vsync) ? 1 : 0);
            prom_vblank_q_matches <= prom_vblank_q_matches +
                ((dut.prom_vblank_registered == dut.active_vblank) ? 1 : 0);
            prom_vblank_qn_matches <= prom_vblank_qn_matches +
                ((~dut.prom_vblank_registered == dut.active_vblank) ? 1 : 0);
            prom_hblank_q_matches <= prom_hblank_q_matches +
                ((dut.prom_hblank_registered == dut.counter_hblank) ? 1 : 0);
            prom_hblank_qn_matches <= prom_hblank_qn_matches +
                ((~dut.prom_hblank_registered == dut.counter_hblank) ? 1 : 0);
            prom_256h_q_matches <= prom_256h_q_matches +
                ((dut.prom_256h_registered == dut.b256h) ? 1 : 0);
            prom_256h_qn_matches <= prom_256h_qn_matches +
                ((~dut.prom_256h_registered == dut.b256h) ? 1 : 0);
        end

        if (!$isunknown({dut.vsync_from_4n,
                         dut.vsync_n_from_4n,
                         dut.vblank_from_4n,
                         dut.vblank_n_from_4n,
                         dut.active_vsync,
                         dut.active_vsync_n,
                         dut.active_vblank})) begin
            sync_4n_label_known_samples <= sync_4n_label_known_samples + 1;
            sync_4n_vsync_matches <= sync_4n_vsync_matches +
                ((dut.vsync_from_4n == dut.active_vsync) ? 1 : 0);
            sync_4n_vsync_n_matches <= sync_4n_vsync_n_matches +
                ((dut.vsync_n_from_4n == dut.active_vsync_n) ? 1 : 0);
            sync_4n_vblank_matches <= sync_4n_vblank_matches +
                ((dut.vblank_from_4n == dut.active_vblank) ? 1 : 0);
            sync_4n_vblank_n_matches <= sync_4n_vblank_n_matches +
                ((dut.vblank_n_from_4n == ~dut.active_vblank) ? 1 : 0);
        end

        if (!$isunknown({dut.vsync_from_4b, dut.compsync_from_4b,
                         dut.active_vsync_n, dut.active_vsync,
                         dut.active_hsync})) begin
            sync_gate_known_samples <= sync_gate_known_samples + 1;
            vsync_4b_expected_matches <= vsync_4b_expected_matches +
                ((dut.vsync_from_4b == dut.active_vsync) ? 1 : 0);
            compsync_4b_expected_matches <= compsync_4b_expected_matches +
                ((dut.compsync_from_4b == ~(dut.active_vsync ^ dut.active_hsync)) ? 1 : 0);
        end

        if (!$isunknown({dut.vsync_from_4b_4n,
                         dut.compsync_from_4b_4n,
                         dut.active_vsync,
                         dut.active_hsync})) begin
            sync_gate_4n_known_samples <= sync_gate_4n_known_samples + 1;
            vsync_4b_4n_expected_matches <= vsync_4b_4n_expected_matches +
                ((dut.vsync_from_4b_4n == dut.active_vsync) ? 1 : 0);
            compsync_4b_4n_expected_matches <= compsync_4b_4n_expected_matches +
                ((dut.compsync_from_4b_4n == ~(dut.active_vsync ^ dut.active_hsync)) ? 1 : 0);
            if (dut.vsync_from_4b_4n != dut.active_vsync) begin
                sync_gate_4n_vsync_mismatches <= sync_gate_4n_vsync_mismatches + 1;
                if (sync_gate_4n_first_vsync_h < 0) begin
                    sync_gate_4n_first_vsync_h <= dut.hcnt;
                    sync_gate_4n_first_vsync_v <= dut.vcnt;
                end
                sync_gate_4n_last_vsync_h <= dut.hcnt;
                sync_gate_4n_last_vsync_v <= dut.vcnt;
            end
            if (dut.compsync_from_4b_4n != ~(dut.active_vsync ^ dut.active_hsync)) begin
                sync_gate_4n_compsync_mismatches <= sync_gate_4n_compsync_mismatches + 1;
                if (sync_gate_4n_first_compsync_h < 0) begin
                    sync_gate_4n_first_compsync_h <= dut.hcnt;
                    sync_gate_4n_first_compsync_v <= dut.vcnt;
                end
                sync_gate_4n_last_compsync_h <= dut.hcnt;
                sync_gate_4n_last_compsync_v <= dut.vcnt;
            end
        end

        if (!$isunknown({dut.vsync_from_4b_4n,
                         dut.compsync_from_4b_4n,
                         dut.prom_frame_origin_vsync,
                         dut.prom_frame_origin_compsync})) begin
            sync_gate_4n_wrap_known_samples <= sync_gate_4n_wrap_known_samples + 1;
            vsync_4b_4n_wrap_matches <= vsync_4b_4n_wrap_matches +
                ((dut.vsync_from_4b_4n == dut.prom_frame_origin_vsync) ? 1 : 0);
            compsync_4b_4n_wrap_matches <= compsync_4b_4n_wrap_matches +
                ((dut.compsync_from_4b_4n == dut.prom_frame_origin_compsync) ? 1 : 0);
        end

        if (!$isunknown({dut.hblank_from_3c, dut.counter_hblank})) begin
            hblank_boundary_known_samples <= hblank_boundary_known_samples + 1;
            hblank_boundary_expected_matches <= hblank_boundary_expected_matches +
                ((dut.hblank_from_3c == dut.counter_hblank) ? 1 : 0);
        end
        if (!$isunknown({dut.hblank_from_3c_latched,
                         dut.hblank_n_from_3c_latched,
                         dut.counter_hblank})) begin
            hblank_latched_known_samples <= hblank_latched_known_samples + 1;
            hblank_latched_q_matches <= hblank_latched_q_matches +
                ((dut.hblank_from_3c_latched == dut.counter_hblank) ? 1 : 0);
            hblank_latched_qn_matches <= hblank_latched_qn_matches +
                ((dut.hblank_n_from_3c_latched == dut.counter_hblank) ? 1 : 0);
            if (dut.hblank_from_3c_latched != dut.counter_hblank) begin
                hblank_latched_q_mismatches <= hblank_latched_q_mismatches + 1;
                if (hblank_latched_first_q_h < 0) begin
                    hblank_latched_first_q_h <= dut.hcnt;
                    hblank_latched_first_q_v <= dut.vcnt;
                end
                hblank_latched_last_q_h <= dut.hcnt;
                hblank_latched_last_q_v <= dut.vcnt;
            end
            if (dut.hblank_n_from_3c_latched != dut.counter_hblank) begin
                hblank_latched_qn_mismatches <= hblank_latched_qn_mismatches + 1;
                if (hblank_latched_first_qn_h < 0) begin
                    hblank_latched_first_qn_h <= dut.hcnt;
                    hblank_latched_first_qn_v <= dut.vcnt;
                end
                hblank_latched_last_qn_h <= dut.hcnt;
                hblank_latched_last_qn_v <= dut.vcnt;
            end
        end

        if (!$isunknown({dut.bvblank, dut.counter_vblank,
                         dut.b256h, dut.counter_b256h})) begin
            custom_timing_known_samples <= custom_timing_known_samples + 1;
            custom_timing_expected_matches <= custom_timing_expected_matches +
                ((dut.bvblank == dut.counter_vblank &&
                  dut.b256h == dut.counter_b256h) ? 1 : 0);
        end

        if (dut.render_pending &&
            !$isunknown({dut.mbj_pending0,
                         dut.mbj_pending1,
                         dut.mrom_parallel_pair_pixel0,
                         dut.mrom_parallel_pair_pixel1})) begin
            motion_parallel_known_samples <= motion_parallel_known_samples + 1;
            motion_parallel_pair0_matches <= motion_parallel_pair0_matches +
                ((dut.mbj_pending0 == dut.mrom_parallel_pair_pixel0) ? 1 : 0);
            motion_parallel_pair1_matches <= motion_parallel_pair1_matches +
                ((dut.mbj_pending1 == dut.mrom_parallel_pair_pixel1) ? 1 : 0);
        end

        if (!dut.motion_buffer_write_n &&
            !$isunknown({dut.motion_buffer_left_ram_data,
                         dut.motion_buffer_right_ram_data})) begin
            motion_buffer_write_samples <= motion_buffer_write_samples + 1;
            if (dut.motion_buffer_render_write)
                motion_buffer_render_write_samples <=
                    motion_buffer_render_write_samples + 1;
            if (dut.motion_buffer_clear_write)
                motion_buffer_clear_write_samples <=
                    motion_buffer_clear_write_samples + 1;
            if (dut.motion_buffer_left_ram_data != 4'd0 ||
                dut.motion_buffer_right_ram_data != 4'd0)
                motion_buffer_data_nonzero_samples <=
                    motion_buffer_data_nonzero_samples + 1;
            if (dut.motion_buffer_render_write) begin
                if (dut.motion_buffer_left_ram_data != 4'd0)
                    motion_buffer_left_data_nonzero_samples <=
                        motion_buffer_left_data_nonzero_samples + 1;
                if (dut.motion_buffer_right_ram_data != 4'd0)
                    motion_buffer_right_data_nonzero_samples <=
                        motion_buffer_right_data_nonzero_samples + 1;
                if (dut.mbj_pending0 != 4'd0)
                    motion_buffer_mbj0_nonzero_samples <=
                        motion_buffer_mbj0_nonzero_samples + 1;
                if (dut.mbj_pending1 != 4'd0)
                    motion_buffer_mbj1_nonzero_samples <=
                        motion_buffer_mbj1_nonzero_samples + 1;
                motion_buffer_8k_mbj_matches <=
                    motion_buffer_8k_mbj_matches +
                    ((dut.motion_buffer_data_from_8k ==
                      dut.mbj_pending0) ? 1 : 0);
                motion_buffer_8m_mbj_matches <=
                    motion_buffer_8m_mbj_matches +
                    ((dut.motion_buffer_data_from_8m ==
                      dut.mbj_pending1) ? 1 : 0);
                motion_buffer_8k_feedback_matches <=
                    motion_buffer_8k_feedback_matches +
                    ((dut.motion_buffer_data_from_8k ==
                      dut.lb0_feedback_for_8k) ? 1 : 0);
                motion_buffer_8m_feedback_matches <=
                    motion_buffer_8m_feedback_matches +
                    ((dut.motion_buffer_data_from_8m ==
                      dut.lb1_feedback_for_8m) ? 1 : 0);
            end
        end
        if (!$isunknown({dut.motion_buffer_we_n_from_8j_8l,
                         dut.motion_buffer_write_n,
                         dut.motion_buffer_9t_clk_en_from_bsm})) begin
            if (dut.motion_buffer_9t_clk_en_from_bsm) begin
                motion_buffer_9t_clk_samples <=
                    motion_buffer_9t_clk_samples + 1;
                if (!dut.motion_buffer_we_n_from_8j_8l)
                    motion_buffer_9t_we_overlap_samples <=
                        motion_buffer_9t_we_overlap_samples + 1;
                if (!dut.motion_buffer_write_n)
                    motion_buffer_9t_bridge_overlap_samples <=
                        motion_buffer_9t_bridge_overlap_samples + 1;
                if (dut.hblank || dut.vblank)
                    motion_buffer_9t_blank_samples <=
                        motion_buffer_9t_blank_samples + 1;
                if (!dut.hblank && !dut.vblank)
                    motion_buffer_9t_visible_samples <=
                        motion_buffer_9t_visible_samples + 1;
            end
            if (!dut.motion_buffer_we_n_from_8j_8l)
                motion_buffer_schematic_we_samples <=
                    motion_buffer_schematic_we_samples + 1;
            if (!dut.motion_buffer_we_n_from_8j_8l &&
                !dut.motion_buffer_write_n)
                motion_buffer_bridge_we_overlap_samples <=
                    motion_buffer_bridge_we_overlap_samples + 1;
            if (dut.motion_buffer_we_n_from_8j_8l &&
                !dut.motion_buffer_write_n)
                motion_buffer_bridge_only_we_samples <=
                    motion_buffer_bridge_only_we_samples + 1;
            if (!dut.motion_buffer_we_n_from_8j_8l &&
                dut.motion_buffer_write_n) begin
                motion_buffer_schematic_only_we_samples <=
                    motion_buffer_schematic_only_we_samples + 1;
                if (dut.hblank || dut.vblank)
                    motion_buffer_schematic_only_blank_samples <=
                        motion_buffer_schematic_only_blank_samples + 1;
                if (dut.render_pending)
                    motion_buffer_schematic_only_render_samples <=
                        motion_buffer_schematic_only_render_samples + 1;
                if (!dut.hblank && !dut.vblank)
                    motion_buffer_schematic_only_visible_samples <=
                        motion_buffer_schematic_only_visible_samples + 1;
            end
        end
        if (!$isunknown({dut.motion_buffer_cs1_n_from_8j_8l,
                         dut.motion_buffer_cs2_n_from_8j_8l,
                         dut.motion_buffer_oe_n_from_8j_8l})) begin
            motion_buffer_control_known_samples <=
                motion_buffer_control_known_samples + 1;
            if (!dut.motion_buffer_cs1_n_from_8j_8l &&
                !dut.motion_buffer_cs2_n_from_8j_8l &&
                !dut.motion_buffer_oe_n_from_8j_8l)
                motion_buffer_cs_oe_active_samples <=
                    motion_buffer_cs_oe_active_samples + 1;
            else
                motion_buffer_cs_oe_inactive_samples <=
                    motion_buffer_cs_oe_inactive_samples + 1;
        end
        if (dut.motion_buffer_render_write &&
            !$isunknown({dut.motion_buffer_left_ram_write_addr,
                         dut.motion_buffer_right_ram_write_addr,
                         dut.motion_buffer_left_load_addr,
                         dut.motion_buffer_right_load_addr})) begin
            motion_buffer_addr_known_samples <=
                motion_buffer_addr_known_samples + 1;
            motion_buffer_addr_expected_matches <=
                motion_buffer_addr_expected_matches +
                    ((dut.motion_buffer_left_ram_write_addr ==
                      dut.motion_buffer_left_load_addr &&
                      dut.motion_buffer_right_ram_write_addr ==
                      dut.motion_buffer_right_load_addr) ? 1 : 0);
            motion_buffer_addr_adjacent_matches <=
                motion_buffer_addr_adjacent_matches +
                    ((dut.motion_buffer_right_ram_write_addr ==
                      dut.motion_buffer_left_ram_write_addr + 8'd1) ? 1 : 0);
        end
        if (dut.motion_buffer_render_write &&
            !$isunknown({dut.motion_buffer_left_addr_from_7j_7k,
                         dut.motion_buffer_right_addr_from_7l_7m,
                         dut.motion_buffer_left_load_addr,
                         dut.motion_buffer_right_load_addr,
                         dut.motion_buffer_left_load_n,
                         dut.motion_buffer_right_load_n,
                         dut.motion_buffer_left_clear_n,
                         dut.motion_buffer_right_clear_n})) begin
            motion_buffer_counter_addr_known_samples <=
                motion_buffer_counter_addr_known_samples + 1;
            motion_buffer_counter_addr_exact_matches <=
                motion_buffer_counter_addr_exact_matches +
                    ((dut.motion_buffer_left_addr_from_7j_7k ==
                      dut.motion_buffer_left_load_addr &&
                      dut.motion_buffer_right_addr_from_7l_7m ==
                      dut.motion_buffer_right_load_addr) ? 1 : 0);
            motion_buffer_counter_addr_prev_matches <=
                motion_buffer_counter_addr_prev_matches +
                    ((dut.motion_buffer_left_addr_from_7j_7k ==
                      dut.motion_buffer_left_load_addr - 8'd1 &&
                      dut.motion_buffer_right_addr_from_7l_7m ==
                      dut.motion_buffer_right_load_addr - 8'd1) ? 1 : 0);
            motion_buffer_counter_addr_next_matches <=
                motion_buffer_counter_addr_next_matches +
                    ((dut.motion_buffer_left_addr_from_7j_7k ==
                      dut.motion_buffer_left_load_addr + 8'd1 &&
                      dut.motion_buffer_right_addr_from_7l_7m ==
                      dut.motion_buffer_right_load_addr + 8'd1) ? 1 : 0);
            motion_buffer_counter_addr_cross_matches <=
                motion_buffer_counter_addr_cross_matches +
                    ((dut.motion_buffer_left_addr_from_7j_7k ==
                      dut.motion_buffer_right_load_addr &&
                      dut.motion_buffer_right_addr_from_7l_7m ==
                      dut.motion_buffer_left_load_addr) ? 1 : 0);
            if (!dut.motion_buffer_left_load_n)
                motion_buffer_counter_left_load_active <=
                    motion_buffer_counter_left_load_active + 1;
            if (!dut.motion_buffer_right_load_n)
                motion_buffer_counter_right_load_active <=
                    motion_buffer_counter_right_load_active + 1;
            if (!dut.motion_buffer_left_clear_n)
                motion_buffer_counter_left_clear_active <=
                    motion_buffer_counter_left_clear_active + 1;
            if (!dut.motion_buffer_right_clear_n)
                motion_buffer_counter_right_clear_active <=
                    motion_buffer_counter_right_clear_active + 1;
        end
        if (!$isunknown({dut.motion_buffer_left_load_n,
                         dut.motion_buffer_right_load_n,
                         dut.motion_buffer_left_clear_n,
                         dut.motion_buffer_right_clear_n,
                         dut.motion_buffer_9t_clk_en_from_bsm,
                         dut.motion_buffer_render_write})) begin
            motion_buffer_moh_known_samples <=
                motion_buffer_moh_known_samples + 1;
            if (dut.motion_buffer_9t_clk_en_from_bsm) begin
                if (!dut.motion_buffer_left_load_n)
                    motion_buffer_moh_left_load_bsm <=
                        motion_buffer_moh_left_load_bsm + 1;
                if (!dut.motion_buffer_right_load_n)
                    motion_buffer_moh_right_load_bsm <=
                        motion_buffer_moh_right_load_bsm + 1;
                if (!dut.motion_buffer_left_clear_n)
                    motion_buffer_moh_left_clear_bsm <=
                        motion_buffer_moh_left_clear_bsm + 1;
                if (!dut.motion_buffer_right_clear_n)
                    motion_buffer_moh_right_clear_bsm <=
                        motion_buffer_moh_right_clear_bsm + 1;
            end
            if (dut.motion_buffer_render_write) begin
                if (!dut.motion_buffer_left_load_n)
                    motion_buffer_moh_left_load_render <=
                        motion_buffer_moh_left_load_render + 1;
                if (!dut.motion_buffer_right_load_n)
                    motion_buffer_moh_right_load_render <=
                        motion_buffer_moh_right_load_render + 1;
                if (!dut.motion_buffer_left_clear_n)
                    motion_buffer_moh_left_clear_render <=
                        motion_buffer_moh_left_clear_render + 1;
                if (!dut.motion_buffer_right_clear_n)
                    motion_buffer_moh_right_clear_render <=
                        motion_buffer_moh_right_clear_render + 1;
            end
        end

        if (!dut.hblank && !dut.vblank &&
            !$isunknown({dut.lb0_from_8j, dut.lb1_from_8l,
                         dut.lb0_from_9t, dut.lb1_from_9t,
                         dut.mbit_schematic, dut.mbit_compat})) begin
            motion_buffer_raw_b1h =
                dut.b1h ? dut.lb1_from_8l : dut.lb0_from_8j;
            motion_buffer_raw_b1h_n =
                dut.b1h ? dut.lb0_from_8j : dut.lb1_from_8l;
            motion_buffer_raw_b2h =
                dut.b2h ? dut.lb1_from_8l : dut.lb0_from_8j;
            motion_buffer_raw_b4h =
                dut.b4h ? dut.lb1_from_8l : dut.lb0_from_8j;
            motion_buffer_sel_b1h =
                dut.b1h ? dut.lb1_from_9t : dut.lb0_from_9t;
            motion_buffer_sel_b1h_n =
                dut.b1h ? dut.lb0_from_9t : dut.lb1_from_9t;
            motion_buffer_sel_b2h =
                dut.b2h ? dut.lb1_from_9t : dut.lb0_from_9t;
            motion_buffer_sel_b2h_n =
                dut.b2h ? dut.lb0_from_9t : dut.lb1_from_9t;
            motion_buffer_sel_b4h =
                dut.b4h ? dut.lb1_from_9t : dut.lb0_from_9t;
            if (dut.b1h) begin
                if (dut.motion_buffer_read_bank) begin
                    motion_buffer_selected_mem_current =
                        dut.u_8j_motion_buffer_left_ram_bank1.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_prev =
                        dut.u_8j_motion_buffer_left_ram_bank1.mem[dut.hcnt[7:0] - 8'd1];
                    motion_buffer_selected_mem_next =
                        dut.u_8j_motion_buffer_left_ram_bank1.mem[dut.hcnt[7:0] + 8'd1];
                    motion_buffer_selected_mem_other_bank =
                        dut.u_8j_motion_buffer_left_ram_bank0.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_other_side =
                        dut.u_8l_motion_buffer_right_ram_bank1.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_other_side_prev =
                        dut.u_8l_motion_buffer_right_ram_bank1.mem[dut.hcnt[7:0] - 8'd1];
                    motion_buffer_selected_mem_other_side_next =
                        dut.u_8l_motion_buffer_right_ram_bank1.mem[dut.hcnt[7:0] + 8'd1];
                end else begin
                    motion_buffer_selected_mem_current =
                        dut.u_8j_motion_buffer_left_ram_bank0.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_prev =
                        dut.u_8j_motion_buffer_left_ram_bank0.mem[dut.hcnt[7:0] - 8'd1];
                    motion_buffer_selected_mem_next =
                        dut.u_8j_motion_buffer_left_ram_bank0.mem[dut.hcnt[7:0] + 8'd1];
                    motion_buffer_selected_mem_other_bank =
                        dut.u_8j_motion_buffer_left_ram_bank1.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_other_side =
                        dut.u_8l_motion_buffer_right_ram_bank0.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_other_side_prev =
                        dut.u_8l_motion_buffer_right_ram_bank0.mem[dut.hcnt[7:0] - 8'd1];
                    motion_buffer_selected_mem_other_side_next =
                        dut.u_8l_motion_buffer_right_ram_bank0.mem[dut.hcnt[7:0] + 8'd1];
                end
            end else begin
                if (dut.motion_buffer_read_bank) begin
                    motion_buffer_selected_mem_current =
                        dut.u_8l_motion_buffer_right_ram_bank1.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_prev =
                        dut.u_8l_motion_buffer_right_ram_bank1.mem[dut.hcnt[7:0] - 8'd1];
                    motion_buffer_selected_mem_next =
                        dut.u_8l_motion_buffer_right_ram_bank1.mem[dut.hcnt[7:0] + 8'd1];
                    motion_buffer_selected_mem_other_bank =
                        dut.u_8l_motion_buffer_right_ram_bank0.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_other_side =
                        dut.u_8j_motion_buffer_left_ram_bank1.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_other_side_prev =
                        dut.u_8j_motion_buffer_left_ram_bank1.mem[dut.hcnt[7:0] - 8'd1];
                    motion_buffer_selected_mem_other_side_next =
                        dut.u_8j_motion_buffer_left_ram_bank1.mem[dut.hcnt[7:0] + 8'd1];
                end else begin
                    motion_buffer_selected_mem_current =
                        dut.u_8l_motion_buffer_right_ram_bank0.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_prev =
                        dut.u_8l_motion_buffer_right_ram_bank0.mem[dut.hcnt[7:0] - 8'd1];
                    motion_buffer_selected_mem_next =
                        dut.u_8l_motion_buffer_right_ram_bank0.mem[dut.hcnt[7:0] + 8'd1];
                    motion_buffer_selected_mem_other_bank =
                        dut.u_8l_motion_buffer_right_ram_bank1.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_other_side =
                        dut.u_8j_motion_buffer_left_ram_bank0.mem[dut.hcnt[7:0]];
                    motion_buffer_selected_mem_other_side_prev =
                        dut.u_8j_motion_buffer_left_ram_bank0.mem[dut.hcnt[7:0] - 8'd1];
                    motion_buffer_selected_mem_other_side_next =
                        dut.u_8j_motion_buffer_left_ram_bank0.mem[dut.hcnt[7:0] + 8'd1];
                end
            end
            motion_buffer_selected_window_has_match = 1'b0;
            motion_buffer_other_window_has_match = 1'b0;
            for (motion_window_i = -8; motion_window_i <= 8;
                 motion_window_i = motion_window_i + 1) begin
                if (dut.b1h) begin
                    if (dut.motion_buffer_read_bank) begin
                        if (dut.u_8j_motion_buffer_left_ram_bank1.mem[
                            dut.hcnt[7:0] + motion_window_i[7:0]] ==
                            mbit_compat_d1_tb)
                            motion_buffer_selected_window_has_match = 1'b1;
                        if (dut.u_8l_motion_buffer_right_ram_bank1.mem[
                            dut.hcnt[7:0] + motion_window_i[7:0]] ==
                            mbit_compat_d1_tb) begin
                            motion_buffer_other_window_has_match = 1'b1;
                            if (dut.mbit_schematic == 4'd0 &&
                                mbit_compat_d1_tb != 4'd0)
                                motion_buffer_other_window_match_offset[
                                    motion_window_i + 8] <=
                                    motion_buffer_other_window_match_offset[
                                        motion_window_i + 8] + 1;
                        end
                    end else begin
                        if (dut.u_8j_motion_buffer_left_ram_bank0.mem[
                            dut.hcnt[7:0] + motion_window_i[7:0]] ==
                            mbit_compat_d1_tb)
                            motion_buffer_selected_window_has_match = 1'b1;
                        if (dut.u_8l_motion_buffer_right_ram_bank0.mem[
                            dut.hcnt[7:0] + motion_window_i[7:0]] ==
                            mbit_compat_d1_tb) begin
                            motion_buffer_other_window_has_match = 1'b1;
                            if (dut.mbit_schematic == 4'd0 &&
                                mbit_compat_d1_tb != 4'd0)
                                motion_buffer_other_window_match_offset[
                                    motion_window_i + 8] <=
                                    motion_buffer_other_window_match_offset[
                                        motion_window_i + 8] + 1;
                        end
                    end
                end else begin
                    if (dut.motion_buffer_read_bank) begin
                        if (dut.u_8l_motion_buffer_right_ram_bank1.mem[
                            dut.hcnt[7:0] + motion_window_i[7:0]] ==
                            mbit_compat_d1_tb)
                            motion_buffer_selected_window_has_match = 1'b1;
                        if (dut.u_8j_motion_buffer_left_ram_bank1.mem[
                            dut.hcnt[7:0] + motion_window_i[7:0]] ==
                            mbit_compat_d1_tb) begin
                            motion_buffer_other_window_has_match = 1'b1;
                            if (dut.mbit_schematic == 4'd0 &&
                                mbit_compat_d1_tb != 4'd0)
                                motion_buffer_other_window_match_offset[
                                    motion_window_i + 8] <=
                                    motion_buffer_other_window_match_offset[
                                        motion_window_i + 8] + 1;
                        end
                    end else begin
                        if (dut.u_8l_motion_buffer_right_ram_bank0.mem[
                            dut.hcnt[7:0] + motion_window_i[7:0]] ==
                            mbit_compat_d1_tb)
                            motion_buffer_selected_window_has_match = 1'b1;
                        if (dut.u_8j_motion_buffer_left_ram_bank0.mem[
                            dut.hcnt[7:0] + motion_window_i[7:0]] ==
                            mbit_compat_d1_tb) begin
                            motion_buffer_other_window_has_match = 1'b1;
                            if (dut.mbit_schematic == 4'd0 &&
                                mbit_compat_d1_tb != 4'd0)
                                motion_buffer_other_window_match_offset[
                                    motion_window_i + 8] <=
                                    motion_buffer_other_window_match_offset[
                                        motion_window_i + 8] + 1;
                        end
                    end
                end
            end
            if (dut.lb0_from_9t != 4'd0 || dut.lb1_from_9t != 4'd0)
                motion_buffer_lb_nonzero_samples <=
                    motion_buffer_lb_nonzero_samples + 1;
            if (dut.lb0_from_8j != 4'd0 || dut.lb1_from_8l != 4'd0)
                motion_buffer_raw_lb_nonzero_samples <=
                    motion_buffer_raw_lb_nonzero_samples + 1;
            if (motion_buffer_raw_b1h != 4'd0)
                motion_buffer_raw_b1h_nonzero <=
                    motion_buffer_raw_b1h_nonzero + 1;
            if (motion_buffer_raw_b1h_n != 4'd0)
                motion_buffer_raw_b1h_n_nonzero <=
                    motion_buffer_raw_b1h_n_nonzero + 1;
            if (motion_buffer_raw_b2h != 4'd0)
                motion_buffer_raw_b2h_nonzero <=
                    motion_buffer_raw_b2h_nonzero + 1;
            if (motion_buffer_raw_b4h != 4'd0)
                motion_buffer_raw_b4h_nonzero <=
                    motion_buffer_raw_b4h_nonzero + 1;
            if (dut.mbit_compat != 4'd0) begin
                motion_buffer_compat_nonzero_samples <=
                    motion_buffer_compat_nonzero_samples + 1;
                if (motion_buffer_raw_b1h_n == 4'd0) begin
                    motion_buffer_compat_raw_missing <=
                        motion_buffer_compat_raw_missing + 1;
                    if (motion_buffer_compat_raw_missing_first_h < 0) begin
                        motion_buffer_compat_raw_missing_first_h <= dut.hcnt;
                        motion_buffer_compat_raw_missing_first_v <= dut.vcnt;
                    end
                    motion_buffer_compat_raw_missing_last_h <= dut.hcnt;
                    motion_buffer_compat_raw_missing_last_v <= dut.vcnt;
                end
                if (motion_buffer_sel_b1h_n == 4'd0)
                    motion_buffer_compat_latched_missing <=
                        motion_buffer_compat_latched_missing + 1;
                if (dut.mbit_schematic == 4'd0)
                    motion_buffer_compat_schematic_missing <=
                        motion_buffer_compat_schematic_missing + 1;
            end
            if (mbit_compat_d1_tb != 4'd0) begin
                motion_buffer_compat_d1_nonzero_samples <=
                    motion_buffer_compat_d1_nonzero_samples + 1;
                if (!$isunknown(dut.mbit_schematic_single_addr)) begin
                    if (dut.mbit_schematic_single_addr != 4'd0)
                        motion_buffer_single_addr_nonzero_samples <=
                            motion_buffer_single_addr_nonzero_samples + 1;
                    if (dut.mbit_schematic_single_addr == dut.mbit_compat)
                        motion_buffer_single_addr_now_matches <=
                            motion_buffer_single_addr_now_matches + 1;
                    if (dut.mbit_schematic_single_addr == mbit_compat_d1_tb)
                        motion_buffer_single_addr_d1_matches <=
                            motion_buffer_single_addr_d1_matches + 1;
                    if (dut.mbit_schematic_single_addr == mbit_compat_d2_tb)
                        motion_buffer_single_addr_d2_matches <=
                            motion_buffer_single_addr_d2_matches + 1;
                    if (dut.mbit_schematic_single_addr == mbit_compat_d3_tb)
                        motion_buffer_single_addr_d3_matches <=
                            motion_buffer_single_addr_d3_matches + 1;
                    if (dut.mbit_schematic_single_addr == 4'd0)
                        motion_buffer_single_addr_d1_missing <=
                            motion_buffer_single_addr_d1_missing + 1;
                end
                if (dut.mbit_schematic == 4'd0) begin
                    motion_buffer_compat_d1_schematic_missing <=
                        motion_buffer_compat_d1_schematic_missing + 1;
                    if (!$isunknown(dut.mbit_schematic_single_addr) &&
                        dut.mbit_schematic_single_addr != 4'd0)
                        motion_buffer_single_addr_fills_bridge_missing <=
                            motion_buffer_single_addr_fills_bridge_missing + 1;
                    if (motion_buffer_compat_d1_missing_first_h < 0) begin
                        motion_buffer_compat_d1_missing_first_h <= dut.hcnt;
                        motion_buffer_compat_d1_missing_first_v <= dut.vcnt;
                    end
                    motion_buffer_compat_d1_missing_last_h <= dut.hcnt;
                    motion_buffer_compat_d1_missing_last_v <= dut.vcnt;
                    if (motion_buffer_raw_b1h_n != 4'd0)
                        motion_buffer_compat_d1_missing_raw_present <=
                            motion_buffer_compat_d1_missing_raw_present + 1;
                    if (motion_buffer_sel_b1h_n != 4'd0)
                        motion_buffer_compat_d1_missing_latched_present <=
                            motion_buffer_compat_d1_missing_latched_present + 1;
                    if (motion_buffer_selected_mem_current != 4'd0)
                        motion_buffer_compat_d1_missing_mem_current <=
                            motion_buffer_compat_d1_missing_mem_current + 1;
                    if (motion_buffer_selected_mem_prev != 4'd0)
                        motion_buffer_compat_d1_missing_mem_prev <=
                            motion_buffer_compat_d1_missing_mem_prev + 1;
                    if (motion_buffer_selected_mem_next != 4'd0)
                        motion_buffer_compat_d1_missing_mem_next <=
                            motion_buffer_compat_d1_missing_mem_next + 1;
                    if (motion_buffer_selected_mem_other_bank != 4'd0)
                        motion_buffer_compat_d1_missing_mem_other_bank <=
                            motion_buffer_compat_d1_missing_mem_other_bank + 1;
                    if (motion_buffer_selected_mem_other_side != 4'd0) begin
                        motion_buffer_compat_d1_missing_mem_other_side <=
                            motion_buffer_compat_d1_missing_mem_other_side + 1;
                        if (motion_buffer_selected_mem_other_side ==
                            mbit_compat_d1_tb)
                            motion_buffer_compat_d1_missing_mem_other_side_match <=
                                motion_buffer_compat_d1_missing_mem_other_side_match + 1;
                    end
                    if (motion_buffer_selected_mem_other_side_prev != 4'd0) begin
                        motion_buffer_compat_d1_missing_mem_other_side_prev <=
                            motion_buffer_compat_d1_missing_mem_other_side_prev + 1;
                        if (motion_buffer_selected_mem_other_side_prev ==
                            mbit_compat_d1_tb)
                            motion_buffer_compat_d1_missing_mem_other_side_prev_match <=
                                motion_buffer_compat_d1_missing_mem_other_side_prev_match + 1;
                    end
                    if (motion_buffer_selected_mem_other_side_next != 4'd0) begin
                        motion_buffer_compat_d1_missing_mem_other_side_next <=
                            motion_buffer_compat_d1_missing_mem_other_side_next + 1;
                        if (motion_buffer_selected_mem_other_side_next ==
                            mbit_compat_d1_tb)
                            motion_buffer_compat_d1_missing_mem_other_side_next_match <=
                                motion_buffer_compat_d1_missing_mem_other_side_next_match + 1;
                    end
                    if (motion_buffer_selected_window_has_match)
                        motion_buffer_compat_d1_missing_selected_window_match <=
                            motion_buffer_compat_d1_missing_selected_window_match + 1;
                    if (motion_buffer_other_window_has_match)
                        motion_buffer_compat_d1_missing_other_window_match <=
                            motion_buffer_compat_d1_missing_other_window_match + 1;
                    if (dut.motion_buffer_data_from_8k == dut.mbj_pending0)
                        motion_buffer_compat_d1_missing_8k_mbj <=
                            motion_buffer_compat_d1_missing_8k_mbj + 1;
                    if (dut.motion_buffer_data_from_8k == dut.lb0_feedback_for_8k)
                        motion_buffer_compat_d1_missing_8k_feedback <=
                            motion_buffer_compat_d1_missing_8k_feedback + 1;
                    if (dut.motion_buffer_data_from_8m == dut.mbj_pending1)
                        motion_buffer_compat_d1_missing_8m_mbj <=
                            motion_buffer_compat_d1_missing_8m_mbj + 1;
                    if (dut.motion_buffer_data_from_8m == dut.lb1_feedback_for_8m)
                        motion_buffer_compat_d1_missing_8m_feedback <=
                            motion_buffer_compat_d1_missing_8m_feedback + 1;
                    if (dut.ivdsh_from_7f)
                        motion_buffer_compat_d1_missing_ivdsh_high <=
                            motion_buffer_compat_d1_missing_ivdsh_high + 1;
                    if (dut.ivdbh_from_7f)
                        motion_buffer_compat_d1_missing_ivdbh_high <=
                            motion_buffer_compat_d1_missing_ivdbh_high + 1;
                end
                if (dut.mbit_schematic != 4'd0 &&
                    dut.mbit_schematic != mbit_compat_d1_tb)
                    motion_buffer_compat_d1_schematic_value_mismatch <=
                        motion_buffer_compat_d1_schematic_value_mismatch + 1;
            end
            if (motion_buffer_sel_b1h != 4'd0)
                motion_buffer_sel_b1h_nonzero <=
                    motion_buffer_sel_b1h_nonzero + 1;
            motion_buffer_sel_b1h_matches <=
                motion_buffer_sel_b1h_matches +
                ((motion_buffer_sel_b1h == dut.mbit_compat) ? 1 : 0);
            if (motion_buffer_sel_b1h_n != 4'd0)
                motion_buffer_sel_b1h_n_nonzero <=
                    motion_buffer_sel_b1h_n_nonzero + 1;
            motion_buffer_sel_b1h_n_matches <=
                motion_buffer_sel_b1h_n_matches +
                ((motion_buffer_sel_b1h_n == dut.mbit_compat) ? 1 : 0);
            if (motion_buffer_sel_b2h != 4'd0)
                motion_buffer_sel_b2h_nonzero <=
                    motion_buffer_sel_b2h_nonzero + 1;
            motion_buffer_sel_b2h_matches <=
                motion_buffer_sel_b2h_matches +
                ((motion_buffer_sel_b2h == dut.mbit_compat) ? 1 : 0);
            if (motion_buffer_sel_b2h_n != 4'd0)
                motion_buffer_sel_b2h_n_nonzero <=
                    motion_buffer_sel_b2h_n_nonzero + 1;
            motion_buffer_sel_b2h_n_matches <=
                motion_buffer_sel_b2h_n_matches +
                ((motion_buffer_sel_b2h_n == dut.mbit_compat) ? 1 : 0);
            if (motion_buffer_sel_b4h != 4'd0)
                motion_buffer_sel_b4h_nonzero <=
                    motion_buffer_sel_b4h_nonzero + 1;
            motion_buffer_sel_b4h_matches <=
                motion_buffer_sel_b4h_matches +
                ((motion_buffer_sel_b4h == dut.mbit_compat) ? 1 : 0);
            if (dut.mbit_schematic != 4'd0) begin
                motion_buffer_mbit_nonzero_samples <=
                    motion_buffer_mbit_nonzero_samples + 1;
                motion_buffer_mbit_nonzero_compat_now <=
                    motion_buffer_mbit_nonzero_compat_now +
                    ((dut.mbit_compat != 4'd0) ? 1 : 0);
                motion_buffer_mbit_nonzero_compat_d1 <=
                    motion_buffer_mbit_nonzero_compat_d1 +
                    ((mbit_compat_d1_tb != 4'd0) ? 1 : 0);
                motion_buffer_mbit_nonzero_compat_d2 <=
                    motion_buffer_mbit_nonzero_compat_d2 +
                    ((mbit_compat_d2_tb != 4'd0) ? 1 : 0);
                motion_buffer_mbit_nonzero_compat_d3 <=
                    motion_buffer_mbit_nonzero_compat_d3 +
                    ((mbit_compat_d3_tb != 4'd0) ? 1 : 0);
                if (motion_buffer_mbit_first_h < 0) begin
                    motion_buffer_mbit_first_h <= dut.hcnt;
                    motion_buffer_mbit_first_v <= dut.vcnt;
                end
                motion_buffer_mbit_last_h <= dut.hcnt;
                motion_buffer_mbit_last_v <= dut.vcnt;
            end
        end

        if (!$isunknown({dut.pl1_inputs_to_9n, dut.pl2_inputs_to_9p,
                         dut.system_inputs_to_9r, dut.bvblank})) begin
            input_buffer_known_samples <= input_buffer_known_samples + 1;
            input_buffer_expected_matches <= input_buffer_expected_matches +
                ((dut.pl1_inputs_to_9n == tb_pl1_expected &&
                  dut.pl2_inputs_to_9p == tb_pl2_expected &&
                  dut.system_inputs_to_9r == tb_system_expected) ? 1 : 0);
        end

        if (!$isunknown({dut.blank_n_from_4j, dut.hblank, dut.vblank})) begin
            blank_gate_known_samples <= blank_gate_known_samples + 1;
            blank_gate_expected_matches <= blank_gate_expected_matches +
                ((dut.blank_n_from_4j == (!dut.hblank && !dut.vblank)) ? 1 : 0);
        end

        if (!dut.hblank && !dut.vblank) begin
            pbit_compat_d3_tb <= dut.pbit_compat_d2;
            mbit_compat_d1_tb <= dut.mbit_compat;
            mbit_compat_d2_tb <= mbit_compat_d1_tb;
            mbit_compat_d3_tb <= mbit_compat_d2_tb;
            color_inverted_d1 <= dut.color_ram_inverted_outputs;
            color_inverted_d2 <= color_inverted_d1;
            colsel_expected =
                dut.colram ? 2'b11 :
                (dut.mbit != 4'd0) ? 2'b10 :
                (dut.bmap[2:0] != 3'd0) ? 2'b01 :
                2'b00;
            cola_expected =
                colsel_expected == 2'b11 ? dut.ma[5:0] :
                colsel_expected == 2'b10 ? {2'b10, dut.mbit} :
                colsel_expected == 2'b01 ? {2'b01, dut.bmap[3:0]} :
                {2'b00, dut.pbit};
            pf_samples <= pf_samples + 1;
            if (!$isunknown({
                dut.pf_pbit_compare_now_match,
                dut.pf_pbit_compare_d1_match,
                dut.pf_pbit_compare_d2_match,
                pbit_compat_d3_tb,
                dut.pbit_n_from_ls194,
                dut.pbit_f_from_ls194,
                dut.pbit_compat
            })) begin
                pf_known_samples <= pf_known_samples + 1;
                pf_now_matches <= pf_now_matches + (dut.pf_pbit_compare_now_match ? 1 : 0);
                pf_d1_matches <= pf_d1_matches + (dut.pf_pbit_compare_d1_match ? 1 : 0);
                pf_d2_matches <= pf_d2_matches + (dut.pf_pbit_compare_d2_match ? 1 : 0);
                pf_d3_matches <= pf_d3_matches + ((dut.pbit_from_4n == pbit_compat_d3_tb) ? 1 : 0);
                pf_n_now_matches <= pf_n_now_matches + ((dut.pbit_n_from_ls194 == dut.pbit_compat) ? 1 : 0);
                pf_n_d1_matches <= pf_n_d1_matches + ((dut.pbit_n_from_ls194 == dut.pbit_compat_d1) ? 1 : 0);
                pf_n_d2_matches <= pf_n_d2_matches + ((dut.pbit_n_from_ls194 == dut.pbit_compat_d2) ? 1 : 0);
                pf_n_d3_matches <= pf_n_d3_matches + ((dut.pbit_n_from_ls194 == pbit_compat_d3_tb) ? 1 : 0);
                pf_f_now_matches <= pf_f_now_matches + ((dut.pbit_f_from_ls194 == dut.pbit_compat) ? 1 : 0);
                pf_f_d1_matches <= pf_f_d1_matches + ((dut.pbit_f_from_ls194 == dut.pbit_compat_d1) ? 1 : 0);
                pf_f_d2_matches <= pf_f_d2_matches + ((dut.pbit_f_from_ls194 == dut.pbit_compat_d2) ? 1 : 0);
                pf_f_d3_matches <= pf_f_d3_matches + ((dut.pbit_f_from_ls194 == pbit_compat_d3_tb) ? 1 : 0);
            end
            if (!$isunknown({dut.mbit_schematic,
                             dut.mbit_compat,
                             mbit_compat_d1_tb,
                             mbit_compat_d2_tb,
                             mbit_compat_d3_tb})) begin
                motion_buffer_known_samples <= motion_buffer_known_samples + 1;
                motion_buffer_now_matches <= motion_buffer_now_matches +
                    ((dut.mbit_schematic == dut.mbit_compat) ? 1 : 0);
                motion_buffer_d1_matches <= motion_buffer_d1_matches +
                    ((dut.mbit_schematic == mbit_compat_d1_tb) ? 1 : 0);
                motion_buffer_d2_matches <= motion_buffer_d2_matches +
                    ((dut.mbit_schematic == mbit_compat_d2_tb) ? 1 : 0);
                motion_buffer_d3_matches <= motion_buffer_d3_matches +
                    ((dut.mbit_schematic == mbit_compat_d3_tb) ? 1 : 0);
            end
            if (!$isunknown({dut.colsel_from_gates, colsel_expected})) begin
                colsel_known_samples <= colsel_known_samples + 1;
                colsel_expected_matches <= colsel_expected_matches +
                    ((dut.colsel_from_gates == colsel_expected) ? 1 : 0);
            end
            if (!$isunknown({dut.cola_video_from_mux_tree, cola_expected})) begin
                cola_known_samples <= cola_known_samples + 1;
                cola_expected_matches <= cola_expected_matches +
                    ((dut.cola_video_from_mux_tree == cola_expected) ? 1 : 0);
            end
            if (!$isunknown({dut.palette_index, dut.cola_video_from_mux_tree})) begin
                palette_index_known_samples <= palette_index_known_samples + 1;
                palette_index_cola_matches <= palette_index_cola_matches +
                    ((dut.palette_index == dut.cola_video_from_mux_tree) ? 1 : 0);
            end
            if (!$isunknown({dut.cr_latched_outputs, dut.color_ram_inverted_outputs,
                             color_inverted_d1, color_inverted_d2})) begin
                color_latch_known_samples <= color_latch_known_samples + 1;
                color_latch_now_matches <= color_latch_now_matches +
                    ((dut.cr_latched_outputs == dut.color_ram_inverted_outputs) ? 1 : 0);
                color_latch_d1_matches <= color_latch_d1_matches +
                    ((dut.cr_latched_outputs == color_inverted_d1) ? 1 : 0);
                color_latch_d2_matches <= color_latch_d2_matches +
                    ((dut.cr_latched_outputs == color_inverted_d2) ? 1 : 0);
            end
            if (!$isunknown({dut.rgb_bits, dut.cr_latched_outputs})) begin
                rgb_bits_known_samples <= rgb_bits_known_samples + 1;
                rgb_bits_latch_matches <= rgb_bits_latch_matches +
                    ((dut.rgb_bits == dut.cr_latched_outputs) ? 1 : 0);
            end
        end
    end
end

initial begin
    for (init_i = 0; init_i < 256; init_i = init_i + 1) begin
        dut.sync_prom[init_i] = 8'd0;
    end
    // Optional: pass +PROM_HEX=<path> to compare the real 136023-116.3n PROM.
    if ($test$plusargs("PROM_HEX") &&
        $value$plusargs("PROM_HEX=%s", prom_hex_path)) begin
        $readmemh(prom_hex_path, dut.sync_prom);
    end

    for (init_i = 0; init_i < 1024; init_i = init_i + 1) begin
        dut.playfield_ram.mem[init_i] = init_i[7:0];
    end
    for (init_i = 0; init_i < 64; init_i = init_i + 1) begin
        dut.palette_ram[init_i] = {init_i[2:0], init_i[5:3], init_i[2:0] ^ init_i[5:3]};
    end
    for (init_i = 0; init_i < 256; init_i = init_i + 1) begin
        dut.sprite_line0[init_i] = (init_i[3:0] == 4'h0) ? 4'h0 : init_i[3:0];
        dut.sprite_line1[init_i] = (init_i[4:1] == 4'h0) ? 4'h0 : init_i[4:1];
        dut.motion_ram_6l[init_i] = 4'd0;
        dut.motion_ram_6m[init_i] = 4'd0;
        dut.u_8j_motion_buffer_left_ram_bank0.mem[init_i] = 4'd0;
        dut.u_8j_motion_buffer_left_ram_bank1.mem[init_i] = 4'd0;
        dut.u_8l_motion_buffer_right_ram_bank0.mem[init_i] = 4'd0;
        dut.u_8l_motion_buffer_right_ram_bank1.mem[init_i] = 4'd0;
    end
    for (init_i = 0; init_i < 2048; init_i = init_i + 1) begin
        dut.playfield_ram_4lm_observe.mem[init_i] = init_i[7:0];
    end
    for (init_i = 0; init_i < 4096; init_i = init_i + 1) begin
        dut.char_graphics_5n.mem[init_i] = {init_i[0], init_i[1], init_i[2], init_i[3],
                                             init_i[4], init_i[5], init_i[6], init_i[7]};
        dut.char_graphics_5r.mem[init_i] = {init_i[7], init_i[6], init_i[5], init_i[4],
                                             init_i[3], init_i[2], init_i[1], init_i[0]};
        dut.motion_graphics_6n.mem[init_i] = 8'ha5;
        dut.motion_graphics_8r.mem[init_i] = 8'h5a;
    end
    // Seed one object into the current schematic-style vertical match window.
    // Object 63 is scanned first after hblank; Y=E0 matches visible render_y
    // values 10..1F through the 5J high-nibble decode.
    dut.motion_ram_6l[8'h3f] = 4'h0;
    dut.motion_ram_6m[8'h3f] = 4'he;
    dut.motion_ram_6l[8'h7f] = 4'd0;
    dut.motion_ram_6m[8'h7f] = 4'd0;
    dut.motion_ram_6l[8'hff] = 4'h0;
    dut.motion_ram_6m[8'hff] = 4'h2;
    for (init_i = 0; init_i < 65536; init_i = init_i + 1) begin
        dut.bitmap0.mem[init_i] = (init_i[2:0] == 3'h0) ? 4'h0 : {1'b0, init_i[2:0]};
        dut.bitmap1.mem[init_i] = (init_i[3:1] == 3'h0) ? 4'h0 : {1'b0, init_i[3:1]};
    end

    repeat (10) @(posedge clk);
    reset <= 0;
    repeat (SIM_FRAME_CLOCKS) @(posedge clk);
    $display("Simulation window ce_pixels=%0d", SIM_FRAME_PIXELS);
    $display("PF compare samples=%0d known=%0d now=%0d d1=%0d d2=%0d d3=%0d",
             pf_samples, pf_known_samples,
             pf_now_matches, pf_d1_matches, pf_d2_matches, pf_d3_matches);
    $display("PF normal-end matches now=%0d d1=%0d d2=%0d d3=%0d",
             pf_n_now_matches, pf_n_d1_matches, pf_n_d2_matches, pf_n_d3_matches);
    $display("PF flipped-end matches now=%0d d1=%0d d2=%0d d3=%0d",
             pf_f_now_matches, pf_f_d1_matches, pf_f_d2_matches, pf_f_d3_matches);
    $display("COLSEL compare known=%0d expected=%0d",
             colsel_known_samples, colsel_expected_matches);
    $display("COLA compare known=%0d expected=%0d",
             cola_known_samples, cola_expected_matches);
    $display("Palette index COLA compare known=%0d expected=%0d",
             palette_index_known_samples, palette_index_cola_matches);
    $display("Color latch compare known=%0d now=%0d d1=%0d d2=%0d",
             color_latch_known_samples, color_latch_now_matches,
             color_latch_d1_matches, color_latch_d2_matches);
    $display("RGB bits latch compare known=%0d expected=%0d",
             rgb_bits_known_samples, rgb_bits_latch_matches);
    $display("Blank gate compare known=%0d expected=%0d",
             blank_gate_known_samples, blank_gate_expected_matches);
    $display("Input buffer harness compare known=%0d expected=%0d",
             input_buffer_known_samples, input_buffer_expected_matches);
    $display("Custom timing fallback compare known=%0d expected=%0d",
             custom_timing_known_samples, custom_timing_expected_matches);
    $display("HBLANK 3C boundary compare known=%0d expected=%0d",
             hblank_boundary_known_samples, hblank_boundary_expected_matches);
    $display("HBLANK 3B/3C latch compare known=%0d q=%0d qn=%0d",
             hblank_latched_known_samples, hblank_latched_q_matches,
             hblank_latched_qn_matches);
    $display("HBLANK 3B/3C transitions first=%0d second=%0d rise=%0d q=%0d qn=%0d",
             hblank_3b_first_transitions, hblank_3b_second_transitions,
             hblank_3b_second_rise_count,
             hblank_3c_q_transitions, hblank_3c_qn_transitions);
    $display("HBLANK 3B/3C high samples first=%0d second=%0d q=%0d qn=%0d",
             hblank_3b_first_high_samples, hblank_3b_second_high_samples,
             hblank_3c_q_high_samples, hblank_3c_qn_high_samples);
    $display("HBLANK 3B/3C latch mismatch span q=%0d first=%0d,%0d last=%0d,%0d qn=%0d first=%0d,%0d last=%0d,%0d",
             hblank_latched_q_mismatches,
             hblank_latched_first_q_h, hblank_latched_first_q_v,
             hblank_latched_last_q_h, hblank_latched_last_q_v,
             hblank_latched_qn_mismatches,
             hblank_latched_first_qn_h, hblank_latched_first_qn_v,
             hblank_latched_last_qn_h, hblank_latched_last_qn_v);
    $display("Sync 4B/4D gate compare known=%0d vsync=%0d compsync=%0d",
             sync_gate_known_samples, vsync_4b_expected_matches,
             compsync_4b_expected_matches);
    $display("Sync 4B/4D from 4N compare known=%0d vsync=%0d compsync=%0d",
             sync_gate_4n_known_samples, vsync_4b_4n_expected_matches,
             compsync_4b_4n_expected_matches);
    $display("Sync 4B/4D from 4N mismatch span vsync=%0d first=%0d,%0d last=%0d,%0d compsync=%0d first=%0d,%0d last=%0d,%0d",
             sync_gate_4n_vsync_mismatches,
             sync_gate_4n_first_vsync_h, sync_gate_4n_first_vsync_v,
             sync_gate_4n_last_vsync_h, sync_gate_4n_last_vsync_v,
             sync_gate_4n_compsync_mismatches,
             sync_gate_4n_first_compsync_h, sync_gate_4n_first_compsync_v,
             sync_gate_4n_last_compsync_h, sync_gate_4n_last_compsync_v);
    $display("Sync 4B/4D from 4N frame-origin compare known=%0d vsync=%0d compsync=%0d",
             sync_gate_4n_wrap_known_samples,
             vsync_4b_4n_wrap_matches,
             compsync_4b_4n_wrap_matches);
    $display("PROM 3N/4N timing compare known=%0d vsync_q=%0d vsync_qn=%0d vblank_q=%0d vblank_qn=%0d hblank_q=%0d hblank_qn=%0d b256_q=%0d b256_qn=%0d",
             prom_timing_known_samples,
             prom_vsync_q_matches, prom_vsync_qn_matches,
             prom_vblank_q_matches, prom_vblank_qn_matches,
             prom_hblank_q_matches, prom_hblank_qn_matches,
             prom_256h_q_matches, prom_256h_qn_matches);
    $display("4N label compare known=%0d vsync=%0d vsync_n=%0d vblank=%0d vblank_n=%0d",
             sync_4n_label_known_samples,
             sync_4n_vsync_matches, sync_4n_vsync_n_matches,
             sync_4n_vblank_matches, sync_4n_vblank_n_matches);
    $display("Motion ROM parallel pair compare known=%0d p0=%0d p1=%0d",
             motion_parallel_known_samples,
             motion_parallel_pair0_matches, motion_parallel_pair1_matches);
    $display("Motion buffer 9H compare known=%0d now=%0d d1=%0d d2=%0d d3=%0d",
             motion_buffer_known_samples,
             motion_buffer_now_matches, motion_buffer_d1_matches,
             motion_buffer_d2_matches, motion_buffer_d3_matches);
    $display("Motion buffer activity writes=%0d render=%0d clear=%0d data_nonzero=%0d lb_nonzero=%0d mbit_nonzero=%0d compat_nonzero=%0d",
             motion_buffer_write_samples,
             motion_buffer_render_write_samples,
             motion_buffer_clear_write_samples,
             motion_buffer_data_nonzero_samples,
             motion_buffer_lb_nonzero_samples,
             motion_buffer_mbit_nonzero_samples,
             motion_buffer_compat_nonzero_samples);
    $display("Motion buffer 93422 WE compare schematic_bsm=%0d bridge=%0d overlap=%0d bridge_only=%0d schematic_only=%0d blank=%0d render=%0d visible=%0d",
             motion_buffer_schematic_we_samples,
             motion_buffer_write_samples,
             motion_buffer_bridge_we_overlap_samples,
             motion_buffer_bridge_only_we_samples,
             motion_buffer_schematic_only_we_samples,
             motion_buffer_schematic_only_blank_samples,
             motion_buffer_schematic_only_render_samples,
             motion_buffer_schematic_only_visible_samples);
    $display("Motion buffer 9T/WE phase clk=%0d we_overlap=%0d bridge_overlap=%0d blank=%0d visible=%0d",
             motion_buffer_9t_clk_samples,
             motion_buffer_9t_we_overlap_samples,
             motion_buffer_9t_bridge_overlap_samples,
             motion_buffer_9t_blank_samples,
             motion_buffer_9t_visible_samples);
    $display("Motion buffer 93422 control known=%0d cs_oe_active=%0d cs_oe_inactive=%0d",
             motion_buffer_control_known_samples,
             motion_buffer_cs_oe_active_samples,
             motion_buffer_cs_oe_inactive_samples);
    $display("Motion buffer address compare known=%0d expected=%0d adjacent=%0d",
             motion_buffer_addr_known_samples,
             motion_buffer_addr_expected_matches,
             motion_buffer_addr_adjacent_matches);
    $display("Motion buffer counter address compare known=%0d exact=%0d prev=%0d next=%0d cross=%0d left_load=%0d right_load=%0d left_clear=%0d right_clear=%0d",
             motion_buffer_counter_addr_known_samples,
             motion_buffer_counter_addr_exact_matches,
             motion_buffer_counter_addr_prev_matches,
             motion_buffer_counter_addr_next_matches,
             motion_buffer_counter_addr_cross_matches,
             motion_buffer_counter_left_load_active,
             motion_buffer_counter_right_load_active,
             motion_buffer_counter_left_clear_active,
             motion_buffer_counter_right_clear_active);
    $display("Motion buffer MOH phase known=%0d bsm_ll=%0d bsm_rl=%0d bsm_lc=%0d bsm_rc=%0d render_ll=%0d render_rl=%0d render_lc=%0d render_rc=%0d",
             motion_buffer_moh_known_samples,
             motion_buffer_moh_left_load_bsm,
             motion_buffer_moh_right_load_bsm,
             motion_buffer_moh_left_clear_bsm,
             motion_buffer_moh_right_clear_bsm,
             motion_buffer_moh_left_load_render,
             motion_buffer_moh_right_load_render,
             motion_buffer_moh_left_clear_render,
             motion_buffer_moh_right_clear_render);
    $display("Motion buffer 8K/8M render data left_nonzero=%0d right_nonzero=%0d mbj0_nonzero=%0d mbj1_nonzero=%0d 8k_mbj=%0d 8m_mbj=%0d 8k_fb=%0d 8m_fb=%0d",
             motion_buffer_left_data_nonzero_samples,
             motion_buffer_right_data_nonzero_samples,
             motion_buffer_mbj0_nonzero_samples,
             motion_buffer_mbj1_nonzero_samples,
             motion_buffer_8k_mbj_matches,
             motion_buffer_8m_mbj_matches,
             motion_buffer_8k_feedback_matches,
             motion_buffer_8m_feedback_matches);
    $display("Motion buffer nonzero overlap now=%0d d1=%0d d2=%0d d3=%0d span first=%0d,%0d last=%0d,%0d",
             motion_buffer_mbit_nonzero_compat_now,
             motion_buffer_mbit_nonzero_compat_d1,
             motion_buffer_mbit_nonzero_compat_d2,
             motion_buffer_mbit_nonzero_compat_d3,
             motion_buffer_mbit_first_h,
             motion_buffer_mbit_first_v,
             motion_buffer_mbit_last_h,
             motion_buffer_mbit_last_v);
    $display("Motion buffer 9H select candidates b1h_nonzero=%0d b1h_match=%0d b2h_nonzero=%0d b2h_match=%0d b4h_nonzero=%0d b4h_match=%0d",
             motion_buffer_sel_b1h_nonzero,
             motion_buffer_sel_b1h_matches,
             motion_buffer_sel_b2h_nonzero,
             motion_buffer_sel_b2h_matches,
             motion_buffer_sel_b4h_nonzero,
             motion_buffer_sel_b4h_matches);
    $display("Motion buffer 9H inverted candidates b1h_n_nonzero=%0d b1h_n_match=%0d b2h_n_nonzero=%0d b2h_n_match=%0d",
             motion_buffer_sel_b1h_n_nonzero,
             motion_buffer_sel_b1h_n_matches,
             motion_buffer_sel_b2h_n_nonzero,
             motion_buffer_sel_b2h_n_matches);
    $display("Motion buffer raw 93422 nonzero raw_lb=%0d raw_b1h=%0d raw_b1h_n=%0d raw_b2h=%0d raw_b4h=%0d",
             motion_buffer_raw_lb_nonzero_samples,
             motion_buffer_raw_b1h_nonzero,
             motion_buffer_raw_b1h_n_nonzero,
             motion_buffer_raw_b2h_nonzero,
             motion_buffer_raw_b4h_nonzero);
    $display("Motion buffer compat missing raw=%0d latched=%0d schematic=%0d raw_span first=%0d,%0d last=%0d,%0d",
             motion_buffer_compat_raw_missing,
             motion_buffer_compat_latched_missing,
             motion_buffer_compat_schematic_missing,
             motion_buffer_compat_raw_missing_first_h,
             motion_buffer_compat_raw_missing_first_v,
             motion_buffer_compat_raw_missing_last_h,
             motion_buffer_compat_raw_missing_last_v);
    $display("Motion buffer d1 coverage compat_d1_nonzero=%0d schematic_missing=%0d value_mismatch=%0d missing_span first=%0d,%0d last=%0d,%0d raw_present=%0d latched_present=%0d mem_current=%0d mem_prev=%0d mem_next=%0d mem_other_bank=%0d mem_other_side=%0d mem_other_side_match=%0d mem_other_side_prev=%0d mem_other_side_prev_match=%0d mem_other_side_next=%0d mem_other_side_next_match=%0d selected_window_match=%0d other_window_match=%0d",
             motion_buffer_compat_d1_nonzero_samples,
             motion_buffer_compat_d1_schematic_missing,
             motion_buffer_compat_d1_schematic_value_mismatch,
             motion_buffer_compat_d1_missing_first_h,
             motion_buffer_compat_d1_missing_first_v,
             motion_buffer_compat_d1_missing_last_h,
             motion_buffer_compat_d1_missing_last_v,
             motion_buffer_compat_d1_missing_raw_present,
             motion_buffer_compat_d1_missing_latched_present,
             motion_buffer_compat_d1_missing_mem_current,
             motion_buffer_compat_d1_missing_mem_prev,
             motion_buffer_compat_d1_missing_mem_next,
             motion_buffer_compat_d1_missing_mem_other_bank,
             motion_buffer_compat_d1_missing_mem_other_side,
             motion_buffer_compat_d1_missing_mem_other_side_match,
             motion_buffer_compat_d1_missing_mem_other_side_prev,
             motion_buffer_compat_d1_missing_mem_other_side_prev_match,
             motion_buffer_compat_d1_missing_mem_other_side_next,
             motion_buffer_compat_d1_missing_mem_other_side_next_match,
             motion_buffer_compat_d1_missing_selected_window_match,
             motion_buffer_compat_d1_missing_other_window_match);
    $display("Motion buffer single-address probe nonzero=%0d now=%0d d1=%0d d2=%0d d3=%0d d1_missing=%0d fills_bridge_missing=%0d",
             motion_buffer_single_addr_nonzero_samples,
             motion_buffer_single_addr_now_matches,
             motion_buffer_single_addr_d1_matches,
             motion_buffer_single_addr_d2_matches,
             motion_buffer_single_addr_d3_matches,
             motion_buffer_single_addr_d1_missing,
             motion_buffer_single_addr_fills_bridge_missing);
    $display("Motion buffer other-side match offsets m8=%0d m7=%0d m6=%0d m5=%0d m4=%0d m3=%0d m2=%0d m1=%0d z=%0d p1=%0d p2=%0d p3=%0d p4=%0d p5=%0d p6=%0d p7=%0d p8=%0d",
             motion_buffer_other_window_match_offset[0],
             motion_buffer_other_window_match_offset[1],
             motion_buffer_other_window_match_offset[2],
             motion_buffer_other_window_match_offset[3],
             motion_buffer_other_window_match_offset[4],
             motion_buffer_other_window_match_offset[5],
             motion_buffer_other_window_match_offset[6],
             motion_buffer_other_window_match_offset[7],
             motion_buffer_other_window_match_offset[8],
             motion_buffer_other_window_match_offset[9],
             motion_buffer_other_window_match_offset[10],
             motion_buffer_other_window_match_offset[11],
             motion_buffer_other_window_match_offset[12],
             motion_buffer_other_window_match_offset[13],
             motion_buffer_other_window_match_offset[14],
             motion_buffer_other_window_match_offset[15],
             motion_buffer_other_window_match_offset[16]);
    $display("Motion buffer missing 8K/8M select 8k_mbj=%0d 8k_fb=%0d 8m_mbj=%0d 8m_fb=%0d ivdsh_high=%0d ivdbh_high=%0d",
             motion_buffer_compat_d1_missing_8k_mbj,
             motion_buffer_compat_d1_missing_8k_feedback,
             motion_buffer_compat_d1_missing_8m_mbj,
             motion_buffer_compat_d1_missing_8m_feedback,
             motion_buffer_compat_d1_missing_ivdsh_high,
             motion_buffer_compat_d1_missing_ivdbh_high);
    $finish;
end

endmodule
