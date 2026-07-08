# Sheet 4A/4B Motion Object Pin Audit

Scope: logic pins for the Sheet 4A/4B motion-object path only. Power pins are
omitted. This audit is documentation-only and must not be used as permission to
change visible behaviour.

Status key:

- `exact`: schematic net and RTL signal agree at this boundary.
- `approximate`: RTL represents the function, but not yet as a pin/phase exact circuit.
- `missing`: schematic pin has no trusted RTL representation yet.
- `timing uncertain`: net is named, but phase/clock/lifetime is not proven.
- `active-low uncertain`: polarity or active-low treatment still needs proof.

Current guardrails:

- `USE_SCHEMATIC_MOTION_BUFFER = 0`.
- `USE_SCHEMATIC_MOTION_ROM_PIXELS = 0`.
- Do not fix sprite output while this table is being completed.
- `MAME` may explain expected behaviour, but not schematic pin wiring.

Resolved boxed uncertainty 2026-07-03:

- LS194 `S0` pin 9 is the common rail from `10D` pin 8 for `6P/6R/7P/7R`.
- LS194 `S1` pin 10 is the common rail from `10C` pin 6 for `6P/6R/7P/7R`.
- `10D` pin 6 is a NAND-derived active-low load-request term from the inverted
  `MATCH` path and `NIB LOAD`; when this term is low, `10C` pin 6 and `10D`
  pin 8 both go high, so the LS194s see `S1/S0=11` parallel load.
- When the load-request term is high, the `FLIP` path drives the two rails
  complementarily through `10C`/`10D`, selecting one of the two shift modes
  (`S1/S0=01` or `10`). LS194 `S0/S1` pins themselves are active-high mode
  selects; there is no active-low LS194 mode pin. This does not prove the
  upstream `NIB LOAD`, `FLIP`, `LOF`, or `B5M`/legacy-`BSM` timing is
  behaviour-ready.
- The four LS194 packages share the same control wiring: pin 1 clear is held
  inactive by `PR171`, pins 2 and 7 serial inputs are grounded, pin 11 clock is
  the `B5M`/legacy-`BSM` timing rail, pins 3-6 are the parallel motion-ROM
  nibble inputs, and pins 12-15 are
  the four shift-register outputs used as `MBJ`, intermediate taps, and `MBJF`.
  These pin/net mappings are confirmed; active RTL still uses a provisional
  render/load shortcut, so output timing remains uncertain until Step 2.

## Sheet 4A: Motion ROM Source

| IC | pin | schematic net | connected IC/pin | RTL signal | status | evidence/notes |
| --- | --- | --- | --- | --- | --- | --- |
| `6N`, `8R` | 18,19,22,23,1,2,3,4,5,6,7,8 | `MOPA11..MOPA1`, `M14H` address inputs | shared motion picture address bus | `motion_rom_addr`, formed from provisional `mopa_code`, `mopa_low_from_6h`, `mopa_x`, and compatibility bank select | approximate | Cached `sheet_4a_6n_8r_motion_rom_pin_crop.png` proves the shared address pin labels. RTL has a functional address but not a pin/phase-exact 6N/8R address mux yet; `M14H` also has a non-driving LS86 candidate. |
| `6N` | 17,16,15,14,13,11,10,9 | `M7..M0` data outputs | LS194 parallel data bus | `mrom_from_6n_8r[7:0]`, `m7..m0` | exact | Crop shows 6N data outputs `M7..M0`; RTL maps them to the low byte of `motion_rom_parallel_data`. Output timing still depends on ROM address/load phase. |
| `8R` | 17,16,15,14,13,11,10,9 | `MF..M8` data outputs | LS194 parallel data bus | `mrom_from_6n_8r[15:8]`, `mf_mrom..m8` | exact | Crop shows 8R data outputs `MF..M8`; RTL maps them to the high byte of `motion_rom_parallel_data`. Output timing still depends on ROM address/load phase. |
| `6N`, `8R` | 20 | chip select | tied low | ROMs effectively always enabled in `motion_rom_6n_data`/`motion_rom_8r_data` | exact | Crop shows both 2532 `CS` pins tied low. |

## Sheet 4A: Motion ROM Shift And Flip Select

| IC | pin | schematic net | connected IC/pin | RTL signal | status | evidence/notes |
| --- | --- | --- | --- | --- | --- | --- |
| `6R` | 11 | `BSM` | timing sheet / local clock rail | `bsm` on non-driving candidate; active path uses `motion_shift_load_from_render_pending` as clk_en | timing uncertain | Pin/net mapping is exact: LS194 clock pin 11 is `BSM`. Active LS194 shortcut still loads from the temporary renderer, so clock/load timing is not behaviour-ready. |
| `6R` | 1 | `/CLR` | held inactive via `PR171` | `clear_n(1'b1)` | exact | Wide LS194 crop shows clear held inactive through the resistor network. |
| `6R` | 3 | `M0` | motion ROM data bus | `m0` in `.d({mc_mrom,m8,m4,m0})` | exact | Parallel data grouping is represented. |
| `6R` | 4 | `M4` | motion ROM data bus | `m4` | exact | Parallel data grouping is represented. |
| `6R` | 5 | `M8` | motion ROM data bus | `m8` | exact | Parallel data grouping is represented. |
| `6R` | 6 | `MC` | motion ROM data bus | `mc_mrom` | exact | Parallel data grouping is represented. |
| `6R` | 9 | S0 mode rail | `10D` pin 8 LS00 output | candidate `motion_ls194_s0_pin9_from_10d8_candidate_n`; active path still `motion_shift_mode_provisional` | exact | Cached LS194/10C/10D crops show the common `10D` pin 8 rail feeding LS194 pin 9. Pin mapping is exact; behaviour remains non-driving until upstream timing is proven. Icarus rejects a simple S0/S1 polarity fix: direct mode scores `56/172` missing-captured matches and inverted mode scores `0/172`, versus current LS194/MBJF `84/172`. |
| `6R` | 10 | S1 mode rail | `10C` pin 6 LS00 output | candidate `motion_ls194_s1_pin10_from_10c6_candidate_n`; active path still `motion_shift_mode_provisional` | exact | Cached LS194/10C/10D crops show the common `10C` pin 6 rail feeding LS194 pin 10. Pin mapping is exact; behaviour remains non-driving until upstream timing is proven. The direct/inverted mode-candidate scores above keep the uncertainty on timing, not pin polarity. |
| `6R` | 2 | serial-right input | tied low | `sr(1'b0)` | exact | Wide LS194 crop shows pin 2 tied low. |
| `6R` | 7 | serial-left input | tied low | `sl(1'b0)` | exact | Wide LS194 crop shows pin 7 tied low. |
| `6R` | 12 | `MBJ0` | `7N` normal-side input | `mbj0_shift_q[3]`, `mbj_from_ls194[0]` | timing uncertain | Pin/net mapping is exact; output timing depends on unresolved `BSM`/mode/load phase. |
| `6R` | 13 | intermediate tap | local LS194 output | `mbj0_shift_q[2]`, `mbj_from_ls194_tap2[0]` | timing uncertain | Pin/net mapping is exact; tap is exposed only for non-driving audit classification. |
| `6R` | 14 | intermediate tap | local LS194 output | `mbj0_shift_q[1]`, `mbj_from_ls194_tap1[0]` | timing uncertain | Pin/net mapping is exact; tap is exposed only for non-driving audit classification. |
| `6R` | 15 | `MBJ0F` | `7N` flipped-side input | `mbj0_shift_q[0]`, `mbjf_from_ls194[0]` | timing uncertain | Pin/net mapping is exact; output timing depends on unresolved `BSM`/mode/load phase. |
| `6P` | 11 | `BSM` | timing sheet / local clock rail | `bsm` on non-driving candidate; active path uses `motion_shift_load_from_render_pending` as clk_en | timing uncertain | Same exact clock pin mapping and timing uncertainty as `6R`. |
| `6P` | 1 | `/CLR` | held inactive via `PR171` | `clear_n(1'b1)` | exact | Wide LS194 crop shows clear held inactive through the resistor network. |
| `6P` | 3 | `M1` | motion ROM data bus | `m1` in `.d({md_mrom,m9,m5,m1})` | exact | Parallel data grouping is represented. |
| `6P` | 4 | `M5` | motion ROM data bus | `m5` | exact | Parallel data grouping is represented. |
| `6P` | 5 | `M9` | motion ROM data bus | `m9` | exact | Parallel data grouping is represented. |
| `6P` | 6 | `MD` | motion ROM data bus | `md_mrom` | exact | Parallel data grouping is represented. |
| `6P` | 9 | S0 mode rail | `10D` pin 8 LS00 output | candidate `motion_ls194_s0_pin9_from_10d8_candidate_n`; active path still `motion_shift_mode_provisional` | exact | Same exact common S0 rail as `6R`; not behaviour-driving yet. |
| `6P` | 10 | S1 mode rail | `10C` pin 6 LS00 output | candidate `motion_ls194_s1_pin10_from_10c6_candidate_n`; active path still `motion_shift_mode_provisional` | exact | Same exact common S1 rail as `6R`; not behaviour-driving yet. |
| `6P` | 2 | serial-right input | tied low | `sr(1'b0)` | exact | Wide LS194 crop shows pin 2 tied low. |
| `6P` | 7 | serial-left input | tied low | `sl(1'b0)` | exact | Wide LS194 crop shows pin 7 tied low. |
| `6P` | 12 | `MBJ1` | `7N` normal-side input | `mbj1_shift_q[3]`, `mbj_from_ls194[1]` | timing uncertain | Pin/net mapping is exact; output timing depends on unresolved `BSM`/mode/load phase. |
| `6P` | 13 | intermediate tap | local LS194 output | `mbj1_shift_q[2]`, `mbj_from_ls194_tap2[1]` | timing uncertain | Pin/net mapping is exact; tap is exposed only for non-driving audit classification. |
| `6P` | 14 | intermediate tap | local LS194 output | `mbj1_shift_q[1]`, `mbj_from_ls194_tap1[1]` | timing uncertain | Pin/net mapping is exact; tap is exposed only for non-driving audit classification. |
| `6P` | 15 | `MBJ1F` | `7N` flipped-side input | `mbj1_shift_q[0]`, `mbjf_from_ls194[1]` | timing uncertain | Pin/net mapping is exact; output timing depends on unresolved `BSM`/mode/load phase. |
| `7R` | 11 | `BSM` | timing sheet / local clock rail | `bsm` on non-driving candidate; active path uses `motion_shift_load_from_render_pending` as clk_en | timing uncertain | Same exact clock pin mapping and timing uncertainty as `6R`. |
| `7R` | 1 | `/CLR` | held inactive via `PR171` | `clear_n(1'b1)` | exact | Wide LS194 crop shows clear held inactive through the resistor network. |
| `7R` | 3 | `M2` | motion ROM data bus | `m2` in `.d({me_mrom,ma_mrom,m6,m2})` | exact | Parallel data grouping is represented. |
| `7R` | 4 | `M6` | motion ROM data bus | `m6` | exact | Parallel data grouping is represented. |
| `7R` | 5 | `MA` | motion ROM data bus | `ma_mrom` | exact | Parallel data grouping is represented. |
| `7R` | 6 | `ME` | motion ROM data bus | `me_mrom` | exact | Parallel data grouping is represented. |
| `7R` | 9 | S0 mode rail | `10D` pin 8 LS00 output | candidate `motion_ls194_s0_pin9_from_10d8_candidate_n`; active path still `motion_shift_mode_provisional` | exact | Same exact common S0 rail as `6R`; not behaviour-driving yet. |
| `7R` | 10 | S1 mode rail | `10C` pin 6 LS00 output | candidate `motion_ls194_s1_pin10_from_10c6_candidate_n`; active path still `motion_shift_mode_provisional` | exact | Same exact common S1 rail as `6R`; not behaviour-driving yet. |
| `7R` | 2 | serial-right input | tied low | `sr(1'b0)` | exact | Wide LS194 crop shows pin 2 tied low. |
| `7R` | 7 | serial-left input | tied low | `sl(1'b0)` | exact | Wide LS194 crop shows pin 7 tied low. |
| `7R` | 12 | `MBJ2` | `7N` normal-side input | `mbj2_shift_q[3]`, `mbj_from_ls194[2]` | timing uncertain | Pin/net mapping is exact; output timing depends on unresolved `BSM`/mode/load phase. |
| `7R` | 13 | intermediate tap | local LS194 output | `mbj2_shift_q[2]`, `mbj_from_ls194_tap2[2]` | timing uncertain | Pin/net mapping is exact; tap is exposed only for non-driving audit classification. |
| `7R` | 14 | intermediate tap | local LS194 output | `mbj2_shift_q[1]`, `mbj_from_ls194_tap1[2]` | timing uncertain | Pin/net mapping is exact; tap is exposed only for non-driving audit classification. |
| `7R` | 15 | `MBJ2F` | `7N` flipped-side input | `mbj2_shift_q[0]`, `mbjf_from_ls194[2]` | timing uncertain | Pin/net mapping is exact; output timing depends on unresolved `BSM`/mode/load phase. |
| `7P` | 11 | `BSM` | timing sheet / local clock rail | `bsm` on non-driving candidate; active path uses `motion_shift_load_from_render_pending` as clk_en | timing uncertain | Same exact clock pin mapping and timing uncertainty as `6R`. |
| `7P` | 1 | `/CLR` | held inactive via `PR171` | `clear_n(1'b1)` | exact | Wide LS194 crop shows clear held inactive through the resistor network. |
| `7P` | 3 | `M3` | motion ROM data bus | `m3` in `.d({mf_mrom,mb_mrom,m7,m3})` | exact | Parallel data grouping is represented. |
| `7P` | 4 | `M7` | motion ROM data bus | `m7` | exact | Parallel data grouping is represented. |
| `7P` | 5 | `MB` | motion ROM data bus | `mb_mrom` | exact | Parallel data grouping is represented. |
| `7P` | 6 | `MF` | motion ROM data bus | `mf_mrom` | exact | Parallel data grouping is represented. |
| `7P` | 9 | S0 mode rail | `10D` pin 8 LS00 output | candidate `motion_ls194_s0_pin9_from_10d8_candidate_n`; active path still `motion_shift_mode_provisional` | exact | Same exact common S0 rail as `6R`; not behaviour-driving yet. |
| `7P` | 10 | S1 mode rail | `10C` pin 6 LS00 output | candidate `motion_ls194_s1_pin10_from_10c6_candidate_n`; active path still `motion_shift_mode_provisional` | exact | Same exact common S1 rail as `6R`; not behaviour-driving yet. |
| `7P` | 2 | serial-right input | tied low | `sr(1'b0)` | exact | Wide LS194 crop shows pin 2 tied low. |
| `7P` | 7 | serial-left input | tied low | `sl(1'b0)` | exact | Wide LS194 crop shows pin 7 tied low. |
| `7P` | 12 | `MBJ3` | `7N` normal-side input | `mbj3_shift_q[3]`, `mbj_from_ls194[3]` | timing uncertain | Pin/net mapping is exact; output timing depends on unresolved `BSM`/mode/load phase. |
| `7P` | 13 | intermediate tap | local LS194 output | `mbj3_shift_q[2]`, `mbj_from_ls194_tap2[3]` | timing uncertain | Pin/net mapping is exact; tap is exposed only for non-driving audit classification. |
| `7P` | 14 | intermediate tap | local LS194 output | `mbj3_shift_q[1]`, `mbj_from_ls194_tap1[3]` | timing uncertain | Pin/net mapping is exact; tap is exposed only for non-driving audit classification. |
| `7P` | 15 | `MBJ3F` | `7N` flipped-side input | `mbj3_shift_q[0]`, `mbjf_from_ls194[3]` | timing uncertain | Pin/net mapping is exact; output timing depends on unresolved `BSM`/mode/load phase. |
| `7N` | 1 | `FLIP` select | `11F` output | `flip_from_11f` | timing uncertain | 11F `LOF` timing is still provisional. Focused p3 age-2 trace shows LS194 Q3 equals Q0 for all samples in that window (`eq=992`, `ne=0`), so 7N select cannot explain that specific failure by itself. |
| `7N` | 15 | enable | tied active | `enable_n(1'b0)` | exact | RTL LS157 enable is tied active. |
| `7N` | 5 | normal input bit 3 | LS194 normal output `MBJ3` | `mbj_from_ls194[3]`; non-driving `mbj_from_7n_pin_order_candidate` verifies logical reorder | timing uncertain | Cached `sheet_4a_7n_mbj_flip_selector_crop.png` corrects the physical package order. Icarus shows the pin-order reconstruction equals the existing logical 7N bus for all captured samples (`known=4096 equal=4096`) and scores the same missing-window source matches (`7n_match=84`, `7n_pin_order_match=84`), so no behaviour change is justified. LS194 output tap/phase and `FLIP` timing are still not final. |
| `7N` | 6 | flipped input bit 3 | LS194 flipped output `MBJ3F` | `mbjf_from_ls194[3]` | timing uncertain | Physical pin order is exact; LS194 output timing remains unresolved. |
| `7N` | 7 | selected bit 3 | `MBJ3*` to 8K/8M write-side path | `mbj_from_7n[3]`; active buffer still uses `mbj_pending0/1` | approximate | Logical vector bit is named, but selected bus is not yet driving 8K/8M active path. In the p3 age-2 trace, live 7N equals held 7N and pixel0 for all samples (`992/992`) while selected 8K/8M write data is blank in the representative sample, keeping this approximate until the 8K/8M write-side handoff is proven. |
| `7N` | 14 | normal input bit 2 | LS194 normal output `MBJ2` | `mbj_from_ls194[2]` | timing uncertain | Physical pin order is exact; LS194 output tap/phase not final. |
| `7N` | 13 | flipped input bit 2 | LS194 flipped output `MBJ2F` | `mbjf_from_ls194[2]` | timing uncertain | Physical pin order is exact; LS194 output timing remains unresolved. |
| `7N` | 12 | selected bit 2 | `MBJ2*` to 8K/8M write-side path | `mbj_from_7n[2]`; active buffer still uses `mbj_pending0/1` | approximate | Logical vector bit is named, but selected bus is not yet driving 8K/8M active path. |
| `7N` | 2 | normal input bit 1 | LS194 normal output `MBJ1` | `mbj_from_ls194[1]` | timing uncertain | Physical pin order is exact; LS194 output tap/phase not final. |
| `7N` | 3 | flipped input bit 1 | LS194 flipped output `MBJ1F` | `mbjf_from_ls194[1]` | timing uncertain | Physical pin order is exact; LS194 output timing remains unresolved. |
| `7N` | 4 | selected bit 1 | `MBJ1*` to 8K/8M write-side path | `mbj_from_7n[1]`; active buffer still uses `mbj_pending0/1` | approximate | Logical vector bit is named, but selected bus is not yet driving 8K/8M active path. |
| `7N` | 11 | normal input bit 0 | LS194 normal output `MBJ0` | `mbj_from_ls194[0]` | timing uncertain | Physical pin order is exact; LS194 output tap/phase not final. |
| `7N` | 10 | flipped input bit 0 | LS194 flipped output `MBJ0F` | `mbjf_from_ls194[0]` | timing uncertain | Physical pin order is exact; LS194 output timing remains unresolved. |
| `7N` | 9 | selected bit 0 | `MBJ0*` to 8K/8M write-side path | `mbj_from_7n[0]`; active buffer still uses `mbj_pending0/1` | approximate | Logical vector bit is named, but selected bus is not yet driving 8K/8M active path. |

## Sheet 4A: Load/Shift Timing Nets

| net | confirmed destination pins | RTL signal | status | evidence/notes |
| --- | --- | --- | --- | --- |
| `BYTLOAD` | `1H` pin 15 active-low `G`, `8F` pin 1 active-low `G` | `bytload_from_render_pending` is a provisional active-high alias inverted for active `8F`; non-driving `moh_left_decode_1h_pin_candidate_n` now places it directly on `1H` active-low `G` | active-low uncertain | Cached `sheet_4a_1h_8f_bytload_decode_zoom.png` proves the decoder destination pins. The existing Sheet 3B `pf_bytload_from_10d` alias has been tested as a motion substitute and rejected by diagnostics (`8/992` p3 age-2 MBJ/feedback, with no h4 write overlap), so do not promote it to the Sheet 4A motion `BYTLOAD` source. A sim-only 1H enable matrix also rejects simple inversion/substitution: render `ll/rl` counts are current level `0/0`, inverted level `512/512`, `pf_bytload` `64/64`, inverted `pf_bytload` `448/448`, `pf_nibload` `384/384`, and inverted `pf_nibload` `128/128`, none matching the active temporary render phase `0/1024`. Source, pulse/level behavior, and true polarity remain untraced. |
| `NIB LOAD` | `10D` pin 5 into LS00 mode chain; with inverted `MATCH` on `10D` pin 4, output `10D` pin 6 forms the active-low load-request term | `motion_ls194_nib_load_provisional`; non-driving candidates also try `pf_nibload_from_3f` and `pf_ldnib_from_11f` | timing uncertain | Cached `sheet_4a_nib_load_trace_crop.png` and `sheet_4a_ls194_10c_10d_zoom.png` prove the local destination into 10D. Sheet 3B `pf_nibload_from_3f` is an available comparison candidate, but direct substitution scores `0/992` for the p3 age-2 right-side window. In the h4/h6 proof window it only partially correlates: h4 has origin `NIBLOAD=16/24` and write `NIBLOAD=0/24`, while h6 has origin/write `NIBLOAD=16/16`; `LDNIB` follows the same h6 pattern. A p3 age-2 mode-bin comparison distinguishes the two candidates (`NIBLOAD b2/b3=737/255`, `LDNIB b2/b3=257/735`, current `b3=992`) but does not make either behaviour-ready. This is timing evidence; do not collapse this net into `BYTLOAD`. |
| `LOF` | `11F` pin 11 clock, with `FLIPM` on D pin 12 and outputs `FLIP`/complement | `lof_provisional_from_render_pending` / `lof_rise_provisional_from_render_pending`; non-driving candidates also try Sheet 3B `pf_bytload`, `pf_nibload`, `pf_ldf`, and `pf_ldnib` edges | timing uncertain | Cached `sheet_4a_11f_lof_wide_crop.png` proves the 11F clock destination and separation from local `BYTLOAD`. Prior probes rejected simple `B4H`/`BSM` clock substitutions for the 11F LS86 candidate at the p3 age-2 and h4/h6 proof points. Non-driving Sheet 3B edge-clock matrices now reject both rising and falling edges of `pf_bytload`/`pf_nibload`/`pf_ldf`/`pf_ldnib` as simple `LOF` aliases in the p3 age-2 window (`0/0/0/0` for each edge set). Keep `LOF` boxed until its source is traced; source, edge, and pulse/level behavior remain untraced. |

## Sheet 4A: MOH Decode Logic

| IC | pin | schematic net | connected IC/pin | RTL signal | status | evidence/notes |
| --- | --- | --- | --- | --- | --- | --- |
| `1H` | 15 | active-low `G` enable | `BYTLOAD` | non-driving `u_1h_moh_left_pin_candidate_decode.enable_n(bytload_from_render_pending)`; active path still collapsed | active-low uncertain | New cached `1H/8F` crop shows `BYTLOAD` feeding the upper-half active-low enable pin 15. Icarus with the pin-honest candidate shows no render-window loads (`render_ll=0`, `render_rl=0`) and large mismatch against the active collapsed decode (`mismatch_ll=38848`, `mismatch_rl=39872`), proving the current provisional `BYTLOAD` lifetime is not behaviour-ready. |
| `1H` | 14 | A select | `IV` | non-driving candidate `sel[0]=iv_provisional_from_display_line_bank`; active path still collapsed | approximate | Crop shows upper-half `A` pin 14 tied to the `IV` line shared with `8F` pin 3. `IV` source is still provisional. |
| `1H` | 13 | B select | constant low | non-driving candidate `sel[1]=1'b0` | exact | Crop shows upper-half `B` pin 13 tied low. |
| `1H` | 12 | Y0 | `MOHLI` to `7L/7M` load and `8K` select | `mohli_decoded_n`, `motion_buffer_8k_select_from_mohli_n` | timing uncertain | Crop shows physical Y0 pin 12 is active-low `MOHLI`; phase depends on unresolved `BYTLOAD`/`IV`. |
| `1H` | 11 | Y1 | `MOHLO` to `7J/7K` load side | `mohlo_decoded_n`, `motion_buffer_left_load_n` | timing uncertain | Crop shows physical Y1 pin 11 is active-low `MOHLO`; phase depends on unresolved `BYTLOAD`/`IV`. |
| `1H` | 10 | Y2 | unused/other local decode | not represented | missing | Not currently assigned to a named output in the motion-buffer path. |
| `1H` | 9 | Y3 | unused/other local decode | not represented | missing | Not currently assigned to a named output in the motion-buffer path. |
| `7F` | 2 | D | `IV` | `iv_provisional_from_display_line_bank` | approximate | Enlarged cached `sheet_4a_7f_8f_iv_labels_zoom.png` confirms 7F samples `IV`; source remains provisional. |
| `7F` | 3 | CLK | `B8H` | `b8h_7f_rise` | timing uncertain | Crop confirms clock pin label `B8H`; edge/pulse source remains under timing audit. |
| `7F` | 5 | Q | `IVDSH` | `ivdsh_from_7f` | exact | Enlarged crop confirms Q pin 5 is the `IVDSH` side; RTL naming corrected so `IVDBH` is no longer taken from Q. |
| `7F` | 6 | `/Q` | `IVDBH` | `ivdbh_from_7f` | exact | Enlarged crop confirms `/Q` pin 6 is the `IVDBH` side used by 8F pin 2 and 8K/8M enables. Icarus passes after the non-visible naming correction; p3 age-2 8M MBJ window rises from `8/992` to `488/992`, but `USE_SCHEMATIC_MOTION_BUFFER` remains off. |
| `8F` | 1 | active-low `G` enable | `BYTLOAD` | `enable_n(!bytload_from_render_pending)` | active-low uncertain | Crop shows `BYTLOAD` feeding active-low enable pin 1. RTL uses an active-high provisional alias inverted into `enable_n`; exact net polarity/source remains unresolved. |
| `8F` | 2 | A select | `IVDBH` from `7F` `/Q` | `ivdbh_from_7f` | timing uncertain | Enlarged crop shows physical A pin 2 is `IVDBH` from 7F `/Q`; RTL naming is now pin-correct, but `B8H` edge and upstream `IV` source remain provisional. |
| `8F` | 3 | B select | `IV` from upstream source | `iv_provisional_from_display_line_bank` | approximate | Crop shows physical B pin 3 is `IV`. RTL source is explicitly provisional; user-corrected `INY`, not `INV`, remains a negative check only. |
| `8F` | 4 | Y0 | right decode Y0 | `moh_right_decode_n[0]` | missing | Not currently assigned to a named output in the motion-buffer path. |
| `8F` | 5 | Y1 | `MOHRO` to `7J/7K` clear side | `mohro_decoded_n`, `motion_buffer_left_clear_n` | timing uncertain | Crop confirms physical Y1 pin 5 is active-low `MOHRO`; active-low output is represented but timing depends on unresolved `BYTLOAD`/`IV`. |
| `8F` | 6 | Y2 | `MOHRI` to `7L/7M` clear and `8M` select | `mohri_decoded_n`, `motion_buffer_8m_select_from_mohri_n` | timing uncertain | Crop confirms physical Y2 pin 6 is active-low `MOHRI`; active-low output is represented but timing depends on unresolved `BYTLOAD`/`IV`. |
| `8F` | 7 | Y3 | right decode Y3 | `moh_right_decode_n[3]` | missing | Not currently assigned to a named output in the motion-buffer path. |

## Sheet 4B: Motion Buffer Counters

| IC | pin | schematic net | connected IC/pin | RTL signal | status | evidence/notes |
| --- | --- | --- | --- | --- | --- | --- |
| `7J` | 2 | CLK | `BSM` timing rail | `clk_en(bsm)` | exact | RTL names `BSM` for the LS163 counter clock enable. |
| `7J` | 1 | `/CLR` | `MOHRO` from `8F` Y1 | `motion_buffer_left_clear_n` | timing uncertain | Pin function named; `MOHRO` timing depends on provisional 8F/IV/BYTLOAD. |
| `7J` | 9 | `/LOAD` | `MOHLO` from `1H` Y1 | `motion_buffer_left_load_n` | timing uncertain | Pin function named; load address source is provisional. Manual 1H review confirms Y1/pin 11 is `/MOHLO`; active RTL aliases remain reversed, so this row is pin-audit truth rather than current behaviour-driving wiring. |
| `7J` | 3,4,5,6 | A-D preload | local low X/address bus | `motion_buffer_left_load_addr[3:0]` | approximate | Uses temporary renderer address `pending_sx + pending_x`. |
| `7J` | 14,13,12,11 | QA-QD | `8J` A0-A3 | `motion_buffer_left_addr_from_7j_7k[3:0]` | approximate | Counter exists; bridge still uses separate read/write addresses. |
| `7J` | 7 | ENP | board count enable | `enp(1'b1)` | approximate | Count gating not yet pin-proven. |
| `7J` | 10 | ENT | board count/cascade enable | `ent(1'b1)` | approximate | Count gating not yet pin-proven. |
| `7K` | 2 | CLK | `BSM` timing rail | `clk_en(bsm)` | exact | RTL names `BSM`. |
| `7K` | 1 | `/CLR` | `MOHRO` from `8F` Y1 | `motion_buffer_left_clear_n` | timing uncertain | Same left clear as `7J`. |
| `7K` | 9 | `/LOAD` | `MOHLO` from `1H` Y1 | `motion_buffer_left_load_n` | timing uncertain | Same left load as `7J`; active RTL aliases remain reversed. |
| `7K` | 3,4,5,6 | A-D preload | local high X/address bus | `motion_buffer_left_load_addr[7:4]` | approximate | Temporary renderer address. |
| `7K` | 14,13,12,11 | QA-QD | `8J` A4-A7 | `motion_buffer_left_addr_from_7j_7k[7:4]` | approximate | Counter exists; bridge still uses separate read/write addresses. |
| `7K` | 7 | ENP | board count enable | `enp(1'b1)` | approximate | Count gating not yet pin-proven. |
| `7K` | 10 | ENT | `7J` ripple/cascade | `ent(motion_buffer_left_low_ripple)` | approximate | Cascade represented, but pin proof incomplete. |
| `7L` | 2 | CLK | `BSM` timing rail | `clk_en(bsm)` | exact | RTL names `BSM`. |
| `7L` | 1 | `/CLR` | `MOHRI` from `8F` Y2 | `motion_buffer_right_clear_n` | timing uncertain | Pin function named; `MOHRI` timing is unresolved. |
| `7L` | 9 | `/LOAD` | `MOHLI` from `1H` Y0 | `motion_buffer_right_load_n` | timing uncertain | Pin function named; load phase is unresolved. Manual 1H review confirms Y0/pin 12 is `/MOHLI`; active RTL aliases remain reversed. |
| `7L` | 3,4,5,6 | A-D preload | local low X/address bus | `motion_buffer_right_load_addr[3:0]` | approximate | Uses temporary renderer address `pending_sx + pending_x + 1`. |
| `7L` | 14,13,12,11 | QA-QD | `8L` A0-A3 | `motion_buffer_right_addr_from_7l_7m[3:0]` | approximate | Counter exists; bridge still uses separate read/write addresses. |
| `7L` | 7 | ENP | board count enable | `enp(1'b1)` | approximate | Count gating not yet pin-proven. |
| `7L` | 10 | ENT | board count/cascade enable | `ent(1'b1)` | approximate | Count gating not yet pin-proven. |
| `7M` | 2 | CLK | `BSM` timing rail | `clk_en(bsm)` | exact | RTL names `BSM`. |
| `7M` | 1 | `/CLR` | `MOHRI` from `8F` Y2 | `motion_buffer_right_clear_n` | timing uncertain | Same right clear as `7L`. |
| `7M` | 9 | `/LOAD` | `MOHLI` from `1H` Y0 | `motion_buffer_right_load_n` | timing uncertain | Same right load as `7L`; active RTL aliases remain reversed. |
| `7M` | 3,4,5,6 | A-D preload | local high X/address bus | `motion_buffer_right_load_addr[7:4]` | approximate | Temporary renderer address. |
| `7M` | 14,13,12,11 | QA-QD | `8L` A4-A7 | `motion_buffer_right_addr_from_7l_7m[7:4]` | approximate | Counter exists; bridge still uses separate read/write addresses. |
| `7M` | 7 | ENP | board count enable | `enp(1'b1)` | approximate | Count gating not yet pin-proven. |
| `7M` | 10 | ENT | `7L` ripple/cascade | `ent(motion_buffer_right_low_ripple)` | approximate | Cascade represented, but pin proof incomplete. |

## Sheet 4B: 8K/8M Data Steering Into 8J/8L

| IC | pin | schematic net | connected IC/pin | RTL signal | status | evidence/notes |
| --- | --- | --- | --- | --- | --- | --- |
| `8K` | 1 | `/MOHLI` select | `1H` Y0 | `motion_buffer_8k_select_from_mohli_n` | exact | Manual 1H review says 8K select is active-low `/MOHLI` from 1H Y0/pin 12. The active RTL alias is still reversed (`mohli_decoded_n = moh_left_decode_n[1]`), while the non-driving corrected closed-loop probe uses `moh_left_decode_1h_pin_candidate_n[0]`. |
| `8K` | 15 | active-low `G` enable from `IVDBH` | `7F` `/Q` | `motion_buffer_8k_enable_n_from_ivdbh` | timing uncertain | Pin-level mapping is exact: LS157 active-low enable pin 15 is tied to `IVDBH` from 7F `/Q`; remaining risk is upstream `IV` source and object-scan/write phase. p3 age-2 BSM evidence still splits live 8K into enabled `c0=496` and disabled `c2=496`. |
| `8K` | 2 | A input | `MBJ3*` | `mbj_from_7n[3]` | exact | RTL now drives the inactive schematic 8K A side from 7N, matching the pin audit. p3 age-2 BSM evidence has actual 8K equal live 7N for the enabled half (`496/992`). |
| `8K` | 3 | B input | `LB03` feedback | `lb0_feedback_for_8k[3]` | approximate | Feedback uses compatibility `sprite_line0/1`, not schematic 93422 output lifetime. |
| `8K` | 9 | `D4` | `8J` D4 | `motion_buffer_data_from_8k[3]` | exact | Physical vector convention documented: pin 9 -> D4. |
| `8K` | 14 | A input | `MBJ2*` | `mbj_from_7n[2]` | exact | RTL now drives the inactive schematic 8K A side from 7N, matching the pin audit. |
| `8K` | 13 | B input | `LB02` feedback | `lb0_feedback_for_8k[2]` | approximate | Feedback uses compatibility `sprite_line0/1`. |
| `8K` | 12 | `D3` | `8J` D3 | `motion_buffer_data_from_8k[2]` | exact | Physical vector convention documented. |
| `8K` | 5 | A input | `MBJ1*` | `mbj_from_7n[1]` | exact | RTL now drives the inactive schematic 8K A side from 7N, matching the pin audit. |
| `8K` | 6 | B input | `LB01` feedback | `lb0_feedback_for_8k[1]` | approximate | Feedback uses compatibility `sprite_line0/1`. |
| `8K` | 7 | `D2` | `8J` D2 | `motion_buffer_data_from_8k[1]` | exact | Physical vector convention documented. |
| `8K` | 11 | A input | `MBJ0*` | `mbj_from_7n[0]` | exact | RTL now drives the inactive schematic 8K A side from 7N, matching the pin audit. |
| `8K` | 10 | B input | `LB00` feedback | `lb0_feedback_for_8k[0]` | approximate | Feedback uses compatibility `sprite_line0/1`. |
| `8K` | 4 | `D1` | `8J` D1 | `motion_buffer_data_from_8k[0]` | exact | Physical vector convention documented. |
| `8M` | 1 | `/MOHRI` select | `8F` Y2 | `motion_buffer_8m_select_from_mohri_n` | exact | Corrected pin audit says 8M select is active-low `MOHRI`. |
| `8M` | 15 | active-low `G` enable from `IVDBH` | `7F` `/Q` | `motion_buffer_8m_enable_n_from_ivdbh` | timing uncertain | Pin-level mapping is exact: LS157 active-low enable pin 15 is tied to `IVDBH` from 7F `/Q`; remaining risk is upstream `IV` source and object-scan/write phase. After correcting the RTL name, p3 age-2 BSM evidence splits live 8M into `c0=488/c1=8/c3=496`, with 8M MBJ selected for `488/992`. |
| `8M` | 11 | A input | `MBJ3*` | `mbj_from_7n[3]` | exact | RTL now drives the inactive schematic 8M A side from 7N, matching the pin audit. p3 age-2 BSM evidence has actual 8M equal live 7N for the MBJ-selected window (`488/992`), but full inactive comparison still has `value_mismatch=12`, so the surrounding phase remains unresolved. |
| `8M` | 10 | B input | `LB13` feedback | `lb1_feedback_for_8m[3]` | approximate | Feedback uses compatibility `sprite_line0/1`, not schematic 93422 output lifetime. |
| `8M` | 9 | `D4` | `8L` D4 | `motion_buffer_data_from_8m[3]` | exact | Physical vector convention documented: pin 9 -> D4. |
| `8M` | 14 | A input | `MBJ2*` | `mbj_from_7n[2]` | exact | RTL now drives the inactive schematic 8M A side from 7N, matching the pin audit. |
| `8M` | 13 | B input | `LB12` feedback | `lb1_feedback_for_8m[2]` | approximate | Feedback uses compatibility `sprite_line0/1`. |
| `8M` | 12 | `D3` | `8L` D3 | `motion_buffer_data_from_8m[2]` | exact | Physical vector convention documented. |
| `8M` | 5 | A input | `MBJ1*` | `mbj_from_7n[1]` | exact | RTL now drives the inactive schematic 8M A side from 7N, matching the pin audit. |
| `8M` | 6 | B input | `LB11` feedback | `lb1_feedback_for_8m[1]` | approximate | Feedback uses compatibility `sprite_line0/1`. |
| `8M` | 7 | `D2` | `8L` D2 | `motion_buffer_data_from_8m[1]` | exact | Physical vector convention documented. |
| `8M` | 2 | A input | `MBJ0*` | `mbj_from_7n[0]` | exact | RTL now drives the inactive schematic 8M A side from 7N, matching the pin audit. |
| `8M` | 3 | B input | `LB10` feedback | `lb1_feedback_for_8m[0]` | approximate | Feedback uses compatibility `sprite_line0/1`. |
| `8M` | 4 | `D1` | `8L` D1 | `motion_buffer_data_from_8m[0]` | exact | Physical vector convention documented. |

## Sheet 4B: 8J/8L Motion Buffer RAMs

| IC | pin | schematic net | connected IC/pin | RTL signal | status | evidence/notes |
| --- | --- | --- | --- | --- | --- | --- |
| `8J` | 4 | A0 | `7J/7K` address bit 0 | `motion_buffer_left_addr_from_7j_7k[0]`; bridge may use split address | approximate | Single-address probe exists, but active bridge still splits read/write and banks. |
| `8J` | 3 | A1 | `7J/7K` address bit 1 | `motion_buffer_left_addr_from_7j_7k[1]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8J` | 2 | A2 | `7J/7K` address bit 2 | `motion_buffer_left_addr_from_7j_7k[2]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8J` | 1 | A3 | `7J/7K` address bit 3 | `motion_buffer_left_addr_from_7j_7k[3]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8J` | 21 | A4 | `7J/7K` address bit 4 | `motion_buffer_left_addr_from_7j_7k[4]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8J` | 5 | A5 | `7J/7K` address bit 5 | `motion_buffer_left_addr_from_7j_7k[5]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8J` | 6 | A6 | `7J/7K` address bit 6 | `motion_buffer_left_addr_from_7j_7k[6]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8J` | 7 | A7 | `7J/7K` address bit 7 | `motion_buffer_left_addr_from_7j_7k[7]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8J` | 9 | D1 | `8K` output D1 | `motion_buffer_data_from_8k[0]` | exact | Cached crop confirms D1 pin 9. |
| `8J` | 11 | D2 | `8K` output D2 | `motion_buffer_data_from_8k[1]` | exact | Cached crop confirms D2 pin 11. |
| `8J` | 13 | D3 | `8K` output D3 | `motion_buffer_data_from_8k[2]` | exact | Cached crop confirms D3 pin 13. |
| `8J` | 15 | D4 | `8K` output D4 | `motion_buffer_data_from_8k[3]` | exact | Cached crop confirms D4 pin 15. |
| `8J` | 10 | O1 | `LB00` to `9T` | `lb0_from_8j[0]` | approximate | Output path exists, but active bridge is two-bank compatibility RAM. |
| `8J` | 12 | O2 | `LB01` to `9T` | `lb0_from_8j[1]` | approximate | Output path exists, but active bridge is two-bank compatibility RAM. |
| `8J` | 14 | O3 | `LB02` to `9T` | `lb0_from_8j[2]` | approximate | Output path exists, but active bridge is two-bank compatibility RAM. |
| `8J` | 16 | O4 | `LB03` to `9T` | `lb0_from_8j[3]` | approximate | Output path exists, but active bridge is two-bank compatibility RAM. |
| `8J` | 20 | `WE` from `BSM` | timing rail | `motion_buffer_we_n_from_8j_8l = !bsm` | exact | Named from Sheet 4B audit. |
| `8J` | 19 | `CS1` | tied active | `motion_buffer_cs1_n_from_8j_8l = 1'b0` | exact | Named from Sheet 4B audit. |
| `8J` | 17 | `CS2` | tied active | `motion_buffer_cs2_n_from_8j_8l = 1'b0` | exact | Named from Sheet 4B audit. |
| `8J` | 18 | `OE` | tied active | `motion_buffer_oe_n_from_8j_8l = 1'b0` | exact | Named from Sheet 4B audit. |
| `8L` | 4 | A0 | `7L/7M` address bit 0 | `motion_buffer_right_addr_from_7l_7m[0]`; bridge may use split address | approximate | Single-address probe exists, but active bridge still splits read/write and banks. |
| `8L` | 3 | A1 | `7L/7M` address bit 1 | `motion_buffer_right_addr_from_7l_7m[1]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8L` | 2 | A2 | `7L/7M` address bit 2 | `motion_buffer_right_addr_from_7l_7m[2]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8L` | 1 | A3 | `7L/7M` address bit 3 | `motion_buffer_right_addr_from_7l_7m[3]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8L` | 21 | A4 | `7L/7M` address bit 4 | `motion_buffer_right_addr_from_7l_7m[4]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8L` | 5 | A5 | `7L/7M` address bit 5 | `motion_buffer_right_addr_from_7l_7m[5]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8L` | 6 | A6 | `7L/7M` address bit 6 | `motion_buffer_right_addr_from_7l_7m[6]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8L` | 7 | A7 | `7L/7M` address bit 7 | `motion_buffer_right_addr_from_7l_7m[7]`; bridge may use split address | approximate | Pin order confirmed by cached crop. |
| `8L` | 9 | D1 | `8M` output D1 | `motion_buffer_data_from_8m[0]` | exact | Cached crop confirms D1 pin 9. |
| `8L` | 11 | D2 | `8M` output D2 | `motion_buffer_data_from_8m[1]` | exact | Cached crop confirms D2 pin 11. |
| `8L` | 13 | D3 | `8M` output D3 | `motion_buffer_data_from_8m[2]` | exact | Cached crop confirms D3 pin 13. |
| `8L` | 15 | D4 | `8M` output D4 | `motion_buffer_data_from_8m[3]` | exact | Cached crop confirms D4 pin 15. |
| `8L` | 10 | O1 | `LB10` to `9T` | `lb1_from_8l[0]` | approximate | Output path exists, but active bridge is two-bank compatibility RAM. |
| `8L` | 12 | O2 | `LB11` to `9T` | `lb1_from_8l[1]` | approximate | Output path exists, but active bridge is two-bank compatibility RAM. |
| `8L` | 14 | O3 | `LB12` to `9T` | `lb1_from_8l[2]` | approximate | Output path exists, but active bridge is two-bank compatibility RAM. |
| `8L` | 16 | O4 | `LB13` to `9T` | `lb1_from_8l[3]` | approximate | Output path exists, but active bridge is two-bank compatibility RAM. |
| `8L` | 20 | `WE` from `BSM` | timing rail | `motion_buffer_we_n_from_8j_8l = !bsm` | exact | Named from Sheet 4B audit. |
| `8L` | 19 | `CS1` | tied active | `motion_buffer_cs1_n_from_8j_8l = 1'b0` | exact | Named from Sheet 4B audit. |
| `8L` | 17 | `CS2` | tied active | `motion_buffer_cs2_n_from_8j_8l = 1'b0` | exact | Named from Sheet 4B audit. |
| `8L` | 18 | `OE` | tied active | `motion_buffer_oe_n_from_8j_8l = 1'b0` | exact | Named from Sheet 4B audit. |

## Sheet 4B: 9T Latch And 9H Final MBIT Select

| IC | pin | schematic net | connected IC/pin | RTL signal | status | evidence/notes |
| --- | --- | --- | --- | --- | --- | --- |
| `9T` | 11 | CLK | `BSM` timing rail | `motion_buffer_9t_clk_en_from_bsm = bsm` | exact | Crop/audit confirms 9T clocks from `BSM`. |
| `9T` | 1 | `/CLR` | held inactive | `motion_buffer_9t_clear_n_from_sheet = 1'b1`; model reset is FPGA-only | exact | Clear held inactive in schematic model. |
| `9T` | 8 | D input for `LB03` | `8J/8L` output side | `.d({lb1_from_8l, lb0_from_8j})` | exact | Cached crop shows pin 9 output is `LB03`. |
| `9T` | 9 | Q output | `LB03` to `9H` | `lb0_from_9t[3]` | exact | Pin order visible in cached `9T/9H` crop. |
| `9T` | 13 | D input for `LB02` | `8J/8L` output side | `.d({lb1_from_8l, lb0_from_8j})` | exact | Cached crop shows pin 12 output is `LB02`. |
| `9T` | 12 | Q output | `LB02` to `9H` | `lb0_from_9t[2]` | exact | Pin order visible in cached `9T/9H` crop. |
| `9T` | 14 | D input for `LB01` | `8J/8L` output side | `.d({lb1_from_8l, lb0_from_8j})` | exact | Cached crop shows pin 15 output is `LB01`. |
| `9T` | 15 | Q output | `LB01` to `9H` | `lb0_from_9t[1]` | exact | Pin order visible in cached `9T/9H` crop. |
| `9T` | 7 | D input for `LB00` | `8J/8L` output side | `.d({lb1_from_8l, lb0_from_8j})` | exact | Cached crop shows pin 6 output is `LB00`. |
| `9T` | 6 | Q output | `LB00` to `9H` | `lb0_from_9t[0]` | exact | Pin order visible in cached `9T/9H` crop. |
| `9T` | 3 | D input for `LB13` | `8J/8L` output side | `.d({lb1_from_8l, lb0_from_8j})` | exact | Cached crop shows pin 2 output is `LB13`. |
| `9T` | 2 | Q output | `LB13` to `9H` | `lb1_from_9t[3]` | exact | Pin order visible in cached `9T/9H` crop. |
| `9T` | 18 | D input for `LB12` | `8J/8L` output side | `.d({lb1_from_8l, lb0_from_8j})` | exact | Cached crop shows pin 19 output is `LB12`. |
| `9T` | 19 | Q output | `LB12` to `9H` | `lb1_from_9t[2]` | exact | Pin order visible in cached `9T/9H` crop. |
| `9T` | 17 | D input for `LB11` | `8J/8L` output side | `.d({lb1_from_8l, lb0_from_8j})` | exact | Cached crop shows pin 16 output is `LB11`. |
| `9T` | 16 | Q output | `LB11` to `9H` | `lb1_from_9t[1]` | exact | Pin order visible in cached `9T/9H` crop. |
| `9T` | 4 | D input for `LB10` | `8J/8L` output side | `.d({lb1_from_8l, lb0_from_8j})` | exact | Cached crop shows pin 5 output is `LB10`. |
| `9T` | 5 | Q output | `LB10` to `9H` | `lb1_from_9t[0]` | exact | Pin order visible in cached `9T/9H` crop. |
| `9H` | 1 | `VDBH` select | horizontal timing | `motion_buffer_9h_select_from_vdbh = vdbh` | exact | `9H` is final LS157 selector; not `9K`. |
| `9H` | 15 | enable | tied active | `enable_n(1'b0)` | exact | RTL ties LS157 enable active. |
| `9H` | 11 | A input | `LB03` from `9T` | `lb0_from_9t[3]` | exact | New cached 9H crop confirms pin 11 `LB03`. |
| `9H` | 10 | B input | `LB13` from `9T` | `lb1_from_9t[3]` | exact | New cached 9H crop confirms pin 10 `LB13`. |
| `9H` | 9 | output | `MBIT3` | `mbit_from_9h[3]`, `mbit_schematic[3]` | exact | New cached 9H crop confirms pin 9 `MBIT3`; non-driving while `USE_SCHEMATIC_MOTION_BUFFER=0`. |
| `9H` | 5 | A input | `LB02` from `9T` | `lb0_from_9t[2]` | exact | New cached 9H crop confirms pin 5 `LB02`. |
| `9H` | 6 | B input | `LB12` from `9T` | `lb1_from_9t[2]` | exact | New cached 9H crop confirms pin 6 `LB12`. |
| `9H` | 7 | output | `MBIT2` | `mbit_from_9h[2]`, `mbit_schematic[2]` | exact | New cached 9H crop confirms pin 7 `MBIT2`; non-driving while `USE_SCHEMATIC_MOTION_BUFFER=0`. |
| `9H` | 14 | A input | `LB01` from `9T` | `lb0_from_9t[1]` | exact | New cached 9H crop confirms pin 14 `LB01`. |
| `9H` | 13 | B input | `LB11` from `9T` | `lb1_from_9t[1]` | exact | New cached 9H crop confirms pin 13 `LB11`. |
| `9H` | 12 | output | `MBIT1` | `mbit_from_9h[1]`, `mbit_schematic[1]` | exact | New cached 9H crop confirms pin 12 `MBIT1`; non-driving while `USE_SCHEMATIC_MOTION_BUFFER=0`. |
| `9H` | 2 | A input | `LB00` from `9T` | `lb0_from_9t[0]` | exact | New cached 9H crop confirms pin 2 `LB00`. |
| `9H` | 3 | B input | `LB10` from `9T` | `lb1_from_9t[0]` | exact | New cached 9H crop confirms pin 3 `LB10`. |
| `9H` | 4 | output | `MBIT0` | `mbit_from_9h[0]`, `mbit_schematic[0]` | exact | New cached 9H crop confirms pin 4 `MBIT0`; non-driving while `USE_SCHEMATIC_MOTION_BUFFER=0`. |

## Open Pin-Audit Items Before Any Behaviour Change

- LS194 `S0/S1` pin-to-net assignment is now exact for the `10C`/`10D` rails.
- `BYTLOAD`, `NIB LOAD`, `FLIP`, `LOF`, and the `B5M`/legacy-`BSM` timing rail must remain separate until
  sources are proven; the active LS194 behaviour still uses the provisional
  renderer shortcut.
- Cross-sheet B5M source note: manual Sheet 2A Master/Slave Interconnect review
  corrects the earlier `ESM/BSM` reading to `E5M/B5M`. Upper `1P` distributes
  `E1H/E2H/E4H/E8H` into `B1H/B2H/B4H/B8H`; lower `1R` is the local
  buffer/distribution stage from upstream `E5M` at connector pin 31 to
  the local `B5M*` node. The Sheet 2A crop now documents nearby `8C` inverter
  sections as pin 5 -> 6 labelled `B5M*` and pin 9 -> 8 labelled `B5M`. Existing
  row labels that say `BSM` are legacy audit/RTL names for this rail until the
  local Sheet 4A/4B labels are re-cropped. Sheet 6B now proves the source-side
  handoff: lower `3D` LS244 buffers `5MHZ` on pin 11 to `E5M` on output pin 9,
  exported at J17 pin 31, then received on Sheet 2A by `1R` pins 2 and 17 before
  `1R` outputs pin 18 `B5M*` and pin 3 `B5M`. Sheet 4A/4B destination pins stay
  `exact`; remaining risk is phase/polarity modelling of the generated 5 MHz
  rail, not an unknown `E5M` connector source. Since FPGA clocks/enables will be
  generated internally, the LS244/LS04 distribution chain is connection
  provenance rather than a requirement to duplicate every physical buffer in RTL.
- `8F` uses `IV`, not the Sheet 6B `INY` graph-register signal.
- `7J/7K/7L/7M` preload data pins are represented by temporary X-derived addresses, not a proven schematic address lifetime.
- `8J/8L` are still represented by a compatibility two-bank bridge plus a non-driving single-address probe.
- `8K/8M` LS157 enable pin mapping is documented; the remaining uncertainty is `IV/7F` timing, because current useful pixels are rejected by local control phase.
- See `Documents/sheet_4a_4b_timing_source_audit.md`: current RTL sources for `IV`, `BYTLOAD`, and legacy `bsm`/corrected `B5M` are provisional aliases, so do not infer new pin swaps from their current phase behaviour.
