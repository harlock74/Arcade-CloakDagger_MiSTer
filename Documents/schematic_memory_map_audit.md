# Cloak & Dagger Memory Map Audit

Branch: `rewrite/schematic-4a-4b`

Sources:

- Master memory map: rendered `page-019`, schematic sheet `10A`.
- Slave memory map: rendered `page-020`, schematic sheet `10B`.
- Cross-reference: `Documents/cloak_mame.cpp`.
- Current RTL: `rtl/cloak_core.sv`.

Purpose: verify address decoding before deeper per-sheet implementation. This
is not a replacement for the detailed logic audits of Sheets 2A/2B/6B/7A, but
it defines the externally visible decode each logic sheet must satisfy.

## Master CPU Map

| Address | Schematic Function | Current RTL Decode | Status | Notes |
| --- | --- | --- | --- | --- |
| `0000-03FF` | Working RAM | `m_main_ram_cs = ma < 0400` | `PARTIAL` | Functional RAM present; exact Sheet 2A/2B timing not audited. |
| `0400-07FF` | Playfield RAM | `m_play_cs = 0400-07FF` | `PARTIAL` | Used for CPU and video playfield access; Sheet 3A/3B audit pending. |
| `0800-0FFF` | Communication RAM | `m_shared_cs = 0800-0FFF` | `PARTIAL` | Functional shared RAM; arbitration/interconnect not audited. |
| `1000-100F` | Custom I/O 1 / POKEY 1 | `m_pokey1_cs = 1000-100F` | `PARTIAL` | RTL uses `pokey_compat`; exact input port wiring pending Sheet 5A audit. |
| `1008` | Start 2 / Start 1 inputs | via POKEY allpot/start mapping | `PARTIAL` | Needs Sheet 5A input audit. |
| `1800-180F` | Custom I/O 2 / POKEY 2 | `m_pokey2_cs = 1800-180F` | `PARTIAL` | RTL uses `pokey_compat`; DIP/audio behavior pending Sheet 5B audit. |
| `2000` | Player 1 joysticks | `in1` enables Sheet 5A `9N` LS244 | `PARTIAL` | `PABD7..0 = LL, LR, LU, LD, RL, RR, RU, RD`, cross-checked against MAME `P1`. |
| `2200` | Player 2 joysticks | `in2` enables Sheet 5A `9P` LS244 | `PARTIAL` | Player 2 byte now has the same named LS244 path; MAME marks this port unused for the upright set. |
| `2400` | VBLANK/self-test/coin/cocktail/igniter inputs | `in3` enables Sheet 5A `9R` LS244 | `PARTIAL` | `PABD7..0 = FIRE1, FIRE2, COIN AUX, COCKTAIL, COIN R, COIN L, SELF TEST, BVBLANK`, cross-checked against Sheet 5A/MAME. |
| `2600` | Custom write | named `m_custom_write_cs` | `PARTIAL` | Decode name exists; behavior remains intentionally stubbed. |
| `2800-29FF` | Non-volatile RAM | `m_nvram_cs = 2800-29FF` | `PARTIAL` | Enable/write behavior via `3E00` not fully modeled. |
| `3000-30FF` | Motion RAM | `m_motion_cs = 3000-30FF` | `PARTIAL` | Now crosses named `MOA/MOD` bus, but Sheet 4A 74LS157/2101/244 not complete. |
| `3200-327F` | Color RAM | `m_palette_cs = 3200-327F` | `PARTIAL` | RTL stores `{ma[6], mdo}`; final Sheet 4B/5A color mux pending. |
| `3800` | Right coin counter | `out_latch[0]` via `m_coin_counter_r_cs` | `PARTIAL` | Logical latch exists internally; physical counter output not exposed. |
| `3801` | Left coin counter | `out_latch[1]` via `m_coin_counter_l_cs` | `PARTIAL` | Logical latch exists internally; physical counter output not exposed. |
| `3803` | Cocktail output | `out_latch[3]` via `m_cocktail_out_cs` | `PARTIAL` | Latched internally, not yet connected to cocktail video/input paths. |
| `3806` | Start 2 LED | `out_latch[6]` via `m_start2_led_cs` | `PARTIAL` | Logical latch exists internally; physical LED output not exposed. |
| `3807` | Start 1 LED | `out_latch[7]` via `m_start1_led_cs` | `PARTIAL` | Logical latch exists internally; physical LED output not exposed. |
| `3A00` | Watchdog | named `m_watchdog_cs` | `PARTIAL` | Decode name exists; FPGA reset/watchdog behavior still differs from PCB. |
| `3C00` | Reset IRQ | named `m_irq_reset_cs` clears main IRQ on write | `PARTIAL` | Functional IRQ clear exists; exact decode timing pending. |
| `3E00` | Enable NVRAM | named `m_nvram_enable_cs` | `PARTIAL` | Decode name exists; NVRAM is still always accessible when selected. |
| `4000-FFFF` | Master program ROM | `m_rom_cs = ma >= 4000` | `PARTIAL` | Functional ROM present; exact ROM select sheet audit pending. |

## Slave CPU Map

| Address | Schematic Function | Current RTL Decode | Status | Notes |
| --- | --- | --- | --- | --- |
| `0000-0007` | Working RAM | `s_local_cs = sa < 0800` | `PARTIAL` | RTL treats `0000-07FF` as local RAM except graph register overlay. |
| `0008-000A`, `000C-000E` | Store/read bitmap RAM and coordinate auto-adjust | `s_graph_cs = 0008-000F`; `adjust_bitmap()` | `PARTIAL` | Functional approximation; Sheets 7B/8A/8B audit required. |
| `000B` | Bitmap X coordinate | `sa[2:0] == 3` writes `bitmap_x` | `PARTIAL` | Matches map functionally; exact write timing pending. |
| `000F` | Bitmap Y coordinate | `sa[2:0] == 7` writes `bitmap_y` | `PARTIAL` | Matches map functionally; exact write timing pending. |
| `0010-07FF` | Working RAM | `s_local_cs = sa < 0800` | `PARTIAL` | Functional RAM present. |
| `0800-0FFF` | Communication RAM | `s_shared_cs = 0800-0FFF` | `PARTIAL` | Functional shared RAM; exact interconnect pending. |
| `1000` | Reset IRQ | named `pbirqres` clears slave IRQ on write | `PARTIAL` | Functional IRQ clear exists. |
| `1200` | Swap bitmaps / clear bitmap | named `swap` bits 0/1 | `PARTIAL` | Functional; exact Sheet 7B/8A behavior pending. |
| `1400` | Custom write | named `s_custom_write_cs` | `PARTIAL` | Decode name exists; behavior remains intentionally stubbed. |
| `2000-FFFF` | Slave program ROM | `s_rom_cs = sa >= 2000` | `PARTIAL` | Functional ROM present; exact ROM select audit pending. |

## Immediate Risks From Map Audit

- Master `2600` and slave `1400` custom writes are named but still behaviorally
  stubbed. They may affect display positioning or timing; this must be checked
  before declaring video exact.
- Master output addresses `3800-3807` now have an internal `out_latch`, but
  only as logical stubs.
- NVRAM enable at `3E00` is named but not functionally gating writes yet. This
  can affect persistence and write protection behavior.
- Player 2/cocktail physical behavior is still incomplete, but the `2200`
  LS244 read path now exists structurally.

## Implementation Rule

When touching decode logic in `rtl/cloak_core.sv`, update this file and the
relevant detailed sheet audit in the same commit.
