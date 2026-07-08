# Schematic Crops

Stable crop cache for repeated schematic inspection. These images are inspection
aids only; audit entries still need schematic reasoning and/or RTL evidence
before behavior-driving changes.

## Sheet 4A

Source: `Documents/cloak.pdf`, PDF page 62, rendered at 220 dpi with Ghostscript
and cropped/inspected with `.venv-pillow`.

- `sheet_4a/sheet_4a_full_pdf62_r220.png`: full Sheet 4A render.
- `sheet_4a/sheet_4a_7f_8f_local_crop.png`: local 7F/8F output labels.
- `sheet_4a/sheet_4a_7f_8f_boundary_wide.png`: 7F/8F IV, IVDBH, BYTLOAD boundary.
- `sheet_4a/sheet_4a_7f_8f_iv_labels_zoom.png`: enlarged crop from the cached 7F/8F boundary showing 8F `A=IVDBH`, `B=IV`, and 7F `Q`/`/Q` label placement.
- `sheet_4a/sheet_4a_1h_8f_bytload_decode_zoom.png`: zoomed 1H/8F decode crop showing `BYTLOAD` on the active-low LS139 enable pins, `1H` upper-half pins `A=IV`, `B=0`, `Y1=MOHLO`, `Y0=MOHLI`, and `8F` pins `A=IVDBH`, `B=IV`, `Y1=MOHRO`, `Y2=MOHRI`.
- `sheet_4a/sheet_4a_11f_flip_latch_crop.png`: 11F FLIP latch boundary (`FLIPM`, `LOF`, `FLIP`).
- `sheet_4a/sheet_4a_11f_lof_wide_crop.png`: wider 11F/1H/8F view showing `LOF` as a named clock input, separate from the local `BYTLOAD` line.
- `sheet_4a/sheet_4a_6h_flipm_m14h_crop.png`: 6H/8H and LS86 area showing `COCKTAIL`, `MOFLIP`, `FLIPM`, `/4H`, and `M14H`.
- `sheet_4a/sheet_4a_6h_left_boundary_crop.png`: wider 6H/8H boundary showing LS83/LS20 inputs into `6H` (`COCKTAIL`, `/MATCH`, `MOPA4..1`).
- `sheet_4a/sheet_4a_ls194_control_crop.png`: LS194 and LS00 control area.
- `sheet_4a/sheet_4a_ls194_control_zoom.png`: enlarged LS194 mode/control trace.
- `sheet_4a/sheet_4a_ls194_mode_logic_r360.png`: high-resolution LS00 mode logic around `MATCH`, `NIB LOAD`, and `FLIP`.
- `sheet_4a/sheet_4a_ls194_nibload_to_decode_boundary_crop.png`: wider LS194/1H/8F boundary showing the nearby `BYTLOAD` label and LS194 control rails; use with care because it does not prove `BYTLOAD` source.
- `sheet_4a/sheet_4a_ls194_nibload_10c_10d_crop.png`: lower LS00 control-gate crop showing `/MATCH`, `NIB LOAD`, `FLIP`, 10C, and 10D.
- `sheet_4a/sheet_4a_ls194_10c_10d_zoom.png`: zoomed LS00 gate labels/pins for 10D pin 6, 10C pin 6, 10D pin 11, and 10D pin 8.
- `sheet_4a/sheet_4a_nib_load_trace_crop.png`: Sheet 4A view showing `NIB LOAD` entering the LS194 mode logic as a named incoming net.
- `sheet_4a/sheet_4a_bytload_lof_ls194_wide_crop.png`: wider cached full-render crop covering the LS194s, 1H/8F decode, 7F, 7N, and the lower 10C/10D mode gates; use to keep `BYTLOAD`, `NIB LOAD`, and `LOF` visually separated.
- `sheet_4a/sheet_4a_bytload_1h_8f_extended_trace_crop.png`: extended Sheet 4A crop from the full render, spanning motion ROMs, LS194s, 1H/8F, 7F, and 11F edge context. It confirms `BYTLOAD` is a named net at the 1H/8F decode boundary in this view, not a visible local output of the nearby 10C/10D LS194 mode gates.
- `sheet_4a/sheet_4a_6n_8r_motion_rom_pin_crop.png`: focused 6N/8R 2532 motion-ROM crop showing shared address pins `MOPA11..MOPA1` plus `M14H`, chip selects tied low, and 6N/8R data outputs `M0..M7` / `M8..MF`.
- `sheet_4a/sheet_4a_7n_mbj_flip_selector_crop.png`: focused 7N LS157 crop showing physical package order: pins 5/6/7 for `MBJ3/MBJ3F/MBJ3*`, pins 14/13/12 for `MBJ2/MBJ2F/MBJ2*`, pins 2/3/4 for `MBJ1/MBJ1F/MBJ1*`, and pins 11/10/9 for `MBJ0/MBJ0F/MBJ0*`.

## Sheet 4B

Source: `Documents/cloak.pdf`, PDF page 63, rendered at 220 dpi with Ghostscript
and cropped/inspected with `.venv-pillow`. The earlier
`/tmp/cloak_hi/motion_sheet4b_buffer_zoom.png` crop was also promoted into the
persistent cache; use these instead of regenerating the same buffer-area crops.

- `sheet_4b/sheet_4b_full_pdf63_r220.png`: full Sheet 4B render.
- `sheet_4b/sheet_4b_left_half_pdf63_r220.png`: left half of Sheet 4B showing the `7J/7K/7L/7M` counters, `8K/8M` muxes, and `8J/8L` RAM inputs.
- `sheet_4b/sheet_4b_top_half_pdf63_r220.png`: top half of Sheet 4B for quick orientation around the motion-buffer block.
- `sheet_4b/sheet_4b_motion_buffer_zoom_cached.png`: motion-buffer area around `7J/7K/7L/7M`, `8K/8M`, `8J/8L`, `9T`, and `9H`.
- `sheet_4b/sheet_4b_left_write_controls_crop.png`: left portion of the cached Sheet 4B zoom covering the counter/mux/write-control side.
- `sheet_4b/sheet_4b_9t_9h_center_crop.png`: center of the cached Sheet 4B zoom covering `8J/8L` outputs into `9T/9H`.
- `sheet_4b/sheet_4b_9h_final_selector_crop.png`: final 9H LS157 selector crop showing `LB03/LB13 -> MBIT3`, `LB02/LB12 -> MBIT2`, `LB01/LB11 -> MBIT1`, and `LB00/LB10 -> MBIT0`.
