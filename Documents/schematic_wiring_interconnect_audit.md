# Wiring / Interconnect Audit

Branch: `rewrite/schematic-4a-4b`

Sheets:

- `9A`: Cloak and Dagger EMI/FMI Shield PCB, rendered as
  `/tmp/cloak_wiring_hi/shield_9a.png`
- `10C`: Main Wiring Diagram - Conversion Kit, rendered as
  `/tmp/cloak_wiring_hi/wiring_10c.png`

Status: `STARTED`

Purpose: record cabinet/harness names that matter for MiSTer controls, video,
audio, and output stubs. These sheets are mostly physical wiring and filtering,
not RTL logic, but they define the original signal names that should be preserved
in comments/wires where practical.

Legend:

- `DONE`: structurally represented and verified.
- `PARTIAL`: functionally represented, but not net-for-net.
- `MISSING`: not represented.
- `IGNORED`: physical/analog detail intentionally not modeled.

## Sheet 9A: EMI/FMI Shield PCB

| Ref | Device / Area | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `P20`/`J20` pass-through | connector/shield board | `GND`, `+5V`, `+5 SENSE`, `+10.3V`, `+12V`, `-5V`, controls, video, audio | Master PCB to cabinet harness pass-through | MiSTer top-level supplies implicit power and I/O | `IGNORED/PARTIAL` | Power/sense rails are not RTL. Signal names are useful for control/video mapping. |
| Capacitor/filter network | EMI capacitors | many harness lines to ground | EMI filtering | none | `IGNORED` | Analog filtering intentionally not modeled. |
| Input harness lines | connector nets | `FIRE1`, `FIRE2`, `COIN R`, `COIN L`, `COIN AUX`, `SELF TEST`, `PL1*`, `PL2*` | Physical input path to Sheet 5A LS244 buffers | `joystick_0`, `joystick_1`, `fire1`, inactive `fire2`, `coin_r`, `coin_l`, `coin_aux`, `self_test`, `start*` | `PARTIAL` | MAME marks player-2 controls and second fire as unused for this game. The MiSTer wrapper now advertises only five action mappings: the four right-stick directions plus Igniter. Start/Coin stay on standard MiSTer start/coin bits. |
| Video/audio harness lines | connector nets | `RED`, `GREEN`, `BLUE`, `HSYNC`, `VSYNC`, `COMP SYNC`, `AUD1`, `AUD2`, `AUD GND` | Cabinet monitor/audio output path | MiSTer RGB/hsync/vsync/audio outputs | `PARTIAL` | Digital signal names map cleanly; analog monitor/audio wiring is not modeled. |
| Output harness lines | connector nets | `START LED 1`, `START LED 2`, `CN CNT R`, `CN CNT L`, `CABINET` | Lamps/counters/cabinet outputs | internal `out_latch` stubs | `PARTIAL` | Logical outputs now exist internally from Sheet 5B `74LS259`; physical drivers remain ignored. |

## Sheet 10C: Main Wiring Diagram / Conversion Kit

| Area | Visible Nets | Function | Current RTL | Status | Notes |
| --- | --- | --- | --- | --- | --- |
| Coin door | `SELF TEST`, `AUX COIN`, `LEFT COIN`, `RIGHT COIN`, power/lamps | Coin/test/service harness | `coin_r`, `coin_l`, `coin_aux`, `self_test` | `PARTIAL` | Core interface now keeps distinct coin/test lines; MiSTer wrapper maps available controls conservatively. |
| Control panel joysticks | right and left joystick switch wiring | Eight directional lines: `R JOYSTICK U/D/L/R`, `L JOYSTICK U/D/L/R` | `joystick_0` maps left stick from MiSTer direction bits `[1]=left`, `[0]=right`, `[3]=up`, `[2]=down`; right stick maps from buttons `[4]=Fire Left`, `[5]=Fire Right`, `[6]=Fire Up`, `[7]=Fire Down` | `PARTIAL` | Original cabinet has two sticks / directional groups. MiSTer presents the right stick as mappable buttons named Fire Left/Right/Up/Down, plus Igniter as button 5. |
| Fire/start controls | `FIRE`, `START1`, `START2`, `START1 LED`, `START2 LED` | Fire button, start inputs, lamp outputs | `start1`, `start2`, joystick buttons; internal LED latch bits | `PARTIAL` | Start inputs exist; LED latch bits are internal only. |
| Monitor connector | `RED`, `GREEN`, `BLUE`, `HSYNC`, `VSYNC`, `VIDEO GND` | RGB monitor output | `red`, `green`, `blue`, `hsync`, `vsync` | `PARTIAL` | MiSTer uses digital output path; physical monitor wiring is reference-only. |
| Audio/speaker | `AUDIO1`, `AUDIO2`, speaker connector | Audio output routing | single mixed `audio` output | `PARTIAL` | Original has two named audio lines; current core mixes both POKEYs into one digital output. |
| Power base / sound board / slave PCB | `+5V`, `+12V`, `-5V`, `6.3VAC`, power grounds | Cabinet power distribution | none | `IGNORED` | Not RTL except reset/power-good behavior handled elsewhere. |

## Current RTL Mapping

Relevant code areas:

- Core inputs in `rtl/cloak_core.sv`: `joystick_0`, `joystick_1`, `fire1`,
  `fire2`, `coin_r`, `coin_l`, `coin_aux`, `cocktail`, `start1`, `start2`,
  `self_test`, `dips`.
- Sheet 5A input logic audit: `schematic_io_video_audit.md`.
- Sheet 5B output/audio audit: `schematic_audio_outputs_audit.md`.
- Top-level MiSTer input mapping should use these harness names when controls
  are cleaned up.

## Important Findings

- These sheets do not add major new RTL logic by themselves, but they confirm
  that current coin/control mapping is simplified.
- Separate `COIN L`, `COIN R`, and `COIN AUX` now exist at the core boundary.
  The wrapper maps right coin to player 1 coin, left coin to player 2 coin, and
  aux coin to the current service input.
- `START LED 1`, `START LED 2`, `CN CNT R`, and `CN CNT L` now exist as
  internal logical latch bits, even though their physical drivers do not matter
  on MiSTer.
- Player/cocktail naming should be kept explicit because playfield, bitmap, and
  inputs all reference cocktail-related paths.

## Next Implementation Candidates

1. Decide whether `COCKTAIL` should be exposed to the MiSTer framework after
   playfield and bitmap cocktail paths are fully verified.
2. Keep output latch stubs internal unless a MiSTer status/debug output is
   needed.
3. Keep all EMI capacitors, sense lines, power rails, and analog speaker/monitor
   wiring ignored except for naming references.
