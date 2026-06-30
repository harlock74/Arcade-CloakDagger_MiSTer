# Master CPU / Bus Audit

Branch: `rewrite/schematic-4a-4b`

Sheets:

- `2A`: Master Microprocessor, Master/Slave Interconnect, rendered as
  `/tmp/cloak_master_hi/master_01.png`
- `2B`: Communication RAM, Master Program, Non-Volatile RAM, rendered as
  `/tmp/cloak_master_hi/master_02.png`
- `10A`: Master memory map, rendered as `/tmp/cloak_pages/page-019.png`

Status: `STARTED`

Purpose: verify the master CPU foundation before more video/motion rewrites.

Legend:

- `DONE`: structurally represented and verified.
- `PARTIAL`: functionally represented, but not net-for-net.
- `MISSING`: not represented.
- `VERIFY`: visible on schematic but needs further trace before coding.

## Sheet 2A: Master Microprocessor

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `3C` | `6502B` | `PABA*`, `PABD*`, `PABR/W`, `IRQ`, `RESET`, `READY`, `PHI0/PHI1/PHI2` | Master CPU | `T65 main_cpu` | `PARTIAL` | CPU exists, but exact phase clocks and READY/SO/NMI behavior are simplified. |
| `2B`, `2C`, `2G` | `74LS244` | CPU `A0..A15` to `PABA0..PABA15` | Master address bus buffers | direct `ma = ma24[15:0]` | `PARTIAL` | Bus exists logically; no structural LS244 enables. |
| `2E/F` | `74LS245` | CPU data `D0..D7` to `PABD0..PABD7`, `PABR/W` | Master data bus transceiver | direct `mdi/mdo` mux | `PARTIAL` | Direction behavior exists through CPU DI/DO, but no LS245 structure/timing. |
| `5E` | `74LS138` | `PABA11..15`, outputs `LFREQ`, `HFREQ`, `PACMRAM`, `PARAM`, etc. | Main high address decode | named wires `lfreq`, `hfreq`, `pacmram`, `param` | `PARTIAL` | Functional map and schematic names exist; exact LS138 polarity/timing is still collapsed. |
| `8F` | `74LS139` | `PABA9/10`, `COLRAM`, `MORAM`, etc. | Sub-decode for color/motion/RAM regions | named wires `moram`, `colram` | `PARTIAL` | Motion/color selects now have schematic names, but LS139 structure/timing is still collapsed. |
| `9E` | `74LS139` | `PABA9/10`, outputs `OUT`, `WDDIS`, `PAIRQRES`, etc. | Output/custom/IRQ decode | named wires `m_out_cs`, `m_watchdog_cs`, `m_irq_reset_cs`, `m_custom_write_cs` | `PARTIAL` | `PAIRQRES`, `OUT`, watchdog and custom-write names exist. Watchdog/custom-write behavior is still stubbed. |
| `9A` | `74LS109` | CPU clock/reset related nets | CPU clock phase/control latch | clock enables `ce_main` | `PARTIAL` | Current core uses simple 1 MHz enable, not exact phase chain. |
| `8A`, `9D`, `9C`, `10C`, `8B`, `8D`, `7D` gates | `74LS74`, `74LS02`, `74LS00`, `74LS20`, `74LS32`, `74LS08` | `FREQ`, `PACMRAM`, `BDEL2H`, `BWRITE`, `PABR/W`, `MORAM`, reset/watchdog nets | Timing, reset, write, and select glue | scattered simple enables | `MISSING/PARTIAL` | Needs gate-level trace before exact timing changes. |
| `9D`, `7E`, `9D` | `74LS393`, `74LS74` | `POR`, `WDCLR`, `RESET`, `IRQ` | Reset/watchdog/IRQ latch chain | reset input plus software IRQ clear | `PARTIAL` | Watchdog not modeled; IRQ frequency approximated in RTL. |
| `1P`, `1D`, `8C`, `5H` interconnect block | `74LS244`, `74LS04`, `74LS02` plus resistor packs | `BSM`, `BSM*`, `B1H`, `B2H`, `B4H`, `B8H`, `B16H`, `B32H`, `B256H`, `BVBLANK`, `BMAP*` | Master/slave timing and interconnect nets | mostly implicit counters and direct bitmap signals | `MISSING/PARTIAL` | These timing nets affect video/motion/bitmap; must be audited before final 1:1 timing. |

## Sheet 2B: Communication RAM

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `1H`, `1F` | `74LS245` | `EPBBD0..7`, `PABD0..7`, `CMD0..7`, `BPBBR/W`, `PABR/W` | Communication RAM data bus buffers | `communication_ram` dual-port RAM data ports | `PARTIAL` | Functional shared data path exists; tri-state/buffer timing not modeled. |
| `1J` | `74LS139` | `PABA13..15`, outputs `PAROM0..3` | Master ROM bank decode / comm area decode context | ROM array indexing | `PARTIAL` | ROM select collapsed into one array; bank-select nets not represented. |
| `1B`, `1C`, `1A` | `74LS157` | `PABA/PBBA` address pairs, `BDEL2H`, outputs to communication RAM address | Communication RAM address muxes | dual-port RAM addresses `ma[10:0]` and `sa[10:0]` | `PARTIAL` | Functional dual-port RAM sidesteps original mux/arbitration timing. |
| `1D/E` | `6116-2` | `CMD0..7`, muxed address, `CMCS`, `CMWR` | 2K communication RAM | `cloak_tdp_ram #(.AW(11)) communication_ram` | `PARTIAL` | Capacity matches; exact CS/WE/OE timing not modeled. |
| `4J`, `5F`, `7C`, `9C`, `5J`, `9F` gates | `74LS08`, `74LS32`, `74LS00`, `74LS20` | `PACMRAM`, `BPBCMRAM`, `CMCS`, `CMWR`, `PAMEM`, `BWRITE` | Communication RAM select/write logic | `m_shared_cs`, `s_shared_cs`, write enables | `PARTIAL` | Decode behavior exists; named gate chain absent. |

## Sheet 2B: Master Program ROM

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `2D`, `2F`, `2H/J`, `2K` | `2764-2`, `27128-2` ROMs | `PABA0..12`, `PAROM0..3`, ROM `D0..D7` | Master program ROM banks | `main_rom[0:16'hBFFF]` | `PARTIAL` | Program bytes load/function, but physical chip selects and sizes are collapsed. |
| `3F/H` | `74LS245` | ROM data to `AD0..AD7`, `PABR/W` | Program ROM data bus buffer | `main_rom_q` into `mdi` | `PARTIAL` | Functional ROM read, not structural buffer. |
| `4J`, `1L` gates | `74LS08`, `74LS27` | `EEDECODE`, `PAMEM`, `PABA14/15` | ROM/memory enable decode | `m_rom_cs = ma >= 4000` | `PARTIAL` | Correct broad range; exact decode and enable polarity not represented. |

## Sheet 2B: Non-Volatile RAM

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `3J/K` | `X2816A` | `PABA0..8`, data bus, `EEDECODE`, `EEPROM`, `BWRITE`, `POR`, `PABR/W` | Non-volatile RAM / EEPROM | `nonvolatile_ram` | `PARTIAL` | RAM exists, but EEPROM write enable/protection/persistence are simplified. |
| `5F`, `7D`, `7A` gates | `74LS32`, `74LS08`, `74LS14` | `EEPROM`, `BWRITE`, `POR`, `PABR/W` | NVRAM enable/write control | `m_nvram_cs` direct write | `MISSING/PARTIAL` | Master `3E00` NVRAM enable from memory map is missing in RTL. |

## Sheet 10A Cross-Check Findings

Important map mismatches still open:

- `2600` custom write is named as `m_custom_write_cs`, but behavior is still stubbed.
- `3800`, `3801`, `3803`, `3806`, `3807` output strobes now feed internal `out_latch`; physical outputs remain internal.
- `3A00` watchdog reset is named as `m_watchdog_cs`, but behavior is still stubbed.
- `3E00` NVRAM enable is named as `m_nvram_enable_cs`, but NVRAM gating is not yet implemented.
- Player 2 and the `2400` system input byte now have explicit Sheet 5A LS244
  paths; cocktail remains tied inactive in the MiSTer wrapper until the video
  cocktail paths are fully verified.

## RTL References

Current relevant code in `rtl/cloak_core.sv`:

- Master CPU: `main_cpu`.
- Master decode: `m_main_ram_cs`, `m_play_cs`, `m_shared_cs`, `m_pokey1_cs`,
  `m_pokey2_cs`, `m_nvram_cs`, `m_motion_cs`, `m_palette_cs`, `m_rom_cs`,
  plus schematic aliases `param`, `pacmram`, `lfreq`, `hfreq`, `moram`,
  `colram`, `m_out_cs`, `m_irq_reset_cs`, `m_watchdog_cs`,
  `m_custom_write_cs`, and `m_nvram_enable_cs`.
- Communication RAM: `communication_ram`.
- NVRAM: `nonvolatile_ram`.
- Program ROM: `main_rom`, `main_rom_q`.
- IRQ: `main_irq_n` generation and clear at `3C00`.

## Next Implementation Candidates

Do not change CPU timing yet. The safest schematic-backed foundation steps are:

1. Add a real `nvram_enabled` latch from `3E00` and gate NVRAM writes.
2. Decide whether `m_custom_write_cs` and `m_watchdog_cs` need functional
   behavior or should remain intentional stubs.
3. Connect `out_latch` cocktail only after input/playfield/bitmap cocktail
   paths are ready.
4. Rename broad ROM/communication selects with schematic names while preserving
   behavior.

Each step must update this audit and `schematic_memory_map_audit.md`.
