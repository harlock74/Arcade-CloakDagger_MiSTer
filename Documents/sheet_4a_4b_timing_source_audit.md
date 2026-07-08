# Sheet 4A/4B Timing Source Audit

Date: 2026-07-04

Scope: Sheet 4A/4B motion-object timing only. This audit documents timing-source confidence for the non-driving closed-loop Sheet 4B probe and the surrounding 1H/8F/7F decode path. It does not propose a visible candidate.

## Summary

The pin-level destinations for `7F`, `1H`, `8F`, `8K/8M`, `8J/8L`, and `9T` are mostly known, but the source timing that drives them is not fully schematic-derived in RTL.

2026-07-07 handoff note: the visual-check documentation pass now has a more
reliable Sheet 7A sync-chain checklist in
`Documents/schematic_visual_check_sheet_7a.csv` / `.md`. Use those files before
future work on the upstream `10MHZ`/`5MHZ` generator path. The cross-sheet
`B5M` path in this file remains: `5MHZ -> Sheet 6B 3D -> E5M -> Sheet 2A 1R/8C
-> B5M*/B5M`.

Current RTL aliases:

```verilog
wire motion_bytload_decode_enable_provisional = render_pending;
wire bytload_from_render_pending = motion_bytload_decode_enable_provisional;
wire iv_provisional_from_display_line_bank = display_line_bank;
wire bsm = ce_5m;
```

These aliases are useful for naming and non-driving probes, but they are not yet proven to be the true schematic timing sources. The recent player-object overlap result is therefore expected: local pin mappings can be correct while the closed-loop probe still misses the real write/read phase.

## Timing Source Table

| Signal | Schematic source IC/pin | RTL current source | Source confidence | Downstream logic depending on it | Risk if phase is wrong |
| --- | --- | --- | --- | --- | --- |
| `IV` | Named net into `7F` pin 2 `D`, `1H` pin 14 `A`, and `8F` pin 3 `B` | `iv_provisional_from_display_line_bank = display_line_bank` | provisional | `7F` latch input; `1H` left decode `/MOHLI`/`/MOHLO`; `8F` right decode `/MOHRI`/`/MOHRO` | Wrong object/byte phase makes 1H/8F select the opposite half of the object timing, causing MBJ select and IVDBH enable not to overlap. |
| `IVDBH` | `7F` pin 6 `/Q` | `ivdbh_from_7f = u_7f_ivdb_latch.q_n` | schematic pin exact; source timing provisional via `IV` and `B8H` | `8F` pin 2 `A`; `8K` pin 15 active-low enable; `8M` pin 15 active-low enable | Correct polarity can still be unusable if `IV` or `B8H` are sampled at the wrong phase; 8K may be disabled exactly when `/MOHLI` selects MBJ. |
| `IVDSH` | `7F` pin 5 `Q` | `ivdsh_from_7f = u_7f_ivdb_latch.q` | schematic pin exact; source timing provisional via `IV` and `B8H` | Diagnostic/probe comparisons; complement of `IVDBH` | Tempting to use as an enable because it creates overlap in the player diagnostic, but that contradicts the pin audit and produces wrong/extra pixels. |
| `BYTLOAD` | Named rail into `1H` pin 15 active-low `G` and `8F` pin 1 active-low `G` | `bytload_from_render_pending = render_pending` | provisional; source/pulse/level untraced | Enables/disables 1H and 8F decoders; indirectly gates `/MOHLI`, `/MOHLO`, `/MOHRI`, `/MOHRO`; affects LS194/load timing context | Wrong lifetime can make the decoders active in the wrong object-scan phase or inactive during the real write phase. |
| `B5M` / legacy audit name `BSM` | Named 5 MHz timing rail to 7J/7K/7L/7M clocks, `8J/8L` WE, and `9T` clock; previously misread as `BSM` in this audit | `bsm = ce_5m` | provisional, legacy-named `B5M` alias; local destinations known | 93422 write enable (`WE_n = !bsm`); `9T` latch clock; motion buffer counters | If the real `B5M` rail has a different phase/polarity than the broad `ce_5m` alias, the probe over-writes/latches at the wrong time and makes old/new 93422 timing comparisons meaningless. |
| `B8H` | Horizontal timing rail into `7F` pin 3 clock | `b8h = hcnt[3]`, sampled as `b8h_7f_rise = ce_5m && !b8h_7f_d && b8h` | schematic destination exact; source/edge provisional | `7F` captures `IV`, generating `IVDSH`/`IVDBH` | Wrong edge or horizontal source shifts both `IVDBH` and `IVDSH`, preserving polarity but misaligning 8K/8M enables against 1H/8F select. |
| `/MOHLI` | `1H` pin 12 `Y0` | Active alias still `mohli_decoded_n = moh_left_decode_n[1]`; corrected non-driving probe uses `moh_left_decode_1h_pin_candidate_n[0]` | pin exact; active RTL alias still provisional/reversed | `8K` pin 1 select; `7L/7M` load side | Correct pin fact can still look wrong if `IV`/`BYTLOAD` are provisional; 8K selects MBJ when enable is inactive in the current diagnostic. |
| `/MOHLO` | `1H` pin 11 `Y1` | Active alias still `mohlo_decoded_n = moh_left_decode_n[0]`; corrected non-driving probe uses `moh_left_decode_1h_pin_candidate_n[1]` | pin exact; active RTL alias still provisional/reversed | `7J/7K` load side | Complementary phase can make a diagnostic pass partially but is not evidence to swap pins. |
| `/MOHRI` | `8F` pin 6 `Y2` | `mohri_decoded_n = moh_right_decode_n[2]`; pin-correct probe uses `moh_right_decode_8f_pin_candidate_n[2]` | pin exact; timing uncertain | `8M` pin 1 select; `7L/7M` clear side | Wrong `IV`/`IVDBH`/`BYTLOAD` source changes right-side MBJ-vs-feedback selection and can hide true 8M data. |
| `/MOHRO` | `8F` pin 5 `Y1` | `mohro_decoded_n = moh_right_decode_n[1]`; pin-correct probe uses `moh_right_decode_8f_pin_candidate_n[1]` | pin exact; timing uncertain | `7J/7K` clear side | Wrong phase changes counter clear/load relationships and can corrupt object horizontal lifetime. |
| `8K enable` | `8K` LS157 pin 15 active-low `G` from `IVDBH` | `motion_buffer_8k_enable_n_from_ivdbh = ivdbh_from_7f` | pin exact; phase uncertain | Enables `8K` output into `8J` data input | Current player diagnostic proves `/MOHLI` MBJ select overlaps only with `IVDBH=1`, so the active-low enable is inactive during all 8K MBJ-selected samples. |
| `8M enable` | `8M` LS157 pin 15 active-low `G` from `IVDBH` | `motion_buffer_8m_enable_n_from_ivdbh = ivdbh_from_7f` | pin exact; phase uncertain | Enables `8M` output into `8L` data input | Same enable source as 8K; useful right-side data in some probes does not prove the source timing is globally correct. |
| `93422 WE` | `8J/8L` pin 20 active-low `WE` from the `B5M`/legacy-`BSM` rail | `motion_buffer_we_n_from_8j_8l = !bsm`; bridge banks additionally use compatibility write-bank gating | schematic destination exact; active implementation compatibility-derived | Writes `8K/8M` mux outputs into motion buffer RAMs | If `B5M` is too broad/narrow or banked bridge write gating is not schematic-equivalent, data is written/cleared outside the true object lifetime. |
| `9T clock` | `9T` pin 11 `CLK` from the `B5M`/legacy-`BSM` rail | `motion_buffer_9t_clk_en_from_bsm = bsm` | schematic destination exact; source phase provisional | Latches `8J/8L` outputs into `LB00..LB13`; feeds 9H and 8K/8M feedback in closed-loop probe | If `B5M` phase is wrong, 9T captures before/after the intended 93422 value or captures too often. |

## Specific Findings

### IV

The schematic evidence currently proves only the local destinations: `IV` enters `7F` pin 2, `1H` pin 14, and `8F` pin 3. The upstream schematic generator for `IV` has not been identified in the audit. Therefore `iv_provisional_from_display_line_bank = display_line_bank` is a temporary alias, not a proven schematic source.

Current evidence does not prove whether real `IV` is an object/byte phase, a line phase, or a display-bank phase. The player diagnostic failure strongly suggests it is not safely modelled by the current display-bank alias.

### BYTLOAD

The schematic evidence proves `BYTLOAD` feeds active-low decode enables: `1H` pin 15 and `8F` pin 1. Its upstream source and pulse/level behaviour remain untraced. Therefore `bytload_from_render_pending = render_pending` is a temporary alias.

Because `BYTLOAD` controls when 1H/8F decode outputs are valid, a wrong alias can make `/MOHLI`, `/MOHLO`, `/MOHRI`, and `/MOHRO` appear phase-inverted even when the pin mapping is correct.

### B5M / Legacy BSM Name

The schematic evidence proves the timing rail previously tracked here as `BSM` is consumed by the Sheet 4B buffer chain: motion-buffer counters clock from it, 93422 write enable is derived from it, and 9T clocks from it. Manual Sheet 2A review now corrects the cross-sheet name to `B5M`/`B5M*`, fed from `E5M`, not `BSM`/`BSM*` fed from a misread `ESM`.

Therefore `bsm = ce_5m` remains a provisional legacy-named alias for the `B5M` timing rail. It is suitable as a broad clock-enable placeholder, and the connection trace now proves it is the right timing family. The remaining concern is not reproducing the physical LS244/LS04 distribution chain in Verilog; it is proving the generated enable edge/phase used for 93422 write and 9T latch timing.

#### B5M Step 1 Trace

Sheet 4A and Sheet 4B show the rail previously read as `BSM` as an incoming labelled timing rail, not as locally generated logic. Current correction: treat those audit mentions as `B5M`/legacy `BSM` until the local Sheet 4A/4B labels are re-cropped.

- Sheet 4A: the legacy `BSM`/corrected `B5M` rail clocks the four LS194 motion shift registers (`6R/6P/7R/7P` pin 11).
- Sheet 4B: the legacy `BSM`/corrected `B5M` rail clocks the four LS163 motion-buffer counters (`7J/7K/7L/7M` pin 2), drives active-low `WE` on both 93422 RAMs (`8J/8L` pin 20, represented as `WE_n = !bsm`), and clocks `9T` (`LS273` pin 11).
- The wider master/slave interconnect audit now identifies two distribution stages: Sheet 6B `3D` buffers `5MHZ` into `E5M` at J17 pin 31, then Sheet 2A `1R`/`8C` buffers `E5M` into board-side `B5M*`/`B5M`. The visible connector path is `3D` pin 9 -> `J17` pin 31 -> Sheet 2A `1R` pins 2 and 17.

No local Sheet 4A/4B crop generates `E5M`/`B5M`; the source is cross-sheet. The newly traced source-side path is `5MHZ -> 3D LS244 pin 11 -> 3D pin 9 E5M -> J17 pin 31 -> Sheet 2A 1R pins 2/17 -> 1R pins 18/3 and 8C -> B5M*/B5M`. No non-driving `bsm_schematic_candidate` was added in this documentation step.

Implementation note: for future RTL, the physical LS244/LS04 distribution chain does not necessarily need to be behaviourally reproduced gate-for-gate because the FPGA will generate the timing rails internally. The connection audit is still important because it proves which schematic rail reaches the Sheet 4A/4B clock/write/latch pins and prevents misreading `B5M` as an unrelated `BSM` net.

| B5M / legacy BSM item | Evidence |
| --- | --- |
| Schematic source IC/pin | Sheet 6B lower `3D` LS244 buffers `5MHZ` from pin 11 to `E5M` on pin 9, exported through J17 pin 31. Sheet 2A then routes that `E5M` net to lower `1R` pins 2 and 17; `1R` outputs pin 18 `B5M*` and pin 3 `B5M`, with nearby `8C` inverter distribution also shown. |
| Signal type | Timing rail used as a clock at LS194, LS163, and 9T destinations; also used as the active-high source for active-low 93422 write enable. |
| Active level at 93422 | Legacy `bsm`/corrected `B5M=1` makes `WE_n=0`, so 93422 write is active in the RTL model. |
| Active level at 9T | Legacy `bsm`/corrected `B5M` clocks `9T`; edge/phase source remains unknown. |
| Relationship to `B8H` | `E5M` is sourced from `5MHZ` through Sheet 6B `3D`, while `B8H` is a separate horizontal timing rail distributed through the `1P`/`2F/H` path. Current RTL has `bsm=ce_5m` and `b8h=hcnt[3]`, so it still does not encode a cross-sheet buffer path. |
| Relationship to `BYTLOAD` | Unknown. Current player diagnostic has legacy `bsm=384/384` while `BYTLOAD=0/384`; prior render-tag evidence has `t4 bsm=1024` with only `BYTLOAD=32`, proving the current aliases are not tightly phase-related. |
| Current RTL source | `wire bsm = ce_5m;` |
| Current source classification | Approximate/provisional by name and phase, but in the correct generated 5 MHz timing family. |
| Safe candidate available? | Documentation source path is now traced through Sheet 6B and Sheet 2A. A non-driving RTL candidate would still need a deliberate model of the `5MHZ/E5M/B5M` edge/enable relationship rather than another local 8K/8M phase guess. |

Required report for this bounded pass:

```text
current_bsm_phase: ce_5m; active on every modeled 5 MHz enable sample.
schematic_bsm_candidate_phase: not implemented; source path now traced as 5MHZ -> Sheet 6B 3D pin 9 -> J17 pin 31 -> Sheet 2A 1R pins 2/17 -> B5M*/B5M.
relationship_to_B8H: separate timing rail family; no B8H-derived phase restriction is documented for B5M.
relationship_to_BYTLOAD_if_known: unknown; current aliases show poor overlap.
93422_WE_phase: WE_n = !legacy_bsm, so B5M/legacy-bsm high writes in the schematic model.
9T_latch_phase: 9T clocks from B5M/legacy-bsm, but edge/phase source is not yet known.
```

Conclusion for B5M/legacy BSM: `bsm = ce_5m` is conceptually close as a broad 5 MHz enable. It is still an approximate legacy name rather than a pin-to-pin model of the traced cross-sheet distribution path `5MHZ -> Sheet 6B 3D -> E5M -> Sheet 2A 1R/8C -> B5M*/B5M`, but that is less concerning for implementation than a wrong destination or wrong timing family: Verilog can generate the clock enable directly once the intended phase/polarity is known.

#### B5M Source Trace: `1P` / `1R` / `8C`

This bounded pass followed the upstream clue from the master CPU audit. Manual
cross-sheet review corrected the local-source interpretation twice: first from
upper `1P` to lower `1R`, and then from the misread `ESM/BSM` nomenclature to
`E5M/B5M`.
Sheet 2A's Master/Slave Interconnect section has two LS244 buffer groups. The
upper `1P` LS244 distributes the `E1H`, `E2H`, `E4H`, and `E8H` timing rails
into the corresponding `B1H`, `B2H`, `B4H`, and `B8H` rails. The lower `1R`
LS244 distributes `MAP0`, `MAP1`, `MAP2`, `E32H`, `E5M`, and related rails into
board-side `BMAP0`, `BMAP1`, `BMAP2`, `B32H`, `B5M*`, `B5M`, and related
outputs. The bottom-left Sheet 2A crop confirms `E5M` at connector pin 31.
Therefore the corrected distribution path is `E5M -> 1R/8C -> B5M*/B5M`.
`1R` and `8C` are still only buffer/complement distribution points, not proof
of the ultimate `E5M` timing source.

#### E5M Source Trace: Sheet 6B `3D`

The user-provided Sheet 6B Master/Slave Interconnect crop identifies the source
side of `E5M`: lower LS244 `3D` buffers the `5MHZ` rail to connector J17 pin 31.
This means the cross-sheet timing path is now:

```text
5MHZ -> Sheet 6B 3D LS244 pin 11 -> 3D pin 9 E5M -> J17 pin 31
     -> Sheet 2A 1R pins 2/17 -> 1R pins 18/3 and 8C -> B5M*/B5M
```

`3D` is a distribution buffer, not necessarily the oscillator/divider source of
`5MHZ`. The remaining source provenance, if needed, is therefore the upstream
`5MHZ` generator, not the `E5M` connector source.

| IC | Type | Input pins/nets | Output pins/nets | B5M role | Polarity | Relationship to `B8H` / 5 MHz / horizontal timing | RTL equivalent |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `1P` upper LS244 | `74LS244`; Sheet 2A Master/Slave Interconnect upper buffer | `E1H`, `E2H`, `E4H`, `E8H`, plus related control rails per screenshot | `B1H`, `B2H`, `B4H`, `B8H`, plus related board-side rails | Distributes BxH timing rails; not the `E5M -> B5M` path | LS244 non-inverting buffer; enable pins tied low for active distribution in the screenshot | Provides the `B8H` rail family but does not itself generate `B5M` | No structural equivalent; current RTL derives `b1h..b8h` from counters |
| `1R` lower LS244 | `74LS244`; Sheet 2A Master/Slave Interconnect lower buffer | `MAP0`, `MAP1`, `MAP2`, `E32H`, `E5M` at connector pin 31, with `E5M` routed to pins 2 and 17 | `BMAP0`, `BMAP1`, `BMAP2`, `B32H`, pin 18 `B5M*`, pin 3 `B5M`, and related rails | Buffers/distributes upstream `E5M` into the board-side 5 MHz rail family; not the ultimate timing generator | `1R` is non-inverting; its outputs feed the nearby `8C` inverter/export pair shown in the crop | `E5M` is the incoming 5 MHz timing family; relationship to `B8H` remains separate | No structural equivalent; current RTL still uses legacy `bsm = ce_5m` |
| `1R` enables | `74LS244` active-low enables | Standard LS244 `/1G` pin 1 and `/2G` pin 19 are tied low in the screenshot | Enables both `1R` output banks | Keeps the distribution buffer active | Active-low enables tied active | No phase relation; just buffer enable | No structural equivalent |
| `8C` | `74LS04` inverter pair shown near top-right of Sheet 2A crop | Input pins 5 and 9 are driven from the `B5M*` node | Pin 6 output is labelled `B5M*`; pin 8 output is labelled `B5M` | Provides the shown complementary/exported 5 MHz rails from the `B5M*` node; does not generate upstream `E5M` | Inverting stages; the crop shows the local `B5M*` node feeding both inverters, with outputs labelled `B5M*` and `B5M` | Confirms local complement/buffer distribution, but not the source-side relation to `B8H` or base 5 MHz | No structural equivalent |
| Sheet 6B `3D` lower LS244 | `74LS244`; Master/Slave Interconnect lower buffer | pin 11 `5MHZ` | pin 9 `E5M` to J17 pin 31 | Source-side buffer for `E5M` | LS244 non-inverting buffer; enables shown tied active | Shows `E5M` is buffered from `5MHZ`; relationship to `B8H` is separate unless later timing sheets prove otherwise | No structural equivalent; current RTL still uses legacy `bsm = ce_5m` |

Specific answers for this pass:

1. Which IC/pin generates `B5M`: locally, Sheet 2A lower Master/Slave
   Interconnect LS244 `1R` buffers/distributes upstream `E5M` into board-side
   `B5M*` and `B5M`. `1R` does not generate the timing in the oscillator/counter
   sense.
2. LS244 pins: the screenshot shows `E5M` entering at connector pin 31 and
   routed to `1R` input pins 2 and 17. `1R` output pin 18 is labelled `B5M*`,
   and `1R` output pin 3 is labelled `B5M`. `1R` active-low enables `/1G` pin 1
   and `/2G` pin 19 are tied low/active.
3. 8C involvement: the Sheet 2A screenshot shows `8C` inverter stages on the
   `B5M*`/`B5M` complement/export path. In the visible crop, `8C` pin 5 -> 6
   outputs `B5M*`, and `8C` pin 9 -> 8 outputs `B5M`, both fed from the local
   `B5M*` node.
4. Does the LS244 generate B5M: no, not in the timing-generator sense. Sheet 6B
   `3D` buffers `5MHZ` into `E5M`, and Sheet 2A `1R` is a
   cross-sheet buffer/distribution stage from `E5M` to `B5M*`/`B5M`. The
   ultimate timing source is still the upstream `5MHZ` generator.
5. Where E5M comes from: Sheet 6B lower `3D` LS244 pin 9, driven by `5MHZ` on
   pin 11, exported at J17 pin 31.
6. Signal type: at Sheet 4A/4B destinations, legacy `BSM`/corrected `B5M` behaves as a timing rail
   used as clocks for LS194, LS163, and `9T`, and as the active-high source for
   active-low 93422 write enable. Whether the generator is a pulse, decoded
   window, divided clock, or buffered timing rail remains unresolved.
7. Active-high at Sheet 4B: yes for writes in the RTL model. `bsm=1` implies `WE_n=0` at
   `8J/8L`. Clocked destinations depend on the physical edge/phase, still
   unknown.
8. Relationship between `B5M`, `B8H`, and `ce_5m`: `B5M` is distributed from
   `E5M`, which is buffered from `5MHZ`; `B8H` is a separate horizontal timing
   rail. Current `ce_5m` is conceptually close to the `5MHZ` family but does not
   encode the cross-sheet buffer/complement path.
9. `wire bsm = ce_5m`: approximate/provisional as a schematic name, but likely
   acceptable as a broad generated 5 MHz clock-enable family once phase/polarity
   are proven. The RTL does not need to model every LS244/LS04 distribution
   buffer unless a delay/polarity distinction becomes behaviour-relevant.
10. Inputs needed for a future non-driving `bsm_schematic_candidate`: the
    existing `ce_5m`/`5MHZ` timing source, plus explicit named staging for Sheet
    6B `3D` output `E5M` and Sheet 2A `1R`/`8C` output `B5M`/`B5M*` if we want
    the RTL names to mirror the schematic.

No `bsm_schematic_candidate` was added because this was a documentation-only
trace. The source path is now clear enough to create a non-driving named timing
rail later if desired.

#### E5M Source Trace

This bounded pass looked one level upstream of the Sheet 2A `1R` LS244. The
current readable audit material now proves `E5M` is sourced on Sheet 6B by lower
LS244 `3D`, pin 9, from `5MHZ` on pin 11, and enters Sheet 2A at connector pin
31. Sheet 2A then distributes it as `B5M*`/`B5M`.

| IC/net | Type | Input pins/nets | Output pins/nets | E5M role | Polarity | Relationship to `B5M` / `B5M*` | RTL equivalent |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `E5M` | Timing/interconnect net | Sheet 6B `3D` pin 9, driven by `5MHZ` at pin 11 | Sheet 6B J17 pin 31, then Sheet 2A `1R` pins 2 and 17 | Source-side rail for board-side `B5M*`/`B5M` | Buffered from `5MHZ` through LS244 `3D`; downstream Sheet 2A complement labels are documented separately | `B5M*`/`B5M` are buffered/distributed from `E5M` through the visible `1R`/`8C` path | No direct RTL signal; current legacy `bsm = ce_5m` bypasses named `E5M` |
| Sheet 2A `1P` | `74LS244` upper interconnect buffer | `E1H`, `E2H`, `E4H`, `E8H` per screenshot | `B1H`, `B2H`, `B4H`, `B8H` per screenshot | Distributes BxH timing rails; not the B5M path | LS244 non-inverting; enables tied active | Provides BxH rails adjacent to the B5M source trace | RTL has fallback `b1h..b8h` aliases |
| Sheet 2A `1R` | `74LS244` lower interconnect buffer | `E5M` from connector pin 31 to input pins 2 and 17, plus `MAP0/MAP1/MAP2/E32H` | pin 18 `B5M*`, pin 3 `B5M`, plus `BMAP0/BMAP1/BMAP2/B32H` and related rails | Buffers/distributes `E5M`; does not generate the timing phase | Non-inverting LS244 distribution; enables tied active | Local distribution source of Sheet 4A/4B corrected `B5M` rail family after the visible `8C` inverters | No structural equivalent |
| Sheet 2A `8C` | `74LS04` inverter stages | `B5M*` node to pins 5 and 9 | pin 6 `B5M*`, pin 8 `B5M` | Complement/export path for the 5 MHz rails; not proven as `E5M` generator | Inverting stages as drawn in the Sheet 2A crop | Confirms local `B5M*`/`B5M` export, but not source-side relation between `E5M` and base timing | No structural equivalent |
| Sheet 6B `3D` | `74LS244` lower interconnect buffer | pin 11 `5MHZ` | pin 9 `E5M` to J17 pin 31 | Generates/distributes the named `E5M` rail from `5MHZ` | Non-inverting LS244 output; enables tied active in the crop | Direct source-side bridge from `5MHZ` to `E5M`; `B8H` remains a separate horizontal rail family | No structural equivalent; current RTL uses broad `ce_5m` |
| Sheet 7A sync chain | `74LS109`, `74LS163`, `74LS160`, `74LS163A`, `74LS74`, gates | `10MHZ`, `5MHZ`, `1H..256H`, sync/blank rails | Produces base timing rails visible in cached Sheet 7A crop | Candidate upstream generator for the `5MHZ` input to Sheet 6B `3D` | Unknown in this audit section | Relationship between base `5MHZ` and horizontal rails remains a broader timing audit topic | RTL fallback counters provide broad timing aliases |

Answers for this E5M pass:

1. Where does `E5M` come from: Sheet 6B lower `3D` LS244 pin 9, driven by
   `5MHZ` at pin 11, exported through J17 pin 31.
2. Master/slave/interconnect location: `B5M` is locally buffered on master
   Sheet 2A through `1R` from `E5M`; `1P` distributes the BxH timing rails.
   `E5M` is sourced on Sheet 6B from `5MHZ`.
3. Buffered version of another rail: yes. `E5M` is a buffered version of `5MHZ`
   through Sheet 6B `3D`; `B5M` is then a Sheet 2A distributed version of
   `E5M`.
4. Active polarity: `E5M` is a non-inverted LS244 output from `5MHZ` on Sheet
   6B `3D`. Legacy `bsm`/corrected `B5M` is active-high at the Sheet 4B 93422
   write-enable destination because `WE_n = !bsm`; the visible Sheet 2A `1R`/`8C`
   distribution path documents the local `B5M*`/`B5M` labels.
5. Relationship to `B8H` / `B5M` / `B5M*`: `B5M*`/`B5M` are downstream of
   `E5M` through Sheet 2A `1R`/`8C`; `B8H` is part of the adjacent `1P` BxH
   rail distribution. Current evidence shows `E5M` is derived from base `5MHZ`,
   not from `B8H`.
6. Current RTL `bsm = ce_5m`: still approximate/provisional by naming and
   structure, but the source evidence now supports it as the correct timing
   family: `E5M` comes from `5MHZ`. A future non-driving cleanup can name the
   stages explicitly without changing behaviour.
7. Inputs needed for a non-driving `bsm_schematic_candidate`: existing `ce_5m`
   plus named non-driving aliases for Sheet 6B `E5M` and Sheet 2A `B5M/B5M*`.

Stop condition cleared for the `E5M` connector source. Remaining broader timing
source, if needed, is the upstream base `5MHZ` generator, not the `E5M` handoff.

### 7F

Confirmed from the cached Sheet 4A crop:

| 7F item | Schematic fact | RTL |
| --- | --- | --- |
| Device | `LS74` | `cloak_74ls74 u_7f_ivdb_latch` |
| D | pin 2 = `IV` | `.d(iv_provisional_from_display_line_bank)` |
| Clock | pin 3 = `B8H` | `.clk_en(b8h_7f_rise)` |
| Q | pin 5 = `IVDSH` | `.q(ivdsh_from_7f)` |
| /Q | pin 6 = `IVDBH` | `.q_n(ivdbh_from_7f)` |

The RTL polarity names match the schematic. The unresolved part is not Q versus `/Q`; it is that the RTL D input is still provisional `display_line_bank`, and the RTL clock edge is derived from provisional `b8h = hcnt[3]`.

## Conclusion

Outcome 1, revised after the Sheet 6B find: `B5M`/legacy `bsm` is no longer an unknown cross-sheet source; it is sourced from `5MHZ` through Sheet 6B `3D` and Sheet 2A `1R/8C`. The RTL `bsm = ce_5m` is still a legacy placeholder name rather than a pin-to-pin buffer-chain model. `IV` and `BYTLOAD` remain provisional in the current RTL/probe, so the closed-loop Sheet 4B probe still cannot be expected to match the real schematic until those sources are replaced or proven.

The next useful work should not be another 8K/8M pin/phase variant. It should trace one true timing source at a time. After the Sheet 6B `E5M` source find, the immediate blockers are now `IV` and `BYTLOAD`; the `B5M`/legacy-`bsm` family is sufficiently traced for documentation and for a later non-driving naming cleanup.
