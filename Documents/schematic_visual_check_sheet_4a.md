# Schematic Visual Check - Sheet 4A

Reviewer-facing checklist generated from the Sheet 4A visual-check CSV. Keep this file and the CSV in sync; the CSV is the spreadsheet source for `.numbers` updates.

## Summary

- Rows: 186
- Check: 139
- High: 47

## Review Focus

Rows marked `Check` still need visual confirmation against the schematic crop/PDF. Do not promote them to `Checked` until the pin number, label, and connection are readable.

## Visual Check Table


| Sheet | Board | Section | IC | IC Type | Pin Number | Pin Function | Active Low | Connected To | Direction | Confidence | Reviewer Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 1 | /1G enable | Y | MORAM/PABR-W enable gate from 8D | Input | Check | Visible enable path near 2H; exact active-low equation needs focused review |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 2 | 1A1 input | N | MOD0 | Input | Check | Visible MOD0 input label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 4 | 1A2 input | N | MOD1 | Input | Check | Visible MOD1 input label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 6 | 1A3 input | N | MOD2 | Input | Check | Visible MOD2 input label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 8 | 1A4 input | N | MOD3 | Input | Check | Visible MOD3 input label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 11 | 2A1 input | N | MOD4 | Input | Check | Visible MOD4 input label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 13 | 2A2 input | N | MOD5 | Input | Check | Visible MOD5 input label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 15 | 2A3 input | N | MOD6 | Input | Check | Visible MOD6 input label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 17 | 2A4 input | N | MOD7 | Input | Check | Visible MOD7 input label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 18 | 1Y1 output | N | PABD0 | Output | Check | Visible PABD0 output label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 16 | 1Y2 output | N | PABD1 | Output | Check | Visible PABD1 output label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 14 | 1Y3 output | N | PABD2 | Output | Check | Visible PABD2 output label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 12 | 1Y4 output | N | PABD3 | Output | Check | Visible PABD3 output label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 9 | 2Y1 output | N | PABD4 | Output | Check | Visible PABD4 output label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 7 | 2Y2 output | N | PABD5 | Output | Check | Visible PABD5 output label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 5 | 2Y3 output | N | PABD6 | Output | Check | Visible PABD6 output label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 3 | 2Y4 output | N | PABD7 | Output | Check | Visible PABD7 output label |
| 4A | Master | Motion CPU Readback Buffer | 2H | 74LS244 | 19 | /2G enable | Y | MORAM/PABR-W enable gate from 8D | Input | Check | Visible enable path near 2H; exact active-low equation needs focused review |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 1 | Select | N | MORAM | Input | Check | Visible select label |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 2 | A input | N | PABA3 | Input | Check | Visible input label for MOPA3 mux |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 3 | B input | N | B8H | Input | Check | Visible input label for MOPA3 mux |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 4 | Y output | N | MOPA3 | Output | Check | Visible output label |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 5 | A input | N | PABA2 | Input | Check | Visible input label for MOPA2 mux |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 6 | B input | N | 16H | Input | Check | Visible input label for MOPA2 mux |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 7 | Y output | N | MOPA2 | Output | Check | Visible output label |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 9 | Y output | N | MOPA1 | Output | Check | Visible output label |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 10 | B input | N | 32H | Input | Check | Visible input label for MOPA1 mux |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 11 | A input | N | PABA1 | Input | Check | Visible input label for MOPA1 mux |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 12 | Y output | N | MOPA0 | Output | Check | Visible output label |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 13 | B input | N | 64H | Input | Check | Visible input label for MOPA0 mux |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 14 | A input | N | PABA0 | Input | Check | Visible input label for MOPA0 mux |
| 4A | Master | Motion Address Mux | 5M | 74LS157 | 15 | /G enable | Y | Tied ground active | Input | Check | Visible ground tie |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 1 | Select | N | MORAM | Input | Check | Visible select label |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 2 | A input | N | PABA7 | Input | Check | Visible input label for MOPA7 mux |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 3 | B input | N | B64H | Input | Check | Visible input label for MOPA7 mux |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 4 | Y output | N | MOPA7 | Output | Check | Visible output label |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 5 | A input | N | PABA6 | Input | Check | Visible input label for MOPA6 mux |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 6 | B input | N | B32H | Input | Check | Visible input label for MOPA6 mux |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 7 | Y output | N | MOPA6 | Output | Check | Visible output label |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 9 | Y output | N | MOPA5 | Output | Check | Visible output label |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 10 | B input | N | 128H | Input | Check | Visible input label for MOPA5 mux |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 11 | A input | N | PABA5 | Input | Check | Visible input label for MOPA5 mux |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 12 | Y output | N | MOPA4 | Output | Check | Visible output label |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 13 | B input | N | 256H | Input | Check | Visible input label for MOPA4 mux |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 14 | A input | N | PABA4 | Input | Check | Visible input label for MOPA4 mux |
| 4A | Master | Motion Address Mux | 5L | 74LS157 | 15 | /G enable | Y | Tied ground active | Input | Check | Visible ground tie |
| 4A | Master | Motion Object RAM | 6M | 2101A-2 | visible address pins | Address inputs | N | MOPA0..MOPA7 | Input | Check | Visible 2101A-2 package and MOPA address labels; needs dedicated crop for exact pin-by-pin order |
| 4A | Master | Motion Object RAM | 6M | 2101A-2 | visible data-in pins | Data inputs | N | PABD0/PABD2/PABD4/PABD6 | Input | Check | Visible PABD even-bit input labels to high nibble RAM; exact pins need focused review |
| 4A | Master | Motion Object RAM | 6M | 2101A-2 | visible data-out pins | Data outputs | N | MOD1/MOD3/MOD5/MOD7 | Output | Check | Visible odd MOD output labels; exact pins need focused review |
| 4A | Master | Motion Object RAM | 6M | 2101A-2 | WE/RW | R/W control | Y/N | PAWRITE / R-W path | Input | Check | Visible R/W control area; exact polarity needs focused review |
| 4A | Master | Motion Object RAM | 6L | 2101A-2 | visible address pins | Address inputs | N | MOPA0..MOPA7 | Input | Check | Visible 2101A-2 package and MOPA address labels; needs dedicated crop for exact pin-by-pin order |
| 4A | Master | Motion Object RAM | 6L | 2101A-2 | visible data-in pins | Data inputs | N | PABD1/PABD3/PABD5/PABD7 | Input | Check | Visible PABD odd-bit input labels to low nibble RAM; exact pins need focused review |
| 4A | Master | Motion Object RAM | 6L | 2101A-2 | visible data-out pins | Data outputs | N | MOD0/MOD2/MOD4/MOD6 | Output | Check | Visible even MOD output labels; exact pins need focused review |
| 4A | Master | Motion Object RAM | 6L | 2101A-2 | WE/RW | R/W control | Y/N | PAWRITE / R-W path | Input | Check | Visible R/W control area; exact polarity needs focused review |
| 4A | Master | Motion ROM Source | 6N | 2532 | 18 | Address input | N | MOPA11 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 19 | Address input | N | MOPA10 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 22 | Address input | N | MOPA9 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 23 | Address input | N | MOPA8 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 1 | Address input | N | MOPA7 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 2 | Address input | N | MOPA6 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 3 | Address input | N | MOPA5 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 4 | Address input | N | MOPA4 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 5 | Address input | N | MOPA3 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 6 | Address input | N | MOPA2 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 7 | Address input | N | MOPA1 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 8 | Address input | N | M14H | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 6N | 2532 | 17 | Data output | N | M7 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 6N | 2532 | 16 | Data output | N | M6 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 6N | 2532 | 15 | Data output | N | M5 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 6N | 2532 | 14 | Data output | N | M4 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 6N | 2532 | 13 | Data output | N | M3 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 6N | 2532 | 11 | Data output | N | M2 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 6N | 2532 | 10 | Data output | N | M1 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 6N | 2532 | 9 | Data output | N | M0 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 6N | 2532 | 20 | Chip select | Y | Tied low | Input | Check | Seeded from cached 6N/8R crop notes; visually confirm tie |
| 4A | Master | Motion ROM Source | 8R | 2532 | 18 | Address input | N | MOPA11 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 19 | Address input | N | MOPA10 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 22 | Address input | N | MOPA9 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 23 | Address input | N | MOPA8 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 1 | Address input | N | MOPA7 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 2 | Address input | N | MOPA6 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 3 | Address input | N | MOPA5 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 4 | Address input | N | MOPA4 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 5 | Address input | N | MOPA3 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 6 | Address input | N | MOPA2 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 7 | Address input | N | MOPA1 | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 8 | Address input | N | M14H | Input | Check | Split from 6N/8R address bus row; visually confirm exact label and route |
| 4A | Master | Motion ROM Source | 8R | 2532 | 17 | Data output | N | MF to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 8R | 2532 | 16 | Data output | N | ME to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 8R | 2532 | 15 | Data output | N | MD to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 8R | 2532 | 14 | Data output | N | MC to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 8R | 2532 | 13 | Data output | N | MB to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 8R | 2532 | 11 | Data output | N | MA to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 8R | 2532 | 10 | Data output | N | M9 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 8R | 2532 | 9 | Data output | N | M8 to LS194 parallel data bus | Output | Check | Split from cached ROM data row; visually confirm pin label |
| 4A | Master | Motion ROM Source | 8R | 2532 | 20 | Chip select | Y | Tied low | Input | Check | Seeded from cached 6N/8R crop notes; visually confirm tie |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 1 | /CLR | Y | Held inactive via PR171 | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 2 | Serial right input | N | Tied low | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 3 | Parallel input | N | M0 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 4 | Parallel input | N | M4 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 5 | Parallel input | N | M8 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 6 | Parallel input | N | MC from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 7 | Serial left input | N | Tied low | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 9 | S0 mode select | N | 10D pin 8 common S0 rail | Input | High | Confirmed in LS194/10C/10D crop |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 10 | S1 mode select | N | 10C pin 6 common S1 rail | Input | High | Confirmed in LS194/10C/10D crop |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 11 | CLK | N | B5M / legacy BSM timing rail | Input | Check | Destination confirmed; local label may still need re-crop from BSM to B5M |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 12 | Q3 output | N | MBJ0 normal output to 7N | Output | Check | Pin/net mapping exact in audit; timing/tap meaning still needs visual confirmation |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 13 | Q2 output | N | intermediate tap | Output | Check | Exposed for audit classification; visually confirm no labelled off-sheet net |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 14 | Q1 output | N | intermediate tap | Output | Check | Exposed for audit classification; visually confirm no labelled off-sheet net |
| 4A | Master | Motion Shift Registers | 6R | 74LS194 | 15 | Q0 output | N | MBJ0F flipped output to 7N | Output | Check | Pin/net mapping exact in audit; timing/tap meaning still needs visual confirmation |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 1 | /CLR | Y | Held inactive via PR171 | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 2 | Serial right input | N | Tied low | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 3 | Parallel input | N | M1 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 4 | Parallel input | N | M5 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 5 | Parallel input | N | M9 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 6 | Parallel input | N | MD from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 7 | Serial left input | N | Tied low | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 9 | S0 mode select | N | 10D pin 8 common S0 rail | Input | High | Confirmed in LS194/10C/10D crop |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 10 | S1 mode select | N | 10C pin 6 common S1 rail | Input | High | Confirmed in LS194/10C/10D crop |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 11 | CLK | N | B5M / legacy BSM timing rail | Input | Check | Destination confirmed; local label may still need re-crop from BSM to B5M |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 12 | Q3 output | N | MBJ1 normal output to 7N | Output | Check | Pin/net mapping exact in audit; timing/tap meaning still needs visual confirmation |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 13 | Q2 output | N | intermediate tap | Output | Check | Exposed for audit classification; visually confirm no labelled off-sheet net |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 14 | Q1 output | N | intermediate tap | Output | Check | Exposed for audit classification; visually confirm no labelled off-sheet net |
| 4A | Master | Motion Shift Registers | 6P | 74LS194 | 15 | Q0 output | N | MBJ1F flipped output to 7N | Output | Check | Pin/net mapping exact in audit; timing/tap meaning still needs visual confirmation |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 1 | /CLR | Y | Held inactive via PR171 | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 2 | Serial right input | N | Tied low | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 3 | Parallel input | N | M2 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 4 | Parallel input | N | M6 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 5 | Parallel input | N | MA from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 6 | Parallel input | N | ME from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 7 | Serial left input | N | Tied low | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 9 | S0 mode select | N | 10D pin 8 common S0 rail | Input | High | Confirmed in LS194/10C/10D crop |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 10 | S1 mode select | N | 10C pin 6 common S1 rail | Input | High | Confirmed in LS194/10C/10D crop |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 11 | CLK | N | B5M / legacy BSM timing rail | Input | Check | Destination confirmed; local label may still need re-crop from BSM to B5M |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 12 | Q3 output | N | MBJ2 normal output to 7N | Output | Check | Pin/net mapping exact in audit; timing/tap meaning still needs visual confirmation |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 13 | Q2 output | N | intermediate tap | Output | Check | Exposed for audit classification; visually confirm no labelled off-sheet net |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 14 | Q1 output | N | intermediate tap | Output | Check | Exposed for audit classification; visually confirm no labelled off-sheet net |
| 4A | Master | Motion Shift Registers | 7R | 74LS194 | 15 | Q0 output | N | MBJ2F flipped output to 7N | Output | Check | Pin/net mapping exact in audit; timing/tap meaning still needs visual confirmation |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 1 | /CLR | Y | Held inactive via PR171 | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 2 | Serial right input | N | Tied low | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 3 | Parallel input | N | M3 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 4 | Parallel input | N | M7 from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 5 | Parallel input | N | MB from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 6 | Parallel input | N | MF from motion ROM data bus | Input | High | Split from exact LS194 parallel-input pin audit |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 7 | Serial left input | N | Tied low | Input | High | Seeded from LS194 wide crop |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 9 | S0 mode select | N | 10D pin 8 common S0 rail | Input | High | Confirmed in LS194/10C/10D crop |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 10 | S1 mode select | N | 10C pin 6 common S1 rail | Input | High | Confirmed in LS194/10C/10D crop |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 11 | CLK | N | B5M / legacy BSM timing rail | Input | Check | Destination confirmed; local label may still need re-crop from BSM to B5M |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 12 | Q3 output | N | MBJ3 normal output to 7N | Output | Check | Pin/net mapping exact in audit; timing/tap meaning still needs visual confirmation |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 13 | Q2 output | N | intermediate tap | Output | Check | Exposed for audit classification; visually confirm no labelled off-sheet net |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 14 | Q1 output | N | intermediate tap | Output | Check | Exposed for audit classification; visually confirm no labelled off-sheet net |
| 4A | Master | Motion Shift Registers | 7P | 74LS194 | 15 | Q0 output | N | MBJ3F flipped output to 7N | Output | Check | Pin/net mapping exact in audit; timing/tap meaning still needs visual confirmation |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 1 | Select | N | FLIP from 11F | Input | Check | FLIP timing still unresolved |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 2 | A input | N | MBJ1 normal LS194 output | Input | Check | Physical order corrected in audit; visually confirm on Sheet 4A |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 5 | A input | N | MBJ3 normal LS194 output | Input | Check | Physical order corrected in audit; visually confirm on Sheet 4A |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 11 | A input | N | MBJ0 normal LS194 output | Input | Check | Physical order corrected in audit; visually confirm on Sheet 4A |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 14 | A input | N | MBJ2 normal LS194 output | Input | Check | Physical order corrected in audit; visually confirm on Sheet 4A |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 3 | B input | N | MBJ1F flipped LS194 output | Input | Check | Physical order corrected in audit; visually confirm on Sheet 4A |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 6 | B input | N | MBJ3F flipped LS194 output | Input | Check | Physical order corrected in audit; visually confirm on Sheet 4A |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 10 | B input | N | MBJ0F flipped LS194 output | Input | Check | Physical order corrected in audit; visually confirm on Sheet 4A |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 13 | B input | N | MBJ2F flipped LS194 output | Input | Check | Physical order corrected in audit; visually confirm on Sheet 4A |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 4 | Y output | N | MBJ1* to Sheet 4B | Output | Check | Selected bus timing unresolved; visually confirm off-sheet label |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 7 | Y output | N | MBJ3* to Sheet 4B | Output | Check | Selected bus timing unresolved; visually confirm off-sheet label |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 9 | Y output | N | MBJ0* to Sheet 4B | Output | Check | Selected bus timing unresolved; visually confirm off-sheet label |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 12 | Y output | N | MBJ2* to Sheet 4B | Output | Check | Selected bus timing unresolved; visually confirm off-sheet label |
| 4A | Master | Motion Flip Selector | 7N | 74LS157 | 15 | /G enable | Y | Tied active | Input | High | Seeded from 7N crop/pin audit |
| 4A | Master | MOH Decode | 1H | 74LS139 | 15 | /G enable | Y | BYTLOAD | Input | Check | Destination confirmed; source/polarity timing unresolved |
| 4A | Master | MOH Decode | 1H | 74LS139 | 14 | A select | N | IV | Input | Check | Destination confirmed; IV source unresolved |
| 4A | Master | MOH Decode | 1H | 74LS139 | 13 | B select | N | Tied low | Input | High | Seeded from 1H/8F crop |
| 4A | Master | MOH Decode | 1H | 74LS139 | 12 | Y0 | Y | MOHLI to 7L/7M load and 8K select | Output | High | Important corrected mapping: Y0 = /MOHLI |
| 4A | Master | MOH Decode | 1H | 74LS139 | 11 | Y1 | Y | MOHLO to 7J/7K load | Output | High | Important corrected mapping: Y1 = /MOHLO |
| 4A | Master | IVDBH Latch | 7F | 74LS74 | 2 | D | N | IV | Input | Check | IV source unresolved |
| 4A | Master | IVDBH Latch | 7F | 74LS74 | 3 | CLK | N | B8H | Input | Check | Clock destination confirmed; source/edge unresolved |
| 4A | Master | IVDBH Latch | 7F | 74LS74 | 5 | Q | N | IVDSH | Output | High | Confirmed Q side |
| 4A | Master | IVDBH Latch | 7F | 74LS74 | 6 | /Q | Y | IVDBH | Output | High | Confirmed /Q side |
| 4A | Master | MOH Decode | 8F | 74LS139 | 1 | /G enable | Y | BYTLOAD | Input | Check | Destination confirmed; source/polarity timing unresolved |
| 4A | Master | MOH Decode | 8F | 74LS139 | 2 | A select | N | IVDBH from 7F /Q | Input | High | Confirmed in 7F/8F crop |
| 4A | Master | MOH Decode | 8F | 74LS139 | 3 | B select | N | IV | Input | Check | Destination confirmed; IV source unresolved |
| 4A | Master | MOH Decode | 8F | 74LS139 | 5 | Y1 | Y | MOHRO to 7J/7K clear | Output | High | Corrected mapping retained |
| 4A | Master | MOH Decode | 8F | 74LS139 | 6 | Y2 | Y | MOHRI to 7L/7M clear and 8M select | Output | High | Corrected mapping retained |
| 4A | Master | Load/Shift Timing | 10D | 74LS00 | 8 | S0 rail output | N | LS194 pin 9 common S0 rail | Output | High | Confirmed common S0 rail; gate inputs still need visual split |
| 4A | Master | Load/Shift Timing | 10C | 74LS00 | 6 | S1 rail output | N | LS194 pin 10 common S1 rail | Output | High | Confirmed common S1 rail; gate inputs still need visual split |
| 4A | Master | Flip Timing | 11F | 74LS74 | 11 | LOF/FLIP latch pin | N/Y | LOF/FLIP timing net | Logic | Check | Split from existing grouped row; LOF source unresolved |
| 4A | Master | Flip Timing | 11F | 74LS74 | 12 | LOF/FLIP latch pin | N/Y | LOF/FLIP timing net | Logic | Check | Split from existing grouped row; LOF source unresolved |
| 4A | Master | Flip Timing | 11F | 74LS74 | 5 | FLIP output pin | N | FLIP/FLIPM related output | Logic | Check | Split from existing grouped row; LOF source unresolved |
| 4A | Master | Flip Timing | 11F | 74LS74 | 6 | FLIP complement/output pin | Y | FLIP/FLIPM related output | Logic | Check | Split from existing grouped row; LOF source unresolved |

## Notes

- `Check` rows are seeded from the current schematic audits and visual sheet crops where noted; they are not final schematic facts.
- Preserve reviewer edits in the CSV/Numbers file when syncing this Markdown.
