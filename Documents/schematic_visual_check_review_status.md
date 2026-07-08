# Schematic Visual Check Review Status

Branch: `rewrite/schematic-4a-4b`

Purpose: track the documentation-only visual-check/netlist review pass using
the separated sheet PDFs in `Documents/Master` and `Documents/Slave`.

## Excluded For This Pass

| Sheet | Reason |
| --- | --- |
| `1B` | Power input sheet; defer while digital/netlist work is prioritized. |
| `5B` | Defer until the related output/audio/support path is selected. |
| `6A` | Defer until the Slave PCB CPU/system audit is selected. |
| `9A` | Defer until its sheet function is needed by the current digital path. |

Parts lists are reference-only for IC type confirmation, not pin-netlist
source files.

## Column Conventions

### Active Low

The `Active Low` column is a reviewer/filter aid only. It is meaningful only
for input/control pins. The source of truth remains the `Pin Function`,
schematic net label, and `Reviewer Notes`.

For example, a standard `74LS273` pin 1 row should still say `/CLR` in
`Pin Function`; `Active Low = Y` simply makes that active-low input easy to
filter during review.

Allowed values:

- `Y`: input pin performs its named function when driven low.
- `N`: input pin is not active-low.
- `N.A.`: output pins, power pins, tied rails, or non-pin grouped rows.

Output polarity, inverted output nets, De Morgan output bubbles, and low-true
net naming must be documented in `Pin Function`, `Connected To`, or
`Reviewer Notes`, not in `Active Low`.

Examples:

- `/CLR` input: `Y`
- `/G` enable input: `Y`
- `Select` input: `N`
- `/Q` output: `N.A.`, with a note such as `low-true output net`
- NAND output bubble: `N.A.`, with a note such as `output bubble shown`
- De Morgan input bubble: use `Y` only if that input function is active-low;
  otherwise use `N` and note `input bubble shown`

## Current Visual-Check Files

| Sheet | CSV/MD exists | Current status |
| --- | --- | --- |
| `2A` | yes | IC inventory/type pass updated from `Documents/Master/Sheet2A.pdf`; CPU has 40 pin rows; `8F`/`9E` LS139 decoders are expanded to per-pin rows and `8F` `MORAM` is captured. The CPU `R/W` write-strobe path is now expanded through `4/5E`, `7D`, and `7C` to document `PABR/W`, `BWRITE`, and `PAWRITE` generation. Other small glue ICs remain grouped `Check` rows pending package-level pin crops. |
| `3B` | yes | Expanded from `Documents/Master/Sheet3B.pdf` to remove grouped `multiple` rows; latch, ROM, load-timing, shift-register, address, and cocktail sections now have per-pin checklist rows. Many rows remain `Check` because exact small labels still need reviewer confirmation. |
| `4A` | yes | Expanded from `Documents/Master/Sheet4A.pdf` to include previously missing visible motion address/readback/RAM inventory (`2H`, `5M`, `5L`, `6M`, `6L`) plus the existing motion ROM/shift/decode rows. Exact 2101 RAM pin order still needs dedicated focused crops. |
| `4B` | yes | Per-pin checklist exists; current CSV/Numbers files have user edits still uncommitted and should not be overwritten. |
| `5A` | yes | Created from `Documents/Master/Sheet5A.pdf`; covers the three LS244 input buffers (`9R`, `9P`, `9N`), color RAM `9L/M`, color RAM write gate `8D`, blanking gate `4J`, RGB latch packages (`5N`, `5M`, `5L`), RGB output transistors, `J19`, and video +5V filter. Color latch bit routing remains `Check` where the exact output-to-latch bit needs focused review. |
| `6B` | yes | Created from `Documents/Slave/Sheet6B.pdf`; covers the slave 6502B CPU, address/data buffers, CPU R/W buffering, IRQ/DRAM/bitmap-control latches, Master/Slave Interconnect buffers, ROM/RAM/custom decode logic, LDX/LDY decode, graph-control glue, and the `5MHZ -> E5M` source-side interconnect row. Decoder output polarity is kept in notes/net labels; `Active Low = Y` remains reserved for active-low input pins only. |
| `7A` | yes | Sync-chain rows expanded from grouped placeholders into visible per-pin checklist rows using `Documents/Slave/Sheet7A.pdf` and cached crops under `/private/tmp/cloak_sheet_review`; current pass covers clock divider, horizontal/vertical counters, vertical PROM/register, HBLANK latches, sync output gates, horizontal starred aliases, custom timing package, Slave Program ROM, Working RAM, and Communication RAM Interconnect. Program ROM is represented as the seven visible 2764 columns `1E/1F`, `1F/1H`, `1J`, `1K`, `1L`, `1M`, and `1N` selected by `PBROM0..PBROM6`. |

## Handoff Notes

- Current documentation-first commit: `a5b2110 Expand Sheet 7A sync chain visual check rows`.
- Recent supporting commit: `5493fc5 Expand Sheet 2A LS139 visual check rows`.
- Do not overwrite user-edited Sheet 4B CSV/Numbers files. Check `git status`
  before staging.
- For documentation-only changes, do not run Icarus and do not ask for MiSTer
  testing.
- For spreadsheet sync, keep `.csv` as the text source and regenerate `.md`
  from it, preserving any reviewer notes.
- Useful current crop cache:
  - `/private/tmp/cloak_sheet_review/Sheet7A_sync_chain_full_readable.png`
  - `/private/tmp/cloak_sheet_review/Sheet7A_sync_prom_4n_readable.png`
  - `/private/tmp/cloak_sheet_review/Sheet7A_full_readable.png`
  - `/private/tmp/cloak_sheet_review/Sheet2A_8f_9e_full_decode.png`
- Good next bounded passes:
  - Sheet 2A remaining grouped glue around memory decode, `/MORAM`, and the high-address decode write enables.
  - Sheet 2B, because `/MORAM` and related master memory decode continue there.

## Included Sheets Missing Visual-Check Files

| Sheet | Source PDF |
| --- | --- |
| `2B` | `Documents/Master/Sheet2B.pdf` |
| `3A` | `Documents/Master/Sheet3A.pdf` |
| `7B` | `Documents/Slave/Sheet7B.pdf` |
| `8A` | `Documents/Slave/Sheet8A.pdf` |
| `8B` | `Documents/Slave/Sheet8B.pdf` |

## Review Rules

- Do not infer pins from RTL.
- Use `Check` for rows seeded from existing audits or readable IC inventory but
  not yet visually pin-confirmed.
- Preserve user edits in `.csv` and `.numbers` files.
- For each sheet, commit documentation-only corrections separately.
