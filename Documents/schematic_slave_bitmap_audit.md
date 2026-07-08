# Slave CPU / Bitmap Audit

Branch: `rewrite/schematic-4a-4b`

Sheets:

- `6A`: Slave PCB Power Input, Clock, rendered as `/tmp/cloak_slave_hi/slave_01.png`
- `6B`: Slave Microprocessor, Slave Processing, Master/Slave Interconnect,
  rendered as `/tmp/cloak_slave_hi/slave_02.png`
- `7A`: Sync Chain, Slave Program ROM, Working RAM, Communication RAM,
  rendered as `/tmp/cloak_slave_hi/slave_03.png`
- `7B`: Bit Map Clock, Bit Map Write, rendered as
  `/tmp/cloak_slave_hi/slave_04.png`
- `8A`: Bit Map, rendered as `/tmp/cloak_slave_hi/slave_05.png`
- `8B`: Bit Map Output, rendered as `/tmp/cloak_slave_hi/slave_06.png`
- `10B`: Slave memory map, rendered as `/tmp/cloak_pages/page-020.png`

Status: `STARTED`

Purpose: map the slave CPU and bitmap subsystem before making further video
changes. This subsystem controls bitmap/background graphics and intersects with
final video priority, so it must be reviewed before claiming a 1:1 core.

Legend:

- `DONE`: structurally represented and verified.
- `PARTIAL`: functionally represented, but not net-for-net.
- `MISSING`: not represented.
- `VERIFY`: visible on schematic but needs further trace before coding.

## Sheet 6B: Slave Microprocessor / Slave Processing

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `7B/D` | `6502B` | `PBBA0..15`, `PBBD0..7`, `PBBR/W`, `IRQ`, `RESET`, `PHI0/PHI1/PHI2`, `READY`, `NMI`, `SO` | Slave CPU | `T65 slave_cpu` | `PARTIAL` | CPU exists, but exact phase clocks, READY, NMI/SO behavior, and discrete reset/IRQ path are simplified. |
| `1B`, `1C`, `3D`, `3E`, `5K` | `74LS244`, `74LS04` | CPU address lines to `PBBA*`, `PBBR/W`, timing/control aliases | Slave address/control bus buffers | direct `sa = sa24[15:0]`, `srw` | `PARTIAL` | Logical bus exists; LS244/LS04 structure and enables are collapsed. |
| `2F`, `3E` | `74LS245`, `74LS04` | CPU data `D0..D7` to `PBBD0..7`, `PBBR/W`, `PBBMEM` | Slave data bus transceiver | direct `sdi/sdo` mux | `PARTIAL` | Direction behavior exists through CPU DI/DO, not as a bus transceiver. |
| `2M`, `2L`, `4L`, `5M`, `5N`, `6M`, `6N`, `6H` | `74LS00`, `74LS08`, `74LS32`, `74LS139`, `74LS138`, `74LS02` | `ZERO`, `SUB`, `DECODE`, `PBRAM`, `PBROM*`, `PBCMRAM`, `CUSTOMWR`, `PBIRQRES`, `LDX`, `LDY`, `INV` | Slave address decode and custom/write strobes | named wires `pbram`, `pbcmram`, `pbmem`, `pbirqres`, `s_custom_write_cs`, active-low `ldx_decode_n`, `ldy_decode_n`, positive aliases `ldx`, `ldy`, `drawren`, `swap` | `PARTIAL` | Main decode names exist behaviorally. Sheet 6B `6H` active-low `LDX/LDY` polarity is now represented; exact full decoder IC structure and `CUSTOMWR` behavior remain partial. |
| `4M`, `6L`, `7L`, `5L`, `5M` | `74LS74`, `74LS109A`, `74LS00`, gates | `VBLANK`, `PBIRQRES`, `DRAM`, `DRAWREN`, `BUFSEL`, `PBROM*` | IRQ/reset, bitmap-buffer and ROM-enable timing | `slave_irq_n`, `bitmap_select`, `bitmap_clear`, `bufsel`, `clrram`, active-low `dram_decode_n` | `PARTIAL` | Sheet 6B `5M` active-low `DRAM` decode is represented for the LS169 enable path. Other latch timing remains functional/provisional. |
| Master/slave interconnect buffers | `74LS244` blocks | `E1H`, `E2H`, `E4H`, `E8H`, `EPB0`, `EPBR/W`, `EPBCMRAM`, `E16H`, `E32H`, `E256H`, `EVBLANK`, `ESM`, `BRES` | Timing/control nets crossing from master/slave harness | named `e1h`, `e2h`, `e4h`, `e8h`, `e16h`, `e32h`, `e256h`, `evblank`, `ehblank` aliases | `PARTIAL` | Timing aliases are explicit. `EVBLANK/E256H` now inherit the Sheet 3A `21/M` package outputs, whose internals still use counter-derived fallback timing. |

## Sheet 7A: Slave Sync, ROM, RAM, Communication RAM

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `8K`, `8J`, `4C`, `5C`, `3M`, `2N` | `74LS109`, `74LS163`, `74LS160`, `74LS163A` counters | `10MHZ`, `5MHZ`, `1H`, `2H`, `4H`, `8H`, `16H`, `32H`, `64H`, `128H`, `256H`, `HSYNC`, `VSYNC`, `HBLANK`, `VBLANK` | Slave sync/timing chain | named `b1h..b256h`, `counter_*`, `hblank_from_3c`, active `hblank/vblank/hsync/vsync`, and observational `u_3b_*`/`u_3c_hblank_256h_latch` | `PARTIAL` | Current visible timing still uses fallback counters. The Sheet 7A `3B/3C` HBLANK LS74 chain is now modeled observationally: first `3B` D=`2H`, CK=`1H`, CLR=`4H`; second `3B` D=first Q, CK=`5MHz`; `3C` D=`256H`, CK=second `3B` Q, with Q/Q* exposed for phase comparison. |
| `4D`, `4B` | `74LS86`, `74LS04` | `HSYNC`, `VSYNC`, `/VSYNC`, `COMPSYNC`, output `VSYNC` | Combines sync pulses and buffers sync outputs | `u_4d_composite_sync_xor`, `u_4b_sync_output_inverters`, `u_4d_composite_sync_xor_from_4n`, `u_4b_sync_output_inverters_from_4n`, `compsync_from_4b`, `vsync_from_4b`, `compsync_from_4b_4n`, `vsync_from_4b_4n` | `PARTIAL` | Observational gate boundaries are present. The active-safe path still uses fallback `HSYNC/VSYNC`; the parallel schematic path now feeds `4D/4B` from the physical `4N` `VSYNC` and `/VSYNC` labels. These outputs are not yet wired to MiSTer video output. |
| `3N` | `82S129` vertical timing PROM | address inputs `1V`, `2V`, `4V`, `8V`, `16V`, `32V`, `64V`, `128V`; outputs into LS175/LS74 timing chain | Vertical timing decode before registered sync/blank outputs | named `vertical_prom_addr`, `vertical_prom_data`, and `vertical_prom_o1..o4` | `PARTIAL` | PROM ROM is loaded and has explicit boundary names. Outputs feed the pin-oriented `4N` register-stage names, but are not yet used to drive visible `vsync/vblank/hblank`. |
| `4N` and adjacent sync latches | `74LS175` / `74LS74` | PROM outputs, `256H`, `/VSYNC`, `VSYNC`, `/VBLANK`, `VBLANK`, related complements | Registers vertical timing PROM outputs | `sync_4n_q1..q4`, pin aliases, `vsync_n_from_4n`, `vsync_from_4n`, `vblank_n_from_4n`, `vblank_from_4n` | `PARTIAL` | `4N` is now represented as a physical 74LS175 boundary: PROM O4/O3/O2/O1 feed D pins 4/5/12/13. The visible `/VSYNC`, `VSYNC`, `/VBLANK`, and `VBLANK` labels are exposed from the corresponding Q or /Q pins. These outputs remain observational until clock phase is proven safe for active video. |
| `1E/F`, `1F/H`, `1J`, `1K`, `1L`, `1M`, `1N` | `2764` ROMs | `PBBA0..12`, `PBROM0..6`, `BD0..7` | Slave program ROM banks | `slave_rom[0:16'hDFFF]` | `PARTIAL` | ROM content maps functionally; individual chip selects and physical bank structure are collapsed. |
| `2E` | `74LS245` | ROM data to `BD0..7`, `PBBR/W` | Slave ROM data bus buffer | `slave_rom_q` into `sdi` | `PARTIAL` | Functional read path exists, no LS245 structure. |
| Working RAM block | `6116-2` | `PBBA0..10`, data bus, `PBRAM`, `PBWRITE` | Slave local RAM | `slave_work_ram` 2K | `PARTIAL` | Capacity matches broadly; exact select/write timing not reproduced. |
| Communication RAM interconnect | `74LS245`, shared connector nets `EPBBD*` | `PBBD0..7`, `EPBBD0..7`, `PBCMRAM`, `PBBR/W` | Slave side of master/slave communication RAM | `communication_ram` slave port | `PARTIAL` | Functional dual-port RAM replaces original bus/buffer arbitration. |

## Sheet 7B: Bitmap Clock / Bitmap Write

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `9N`, `8N`, `9K` | `74LS74` | `RAS`, `CAS`, `SELROW`, `ROW`, `10MHZ`, `5MHZ` | DRAM row/column timing generator | provisional `ras_n`, `cas_n`, `row`, `selrow` aliases | `PARTIAL` | Original bitmap memory is DRAM-like; current RAM still does not use RAS/CAS timing. These names are current timing placeholders, not final gate-level equations. |
| `8L`, `8M`, `9L`, `7N`, `6N` | `74LS32`, `74LS00`, gates | `PBWRITE`, `DRAWREN`, `BUFSEL`, `CLRRAM`, `VBLANK`, `HBLANK` | Bitmap write/clear/buffer select timing | `bmp_write`, `bitmap_clear`, `bitmap_select` | `PARTIAL` | Behavior exists, but gate-level timing and blanking dependence are simplified. |
| `8J`, `9J`, `8H`, `9H` | `74LS02` | `DR0..DR3`, `WRB0..3`, `WRA0..3` | Per-plane write enables for A/B bitmap banks | named `wra0..3`, `wrb0..3`, `wra`, `wrb` | `PARTIAL` | Current design still writes one 4-bit word into the selected FPGA bank. `wra/wrb` are full-nibble current-behavior aliases, not final per-plane gate equations. |
| `6H` | `74LS139` | `X0/X1`, `DR0..DR3` | Decode write lane/plane | named `dr_n`, `dr0_n..dr3_n` from `sa[1:0]` | `PARTIAL` | Decoder boundary exists, but decoded lanes are not yet used to gate individual bitmap planes. |

## Sheet 8A: Bitmap RAM / Address Generation

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `6J`, `4K`, `4F`, `5F`, `3J`, `3A`, `4H`, `4J` and related `74153` muxes | `74LS153` | `CUSA..CUSH`, `4H*`, `8H*`, `16H*`, `32H*`, `64H*`, `128H*`, `X*`, `Y*`, outputs `DRADR0..7` | Bitmap DRAM multiplexed address generation | named `dradr_cpu_row`, `dradr_cpu_col`, `dradr_video_row`, `dradr_video_col`, `dradr_cpu_mux`, `dradr_video_mux`, `dradr_mux`, plus flat `dradr_cpu`/`dradr_video` | `PARTIAL` | Row/column boundary names now exist, but current storage still uses flat 16-bit FPGA addresses rather than true RAS/CAS-multiplexed DRAM addressing. |
| Large `4116` matrix | `4116` DRAMs | `DRA/DRB` data, `DRADR*`, `RAS`, `CAS`, `WRA*`, `WRB*` | Bitmap storage banks/planes | `bitmap0` and `bitmap1` `cloak_dpram #(.AW(16), .DW(4))`, named `dra_cpu_in`, `drb_cpu_in`, `dra_video`, `drb_video`, `wra`, `wrb` | `PARTIAL` | Functional equivalent storage exists, but not DRAM timing or physical bit-plane structure. |
| `5H`, `4H`, `5J`, `4J` | `74LS169` counters | `LDX`, `LDY`, `PBBA*`, `DRAM`, `INV`, `X0`, `X1`, X/Y nets | Bitmap X/Y coordinate counters / auto inc-dec | four `cloak_74ls169` instances: `u_5h_x_low`, `u_4h_x_high`, `u_5j_y_low`, `u_4j_y_high`; per-chip pin aliases `u_5h_*`, `u_4h_*`, `u_5j_*`, `u_4j_*` for `ld_n`, `enp_n`, `ent_n`, `ud`, `p`, `q`, `tc`; `ls169_counter_clk_en` models the 3E LS04 inverted `PBBPHI2` package clock as a synchronous enable; `dram_decode_n` models Sheet 6B active-low `DRAM` | `PARTIAL` | Counter state now lives inside explicit LS169-style devices with per-package pin aliases. Remaining work: final trace of the write/load timing and low-counter enables. |
| `7H`, other `74LS157` blocks | `74LS157` | `PBBD*`, `DRAI/DRBI*`, `BUFSEL`, `CLRRAM` | CPU data to bitmap/clear muxing | writes `sdo[3:0]`, clear writes zero | `PARTIAL` | Functional write/clear exists, not structural. |

### Sheet 8A: LS169 Pin Verification Table

This table is the working checklist before marking the X/Y counter block
`DONE`. `RTL net` means the pin exists in the Verilog with a per-chip alias.
`Trace status` states whether the exact schematic equation has been verified
from the scan.

| Chip | Role | Pin class | RTL net | Trace status | Notes |
| --- | --- | --- | --- | --- | --- |
| `5H` | X low nibble | parallel inputs | `u_5h_p = xl_counter_d` | `MATCH` | Sheet 8A crop shows PBBD0..3 feeding A..D; RTL maps `sdo[3:0]` to this package. |
| `5H` | X low nibble | outputs | `u_5h_q`, `u_5h_tc` | `PARTIAL` | Output feeds `X0..X3` through `xl_counter_q`; ripple terminal count exists. |
| `5H` | X low nibble | load | `u_5h_ld_n` | `PARTIAL` | Sheet 8A shows common active-low `LDX`; RTL now exposes `ldx_decode_n` and derives the write-qualified `ldx_counter_load_n`. Exact upstream custom-write gate still needs final trace. |
| `5H` | X low nibble | enables | `u_5h_enp_n = dram_decode_n`, `u_5h_ent_n = pbba0_graph` | `PARTIAL` | Sheet 6B `5M` forms active-low `DRAM = NAND(DECODE, NAND(PBBA0,PBBA1))`; RTL uses this through `dram_decode_n`. |
| `5H` | X low nibble | direction | `u_5h_ud` | `PARTIAL` | Crop shows `U/D` fed by `PBBA2`; RTL aliases `PBBA2` as `graph_inv`. Exact semantic name still needs full trace. |
| `4H` | X high nibble | parallel inputs | `u_4h_p = xh_counter_d` | `MATCH` | Sheet 8A crop shows PBBD4..7 feeding A..D; RTL maps `sdo[7:4]` to this package. |
| `4H` | X high nibble | outputs | `u_4h_q`, `u_4h_tc` | `PARTIAL` | Output feeds `X4..X7`; high-stage count enable currently comes from low-stage terminal count. |
| `4H` | X high nibble | load | `u_4h_ld_n` | `PARTIAL` | Shared with `5H` load in RTL. |
| `4H` | X high nibble | enables | `u_4h_enp_n = !dram_counter_access`, `u_4h_ent_n = xl_counter_tc_n` | `MATCH` | Sheet 8A crop shows `5H TC` feeding the high X counter enable path while `DRAM` feeds the other enable. |
| `4H` | X high nibble | direction | `u_4h_ud` | `PARTIAL` | Currently same direction as low X stage. |
| `5J` | Y low nibble | parallel inputs | `u_5j_p = yl_counter_d` | `MATCH` | Sheet 8A crop shows PBBD0..3 feeding A..D; RTL maps `sdo[3:0]` to this package. |
| `5J` | Y low nibble | outputs | `u_5j_q`, `u_5j_tc` | `PARTIAL` | Output feeds `Y0..Y3`; ripple terminal count exists. |
| `5J` | Y low nibble | load | `u_5j_ld_n` | `PARTIAL` | Sheet 8A shows common active-low `LDY`; RTL now exposes `ldy_decode_n` and derives the write-qualified `ldy_counter_load_n`. Exact upstream custom-write gate still needs final trace. |
| `5J` | Y low nibble | enables | `u_5j_enp_n = dram_decode_n`, `u_5j_ent_n = pbba1_graph` | `PARTIAL` | Mirrors the visible X-counter structure using `PBBA1` and active-low `DRAM`; low Y enable destination still needs direct crop confirmation. |
| `5J` | Y low nibble | direction | `u_5j_ud = inv_graph` | `PARTIAL` | Sheet 8A labels the Y LS169 `U/D` input as `INV`; Sheet 6B forms `INV` with 6M LS02 `NOR(PBBA0, PBBA1)` feeding 5N LS32 OR with `PBBA2`. |
| `4J` | Y high nibble | parallel inputs | `u_4j_p = yh_counter_d` | `MATCH` | Sheet 8A crop shows PBBD4..7 feeding A..D; RTL maps `sdo[7:4]` to this package. |
| `4J` | Y high nibble | outputs | `u_4j_q`, `u_4j_tc` | `PARTIAL` | Output feeds `Y4..Y7`; high-stage count enable currently comes from low-stage terminal count. |
| `4J` | Y high nibble | load | `u_4j_ld_n` | `PARTIAL` | Shared with `5J` load in RTL. |
| `4J` | Y high nibble | enables | `u_4j_enp_n = !dram_counter_access`, `u_4j_ent_n = yl_counter_tc_n` | `MATCH` | Sheet 8A crop shows `5J TC` feeding the high Y counter enable path while `DRAM` feeds the other enable. |
| `4J` | Y high nibble | direction | `u_4j_ud = inv_graph` | `PARTIAL` | Same `INV` net as the low Y stage. Remaining work is to verify the exact physical route from Sheet 6B to Sheet 8A, not the local boolean expression. |

## Sheet 8B: Bitmap Output

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `6B`, `6C`, `6F` | `74LS157` | `DRA*`, `DRB*`, `SELB`, `BUFSEL`, `X0/X1` | Selects bitmap bank/bit groups for output | `bitmap_select ? bmp0_vid_q : bmp1_vid_q` | `PARTIAL` | Functional bank select exists, but not the full mux tree. |
| `2J` | `74LS374` | selected DRAM bits to `PBBD0..7`, clocked by timing/gates | Bitmap read latch back to slave data bus | `graph_dout` | `PARTIAL` | CPU readback exists as a simple mux; latch timing is absent. |
| `6A`, `6D`, `6E`, `7J` | `74LS157` | `DRA/DRB` bits, `MAP*F`, `MAP*N`, `COCKTAIL`, `BUFSEL` | Bitmap pixel bit selection / cocktail normal-flipped paths | named `bmap` direct nibble | `MISSING/PARTIAL` | Output bit ordering and cocktail mode are not structurally represented. |
| `5A`, `5D`, `5E` | `74LS194` | `MAP0..2`, `MAP*N/F`, `5MHZ`, `S0/S1` | Bitmap output shift/register pipeline | direct `bmp*_vid_q` sampling | `MISSING/PARTIAL` | Current bitmap output is direct RAM lookup, no LS194 pixel pipeline. |
| `6K`, `6L` and gates | `74LS00`, `74LS74`, `74LS04` | `5MHZ`, `ECOCKTAIL`, `S0/S1`, pixel-shift controls | Bitmap output shift/control timing | none named | `MISSING/PARTIAL` | May affect pixel phase and cocktail orientation. |

## Current RTL Mapping

Relevant code in `rtl/cloak_core.sv`:

- Slave CPU: `slave_cpu`.
- Vertical timing PROM: `sync_prom` loaded from `136023-116.3n`, exposed as
  `vertical_prom_addr`, `vertical_prom_data`, and `vertical_prom_o1..o4`
  outputs.
- Provisional vertical timing register stage: physical `4N` aliases
  `sync_4n_q1..q4`, `sync_4n_q*_pin*`, `vsync_n_from_4n`,
  `vsync_from_4n`, `vblank_n_from_4n`, and `vblank_from_4n`, not yet driving
  active video.
- Active sync/blank selector boundary: `counter_hblank`, `counter_vblank`,
  `counter_hsync_n`, `counter_vsync_n`, `hblank_from_3c`, test-proven
  frame-origin aliases `prom_frame_origin_vsync`,
  `prom_frame_origin_vsync_n`, `prom_frame_origin_compsync`, plus
  `active_hblank`, `active_vblank`, `active_hsync_n`, and `active_vsync_n`.
  Observational HBLANK latch chain: `hblank_3b_first_q`,
  `hblank_3b_second_q`, `hblank_from_3c_latched`,
  `hblank_n_from_3c_latched`.
  Observational sync gates: fallback-fed `sync_4d_xor_y`, `sync_4b_inv_y`,
  `compsync_from_4b`, `vsync_from_4b`, and parallel 4N-fed
  `sync_4d_xor_4n_y`, `sync_4b_inv_4n_y`, `compsync_from_4b_4n`,
  `vsync_from_4b_4n`.
- Master/slave timing interconnect aliases: `e1h`, `e2h`, `e4h`, `e8h`,
  `e16h`, `e32h`, `e256h`, `evblank`, `ehblank`.
- Slave decode: `s_local_cs`, `s_shared_cs`, `s_graph_cs`, `s_rom_cs`, plus
  schematic aliases `pbram`, `pbcmram`, `pbmem`, `pbirqres`,
  `s_custom_write_cs`, `ldx`, `ldy`, `drawren`, and `swap`.
- Slave memories: `slave_rom`, `slave_work_ram`, `communication_ram` slave port.
- Bitmap registers/control: `bitmap_select`, `bitmap_clear`, `clear_addr`,
  reconstructed `bitmap_x`, `bitmap_y`, four `cloak_74ls169` X/Y counter
  instances, per-chip LS169 pin aliases `u_5h_*`, `u_4h_*`, `u_5j_*`,
  `u_4j_*`, plus Sheet 8A counter aliases `x_counter_*`, `y_counter_*`,
  `graph_x0`, `graph_x1`, and `graph_inv`.
- Bitmap storage: `bitmap0`, `bitmap1` dual-port RAMs with named
  `dradr_cpu_row`, `dradr_cpu_col`, `dradr_video_row`, `dradr_video_col`,
  `dradr_cpu_mux`, `dradr_video_mux`, `dradr_mux`, flat `dradr_cpu`,
  flat `dradr_video`, `dra_cpu_in`, `drb_cpu_in`, `ras_n`, `cas_n`, `row`,
  `selrow`, `dr0_n..dr3_n`, `wra0..3`, `wrb0..3`, `wra`, `wrb`.
- Bitmap output: `dra_video`, `drb_video`, `bmap`, final
  `palette_index` bitmap branch.

## Important Findings

- The slave/bitmap subsystem is functional but not a 1:1 schematic
  implementation.
- The Sheet 7A vertical timing PROM is now represented at the ROM boundary and
  through provisional registered output names. The exact phase/polarity is still
  not verified, so active video still uses the stable behavioral counters.
- The active sync/blank outputs now pass through named selector wires. `HBLANK`
  has a Sheet 7A `3C` endpoint name in the active path, and the physical
  `3B/3C` LS74 latch chain exists as an observational path for phase/polarity
  comparison before any behavior-driving switch.
- Current full-frame smoke-test result for the observational HBLANK chain:
  `HBLANK 3B/3C latch compare known=76158 q=60927 qn=15231`.
  The localized diagnostics show the apparent partial match is not a valid
  alternate polarity:
  `HBLANK 3B/3C transitions first=0 second=0 rise=0 q=0 qn=0` and
  `HBLANK 3B/3C high samples first=0 second=0 q=0 qn=83839`.
  This means the current first `3B` transcription never toggles, so the second
  `3B` and `3C` never receive a useful clock. The Sheet 7A crop still shows the
  apparent pins `D=2H`, `CK=1H`, `CLR=4H`, but the digital model of that path is
  incomplete or using the wrong effective edge/polarity. It must remain
  non-driving and be re-traced before active `HBLANK` can move off the fallback
  counter endpoint.
- Current full-frame smoke-test result for the observational sync gates:
  `Sync 4B/4D gate compare known=83839 vsync=83839 compsync=83839`. This
  confirms the modeled `4D` XOR and `4B` inverter equations are internally
  consistent with the current fallback sync sources.
- Current full-frame smoke-test result for the parallel `4N`-fed output gates
  with real `136023-116.3n` PROM loaded:
  `Sync 4B/4D from 4N compare known=76158 vsync=75456 compsync=75456`.
  The mismatch span is localized:
  `Sync 4B/4D from 4N mismatch span vsync=702 first=257,259 last=318,261 compsync=702 first=257,259 last=318,261`.
  When compared against a test-only frame-origin expectation using that physical
  end-of-frame interval, the result is exact:
  `Sync 4B/4D from 4N frame-origin compare known=76158 vsync=76158 compsync=76158`.
  The frame-origin expectation now has named RTL aliases
  `prom_frame_origin_vsync`, `prom_frame_origin_vsync_n`, and
  `prom_frame_origin_compsync`. This proves the modeled schematic
  `4N -> 4D/4B` sync wiring is correct under the PROM/frame-origin convention.
  It should remain non-driving until active video timing is migrated to that
  frame origin deliberately.
- Current full-frame smoke-test result with real `136023-116.3n` PROM loaded
  after physical `4N` pin mapping:
  `PROM 3N/4N timing compare known=76158 vsync_q=75456 vsync_qn=702 vblank_q=76095 vblank_qn=63 hblank_q=60927 hblank_qn=15231 b256_q=60927 b256_qn=15231`
  and
  `4N label compare known=76158 vsync=75456 vsync_n=75456 vblank=76095 vblank_n=76095`.
  This is strong evidence that the visible `4N` `VSYNC/VBLANK` labels are now
  mapped to the correct LS175 output pins, but the PROM chain still remains
  non-driving until the remaining horizontal and clock-phase relationships are
  fully reconciled.
- The original bitmap hardware is DRAM-bank and bit-plane based, with explicit
  RAS/CAS, row/column muxing, write-enable plane strobes, LS169 X/Y counters,
  and LS194 output shifting. Current RTL replaces this with FPGA-friendly RAM and
  behavioral address math.
- Sheet 7B bitmap clock/write names now exist, but they are not yet a true DRAM
  implementation. The next bitmap work must replace placeholder `RAS/CAS` and
  full-nibble `WRA/WRB` enables with the actual gate equations.
- Sheet 8A X/Y counter state is now held by four explicit `cloak_74ls169`
  instances, and the old offset table has been replaced by explicit
  load/count/direction pin wiring. Per-package pin aliases are now exposed for
  `5H`, `4H`, `5J`, and `4J`; the next step is checking those aliases against
  the exact schematic pins before changing behavior.
- LS169 `TC` is now modeled as an active-low ripple output qualified by the
  active enable pins, and the high X/Y nibbles are enabled from the low-nibble
  ripple outputs.
- Sheet 8A DRAM address row/column boundary names now exist. The next bitmap RAM
  step is replacing the flat FPGA address substitute with the traced 74LS153
  row/column mux equations only after `RAS`, `CAS`, `ROW`, and `SELROW` are
  verified.
- This does not automatically mean the current visual bug is in bitmap logic,
  but it means bitmap timing and output priority must be treated as provisional.
- The slave custom write at `1400` now has a named decode wire, but behavior
  remains open from the memory map audit.
- Player/cocktail paths appear in bitmap output as well as playfield/input, so
  cocktail support cannot be fixed in only one module.

## Next Implementation Candidates

1. Trace the real `SELROW`, `ROW`, `RAS`, `CAS` equations before adding them to
   RTL, so we do not create misleading placeholder timing.
2. Replace `adjust_bitmap()` magic offsets with named schematic operations from
   `LDX`, `LDY`, `INV`, and the LS169 counter direction/load controls.
3. Replace the provisional `DRA/DRB/BMAP` aliases with explicit bitmap output
   mux/latch names before changing pixel priority or
   bit ordering.
4. Only after the named foundation is in place, compare the bitmap output phase
   against MAME/MiSTer screenshots.
