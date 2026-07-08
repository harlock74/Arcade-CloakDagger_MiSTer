# Schematic Visual Check - Sheet 7A

Reviewer-facing checklist generated from the Sheet 7A visual-check CSV. Keep this file and the CSV in sync; the CSV is the spreadsheet source for `.numbers` updates.

## Summary

- Rows: 433
- High: 331
- Check: 102

## Review Focus

Rows marked `Check` still need visual confirmation against the schematic crop/PDF. Do not promote them to `Checked` until the pin number, label, and connection are readable.

Sheet 7A has expanded visual-check rows for the sync chain, custom timing package, Slave Program ROM bank, Working RAM, and Communication RAM Interconnect. The program ROM bank is represented as the seven visible 2764 columns `1E/1F`, `1F/1H`, `1J`, `1K`, `1L`, `1M`, and `1N`, selected by `PBROM0..PBROM6`.

## Visual Check Table

| Sheet | Board | Section | IC | IC Type | Pin Number | Pin Function | Active Low | Connected To | Direction | Confidence | Reviewer Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 7A | Slave | Sync Clock Source | J17 | Connector | 41 | ECOCKTAIL input | N | ECOCKTAIL | Input | High | Visible at lower-left of sync-chain crop feeding 5K inverter |
| 7A | Slave | Sync Clock Source | 5K | 74LS04 | 3 | Inverter input | N | ECOCKTAIL | Input | High | Visible inverter section in sync-chain crop |
| 7A | Slave | Sync Clock Source | 5K | 74LS04 | 4 | Inverter output | N.A. | ECOCKTAIL inverted/common rail | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 7A | Slave | Sync Clock Source | 8K | 74LS109 | 15 | /PR preset | Y | PR17 pull-up rail | Input | Check | Visible pull-up rail; exact LS109 section mapping still needs datasheet cross-check |
| 7A | Slave | Sync Clock Source | 8K | 74LS109 | 4 | Clock input | N | 10MHZ | Input | High | Visible 10MHZ label into 8K clock pin |
| 7A | Slave | Sync Clock Source | 8K | 74LS109 | 3 | K input | N | Ground | Input | High | Visible ground tie |
| 7A | Slave | Sync Clock Source | 8K | 74LS109 | 5 | Q output | N.A. | 5MHZ | Output | High | Visible 5MHZ label from 8K output |
| 7A | Slave | Sync Clock Source | 8K | 74LS109 | 7 | /Q output | N.A. | UNCLEAR clock output | Output | Check | Pin visible but output label/role not fully readable |
| 7A | Slave | Sync Clock Source | 4K | 74LS109 | 15 | /PR preset | Y | PR17 pull-up rail | Input | Check | Visible pull-up rail; exact LS109 section mapping still needs datasheet cross-check |
| 7A | Slave | Sync Clock Source | 4K | 74LS109 | 14 | J input | N | 5MHZ | Input | High | Visible 5MHZ input label into 4K |
| 7A | Slave | Sync Clock Source | 4K | 74LS109 | 13 | Clock input | N | 10MHZ | Input | High | Visible 10MHZ clock label into 4K |
| 7A | Slave | Sync Clock Source | 4K | 74LS109 | 12 | K input | N | UNCLEAR clock-divider input | Input | Check | Pin visible but exact net label not readable |
| 7A | Slave | Sync Clock Source | 4K | 74LS109 | 10 | Q output | N.A. | 10MHZ/5MHZ divider output | Output | Check | Output pin visible; exact net label/role needs focused crop |
| 7A | Slave | Sync Clock Source | 4K | 74LS109 | 11 | /Q output | N.A. | 10MHZ/5MHZ divider output complement | Output | Check | Output pin visible; exact net label/role needs focused crop |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 2 | Clock input | N | 10MHZ | Input | High | Visible clock label into 4C |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 3 | A load input | N | UNCLEAR load/tie | Input | Check | Pin visible but exact net not readable in current crop |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 4 | B load input | N | UNCLEAR load/tie | Input | Check | Pin visible but exact net not readable in current crop |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 5 | C load input | N | UNCLEAR load/tie | Input | Check | Pin visible but exact net not readable in current crop |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 6 | D load input | N | UNCLEAR load/tie | Input | Check | Pin visible but exact net not readable in current crop |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 7 | EP enable | N | Counter enable chain | Input | Check | Visible enable pin; exact upstream net not fully readable |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 9 | /LOAD input | Y | Horizontal load/control rail | Input | Check | Visible /LD pin; exact net not fully readable |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 10 | ET enable | N | Counter enable chain | Input | Check | Visible enable pin; exact upstream net not fully readable |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 11 | QD output | N.A. | 8H | Output | High | Visible timing output label |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 12 | QC output | N.A. | 4H | Output | High | Visible timing output label |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 13 | QB output | N.A. | 2H | Output | High | Visible timing output label |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 14 | QA output | N.A. | 1H | Output | High | Visible timing output label |
| 7A | Slave | Horizontal Counter Chain | 4C | 74LS163A | 15 | RCO output | N.A. | Cascade carry to 5C | Output | Check | Visible carry route into next counter |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 2 | Clock input | N | 10MHZ | Input | High | Visible clock label into 5C |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 3 | A load input | N | 1H | Input | High | Visible load input label |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 4 | B load input | N | 2H | Input | High | Visible load input label |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 5 | C load input | N | 4H | Input | High | Visible load input label |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 6 | D load input | N | 8H | Input | High | Visible load input label |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 7 | EP enable | N | Cascade enable from 4C | Input | Check | Visible enable connection from 4C carry/enable chain |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 9 | /LOAD input | Y | Horizontal load/control rail | Input | Check | Visible /LD pin; exact net not fully readable |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 10 | ET enable | N | Cascade enable from 4C | Input | Check | Visible enable connection from 4C carry/enable chain |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 11 | QD output | N.A. | 128H | Output | High | Visible timing output label |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 12 | QC output | N.A. | 64H | Output | High | Visible timing output label |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 13 | QB output | N.A. | 32H | Output | High | Visible timing output label |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 14 | QA output | N.A. | 16H | Output | High | Visible timing output label |
| 7A | Slave | Horizontal Counter Chain | 5C | 74LS160 | 15 | RCO output | N.A. | 256H/cascade carry | Output | Check | Visible carry/256H area; exact net role needs confirmation |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 2 | Clock input | N | 256H-derived clock/control | Input | Check | Visible 256H-related line into vertical chain; exact pin/source needs confirmation |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 3 | A load input | N | 1V | Input | High | Visible vertical load/input label |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 4 | B load input | N | 2V | Input | High | Visible vertical load/input label |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 5 | C load input | N | 4V | Input | High | Visible vertical load/input label |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 6 | D load input | N | 8V | Input | High | Visible vertical load/input label |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 7 | EP enable | N | Vertical enable chain | Input | Check | Visible enable pin; exact net not fully readable |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 9 | /LOAD input | Y | Vertical load/control rail | Input | Check | Visible /LD pin; exact net not fully readable |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 10 | ET enable | N | Vertical enable chain | Input | Check | Visible enable pin; exact net not fully readable |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 11 | QD output | N.A. | 8V | Output | High | Visible timing output label |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 12 | QC output | N.A. | 4V | Output | High | Visible timing output label |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 13 | QB output | N.A. | 2V | Output | High | Visible timing output label |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 14 | QA output | N.A. | 1V | Output | High | Visible timing output label |
| 7A | Slave | Vertical Counter Chain | 3M | 74LS163A | 15 | RCO output | N.A. | Cascade carry to 2N | Output | Check | Visible carry route into next counter |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 2 | Clock input | N | 256H-derived clock/control | Input | Check | Visible 256H-related line into vertical chain; exact pin/source needs confirmation |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 3 | A load input | N | 16V | Input | High | Visible vertical load/input label |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 4 | B load input | N | 32V | Input | High | Visible vertical load/input label |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 5 | C load input | N | 64V | Input | High | Visible vertical load/input label |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 6 | D load input | N | 128V | Input | High | Visible vertical load/input label |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 7 | EP enable | N | Vertical enable chain | Input | Check | Visible enable pin; exact net not fully readable |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 9 | /LOAD input | Y | Vertical load/control rail | Input | Check | Visible /LD pin; exact net not fully readable |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 10 | ET enable | N | Vertical enable chain | Input | Check | Visible enable pin; exact net not fully readable |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 11 | QD output | N.A. | 128V | Output | High | Visible timing output label |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 12 | QC output | N.A. | 64V | Output | High | Visible timing output label |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 13 | QB output | N.A. | 32V | Output | High | Visible timing output label |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 14 | QA output | N.A. | 16V | Output | High | Visible timing output label |
| 7A | Slave | Vertical Counter Chain | 2N | 74LS163A | 15 | RCO output | N.A. | 256V/cascade carry | Output | Check | Visible carry/256V area; exact net role needs confirmation |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 15 | A7 address input | N | 128V | Input | High | Visible PROM address label |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 1 | A6 address input | N | 64V | Input | High | Visible PROM address label |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 2 | A5 address input | N | 32V | Input | High | Visible PROM address label |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 3 | A4 address input | N | 16V | Input | High | Visible PROM address label |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 4 | A3 address input | N | 8V | Input | High | Visible PROM address label |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 7 | A2 address input | N | 4V | Input | High | Visible PROM address label |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 6 | A1 address input | N | 2V | Input | High | Visible PROM address label |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 5 | A0 address input | N | 1V | Input | High | Visible PROM address label |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 14 | CE1/chip enable | Y | Ground | Input | Check | Visible tied-low enable; confirm exact 82S129 enable naming |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 13 | CE2/chip enable | Y | Ground | Input | Check | Visible tied-low enable; confirm exact 82S129 enable naming |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 9 | O4 output | N.A. | PROM O4 to 4N | Output | Check | Visible output pin into 4N; exact decoded function assigned after 4N review |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 10 | O3 output | N.A. | PROM O3 to 4N | Output | Check | Visible output pin into 4N; exact decoded function assigned after 4N review |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 11 | O2 output | N.A. | PROM O2 to 4N | Output | Check | Visible output pin into 4N; exact decoded function assigned after 4N review |
| 7A | Slave | Vertical Timing PROM | 3N | 82S129 | 12 | O1 output | N.A. | PROM O1 to 4N | Output | Check | Visible output pin into 4N; exact decoded function assigned after 4N review |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 9 | Clock input | N | 256H | Input | High | Visible 256H clock label |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 4 | D input | N | PROM O4/O3 decoded input | Input | Check | Visible PROM-to-register input; exact bit label not readable |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 5 | D input | N | PROM O4/O3 decoded input | Input | Check | Visible PROM-to-register input; exact bit label not readable |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 12 | D input | N | PROM O2/O1 decoded input | Input | Check | Visible PROM-to-register input; exact bit label not readable |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 13 | D input | N | PROM O2/O1 decoded input | Input | Check | Visible PROM-to-register input; exact bit label not readable |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 2 | Q output | N.A. | VSYNC/VBLANK decoded output | Output | Check | Visible register output; exact net label not fully readable |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 7 | Q output | N.A. | VSYNC | Output | High | Visible VSYNC label |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 10 | Q output | N.A. | VSYNC | Output | High | Visible VSYNC label |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 15 | Q output | N.A. | VBLANK | Output | High | Visible VBLANK label |
| 7A | Slave | Vertical Timing Register | 4N | 74LS175 | 14 | /Q output | N.A. | VBLANK complement | Output | Check | Visible paired VBLANK output; exact label polarity needs confirmation |
| 7A | Slave | Sync Output Logic | 4D | 74LS86 | 12 | XOR input | N | VSYNC | Input | High | Visible VSYNC input label |
| 7A | Slave | Sync Output Logic | 4D | 74LS86 | 13 | XOR input | N | HSYNC | Input | High | Visible HSYNC input label |
| 7A | Slave | Sync Output Logic | 4D | 74LS86 | 11 | XOR output | N.A. | Composite-sync pre-invert | Output | High | Visible output feeding 4B pin 3 |
| 7A | Slave | Sync Output Logic | 4B | 74LS04 | 3 | Inverter input | N | Composite-sync pre-invert from 4D pin 11 | Input | High | Visible input from 4D XOR |
| 7A | Slave | Sync Output Logic | 4B | 74LS04 | 4 | Inverter output | N.A. | COMPSYNC | Output | High | Visible COMPSYNC label/pull-up node |
| 7A | Slave | Sync Output Logic | 4B | 74LS04 | 5 | Inverter input | N | VSYNC | Input | High | Visible VSYNC input label |
| 7A | Slave | Sync Output Logic | 4B | 74LS04 | 6 | Inverter output | N.A. | VSYNC buffered output | Output | High | Visible VSYNC output node/pull-up |
| 7A | Slave | Sync Output Logic | 4B | 74LS04 | 9 | Inverter input | N | HSYNC/256H sync path | Input | Check | Visible inverter input in HSYNC/256H path; exact source needs confirmation |
| 7A | Slave | Sync Output Logic | 4B | 74LS04 | 8 | Inverter output | N.A. | HSYNC pre-output | Output | Check | Visible output feeding COMPSYNC/HSYNC node; exact label needs confirmation |
| 7A | Slave | HBLANK Latch Chain | 3A | 74LS74 | 12 | D input | N | 2H | Input | High | Visible D input label |
| 7A | Slave | HBLANK Latch Chain | 3A | 74LS74 | 11 | Clock input | N | 1H | Input | High | Visible clock input label |
| 7A | Slave | HBLANK Latch Chain | 3A | 74LS74 | 10 | /PR preset | Y | PR13 pull-up rail | Input | Check | Visible pull-up rail |
| 7A | Slave | HBLANK Latch Chain | 3A | 74LS74 | 13 | /CLR clear | Y | 4H | Input | High | Visible clear input label |
| 7A | Slave | HBLANK Latch Chain | 3A | 74LS74 | 9 | Q output | N.A. | 5MHZ-related HBLANK chain node | Output | Check | Visible output into 3B; exact net label not readable |
| 7A | Slave | HBLANK Latch Chain | 3A | 74LS74 | 8 | /Q output | N.A. | 5MHZ-related HBLANK chain node complement | Output | Check | Visible output into 3B; exact net label not readable |
| 7A | Slave | HBLANK Latch Chain | 3B | 74LS74 | 2 | D input | N | 3A output | Input | Check | Visible connection from 3A; exact Q or /Q source needs confirmation |
| 7A | Slave | HBLANK Latch Chain | 3B | 74LS74 | 3 | Clock input | N | 5MHZ | Input | High | Visible 5MHZ clock label |
| 7A | Slave | HBLANK Latch Chain | 3B | 74LS74 | 4 | /PR preset | Y | PR13 pull-up rail | Input | Check | Visible pull-up rail |
| 7A | Slave | HBLANK Latch Chain | 3B | 74LS74 | 1 | /CLR clear | Y | PR13 pull-up rail or clear rail | Input | Check | Visible pull-up/clear rail; exact source not fully readable |
| 7A | Slave | HBLANK Latch Chain | 3B | 74LS74 | 5 | Q output | N.A. | 256H/HBLANK chain node | Output | Check | Visible output into 3C; exact label not readable |
| 7A | Slave | HBLANK Latch Chain | 3B | 74LS74 | 6 | /Q output | N.A. | 256H/HBLANK chain node complement | Output | Check | Visible output into 3C; exact label not readable |
| 7A | Slave | HBLANK Latch Chain | 3C | 74LS74 | 2 | D input | N | 256H | Input | High | Visible D input label |
| 7A | Slave | HBLANK Latch Chain | 3C | 74LS74 | 3 | Clock input | N | 3B output | Input | Check | Visible clock/control from 3B; exact Q or /Q source needs confirmation |
| 7A | Slave | HBLANK Latch Chain | 3C | 74LS74 | 4 | /PR preset | Y | PR13 pull-up rail | Input | Check | Visible pull-up rail |
| 7A | Slave | HBLANK Latch Chain | 3C | 74LS74 | 1 | /CLR clear | Y | PR13 pull-up rail or clear rail | Input | Check | Visible pull-up/clear rail; exact source not fully readable |
| 7A | Slave | HBLANK Latch Chain | 3C | 74LS74 | 5 | Q output | N.A. | HBLANK | Output | High | Visible HBLANK output label |
| 7A | Slave | HBLANK Latch Chain | 3C | 74LS74 | 6 | /Q output | N.A. | HBLANK complement | Output | Check | Visible paired output; exact label polarity needs confirmation |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 13 | XOR input | N | 4H | Input | High | Visible input label |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 12 | XOR input | N | ECOCKTAIL common rail | Input | Check | Visible common ECOCKTAIL rail feeding XOR chain |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 11 | XOR output | N.A. | 4H* | Output | High | Visible output label |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 9 | XOR input | N | 8H | Input | High | Visible input label |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 10 | XOR input | N | ECOCKTAIL common rail | Input | Check | Visible common ECOCKTAIL rail feeding XOR chain |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 8 | XOR output | N.A. | 8H* | Output | High | Visible output label |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 5 | XOR input | N | 16H | Input | High | Visible input label |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 4 | XOR input | N | ECOCKTAIL common rail | Input | Check | Visible common ECOCKTAIL rail feeding XOR chain |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 6 | XOR output | N.A. | 16H* | Output | High | Visible output label |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 1 | XOR input | N | 32H | Input | High | Visible input label |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 2 | XOR input | N | ECOCKTAIL common rail | Input | Check | Visible common ECOCKTAIL rail feeding XOR chain |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 3 | XOR output | N.A. | 32H* | Output | High | Visible output label |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 9 | XOR input | N | 64H | Input | High | Visible input label |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 10 | XOR input | N | ECOCKTAIL common rail | Input | Check | Visible common ECOCKTAIL rail feeding XOR chain |
| 7A | Slave | Horizontal Star Alias Logic | 4D | 74LS86 | 8 | XOR output | N.A. | 64H* | Output | High | Visible output label |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 5 | XOR input | N | 128H | Input | High | Visible input label |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 4 | XOR input | N | ECOCKTAIL common rail | Input | Check | Visible common ECOCKTAIL rail feeding XOR chain |
| 7A | Slave | Horizontal Star Alias Logic | 5F | 74LS86 | 6 | XOR output | N.A. | 128H* | Output | High | Visible output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 2 | CUSTOMWR input | Y | CUSTOMWR | Input | Check | Visible active-low-looking CUSTOMWR label into custom package; exact polarity should be confirmed from net label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 4 | PBBD7 input | N | PBBD7 | Input | High | Visible data input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 5 | PBBD6 input | N | PBBD6 | Input | High | Visible data input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 6 | PBBD5 input | N | PBBD5 | Input | High | Visible data input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 7 | PBBD4 input | N | PBBD4 | Input | High | Visible data input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 8 | PBBD3 input | N | PBBD3 | Input | High | Visible data input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 9 | PBBD2 input | N | PBBD2 | Input | High | Visible data input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 10 | PBBD1 input | N | PBBD1 | Input | High | Visible data input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 11 | PBBD0 input | N | PBBD0 | Input | High | Visible data input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 1 | ECOCKTAIL input | N | ECOCKTAIL | Input | High | Visible ECOCKTAIL input label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 23 | CUSH output | N.A. | CUSH | Output | High | Visible custom output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 22 | CUSG output | N.A. | CUSG | Output | High | Visible custom output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 21 | CUSF output | N.A. | CUSF | Output | High | Visible custom output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 20 | CUSE output | N.A. | CUSE | Output | High | Visible custom output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 19 | CUSD output | N.A. | CUSD | Output | High | Visible custom output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 17 | CUSC output | N.A. | CUSC | Output | High | Visible custom output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 16 | CUSB output | N.A. | CUSB | Output | High | Visible custom output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 15 | CUSA output | N.A. | CUSA | Output | High | Visible custom output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 14 | VBLANK output | N.A. | VBLANK | Output | High | Visible VBLANK output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 13 | 256H output | N.A. | 256H | Output | High | Visible 256H output label |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 24 | VCC | N.A. | +5V | Power | High | Visible +5V rail |
| 7A | Slave | Custom Timing Package | 3H | CUSTOM | 12 | GND | N.A. | Ground | Power | High | Visible ground pin |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 1 | VPP | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 2 | A12 address input | N | PBBA12 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 3 | A7 address input | N | PBBA7 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 4 | A6 address input | N | PBBA6 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 5 | A5 address input | N | PBBA5 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 6 | A4 address input | N | PBBA4 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 7 | A3 address input | N | PBBA3 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 8 | A2 address input | N | PBBA2 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 9 | A1 address input | N | PBBA1 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 10 | A0 address input | N | PBBA0 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 11 | D0 output | N.A. | ROM D0 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 12 | D1 output | N.A. | ROM D1 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 13 | D2 output | N.A. | ROM D2 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 14 | GND | N.A. | Ground | Power | Check | Standard 2764 ground pin; ground symbol not separately readable for each repeated column; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 15 | D3 output | N.A. | ROM D3 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 16 | D4 output | N.A. | ROM D4 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 17 | D5 output | N.A. | ROM D5 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 18 | D6 output | N.A. | ROM D6 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 19 | D7 output | N.A. | ROM D7 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 20 | /CE chip enable | Y | PBROM0 | Input | High | Visible per-ROM PBROM select on pin 20; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 21 | A10 address input | N | PBBA10 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 22 | /OE output enable | Y | Common ROM /OE rail | Input | Check | Common /OE rail visible; appears tied together, final source/tie needs focused confirmation; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 23 | A11 address input | N | PBBA11 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 24 | A9 address input | N | PBBA9 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 25 | A8 address input | N | PBBA8 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 26 | NC | N.A. | +5V/top rail area | NC | Check | Top label shows NC in repeated ROM header; exact tie/no-connect should be visually confirmed; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 27 | PGM input | N | +5V rail | Input | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1E/1F | 2764 | 28 | VCC | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1E/1F |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 1 | VPP | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 2 | A12 address input | N | PBBA12 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 3 | A7 address input | N | PBBA7 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 4 | A6 address input | N | PBBA6 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 5 | A5 address input | N | PBBA5 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 6 | A4 address input | N | PBBA4 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 7 | A3 address input | N | PBBA3 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 8 | A2 address input | N | PBBA2 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 9 | A1 address input | N | PBBA1 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 10 | A0 address input | N | PBBA0 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 11 | D0 output | N.A. | ROM D0 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 12 | D1 output | N.A. | ROM D1 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 13 | D2 output | N.A. | ROM D2 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 14 | GND | N.A. | Ground | Power | Check | Standard 2764 ground pin; ground symbol not separately readable for each repeated column; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 15 | D3 output | N.A. | ROM D3 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 16 | D4 output | N.A. | ROM D4 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 17 | D5 output | N.A. | ROM D5 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 18 | D6 output | N.A. | ROM D6 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 19 | D7 output | N.A. | ROM D7 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 20 | /CE chip enable | Y | PBROM1 | Input | High | Visible per-ROM PBROM select on pin 20; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 21 | A10 address input | N | PBBA10 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 22 | /OE output enable | Y | Common ROM /OE rail | Input | Check | Common /OE rail visible; appears tied together, final source/tie needs focused confirmation; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 23 | A11 address input | N | PBBA11 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 24 | A9 address input | N | PBBA9 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 25 | A8 address input | N | PBBA8 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 26 | NC | N.A. | +5V/top rail area | NC | Check | Top label shows NC in repeated ROM header; exact tie/no-connect should be visually confirmed; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 27 | PGM input | N | +5V rail | Input | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1F/1H | 2764 | 28 | VCC | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1F/1H |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 1 | VPP | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 2 | A12 address input | N | PBBA12 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 3 | A7 address input | N | PBBA7 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 4 | A6 address input | N | PBBA6 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 5 | A5 address input | N | PBBA5 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 6 | A4 address input | N | PBBA4 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 7 | A3 address input | N | PBBA3 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 8 | A2 address input | N | PBBA2 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 9 | A1 address input | N | PBBA1 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 10 | A0 address input | N | PBBA0 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 11 | D0 output | N.A. | ROM D0 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 12 | D1 output | N.A. | ROM D1 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 13 | D2 output | N.A. | ROM D2 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 14 | GND | N.A. | Ground | Power | Check | Standard 2764 ground pin; ground symbol not separately readable for each repeated column; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 15 | D3 output | N.A. | ROM D3 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 16 | D4 output | N.A. | ROM D4 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 17 | D5 output | N.A. | ROM D5 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 18 | D6 output | N.A. | ROM D6 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 19 | D7 output | N.A. | ROM D7 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 20 | /CE chip enable | Y | PBROM2 | Input | High | Visible per-ROM PBROM select on pin 20; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 21 | A10 address input | N | PBBA10 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 22 | /OE output enable | Y | Common ROM /OE rail | Input | Check | Common /OE rail visible; appears tied together, final source/tie needs focused confirmation; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 23 | A11 address input | N | PBBA11 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 24 | A9 address input | N | PBBA9 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 25 | A8 address input | N | PBBA8 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 26 | NC | N.A. | +5V/top rail area | NC | Check | Top label shows NC in repeated ROM header; exact tie/no-connect should be visually confirmed; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 27 | PGM input | N | +5V rail | Input | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1J | 2764 | 28 | VCC | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1J |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 1 | VPP | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 2 | A12 address input | N | PBBA12 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 3 | A7 address input | N | PBBA7 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 4 | A6 address input | N | PBBA6 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 5 | A5 address input | N | PBBA5 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 6 | A4 address input | N | PBBA4 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 7 | A3 address input | N | PBBA3 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 8 | A2 address input | N | PBBA2 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 9 | A1 address input | N | PBBA1 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 10 | A0 address input | N | PBBA0 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 11 | D0 output | N.A. | ROM D0 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 12 | D1 output | N.A. | ROM D1 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 13 | D2 output | N.A. | ROM D2 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 14 | GND | N.A. | Ground | Power | Check | Standard 2764 ground pin; ground symbol not separately readable for each repeated column; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 15 | D3 output | N.A. | ROM D3 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 16 | D4 output | N.A. | ROM D4 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 17 | D5 output | N.A. | ROM D5 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 18 | D6 output | N.A. | ROM D6 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 19 | D7 output | N.A. | ROM D7 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 20 | /CE chip enable | Y | PBROM3 | Input | High | Visible per-ROM PBROM select on pin 20; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 21 | A10 address input | N | PBBA10 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 22 | /OE output enable | Y | Common ROM /OE rail | Input | Check | Common /OE rail visible; appears tied together, final source/tie needs focused confirmation; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 23 | A11 address input | N | PBBA11 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 24 | A9 address input | N | PBBA9 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 25 | A8 address input | N | PBBA8 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 26 | NC | N.A. | +5V/top rail area | NC | Check | Top label shows NC in repeated ROM header; exact tie/no-connect should be visually confirmed; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 27 | PGM input | N | +5V rail | Input | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1K | 2764 | 28 | VCC | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1K |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 1 | VPP | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 2 | A12 address input | N | PBBA12 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 3 | A7 address input | N | PBBA7 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 4 | A6 address input | N | PBBA6 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 5 | A5 address input | N | PBBA5 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 6 | A4 address input | N | PBBA4 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 7 | A3 address input | N | PBBA3 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 8 | A2 address input | N | PBBA2 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 9 | A1 address input | N | PBBA1 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 10 | A0 address input | N | PBBA0 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 11 | D0 output | N.A. | ROM D0 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 12 | D1 output | N.A. | ROM D1 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 13 | D2 output | N.A. | ROM D2 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 14 | GND | N.A. | Ground | Power | Check | Standard 2764 ground pin; ground symbol not separately readable for each repeated column; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 15 | D3 output | N.A. | ROM D3 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 16 | D4 output | N.A. | ROM D4 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 17 | D5 output | N.A. | ROM D5 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 18 | D6 output | N.A. | ROM D6 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 19 | D7 output | N.A. | ROM D7 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 20 | /CE chip enable | Y | PBROM4 | Input | High | Visible per-ROM PBROM select on pin 20; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 21 | A10 address input | N | PBBA10 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 22 | /OE output enable | Y | Common ROM /OE rail | Input | Check | Common /OE rail visible; appears tied together, final source/tie needs focused confirmation; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 23 | A11 address input | N | PBBA11 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 24 | A9 address input | N | PBBA9 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 25 | A8 address input | N | PBBA8 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 26 | NC | N.A. | +5V/top rail area | NC | Check | Top label shows NC in repeated ROM header; exact tie/no-connect should be visually confirmed; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 27 | PGM input | N | +5V rail | Input | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1L | 2764 | 28 | VCC | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1L |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 1 | VPP | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 2 | A12 address input | N | PBBA12 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 3 | A7 address input | N | PBBA7 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 4 | A6 address input | N | PBBA6 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 5 | A5 address input | N | PBBA5 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 6 | A4 address input | N | PBBA4 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 7 | A3 address input | N | PBBA3 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 8 | A2 address input | N | PBBA2 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 9 | A1 address input | N | PBBA1 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 10 | A0 address input | N | PBBA0 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 11 | D0 output | N.A. | ROM D0 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 12 | D1 output | N.A. | ROM D1 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 13 | D2 output | N.A. | ROM D2 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 14 | GND | N.A. | Ground | Power | Check | Standard 2764 ground pin; ground symbol not separately readable for each repeated column; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 15 | D3 output | N.A. | ROM D3 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 16 | D4 output | N.A. | ROM D4 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 17 | D5 output | N.A. | ROM D5 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 18 | D6 output | N.A. | ROM D6 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 19 | D7 output | N.A. | ROM D7 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 20 | /CE chip enable | Y | PBROM5 | Input | High | Visible per-ROM PBROM select on pin 20; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 21 | A10 address input | N | PBBA10 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 22 | /OE output enable | Y | Common ROM /OE rail | Input | Check | Common /OE rail visible; appears tied together, final source/tie needs focused confirmation; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 23 | A11 address input | N | PBBA11 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 24 | A9 address input | N | PBBA9 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 25 | A8 address input | N | PBBA8 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 26 | NC | N.A. | +5V/top rail area | NC | Check | Top label shows NC in repeated ROM header; exact tie/no-connect should be visually confirmed; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 27 | PGM input | N | +5V rail | Input | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1M | 2764 | 28 | VCC | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1M |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 1 | VPP | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 2 | A12 address input | N | PBBA12 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 3 | A7 address input | N | PBBA7 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 4 | A6 address input | N | PBBA6 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 5 | A5 address input | N | PBBA5 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 6 | A4 address input | N | PBBA4 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 7 | A3 address input | N | PBBA3 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 8 | A2 address input | N | PBBA2 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 9 | A1 address input | N | PBBA1 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 10 | A0 address input | N | PBBA0 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 11 | D0 output | N.A. | ROM D0 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 12 | D1 output | N.A. | ROM D1 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 13 | D2 output | N.A. | ROM D2 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 14 | GND | N.A. | Ground | Power | Check | Standard 2764 ground pin; ground symbol not separately readable for each repeated column; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 15 | D3 output | N.A. | ROM D3 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 16 | D4 output | N.A. | ROM D4 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 17 | D5 output | N.A. | ROM D5 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 18 | D6 output | N.A. | ROM D6 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 19 | D7 output | N.A. | ROM D7 bus to 2E LS245 | Output | High | Visible ROM data bus to output buffer; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 20 | /CE chip enable | Y | PBROM6 | Input | High | Visible per-ROM PBROM select on pin 20; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 21 | A10 address input | N | PBBA10 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 22 | /OE output enable | Y | Common ROM /OE rail | Input | Check | Common /OE rail visible; appears tied together, final source/tie needs focused confirmation; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 23 | A11 address input | N | PBBA11 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 24 | A9 address input | N | PBBA9 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 25 | A8 address input | N | PBBA8 | Input | High | Visible address bus label; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 26 | NC | N.A. | +5V/top rail area | NC | Check | Top label shows NC in repeated ROM header; exact tie/no-connect should be visually confirmed; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 27 | PGM input | N | +5V rail | Input | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM | 1N | 2764 | 28 | VCC | N.A. | +5V rail | Power | High | Top rail visibly tied to +5V; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png; visible ROM column label 1N |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 1 | DIR direction input | N | UNCLEAR direction/control net | Input | Check | Pin visible on LS245; exact direction source not readable in crop |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 2 | A1 bus pin | N | ROM D0 bus | Bidirectional | High | Visible ROM data bus into LS245; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 3 | A2 bus pin | N | ROM D1 bus | Bidirectional | High | Visible ROM data bus into LS245; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 4 | A3 bus pin | N | ROM D2 bus | Bidirectional | High | Visible ROM data bus into LS245; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 5 | A4 bus pin | N | ROM D3 bus | Bidirectional | High | Visible ROM data bus into LS245; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 6 | A5 bus pin | N | ROM D4 bus | Bidirectional | High | Visible ROM data bus into LS245; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 7 | A6 bus pin | N | ROM D5 bus | Bidirectional | High | Visible ROM data bus into LS245; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 8 | A7 bus pin | N | ROM D6 bus | Bidirectional | High | Visible ROM data bus into LS245; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 9 | A8 bus pin | N | ROM D7 bus | Bidirectional | High | Visible ROM data bus into LS245; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 10 | GND | N.A. | Ground | Power | Check | Standard LS245 ground pin; not independently labelled in crop |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 11 | B1 bus pin | N | BD7 | Bidirectional | High | Visible BD7 label on LS245 output side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 12 | B2 bus pin | N | BD6 | Bidirectional | High | Visible BD6 label on LS245 output side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 13 | B3 bus pin | N | BD5 | Bidirectional | High | Visible BD5 label on LS245 output side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 14 | B4 bus pin | N | BD4 | Bidirectional | High | Visible BD4 label on LS245 output side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 15 | B5 bus pin | N | BD3 | Bidirectional | High | Visible BD3 label on LS245 output side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 16 | B6 bus pin | N | BD2 | Bidirectional | High | Visible BD2 label on LS245 output side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 17 | B7 bus pin | N | BD1 | Bidirectional | High | Visible BD1 label on LS245 output side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 18 | B8 bus pin | N | BD0 | Bidirectional | High | Visible BD0 label on LS245 output side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 19 | /G enable | Y | PBBR/W | Input | High | Visible PBBR/W label at LS245 enable pin 19 |
| 7A | Slave | Slave Program ROM Output Buffer | 2E | 74LS245 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS245 power pin; not independently labelled in crop |
| 7A | Slave | Slave Program ROM Select Glue | 5K | 74LS04 | 13 | Inverter input | N | PBROM select glue net | Input | Check | Visible 5K inverter in lower-right ROM select area; exact input label partly unclear |
| 7A | Slave | Slave Program ROM Select Glue | 5K | 74LS04 | 12 | Inverter output | N.A. | PBROM select glue net | Output | Check | Visible 5K inverter output feeding 6J area; exact label partly unclear |
| 7A | Slave | Slave Program ROM Select Glue | 6J | 74LS00 | 1 | NAND input | N | SUB / PBROM select term | Input | Check | Visible LS00 gate in ROM select area; exact input label partly unclear |
| 7A | Slave | Slave Program ROM Select Glue | 6J | 74LS00 | 2 | NAND input | N | PBROM select term | Input | Check | Visible LS00 gate in ROM select area; exact input label partly unclear |
| 7A | Slave | Slave Program ROM Select Glue | 6J | 74LS00 | 3 | NAND output | N.A. | ROM select output term | Output | Check | Visible LS00 output in ROM select area; exact output label partly unclear |
| 7A | Slave | Working RAM | 2K | 6116-2 | 1 | A7 address input | N | PBBA7 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 2 | A6 address input | N | PBBA6 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 3 | A5 address input | N | PBBA5 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 4 | A4 address input | N | PBBA4 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 5 | A3 address input | N | PBBA3 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 6 | A2 address input | N | PBBA2 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 7 | A1 address input | N | PBBA1 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 8 | A0 address input | N | PBBA0 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 9 | I/O1 data | N | Slave data bus bit 0/1 area | Bidirectional | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 10 | I/O2 data | N | Slave data bus bit 1/2 area | Bidirectional | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 11 | I/O3 data | N | Slave data bus bit 2/3 area | Bidirectional | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 12 | GND | N.A. | Ground | Power | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 13 | I/O4 data | N | Slave data bus bit 3/4 area | Bidirectional | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 14 | I/O5 data | N | Slave data bus bit 4/5 area | Bidirectional | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 15 | I/O6 data | N | Slave data bus bit 5/6 area | Bidirectional | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 16 | I/O7 data | N | Slave data bus bit 6/7 area | Bidirectional | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 17 | I/O8 data | N | Slave data bus bit 7/8 area | Bidirectional | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 18 | /CE chip enable | Y | PBRAM | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 19 | A10 address input | N | PBBA10 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 20 | /OE output enable | Y | Output enable tied/rail | Input | Check | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 21 | /WE write enable | Y | 3L pin 6 write-enable output | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 22 | A9 address input | N | PBBA9 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 23 | A8 address input | N | PBBA8 | Input | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM | 2K | 6116-2 | 24 | VCC | N.A. | +5V | Power | High | Visible Working RAM block; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Working RAM Glue | 3L | 74LS32 | 4 | OR input | N | PBWRITE | Input | High | Visible PBWRITE into 3L gate |
| 7A | Slave | Working RAM Glue | 3L | 74LS32 | 5 | OR input | N | PBRAM | Input | High | Visible PBRAM into 3L gate |
| 7A | Slave | Working RAM Glue | 3L | 74LS32 | 6 | OR output | N.A. | 2K pin 21 /WE | Output | High | Visible output to 2K WE/OE area |
| 7A | Slave | Communication RAM Interconnect | J17 | Connector | 42 | EPBBD7 connector pin | N | EPBBD7 | Bidirectional | High | Visible J17 pin 42 in communication RAM interconnect crop |
| 7A | Slave | Communication RAM Interconnect | J17 | Connector | 43 | EPBBD6 connector pin | N | EPBBD6 | Bidirectional | High | Visible J17 pin 43 in communication RAM interconnect crop |
| 7A | Slave | Communication RAM Interconnect | J17 | Connector | 44 | EPBBD5 connector pin | N | EPBBD5 | Bidirectional | High | Visible J17 pin 44 in communication RAM interconnect crop |
| 7A | Slave | Communication RAM Interconnect | J17 | Connector | 45 | EPBBD4 connector pin | N | EPBBD4 | Bidirectional | High | Visible J17 pin 45 in communication RAM interconnect crop |
| 7A | Slave | Communication RAM Interconnect | J17 | Connector | 46 | EPBBD3 connector pin | N | EPBBD3 | Bidirectional | High | Visible J17 pin 46 in communication RAM interconnect crop |
| 7A | Slave | Communication RAM Interconnect | J17 | Connector | 47 | EPBBD2 connector pin | N | EPBBD2 | Bidirectional | High | Visible J17 pin 47 in communication RAM interconnect crop |
| 7A | Slave | Communication RAM Interconnect | J17 | Connector | 48 | EPBBD1 connector pin | N | EPBBD1 | Bidirectional | High | Visible J17 pin 48 in communication RAM interconnect crop |
| 7A | Slave | Communication RAM Interconnect | J17 | Connector | 49 | EPBBD0 connector pin | N | EPBBD0 | Bidirectional | High | Visible J17 pin 49 in communication RAM interconnect crop |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 1 | DIR direction input | N | D/R control | Input | High | Visible D/R label on LS245 pin 1 |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 2 | A1 bus pin | N | EPBBD0 | Bidirectional | High | Visible EPBBD0 side to J17; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 3 | A2 bus pin | N | EPBBD1 | Bidirectional | High | Visible EPBBD1 side to J17; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 4 | A3 bus pin | N | EPBBD2 | Bidirectional | High | Visible EPBBD2 side to J17; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 5 | A4 bus pin | N | EPBBD3 | Bidirectional | High | Visible EPBBD3 side to J17; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 6 | A5 bus pin | N | EPBBD4 | Bidirectional | High | Visible EPBBD4 side to J17; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 7 | A6 bus pin | N | EPBBD5 | Bidirectional | High | Visible EPBBD5 side to J17; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 8 | A7 bus pin | N | EPBBD6 | Bidirectional | High | Visible EPBBD6 side to J17; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 9 | A8 bus pin | N | EPBBD7 | Bidirectional | High | Visible EPBBD7 side to J17; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 10 | GND | N.A. | Ground | Power | Check | Standard LS245 ground pin; not independently labelled in crop |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 11 | B1 bus pin | N | PBBD7 | Bidirectional | High | Visible PBBD7 label on LS245 side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 12 | B2 bus pin | N | PBBD6 | Bidirectional | High | Visible PBBD6 label on LS245 side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 13 | B3 bus pin | N | PBBD5 | Bidirectional | High | Visible PBBD5 label on LS245 side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 14 | B4 bus pin | N | PBBD4 | Bidirectional | High | Visible PBBD4 label on LS245 side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 15 | B5 bus pin | N | PBBD3 | Bidirectional | High | Visible PBBD3 label on LS245 side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 16 | B6 bus pin | N | PBBD2 | Bidirectional | High | Visible PBBD2 label on LS245 side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 17 | B7 bus pin | N | PBBD1 | Bidirectional | High | Visible PBBD1 label on LS245 side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 18 | B8 bus pin | N | PBBD0 | Bidirectional | High | Visible PBBD0 label on LS245 side; Visible in /private/tmp/cloak_sheet_review/Sheet7A_full_readable.png |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 19 | /G enable | Y | PBCMRAM | Input | High | Visible PBCMRAM label at LS245 enable pin 19 |
| 7A | Slave | Communication RAM Interconnect | 2H/J | 74LS245 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS245 power pin; not independently labelled in crop |

## Notes

- `Check` rows are seeded from the current schematic audits and visual sheet crops where noted; they are not final schematic facts.
- Preserve reviewer edits in the CSV/Numbers file when syncing this Markdown.
- Power pins or standard package pins marked `Check` usually mean the standard pin function is known but the individual rail mark is not independently readable for every repeated package column.
