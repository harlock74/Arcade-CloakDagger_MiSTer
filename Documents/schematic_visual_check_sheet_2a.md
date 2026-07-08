# Schematic Visual Check - Sheet 2A

Reviewer-facing checklist generated from the Sheet 2A visual-check CSV. Keep this file and the CSV in sync; the CSV is the spreadsheet source for `.numbers` updates.

## Summary

- Rows: 134
- High: 29
- Check: 105

## Review Focus

Rows marked `Check` still need visual confirmation against the schematic crop/PDF. Do not promote them to `Checked` until the pin number, label, and connection are readable.

Sheet 2A has now been reviewed against `Documents/Master/Sheet2A.pdf` for IC inventory/type corrections. The `8F` and `9E` LS139 address decoders have per-pin visual-check rows, including the `8F` `MORAM` output. The CPU `R/W` write-strobe path is now expanded from `3C` pin 34 through `4/5E`, `7D`, and `7C` to document `PABR/W`, `BWRITE`, and `PAWRITE` polarity-generation. Other small glue ICs remain grouped until each package gets a focused pin-level crop review.

## Visual Check Table

| Sheet | Board | Section | IC | IC Type | Pin Number | Pin Function | Active Low | Connected To | Direction | Confidence | Reviewer Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2A | Master | Master Microprocessor | 3C | 6502B | 1 | VSS | N | Ground | Power | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 2 | RDY | N | READY / RDY control net | Input | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 3 | PHI1 output | N | PHI1 / CPU phase output | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 4 | IRQ input | Y | IRQ / master interrupt request | Input | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 5 | NC | N | No visible CPU function / no-connect | NC | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 6 | NMI input | Y | NMI / likely tied inactive or unused | Input | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 7 | SYNC output | N | SYNC / CPU sync output | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 8 | VCC | N | +5V | Power | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 9 | A0 address output | N | PABA0 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 10 | A1 address output | N | PABA1 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 11 | A2 address output | N | PABA2 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 12 | A3 address output | N | PABA3 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 13 | A4 address output | N | PABA4 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 14 | A5 address output | N | PABA5 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 15 | A6 address output | N | PABA6 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 16 | A7 address output | N | PABA7 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 17 | A8 address output | N | PABA8 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 18 | A9 address output | N | PABA9 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 19 | A10 address output | N | PABA10 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 20 | A11 address output | N | PABA11 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 21 | VSS | N | Ground | Power | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 22 | A12 address output | N | PABA12 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 23 | A13 address output | N | PABA13 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 24 | A14 address output | N | PABA14 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 25 | A15 address output | N | PABA15 / address buffer input | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 26 | D7 data bus | N | PABD7 / data transceiver bus | Bidirectional | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 27 | D6 data bus | N | PABD6 / data transceiver bus | Bidirectional | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 28 | D5 data bus | N | PABD5 / data transceiver bus | Bidirectional | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 29 | D4 data bus | N | PABD4 / data transceiver bus | Bidirectional | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 30 | D3 data bus | N | PABD3 / data transceiver bus | Bidirectional | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 31 | D2 data bus | N | PABD2 / data transceiver bus | Bidirectional | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 32 | D1 data bus | N | PABD1 / data transceiver bus | Bidirectional | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 33 | D0 data bus | N | PABD0 / data transceiver bus | Bidirectional | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 34 | R/W output | N.A. | R/W net to 4/5E pin 9 and write-strobe gate chain | Output | High | Visible in user Sheet 2A crop; source for PABR/W polarity pair and BWRITE / PAWRITE generation |
| 2A | Master | Master Microprocessor | 3C | 6502B | 35 | NC | N | No visible CPU function / no-connect | NC | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 36 | NC | N | No visible CPU function / no-connect | NC | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 37 | PHI0 clock input | N | PHI0 / CPU clock input | Input | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 38 | SO input | Y | SO / likely tied inactive or unused | Input | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 39 | PHI2 output | N | PHI2 / CPU phase output | Output | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Microprocessor | 3C | 6502B | 40 | RESET input | Y | RESET / master reset | Input | Check | 6502B standard pin function seeded for visual review; confirm exact Sheet 2A net label and connection |
| 2A | Master | Master Address Bus | 2B | 74LS244 | multiple | Address buffer pins | Y/N | CPU address lines to PABA bus | Logic | Check | Seeded from master CPU audit |
| 2A | Master | Master Address Bus | 2C | 74LS244 | multiple | Address buffer pins | Y/N | CPU address lines to PABA bus | Logic | Check | Seeded from master CPU audit |
| 2A | Master | Master Address Bus | 2G | 74LS244 | multiple | Address buffer pins | Y/N | CPU address lines to PABA bus | Logic | Check | Seeded from master CPU audit |
| 2A | Master | Master Data Bus | 2E/F | 74LS245 | multiple | Data transceiver pins | Y/N | CPU D0..7 to PABD0..7 with PABR/W direction | Logic | Check | Seeded from master CPU audit |
| 2A | Master | Address Decode | 5E | 74LS138 | multiple | High address decode pins | Y | PABA11..15 to LFREQ/HFREQ/PACMRAM/PARAM/etc | Logic | Check | Seeded from master CPU audit |
| 2A | Master | CPU Write Strobe | 4/5E | 74LS04 | 9 | Inverter input | N | 3C pin 34 R/W | Input | High | Visible in user Sheet 2A crop; first inverter in CPU R/W polarity chain |
| 2A | Master | CPU Write Strobe | 4/5E | 74LS04 | 8 | Inverter output | N.A. | PABR/W-derived inverted net to 4/5E pin 11 and 7D pin 13 | Output | Check | Visible in user Sheet 2A crop; exact overbar placement on PABR/W label should be visually confirmed |
| 2A | Master | CPU Write Strobe | 4/5E | 74LS04 | 11 | Inverter input | N | PABR/W-derived net from 4/5E pin 8 | Input | High | Visible in user Sheet 2A crop; second inverter restores opposite R/W polarity |
| 2A | Master | CPU Write Strobe | 4/5E | 74LS04 | 10 | Inverter output | N.A. | Opposite PABR/W polarity output | Output | Check | Visible in user Sheet 2A crop; exact overbar placement on PABR/W label should be visually confirmed |
| 2A | Master | CPU Write Strobe | 7D | 74LS08 | 12 | AND input | N | PA Phi 0 / PA0 phase input | Input | Check | Visible in user Sheet 2A crop; label looks like PA Phi 0 and needs confirmation from full Sheet 2A |
| 2A | Master | CPU Write Strobe | 7D | 74LS08 | 13 | AND input | N | PABR/W-derived write-polarity net from 4/5E pin 8 | Input | High | Visible in user Sheet 2A crop |
| 2A | Master | CPU Write Strobe | 7D | 74LS08 | 11 | AND output | N.A. | BWRITE; also drives 7C pin 13 | Output | High | Visible in user Sheet 2A crop; one of the four write/control outputs from the CPU R/W chain |
| 2A | Master | CPU Write Strobe | 7C | 74LS00 | 13 | NAND input | N | BWRITE from 7D pin 11 | Input | High | Visible in user Sheet 2A crop |
| 2A | Master | CPU Write Strobe | 7C | 74LS00 | 12 | NAND input | N | B5M* | Input | High | Visible in user Sheet 2A crop; low-true signal name is documented in Connected To not Active Low |
| 2A | Master | CPU Write Strobe | 7C | 74LS00 | 11 | NAND output | N.A. | PAWRITE low-true output | Output | High | Visible in user Sheet 2A crop; output bubble shown and label appears overbar PAWRITE |
| 2A | Master | Address Decode | 8F | 74LS139 | 1 | /G enable | Y | Decoded enable from 4/5F and 7C gate chain | Input | Check | Visible enable route; exact upstream gate chain still needs focused review |
| 2A | Master | Address Decode | 8F | 74LS139 | 2 | A select | N | PABA9 | Input | High | Visible input label on Sheet 2A crop |
| 2A | Master | Address Decode | 8F | 74LS139 | 3 | B select | N | PABA10 | Input | High | Visible input label on Sheet 2A crop |
| 2A | Master | Address Decode | 8F | 74LS139 | 4 | Y0 output | N.A. | MORAM | Output | High | Visible decoded output label; low-true output naming/polarity should be described in notes not Active Low |
| 2A | Master | Address Decode | 8F | 74LS139 | 5 | Y1 output | N.A. | COLRAM | Output | High | Visible decoded output label |
| 2A | Master | Address Decode | 8F | 74LS139 | 6 | Y2 output | N.A. | UNCLEAR decoded output | Output | Check | Pin visible but label not readable in current crop |
| 2A | Master | Address Decode | 8F | 74LS139 | 7 | Y3 output | N.A. | UNCLEAR decoded output | Output | Check | Pin visible but label not readable in current crop |
| 2A | Master | Address Decode | 8F | 74LS139 | 15 | /G enable | Y | Decoded enable from 4/5E and 4/5F gate chain | Input | Check | Visible enable route; exact upstream gate chain still needs focused review |
| 2A | Master | Address Decode | 8F | 74LS139 | 14 | A select | N | PABA9 | Input | High | Visible input label on Sheet 2A crop |
| 2A | Master | Address Decode | 8F | 74LS139 | 13 | B select | N | PABA10 | Input | High | Visible input label on Sheet 2A crop |
| 2A | Master | Address Decode | 8F | 74LS139 | 12 | Y0 output | N.A. | OUTRAM | Output | High | Visible decoded output label |
| 2A | Master | Address Decode | 8F | 74LS139 | 11 | Y1 output | N.A. | UNCLEAR decoded output | Output | Check | Pin visible but label not readable in current crop |
| 2A | Master | Address Decode | 8F | 74LS139 | 10 | Y2 output | N.A. | UNCLEAR decoded output | Output | Check | Pin visible but label not readable in current crop |
| 2A | Master | Address Decode | 8F | 74LS139 | 9 | Y3 output | N.A. | UNCLEAR decoded output | Output | Check | Pin visible but label not readable in current crop |
| 2A | Master | Address Decode | 9E | 74LS139 | 1 | /G enable | Y | PAWRITE / write-qualified enable path | Input | Check | Visible enable line from 9C/8D area; exact upstream gate chain still needs focused review |
| 2A | Master | Address Decode | 9E | 74LS139 | 2 | A select | N | PABA9 | Input | High | Visible input label on Sheet 2A crop |
| 2A | Master | Address Decode | 9E | 74LS139 | 3 | B select | N | PABA10 | Input | High | Visible input label on Sheet 2A crop |
| 2A | Master | Address Decode | 9E | 74LS139 | 4 | Y0 output | N.A. | IN3 | Output | High | Visible decoded output label |
| 2A | Master | Address Decode | 9E | 74LS139 | 5 | Y1 output | N.A. | IN2 | Output | High | Visible decoded output label |
| 2A | Master | Address Decode | 9E | 74LS139 | 6 | Y2 output | N.A. | OUT | Output | High | Visible decoded output label |
| 2A | Master | Address Decode | 9E | 74LS139 | 7 | Y3 output | N.A. | PAIRQRES | Output | High | Visible decoded output label |
| 2A | Master | Address Decode | 9E | 74LS139 | 15 | /G enable | Y | Enable from decode/write gate chain | Input | Check | Visible enable route; exact upstream gate chain still needs focused review |
| 2A | Master | Address Decode | 9E | 74LS139 | 14 | A select | N | PABA9 | Input | High | Visible input label on Sheet 2A crop |
| 2A | Master | Address Decode | 9E | 74LS139 | 13 | B select | N | PABA10 | Input | High | Visible input label on Sheet 2A crop |
| 2A | Master | Address Decode | 9E | 74LS139 | 12 | Y0 output | N.A. | WDDIS | Output | High | Visible decoded output label |
| 2A | Master | Address Decode | 9E | 74LS139 | 11 | Y1 output | N.A. | OUTCR | Output | High | Visible decoded output label |
| 2A | Master | Address Decode | 9E | 74LS139 | 10 | Y2 output | N.A. | UNCLEAR decoded output | Output | Check | Pin visible but label not readable in current crop |
| 2A | Master | Address Decode | 9E | 74LS139 | 9 | Y3 output | N.A. | UNCLEAR decoded output | Output | Check | Pin visible but label not readable in current crop |
| 2A | Master | CPU Clock/Reset | 7E | 74LS74 | multiple | Reset/watchdog/IRQ latch pins | Y/N | POR/WDCLR/RESET/IRQ related nets | Logic | Check | Present in master CPU audit reset/watchdog chain; per-pin review needs higher-resolution Sheet 2A crop |
| 2A | Master | CPU Clock/Reset | 9A | 74LS109 | multiple | CPU clock phase/control latch | N/Y | CPU clock/reset related nets | Logic | Check | Seeded from master CPU audit |
| 2A | Master | CPU Glue / Timing | 10C | 74LS20 | multiple | Decode NAND gate pins | Y/N | PARAM/MORAM/BWRITE related nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review |
| 2A | Master | CPU Glue / Timing | 10D | 74LS00 | multiple | Decode NAND gate pins | Y/N | PARAM/PABR/W/PACMRAM/BWRITE related nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review; added missing visible package |
| 2A | Master | CPU Glue / Timing | 7A | 74LS14 | multiple | Reset/POR inverter sections | Y/N | RESET/POR related nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review |
| 2A | Master | CPU Glue / Timing | 7C | 74LS00 | multiple | Remaining NAND gate pins | N.A. | PABR/W/PARAM/FREQ related nets; write-strobe pins 11/12/13 expanded above | Logic | Check | User Sheet 2A crop confirms 7C is LS00 for the write-strobe gate; remaining package sections still need focused review |
| 2A | Master | CPU Glue / Timing | 7D | 74LS08 | multiple | Remaining AND gate pins | N.A. | FREQ/HFREQ/PABA timing/decode related nets; write-strobe pins 11/12/13 expanded above | Logic | Check | User Sheet 2A crop confirms 7D is LS08 for the write-strobe gate; remaining package sections still need focused review |
| 2A | Master | CPU Glue / Timing | 8A | 74LS393 | multiple | Watchdog/counter pins | Y/N | WDIS/clock/reset related nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review; fixes previous LS74 placeholder |
| 2A | Master | CPU Glue / Timing | 8B | 74LS32 | multiple | Decode OR gate pins | Y/N | BWRITE/PARAM/PABR/W related decode nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review |
| 2A | Master | CPU Glue / Timing | 8D | 74LS08 | multiple | Decode AND gate pins | Y/N | PABR/W/PARAM/write-enable related nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review |
| 2A | Master | CPU Glue / Timing | 8E | 74LS00 | multiple | Watchdog/reset NAND gate pins | Y/N | WDCLR/watchdog/reset related nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review; added missing visible package |
| 2A | Master | CPU Glue / Timing | 9C | 74LS74 | multiple | IRQ/reset latch pins | Y/N | IRQ/POR/PAIRQRES related nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review; fixes previous LS00 placeholder |
| 2A | Master | CPU Glue / Timing | 9D | 74LS02 | multiple | Decode NOR gate pins | Y/N | PAIRQRES/PACMRAM/PARAM related nets | Logic | Check | Reviewed against Documents/Master/Sheet2A.pdf rendered at /private/tmp/cloak_sheet_review/Sheet2A.pdf.png; inventory/type visible but per-pin rows still need focused crop review; resolves previous type conflict note |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 1 | /G enable | Y | Tied low active | Input | Check | Visible tied-low enable in interconnect crop; confirm |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 2 | A input | N | E2H | Input | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 3 | Y output | N | BPBCMRAM | Output | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 4 | A input | N | E1H | Input | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 5 | Y output | N | B4H | Output | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 6 | A input | N | EPB?0 | Input | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 7 | Y output | N | B256H | Output | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 8 | A input | N | EPBBR/W | Input | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 9 | Y output | N | B8H | Output | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 11 | A input | N | E8H | Input | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 12 | Y output | N | BPBBR/W | Output | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 13 | A input | N | E256H | Input | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 14 | Y output | N | BPB?0 | Output | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 15 | A input | N | E4H | Input | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 16 | Y output | N | B1H | Output | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 17 | A input | N | EPBCMRAM | Input | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 18 | Y output | N | B2H | Output | Check | Split from upper LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1P | 74LS244 | 19 | /G enable | Y | Tied low active | Input | Check | Visible tied-low enable in interconnect crop; confirm |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 1 | /G enable | Y | Tied low active | Input | Check | Visible tied-low enable in interconnect crop; confirm |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 2 | A input | N | E5M from connector J17 pin 31 | Input | High | Manual review: E5M received at 1R pins 2 and 17 |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 3 | Y output | N | B5M | Output | High | Manual review: 1R pin 3 labelled B5M |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 4 | A input | N | MAP1 | Input | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 5 | Y output | N | BMAP2 | Output | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 6 | A input | N | MAP0 | Input | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 7 | Y output | N | BRESET | Output | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 8 | A input | N | E32H | Input | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 12 | Y output | N | B32H | Output | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 13 | A input | N | BRESET/J17 pin 2 | Input | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 14 | Y output | N | BMAP0 | Output | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 15 | A input | N | MAP2 | Input | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 16 | Y output | N | BMAP1 | Output | Check | Split from lower LS244 interconnect screenshot; visually confirm exact label |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 17 | A input | N | E5M from connector J17 pin 31 | Input | High | Manual review: E5M received at 1R pins 2 and 17 |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 18 | Y output | N | B5M* | Output | High | Manual review: 1R pin 18 labelled B5M* |
| 2A | Master | Master/Slave Interconnect | 1R | 74LS244 | 19 | /G enable | Y | Tied low active | Input | Check | Visible tied-low enable in interconnect crop; confirm |
| 2A | Master | Master/Slave Interconnect | 8C | 74LS04 | 5 | Input | N | B5M* node from 1R pin 18 | Input | Check | Manual review from Sheet 2A crop; confirm inverter section |
| 2A | Master | Master/Slave Interconnect | 8C | 74LS04 | 6 | Output | N.A. | B5M* labelled output | Output | Check | Manual review from Sheet 2A crop; low-true output naming/polarity should be described in notes not Active Low |
| 2A | Master | Master/Slave Interconnect | 8C | 74LS04 | 8 | Output | N.A. | B5M labelled output | Output | Check | Manual review from Sheet 2A crop; output pin so Active Low is N.A. per convention |
| 2A | Master | Master/Slave Interconnect | 8C | 74LS04 | 9 | Input | N | B5M* node from 1R pin 18 | Input | Check | Manual review from Sheet 2A crop; confirm inverter section |

## Notes

- `Check` rows are seeded from the current schematic audits and RTL comparison only where noted; they are not final schematic facts.
- Preserve reviewer edits in the CSV/Numbers file when syncing this Markdown.
- The Verilog currently uses functional CPU/bus/decode behavior for several Sheet 2A areas, so missing physical IC rows in this checklist do not imply missing runtime behavior.
- `Active Low = Y` is reserved for active-low input/control pins only; outputs use `N.A.` and describe low-true net names or output bubbles in the notes.
- Rows generated from package-level inventory remain `Check` until a focused crop confirms each visible pin/net.
