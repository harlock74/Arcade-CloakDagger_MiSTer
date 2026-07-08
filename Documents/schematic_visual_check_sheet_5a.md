# Schematic Visual Check - Sheet 5A

Reviewer-facing checklist generated from the Sheet 5A visual-check CSV. Keep this file and the CSV in sync; the CSV is the spreadsheet source for `.numbers` updates.

## Summary

- Rows: 128
- High: 105
- Check: 23

## Review Focus

Rows marked `Check` still need visual confirmation against the schematic crop/PDF. Do not promote them to `Checked` until the pin number, label, and connection are readable.

Sheet 5A covers the master input buffers, color RAM/write gate, RGB latch/blanking path, analog RGB output drivers, and video output connector. The cocktail Player 2 LS244 is included because it is visible on the schematic, but the sheet marks that dashed block as not loaded for the cocktail version.

## Visual Check Table

| Sheet | Board | Section | IC | IC Type | Pin Number | Pin Function | Active Low | Connected To | Direction | Confidence | Reviewer Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 1 | 1G enable | Y | IN3; also 9R pin 19 | Input | High | Active-low enable input; visible tied to IN3 |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 19 | 2G enable | Y | IN3; also 9R pin 1 | Input | High | Active-low enable input; visible tied to IN3 |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 17 | A input | N | FIRE1 via J20 F and R42 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 3 | Y output | N.A. | PABD7 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 15 | A input | N | FIRE2 via J20 G and R43 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 5 | Y output | N.A. | PABD6 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 4 | A input | N | COIN AUX via J20 J and R44 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 16 | Y output | N.A. | PABD5 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 8 | A input | N | COCKTAIL via J20 7 and R45 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 12 | Y output | N.A. | PABD4 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 2 | A input | N | COIN R via J20 H and R46 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 18 | Y output | N.A. | PABD3 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 6 | A input | N | COIN L via J20 8 and R47 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 14 | Y output | N.A. | PABD2 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 13 | A input | N | SELF TEST via J20 5 and R48 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 7 | Y output | N.A. | PABD1 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 11 | A input | N | BVBLANK | Input | High | Visible BVBLANK label into 9R |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 9 | Y output | N.A. | PABD0 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 10 | GND | N.A. | Ground | Power | Check | Standard LS244 ground pin; not independently labelled in crop |
| 5A | Master | Input Port 3 | 9R | 74LS244 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS244 power pin; pull-up rail visible nearby |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 1 | 1G enable | Y | IN2; also 9P pin 19 | Input | High | Active-low enable input; visible tied to IN2 |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 19 | 2G enable | Y | IN2; also 9P pin 1 | Input | High | Active-low enable input; visible tied to IN2 |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 17 | A input | N | PL2LL via J20 9 and R57 | Input | High | Dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 3 | Y output | N.A. | PABD7 | Output | High | Output pin; dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 2 | A input | N | PL2LR via J20 N and R58 | Input | High | Dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 18 | Y output | N.A. | PABD6 | Output | High | Output pin; dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 4 | A input | N | PL2LU via J20 12 and R59 | Input | High | Dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 16 | Y output | N.A. | PABD5 | Output | High | Output pin; dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 6 | A input | N | PL2LD via J20 M and R60 | Input | High | Dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 14 | Y output | N.A. | PABD4 | Output | High | Output pin; dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 8 | A input | N | PL2RL via J20 11 and R61 | Input | High | Dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 12 | Y output | N.A. | PABD3 | Output | High | Output pin; dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 11 | A input | N | PL2RR via J20 L and R62 | Input | High | Dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 9 | Y output | N.A. | PABD2 | Output | High | Output pin; dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 13 | A input | N | PL2RU via J20 10 and R63 | Input | High | Dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 7 | Y output | N.A. | PABD1 | Output | High | Output pin; dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 15 | A input | N | PL2RD via J20 K and R64 | Input | High | Dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 5 | Y output | N.A. | PABD0 | Output | High | Output pin; dashed box marked not loaded cocktail version |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 10 | GND | N.A. | Ground | Power | Check | Standard LS244 ground pin; dashed cocktail-version box |
| 5A | Master | Input Port 2 Cocktail | 9P | 74LS244 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS244 power pin; dashed cocktail-version box |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 1 | 1G enable | Y | IN1; also 9N pin 19 | Input | High | Active-low enable input; visible tied to IN1 |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 19 | 2G enable | Y | IN1; also 9N pin 1 | Input | High | Active-low enable input; visible tied to IN1 |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 17 | A input | N | PL1LL via J20 13 and R73 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 3 | Y output | N.A. | PABD7 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 2 | A input | N | PL1LR via J20 T and R74 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 18 | Y output | N.A. | PABD6 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 4 | A input | N | PL1LU via J20 16 and R75 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 16 | Y output | N.A. | PABD5 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 6 | A input | N | PL1LD via J20 S and R76 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 14 | Y output | N.A. | PABD4 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 8 | A input | N | PL1RL via J20 15 and R77 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 12 | Y output | N.A. | PABD3 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 11 | A input | N | PL1RR via J20 R and R78 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 9 | Y output | N.A. | PABD2 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 13 | A input | N | PL1RU via J20 14 and R79 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 7 | Y output | N.A. | PABD1 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 15 | A input | N | PL1RD via J20 P and R80 | Input | High | Visible input label and resistor path |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 5 | Y output | N.A. | PABD0 | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 10 | GND | N.A. | Ground | Power | Check | Standard LS244 ground pin; not independently labelled in crop |
| 5A | Master | Input Port 1 | 9N | 74LS244 | 20 | VCC | N.A. | +5V | Power | Check | Standard LS244 power pin; pull-up rail visible nearby |
| 5A | Master | Color RAM | 9L/M | 82519 | 1 | A3 address input | N | COLA3 | Input | High | Visible address label |
| 5A | Master | Color RAM | 9L/M | 82519 | 2 | A4 address input | N | COLA4 | Input | High | Visible address label |
| 5A | Master | Color RAM | 9L/M | 82519 | 3 | A5 address input | N | COLA5 | Input | High | Visible address label |
| 5A | Master | Color RAM | 9L/M | 82519 | 4 | I0 data input | N | PABD0 | Input | Check | Input bus line visible from PABD bus; bit mapping should be reviewed |
| 5A | Master | Color RAM | 9L/M | 82519 | 5 | I1 data input | N | PABD1 | Input | Check | Input bus line visible from PABD bus; bit mapping should be reviewed |
| 5A | Master | Color RAM | 9L/M | 82519 | 6 | I2 data input | N | PABD2 | Input | Check | Input bus line visible from PABD bus; bit mapping should be reviewed |
| 5A | Master | Color RAM | 9L/M | 82519 | 7 | I3 data input | N | PABD3 | Input | Check | Input bus line visible from PABD bus; bit mapping should be reviewed |
| 5A | Master | Color RAM | 9L/M | 82519 | 8 | I4 data input | N | PABD4 | Input | Check | Input bus line visible from PABD bus; bit mapping should be reviewed |
| 5A | Master | Color RAM | 9L/M | 82519 | 9 | I5 data input | N | PABD5 | Input | Check | Input bus line visible from PABD bus; bit mapping should be reviewed |
| 5A | Master | Color RAM | 9L/M | 82519 | 10 | I6 data input | N | PABD6 | Input | Check | Input bus line visible from PABD bus; bit mapping should be reviewed |
| 5A | Master | Color RAM | 9L/M | 82519 | 11 | I7 data input | N | PABD7 | Input | Check | Input bus line visible from PABD bus; bit mapping should be reviewed |
| 5A | Master | Color RAM | 9L/M | 82519 | 12 | I8 data input | N | PABA6 | Input | High | Visible PABA6 label into I8 |
| 5A | Master | Color RAM | 9L/M | 82519 | 13 | WE write enable | Y | 8D pin 3 color RAM write enable | Input | High | WE pin shown with active-low bubble; driven by LS32 output |
| 5A | Master | Color RAM | 9L/M | 82519 | 15 | CE chip enable | Y | Ground | Input | High | CE pin visibly tied low |
| 5A | Master | Color RAM | 9L/M | 82519 | 16 | O8 output | N.A. | Color RAM O8 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 17 | O7 output | N.A. | Color RAM O7 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 18 | O6 output | N.A. | Color RAM O6 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 19 | O5 output | N.A. | Color RAM O5 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 20 | O4 output | N.A. | Color RAM O4 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 21 | O3 output | N.A. | Color RAM O3 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 22 | O2 output | N.A. | Color RAM O2 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 23 | O1 output | N.A. | Color RAM O1 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 24 | O0 output | N.A. | Color RAM O0 to RGB latch network | Output | High | Visible output pin; exact latch destination should be reviewed with focused crop |
| 5A | Master | Color RAM | 9L/M | 82519 | 25 | A0 address input | N | COLA0 | Input | High | Visible address label |
| 5A | Master | Color RAM | 9L/M | 82519 | 26 | A1 address input | N | COLA1 | Input | High | Visible address label |
| 5A | Master | Color RAM | 9L/M | 82519 | 27 | A2 address input | N | COLA2 | Input | High | Visible address label |
| 5A | Master | Color RAM Write Gate | 8D | 74LS32 | 1 | OR input | N | /COLRAM | Input | High | Visible active-low net label into LS32 input; pin itself is not active-low |
| 5A | Master | Color RAM Write Gate | 8D | 74LS32 | 2 | OR input | N | /PAWRITE | Input | High | Visible active-low net label into LS32 input; pin itself is not active-low |
| 5A | Master | Color RAM Write Gate | 8D | 74LS32 | 3 | OR output | N.A. | 9L/M pin 13 WE | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | Blanking Gate | 4J | 74LS08 | 4 | AND input | N | HBLANK; source: J17 pin 37 | Input | High | Visible HBLANK label and J17 pin |
| 5A | Master | Blanking Gate | 4J | 74LS08 | 5 | AND input | N | BVBLANK | Input | High | Visible BVBLANK label |
| 5A | Master | Blanking Gate | 4J | 74LS08 | 6 | AND output | N.A. | BLANK; shared with LS174 clear pins | Output | High | Output pin; polarity belongs in net label/notes not Active Low |
| 5A | Master | RGB Latch Red | 5N | 74LS174 | 1 | /CLR clear | Y | BLANK | Input | High | Active-low clear pin; visible shared BLANK rail |
| 5A | Master | RGB Latch Red | 5N | 74LS174 | 9 | CLK | N | B5M | Input | High | Visible B5M clock label |
| 5A | Master | RGB Latch Red | 5N | 74LS174 | 14 | D input | N | Color RAM output to red latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Red | 5N | 74LS174 | 15 | Q output | N.A. | CR2 diode/resistor network to Q1 red driver | Output | High | Visible CR2 label |
| 5A | Master | RGB Latch Red | 5N | 74LS174 | 6 | D input | N | Color RAM output to red latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Red | 5N | 74LS174 | 7 | Q output | N.A. | CR3 diode/resistor network to Q1 red driver | Output | High | Visible CR3 label |
| 5A | Master | RGB Latch Red | 5N | 74LS174 | 11 | D input | N | Color RAM output to red latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Red | 5N | 74LS174 | 10 | Q output | N.A. | CR4 diode/resistor network to Q1 red driver | Output | High | Visible CR4 label |
| 5A | Master | RGB Latch Green | 5M | 74LS174 | 1 | /CLR clear | Y | BLANK | Input | High | Active-low clear pin; visible shared BLANK rail |
| 5A | Master | RGB Latch Green | 5M | 74LS174 | 9 | CLK | N | B5M | Input | High | Visible B5M clock label |
| 5A | Master | RGB Latch Green | 5M | 74LS174 | 3 | D input | N | Color RAM output to green latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Green | 5M | 74LS174 | 2 | Q output | N.A. | CR5 diode/resistor network to Q2 green driver | Output | High | Visible CR5 label |
| 5A | Master | RGB Latch Green | 5M | 74LS174 | 4 | D input | N | Color RAM output to green latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Green | 5M | 74LS174 | 5 | Q output | N.A. | CR6 diode/resistor network to Q2 green driver | Output | High | Visible CR6 label |
| 5A | Master | RGB Latch Green | 5M | 74LS174 | 13 | D input | N | Color RAM output to green latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Green | 5M | 74LS174 | 12 | Q output | N.A. | CR7 diode/resistor network to Q2 green driver | Output | High | Visible CR7 label |
| 5A | Master | RGB Latch Blue | 5L | 74LS174 | 1 | /CLR clear | Y | BLANK | Input | High | Active-low clear pin; visible shared BLANK rail |
| 5A | Master | RGB Latch Blue | 5L | 74LS174 | 9 | CLK | N | B5M | Input | High | Visible B5M clock label |
| 5A | Master | RGB Latch Blue | 5L | 74LS174 | 3 | D input | N | Color RAM output to blue latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Blue | 5L | 74LS174 | 2 | Q output | N.A. | CR8 diode/resistor network to Q3 blue driver | Output | High | Visible CR8 label |
| 5A | Master | RGB Latch Blue | 5L | 74LS174 | 4 | D input | N | Color RAM output to blue latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Blue | 5L | 74LS174 | 5 | Q output | N.A. | CR9 diode/resistor network to Q3 blue driver | Output | High | Visible CR9 label |
| 5A | Master | RGB Latch Blue | 5L | 74LS174 | 13 | D input | N | Color RAM output to blue latch bit | Input | Check | Visible route from 9L/M output area; exact color bit needs review |
| 5A | Master | RGB Latch Blue | 5L | 74LS174 | 12 | Q output | N.A. | CR10 diode/resistor network to Q3 blue driver | Output | High | Visible CR10 label |
| 5A | Master | RGB Analog Output | Q1 | 2N3904 | base | Base input | N | CR2/CR3/CR4 resistor mixer through R95/R96/R97 | Input | High | Red channel transistor base network visible |
| 5A | Master | RGB Analog Output | Q1 | 2N3904 | emitter | Emitter output | N.A. | R99/L2 to J19 pin 2 RED | Output | High | Discrete output node; not an IC pin number |
| 5A | Master | RGB Analog Output | Q2 | 2N3904 | base | Base input | N | CR5/CR6/CR7 resistor mixer through R103/R104/R105 | Input | High | Green channel transistor base network visible |
| 5A | Master | RGB Analog Output | Q2 | 2N3904 | emitter | Emitter output | N.A. | R107/L3 to J19 pin 3 GREEN | Output | High | Discrete output node; not an IC pin number |
| 5A | Master | RGB Analog Output | Q3 | 2N3904 | base | Base input | N | CR8/CR9/CR10 resistor mixer through R111/R112/R113 | Input | High | Blue channel transistor base network visible |
| 5A | Master | RGB Analog Output | Q3 | 2N3904 | emitter | Emitter output | N.A. | R115/L4 to J19 pin 1 BLUE | Output | High | Discrete output node; not an IC pin number |
| 5A | Master | RGB Output Connector | J19 | Connector | 1 | BLUE output | N.A. | BLUE from Q3 via L4 | Output | High | Visible connector pin |
| 5A | Master | RGB Output Connector | J19 | Connector | 2 | RED output | N.A. | RED from Q1 via L2 | Output | High | Visible connector pin |
| 5A | Master | RGB Output Connector | J19 | Connector | 3 | GREEN output | N.A. | GREEN from Q2 via L3 | Output | High | Visible connector pin |
| 5A | Master | RGB Output Connector | J19 | Connector | A | VIDEO GND | N.A. | Video ground | Power | High | Visible connector pin |
| 5A | Master | Video Power Filter | L1 | Inductor | 1 | +5V input | N.A. | +5V | Power | High | Visible +5V to L1 |
| 5A | Master | Video Power Filter | L1 | Inductor | 2 | +5VF output | N.A. | +5VF; filtered video +5V rail | Power | High | Visible L1 output and C2 decoupling |
