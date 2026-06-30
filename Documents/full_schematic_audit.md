# Cloak & Dagger Full Schematic Audit Index

Branch: `rewrite/schematic-4a-4b`

Purpose: make the implementation schematic-led across the whole game, not just
the motion-object sheets. Future Verilog work should reference this index first,
then a detailed per-sheet audit.

Sources:

- `Documents/cloak.pdf`
- Rendered schematic pages: `/tmp/cloak_pages/page-001.png` through
  `/tmp/cloak_pages/page-021.png`
- OCR pass performed with `tesseract` on all 21 rendered pages.

Scope rule:

- Include digital logic: CPUs, RAM, ROM, PROM, address decoders, counters,
  latches, muxes, buffers, input/output digital gates, timing, sync, and video
  selection.
- Ignore analog-only details such as resistor/capacitor values except where the
  digital logic depends on a net name, PROM output, or palette/color selection.

## Page And Sheet Inventory

| Rendered Page | Schematic Sheet | Title / Function | Digital Relevance | Audit Status |
| --- | --- | --- | --- | --- |
| `page-001` | Cover/title | Package/title page | None | `DONE: no RTL impact` |
| `page-002` | `1A` | Table of contents | Index only | `DONE: used for inventory` |
| `page-003` | `1B` | Master PCB Power Input | Low | `DONE: power-only, no RTL block beyond reset/clock references` |
| `page-004` | `2A` | Master Microprocessor, Master/Slave Interconnect | High | `STARTED: see schematic_master_cpu_audit.md` |
| `page-005` | `2B` | Communication RAM, Master Program, Non-Volatile RAM | High | `STARTED: see schematic_master_cpu_audit.md` |
| `page-006` | `3A` | Sync Chain, Working RAM/Playfield RAM | High | `STARTED: see schematic_playfield_audit.md` |
| `page-007` | `3B` | Playfield | High | `STARTED: see schematic_playfield_audit.md` |
| `page-008` | `4A` | Motion Object | High | `STARTED: see schematic_4a_4b_audit.md` |
| `page-009` | `4B` | Motion Object Buffers, Video | High | `STARTED: see schematic_4a_4b_audit.md` |
| `page-010` | `5A` | Inputs, RGB Output | Medium | `STARTED: see schematic_io_video_audit.md` |
| `page-011` | `5B` | Outputs, Audio | Medium | `STARTED: see schematic_audio_outputs_audit.md` |
| `page-012` | `6A` | Slave PCB Power Input, Clock | Medium | `STARTED: see schematic_slave_bitmap_audit.md` |
| `page-013` | `6B` | Slave Microprocessor, Slave Processing, Master/Slave Interconnect | High | `STARTED: see schematic_slave_bitmap_audit.md` |
| `page-014` | `7A` | Sync Chain, Slave Program ROM, Working RAM, Communication RAM Interconnect | High | `STARTED: see schematic_slave_bitmap_audit.md` |
| `page-015` | `7B` | Bit Map Clock, Bit Map Write | High | `STARTED: see schematic_slave_bitmap_audit.md` |
| `page-016` | `8A` | Bit Map | High | `STARTED: see schematic_slave_bitmap_audit.md` |
| `page-017` | `8B` | Bit Map Output | High | `STARTED: see schematic_slave_bitmap_audit.md` |
| `page-018` | `9A` | FMI Shield PCB | Low/medium | `STARTED: see schematic_wiring_interconnect_audit.md` |
| `page-019` | `10A` | Memory Map - Master PCB | High | `STARTED: see schematic_memory_map_audit.md` |
| `page-020` | `10B` | Memory Map - Slave PCB | High | `STARTED: see schematic_memory_map_audit.md` |
| `page-021` | `10C` | Main Wiring Diagram - Conversion Kit | Low/medium | `STARTED: see schematic_wiring_interconnect_audit.md` |

## Required Detailed Audits

Create or complete these per-sheet audit files before making non-trivial RTL
changes in that area:

| Area | Sheets | Audit File | Priority | Reason |
| --- | --- | --- | --- | --- |
| Master CPU and address/data bus | `2A`, `2B`, `10A` | `schematic_master_cpu_audit.md` | High | Prevent CPU bus, ROM/RAM, communication RAM, NVRAM mistakes. |
| Master sync and playfield | `3A`, `3B` | `schematic_playfield_audit.md` | High | Blue text fix worked, but full playfield timing still needs verification. |
| Motion objects and final video | `4A`, `4B` | `schematic_4a_4b_audit.md` | High | Current known sprite/enemy issue. |
| Inputs and RGB/video output | `5A`, `4B`, `10C` | `schematic_io_video_audit.md` | Medium | Prevent future OSD/control/video mux assumptions. |
| Audio and outputs | `5B` | `schematic_audio_outputs_audit.md` | Medium | Audio currently works, but should be documented before changes. |
| Slave CPU and bitmap system | `6A`, `6B`, `7A`, `7B`, `8A`, `8B`, `10B` | `schematic_slave_bitmap_audit.md` | High | Bitmap/scene graphics and slave CPU path are major systems. |
| Harness/shield/interconnect | `9A`, `10C` | `schematic_wiring_interconnect_audit.md` | Low/medium | Mostly physical wiring, but control mapping and connector nets matter. |
| Memory maps and decode coverage | `10A`, `10B` | `schematic_memory_map_audit.md` | High | Defines visible master/slave address behavior before sheet-level implementation. |

## Existing RTL Coverage By Subsystem

| Subsystem | Current Main RTL | Schematic Coverage Status |
| --- | --- | --- |
| Master CPU | `T65` instance in `rtl/cloak_core.sv` | `PARTIAL`: memory map implemented, bus timing not fully sheet-audited. |
| Slave CPU | `T65` instance in `rtl/cloak_core.sv` | `PARTIAL`: slave/bitmap sheets now started; bus/timing not net-for-net. |
| Main/slave ROMs | `main_rom`, `slave_rom` arrays | `PARTIAL`: MAME/MRA based; sheet ROM select logic not fully reproduced. |
| Communication RAM | `communication_ram` | `PARTIAL`: functional shared RAM, not exact bus arbitration. |
| NVRAM | `nonvolatile_ram` | `PARTIAL`: memory present, enable/write behavior needs sheet check. |
| Playfield RAM/graphics | `playfield_ram`, `char_graphics` | `PARTIAL`: Sheet 3A/3B audit started; LS157/LS194 path not 1:1. |
| Motion objects | inline renderer in `rtl/cloak_core.sv` on clean branch | `NOT 1:1`: detailed Sheet 4A/4B audit started. |
| Bitmap graphics | bitmap RAM/control logic in `rtl/cloak_core.sv` | `PARTIAL`: functional FPGA RAM replacement; DRAM/mux/shift path not 1:1. |
| Final video mux | `palette_index` combinational priority | `NOT 1:1`: Sheet 4B/5A muxing pending. |
| Inputs | Sheet 5A `9N/9P/9R` LS244 read ports | `PARTIAL`: input buffers and byte order are explicit; cocktail remains inactive until video cocktail paths are verified. |
| Audio | `pokey_compat` x2 and mixer | `PARTIAL`: Sheet 5B audit started; output latch and analog filters not 1:1. |

## Work Rule From Now On

Before modifying RTL:

1. Identify the schematic sheet and rendered page.
2. Update or create the detailed audit file for that sheet.
3. Mark the exact ICs/nets being implemented.
4. Implement the smallest coherent schematic block.
5. Update the audit status from `MISSING` to `PARTIAL` or `DONE`.
6. Run local smoke tests.
7. Only ask for Quartus/MiSTer testing if the change should affect behavior.

This means no more visual “guess patches” without a matching schematic row.
