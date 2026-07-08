# Sheet 4B Visual Check Table

- Total rows: 225
- High rows: 198
- Check rows: 0
- Checked rows: 27
- Check rows grouped by IC:
  - None
- Checked rows grouped by IC:
  - 7K: pin 7 (ENP), pin 10 (ENT), pin 15 (RIP)
  - 7M: pin 7 (ENP), pin 10 (ENT), pin 15 (RIP)
  - 6F: pin 6 (/Q)
  - 10H: pin 11 (C1 input)
  - 11J: pin 2 (A input), pin 3 (B input), pin 13 (B input), pin 14 (A input)
  - 8C: pin 3 (input), pin 4 (output)
  - 8D: pin 4 (OR input), pin 5 (OR input), pin 6 (OR output)
  - 1L: pin 1 (NOR input), pin 2 (NOR input), pin 12 (NOR output), pin 13 (NOR input)
  - 8E: pin 1 (input), pin 2 (input), pin 3 (output), pin 11 (output), pin 12 (input), pin 13 (input)

Visual-check table is schematic-facing only. RTL aliases and implementation notes are intentionally omitted. Schematic net B5M must not be confused with RTL legacy alias bsm.

## Visual Check Rows

| Sheet | Board | Section | IC | IC Type | Pin Number | Pin Function | Active Low | Connected To | Direction | Confidence | Reviewer Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 1 | /CLR | Y | MOHRO; off-sheet MOHRO; also 7K pin 1 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 2 | CLK | N | B5M; off-sheet timing rail; also counters and 93422/9T | Input | High | Confirm label reads B5M |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 3 | A preload | N | MOD0; off-sheet MOD0 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 4 | B preload | N | MOD1; off-sheet MOD1 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 5 | C preload | N | MOD2; off-sheet MOD2 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 6 | D preload | N | MOD3; off-sheet MOD3 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 7 | ENP | N | pullup rail via PR174; PR174 pullup bus | Tied | High | Confirm pull-up rail |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 9 | /LOAD | Y | MOHLO; off-sheet MOHLO; also 7K pin 9 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 10 | ENT | N | pullup rail via PR174; PR174 pullup bus | Tied | High | Confirm pull-up rail |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 11 | QD | N | address bit to 8J A3; 8J pin 1 A3 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 12 | QC | N | address bit to 8J A2; 8J pin 2 A2 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 13 | QB | N | address bit to 8J A1; 8J pin 3 A1 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 14 | QA | N | address bit to 8J A0; 8J pin 4 A0 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7J | 74LS163A | 15 | RIP | N | cascade ripple; 7K pin 10 ENT | Output | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 1 | /CLR | Y | MOHRO; off-sheet MOHRO; also 7J pin 1 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 2 | CLK | N | B5M; off-sheet timing rail; also counters and 93422/9T | Input | High | Confirm label reads B5M |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 3 | A preload | N | MOD4; off-sheet MOD4 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 4 | B preload | N | MOD5; off-sheet MOD5 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 5 | C preload | N | MOD6; off-sheet MOD6 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 6 | D preload | N | MOD7; off-sheet MOD7 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 7 | ENP | N | 7J RIP/cascade node; 7J pin 15 and 7K pin 10 node | Input | Checked | Confirmed |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 9 | /LOAD | Y | MOHLO; off-sheet MOHLO; also 7J pin 9 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 10 | ENT | N | 7J RIP/cascade node; 7J pin 15 and 7K pin 7 node | Input | Checked | Confirmed |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 11 | QD | N | address bit to 8J A7; 8J pin 7 A7 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 12 | QC | N | address bit to 8J A6; 8J pin 6 A6 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 13 | QB | N | address bit to 8J A5; 8J pin 5 A5 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 14 | QA | N | address bit to 8J A4; 8J pin 21 A4 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7K | 74LS163A | 15 | RIP | N | no visible downstream use; local/no visible destination | Output | Checked | Confirmed no hidden connection |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 1 | /CLR | Y | MOHRI; off-sheet MOHRI; also 7M pin 1 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 2 | CLK | N | B5M; off-sheet timing rail; also counters and 93422/9T | Input | High | Confirm label reads B5M |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 3 | A preload | N | MOD0; off-sheet MOD0 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 4 | B preload | N | MOD1; off-sheet MOD1 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 5 | C preload | N | MOD2; off-sheet MOD2 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 6 | D preload | N | MOD3; off-sheet MOD3 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 7 | ENP | N | pullup rail via PR174; PR174 pullup bus | Tied | High | Confirm pull-up rail |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 9 | /LOAD | Y | MOHLI; off-sheet MOHLI; also 7M pin 9 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 10 | ENT | N | pullup rail via PR174; PR174 pullup bus | Tied | High | Confirm pull-up rail |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 11 | QD | N | address bit to 8L A3; 8L pin 1 A3 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 12 | QC | N | address bit to 8L A2; 8L pin 2 A2 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 13 | QB | N | address bit to 8L A1; 8L pin 3 A1 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 14 | QA | N | address bit to 8L A0; 8L pin 4 A0 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7L | 74LS163A | 15 | RIP | N | cascade ripple; 7M pin 10 ENT | Output | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 1 | /CLR | Y | MOHRI; off-sheet MOHRI; also 7L pin 1 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 2 | CLK | N | B5M; off-sheet timing rail; also counters and 93422/9T | Input | High | Confirm label reads B5M |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 3 | A preload | N | MOD4; off-sheet MOD4 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 4 | B preload | N | MOD5; off-sheet MOD5 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 5 | C preload | N | MOD6; off-sheet MOD6 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 6 | D preload | N | MOD7; off-sheet MOD7 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 7 | ENP | N | 7L RIP/cascade node; 7L pin 15 and 7M pin 10 node | Input | Checked | Confirmed |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 9 | /LOAD | Y | MOHLI; off-sheet MOHLI; also 7L pin 9 | Input | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 10 | ENT | N | 7L RIP/cascade node; 7L pin 15 and 7M pin 7 node | Input | Checked | Confirmed |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 11 | QD | N | address bit to 8L A7; 8L pin 7 A7 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 12 | QC | N | address bit to 8L A6; 8L pin 6 A6 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 13 | QB | N | address bit to 8L A5; 8L pin 5 A5 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 14 | QA | N | address bit to 8L A4; 8L pin 21 A4 | Output | High |  |
| 4B | Master | Motion Object Buffers | 7M | 74LS163A | 15 | RIP | N | Not connected | Output | Checked | Confirmed no hidden connection |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 1 | Select | N | MOHLI; off-sheet MOHLI; select for all four muxes | Input | High | Select pin is not active-low; confirm net label |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 2 | A input | Y | MBJ3*; off-sheet MBJ3* | Input | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 3 | B input | N | LB03; 9T pin 9 feedback / 9H pin 11 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 4 | Y output | N | D1; 8J pin 9 D1 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 5 | A input | Y | MBJ1*; off-sheet MBJ1* | Input | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 6 | B input | N | LB01; 9T pin 15 feedback / 9H pin 14 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 7 | Y output | N | D2; 8J pin 11 D2 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 9 | Y output | N | D4; 8J pin 15 D4 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 10 | B input | N | LB00; 9T pin 6 feedback / 9H pin 2 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 11 | A input | Y | MBJ0*; off-sheet MBJ0* | Input | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 12 | Y output | N | D3; 8J pin 13 D3 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 13 | B input | N | LB02; 9T pin 12 feedback / 9H pin 5 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 14 | A input | Y | MBJ2*; off-sheet MBJ2* | Input | High |  |
| 4B | Master | Motion Object Buffers | 8K | 74LS157 | 15 | /G enable | Y | IVDBH; off-sheet IVDBH | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 1 | Select | N | MOHRI; off-sheet MOHRI; select for all four muxes | Input | High | Select pin is not active-low; confirm net label |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 2 | A input | Y | MBJ0*; off-sheet MBJ0* | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 3 | B input | N | LB10; 9T pin 5 feedback / 9H pin 3 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 4 | Y output | N | D1; 8L pin 9 D1 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 5 | A input | Y | MBJ1*; off-sheet MBJ1* | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 6 | B input | N | LB11; 9T pin 16 feedback / 9H pin 13 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 7 | Y output | N | D2; 8L pin 11 D2 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 9 | Y output | N | D4; 8L pin 15 D4 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 10 | B input | N | LB13; 9T pin 2 feedback / 9H pin 10 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 11 | A input | Y | MBJ3*; off-sheet MBJ3* | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 12 | Y output | N | D3; 8L pin 13 D3 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 13 | B input | N | LB12; 9T pin 19 feedback / 9H pin 6 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 14 | A input | Y | MBJ2*; off-sheet MBJ2* | Input | High |  |
| 4B | Master | Motion Object Buffers | 8M | 74LS157 | 15 | /G enable | Y | IVDBH; off-sheet IVDBH | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 1 | A3 | N | address from 7J QD; 7J pin 11 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 2 | A2 | N | address from 7J QC; 7J pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 3 | A1 | N | address from 7J QB; 7J pin 13 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 4 | A0 | N | address from 7J QA; 7J pin 14 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 5 | A5 | N | address from 7K QB; 7K pin 13 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 6 | A6 | N | address from 7K QC; 7K pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 7 | A7 | N | address from 7K QD; 7K pin 11 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 9 | D1 | N | D1 from 8K; 8K pin 4 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 10 | O1 | N | LB00; 9T pin 7 D and feedback to 8K pin 10 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 11 | D2 | N | D2 from 8K; 8K pin 7 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 12 | O2 | N | LB01; 9T pin 14 D and feedback to 8K pin 6 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 13 | D3 | N | D3 from 8K; 8K pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 14 | O3 | N | LB02; 9T pin 13 D and feedback to 8K pin 13 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 15 | D4 | N | D4 from 8K; 8K pin 9 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 16 | O4 | N | LB03; 9T pin 8 D and feedback to 8K pin 3 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 17 | CS2 | Y | tied active via grounded rail/PR174; ground/pull network | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 18 | OE | Y | tied active via grounded rail/PR174; ground/pull network | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 19 | CS1 | Y | tied active via grounded rail/PR174; ground/pull network | Input | High |  |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 20 | WE | Y | B5M; off-sheet timing rail | Input | High | Confirm label reads B5M |
| 4B | Master | Motion Object Buffers | 8J | 93422 | 21 | A4 | N | address from 7K QA; 7K pin 14 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 1 | A3 | N | address from 7L QD; 7L pin 11 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 2 | A2 | N | address from 7L QC; 7L pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 3 | A1 | N | address from 7L QB; 7L pin 13 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 4 | A0 | N | address from 7L QA; 7L pin 14 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 5 | A5 | N | address from 7M QB; 7M pin 13 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 6 | A6 | N | address from 7M QC; 7M pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 7 | A7 | N | address from 7M QD; 7M pin 11 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 9 | D1 | N | D1 from 8M; 8M pin 4 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 10 | O1 | N | LB10; 9T pin 4 D and feedback to 8M pin 3 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 11 | D2 | N | D2 from 8M; 8M pin 7 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 12 | O2 | N | LB11; 9T pin 17 D and feedback to 8M pin 6 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 13 | D3 | N | D3 from 8M; 8M pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 14 | O3 | N | LB12; 9T pin 18 D and feedback to 8M pin 13 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 15 | D4 | N | D4 from 8M; 8M pin 9 | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 16 | O4 | N | LB13; 9T pin 3 D and feedback to 8M pin 10 | Output | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 17 | CS2 | Y | tied active via grounded rail/PR174; ground/pull network | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 18 | OE | Y | tied active via grounded rail/PR174; ground/pull network | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 19 | CS1 | Y | tied active via grounded rail/PR174; ground/pull network | Input | High |  |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 20 | WE | Y | B5M; off-sheet timing rail | Input | High | Confirm label reads B5M |
| 4B | Master | Motion Object Buffers | 8L | 93422 | 21 | A4 | N | address from 7M QA; 7M pin 14 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 1 | /CLR | Y | pullup rail PR174; PR174, held inactive | Tied | High | Confirm pull-up rail |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 2 | Q | N | LB13; feedback to 8M pin 10 and 9H pin 10 | Output | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 3 | D | N | O4 from 8L; 8L pin 16 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 4 | D | N | O1 from 8L; 8L pin 10 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 5 | Q | N | LB10; feedback to 8M pin 3 and 9H pin 3 | Output | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 6 | Q | N | LB00; feedback to 8K pin 10 and 9H pin 2 | Output | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 7 | D | N | O1 from 8J; 8J pin 10 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 8 | D | N | O4 from 8J; 8J pin 16 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 9 | Q | N | LB03; feedback to 8K pin 3 and 9H pin 11 | Output | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 11 | CLK | N | B5M; off-sheet timing rail | Input | High | Confirm label reads B5M |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 12 | Q | N | LB02; feedback to 8K pin 13 and 9H pin 5 | Output | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 13 | D | N | O3 from 8J; 8J pin 14 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 14 | D | N | O2 from 8J; 8J pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 15 | Q | N | LB01; feedback to 8K pin 6 and 9H pin 14 | Output | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 16 | Q | N | LB11; feedback to 8M pin 6 and 9H pin 13 | Output | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 17 | D | N | O2 from 8L; 8L pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 18 | D | N | O3 from 8L; 8L pin 14 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9T | 74LS273 | 19 | Q | N | LB12; feedback to 8M pin 13 and 9H pin 6 | Output | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 1 | Select | N | VDBH; off-sheet VDBH | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 2 | A input | N | LB00; 9T pin 6 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 3 | B input | N | LB10; 9T pin 5 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 4 | Y output | N | MBIT0; video logic; 9K input | Output | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 5 | A input | N | LB02; 9T pin 12 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 6 | B input | N | LB12; 9T pin 19 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 7 | Y output | N | MBIT2; video logic; 9K input | Output | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 9 | Y output | N | MBIT3; video logic; 9K input | Output | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 10 | B input | N | LB13; 9T pin 2 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 11 | A input | N | LB03; 9T pin 9 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 12 | Y output | N | MBIT1; video logic; 9K input | Output | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 13 | B input | N | LB11; 9T pin 16 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 14 | A input | N | LB01; 9T pin 15 | Input | High |  |
| 4B | Master | Motion Object Buffers | 9H | 74LS157 | 15 | /G enable | Y | ground; direct ground | Tied | High | Confirm tied to ground |
| 4B | Master | Video / Colour | 6F | 74LS74 | 1 | /CLR | Y | pullup rail PR173; PR173 | Tied | High | Confirm pull-up rail |
| 4B | Master | Video / Colour | 6F | 74LS74 | 2 | D | N | 128H; off-sheet timing rail | Input | High |  |
| 4B | Master | Video / Colour | 6F | 74LS74 | 3 | CLK | N | B8H; off-sheet timing rail | Input | High |  |
| 4B | Master | Video / Colour | 6F | 74LS74 | 4 | /PRE | Y | pullup rail PR173; PR173 | Tied | High | Confirm pull-up rail |
| 4B | Master | Video / Colour | 6F | 74LS74 | 5 | Q | N | video timing select; feeds 10H/10J select path | Output | High |  |
| 4B | Master | Video / Colour | 6F | 74LS74 | 6 | /Q | Y | Not connected | Output | Checked | Confirmed no hidden connection |
| 4B | Master | Video / Colour | 10H | 74LS153 | 1 | /1G | Y | ground; direct ground | Tied | High | Confirm tied to ground |
| 4B | Master | Video / Colour | 10H | 74LS153 | 2 | B select | N | COLSEL0; off-sheet/control logic | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 3 | C1 input | N | PBIT3; playfield bit | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 4 | C2 input | N | MBIT3; 9H output / motion bit | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 5 | C3 input | N | PABA3; CPU/address related off-sheet net | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 6 | C0 input | N | PBIT2; playfield bit | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 7 | Y output | N | COLA2; off-sheet/final color output | Output | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 9 | Y output | N | COLA3; off-sheet/final color output | Output | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 10 | C0 input | N | PBIT3; playfield bit | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 11 | C1 input | N | 6F Pin 5 | Input | Checked | Confirmed |
| 4B | Master | Video / Colour | 10H | 74LS153 | 12 | C2 input | N | MBIT3; 9H output / motion bit | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 13 | C3 input | N | PABA3; CPU/address related off-sheet net | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 14 | A select | N | COLSEL0; off-sheet/control logic | Input | High |  |
| 4B | Master | Video / Colour | 10H | 74LS153 | 15 | /2G | Y | ground; direct ground | Tied | High | Confirm tied to ground |
| 4B | Master | Video / Colour | 10J | 74LS153 | 1 | /1G | Y | ground; direct ground | Tied | High | Confirm tied to ground |
| 4B | Master | Video / Colour | 10J | 74LS153 | 2 | B select | N | COLSEL0; off-sheet/control logic | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 3 | C1 input | N | PABA0; CPU/address related off-sheet net | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 4 | C2 input | N | MBIT0; 9H output / motion bit | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 5 | C1 input | N | BMAP2; bitmap bit | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 6 | C0 input | N | PBIT0; playfield bit | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 7 | Y output | N | COLA0; off-sheet/final color output | Output | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 9 | Y output | N | COLA1; off-sheet/final color output | Output | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 10 | C0 input | N | PBIT1; playfield bit | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 11 | C1 input | N | BMAP1; bitmap bit | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 12 | C2 input | N | MBIT1; 9H output / motion bit | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 13 | C3 input | N | PABA1; CPU/address related off-sheet net | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 14 | A select | N | COLSEL0; off-sheet/control logic | Input | High |  |
| 4B | Master | Video / Colour | 10J | 74LS153 | 15 | /2G | Y | ground; direct ground | Tied | High | Confirm tied to ground |
| 4B | Master | Video / Colour | 11J | 74LS157 | 1 | Select | N | COLRAM; off-sheet COLRAM | Input | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 2 | A input | N | pull-up rail PR176; PR176 pull-up rail | Tied | Checked | Confirmed pull-up rail PR176 |
| 4B | Master | Video / Colour | 11J | 74LS157 | 3 | B input | N | pull-up rail PR176; PR176 pull-up rail | Tied | Checked | Confirmed pull-up rail PR176 |
| 4B | Master | Video / Colour | 11J | 74LS157 | 4 | Y output | N | unused/local output; no visible labelled destination | Output | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 5 | A input | N | PABA4; off-sheet PABA4 | Input | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 6 | B input | N | COLSEL0; lower Sheet 4B color select logic | Input | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 7 | Y output | N | COLA4; off-sheet/final color output | Output | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 9 | Y output | N | COLA5; off-sheet/final color output | Output | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 10 | B input | N | COLSEL1; lower Sheet 4B color select logic | Input | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 11 | A input | N | PABA5; off-sheet PABA5 | Input | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 12 | Y output | N | unused/local output; no visible labelled destination | Output | High | Confirm IC designator 11J |
| 4B | Master | Video / Colour | 11J | 74LS157 | 13 | B input | N | pull-up rail PR176; PR176 pull-up rail | Tied | Checked | Confirmed pull-up rail PR176 |
| 4B | Master | Video / Colour | 11J | 74LS157 | 14 | A input | N | pull-up rail PR176; PR176 pull-up rail | Tied | Checked | Confirmed pull-up rail PR176 |
| 4B | Master | Video / Colour | 11J | 74LS157 | 15 | /G enable | Y | ground; direct ground | Tied | High | Confirm tied to ground |
| 4B | Master | Video / Colour | 9K | 74LS260 | 1 | input | N | MBIT3; 9H output/local MBIT3 net | Input | High |  |
| 4B | Master | Video / Colour | 9K | 74LS260 | 2 | input | N | MBIT2; 9H output/local MBIT2 net | Input | High |  |
| 4B | Master | Video / Colour | 9K | 74LS260 | 3 | input | N | MBIT1; 9H output/local MBIT1 net | Input | High |  |
| 4B | Master | Video / Colour | 9K | 74LS260 | 5 | output | Y | motion-zero detect; 8E pin 1 and 8C pin 3 branch | Output | High |  |
| 4B | Master | Video / Colour | 9K | 74LS260 | 12 | input | N | MBIT0; 9H output/local MBIT0 net | Input | High |  |
| 4B | Master | Video / Colour | 9K | 74LS260 | 13 | input | N | ground; direct ground | Tied | High | Confirm tied to ground |
| 4B | Master | Video / Colour | 8C | 74LS04 | 3 | input | N | 9K pin 5 | Input | Checked | Confirmed |
| 4B | Master | Video / Colour | 8C | 74LS04 | 4 | output | Y | 8D pin 4 | Output | Checked | Confirmed |
| 4B | Master | Video / Colour | 8D | 74LS32 | 4 | OR input | N | 8C output branch; 8C pin 4 | Input | Checked | Confirmed |
| 4B | Master | Video / Colour | 8D | 74LS32 | 5 | OR input | N | 1L output branch; 1L pin 12 | Input | Checked | Confirmed |
| 4B | Master | Video / Colour | 8D | 74LS32 | 6 | OR output | N | 8E input branch; 8E pin 12 | Output | Checked | Confirmed |
| 4B | Master | Video / Colour | 1L | 74LS27 | 1 | NOR input | N | BMAP2; off-sheet BMAP2 | Input | Checked | Confirmed |
| 4B | Master | Video / Colour | 1L | 74LS27 | 2 | NOR input | N | BMAP1; off-sheet BMAP1 | Input | Checked | Confirmed |
| 4B | Master | Video / Colour | 1L | 74LS27 | 12 | NOR output | Y | 8D pin 5 | Output | Checked | Confirmed |
| 4B | Master | Video / Colour | 1L | 74LS27 | 13 | NOR input | N | BMAP0; off-sheet BMAP0 | Input | Checked | Confirmed |
| 4B | Master | Video / Colour | 8E | 74LS00 | 1 | input | N | 9K output branch; 9K pin 5 | Input | Checked |  |
| 4B | Master | Video / Colour | 8E | 74LS00 | 2 | input | N | /COLRAM; off-sheet COLRAM | Input | Checked |  |
| 4B | Master | Video / Colour | 8E | 74LS00 | 3 | output | Y | COLSEL1; off-sheet COLSEL1 | Output | Checked |  |
| 4B | Master | Video / Colour | 8E | 74LS00 | 11 | output | Y | COLSEL0; off-sheet COLSEL0 | Output | Checked | Confirmed |
| 4B | Master | Video / Colour | 8E | 74LS00 | 12 | input | N | 8D pin 6 | Input | Checked | Confirmed |
| 4B | Master | Video / Colour | 8E | 74LS00 | 13 | input | N | COLRAM; off-sheet COLRAM | Input | Checked | Confirmed |

## Sheet 4B visual inspection priorities

### Priority A — Motion Object Buffers

- None.

### Priority B — Video / Colour

- None.
