# Schematic Visual Check - Sheet 6B

Reviewer-facing checklist generated from the Sheet 6B visual-check CSV. Keep this file and the CSV in sync; the CSV is the spreadsheet source for `.numbers` updates.

## Summary

- Rows: 242
- High: 182
- Check: 60

## Review Focus

Rows marked `Check` still need visual confirmation against the schematic crop/PDF. Do not promote them to `Checked` until the pin number, label, and connection are readable.

Sheet 6B covers the slave 6502B CPU, slave address/data buffers, CPU R/W buffering, IRQ/DRAM/bitmap-control latches, Master/Slave Interconnect buffers, ROM/RAM/custom decode logic, LDX/LDY decode, INV/PBWRITE/DRAM graph-control glue, and the E5M source-side interconnect row. Decoder outputs are described in the notes/net labels, while `Active Low = Y` remains reserved for active-low input pins only.

## Visual Check Table

| Sheet | Board | Section | IC | IC Type | Pin Number | Pin Function | Active Low | Connected To | Direction | Confidence | Reviewer Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 1 | VSS | N.A. | Ground | Power | Check | 6502B standard pin; visible ground rail at bottom |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 2 | RDY | N | READY pull-up/control net | Input | High | Visible READY label with R13 pull-up nearby |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 3 | PHI1 output | N.A. | PHI1/phase output | Output | Check | Standard 6502 phase output; exact visible net not fully readable |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 4 | IRQ input | Y | Slave IRQ from 4M latch/reset chain | Input | High | Visible IRQ input from 4M pin 5 |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 5 | NC | N.A. | No visible CPU function / no-connect | NC | Check | Standard 6502B pin |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 6 | NMI input | Y | NMI tied inactive/pull-up area | Input | Check | Visible NMI label; exact tie path should be reviewed |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 7 | SYNC output | N.A. | SYNC | Output | Check | Visible SYNC label; destination not fully traced in current crop |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 8 | VCC | N.A. | +5V | Power | High | Visible +5V at CPU top |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 9 | A0 output | N.A. | PBBA0 through 1C LS244 | Output | High | Visible address bus route to 1C |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 10 | A1 output | N.A. | PBBA1 through 1C LS244 | Output | High | Visible address bus route to 1C |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 11 | A2 output | N.A. | PBBA2 through 1C LS244 | Output | High | Visible address bus route to 1C |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 12 | A3 output | N.A. | PBBA3 through 1C LS244 | Output | High | Visible address bus route to 1C |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 13 | A4 output | N.A. | PBBA4 through 1C LS244 | Output | High | Visible address bus route to 1C |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 14 | A5 output | N.A. | PBBA5 through 1C LS244 | Output | High | Visible address bus route to 1C |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 15 | A6 output | N.A. | PBBA6 through 1C LS244 | Output | High | Visible address bus route to 1C |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 16 | A7 output | N.A. | PBBA7 through 1C LS244 | Output | High | Visible address bus route to 1C |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 17 | A8 output | N.A. | PBBA8 through 1B LS244 | Output | High | Visible address bus route to 1B |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 18 | A9 output | N.A. | PBBA9 through 1B LS244 | Output | High | Visible address bus route to 1B |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 19 | A10 output | N.A. | PBBA10 through 1B LS244 | Output | High | Visible address bus route to 1B |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 20 | A11 output | N.A. | PBBA11 through 1B LS244 | Output | High | Visible address bus route to 1B |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 21 | VSS | N.A. | Ground | Power | High | Visible lower ground rail |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 22 | A12 output | N.A. | PBBA12 through 1B LS244 | Output | High | Visible address bus route to 1B |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 23 | A13 output | N.A. | PBBA13 through 1B LS244 | Output | High | Visible address bus route to 1B |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 24 | A14 output | N.A. | PBBA14 through 1B LS244 | Output | High | Visible address bus route to 1B |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 25 | A15 output | N.A. | PBBA15 through 1B LS244 | Output | High | Visible address bus route to 1B |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 26 | D7 bidirectional | N | PBBD7 through 2F LS245 | Bidirectional | High | Visible data bus route |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 27 | D6 bidirectional | N | PBBD6 through 2F LS245 | Bidirectional | High | Visible data bus route |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 28 | D5 bidirectional | N | PBBD5 through 2F LS245 | Bidirectional | High | Visible data bus route |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 29 | D4 bidirectional | N | PBBD4 through 2F LS245 | Bidirectional | High | Visible data bus route |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 30 | D3 bidirectional | N | PBBD3 through 2F LS245 | Bidirectional | High | Visible data bus route |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 31 | D2 bidirectional | N | PBBD2 through 2F LS245 | Bidirectional | High | Visible data bus route |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 32 | D1 bidirectional | N | PBBD1 through 2F LS245 | Bidirectional | High | Visible data bus route |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 33 | D0 bidirectional | N | PBBD0 through 2F LS245 | Bidirectional | High | Visible data bus route |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 34 | R/W output | N.A. | PBBR/W through 5K LS04 buffer/inverter | Output | High | Visible R/W label and 5K inverter chain |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 35 | NC | N.A. | No visible CPU function / no-connect | NC | Check | Standard 6502B pin |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 36 | NC | N.A. | No visible CPU function / no-connect | NC | Check | Standard 6502B pin |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 37 | PHI0 clock input | N | Clock input from lower timing/clock chain | Input | Check | Visible clock input line; exact upstream phase source needs focused review |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 38 | SO input | Y | S.O. / set-overflow input | Input | Check | Visible S.O. label; exact tie path should be reviewed |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 39 | PHI2 output | N.A. | PBBPHI2/CPU phase output | Output | Check | Visible phase output route; exact label partly unclear |
| 6B | Slave | Slave Microprocessor | 2B/D | 6502B | 40 | RESET input | Y | BRES reset rail | Input | High | Visible BRES/RESET path |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 1 | 1G enable | Y | Ground | Input | High | Enable pin visibly tied active |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 19 | 2G enable | Y | Ground | Input | High | Enable pin visibly tied active |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 2 | A input | N | CPU A15 | Input | High | Visible from 6502 A15 pin 25 |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 18 | Y output | N.A. | PBBA15 | Output | High | Visible PBBA15 output label |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 17 | A input | N | CPU A14 | Input | High | Visible from 6502 A14 pin 24 |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 3 | Y output | N.A. | PBBA14 | Output | High | Visible PBBA14 output label |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 4 | A input | N | CPU A13 | Input | High | Visible from 6502 A13 pin 23 |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 16 | Y output | N.A. | PBBA13 | Output | High | Visible PBBA13 output label |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 15 | A input | N | CPU A12 | Input | High | Visible from 6502 A12 pin 22 |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 5 | Y output | N.A. | PBBA12 | Output | High | Visible PBBA12 output label |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 6 | A input | N | CPU A11 | Input | High | Visible from 6502 A11 pin 20 |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 14 | Y output | N.A. | PBBA11 | Output | High | Visible PBBA11 output label |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 13 | A input | N | CPU A10 | Input | High | Visible from 6502 A10 pin 19 |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 7 | Y output | N.A. | PBBA10 | Output | High | Visible PBBA10 output label |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 8 | A input | N | CPU A9 | Input | High | Visible from 6502 A9 pin 18 |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 12 | Y output | N.A. | PBBA9 | Output | High | Visible PBBA9 output label |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 11 | A input | N | CPU A8 | Input | High | Visible from 6502 A8 pin 17 |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 9 | Y output | N.A. | PBBA8 | Output | High | Visible PBBA8 output label |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 10 | GND | N.A. | Ground | Power | Check | Standard LS244 ground pin |
| 6B | Slave | Address Buffer High | 1B | 74LS244 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS244 power pin |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 1 | 1G enable | Y | Ground | Input | High | Enable pin visibly tied active |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 19 | 2G enable | Y | Ground | Input | High | Enable pin visibly tied active |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 2 | A input | N | CPU A7 | Input | High | Visible from 6502 A7 pin 16 |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 18 | Y output | N.A. | PBBA7 | Output | High | Visible PBBA7 output label |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 17 | A input | N | CPU A6 | Input | High | Visible from 6502 A6 pin 15 |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 3 | Y output | N.A. | PBBA6 | Output | High | Visible PBBA6 output label |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 4 | A input | N | CPU A5 | Input | High | Visible from 6502 A5 pin 14 |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 16 | Y output | N.A. | PBBA5 | Output | High | Visible PBBA5 output label |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 15 | A input | N | CPU A4 | Input | High | Visible from 6502 A4 pin 13 |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 5 | Y output | N.A. | PBBA4 | Output | High | Visible PBBA4 output label |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 6 | A input | N | CPU A3 | Input | High | Visible from 6502 A3 pin 12 |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 14 | Y output | N.A. | PBBA3 | Output | High | Visible PBBA3 output label |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 13 | A input | N | CPU A2 | Input | High | Visible from 6502 A2 pin 11 |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 7 | Y output | N.A. | PBBA2 | Output | High | Visible PBBA2 output label |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 8 | A input | N | CPU A1 | Input | High | Visible from 6502 A1 pin 10 |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 12 | Y output | N.A. | PBBA1 | Output | High | Visible PBBA1 output label |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 11 | A input | N | CPU A0 | Input | High | Visible from 6502 A0 pin 9 |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 9 | Y output | N.A. | PBBA0 | Output | High | Visible PBBA0 output label |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 10 | GND | N.A. | Ground | Power | Check | Standard LS244 ground pin |
| 6B | Slave | Address Buffer Low | 1C | 74LS244 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS244 power pin |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 1 | DIR direction input | N | PBBR/W direction control | Input | High | Visible PBBR/W/DIR area |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 19 | /G enable | Y | PBBMEM via 3E LS04 | Input | High | Visible PBBMEM enable inverter feeding G |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 2 | A1 bus pin | N | CPU D7 | Bidirectional | High | Visible CPU data bus connection |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 18 | B1 bus pin | N | PBBD7 | Bidirectional | High | Visible PBBD7 label |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 3 | A2 bus pin | N | CPU D6 | Bidirectional | High | Visible CPU data bus connection |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 17 | B2 bus pin | N | PBBD6 | Bidirectional | High | Visible PBBD6 label |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 4 | A3 bus pin | N | CPU D5 | Bidirectional | High | Visible CPU data bus connection |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 16 | B3 bus pin | N | PBBD5 | Bidirectional | High | Visible PBBD5 label |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 5 | A4 bus pin | N | CPU D4 | Bidirectional | High | Visible CPU data bus connection |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 15 | B4 bus pin | N | PBBD4 | Bidirectional | High | Visible PBBD4 label |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 6 | A5 bus pin | N | CPU D3 | Bidirectional | High | Visible CPU data bus connection |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 14 | B5 bus pin | N | PBBD3 | Bidirectional | High | Visible PBBD3 label |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 7 | A6 bus pin | N | CPU D2 | Bidirectional | High | Visible CPU data bus connection |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 13 | B6 bus pin | N | PBBD2 | Bidirectional | High | Visible PBBD2 label |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 8 | A7 bus pin | N | CPU D1 | Bidirectional | High | Visible CPU data bus connection |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 12 | B7 bus pin | N | PBBD1 | Bidirectional | High | Visible PBBD1 label |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 9 | A8 bus pin | N | CPU D0 | Bidirectional | High | Visible CPU data bus connection |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 11 | B8 bus pin | N | PBBD0 | Bidirectional | High | Visible PBBD0 label |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 10 | GND | N.A. | Ground | Power | Check | Standard LS245 ground pin |
| 6B | Slave | Data Bus Buffer | 2F | 74LS245 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS245 power pin |
| 6B | Slave | CPU Read Write Buffer | 5K | 74LS04 | 1 | Inverter input | N | CPU R/W | Input | High | Visible CPU R/W into 5K |
| 6B | Slave | CPU Read Write Buffer | 5K | 74LS04 | 2 | Inverter output | N.A. | PBBR/W | Output | High | Visible PBBR/W label |
| 6B | Slave | CPU Read Write Buffer | 5K | 74LS04 | 3 | Inverter input | N | PBBR/W | Input | High | Visible second 5K inverter stage |
| 6B | Slave | CPU Read Write Buffer | 5K | 74LS04 | 4 | Inverter output | N.A. | PBBR/W complement/output rail | Output | Check | Visible output label partly unclear |
| 6B | Slave | IRQ Reset Latch | 4M | 74LS74 | 2 | D input | N | VBLANK | Input | High | Visible VBLANK input label |
| 6B | Slave | IRQ Reset Latch | 4M | 74LS74 | 3 | CLK | N | VBLANK/clocked timing rail | Input | Check | Clock pin visible; exact clock source needs focused review |
| 6B | Slave | IRQ Reset Latch | 4M | 74LS74 | 4 | /PR preset | Y | PR14 pull-up rail | Input | High | Visible PR14 pull-up |
| 6B | Slave | IRQ Reset Latch | 4M | 74LS74 | 1 | /CLR clear | Y | PBIRQRES | Input | High | Visible PBIRQRES reset label |
| 6B | Slave | IRQ Reset Latch | 4M | 74LS74 | 5 | Q output | N.A. | CPU IRQ pin 4 | Output | High | Visible route to 6502 IRQ |
| 6B | Slave | IRQ Reset Latch | 4M | 74LS74 | 6 | /Q output | N.A. | IRQ complement/local net | Output | Check | Pin visible; destination not fully traced |
| 6B | Slave | DRAM Write Latch | 4M | 74LS74 | 12 | D input | N | DRAM | Input | High | Visible DRAM input label |
| 6B | Slave | DRAM Write Latch | 4M | 74LS74 | 11 | CLK | N | 2H | Input | High | Visible 2H clock label |
| 6B | Slave | DRAM Write Latch | 4M | 74LS74 | 13 | /CLR clear | Y | PR14 pull-up rail | Input | High | Visible PR14 pull-up |
| 6B | Slave | DRAM Write Latch | 4M | 74LS74 | 9 | Q output | N.A. | DRAMWREN | Output | High | Visible DRAMWREN label |
| 6B | Slave | DRAM Write Latch | 4M | 74LS74 | 8 | /Q output | N.A. | DRAMWREN complement/local net | Output | Check | Pin visible; destination not fully traced |
| 6B | Slave | DRAM Write Latch | 6L | 74LS74 | 2 | D input | N | DRAMWREN | Input | High | Visible DRAMWREN input |
| 6B | Slave | DRAM Write Latch | 6L | 74LS74 | 3 | CLK | N | Clock/control from 4M chain | Input | Check | Visible pin; exact clock label not readable |
| 6B | Slave | DRAM Write Latch | 6L | 74LS74 | 4 | /PR preset | Y | +5V/PR16 pull-up rail | Input | Check | Visible pull-up area |
| 6B | Slave | DRAM Write Latch | 6L | 74LS74 | 1 | /CLR clear | Y | Clear/reset rail | Input | Check | Visible clear pin; exact net not fully readable |
| 6B | Slave | DRAM Write Latch | 6L | 74LS74 | 5 | Q output | N.A. | DRAMWREN delayed/local net | Output | Check | Visible route in DRAMWREN chain |
| 6B | Slave | DRAM Write Latch | 6L | 74LS74 | 6 | /Q output | N.A. | DRAMWREN complement/local net | Output | Check | Visible route in DRAMWREN chain |
| 6B | Slave | Bitmap Clear Latch | 7L | 74LS74 | 2 | D input | N | DELAYN/DELAY timing | Input | Check | Visible DEL* timing label; exact spelling unclear |
| 6B | Slave | Bitmap Clear Latch | 7L | 74LS74 | 3 | CLK | N | Clock/control from DEL2H/PBCMRAM chain | Input | Check | Visible clock pin; exact source needs focused review |
| 6B | Slave | Bitmap Clear Latch | 7L | 74LS74 | 4 | /PR preset | Y | +5V pull-up rail | Input | High | Visible pull-up rail |
| 6B | Slave | Bitmap Clear Latch | 7L | 74LS74 | 1 | /CLR clear | Y | Reset/clear rail | Input | Check | Visible clear pin; exact source not fully readable |
| 6B | Slave | Bitmap Clear Latch | 7L | 74LS74 | 5 | Q output | N.A. | CLRRAM/clear-related net | Output | Check | Visible route to clear logic; label should be confirmed |
| 6B | Slave | Bitmap Clear Latch | 7L | 74LS74 | 6 | /Q output | N.A. | CLRRAM complement/local net | Output | Check | Visible output pin; destination not fully traced |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 1 | 1G enable | Y | Ground | Input | High | Enable pins tied active |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 19 | 2G enable | Y | Ground | Input | High | Enable pins tied active |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 13 | A input | N | 1H | Input | High | Visible 1H input label |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 7 | Y output | N.A. | E1H to J17 pin 23 | Output | High | Visible E1H label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 15 | A input | N | 2H | Input | High | Visible 2H input label |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 5 | Y output | N.A. | E2H to J17 pin 17 | Output | High | Visible E2H label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 4 | A input | N | 4H | Input | High | Visible 4H input label |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 16 | Y output | N.A. | E4H to J17 pin 13 | Output | High | Visible E4H label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 17 | A input | N | 8H | Input | High | Visible 8H input label |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 3 | Y output | N.A. | E8H to J17 pin 9 | Output | High | Visible E8H label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 11 | A input | N | PB0 | Input | High | Visible PB0 input label |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 9 | Y output | N.A. | EPB0 to J17 pin 19 | Output | High | Visible EPB0 label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 2 | A input | N | PBBR/W | Input | High | Visible PBBR/W input label |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 18 | Y output | N.A. | EPBR/W to J17 pin 7 | Output | High | Visible EPBR/W label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 8 | A input | N | PBCMRAM | Input | High | Visible PBCMRAM input label |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 12 | Y output | N.A. | EPBCMRAM to J17 pin 15 | Output | High | Visible EPBCMRAM label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 10 | GND | N.A. | Ground | Power | Check | Standard LS244 ground pin |
| 6B | Slave | Master/Slave Interconnect | 2F/H | 74LS244 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS244 power pin |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 1 | 1G enable | Y | Ground | Input | High | Enable pins tied active |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 19 | 2G enable | Y | Ground | Input | High | Enable pins tied active |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 6 | A input | N | 16H | Input | High | Visible 16H input label |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 14 | Y output | N.A. | E16H to J17 pin 22 | Output | High | Visible E16H label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 4 | A input | N | 32H | Input | High | Visible 32H input label |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 16 | Y output | N.A. | E32H to J17 pin 27 | Output | High | Visible E32H label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 17 | A input | N | 256H | Input | High | Visible 256H input label |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 3 | Y output | N.A. | E256H to J17 pin 35 | Output | High | Visible E256H label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 13 | A input | N | VBLANK | Input | High | Visible VBLANK input label |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 7 | Y output | N.A. | EVBLANK to J17 pin 36 | Output | High | Visible EVBLANK label and connector pin |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 11 | A input | N | 5MHZ | Input | High | Visible 5MHZ input label |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 9 | Y output | N.A. | E5M to J17 pin 31 | Output | High | Important B5M/E5M source trace; visible E5M connector label |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 2 | A input | N | ERESET from J17 pin 2 | Input | High | Visible ERESET connector input |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 12 | Y output | N.A. | BRES reset rail | Output | High | Visible BRES label |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 8 | A input | N | Reset/control input | Input | Check | Pin visible; exact net label not fully readable |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 18 | Y output | N.A. | Reset/control output | Output | Check | Pin visible; exact destination not fully readable |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 10 | GND | N.A. | Ground | Power | Check | Standard LS244 ground pin |
| 6B | Slave | Master/Slave Interconnect | 3D | 74LS244 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS244 power pin |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 3 | Input | N | PBBA10 | Input | High | Visible PBBA10 into 2M gate |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 2 | Input | N | PBBA9 | Input | High | Visible PBBA9 into 2M gate |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 4 | Input | N | PBBA8 | Input | High | Visible PBBA8 into 2M gate |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 12 | Input | N | PBBA3 | Input | High | Visible PBBA3 into 2M gate |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 13 | Input | N | Ground | Input | High | Visible tied ground input |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 5 | Output | N.A. | ZERO decode net | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 10 | Input | N | PBBA7 | Input | High | Visible PBBA7 into second 2M gate |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 9 | Input | N | PBBA6 | Input | High | Visible PBBA6 into second 2M gate |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 8 | Input | N | PBBA5 | Input | High | Visible PBBA5 into second 2M gate |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 4/11 | Input | N | PBBA4/ZERO decode terms | Input | Check | Second gate input labels visible but pin association needs review |
| 6B | Slave | Address Decode Zero | 2M | 74LS260 | 6 | Output | N.A. | Address-zero decode output to 2L | Output | Check | Output visible; exact label should be confirmed |
| 6B | Slave | RAM Decode | 2L | 74LS00 | 4 | NAND input | N | ZERO | Input | High | Visible ZERO into 2L |
| 6B | Slave | RAM Decode | 2L | 74LS00 | 5 | NAND input | N | Address-zero decode term from 2M | Input | Check | Visible route from 2M; exact label not printed |
| 6B | Slave | RAM Decode | 2L | 74LS00 | 6 | NAND output | N.A. | PBRAM | Output | High | Visible PBRAM output label |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 2 | D input | N | PBBD1 | Input | High | Visible PBBD1 input label |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 3 | CLK | N | SWAP | Input | High | Visible SWAP clock/input label |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 4 | /PR preset | Y | PR16 pull-up rail | Input | High | Visible PR16 pull-up |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 1 | /CLR clear | Y | Clear/reset rail | Input | Check | Clear pin visible; exact net not fully readable |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 5 | Q output | N.A. | CLRRAM | Output | Check | Visible output; label/route should be reviewed |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 6 | /Q output | N.A. | CLRRAM complement/local net | Output | Check | Visible output pin |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 12 | D input | N | PBBD0 | Input | High | Visible PBBD0 input label |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 11 | CLK | N | SWAP | Input | High | Visible SWAP clock/input label |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 10 | /PR preset | Y | SETBUF pull-up/control | Input | High | Visible SETBUF pull-up/control |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 13 | /CLR clear | Y | RSTBUF reset/control | Input | High | Visible RSTBUF label |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 9 | Q output | N.A. | BUFSEL | Output | High | Visible BUFSEL output label |
| 6B | Slave | Buffer Select | 7M | 74LS74 | 8 | /Q output | N.A. | BUFSEL complement | Output | High | Visible paired BUFSEL complement labels |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 1 | A select input | N | PBBA11 | Input | High | Visible PBBA11 input label |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 2 | B select input | N | PBBA13 | Input | High | Visible PBBA13 input label |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 3 | C select input | N | PBBA15 | Input | High | Visible PBBA15 input label |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 4 | G2A enable | Y | Ground/enable rail | Input | Check | Enable pin visible; exact tie should be confirmed |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 5 | G2B enable | Y | Ground/enable rail | Input | Check | Enable pin visible; exact tie should be confirmed |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 6 | G1 enable | N | PBBA15/decode enable | Input | Check | Visible enable pin; exact source needs review |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 15 | Y0 output | N.A. | PBROM0 | Output | High | Active-low decoder output label visible |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 14 | Y1 output | N.A. | PBROM1 | Output | High | Active-low decoder output label visible |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 13 | Y2 output | N.A. | PBROM2 | Output | High | Active-low decoder output label visible |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 12 | Y3 output | N.A. | PBROM3 | Output | High | Active-low decoder output label visible |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 11 | Y4 output | N.A. | PBROM4 | Output | High | Active-low decoder output label visible |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 10 | Y5 output | N.A. | PBROM5 | Output | High | Active-low decoder output label visible |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 9 | Y6 output | N.A. | PBROM6 | Output | High | Active-low decoder output label visible |
| 6B | Slave | ROM Decode | 6K | 74LS138 | 7 | Y7 output | N.A. | Unused/local output | Output | Check | Output pin visible; label not clearly used |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 1 | 1G enable | Y | SUB | Input | High | Visible SUB input label |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 2 | 1A select | N | PBBA12 | Input | High | Visible PBBA12 input label |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 3 | 1B select | N | PBBA11 | Input | High | Visible PBBA11 input label |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 4 | Y0 output | N.A. | Decode output to 6N/5M logic | Output | Check | Output visible; exact label/route not fully readable |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 5 | Y1 output | N.A. | SWAP | Output | High | Visible SWAP label |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 6 | Y2 output | N.A. | DECRAM | Output | High | Visible DECRAM label |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 7 | Y3 output | N.A. | Decode output/local net | Output | Check | Output visible; exact label not readable |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 15 | 2G enable | Y | PBBA0/PBBA9 decode rail | Input | Check | Second decoder half visible; exact enable source needs review |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 14 | 2A select | N | PBBA0 | Input | Check | Visible PBBA0-related select; exact pin association needs review |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 13 | 2B select | N | PBBA9 | Input | Check | Visible PBBA9-related select; exact pin association needs review |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 12 | Y0 output | N.A. | PBWRITE-related decode | Output | Check | Output visible; exact label not fully readable |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 11 | Y1 output | N.A. | Custom/write decode | Output | Check | Output visible; exact label not fully readable |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 10 | Y2 output | N.A. | CUSTOMWR | Output | High | Visible CUSTOMWR label |
| 6B | Slave | Custom Decode | 5H | 74LS139 | 9 | Y3 output | N.A. | PBIRQRES | Output | High | Visible PBIRQRES label |
| 6B | Slave | LDX LDY Decode | 6H | 74LS139 | 1 | 1G enable | Y | DECODE | Input | High | Visible DECODE enable label |
| 6B | Slave | LDX LDY Decode | 6H | 74LS139 | 2 | 1A select | N | PBBA2 | Input | High | Visible PBBA2 input label |
| 6B | Slave | LDX LDY Decode | 6H | 74LS139 | 3 | 1B select | N | PBBA14 | Input | High | Visible PBBA14 input label |
| 6B | Slave | LDX LDY Decode | 6H | 74LS139 | 4 | Y0 output | N.A. | Decode output/local net | Output | Check | Output visible; exact label not printed |
| 6B | Slave | LDX LDY Decode | 6H | 74LS139 | 5 | Y1 output | N.A. | Decode output/local net | Output | Check | Output visible; exact label not printed |
| 6B | Slave | LDX LDY Decode | 6H | 74LS139 | 6 | Y2 output | N.A. | LDY | Output | High | Visible LDY active-low output label |
| 6B | Slave | LDX LDY Decode | 6H | 74LS139 | 7 | Y3 output | N.A. | LDX | Output | High | Visible LDX active-low output label |
| 6B | Slave | Graph Control Logic | 5M | 74LS00 | 4 | NAND input | N | PBBA0 | Input | High | Visible PBBA0 input |
| 6B | Slave | Graph Control Logic | 5M | 74LS00 | 5 | NAND input | N | 5MHZ/clock phase | Input | High | Visible 5MHZ input label |
| 6B | Slave | Graph Control Logic | 5M | 74LS00 | 6 | NAND output | N.A. | PBWRITE | Output | High | Visible PBWRITE label |
| 6B | Slave | Graph Control Logic | 6N | 74LS02 | 12 | NOR input | N | PBBA0 | Input | High | Visible PBBA0 input |
| 6B | Slave | Graph Control Logic | 6N | 74LS02 | 13 | NOR input | N | 5MHZ | Input | High | Visible 5MHZ input |
| 6B | Slave | Graph Control Logic | 6N | 74LS02 | 11 | NOR output | N.A. | Clock/write phase to 5M | Output | Check | Output visible; exact label not printed |
| 6B | Slave | Graph Control Logic | 6M | 74LS02 | 2 | NOR input | N | PBBA0 | Input | High | Visible PBBA0 input |
| 6B | Slave | Graph Control Logic | 6M | 74LS02 | 3 | NOR input | N | PBBA1 | Input | High | Visible PBBA1 input |
| 6B | Slave | Graph Control Logic | 6M | 74LS02 | 1 | NOR output | N.A. | INV preterm/local net | Output | Check | Feeds 5N logic; exact label not printed |
| 6B | Slave | Graph Control Logic | 5N | 74LS32 | 1 | OR input | N | 6M output / PBBA0/PBBA1 preterm | Input | Check | Visible route from 6M |
| 6B | Slave | Graph Control Logic | 5N | 74LS32 | 2 | OR input | N | PBBA2 | Input | High | Visible PBBA2 input |
| 6B | Slave | Graph Control Logic | 5N | 74LS32 | 3 | OR output | N.A. | INV | Output | High | Visible INV output label |
| 6B | Slave | DRAM Decode | 5M | 74LS00 | 12 | NAND input | N | PBBA0 | Input | High | Visible PBBA0 input |
| 6B | Slave | DRAM Decode | 5M | 74LS00 | 13 | NAND input | N | PBBA1 | Input | High | Visible PBBA1 input |
| 6B | Slave | DRAM Decode | 5M | 74LS00 | 11 | NAND output | N.A. | DRAM predecode | Output | Check | Visible route to 5M gate |
| 6B | Slave | DRAM Decode | 5M | 74LS00 | 1 | NAND input | N | DRAM predecode | Input | Check | Visible route from same package |
| 6B | Slave | DRAM Decode | 5M | 74LS00 | 2 | NAND input | N | DECODE | Input | High | Visible DECODE input |
| 6B | Slave | DRAM Decode | 5M | 74LS00 | 3 | NAND output | N.A. | DRAM | Output | High | Visible DRAM output label |
