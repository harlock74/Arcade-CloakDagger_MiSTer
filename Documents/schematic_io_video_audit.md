# Inputs / RGB / Video Output Audit

Branch: `rewrite/schematic-4a-4b`

Sheets:

- `5A`: Inputs, RGB Output, rendered as `/tmp/cloak_io_hi/io_5a.png`
- `4B`: Motion Object Buffers, Video, rendered as `/tmp/cloak_hi/motion_sheet4b.png`
- `10C`: Main Wiring Diagram / Conversion Kit, rendered as
  `/tmp/cloak_pages/page-021.png`

Status: `STARTED`

Purpose: verify player input mapping and the final digital color/output path.
Analog drive values are intentionally ignored except where resistor networks show
RGB bit significance.

Legend:

- `DONE`: structurally represented and verified.
- `PARTIAL`: functionally represented, but not net-for-net.
- `MISSING`: not represented.
- `VERIFY`: visible on schematic but needs further trace before coding.

## Sheet 5A: Input Buffers

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `9R` | `74LS244` | `FIRE1`, `FIRE2`, `COIN AUX`, `COCKTAIL`, `COIN R`, `COIN L`, `SELF TEST`, `BVBLANK`, outputs `PABD0..7`, enable `IN3` | Main input port 3 read buffer | `u_9r_in3_system_buffer`, `system_inputs_to_9r`, selected by `in3` at `16'h2400` | `PARTIAL` | Sheet 5A/MAME byte order is now applied: `PABD7..0 = FIRE1, FIRE2, COIN AUX, COCKTAIL, COIN R, COIN L, SELF TEST, BVBLANK`. The MiSTer wrapper currently ties cocktail inactive. |
| `9P` | `74LS244` | Cocktail-version `PL2*` lines, outputs into `PABD*`, enable `IN2` | Player 2/cocktail input read buffer | `u_9p_in2_player2_buffer`, `pl2_inputs_to_9p`, selected by `in2` at `16'h2200` | `PARTIAL` | Player 2 now reaches the PABD read path through an LS244 instance. Exact cocktail cabinet bit order still needs pin-level verification. |
| `9N` | `74LS244` | `PL1LL`, `PL1LR`, `PL1LU`, `PL1LD`, `PL1RL`, `PL1RR`, `PL1RU`, `PL1RD`, enable `IN1` | Player 1 movement/fire-direction input read buffer | `u_9n_in1_player1_buffer`, `pl1_inputs_to_9n`, selected by `in1` at `16'h2000` | `PARTIAL` | Sheet 5A/MAME byte order is now applied: `PABD7..0 = LL, LR, LU, LD, RL, RR, RU, RD`. Remaining work is physical cabinet/cocktail verification. |
| J20 input harness | connector/passive pullups | `FIRE1`, `FIRE2`, `COIN*`, `SELF TEST`, `PL1*`, `PL2*`, `COCKTAIL` | Physical control inputs | MiSTer top-level buttons/joystick | `PARTIAL` | Harness names should be preserved in RTL comments/wires when controls are cleaned up. |

## Sheet 5A: Color RAM And Digital RGB Path

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `9L/M` | color RAM/PROM block, marked `82519`/similar on scan | `COLA0..5`, `PABA6`, `PABD0..7`, outputs `O0..O8`, `CE`, `WE` | 64-entry by 9-bit color RAM | `palette_ram[0:63]` stores `{ma[6], mdo}` | `PARTIAL` | Functional shape matches: 6-bit color address and 9-bit output. Exact part type/pin names need confirmation from clearer scan. |
| `8D` | `74LS32` | `COLRAM`, `PAWRITE` | Color RAM write enable glue | `m_palette_cs` write | `PARTIAL` | RTL now names `colram_write_from_8d = PAWRITE && COLRAM` and uses it for palette writes. Exact gate polarity remains to be pin-verified. |
| `10L`, `10K`, `10J` | `74LS174` | color RAM output bits, `B5M`, `BLANK`, outputs toward `CR*`/RGB drive | Registers red, green, blue digital color bits and gates blanking | `u_10l_10k_color_latch_low` and `u_10j_color_latch_high` drive visible `rgb_bits` when `USE_SCHEMATIC_COLOR_LATCH=1` | `PARTIAL` | RTL now latches inverted color RAM outputs through explicit LS174 packages and uses the latched output for visible RGB by default. The old combinational path remains as `rgb_bits_compat`. |
| `4J` | `74LS08` | `HBLANK`, `BVBLANK`, `BLANK` | Generates combined video blanking | `u_4j_video_blank_and` drives `blank_n_from_4j`, which clears the color latches | `PARTIAL` | RTL now models the active-low blank gate explicitly: active-low `HBLANK` and active-low `BVBLANK` feed the LS08. `HBLANK` routes through the Sheet 7A `3C` endpoint, with the physical `3B/3C` latch chain present as an observational phase path; `BVBLANK` routes through Sheet 3A `21/M`. Both active sources still use fallback counter timing internally. |
| RGB output drivers | `2N3904`, diodes/resistor networks, inductors | latched RGB bits to `RED`, `GREEN`, `BLUE` | Analog output weighting/drive | 8-bit MiSTer RGB expansion from 3-bit channels | `PARTIAL` | Analog values are intentionally not copied. Digital bit significance should be preserved. |

## Current RTL Mapping

Relevant code in `rtl/cloak_core.sv`:

- Inputs: module inputs `joystick_0`, `joystick_1`, `fire1`, `fire2`,
  `coin_r`, `coin_l`, `coin_aux`, `cocktail`, `start1`, `start2`,
  `self_test`, `dips`.
- Input mapping: `in1/in2/in3`, `pl1_inputs_to_9n`,
  `pl2_inputs_to_9p`, `system_inputs_to_9r`, and LS244 instances
  `u_9n_in1_player1_buffer`, `u_9p_in2_player2_buffer`,
  `u_9r_in3_system_buffer`.
- POKEY reads: `pokey1` uses `starts`; `pokey2` uses `dips`.
- Palette writes: `m_palette_cs` stores `{ma[6], mdo}` in `palette_ram`.
- RGB output: `palette_index`, `palette_word`, `rgb_bits`, `pr/pg/pb`,
  `red/green/blue`.

## Important Findings

- The input side now has explicit Sheet 5A `IN1/IN2/IN3` LS244 read-buffer
  packages. The `9N` player-1 and mirrored `9P` player-2 bytes now follow the
  visible schematic order into `PABD7..0` and MAME's `P1` definition:
  left-stick `L/R/U/D` in bits `7..4`, right-stick `L/R/U/D` in bits `3..0`.
  The `9R` system byte now has separate named fire, coin, cocktail, self-test,
  and vblank inputs in Sheet 5A/MAME order. Remaining work is deciding whether
  to expose cocktail mode in the MiSTer menu and then tracing all cocktail video
  paths before enabling it.
- The RGB color RAM shape is close to the schematic: 64 addresses and 9 output
  bits. The output latch stage is now present and behavior-driving.
- Final blanking now uses Sheet 7A `3C` `HBLANK` plus Sheet 3A `21/M`
  `BVBLANK` into the Sheet 5A `4J` LS08 active-low `BLANK` gate. Both active
  sources are routed through named schematic endpoints while their internals
  still use fallback counter timing.
- For MiSTer output we should not reproduce analog transistor/resistor networks,
  but we should reproduce the digital latch/blank/color-bit ordering before
  treating video timing as 1:1.

## Next Implementation Candidates

1. Decide whether to expose `COCKTAIL` as a MiSTer menu option; do not enable
   it before playfield and bitmap cocktail paths are fully verified.
2. Compare the observational `3B/3C` HBLANK latch phase against the fallback
   over longer windows, then decide whether the `4B/4D` sync gate outputs
   should remain debug-only or feed any MiSTer-visible composite/sync path.
3. Cross-check these RGB/color nets with Sheet 4B final video priority before
   changing sprite/playfield/bitmap priority.
