# Cloak & Dagger MiSTer Core

Work-in-progress implementation based on Atari schematic package SP-242 and
the official MAME `src/mame/atari/cloak.cpp` hardware description.

The game ROM data is not included. It must be supplied through MiSTer using
the documented ROM layout.

The locally supplied rev-5 ROM set has been checked against all MAME CRCs.
SystemVerilog core and MiSTer-wrapper elaboration pass with Icarus Verilog.
The first Quartus fit failed because inferred bitmap and graphics memories
expanded to 126,662 combinational nodes. Bitmap RAM and graphics ROMs now use
explicit Cyclone V `altsyncram` blocks, and the synthesis paths elaborate
successfully. R2 reached the block-RAM primitives but Quartus 17 rejected
`OLD_DATA` on port B in bidirectional dual-port mode. R3 uses the supported
`NEW_DATA_NO_NBE_READ` setting and completes Analysis & Synthesis, but its
speed-oriented fit requires 5,570 LABs where the device has 4,191. R4 selects
aggressive area optimization, disables logic/register duplication, and removes
unused adaptive filtering, large video buffering, YC output and ALSA support.
R4 reduces the fit from 5,570 to 5,482 LABs but remains above the device's
4,191 LABs. R5 replaces the asynchronous main, slave, communication,
playfield and non-volatile RAM arrays with explicit dual-port Cyclone V block
RAM. R5 compiles, fits and boots on a DE10-Nano. R6 corrects the compact POKEY
clock divider and signed audio output after the first hardware test produced
no sound, but hardware still produced no sound and F12 did not open the OSD.
The current R7 diagnostic build adds a startup test tone, a POKEY-write marker,
and an `OSD_STATUS` video tint to isolate deployment, audio and OSD signaling.
The test tone works and the CPU reaches both POKEYs, but the compact substitute
still produces no samples. The current diagnostic source replaces it with the
proven Atari800 MiSTer POKEY and temporarily uses the known-working
`A.BLUEPRT` core identifier as an OSD A/B test.

## Schematic mapping

| SP-242 sheet | FPGA implementation |
| --- | --- |
| 2A Master microprocessor/interconnect | Two T65 instances, IRQ latches and shared RAM |
| 2B Communication RAM/program/NVRAM | CPU read muxes, shared RAM, ROM loader and NVRAM |
| 3A Sync/working/playfield RAM | Raster counters, master RAM and playfield RAM |
| 3B Playfield | `char_pixel`, tile addressing and character ROM |
| 4A/4B Motion objects/video | Motion RAM, line renderer and layer priority |
| 5A Inputs/RGB | MiSTer controls, palette RAM and nine-bit RGB conversion |
| 5B Audio | `pokey_compat` placeholder; full POKEY remains required |
| 6B/7A Slave CPU/program/shared RAM | Slave T65 bus and slave memory map |
| 7B/8A Bitmap | X/Y commands and dual bitmap page RAM |
| 8B Bitmap output | Bitmap display page and compositor |

## ROM download layout

| Offset | Size | Purpose |
| --- | ---: | --- |
| `00000` | `0C000` | Master ROM, CPU addresses `4000-FFFF` |
| `0C000` | `0E000` | Slave ROM, CPU addresses `2000-FFFF` |
| `1A000` | `02000` | Character graphics |
| `1C000` | `02000` | Motion-object graphics |
| `1E000` | `00100` | Vertical timing PROM |
