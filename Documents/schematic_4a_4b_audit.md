# Cloak & Dagger Sheets 4A/4B Schematic Audit

Branch: `refactor/schematic-motion-object`

Purpose: stop speculative sprite fixes. Every future motion-object change must
reference a row in this audit and either implement it or correct the audit.

Global schematic inventory:

- `Documents/full_schematic_audit.md`

Source images:

- `Documents/cloak.pdf`
- rendered reference: `/tmp/cloak_hi/motion_sheet4a.png`
- rendered reference: `/tmp/cloak_hi/motion_sheet4b.png`

Legend:

- `DONE`: structurally represented and wired with schematic-style names.
- `PARTIAL`: represented, but still simplified or not net-for-net verified.
- `MISSING`: not yet represented structurally.
- `VERIFY`: visible on schematic, but the exact wiring still needs manual
  confirmation before implementation.

## Current Non-1:1 Areas

The present Verilog is still not a 1:1 reproduction. The largest shortcuts are:

- Motion RAM is still accessed as three software-style tables:
  Y at `0x00..0x3f`, attributes at `0x40..0x7f`, X at `0xc0..0xff`.
- The Sheet 4A object scan/load timing is still driven by abstract
  `render_sprite`/`render_half` state, not by the schematic counters/latches.
- The Sheet 4A `MOHLD`, `MOHRD`, `MOHLC`, `MOHRC`, `MATCH`, `MOFLIP` control
  chain is not net-for-net implemented.
- Sheet 4B final video muxing now has provisional `pbit`, `bmap`, `mbit`,
  `mbj_pending*`, and `lb_display` names, but is still a simplified priority
  mux and line-buffer path in `rtl/cloak_core.sv`.

Latest MiSTer test note:

- Commit `8444cef` restored the schematic-style vertical match window and kept
  the diagnostic inverted motion flip polarity. Player orientation looked more
  plausible, but player/enemy graphics were still very corrupted and sometimes
  spatially separated. Treat this as evidence that continuing sprite nibble or
  flip experiments is low-value until the active path stops bypassing the Sheet
  4B `74LS163`/`93422`/`9T`/`9H` buffer chain.
- Commit `d3e445f` enabled the schematic motion buffer diagnostic with
  `USE_SCHEMATIC_MOTION_BUFFER=1` and phase `2`. MiSTer screenshots in
  `../MISTER screenshots/Latest02` show a terrible regression: persistent
  full-height vertical colored stripe columns overlay the title, high-score,
  intro, and gameplay scenes. Background/playfield/text remain recognizable
  underneath, so this is evidence that the current 93422/9T/9H visible path is
  leaking or retaining motion-buffer data across scanlines. The visible selector
  was restored to compatibility immediately after this test; next work should
  focus on buffer clear/bank/read timing rather than trying more visual phase
  guesses.
- Commit `438760d` added an inactive 93422 bridge clear pass while keeping
  `USE_SCHEMATIC_MOTION_BUFFER=0`. MiSTer screenshots in
  `../MISTER screenshots/Latest03` confirm the full-height vertical stripe
  regression is gone, but show remaining circled floor/edge artifacts during
  gameplay. User also reports random horizontal lines at the top of the screen
  when firing, and the known incorrect main-character/enemy rendering remains.
  Treat these as evidence that retained-buffer state improved, but the motion
  object scan/pixel/write timing is still not correct enough for visual
  sign-off.
- Additional Latest03 screenshot `20260630_184213-screen.png` shows circled
  title-screen character/object fragments near the left and right screen edges
  that appear split into coherent horizontal pieces rather than randomly
  corrupted. Treat this as evidence to prioritize the two-pixel pair sequencing,
  X-address stepping, and left/right 93422/9T/9H buffer selection timing before
  doing more visual flip/nibble experiments.

Sheet 4B timing audit note:

- PDF Sheet 4B (`Documents/cloak.pdf`, Sheet 4B "Motion Object Buffers")
  confirms both `8J` and `8L` `93422` RAMs are single-address motion buffers:
  the `7J/7K` and `7L/7M` counter outputs drive `A0..A7`, `WE` pin 20 is driven
  by `BSM`, and `CS1`, `CS2`, and `OE` pins 19/17/18 are tied active through
  the grounded rail/pull network. The schematic does not show separate read and
  write addresses or a line-bank select on the `93422` symbols.
- The same Sheet 4B crop confirms `9T` (`74LS273`) clocks from `BSM`, with clear
  held inactive, and `9H` (`74LS157`) selects `LB0/LB1` into `MBIT` using
  `VDBH`, with enable tied active. Therefore `9T/9H` are structurally named in
  RTL, but the upstream bridge feeding them is still not 1:1.
- Current Sheet 4B conclusion after commits through `7036fda`: the local 8K/8M
  LS157 pin mapping, 8J/8L 93422 CS/OE/WE pins, 9T latch phase, and 9H selector
  have now been corrected or explicitly verified in the non-driving path. The
  remaining mismatch is not a local Sheet 4B bit-order, 9H polarity, 93422
  enable, or stale-feedback problem; it is the temporary renderer/write bridge
  not being phase-coherent with the Sheet 4A `MOHLI/MOHRI/IVDBH` object-scan
  timing. Keep `USE_SCHEMATIC_MOTION_BUFFER=0` until that upstream timing is
  replaced or bridged with a documented non-driving handoff.

## Sheet 4A: Motion Object

### Motion RAM Address And Data

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `5L` | `74LS157` | `PABA7`, `PABA6`, `PABA5`, `PABA4`, `B4H`, `B2H`, `B32H`, `12BH`, `MOA7..MOA4`, `MORAM*` | Upper motion RAM address mux | `PARTIAL` | RTL now uses explicit `cloak_74ls157` instances for the upper CPU/Y/ATTR/X MOA phases. This is still phase-expanded because the renderer has not yet been converted to the single physical MOA bus. |
| `5M` | `74LS157` | `PABA3..PABA0`, `B32H`, `B8H`, `5H`, `MOA3..MOA0`, `MORAM*` | Lower motion RAM address mux | `PARTIAL` | RTL now uses explicit `cloak_74ls157` instances for the lower CPU/Y/ATTR/X MOA phases. The exact board select equation is still pending the timed object-scanner rewrite. |
| `6M`, `6L` | `2101A-2` | `MOA0..MOA7`, `PABD0..PABD7`, `MOD0..MOD7`, `PAWRITE` | Motion-object RAM pair | `PARTIAL` | Storage is now split into `motion_ram_6l` and `motion_ram_6m` nibble arrays, with named low/high MOD outputs. Reads are still phase-expanded because the renderer has not yet been converted to one timed physical MOA/MOD bus. |
| `7H` | `74LS244` | `MOD0..MOD7`, `PABD0..PABD7`, `MORAM*`, `PABR/W` | CPU readback buffer from motion RAM | `PARTIAL` | RTL now instantiates `u_7h_mod_to_pabd_buffer` with active-low enables derived from `MORAM` and CPU read. Internal tri-state is represented as inactive `8'hFF`; exact board enable polarity should still be pin-verified. |

### Motion Data Latches And MOPA Generation

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `6K` | `74LS273` | `MOD0..MOD7`, `CLS A..H`, intermediate outputs | Latches motion RAM data into counter/address path | `PARTIAL` | RTL now instantiates an explicit `cloak_74ls273` as `u_6k_mod_latch`, clock-enabled from the detected `B2H` rising edge. Its `CLS` output is named but not yet behaviour-driving until the downstream `5K/6J/6H` path is connected. |
| `6J` | `74LS83` | `CLSA..CLSD`, vertical timing bits, carry/sum outputs | Low-nibble motion Y adder | `PARTIAL` | Crop confirms this is an LS83 adder, not an LS163 counter. RTL now instantiates `u_6j_motion_y_adder_low`; its low sum drives the motion ROM line address through `mopa_low_from_6h`. It still uses direct `MOD` as `cls_for_5k_6j` until the full B2H/B4H object scan timing can safely use the 6K latch output. |
| `5K` | `74LS83` | `CLSE..CLSH`, vertical timing bits, carry from `6J`, high sum outputs | High-nibble motion Y adder | `PARTIAL` | RTL now instantiates `u_5k_motion_y_adder_high`; high sum bits feed the named `5J` match decode. |
| `5J` | `74LS20` | High `5K` sum bits, output to `6H` latch | Decodes vertical match window | `PARTIAL` | RTL now names `match_from_5j_ls20_n` and derives `match_from_6h` from the LS20-style active-low decode. |
| `8H` | `74LS273` | `MOD0..MOD7`, `MOFLIP`, `MOPA5..MOPA11`, `B4H` | Latches flip and high motion picture address bits | `PARTIAL` | Crop confirms `MOD7 -> MOFLIP` and `MOD6..0 -> MOPA11..5`; RTL now instantiates `u_8h_motion_addr_latch` with a detected `B4H` rising edge. The latched outputs are named, but the simplified renderer still uses direct MOD attributes until the full motion-address timing chain is connected. |
| `6H` lower latch | `74LS174` | `MATCH`, `MOFLIP`, `MOPA1..4`, `B4H` | Captures low MOPA/match related state | `PARTIAL` | Crop confirms the latch outputs `MATCH` and `MOPA1..4`; RTL now instantiates `u_6h_match_mopa_latch` using the same detected `B4H` edge. The latched outputs are named but not yet behaviour-driving. |

### Motion ROMs And M Data Bus

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `6N`, `8R` | `2532` | `MOPA1..MOPA11`, `M0..MF` | Two motion-object graphics ROMs | `PARTIAL` | Motion graphics storage is now split into two 4K `cloak_gfx_rom` instances, `motion_graphics_6n` and `motion_graphics_8r`, sharing the same 12-bit address. RTL exposes `mrom_parallel_pixel0..3` and `mrom_parallel_pair_pixel0/1` from the 16-bit `M0..MF` bus. `USE_SCHEMATIC_MOTION_ROM_PIXELS` defaults off again after the MiSTer experiment made motion graphics worse; LS194 load/shift timing still needs verification before this can be considered final 1:1 behavior. |
| `6P`, `6R`, `7P`, `7R` | `74LS194` | `M0..MF`, `MBJ0..MBJ3`, `MBJ0F..MBJ3F`, `MATCH`, `FLIP` | Shift-register pixel path | `PARTIAL` | RTL now instantiates four `cloak_74ls194` registers with the visible interleaved ROM-bit groupings. Their `MBJ/MBJF` outputs are named but not yet behaviour-driving because the exact `BYTLOAD`/shift/flip timing is still pending. The current shortcut is now explicit in code as `motion_shift_load_from_render_pending = render_pending` with provisional parallel-load mode `2'b11`; this documents that the LS194s are still being loaded by the temporary renderer rather than the schematic BYTLOAD/shift chain. Sim-only render-pair diagnostics show the temporary renderer's sampled writes all occur at `render_pair=3`; the current `7N` output matches `pending0` for all 1023 samples and never matches `pending1` (`7n_p1=0`, `ls194_p1=0`, `mbjf_p1=0`), so the remaining right-side 8M issue is not fixed by directly substituting the present LS194/7N output for the second pending pixel. |
| `7N` | `74LS157` | `MBJ*`, `MBJF*`, `FLIP`, selected `MBJ*` | Flip/select mux for motion pixel bits | `PARTIAL` | RTL now instantiates `u_7n_mbj_flip_select`, selecting between normal and flipped LS194 outputs using latched `FLIP`. Its output is named but not yet behaviour-driving until LS194 load/shift timing is verified. |

### Control And Timing

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `1H`, `8F` | `74LS139` | `BYTLOAD`, `IV`, `IVDBH`, `MOHLO`, `MOHLI`, `MOHRI`, `MOHRO` | Decode motion hold/read/load controls | `PARTIAL` | Enlarged Sheet 4A crop confirms `1H` is always enabled and uses LS139 outputs `Y0/Y1` as `MOHLO/MOHLI`; `8F` is enabled by `BYTLOAD` and uses lower-half outputs `Y0/Y1` as `MOHRO/MOHRI`. RTL now corrects the named output indices to `mohlo=y0`, `mohli=y1`, `mohro=y0`, `mohri=y1`, and maps 8F pins as `A=IV`, `B=IVDBH` (`sel={IVDBH,IV}` for the local LS139 model). The temporary sources are now explicitly named `bytload_from_render_pending`, `iv_provisional_from_display_line_bank`, and `lof_from_bytload_provisional` so the remaining shortcut is visible in code. Icarus passes with `USE_SCHEMATIC_MOTION_BUFFER=0`; corrected-path diagnostics improve but remain phase-incoherent (`schematic_missing` improves from `128` to `112`, `8k_sel_mbj=1023`, `8m_sel_mbj=8`). The 8F select-order correction is schematic-backed but does not materially change the bridge signature, so the remaining bad phase is mainly the right-side `MOHRI`/8M relationship against the temporary renderer. |
| `11F` | `74LS74` | `FLIPM`, `LOF`, `FLIP` | Flip/load timing latch | `PARTIAL` | RTL now instantiates `u_11f_flip_latch`; `LOF` is still a simplified byte-load alias and the latched `FLIP` output is named but not yet behaviour-driving. |
| `7F` | `74LS74` | `IV`, `B8H`, `IVDSH`, `IVDBH` | Video timing latch | `PARTIAL` | Sheet 4A crop confirms the latch clocks from `B8H` and captures `IV`; RTL now clocks `u_7f_ivdb_latch` from the detected `B8H` edge. A non-driving opposite-edge candidate was worse for the right 8M phase (`render_mbj=12 render_fb=1011` versus the current `8m_sel_mbj=8 8m_sel_fb=1015` and inverted-`IV`/`MOHRO` candidates at `504/519`). A small IV-source candidate matrix also rejects simple aliases for inverted line-bank, `vcnt[0]`, and inverted `vcnt[0]` because all score `12/1011` for 8M MBJ selection. The remaining issue is therefore more likely the object-scan/write phase relative to the decoded right-side strobes than a simple 7F edge or line-bank polarity swap. The exact upstream `IV` source is still provisional in RTL, so this remains non-driving for visible motion output. |
| Gates around `MATCH`, `M14H`, `FLIPM`, `FLIPN` | `74LS00`, `74LS04`, `74LS08`, etc. | `MATCH`, `FLIP`, `M14H` | Pixel/object enable and flip controls | `MISSING/PARTIAL` | RTL now has provisional `match_from_6h`, `flipm`, and `m14h` aliases. Gate equations still need full pin-level trace before they can drive behavior. |

## Sheet 4B: Motion Object Buffers / Video

### Left/Right Motion Object Buffers

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `7J`, `7K`, `7L`, `7M` | `74LS163A` | `MOHL*`, `MOHR*`, `MOD*`, outputs to `93422` address | Motion buffer address counters | `PARTIAL` | RTL now instantiates four `cloak_74ls163` counters named for `7J/7K/7L/7M`. Upper `7J/7K` load/clear now use decoded `MOHLO/MOHRO`; lower `7L/7M` load/clear use decoded `MOHLI/MOHRI`; all four clock from the named `BSM` phase, with count enables tied active to match the pulled-up LS163 enable pins. Sheet 4B crop confirms the physical parallel load inputs are `MOD0..MOD7` on both counter pairs; the current RTL load values are still provisional two-pixel X addresses from the temporary renderer, with their validity boundary named as `motion_buffer_load_addr_valid = render_pending`. A direct non-driving trial of `mod_render_x` load data was reverted after smoke worsened the inactive path (`schematic_missing` rose from 32 to 172), showing that the MOD source itself is not phase-coherent yet in the current phase-expanded model. New render-write address diagnostics show the temporary bridge write addresses still match their provisional load values (`known=1024 expected=1024 adjacent=1024`), but the inactive schematic counters do not yet line up with those load/write addresses (`counter known=1024 exact=0 prev=0 next=0 cross=0`). After correcting 1H/8F output indices, render-phase load activity moved to the right-side load net (`left_load=0 right_load=1024`, with `left_clear=504 right_clear=8`), confirming the previous left-load-only result was partly an LS139 output-index error. A later non-driving current-scan bridge trial, using the current object-scan sample instead of delayed `render_pending`, was rejected because it introduced `value_mismatch=48` and worsened the single-address probe (`d1_missing=175` versus the prior `167`). This remains phase-incoherent because the right-side mux still rarely selects MBJ during render. |
| `8J`, `8L` | `93422` | Address `A0..A7`, data `D1..D4`, outputs `O1..O4`, `WE`, `CS`, `OE`, `BSM` | Two motion-object buffer RAMs | `PARTIAL` | PDF audit verifies both Sheet 4B `93422` symbols have one `A0..A7` address bus, data pins `D1..D4`, output pins `O1..O4`, `WE` pin 20 driven by `BSM`, and `CS1`, `CS2`, `OE` pins 19/17/18 tied active through the grounded rail/pull network. RTL now names those pin-level controls as `motion_buffer_we_n_from_8j_8l = !bsm`, `motion_buffer_cs1_n_from_8j_8l = 0`, `motion_buffer_cs2_n_from_8j_8l = 0`, and `motion_buffer_oe_n_from_8j_8l = 0`, but still wraps each schematic RAM in a temporary two-bank FPGA bridge so the inactive path can preserve the current renderer's read/write line lifetime. Icarus control-pin evidence confirms the named CS/OE pins remain active for every sampled cycle: `known=78781 cs_oe_active=78781 cs_oe_inactive=0`. The focused `sim/motion_buffer_tb.sv` harness now also verifies that a disabled CS prevents writes and that disabled OE/CS outputs latch as inactive `4'hf` through `9T/9H`. This bridge is not 1:1: it has separate read/write addresses, writes on `render_pending || clear`, clears through the visible raster address, and selects a line bank with `display_line_bank`; the PDF shows none of those as `93422` pins. Smoke-test evidence quantifies the mismatch: `schematic_bsm=78781 bridge=63983 overlap=63983 bridge_only=0 schematic_only=14798 blank=14798 render=0 visible=0`. New 9T/WE phase counters confirm the named schematic latch clock and 93422 WE are currently the same BSM phase in RTL (`9T clk=78781 we_overlap=78781`), while only the temporary bridge write subset overlaps it (`bridge_overlap=63983`, `blank=19389 visible=59392`). All bridge writes occur during the current `BSM` alias, and the skipped schematic-only `BSM` phases are blanking rather than visible/render phases, so this diagnostic does not justify switching the bridge to write on every `BSM`. Render writes use loaded two-pixel pair addresses directly because the synchronous FPGA RAM otherwise sampled stale LS163 outputs on the same `BSM` edge; harness address compare improved from `expected=0 adjacent=0` to `expected=1024 adjacent=1024`. The temporary renderer advances every core clock, so inactive 93422 render writes sample every `render_pending` cycle rather than the final schematic object-scan write phase; this remains an explicit bridge mismatch to remove when the object scan is converted to true schematic timing. Corrected 8K/8M pin mapping changes the current inactive signature to `compat_d1_nonzero=192 schematic_missing=112`, showing the local 93422 RAM wrapper is still receiving phase-incoherent data/control from the temporary renderer. Visible pixels still use the simplified `sprite_line` arrays. |
| `8K`, `8M` | `74LS157` | `MBJ*`, `LB*`, `MOHLI/MOHRI`, `IVDBH`, outputs to buffer data | Selects data written into motion buffers | `PARTIAL` | Sheet 4B crop verifies the vector convention used by RTL: `[3:0]` is physical `D4..D1` / `LBx3..LBx0` / `MBIT3..MBIT0`; LS157 outputs route as pin 9 -> `D4`, pin 12 -> `D3`, pin 7 -> `D2`, pin 4 -> `D1` on both `8K -> 8J` and `8M -> 8L`. A later crop re-check corrected the control pins: 8K pin 1 select is active-low `MOHLI`, 8M pin 1 select is active-low `MOHRI`, and both pin 15 enables are `IVDBH`, not tied active and not `IVDSH/IVDBH` selects. RTL now names this as `motion_buffer_8k_select_from_mohli_n`, `motion_buffer_8m_select_from_mohri_n`, and `motion_buffer_8k/8m_enable_n_from_ivdbh`. Icarus passes with `USE_SCHEMATIC_MOTION_BUFFER=0`, but the inactive schematic-buffer comparison worsens after the pin correction (`compat_d1_nonzero=192 schematic_missing=128`, `data_nonzero=496`, `other_window_match=0`, selected d1 matches only `64`). Render-control counters explain why: `IVDBH` enables both muxes about half the render samples (`8k_en=512 8k_dis=511`, same for 8M), but the current `render_pending` phase almost never coincides with MBJ selection (`8k_sel_mbj=0 8k_sel_fb=1023`, `8m_sel_mbj=8 8m_sel_fb=1015`). A one-cycle-prewrite probe is asymmetric: previous-cycle 8K mostly selects MBJ (`8k_sel_mbj=1015 8k_sel_fb=8`), while previous-cycle 8M still selects feedback (`8m_sel_mbj=0 8m_sel_fb=1023`). After correcting 1H/8F decode outputs, render 8K is aligned (`8k_sel_mbj=1023`) but 8M remains mostly feedback (`8m_sel_mbj=8`). Non-driving candidate probes show neighboring `MOHRO` and inverted provisional `IV` both make 8M select MBJ for about half of render samples (`render_mbj=504 render_fb=519`), and a render-pair classifier shows this is concentrated at `render_pair=3` (`MOHRI p3=8`, `MOHRO p3=504`). Render-tag diagnostics show the temporary bridge has collapsed all render writes to `pending_x[2:0]=4` (`t4=1023`, all other immediate tags zero; one-cycle delayed tags are still mostly `t4=1008`, with only `t6=15`); at that tag 8K selects MBJ for all writes (`8k_mbj t4=1023`) while 8M selects feedback for nearly all writes (`8m_mbj t4=8`, `8m_fb t4=1015`). A score-only pair-3 candidate is identical to the full `MOHRO` score (`mbj=504 fb=519`) and would produce enabled nonzero right-side MBJ data for all 504 of those samples (`mbj_data=504 nonzero=504`), confirming the useful right-side MBJ window is entirely tied to that temporary-renderer write phase. Treat this as `VERIFY` evidence that the structural pin mapping is now closer to Sheet 4B, while upstream `MOHRI/IVDBH/IV` timing is not phase-coherent with the temporary renderer. |
| `9T` | `74LS273` | `LB00..LB03`, `LB10..LB13`, buffer outputs | Latches buffer outputs into `LB` buses | `PARTIAL` | PDF audit verifies Sheet 4B `9T` clocks from `BSM`, latches the `8J/8L` `O1..O4` outputs into `LB00..LB03` and `LB10..LB13`, and has clear held inactive. RTL now names these controls as `motion_buffer_9t_clk_en_from_bsm = bsm` and `motion_buffer_9t_clear_n_from_sheet = 1`, using the same BSM latch enable for the bridge and single-address probe; Icarus smoke after this naming-only change passed with unchanged motion-buffer diagnostics. The enlarged `9T/9H` crop confirms the RTL latch packing `{lb1_from_8l, lb0_from_8j}` with `lb0_from_9t = [3:0]` and `lb1_from_9t = [7:4]` preserves `LBx3..LBx0` bit order. RTL instantiates `u_9t_line_buffer_latch` with `clk_en = bsm`, matching the named latch phase. The focused `sim/motion_buffer_tb.sv` harness now verifies both that changing the 93422 read address does not change `9H` output until the next `9T` latch edge and that a same-edge write/latch keeps the old RAM output until a later latch in the current synchronous FPGA model. Status remains `PARTIAL` because the data feeding `9T` still comes from the temporary two-bank bridge rather than a single-address schematic `93422` path, and its outputs are not behaviour-driving. |
| `9H` | `74LS157` | `LB*`, outputs `MBIT0..MBIT3`, `VDBH` | Selects final motion bits | `PARTIAL` | PDF audit verifies Sheet 4B `9H` is the `74LS157` final motion-bit selector: `LB03/LB02/LB01/LB00` are its A inputs, `LB13/LB12/LB11/LB10` are its B inputs, `VDBH` drives select pin 1, enable is tied active, and outputs are `MBIT3..MBIT0`. RTL now names the selector as `motion_buffer_9h_select_from_vdbh` and uses it for both the bridge `9H` and single-address probe `9H`, preserving the existing polarity; Icarus smoke after this naming-only change passed with unchanged motion-buffer diagnostics. Visible video remains on compatibility `mbit = lb_display` after the phase-2 schematic-buffer MiSTer diagnostic caused full-height vertical stripe columns. The failed visible test used `USE_SCHEMATIC_MOTION_BUFFER=1`; keep `USE_SCHEMATIC_MOTION_BUFFER=0` until the upstream `8J/8L` read/write phase is coherent. Current main `cloak_core_tb` diagnostics after corrected 8K/8M and 1H/8F mapping are still non-driving only: `compat_d1_nonzero=192 schematic_missing=112 value_mismatch=0`, with the remaining miss attributed to upstream `MOHRI/IVDBH/IV` phase coherence rather than 9H polarity. |

Active-path boundary:

- `rtl/cloak_core.sv` now names `mbit_compat` as the temporary
  `sprite_line0/1` output and `mbit_schematic` as the Sheet 4B `9H` output.
  `USE_SCHEMATIC_MOTION_BUFFER` is back to `0` after the phase-2 MiSTer
  diagnostic regressed into full-height vertical stripe columns. Keep the
  compatibility boundary active until clear/bank/read timing is corrected.
- Reference-designator audit note: Sheet 4B `9H` is the `74LS157` final
  `LB0/LB1` to `MBIT` selector. Sheet 4B `9K` is the `74LS260` `MBIT` zero
  detect gate in the `COLSEL` chain. RTL, simulation harnesses, and handoff
  notes have been corrected to avoid treating `9K` as the final motion mux.

### Final Video Mux

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| Gates around `COLSEL` | `74LS260`, `74LS00`, `74LS04`, `74LS32`, `74LS27` | `MBIT*`, `BMAP*`, `COLRAM`, `COLSEL0`, `COLSEL1` | Selects playfield/bitmap/motion/color-RAM source | `PARTIAL` | RTL now instantiates Sheet 4B `9K` (`74LS260`) for `MBIT` zero detect, `1L` (`74LS27`) for `BMAP` zero detect, `8C` inverter, `8D` OR, and `8E` NAND gates. `COLRAM` is active-high in RTL decode, so the schematic active-low input is represented as `colram_n`. The resulting `colsel_from_gates` now drives the active `COLA` palette-address mux. |
| `10H`, `10J` | `74LS153` | `PBIT*`, `BMAP*`, `MBIT*`, `PABA*`, outputs `COLA0..COLA3` | Selects low color address bits | `PARTIAL` | RTL now instantiates `u_10h_cola3_cola2_mux` and `u_10j_cola1_cola0_mux` using a `cloak_74ls153` model. Their `cola_low_from_10h_10j` output is behavior-driving for palette addressing when `USE_SCHEMATIC_COLOR_MUX=1`. |
| `11J` | `74LS157` | `PABA4/5`, `COLSEL*`, `COLRAM*`, output `COLA4/5` | Selects high color address bits | `PARTIAL` | RTL now instantiates `u_11j_cola5_cola4_mux`, selecting between `COLSEL0/1` and CPU `PABA4/5` using `COLRAM`. `cola_from_mux_tree` is behavior-driving for palette addressing when `USE_SCHEMATIC_COLOR_MUX=1`. |
| Color RAM address boundary | color RAM block | `COLA0..5`, `PABA6`, `PABD0..7` | Addresses and writes 64x9 color RAM | `PARTIAL` | RTL now names `cola_cpu_from_paba`, `colram_bit8_from_paba6`, `cola_video_from_mux_tree`, and `palette_word_from_cola`. Active visible color now uses `palette_index_schematic = cola_video_from_mux_tree` by default, with `palette_index_compat` retained as the old priority expression. |
| Remaining gates around `COLRAM`, `BMAP`, `MBIT` | `74LS00`, `74LS08`, `74LS27`, `74LS32`, `74LS04` | `COLRAM`, `COLSEL*`, `BMAP*`, `MBIT*` | Priority/control decode for final video mux | `PARTIAL` | The visible `COLSEL` chain, `COLA` palette address path, and Sheet 5A color latch output are now behavior-driving. Remaining work is to verify final blank timing against the PROM/custom timing sources and any still-missing final RGB analog-equivalent gates. |

## Implementation Order From Here

Do not continue editing `motion_shift_pixel()` or ROM nibble order unless this
audit proves a wiring error there. The next work should be:

1. Build explicit Sheet 4A `MOA`/`MOD` bus model around the existing
   `motion_ram`.
2. Implement the Sheet 4A latch/counter/control chain enough to produce named
   `MOHLD`, `MOHRD`, `MOHLC`, `MOHRC`, `MATCH`, and `MOFLIP`.
3. Replace the current abstract object scan state with the schematic
   counters/latches.
4. Make the Sheet 4B `74LS163A`/`93422`/`9T`/`9H` buffer path behavior-driving
   and remove the temporary `sprite_line0/1` visible path.
5. Replace the provisional `palette_index` priority expression in
   `rtl/cloak_core.sv` with the Sheet 4B final mux.

## Verification Rule

Before any new Verilog commit:

- Identify the exact audit row(s) being implemented.
- Name the schematic signals in the Verilog.
- State which shortcut is being removed.
- Run local smoke tests.
- Only ask for Quartus/MiSTer testing after a real schematic row changes.
