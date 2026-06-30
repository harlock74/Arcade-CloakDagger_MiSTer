# Audio / Outputs Audit

Branch: `rewrite/schematic-4a-4b`

Sheets:

- `5B`: Outputs, Audio, rendered as `/tmp/cloak_audio_hi/audio_5b.png`
- `10A`: Master memory map, rendered as `/tmp/cloak_pages/page-019.png`

Status: `STARTED`

Purpose: document the currently working audio path and the missing physical
output strobes so later video work does not accidentally regress audio/control
outputs.

Legend:

- `DONE`: structurally represented and verified.
- `PARTIAL`: functionally represented, but not net-for-net.
- `MISSING`: not represented.
- `VERIFY`: visible on schematic but needs further trace before coding.

## Sheet 5B: Audio Timing And POKEY Interfaces

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `7B`, `7P`, `6F`, `11C` | `74LS74` flip-flops | `FREQ`, `BDEL2H`, `B2H`, `B5M`, divided frequency nets | Audio/POKEY timing divider and select timing | `ce_pokey = ce_slave` comment says 10 MHz / 8 | `PARTIAL` | Current clock enable is functional but not net-for-net with the flip-flop divider chain. |
| `6E`, `8D` | `74LS32` | `HFREQ`, `FREQEN`, `LFREQ` | Chip select / frequency enable glue for two sound chips | named `lfreq`, `hfreq`; `ce_pokey` | `PARTIAL` | Address-select names now exist. Exact divider/gate timing remains collapsed. |
| `5C/D` | Atari custom audio/POKEY-compatible chip | `PABA0..3`, `PABR/W`, `AD0..7`, `AUD`, `CHANNEL A/B`, `START1`, `START2`, spare outputs | First POKEY/audio and start-output interface | `pokey_compat pokey1`, `starts` allpot, `pokey1_audio` | `PARTIAL` | Audio and start inputs work functionally; physical output pins are not modeled. |
| `5D` | Atari custom audio/POKEY-compatible chip | `PABA0..3`, `PABR/W`, `AD0..7`, `DIP SW`, `AUD`, `CHANNEL A/B` | Second POKEY/audio and DIP switch interface | `pokey_compat pokey2`, `dips`, `pokey2_audio` | `PARTIAL` | DIP and audio are functionally represented. DIP switch physical bank is simplified into an 8-bit input. |
| DIP switch bank | switch array plus pullups | `DIP SW` lines to second audio/custom chip | Game options | `dips` input | `PARTIAL` | Logic level/polarity should be confirmed before exposing more OSD options. |

## Sheet 5B: Audio Mixing / Analog Output

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| LM324 stages / analog filter | `LM324`, `RS106`, capacitors/resistors | `AUD1`, `AUD2`, `AUD`, `AVREF` | Analog mix/filter/output amplifier | simple digital sum `pokey1_audio + pokey2_audio` | `PARTIAL` | Analog filter is intentionally not reproduced. If audio quality becomes a goal, a digital filter could approximate it separately. |
| J19 audio connector | connector pins | `AUD1`, `AUD2`, `AUD GND` | Physical audio output | MiSTer `audio[15:0]` | `PARTIAL` | MiSTer uses a single digital audio stream; physical dual-output pins are collapsed. |

## Sheet 5B: Output Strobes

| Ref | Device | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `10B` | `74LS259` | `OUT`, `PABD7`, `PABA0..2`, outputs `START LED 1`, `START LED 2`, `COCKTAIL`, `COINCNT R`, `COINCNT L` | Addressable output latch for LEDs, cocktail, coin counters | internal `out_latch[7:0]` | `PARTIAL` | Logical latch exists. Physical LED/counter outputs are not exposed; cocktail is not yet wired into video/input paths. |
| `4/5E` | `74LS04` | `COCKTAIL` to inverted cocktail net | Cocktail output inversion | none explicit | `MISSING/PARTIAL` | Cocktail state is not yet wired through input/playfield/video paths. |
| `10/12`, `10/2` | `74LS07` open-collector drivers | coin counter drive nets | Coin counter output drivers | none | `MISSING` | For MiSTer these should probably become internal debug/status registers or intentional stubs. |
| Output transistors/lamps | discrete drivers | start lamps and coin counters | Physical cabinet outputs | none | `MISSING/IGNORED` | Analog/high-current cabinet drive is intentionally not needed, but the logical latch bits should exist. |

## Current RTL Mapping

Relevant code in `rtl/cloak_core.sv`:

- Audio enables/selects: `ce_pokey`, `m_pokey1_cs`, `m_pokey2_cs`.
- Sound chips: `pokey_compat pokey1`, `pokey_compat pokey2`.
- Inputs into POKEYs: `starts` and `dips`.
- Audio output: `pokey_mix` and `audio`.
- Output latch: `out_latch`, `coin_counter_r`, `coin_counter_l`,
  `cocktail_out`, `start2_led`, `start1_led`.

## Important Findings

- The working audio path should be preserved for now. It is functional, not a
  1:1 reproduction of the timing dividers or analog filters.
- The output latch is now represented internally. It is not likely related to
  the current sprite rendering issue, but it matters for schematic completeness.
- Cocktail output ties back into player/input/playfield selection, so it should
  be represented before finalizing controls and cocktail behavior.

## Next Implementation Candidates

1. Decide whether `FREQEN` needs an explicit timing gate or should stay folded
   into the current POKEY chip-select/clock-enable behavior.
2. Keep physical lamp/coin-driver outputs as internal registers unless a MiSTer
   status/debug output is needed.
3. Connect `cocktail_out` only after input/playfield/bitmap cocktail paths are
   ready.
4. Leave analog filtering alone unless the user later wants audio-quality work.
