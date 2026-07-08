# Cloak & Dagger Sheet 4B Full Pin Netlist

Scope: Sheet 4B only, SP-242 Sheet 4B, "Motion Object Buffers" and "Video".

Evidence used:

- `Documents/cloak.pdf`, Sheet 4B, PDF page 63.
- `Documents/schematic_crops/sheet_4b/sheet_4b_full_pdf63_r220.png`.
- `Documents/schematic_crops/sheet_4b/sheet_4b_top_half_pdf63_r220.png`.
- `Documents/schematic_crops/sheet_4b/sheet_4b_left_half_pdf63_r220.png`.
- `Documents/schematic_crops/sheet_4b/sheet_4b_motion_buffer_zoom_cached.png`.
- `Documents/schematic_crops/sheet_4b/sheet_4b_left_write_controls_crop.png`.
- `Documents/schematic_crops/sheet_4b/sheet_4b_9t_9h_center_crop.png`.
- `Documents/schematic_crops/sheet_4b/sheet_4b_9h_final_selector_crop.png`.

Rules for this file:

- `CONFIRMED` means the visible schematic label/pin/connection is readable on Sheet 4B evidence.
- `PROBABLE` means the line is strongly indicated by the visible schematic but the crop still has some ambiguity.
- `UNCLEAR_LABEL`, `UNCLEAR_PIN`, and `UNCLEAR_CONNECTION` are deliberately blocking statuses, not TODO shortcuts.
- RTL names are comparison aids only. They are not used as schematic evidence.
- Existing RTL signal `bsm` is treated as a legacy RTL/audit name for the confirmed Sheet 4B `B5M` timing rail.
- The visual-check CSV/Markdown review has no remaining `Check` rows as of commit `068ea36`; this detailed netlist is now synced to those reviewed Sheet 4B pin findings. It still separates schematic-confirmed pins from RTL implementation status.

Allowed statuses:

`CONFIRMED`, `PROBABLE`, `UNCLEAR_LABEL`, `UNCLEAR_PIN`, `UNCLEAR_CONNECTION`, `PLACEHOLDER_IN_RTL`, `RTL_MISMATCH`, `NOT_IMPLEMENTED`, `NOT_RELEVANT_TO_RTL`

## IC Inventory

| Sheet | IC | IC type | Evidence/crop | Status | Notes |
| --- | --- | --- | --- | --- | --- |
| 4B | `7J` | `74LS163A` | full/top/left Sheet 4B crops | CONFIRMED | Left low-nibble motion buffer counter. |
| 4B | `7K` | `74LS163A` | full/top/left Sheet 4B crops | CONFIRMED | Left high-nibble motion buffer counter. |
| 4B | `7L` | `74LS163A` | full/left Sheet 4B crops | CONFIRMED | Right low-nibble motion buffer counter. |
| 4B | `7M` | `74LS163A` | full/left Sheet 4B crops | CONFIRMED | Right high-nibble motion buffer counter. |
| 4B | `8K` | `74LS157` | full/top/left Sheet 4B crops | CONFIRMED | Left data mux into `8J`. |
| 4B | `8M` | `74LS157` | full/left Sheet 4B crops | CONFIRMED | Right data mux into `8L`. |
| 4B | `8J` | `93422` | full/top/left Sheet 4B crops | CONFIRMED | Left 4-bit motion buffer RAM. |
| 4B | `8L` | `93422` | full/left Sheet 4B crops | CONFIRMED | Right 4-bit motion buffer RAM. |
| 4B | `9T` | `74LS273` | full/top/9T-9H crops | CONFIRMED | Latches `8J/8L` outputs to `LB00..LB13`. |
| 4B | `9H` | `74LS157` | full/9H final selector crop | CONFIRMED | Selects `LB0x/LB1x` to `MBIT0..MBIT3`. |
| 4B | `6F` | `74LS74` | full/top Sheet 4B crop | CONFIRMED | Video timing flip-flop in color path. |
| 4B | `10H` | `74LS153` | full/top Sheet 4B crop | CONFIRMED | Color mux producing `COLA3` and `COLA2`. |
| 4B | `10J` | `74LS153` | full/top Sheet 4B crop | CONFIRMED | Color mux producing `COLA1` and `COLA0`. |
| 4B | `11J` | `74LS157` | full/top Sheet 4B crop | CONFIRMED | Video mux producing `COLA5` and `COLA4`. |
| 4B | `9K` | `74LS260` | full Sheet 4B crop | CONFIRMED | Motion-zero detect for `MBIT0..MBIT3`; output feeds `COLSEL1`. |
| 4B | `8C` | `74LS04` section | full Sheet 4B crop | CONFIRMED | Inverter section in lower video select logic. |
| 4B | `8D` | `74LS32` section | full Sheet 4B crop / visual-check CSV | CONFIRMED | Single visible OR gate section in lower video select logic, pins 4/5/6. |
| 4B | `1L` | `74LS27` section | full Sheet 4B crop / visual-check CSV | CONFIRMED | Bitmap zero-detect NOR feeding `8D` pin 5. |
| 4B | `8E` | `74LS00` sections | full Sheet 4B crop | CONFIRMED | NAND sections in lower video select logic. |

## Pin Netlist

| Sheet | IC | IC type | Pin | Pin function | Schematic net label | Connected to IC/pin or off-sheet ref | Direction | Active-low? | RTL signal | Status | Evidence/crop | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 4B | `7J` | `74LS163A` | 1 | `/CLR` | `MOHRO` | off-sheet `MOHRO`; also `7K` pin 1 | input | yes | `motion_buffer_left_clear_n` | CONFIRMED | full/top Sheet 4B crop | Local label and shared clear line readable. |
| 4B | `7J` | `74LS163A` | 2 | CLK | `B5M` | off-sheet timing rail; also counters and 93422/9T | input | no | `bsm` | CONFIRMED | full/top Sheet 4B crop | Fresh Sheet 4B review confirms label is `B5M`. |
| 4B | `7J` | `74LS163A` | 3 | A preload | `MOD0` | off-sheet `MOD0` | input | no | `motion_buffer_left_load_addr[0]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic net confirmed; RTL uses temporary X-derived preload. |
| 4B | `7J` | `74LS163A` | 4 | B preload | `MOD1` | off-sheet `MOD1` | input | no | `motion_buffer_left_load_addr[1]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic net confirmed; RTL uses temporary X-derived preload. |
| 4B | `7J` | `74LS163A` | 5 | C preload | `MOD2` | off-sheet `MOD2` | input | no | `motion_buffer_left_load_addr[2]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic net confirmed; RTL uses temporary X-derived preload. |
| 4B | `7J` | `74LS163A` | 6 | D preload | `MOD3` | off-sheet `MOD3` | input | no | `motion_buffer_left_load_addr[3]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic net confirmed; RTL uses temporary X-derived preload. |
| 4B | `7J` | `74LS163A` | 7 | ENP | pullup rail via `PR174` | `PR174` pullup bus | input | no | `1'b1` | CONFIRMED | full/top Sheet 4B crop | Pullup network visible; exact resistor pin on `PR174` is readable only as shared bus. |
| 4B | `7J` | `74LS163A` | 9 | `/LOAD` | `MOHLO` | off-sheet `MOHLO`; also `7K` pin 9 | input | yes | `motion_buffer_left_load_n` | CONFIRMED | full/top Sheet 4B crop | Local label readable. |
| 4B | `7J` | `74LS163A` | 10 | ENT | pullup rail via `PR174` | `PR174` pullup bus | input | no | `1'b1` | CONFIRMED | full/top Sheet 4B crop | Pullup network visible. |
| 4B | `7J` | `74LS163A` | 11 | QD | address bit to `8J` A3 | `8J` pin 1 `A3` | output | no | `motion_buffer_left_addr_from_7j_7k[3]` | CONFIRMED | full/top Sheet 4B crop | Routed down/right to `8J` address bus. |
| 4B | `7J` | `74LS163A` | 12 | QC | address bit to `8J` A2 | `8J` pin 2 `A2` | output | no | `motion_buffer_left_addr_from_7j_7k[2]` | CONFIRMED | full/top Sheet 4B crop | Routed down/right to `8J` address bus. |
| 4B | `7J` | `74LS163A` | 13 | QB | address bit to `8J` A1 | `8J` pin 3 `A1` | output | no | `motion_buffer_left_addr_from_7j_7k[1]` | CONFIRMED | full/top Sheet 4B crop | Routed down/right to `8J` address bus. |
| 4B | `7J` | `74LS163A` | 14 | QA | address bit to `8J` A0 | `8J` pin 4 `A0` | output | no | `motion_buffer_left_addr_from_7j_7k[0]` | CONFIRMED | full/top Sheet 4B crop | Routed down/right to `8J` address bus. |
| 4B | `7J` | `74LS163A` | 15 | RIP | cascade ripple | `7K` pin 10 ENT | output | no | `motion_buffer_left_low_ripple` | CONFIRMED | full/top Sheet 4B crop | Cascade line visible between `7J` and `7K`. |
| 4B | `7K` | `74LS163A` | 1 | `/CLR` | `MOHRO` | off-sheet `MOHRO`; also `7J` pin 1 | input | yes | `motion_buffer_left_clear_n` | CONFIRMED | full/top Sheet 4B crop | Shared clear line readable. |
| 4B | `7K` | `74LS163A` | 2 | CLK | `B5M` | off-sheet timing rail; also counters and 93422/9T | input | no | `bsm` | CONFIRMED | full/top Sheet 4B crop | Fresh Sheet 4B review confirms label is `B5M`. |
| 4B | `7K` | `74LS163A` | 3 | A preload | `MOD4` | off-sheet `MOD4` | input | no | `motion_buffer_left_load_addr[4]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7K` | `74LS163A` | 4 | B preload | `MOD5` | off-sheet `MOD5` | input | no | `motion_buffer_left_load_addr[5]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7K` | `74LS163A` | 5 | C preload | `MOD6` | off-sheet `MOD6` | input | no | `motion_buffer_left_load_addr[6]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7K` | `74LS163A` | 6 | D preload | `MOD7` | off-sheet `MOD7` | input | no | `motion_buffer_left_load_addr[7]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7K` | `74LS163A` | 7 | ENP | `7J` RIP/cascade node | `7J` pin 15 and `7K` pin 10 node | input | no | `motion_buffer_left_low_ripple` | CONFIRMED | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed cascade split. |
| 4B | `7K` | `74LS163A` | 9 | `/LOAD` | `MOHLO` | off-sheet `MOHLO`; also `7J` pin 9 | input | yes | `motion_buffer_left_load_n` | CONFIRMED | full/top Sheet 4B crop | Local label readable. |
| 4B | `7K` | `74LS163A` | 10 | ENT | `7J` RIP/cascade node | `7J` pin 15 and `7K` pin 7 node | input | no | `motion_buffer_left_low_ripple` | CONFIRMED | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed cascade split. |
| 4B | `7K` | `74LS163A` | 11 | QD | address bit to `8J` A7 | `8J` pin 7 `A7` | output | no | `motion_buffer_left_addr_from_7j_7k[7]` | CONFIRMED | full/top Sheet 4B crop | Routed to `8J` address bus. |
| 4B | `7K` | `74LS163A` | 12 | QC | address bit to `8J` A6 | `8J` pin 6 `A6` | output | no | `motion_buffer_left_addr_from_7j_7k[6]` | CONFIRMED | full/top Sheet 4B crop | Routed to `8J` address bus. |
| 4B | `7K` | `74LS163A` | 13 | QB | address bit to `8J` A5 | `8J` pin 5 `A5` | output | no | `motion_buffer_left_addr_from_7j_7k[5]` | CONFIRMED | full/top Sheet 4B crop | Routed to `8J` address bus. |
| 4B | `7K` | `74LS163A` | 14 | QA | address bit to `8J` A4 | `8J` pin 21 `A4` | output | no | `motion_buffer_left_addr_from_7j_7k[4]` | CONFIRMED | full/top Sheet 4B crop | Routed to `8J` address bus. |
| 4B | `7K` | `74LS163A` | 15 | RIP | no visible downstream use | local/no visible destination | output | no | unused | CONFIRMED | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed no hidden connection. |
| 4B | `7L` | `74LS163A` | 1 | `/CLR` | `MOHRI` | off-sheet `MOHRI`; also `7M` pin 1 | input | yes | `motion_buffer_right_clear_n` | CONFIRMED | full/left Sheet 4B crop | Local label readable. |
| 4B | `7L` | `74LS163A` | 2 | CLK | `B5M` | off-sheet timing rail; also counters and 93422/9T | input | no | `bsm` | CONFIRMED | full/left Sheet 4B crop | Fresh Sheet 4B review confirms label is `B5M`. |
| 4B | `7L` | `74LS163A` | 3 | A preload | `MOD0` | off-sheet `MOD0` | input | no | `motion_buffer_right_load_addr[0]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7L` | `74LS163A` | 4 | B preload | `MOD1` | off-sheet `MOD1` | input | no | `motion_buffer_right_load_addr[1]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7L` | `74LS163A` | 5 | C preload | `MOD2` | off-sheet `MOD2` | input | no | `motion_buffer_right_load_addr[2]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7L` | `74LS163A` | 6 | D preload | `MOD3` | off-sheet `MOD3` | input | no | `motion_buffer_right_load_addr[3]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7L` | `74LS163A` | 7 | ENP | pullup rail via `PR174` | `PR174` pullup bus | input | no | `1'b1` | CONFIRMED | full/left Sheet 4B crop | Pullup network visible. |
| 4B | `7L` | `74LS163A` | 9 | `/LOAD` | `MOHLI` | off-sheet `MOHLI`; also `7M` pin 9 | input | yes | `motion_buffer_right_load_n` | CONFIRMED | full/left Sheet 4B crop | Local label readable. |
| 4B | `7L` | `74LS163A` | 10 | ENT | pullup rail via `PR174` | `PR174` pullup bus | input | no | `1'b1` | CONFIRMED | full/left Sheet 4B crop | Pullup network visible. |
| 4B | `7L` | `74LS163A` | 11 | QD | address bit to `8L` A3 | `8L` pin 1 `A3` | output | no | `motion_buffer_right_addr_from_7l_7m[3]` | CONFIRMED | full/left Sheet 4B crop | Routed to `8L` address bus. |
| 4B | `7L` | `74LS163A` | 12 | QC | address bit to `8L` A2 | `8L` pin 2 `A2` | output | no | `motion_buffer_right_addr_from_7l_7m[2]` | CONFIRMED | full/left Sheet 4B crop | Routed to `8L` address bus. |
| 4B | `7L` | `74LS163A` | 13 | QB | address bit to `8L` A1 | `8L` pin 3 `A1` | output | no | `motion_buffer_right_addr_from_7l_7m[1]` | CONFIRMED | full/left Sheet 4B crop | Routed to `8L` address bus. |
| 4B | `7L` | `74LS163A` | 14 | QA | address bit to `8L` A0 | `8L` pin 4 `A0` | output | no | `motion_buffer_right_addr_from_7l_7m[0]` | CONFIRMED | full/left Sheet 4B crop | Routed to `8L` address bus. |
| 4B | `7L` | `74LS163A` | 15 | RIP | cascade ripple | `7M` pin 10 ENT | output | no | `motion_buffer_right_low_ripple` | CONFIRMED | full/left Sheet 4B crop | Cascade line visible between `7L` and `7M`. |
| 4B | `7M` | `74LS163A` | 1 | `/CLR` | `MOHRI` | off-sheet `MOHRI`; also `7L` pin 1 | input | yes | `motion_buffer_right_clear_n` | CONFIRMED | full/left Sheet 4B crop | Shared clear line readable. |
| 4B | `7M` | `74LS163A` | 2 | CLK | `B5M` | off-sheet timing rail; also counters and 93422/9T | input | no | `bsm` | CONFIRMED | full/left Sheet 4B crop | Fresh Sheet 4B review confirms label is `B5M`. |
| 4B | `7M` | `74LS163A` | 3 | A preload | `MOD4` | off-sheet `MOD4` | input | no | `motion_buffer_right_load_addr[4]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7M` | `74LS163A` | 4 | B preload | `MOD5` | off-sheet `MOD5` | input | no | `motion_buffer_right_load_addr[5]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7M` | `74LS163A` | 5 | C preload | `MOD6` | off-sheet `MOD6` | input | no | `motion_buffer_right_load_addr[6]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7M` | `74LS163A` | 6 | D preload | `MOD7` | off-sheet `MOD7` | input | no | `motion_buffer_right_load_addr[7]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic net confirmed; RTL preload placeholder. |
| 4B | `7M` | `74LS163A` | 7 | ENP | `7L` RIP/cascade node | `7L` pin 15 and `7M` pin 10 node | input | no | `motion_buffer_right_low_ripple` | CONFIRMED | full/left Sheet 4B crop / visual-check CSV | Reviewer confirmed cascade split. |
| 4B | `7M` | `74LS163A` | 9 | `/LOAD` | `MOHLI` | off-sheet `MOHLI`; also `7L` pin 9 | input | yes | `motion_buffer_right_load_n` | CONFIRMED | full/left Sheet 4B crop | Shared load line readable. |
| 4B | `7M` | `74LS163A` | 10 | ENT | `7L` RIP/cascade node | `7L` pin 15 and `7M` pin 7 node | input | no | `motion_buffer_right_low_ripple` | CONFIRMED | full/left Sheet 4B crop / visual-check CSV | Reviewer confirmed cascade split. |
| 4B | `7M` | `74LS163A` | 11 | QD | address bit to `8L` A7 | `8L` pin 7 `A7` | output | no | `motion_buffer_right_addr_from_7l_7m[7]` | CONFIRMED | full/left Sheet 4B crop | Routed to `8L` address bus. |
| 4B | `7M` | `74LS163A` | 12 | QC | address bit to `8L` A6 | `8L` pin 6 `A6` | output | no | `motion_buffer_right_addr_from_7l_7m[6]` | CONFIRMED | full/left Sheet 4B crop | Routed to `8L` address bus. |
| 4B | `7M` | `74LS163A` | 13 | QB | address bit to `8L` A5 | `8L` pin 5 `A5` | output | no | `motion_buffer_right_addr_from_7l_7m[5]` | CONFIRMED | full/left Sheet 4B crop | Routed to `8L` address bus. |
| 4B | `7M` | `74LS163A` | 14 | QA | address bit to `8L` A4 | `8L` pin 21 `A4` | output | no | `motion_buffer_right_addr_from_7l_7m[4]` | CONFIRMED | full/left Sheet 4B crop | Routed to `8L` address bus. |
| 4B | `7M` | `74LS163A` | 15 | RIP | no visible downstream use | local/no visible destination | output | no | unused | CONFIRMED | full/left Sheet 4B crop / visual-check CSV | Reviewer confirmed no hidden connection. |
| 4B | `8K` | `74LS157` | 1 | Select | `MOHLI` | off-sheet `MOHLI`; select for all four muxes | input | yes label/function active-low uncertain at net name | `motion_buffer_8k_select_from_mohli_n` | CONFIRMED | full/top/left Sheet 4B crops | Pin is connected to `MOHLI` label. The LS157 select pin itself is not active-low, but the net name has an overbar in previous crops/audits. |
| 4B | `8K` | `74LS157` | 2 | A input | `MBJ3*` | off-sheet `MBJ3*` | input | yes | `mbj_from_7n[3]` | CONFIRMED | full/top Sheet 4B crop | A-side fresh motion bit. |
| 4B | `8K` | `74LS157` | 3 | B input | `LB03` | `9T` pin 9 feedback / `9H` pin 11 | input | no | `lb0_feedback_for_8k[3]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic feedback is LB line; active RTL still has compatibility bridge paths. |
| 4B | `8K` | `74LS157` | 4 | Y output | `D1` | `8J` pin 9 `D1` | output | no | `motion_buffer_data_from_8k[0]` | CONFIRMED | full/top Sheet 4B crop | Output to 93422 data input. |
| 4B | `8K` | `74LS157` | 5 | A input | `MBJ1*` | off-sheet `MBJ1*` | input | yes | `mbj_from_7n[1]` | CONFIRMED | full/top Sheet 4B crop | A-side fresh motion bit. |
| 4B | `8K` | `74LS157` | 6 | B input | `LB01` | `9T` pin 15 feedback / `9H` pin 14 | input | no | `lb0_feedback_for_8k[1]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic feedback is LB line. |
| 4B | `8K` | `74LS157` | 7 | Y output | `D2` | `8J` pin 11 `D2` | output | no | `motion_buffer_data_from_8k[1]` | CONFIRMED | full/top Sheet 4B crop | Output to 93422 data input. |
| 4B | `8K` | `74LS157` | 9 | Y output | `D4` | `8J` pin 15 `D4` | output | no | `motion_buffer_data_from_8k[3]` | CONFIRMED | full/top Sheet 4B crop | Output to 93422 data input. |
| 4B | `8K` | `74LS157` | 10 | B input | `LB00` | `9T` pin 6 feedback / `9H` pin 2 | input | no | `lb0_feedback_for_8k[0]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic feedback is LB line. |
| 4B | `8K` | `74LS157` | 11 | A input | `MBJ0*` | off-sheet `MBJ0*` | input | yes | `mbj_from_7n[0]` | CONFIRMED | full/top Sheet 4B crop | A-side fresh motion bit. |
| 4B | `8K` | `74LS157` | 12 | Y output | `D3` | `8J` pin 13 `D3` | output | no | `motion_buffer_data_from_8k[2]` | CONFIRMED | full/top Sheet 4B crop | Output to 93422 data input. |
| 4B | `8K` | `74LS157` | 13 | B input | `LB02` | `9T` pin 12 feedback / `9H` pin 5 | input | no | `lb0_feedback_for_8k[2]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Schematic feedback is LB line. |
| 4B | `8K` | `74LS157` | 14 | A input | `MBJ2*` | off-sheet `MBJ2*` | input | yes | `mbj_from_7n[2]` | CONFIRMED | full/top Sheet 4B crop | A-side fresh motion bit. |
| 4B | `8K` | `74LS157` | 15 | `/G` enable | `IVDBH` | off-sheet `IVDBH` | input | yes | `motion_buffer_8k_enable_n_from_ivdbh` | CONFIRMED | full/top Sheet 4B crop | LS157 enable pin is active-low. |
| 4B | `8M` | `74LS157` | 1 | Select | `MOHRI` | off-sheet `MOHRI`; select for all four muxes | input | yes label/function active-low uncertain at net name | `motion_buffer_8m_select_from_mohri_n` | CONFIRMED | full/left Sheet 4B crop | Pin is connected to `MOHRI` label. The LS157 select pin itself is not active-low, but the net name has an overbar in previous crops/audits. |
| 4B | `8M` | `74LS157` | 2 | A input | `MBJ0*` | off-sheet `MBJ0*` | input | yes | `mbj_from_7n[0]` | CONFIRMED | full/left Sheet 4B crop | A-side fresh motion bit. |
| 4B | `8M` | `74LS157` | 3 | B input | `LB10` | `9T` pin 5 feedback / `9H` pin 3 | input | no | `lb1_feedback_for_8m[0]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic feedback is LB line. |
| 4B | `8M` | `74LS157` | 4 | Y output | `D1` | `8L` pin 9 `D1` | output | no | `motion_buffer_data_from_8m[0]` | CONFIRMED | full/left Sheet 4B crop | Output to 93422 data input. |
| 4B | `8M` | `74LS157` | 5 | A input | `MBJ1*` | off-sheet `MBJ1*` | input | yes | `mbj_from_7n[1]` | CONFIRMED | full/left Sheet 4B crop | A-side fresh motion bit. |
| 4B | `8M` | `74LS157` | 6 | B input | `LB11` | `9T` pin 16 feedback / `9H` pin 13 | input | no | `lb1_feedback_for_8m[1]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic feedback is LB line. |
| 4B | `8M` | `74LS157` | 7 | Y output | `D2` | `8L` pin 11 `D2` | output | no | `motion_buffer_data_from_8m[1]` | CONFIRMED | full/left Sheet 4B crop | Output to 93422 data input. |
| 4B | `8M` | `74LS157` | 9 | Y output | `D4` | `8L` pin 15 `D4` | output | no | `motion_buffer_data_from_8m[3]` | CONFIRMED | full/left Sheet 4B crop | Output to 93422 data input. |
| 4B | `8M` | `74LS157` | 10 | B input | `LB13` | `9T` pin 2 feedback / `9H` pin 10 | input | no | `lb1_feedback_for_8m[3]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic feedback is LB line. |
| 4B | `8M` | `74LS157` | 11 | A input | `MBJ3*` | off-sheet `MBJ3*` | input | yes | `mbj_from_7n[3]` | CONFIRMED | full/left Sheet 4B crop | A-side fresh motion bit. |
| 4B | `8M` | `74LS157` | 12 | Y output | `D3` | `8L` pin 13 `D3` | output | no | `motion_buffer_data_from_8m[2]` | CONFIRMED | full/left Sheet 4B crop | Output to 93422 data input. |
| 4B | `8M` | `74LS157` | 13 | B input | `LB12` | `9T` pin 19 feedback / `9H` pin 6 | input | no | `lb1_feedback_for_8m[2]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Schematic feedback is LB line. |
| 4B | `8M` | `74LS157` | 14 | A input | `MBJ2*` | off-sheet `MBJ2*` | input | yes | `mbj_from_7n[2]` | CONFIRMED | full/left Sheet 4B crop | A-side fresh motion bit. |
| 4B | `8M` | `74LS157` | 15 | `/G` enable | `IVDBH` | off-sheet `IVDBH` | input | yes | `motion_buffer_8m_enable_n_from_ivdbh` | CONFIRMED | full/left Sheet 4B crop | LS157 enable pin is active-low. |
| 4B | `8J` | `93422` | 1 | A3 | address from `7J` QD | `7J` pin 11 | input | no | `motion_buffer_left_addr_from_7j_7k[3]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Active RTL bridge still has split compatibility addresses. |
| 4B | `8J` | `93422` | 2 | A2 | address from `7J` QC | `7J` pin 12 | input | no | `motion_buffer_left_addr_from_7j_7k[2]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Active RTL bridge still has split compatibility addresses. |
| 4B | `8J` | `93422` | 3 | A1 | address from `7J` QB | `7J` pin 13 | input | no | `motion_buffer_left_addr_from_7j_7k[1]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Active RTL bridge still has split compatibility addresses. |
| 4B | `8J` | `93422` | 4 | A0 | address from `7J` QA | `7J` pin 14 | input | no | `motion_buffer_left_addr_from_7j_7k[0]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Active RTL bridge still has split compatibility addresses. |
| 4B | `8J` | `93422` | 5 | A5 | address from `7K` QB | `7K` pin 13 | input | no | `motion_buffer_left_addr_from_7j_7k[5]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Address line readable. |
| 4B | `8J` | `93422` | 6 | A6 | address from `7K` QC | `7K` pin 12 | input | no | `motion_buffer_left_addr_from_7j_7k[6]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Address line readable. |
| 4B | `8J` | `93422` | 7 | A7 | address from `7K` QD | `7K` pin 11 | input | no | `motion_buffer_left_addr_from_7j_7k[7]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Address line readable. |
| 4B | `8J` | `93422` | 9 | D1 | `D1` from `8K` | `8K` pin 4 | input | no | `motion_buffer_data_from_8k[0]` | CONFIRMED | full/top Sheet 4B crop | Data line readable. |
| 4B | `8J` | `93422` | 10 | O1 | `LB00` | `9T` pin 7 D and feedback to `8K` pin 10 | output | no | `lb0_from_8j[0]` | CONFIRMED | full/top/9T crops | Output line readable. |
| 4B | `8J` | `93422` | 11 | D2 | `D2` from `8K` | `8K` pin 7 | input | no | `motion_buffer_data_from_8k[1]` | CONFIRMED | full/top Sheet 4B crop | Data line readable. |
| 4B | `8J` | `93422` | 12 | O2 | `LB01` | `9T` pin 14 D and feedback to `8K` pin 6 | output | no | `lb0_from_8j[1]` | CONFIRMED | full/top/9T crops | Output line readable. |
| 4B | `8J` | `93422` | 13 | D3 | `D3` from `8K` | `8K` pin 12 | input | no | `motion_buffer_data_from_8k[2]` | CONFIRMED | full/top Sheet 4B crop | Data line readable. |
| 4B | `8J` | `93422` | 14 | O3 | `LB02` | `9T` pin 13 D and feedback to `8K` pin 13 | output | no | `lb0_from_8j[2]` | CONFIRMED | full/top/9T crops | Output line readable. |
| 4B | `8J` | `93422` | 15 | D4 | `D4` from `8K` | `8K` pin 9 | input | no | `motion_buffer_data_from_8k[3]` | CONFIRMED | full/top Sheet 4B crop | Data line readable. |
| 4B | `8J` | `93422` | 16 | O4 | `LB03` | `9T` pin 8 D and feedback to `8K` pin 3 | output | no | `lb0_from_8j[3]` | CONFIRMED | full/top/9T crops | Output line readable. |
| 4B | `8J` | `93422` | 17 | CS2 | tied active via grounded rail/`PR174` | ground/pull network | input | yes | `motion_buffer_cs2_n_from_8j_8l = 1'b0` | CONFIRMED | full/top Sheet 4B crop | Grounded tie/pull network visible. |
| 4B | `8J` | `93422` | 18 | OE | tied active via grounded rail/`PR174` | ground/pull network | input | yes | `motion_buffer_oe_n_from_8j_8l = 1'b0` | CONFIRMED | full/top Sheet 4B crop | Grounded tie/pull network visible. |
| 4B | `8J` | `93422` | 19 | CS1 | tied active via grounded rail/`PR174` | ground/pull network | input | yes | `motion_buffer_cs1_n_from_8j_8l = 1'b0` | CONFIRMED | full/top Sheet 4B crop | Grounded tie/pull network visible. |
| 4B | `8J` | `93422` | 20 | WE | `B5M` | off-sheet timing rail | input | yes | `motion_buffer_we_n_from_8j_8l = !bsm` | CONFIRMED | full/top Sheet 4B crop | Fresh Sheet 4B review confirms label is `B5M`; 93422 WE pin is active-low. |
| 4B | `8J` | `93422` | 21 | A4 | address from `7K` QA | `7K` pin 14 | input | no | `motion_buffer_left_addr_from_7j_7k[4]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Address line readable. |
| 4B | `8L` | `93422` | 1 | A3 | address from `7L` QD | `7L` pin 11 | input | no | `motion_buffer_right_addr_from_7l_7m[3]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Active RTL bridge still has split compatibility addresses. |
| 4B | `8L` | `93422` | 2 | A2 | address from `7L` QC | `7L` pin 12 | input | no | `motion_buffer_right_addr_from_7l_7m[2]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Address line readable. |
| 4B | `8L` | `93422` | 3 | A1 | address from `7L` QB | `7L` pin 13 | input | no | `motion_buffer_right_addr_from_7l_7m[1]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Address line readable. |
| 4B | `8L` | `93422` | 4 | A0 | address from `7L` QA | `7L` pin 14 | input | no | `motion_buffer_right_addr_from_7l_7m[0]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Address line readable. |
| 4B | `8L` | `93422` | 5 | A5 | address from `7M` QB | `7M` pin 13 | input | no | `motion_buffer_right_addr_from_7l_7m[5]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Address line readable. |
| 4B | `8L` | `93422` | 6 | A6 | address from `7M` QC | `7M` pin 12 | input | no | `motion_buffer_right_addr_from_7l_7m[6]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Address line readable. |
| 4B | `8L` | `93422` | 7 | A7 | address from `7M` QD | `7M` pin 11 | input | no | `motion_buffer_right_addr_from_7l_7m[7]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Address line readable. |
| 4B | `8L` | `93422` | 9 | D1 | `D1` from `8M` | `8M` pin 4 | input | no | `motion_buffer_data_from_8m[0]` | CONFIRMED | full/left Sheet 4B crop | Data line readable. |
| 4B | `8L` | `93422` | 10 | O1 | `LB10` | `9T` pin 4 D and feedback to `8M` pin 3 | output | no | `lb1_from_8l[0]` | CONFIRMED | full/left/9T crops | Output line readable. |
| 4B | `8L` | `93422` | 11 | D2 | `D2` from `8M` | `8M` pin 7 | input | no | `motion_buffer_data_from_8m[1]` | CONFIRMED | full/left Sheet 4B crop | Data line readable. |
| 4B | `8L` | `93422` | 12 | O2 | `LB11` | `9T` pin 17 D and feedback to `8M` pin 6 | output | no | `lb1_from_8l[1]` | CONFIRMED | full/left/9T crops | Output line readable. |
| 4B | `8L` | `93422` | 13 | D3 | `D3` from `8M` | `8M` pin 12 | input | no | `motion_buffer_data_from_8m[2]` | CONFIRMED | full/left Sheet 4B crop | Data line readable. |
| 4B | `8L` | `93422` | 14 | O3 | `LB12` | `9T` pin 18 D and feedback to `8M` pin 13 | output | no | `lb1_from_8l[2]` | CONFIRMED | full/left/9T crops | Output line readable. |
| 4B | `8L` | `93422` | 15 | D4 | `D4` from `8M` | `8M` pin 9 | input | no | `motion_buffer_data_from_8m[3]` | CONFIRMED | full/left Sheet 4B crop | Data line readable. |
| 4B | `8L` | `93422` | 16 | O4 | `LB13` | `9T` pin 3 D and feedback to `8M` pin 10 | output | no | `lb1_from_8l[3]` | CONFIRMED | full/left/9T crops | Output line readable. |
| 4B | `8L` | `93422` | 17 | CS2 | tied active via grounded rail/`PR174` | ground/pull network | input | yes | `motion_buffer_cs2_n_from_8j_8l = 1'b0` | CONFIRMED | full/left Sheet 4B crop | Grounded tie/pull network visible. |
| 4B | `8L` | `93422` | 18 | OE | tied active via grounded rail/`PR174` | ground/pull network | input | yes | `motion_buffer_oe_n_from_8j_8l = 1'b0` | CONFIRMED | full/left Sheet 4B crop | Grounded tie/pull network visible. |
| 4B | `8L` | `93422` | 19 | CS1 | tied active via grounded rail/`PR174` | ground/pull network | input | yes | `motion_buffer_cs1_n_from_8j_8l = 1'b0` | CONFIRMED | full/left Sheet 4B crop | Grounded tie/pull network visible. |
| 4B | `8L` | `93422` | 20 | WE | `B5M` | off-sheet timing rail | input | yes | `motion_buffer_we_n_from_8j_8l = !bsm` | CONFIRMED | full/left Sheet 4B crop | Fresh Sheet 4B review confirms label is `B5M`; 93422 WE pin is active-low. |
| 4B | `8L` | `93422` | 21 | A4 | address from `7M` QA | `7M` pin 14 | input | no | `motion_buffer_right_addr_from_7l_7m[4]` | PLACEHOLDER_IN_RTL | full/left Sheet 4B crop | Address line readable. |
| 4B | `9T` | `74LS273` | 1 | `/CLR` | pullup rail `PR174` | `PR174`, held inactive | input | yes | `motion_buffer_9t_clear_n_from_sheet = 1'b1` | CONFIRMED | full/9T-9H crop | Clear tied inactive via pullup. |
| 4B | `9T` | `74LS273` | 2 | Q | `LB13` | feedback to `8M` pin 10 and `9H` pin 10 | output | no | `lb1_from_9t[3]` | CONFIRMED | full/9T-9H crop | Output label readable. |
| 4B | `9T` | `74LS273` | 3 | D | `O4` from `8L` | `8L` pin 16 | input | no | `lb1_from_8l[3]` | CONFIRMED | full/9T-9H crop | Input path readable. |
| 4B | `9T` | `74LS273` | 4 | D | `O1` from `8L` | `8L` pin 10 | input | no | `lb1_from_8l[0]` | CONFIRMED | full/9T-9H crop | Input path readable. |
| 4B | `9T` | `74LS273` | 5 | Q | `LB10` | feedback to `8M` pin 3 and `9H` pin 3 | output | no | `lb1_from_9t[0]` | CONFIRMED | full/9T-9H crop | Output label readable. |
| 4B | `9T` | `74LS273` | 6 | Q | `LB00` | feedback to `8K` pin 10 and `9H` pin 2 | output | no | `lb0_from_9t[0]` | CONFIRMED | full/9T-9H crop | Output label readable. |
| 4B | `9T` | `74LS273` | 7 | D | `O1` from `8J` | `8J` pin 10 | input | no | `lb0_from_8j[0]` | CONFIRMED | full/9T-9H crop | Input path readable. |
| 4B | `9T` | `74LS273` | 8 | D | `O4` from `8J` | `8J` pin 16 | input | no | `lb0_from_8j[3]` | CONFIRMED | full/9T-9H crop | Input path readable. |
| 4B | `9T` | `74LS273` | 9 | Q | `LB03` | feedback to `8K` pin 3 and `9H` pin 11 | output | no | `lb0_from_9t[3]` | CONFIRMED | full/9T-9H crop | Output label readable. |
| 4B | `9T` | `74LS273` | 11 | CLK | `B5M` | off-sheet timing rail | input | no | `motion_buffer_9t_clk_en_from_bsm = bsm` | CONFIRMED | full/9T-9H crop | Fresh Sheet 4B review confirms label is `B5M`. |
| 4B | `9T` | `74LS273` | 12 | Q | `LB02` | feedback to `8K` pin 13 and `9H` pin 5 | output | no | `lb0_from_9t[2]` | CONFIRMED | full/9T-9H crop | Output label readable. |
| 4B | `9T` | `74LS273` | 13 | D | `O3` from `8J` | `8J` pin 14 | input | no | `lb0_from_8j[2]` | CONFIRMED | full/9T-9H crop | Input path readable. |
| 4B | `9T` | `74LS273` | 14 | D | `O2` from `8J` | `8J` pin 12 | input | no | `lb0_from_8j[1]` | CONFIRMED | full/9T-9H crop | Input path readable. |
| 4B | `9T` | `74LS273` | 15 | Q | `LB01` | feedback to `8K` pin 6 and `9H` pin 14 | output | no | `lb0_from_9t[1]` | CONFIRMED | full/9T-9H crop | Output label readable. |
| 4B | `9T` | `74LS273` | 16 | Q | `LB11` | feedback to `8M` pin 6 and `9H` pin 13 | output | no | `lb1_from_9t[1]` | CONFIRMED | full/9T-9H crop | Output label readable. |
| 4B | `9T` | `74LS273` | 17 | D | `O2` from `8L` | `8L` pin 12 | input | no | `lb1_from_8l[1]` | CONFIRMED | full/9T-9H crop | Input path readable. |
| 4B | `9T` | `74LS273` | 18 | D | `O3` from `8L` | `8L` pin 14 | input | no | `lb1_from_8l[2]` | CONFIRMED | full/9T-9H crop | Input path readable. |
| 4B | `9T` | `74LS273` | 19 | Q | `LB12` | feedback to `8M` pin 13 and `9H` pin 6 | output | no | `lb1_from_9t[2]` | CONFIRMED | full/9T-9H crop | Output label readable. |
| 4B | `9H` | `74LS157` | 1 | Select | `VDBH` | off-sheet `VDBH` | input | no | `motion_buffer_9h_select_from_vdbh` | CONFIRMED | 9H final selector crop | Select line readable. |
| 4B | `9H` | `74LS157` | 2 | A input | `LB00` | `9T` pin 6 | input | no | `lb0_from_9t[0]` | CONFIRMED | 9H final selector crop | Pin label readable. |
| 4B | `9H` | `74LS157` | 3 | B input | `LB10` | `9T` pin 5 | input | no | `lb1_from_9t[0]` | CONFIRMED | 9H final selector crop | Pin label readable. |
| 4B | `9H` | `74LS157` | 4 | Y output | `MBIT0` | video logic; `9K` input | output | no | `mbit_from_9h[0]` | CONFIRMED | 9H final selector crop | Output label readable. |
| 4B | `9H` | `74LS157` | 5 | A input | `LB02` | `9T` pin 12 | input | no | `lb0_from_9t[2]` | CONFIRMED | full/9H crop | Corrected review mapping. |
| 4B | `9H` | `74LS157` | 6 | B input | `LB12` | `9T` pin 19 | input | no | `lb1_from_9t[2]` | CONFIRMED | full/9H crop | Corrected review mapping. |
| 4B | `9H` | `74LS157` | 7 | Y output | `MBIT2` | video logic; `9K` input | output | no | `mbit_from_9h[2]` | CONFIRMED | full/9H crop | Output label readable. |
| 4B | `9H` | `74LS157` | 9 | Y output | `MBIT3` | video logic; `9K` input | output | no | `mbit_from_9h[3]` | CONFIRMED | full/9H crop | Output label readable. |
| 4B | `9H` | `74LS157` | 10 | B input | `LB13` | `9T` pin 2 | input | no | `lb1_from_9t[3]` | CONFIRMED | full/9H crop | Pin label readable. |
| 4B | `9H` | `74LS157` | 11 | A input | `LB03` | `9T` pin 9 | input | no | `lb0_from_9t[3]` | CONFIRMED | full/9H crop | Pin label readable. |
| 4B | `9H` | `74LS157` | 12 | Y output | `MBIT1` | video logic; `9K` input | output | no | `mbit_from_9h[1]` | CONFIRMED | full/9H crop | Output label readable. |
| 4B | `9H` | `74LS157` | 13 | B input | `LB11` | `9T` pin 16 | input | no | `lb1_from_9t[1]` | CONFIRMED | full/9H crop | Corrected review mapping. |
| 4B | `9H` | `74LS157` | 14 | A input | `LB01` | `9T` pin 15 | input | no | `lb0_from_9t[1]` | CONFIRMED | full/9H crop | Corrected review mapping. |
| 4B | `9H` | `74LS157` | 15 | `/G` enable | ground | direct ground | input | yes | tied active | CONFIRMED | full/9H crop | LS157 enable tied active-low. |
| 4B | `6F` | `74LS74` | 1 | `/CLR` | pullup rail `PR173` | `PR173` | input | yes | not separately modeled | NOT_IMPLEMENTED | full/top Sheet 4B crop | Video/color path; clear tied inactive by pullup. |
| 4B | `6F` | `74LS74` | 2 | D | `128H` | off-sheet timing rail | input | no | approximate video timing | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Input label readable. |
| 4B | `6F` | `74LS74` | 3 | CLK | `B8H` | off-sheet timing rail | input | no | approximate video timing | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Clock label readable. |
| 4B | `6F` | `74LS74` | 4 | `/PRE` | pullup rail `PR173` | `PR173` | input | yes | not separately modeled | NOT_IMPLEMENTED | full/top Sheet 4B crop | Preset tied inactive by pullup. |
| 4B | `6F` | `74LS74` | 5 | Q | video timing select | feeds `10H`/`10J` select path | output | no | approximate video timing | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Destination line visible into video mux region. |
| 4B | `6F` | `74LS74` | 6 | `/Q` | not connected | no visible downstream use | output | yes | not separately modeled | NOT_RELEVANT_TO_RTL | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed no hidden connection. |
| 4B | `10H` | `74LS153` | 1 | `/1G` | ground | direct ground | input | yes | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Enable tied active. |
| 4B | `10H` | `74LS153` | 2 | B select | `COLSEL0` | off-sheet/control logic | input | no | color select logic | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 3 | `C1` input | `PBIT3` | playfield bit | input | no | playfield/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 4 | `C2` input | `MBIT3` | `9H` output / motion bit | input | no | `mbit_from_9h[3]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 5 | `C3` input | `PABA3` | CPU/address related off-sheet net | input | no | cpu address/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 6 | `C0` input | `PBIT2` | playfield bit | input | no | playfield/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 7 | Y output | `COLA2` | off-sheet/final color output | output | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Output label readable. |
| 4B | `10H` | `74LS153` | 9 | Y output | `COLA3` | off-sheet/final color output | output | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Output label readable. |
| 4B | `10H` | `74LS153` | 10 | `C0` input | `PBIT3` | playfield bit | input | no | playfield/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 11 | `C1` input | `6F` pin 5 | `6F` Q output | input | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `10H` | `74LS153` | 12 | `C2` input | `MBIT3` | `9H` output / motion bit | input | no | `mbit_from_9h[3]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 13 | `C3` input | `PABA3` | CPU/address related off-sheet net | input | no | cpu address/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 14 | A select | `COLSEL0` | off-sheet/control logic | input | no | color select logic | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10H` | `74LS153` | 15 | `/2G` | ground | direct ground | input | yes | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Enable tied active. |
| 4B | `10J` | `74LS153` | 1 | `/1G` | ground | direct ground | input | yes | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Enable tied active. |
| 4B | `10J` | `74LS153` | 2 | B select | `COLSEL0` | off-sheet/control logic | input | no | color select logic | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 3 | `C1` input | `PABA0` | CPU/address related off-sheet net | input | no | cpu address/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 4 | `C2` input | `MBIT0` | `9H` output / motion bit | input | no | `mbit_from_9h[0]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 5 | `C1` input | `BMAP2` | bitmap bit | input | no | bitmap/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 6 | `C0` input | `PBIT0` | playfield bit | input | no | playfield/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 7 | Y output | `COLA0` | off-sheet/final color output | output | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Output label readable. |
| 4B | `10J` | `74LS153` | 9 | Y output | `COLA1` | off-sheet/final color output | output | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Output label readable. |
| 4B | `10J` | `74LS153` | 10 | `C0` input | `PBIT1` | playfield bit | input | no | playfield/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 11 | `C1` input | `BMAP1` | bitmap bit | input | no | bitmap/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 12 | `C2` input | `MBIT1` | `9H` output / motion bit | input | no | `mbit_from_9h[1]` | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 13 | `C3` input | `PABA1` | CPU/address related off-sheet net | input | no | cpu address/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 14 | A select | `COLSEL0` | off-sheet/control logic | input | no | color select logic | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Label readable. |
| 4B | `10J` | `74LS153` | 15 | `/2G` | ground | direct ground | input | yes | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Enable tied active. |
| 4B | `11J` | `74LS157` | 1 | Select | `COLRAM` | off-sheet `COLRAM` | input | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Corrected review mapping. |
| 4B | `11J` | `74LS157` | 2 | A input | pull-up rail `PR176` | `PR176` pull-up rail | tied | no | color path | CONFIRMED | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed pull-up rail `PR176`. |
| 4B | `11J` | `74LS157` | 3 | B input | pull-up rail `PR176` | `PR176` pull-up rail | tied | no | color path | CONFIRMED | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed pull-up rail `PR176`. |
| 4B | `11J` | `74LS157` | 4 | Y output | unused/local output | no visible labelled destination | output | no | color path | NOT_RELEVANT_TO_RTL | full/top Sheet 4B crop | Output not listed in review; no labelled destination visible. |
| 4B | `11J` | `74LS157` | 5 | A input | `PABA4` | off-sheet `PABA4` | input | no | cpu address/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Corrected review mapping. |
| 4B | `11J` | `74LS157` | 6 | B input | `COLSEL0` | lower Sheet 4B color select logic | input | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Corrected review mapping. |
| 4B | `11J` | `74LS157` | 7 | Y output | `COLA4` | off-sheet/final color output | output | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Corrected review mapping. |
| 4B | `11J` | `74LS157` | 9 | Y output | `COLA5` | off-sheet/final color output | output | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Corrected review mapping. |
| 4B | `11J` | `74LS157` | 10 | B input | `COLSEL1` | lower Sheet 4B color select logic | input | no | color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Corrected review mapping. |
| 4B | `11J` | `74LS157` | 11 | A input | `PABA5` | off-sheet `PABA5` | input | no | cpu address/color path | PLACEHOLDER_IN_RTL | full/top Sheet 4B crop | Corrected review mapping. |
| 4B | `11J` | `74LS157` | 12 | Y output | unused/local output | no visible labelled destination | output | no | color path | NOT_RELEVANT_TO_RTL | full/top Sheet 4B crop | Output not listed in review; no labelled destination visible. |
| 4B | `11J` | `74LS157` | 13 | B input | pull-up rail `PR176` | `PR176` pull-up rail | tied | no | color path | CONFIRMED | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed pull-up rail `PR176`. |
| 4B | `11J` | `74LS157` | 14 | A input | pull-up rail `PR176` | `PR176` pull-up rail | tied | no | color path | CONFIRMED | full/top Sheet 4B crop / visual-check CSV | Reviewer confirmed pull-up rail `PR176`. |
| 4B | `11J` | `74LS157` | 15 | `/G` enable | ground | direct ground | input | yes | color path | CONFIRMED | full/top Sheet 4B crop | Enable tied active. |
| 4B | `9K` | `74LS260` | 1 | input | `MBIT3` | `9H` output/local `MBIT3` net | input | no | `mbit_from_9h[3]` | CONFIRMED | full Sheet 4B crop | Lower video logic label readable. |
| 4B | `9K` | `74LS260` | 2 | input | `MBIT2` | `9H` output/local `MBIT2` net | input | no | `mbit_from_9h[2]` | CONFIRMED | full Sheet 4B crop | Lower video logic label readable. |
| 4B | `9K` | `74LS260` | 3 | input | `MBIT1` | `9H` output/local `MBIT1` net | input | no | `mbit_from_9h[1]` | CONFIRMED | full Sheet 4B crop | Lower video logic label readable. |
| 4B | `9K` | `74LS260` | 12 | input | `MBIT0` | `9H` output/local `MBIT0` net | input | no | `mbit_from_9h[0]` | CONFIRMED | full Sheet 4B crop | Lower video logic label readable. |
| 4B | `9K` | `74LS260` | 13 | input | ground | direct ground | input | no | tied low | CONFIRMED | full Sheet 4B crop | Fifth input tied low. |
| 4B | `9K` | `74LS260` | 5 | output | motion-zero detect | `8E` pin 1 and `8C` pin 3 branch | output | yes | motion zero/COLSEL logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop | Output polarity from LS260 function; exact net label absent. |
| 4B | `8C` | `74LS04` | 3 | input | `9K` pin 5 | `9K` pin 5 | input | no | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `8C` | `74LS04` | 4 | output | inverted motion-zero branch | `8D` pin 4 | output | yes | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `8D` | `74LS32` | 4 | OR input | `8C` output branch | `8C` pin 4 | input | no | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `8D` | `74LS32` | 5 | OR input | `1L` output branch | `1L` pin 12 | input | no | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed; old bitmap inputs are at `1L`, not additional visible `8D` gates. |
| 4B | `8D` | `74LS32` | 6 | OR output | `8E` input branch | `8E` pin 12 | output | no | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `1L` | `74LS27` | 1 | NOR input | `BMAP2` | off-sheet `BMAP2` | input | no | bitmap/color path | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `1L` | `74LS27` | 2 | NOR input | `BMAP1` | off-sheet `BMAP1` | input | no | bitmap/color path | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `1L` | `74LS27` | 13 | NOR input | `BMAP0` | off-sheet `BMAP0` | input | no | bitmap/color path | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `1L` | `74LS27` | 12 | NOR output | bitmap-zero branch | `8D` pin 5 | output | yes | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `8E` | `74LS00` | 1 | input | `9K` output branch | `9K` pin 5 | input | no | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer checked. |
| 4B | `8E` | `74LS00` | 2 | input | `/COLRAM` | off-sheet `COLRAM` | input | no | color RAM select | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer checked; label includes active-low bar in visual table. |
| 4B | `8E` | `74LS00` | 3 | output | `COLSEL1` | off-sheet `COLSEL1` | output | yes | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer checked. |
| 4B | `8E` | `74LS00` | 12 | input | `8D` output branch | `8D` pin 6 | input | no | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `8E` | `74LS00` | 13 | input | `COLRAM` | off-sheet `COLRAM` | input | no | color RAM select | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |
| 4B | `8E` | `74LS00` | 11 | output | `COLSEL0` | off-sheet `COLSEL0` | output | yes | color select logic | PLACEHOLDER_IN_RTL | full Sheet 4B crop / visual-check CSV | Reviewer confirmed. |

## Cross-sheet net references

| Net label | Appears on Sheet 4B as | Direction on Sheet 4B | Suspected source/destination sheet | Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `B5M` | Counter clocks, 93422 WE, 9T clock | input timing rail | Sheet 6B `3D` -> Sheet 2A `1R/8C` timing/interconnect | CONFIRMED | Fresh Sheet 4B review confirms visible label is `B5M`; source chain is now traced as `5MHZ -> Sheet 6B 3D pin 11 -> 3D pin 9 E5M -> J17 pin 31 -> Sheet 2A 1R pins 2/17 -> 1R pins 18/3 and 8C -> B5M*/B5M`. |
| `MOHLO` | `7J/7K` `/LOAD` | input control | Sheet 4A `1H` decode | CONFIRMED | Local label readable. |
| `MOHRO` | `7J/7K` `/CLR` | input control | Sheet 4A `8F` decode | CONFIRMED | Local label readable. |
| `MOHLI` | `7L/7M` `/LOAD`, `8K` select | input control | Sheet 4A `1H` decode | CONFIRMED | Local label readable. |
| `MOHRI` | `7L/7M` `/CLR`, `8M` select | input control | Sheet 4A `8F` decode | CONFIRMED | Local label readable. |
| `MOD0..MOD7` | Counter preload inputs | input data/control | Sheet 4A/object scan or motion RAM decode | CONFIRMED | Local labels readable; source sheet not audited here. |
| `MBJ0*..MBJ3*` | `8K/8M` A inputs | input motion pixel data | Sheet 4A `7N` output | CONFIRMED | Local labels readable; exact star/complement semantics require Sheet 4A audit. |
| `IVDBH` | `8K/8M` active-low enable | input timing/control | Sheet 4A `7F` | CONFIRMED | Local label readable. |
| `VDBH` | `9H` select | input timing/control | timing/video sheets | CONFIRMED | Local label readable. |
| `LB00..LB03` | 9T outputs and 8K feedback | local feedback/data | local Sheet 4B loop | CONFIRMED | Internal Sheet 4B loop. |
| `LB10..LB13` | 9T outputs and 8M feedback | local feedback/data | local Sheet 4B loop | CONFIRMED | Internal Sheet 4B loop. |
| `MBIT0..MBIT3` | final motion bits into video logic | output/local video input | Sheet 4B video section and off-sheet color path | CONFIRMED | Local labels readable. |
| `128H` | `6F` D input | input timing rail | timing sheets | CONFIRMED | Local label readable. |
| `B8H` | `6F` clock | input timing rail | Sheet 2A/timing sheets | CONFIRMED | Local label readable. |
| `COLSEL0` | video mux/select logic | input/output control depending node | Sheet 4B lower gates and off-sheet video | UNCLEAR_CONNECTION | Multiple appearances; needs video crop to distinguish source versus distributed net. |
| `COLSEL1` | video mux/select logic | input/output control depending node | Sheet 4B lower gates and off-sheet video | UNCLEAR_CONNECTION | Multiple appearances; needs video crop to distinguish source versus distributed net. |
| `PBIT0..PBIT3` | color mux inputs | input video data | playfield sheets | CONFIRMED | Local labels readable. |
| `BMAP0..BMAP2` | color mux/gate inputs | input bitmap data | bitmap/interconnect sheets | CONFIRMED | Local labels readable; lower video review routes them through `1L` pins 13/2/1, not extra visible `8D` gates. |
| `PABA0..PABA5` | color mux inputs | input CPU/address color data | master CPU/address sheets | CONFIRMED | Local labels readable where visible; `PABA4/5` lower-right visible. |
| `COLA0..COLA5` | color output rails | output video/color | downstream video DAC/color path | CONFIRMED | Local labels readable for `COLA0..COLA5`; some mux source pins still unclear. |
| `COLRAM` | lower gate select input | input control | memory/color RAM decode | CONFIRMED | Local label readable. |
| `B1H`, `B2H`, `B4H`, `B16H`, `B32H`, `B64H`, `B256H` | not clearly visible as Sheet 4B motion-buffer inputs in current crop | unknown | timing sheets | UNCLEAR_CONNECTION | User-listed candidates; this Sheet 4B crop clearly shows `B5M`, `B8H`, `128H`, and `VDBH`, but not all listed BxH rails. Need full-resolution Sheet 4B timing labels to confirm absence/presence. |
| `IVDSH` | not visible on Sheet 4B crop | not present/unclear | Sheet 4A `7F` | UNCLEAR_CONNECTION | `IVDBH` is visible; `IVDSH` is not clearly visible on Sheet 4B. |
| `BYTLOAD` | not visible on Sheet 4B crop | not present/unclear | Sheet 4A decode | UNCLEAR_CONNECTION | Appears on Sheet 4A, not confirmed on Sheet 4B crop. |
| `NIBLOAD` / `NIB LOAD` | not visible on Sheet 4B crop | not present/unclear | Sheet 4A LS194 control | UNCLEAR_CONNECTION | Not confirmed on Sheet 4B crop. |
| `LDNIB` | not visible on Sheet 4B crop | not present/unclear | unknown | UNCLEAR_CONNECTION | Not confirmed on Sheet 4B crop. |
| `LOF` | not visible on Sheet 4B crop | not present/unclear | Sheet 4A flip/load timing | UNCLEAR_CONNECTION | Not confirmed on Sheet 4B crop. |

## RTL comparison notes

| Relevant net | Current RTL equivalent | Classification | Notes |
| --- | --- | --- | --- |
| `B5M` | `wire bsm = ce_5m` | APPROXIMATE | RTL uses broad 5 MHz enable under the legacy signal name `bsm`. Sheet 4B label is confirmed `B5M`, and the cross-sheet source chain is now traced from `5MHZ` through Sheet 6B `3D`, J17 pin 31, and Sheet 2A `1R` pins 2/17 to the `B5M*`/`B5M` distribution. Because FPGA clocks/enables are generated internally, the missing structural LS244/LS04 model is less important than preserving the correct timing family, phase, and destination pins. |
| `ivdbh_from_7f` | `ivdbh_from_7f = u_7f_ivdb_latch.q_n` | APPROXIMATE | Sheet 4B pin destination is exact for `8K/8M` enables; upstream `IV` and `B8H` timing remain provisional. |
| `ivdsh_from_7f` | `ivdsh_from_7f = u_7f_ivdb_latch.q` | APPROXIMATE | Not visible on Sheet 4B; relevant through Sheet 4A/7F timing. |
| `mohli_n` | active RTL aliases `mohli_decoded_n = moh_left_decode_n[1]` | RTL_MISMATCH | Sheet 4B local destination is `MOHLI`; corrected Sheet 4A pin audit says `1H Y0 = /MOHLI`, while active RTL aliases remain provisional/reversed. |
| `mohlo_n` / `mohld_n` | active RTL aliases `mohlo_decoded_n = moh_left_decode_n[0]` | RTL_MISMATCH | Sheet 4B local destination is `MOHLO`; corrected Sheet 4A pin audit says `1H Y1 = /MOHLO`, while active RTL aliases remain provisional/reversed. |
| `mohri_n` | `mohri_decoded_n = moh_right_decode_n[2]` | APPROXIMATE | Sheet 4B local destination is exact; upstream `8F` timing remains provisional. |
| `mohro_n` | `mohro_decoded_n = moh_right_decode_n[1]` | APPROXIMATE | Sheet 4B local destination is exact; upstream `8F` timing remains provisional. |
| `motion_buffer_8k_select` | `motion_buffer_8k_select_from_mohli_n` | EXACT | Sheet 4B pin 1 connection to `MOHLI` is represented structurally. Behaviour depends on upstream decode timing. |
| `motion_buffer_8m_select` | `motion_buffer_8m_select_from_mohri_n` | EXACT | Sheet 4B pin 1 connection to `MOHRI` is represented structurally. Behaviour depends on upstream decode timing. |
| `motion_buffer_8k_enable_n` | `motion_buffer_8k_enable_n_from_ivdbh` | EXACT | Sheet 4B pin 15 connection to `IVDBH` is represented structurally. Behaviour depends on upstream `IVDBH` timing. |
| `motion_buffer_8m_enable_n` | `motion_buffer_8m_enable_n_from_ivdbh` | EXACT | Sheet 4B pin 15 connection to `IVDBH` is represented structurally. Behaviour depends on upstream `IVDBH` timing. |
| `8K/8M A inputs` | `mbj_from_7n[3:0]` | APPROXIMATE | Sheet 4B A-input labels are `MBJ*`; source value/timing belongs to Sheet 4A. |
| `8K/8M B inputs` | compatibility bridge plus closed-loop probe feedback variants | PLACEHOLDER | The real schematic feeds back `LB0x/LB1x`; active visible path still uses compatibility line buffers. |
| `7J/7K/7L/7M preload MOD pins` | X-derived `motion_buffer_*_load_addr` | PLACEHOLDER | Schematic nets are `MOD0..MOD7`; RTL uses temporary renderer addresses. |
| `8J/8L address buses` | schematic counters exist plus compatibility split read/write bridge | PLACEHOLDER | Non-driving single-address probes exist; visible path still compatibility-derived. |
| `8J/8L WE` | `motion_buffer_we_n_from_8j_8l = !bsm` | APPROXIMATE | Pin polarity represented, but `bsm`/`B5M` phase/source is placeholder. |
| `8J/8L CS/OE` | tied active constants | EXACT | Schematic tie-active pins are represented structurally. |
| `9T latch inputs` | `{lb1_from_8l, lb0_from_8j}` in non-driving path; bridge path still compatibility-assisted | APPROXIMATE | Pin order represented; source lifetime not schematic-accurate in active visible path. |
| `9T latch outputs` | `lb0_from_9t`, `lb1_from_9t` | APPROXIMATE | Structural output names match; active path is not fully schematic-driven. |
| `9H selector nets` | `motion_buffer_9h_select_from_vdbh`, `mbit_from_9h` | EXACT | Sheet 4B selector pin mapping is represented structurally. Visible output still gated by behaviour switches. |
| `MBIT0..MBIT3 motion-zero detect` | color/COLSEL logic mostly collapsed elsewhere | MISSING | Sheet 4B lower video logic is not fully 1:1 RTL. |
| `10H/10J/11J/9K/8C/8D/1L/8E video color path` | existing playfield/bitmap/color logic | PLACEHOLDER | This task did not change RTL. The visual-check source confirms the lower-video path as `9K -> 8C/8E`, `1L -> 8D`, and `8D -> 8E`; RTL still needs separate later comparison if this path becomes behaviour-driving work. |

## Required Conclusion

1. Sheet 4B is now visually reviewed in the CSV/Markdown sense: the visual-check table has 225 rows, no remaining `Check` rows, and the detailed netlist has been synced to the reviewed lower-video corrections. From a detailed source-of-truth perspective, remaining limits are mostly cross-sheet source provenance and RTL comparison, not local Sheet 4B visual pin rows.
2. Previously unclear ICs/pins resolved by visual review:
   - `11J` pins 2, 3, 13, and 14 are confirmed tied to `PR176` pull-up rail.
   - `10H` pin 11 is confirmed from `6F` pin 5.
   - `6F` pin 6 is confirmed with no hidden connection.
   - `7K` and `7M` ENP/ENT cascade splits and final RIP no-connects are confirmed.
   - Lower video logic is corrected to one visible `8D` `74LS32` section at pins 4/5/6, plus `1L` `74LS27` pins 1/2/13 -> 12 feeding `8D` pin 5, and `8E` pins 12/13 -> 11 for `COLSEL0`.
3. Remaining local Sheet 4B cautions:
   - Rows still marked `High` in the visual-check file are accepted as visually reviewed but not individually promoted to `Checked`; treat the CSV as the human-review source for current confidence.
   - Any future RTL work on video/color should compare against this synced netlist rather than the older mistaken `8D` multi-gate interpretation.
4. Ambiguous labels:
   - Sheet 4B local timing label is now confirmed as `B5M`; source chain is traced through Sheet 6B `3D`, J17 pin 31, and Sheet 2A `1R` pins 2/17, while RTL still uses the legacy broad `bsm = ce_5m` alias.
   - `COLSEL0`/`COLSEL1` source/direction and active-low presentation need clearer lower-video and upper-video crops.
5. RTL placeholders or mismatches:
   - `bsm = ce_5m` is an approximate legacy alias for the corrected `B5M` timing family, not a structural model of the Sheet 6B/2A buffer chain. That is acceptable as a future implementation direction if the generated clock-enable phase/polarity is proven, because Verilog need not duplicate every physical distribution buffer.
   - `MOD0..MOD7` preload data is placeholder X-derived RTL.
   - `mohli_n` and `mohlo_n` active aliases are still mismatched against corrected Sheet 4A pin facts.
   - `8J/8L` active visible implementation still uses compatibility/split-buffer behaviour, not the one-address 93422 sheet path.
   - Sheet 4B video/COLSEL logic is not represented as a full pin-to-pin gate netlist in RTL.
6. Enough information now exists to continue to Sheet 4A from a local Sheet 4B visual-netlist standpoint. The main blockers for implementation are cross-sheet sources and phases, not missing local Sheet 4B lower-video pins.
7. Next sheet should be Sheet 4A, because Sheet 4B depends directly on `MBJ*`, `MOHLI/MOHLO/MOHRI/MOHRO`, `IVDBH`, `MOD0..MOD7`, and the motion-object source timing generated or decoded there. Sheet 2A/7A timing-source audits should follow when `B5M`, `B8H`, and related timing rails need source provenance.
