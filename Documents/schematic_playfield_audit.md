# Playfield / Master Sync Audit

Branch: `rewrite/schematic-4a-4b`

Sheets:

- `3A`: Sync Chain, Working RAM / Playfield RAM, rendered as
  `/tmp/cloak_playfield_hi/playfield_01.png`
- `3B`: Playfield, rendered as `/tmp/cloak_playfield_hi/playfield_02.png`
- `10A`: Master memory map, rendered as `/tmp/cloak_pages/page-019.png`

Status: `STARTED`

Purpose: verify the master timing and playfield pipeline before more video or
motion-object work. The blue text/title border fix proved this area is visible
on-screen, so further changes must be schematic-led.

Legend:

- `DONE`: structurally represented and verified.
- `PARTIAL`: functionally represented, but not net-for-net.
- `MISSING`: not represented.
- `VERIFY`: visible on schematic but needs further trace before coding.

## Sheet 3A: Sync Chain

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `6P` | `74LS86` | `4H`, `8H`, `16H`, `32H`, `64H`, `128H`, shared vertical/timing input | Generates inverted/delayed horizontal timing aliases `4H**`, `8H**`, `16H**`, `32H**`, `64H**`, `128H**` | active `h4ss..h128ss` aliases plus observational `u_6p_sync_xor_low`/`u_6p_sync_xor_high` | `PARTIAL` | LS86 boundaries now expose `h8ss_from_6p` through `h128ss_from_6p`. The shared phase input is still provisional (`sync_xor_common_from_6p`) until the custom timing/write block is traced. |
| `10E` | `74LS04` | output of `6P` gate to `4H**` | Inverter for one timing alias | active `h4ss` alias plus observational `u_10e_sync_4h_inverter` | `PARTIAL` | Inverter boundary now exposes `h4ss_from_10e_6p`, but active timing remains the stable direct alias until phase/polarity is verified. |
| `21/M` | custom timing/write device, marked `CUSTOM W/R 137321-111` | `PABD0..7`, `CUSTOMWR`, outputs `CUSH`, `CUSG`, `CUSF`, `CUSE`, `CUSD`, `CUSC`, `CUSB`, `CUSA`, `BVBLANK`, `B256H` | Master custom timing/write block | `u_21m_custom_timing_write` exposes the custom package pins plus `cusa_from_21m` through `cush_from_21m`; active `BVBLANK` and `B256H` now come from the package outputs | `PARTIAL` | Package boundary is behavior-driving for `BVBLANK/B256H`, but internal custom equations are not known. MAME's `custom_w` is empty and comments say this write is ignored, so the model still passes through counter-derived fallback timing until hardware traces or equations are found. |

## Sheet 3A: Working RAM / Playfield RAM

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `4/5H` | `74LS245` | `PABD0..7` to `PFD0..7`, `PABR/W`, `PARAM` through gate enable | CPU data bus buffer for playfield RAM | named `pfd_cpu_in` / `playfield_cpu_q` RAM port plus observational `u_45h_pabd_pfd_buffer` | `PARTIAL` | LS245 boundary now exposes `pfd_from_45h` and `pabd_from_45h` with `PABR/W` direction. Active RAM port still bypasses this until the `PARAM` enable gate chain and RAM arbitration are verified. |
| `4L/M` | `HM6116-2` | `PFA0..10`, `PFD0..7`, `CS`, `OE`, `WE` | 2K working/playfield RAM | active `cloak_tdp_ram #(.AW(10), .DW(8)) playfield_ram` plus observational `playfield_ram_4lm_observe` with `AW(11)` | `PARTIAL` | 2K schematic RAM boundary now exists with 11-bit `pfa_from_3n_3l_3m`, `pfd_from_45h`, and observational CS/WE. Active CPU/video playfield still uses the stable 1K compatibility RAM until arbitration and polarity are verified. |
| `7H` | `74LS74` | `B1H`, `B2H`, `BDEL2H`, `BDEL2H*` | Delays/qualifies the playfield RAM access timing | `u_7h_playfield_bdel2h_latch` exposes `bdel2h_from_7h` and `bdel2h_n_from_7h` | `PARTIAL` | Boundary is now modelled as D=`B2H`, CK=`B1H`. Its output selects only the observational `3N/3L/3M` PFA muxes; active dual-port RAM timing is unchanged. |
| `5F` | `74LS32` | `PARAM`, delayed timing, buffer enable nets | Playfield RAM buffer select glue | `u_5f_playfield_buffer_enable_or` drives observational `pfd_buffer_enable_n` | `PARTIAL` | Gate boundary is now named from the Sheet 3A crop. Active data path still bypasses the LS245 output until decode polarity is fully verified. |
| `4J`, `9F`, `8F`, `5H` | `74LS08`, `74LS08`, `74LS00`, `74LS02` gates | `BDEL2H`, `B1H`, `PARAM`, `PAWRITE`, `BWRITE`, `BL` | RAM write/select timing | `u_4j_playfield_ram_cs_and`, `u_9f_playfield_write_phase_and`, `u_5h_playfield_write_select_nor`, `u_8f_playfield_ram_we_nand` expose observational CS/WE nets | `PARTIAL` | Gate boundaries are represented, but active `playfield_ram` still uses `pa_write && param` until CS/OE/WE polarities and RAM arbitration are verified. |

## Sheet 3B: Playfield Address Generation

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `3N`, `3L`, `3M` | `74LS157` | `PABA0..10`, `8H`, `16H`, `32H`, `64H`, `128H**`, `CUSD/E/F/G/H`, outputs `PFA0..10` | Selects CPU address or video scan/timing address for playfield RAM | named `pfa_cpu`, `pfa_video`, `playfield_video_addr`, plus observational `u_3m_pfa_low_mux`, `u_3l_3m_pfa_mid_mux`, `u_3n_3l_pfa_high_mux` | `PARTIAL` | Three LS157 boundaries now expose `pfa_from_3n_3l_3m` and use `bdel2h_from_7h` as select. Active dual-port RAM still uses compatibility CPU/video addresses until the custom `CUS*` timing generator is modelled and the RAM arbitration is verified. |
| `11F` | `74LS74` | `B1H`, `B2H`, `B5M`, `LDF`, `LDNIB`, `NIBLOAD` | Generates byte/nibble load timing for playfield ROM/shift path | `u_11f_playfield_load_latch` exposes `pf_ldf_from_11f` and `pf_ldnib_from_11f`; visible `pbit` still uses compatibility nibble select | `PARTIAL` | 11F boundary is now present and clocked from `B5M`/`ce_5m`, with `pf_nibload_from_3f` on D. It is not yet behaviour-driving for visible pixels. |
| `3F`, `10D`, `10E` | `74LS08`, `74LS00`, `74LS04` | `B1H`, `B2H`, `B4H`, `B5M`, `NIBLOAD`, `BYTLOAD` | Playfield byte-load and nibble-load glue | `u_3f_playfield_nibload_and`, `u_10e_playfield_b4h_inverters`, `u_10d_playfield_bytload_nand` expose `pf_nibload_from_3f` and `pf_bytload_from_10d` | `PARTIAL` | Gate boundaries are represented. `pf_bytload_from_10d` is named but no longer treated as the LS194 clock; the LS194s clock from `B5M`/`ce_5m` as shown on Sheet 3B. |

## Sheet 3B: Playfield Character ROM And Pixel Path

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `4K` | `74LS273` | `PFD0..7`, outputs `PFP0..7` | Latches playfield RAM byte before character ROM addressing | named `pfp = playfield_video_q` | `PARTIAL` | RTL now instantiates `u_4k_playfield_latch` and exposes `pfp_from_4k`. Active character ROM addressing still uses the compatibility direct RAM path until `LDF/LDNIB/BYTLOAD` timing is verified. |
| `5N`, `5R` | `2532` ROMs | `PFP0..7`, `CUSA/B/C`, `4H**`, data `D0..7` | Playfield character graphics ROMs | `char_graphics` ROM, `char_video_addr` | `PARTIAL` | Character graphics storage is now split into two 4K `cloak_gfx_rom` instances, `char_graphics_5n` and `char_graphics_5r`, sharing the same 12-bit address. The active path still selects one compatibility byte with `char_video_addr[12]`. |
| `4P`, `4R`, `3P`, `3R` | `74LS194` | ROM data bits, `B5M`, `BLANK`, outputs `PBIT*` | Parallel-load/shift playfield pixel bits | `u_4p_pbit3_shift`, `u_4r_pbit2_shift`, `u_3p_pbit1_shift`, `u_3r_pbit0_shift` feed active `pbit` through `4N` when `USE_SCHEMATIC_PLAYFIELD_PIXEL=1` | `PARTIAL` | Four LS194 boundaries now expose `pbit_n_from_ls194` and `pbit_f_from_ls194`, clock from `pf_shift_clk_en`/`B5M`, use `pf_blank_clear_n` for active-low clear, and remain compared against the preserved `pbit_compat` reference. |
| `4N` | `74LS157` | `PBIT*N`, `PBIT*F`, `COCKTAIL`, outputs `PBIT0..3` | Selects normal/flipped playfield bit order for cocktail mode | `u_4n_playfield_cocktail_mux` exposes `pbit_from_4n`; active `pbit` now selects this schematic path by default | `PARTIAL` | Mux boundary now uses latched `cocktail_out`. `pbit_compat` preserves the former direct nibble path so comparison nets can still identify bit-order/phase mismatches. |
| `4/5F`, `4/5E` | `74LS00`, `74LS04` | `COCKTAIL`, `LDNIB`, bit-path mux control | Bit-order and load-control glue | `u_45e_playfield_cocktail_inverter` and `u_45f_playfield_shift_mode_nands` drive `pf_ls194_mode_from_45f` | `PARTIAL` | Verified against PDF index 60 / Sheet 3B: 4/5F pin 3 drives LS194 `S0` pin 9, and 4/5F pin 6 drives LS194 `S1` pin 10. The RTL now names those pins explicitly before forming `{S1,S0}` for the active schematic playfield pixel path. |

## Current RTL Mapping

Relevant code in `rtl/cloak_core.sv`:

- Raster counters: `hcnt`, `vcnt`; `hblank`, `vblank`, `hsync`, `vsync`;
  schematic aliases `b1h..b256h`, `b1v..b128v`, active `h4ss..h128ss`, and
  observational `6P`/`10E` outputs. `BVBLANK` and `B256H` are now routed
  through `u_21m_custom_timing_write`.
- Custom timing package: `u_21m_custom_timing_write` names `CUSA..CUSH`,
  `BVBLANK`, and `B256H`, but currently passes through counter-derived fallback
  timing because the Atari custom equations are not known.
- Playfield RAM: active `playfield_ram` is still the stable 1K compatibility
  RAM; observational Sheet 3A/3B boundaries now include `4/5H`, `7H`,
  `3N/3L/3M`, RAM control gates, and `playfield_ram_4lm_observe`.
- Character ROM: split `char_graphics_5n` and `char_graphics_5r` exist, but
  active lookup still selects a compatibility byte with `char_video_addr[12]`.
- Pixel path: active `pbit` now selects the Sheet 3B `4N` output by default
  through `USE_SCHEMATIC_PLAYFIELD_PIXEL`. The former direct nibble path remains
  as `pbit_compat` for comparison against `11F`, `3F/10D/10E`,
  `4P/4R/3P/3R`, `4N`, `4/5E`, `4/5F`, and blank clear.
- Final priority/color: `palette_index` selects sprite, bitmap, then playfield.

Simulation check after the 4/5F pin-order correction:

- `PF compare samples=11875 known=11875 now=1523 d1=11829 d2=1473 d3=742`
- `PF normal-end matches now=1523 d1=11829 d2=1473 d3=742`
- `PF flipped-end matches now=750 d1=1313 d2=2056 d3=751`

This confirms the schematic LS194 normal output is almost perfectly aligned to
the compatibility path delayed by one visible pixel sample. Active playfield
pixels now use the schematic `4N` output by default, with `pbit_compat` retained
as the old reference path.

## Important Findings

- The current RTL is not yet a 1:1 Sheet 3A/3B implementation.
- The current visible playfield is still behavioral, but many physical
  boundaries now exist in parallel as non-driving observation paths.
- The already-fixed blue text/title rectangles likely came from the ROM/nibble
  side of this path, but the schematic path still needs structural replacement
  before future pixel-phase fixes.
- Sheet 3A custom package outputs `CUSA..CUSH`, `BVBLANK`, and `B256H` now
  have explicit `21/M` boundary names. `BVBLANK/B256H` are behavior-driving,
  but still use counter-derived fallback timing inside the custom model. The
  loaded `sync_prom` in RTL corresponds to the Sheet 7A `82S129` vertical
  timing PROM, not this custom block.

## Next Implementation Candidates

Safe next steps:

1. Find or measure the Atari `137321-111` equations/truth table. Without that,
   keep `u_21m_custom_timing_write` on fallback timing.
2. Extend `sim/cloak_core_tb.sv` comparison coverage beyond the current smoke
   window so `pf_pbit_compare_*` can be evaluated over full frames.
3. Verify `BDEL2H`, `PARAM`, `PAWRITE`, RAM `CS/OE/WE`, and LS245 polarity
   before allowing `playfield_ram_4lm_observe` to replace active RAM.
4. Switch active playfield stages one at a time only after comparison nets show
   the schematic path is phase/polarity compatible.
