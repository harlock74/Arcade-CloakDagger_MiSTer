# Cloak & Dagger Sheets 4A/4B Schematic Audit

Branch: `refactor/schematic-motion-object`

Purpose: stop speculative sprite fixes. Every future motion-object change must
reference a row in this audit and either implement it or correct the audit.

Global schematic inventory:

- `Documents/full_schematic_audit.md`

Source images:

- `Documents/cloak.pdf`
- stable reusable crops: `Documents/schematic_crops/`

Legend:

- `DONE`: structurally represented and wired with schematic-style names.
- `PARTIAL`: represented, but still simplified or not net-for-net verified.
- `MISSING`: not yet represented structurally.
- `VERIFY`: visible on schematic, but the exact wiring still needs manual
  confirmation before implementation.

## Current Non-1:1 Areas

The present Verilog is still not a 1:1 reproduction. The largest shortcuts are:

- Motion RAM is still accessed as three software-style tables:
  Y at `0x00..0x3f`, attributes at `0x40..0x7f`, X at `0xc0..0xff`.
- The Sheet 4A object scan/load timing is still driven by abstract
  `render_sprite`/`render_half` state, not by the schematic counters/latches.
- The Sheet 4A `MOHLD`, `MOHRD`, `MOHLC`, `MOHRC`, `MATCH`, `MOFLIP` control
  chain is not net-for-net implemented.
- Sheet 4B final video muxing now has provisional `pbit`, `bmap`, `mbit`,
  `mbj_pending*`, and `lb_display` names, but is still a simplified priority
  mux and line-buffer path in `rtl/cloak_core.sv`.

Latest MiSTer test note:

- Commit `8444cef` restored the schematic-style vertical match window and kept
  the diagnostic inverted motion flip polarity. Player orientation looked more
  plausible, but player/enemy graphics were still very corrupted and sometimes
  spatially separated. Treat this as evidence that continuing sprite nibble or
  flip experiments is low-value until the active path stops bypassing the Sheet
  4B `74LS163`/`93422`/`9T`/`9H` buffer chain.
- Commit `d3e445f` enabled the schematic motion buffer diagnostic with
  `USE_SCHEMATIC_MOTION_BUFFER=1` and phase `2`. MiSTer screenshots in
  `../MISTER screenshots/Latest02` show a terrible regression: persistent
  full-height vertical colored stripe columns overlay the title, high-score,
  intro, and gameplay scenes. Background/playfield/text remain recognizable
  underneath, so this is evidence that the current 93422/9T/9H visible path is
  leaking or retaining motion-buffer data across scanlines. The visible selector
  was restored to compatibility immediately after this test; next work should
  focus on buffer clear/bank/read timing rather than trying more visual phase
  guesses.
- Commit `438760d` added an inactive 93422 bridge clear pass while keeping
  `USE_SCHEMATIC_MOTION_BUFFER=0`. MiSTer screenshots in
  `../MISTER screenshots/Latest03` confirm the full-height vertical stripe
  regression is gone, but show remaining circled floor/edge artifacts during
  gameplay. User also reports random horizontal lines at the top of the screen
  when firing, and the known incorrect main-character/enemy rendering remains.
  Treat these as evidence that retained-buffer state improved, but the motion
  object scan/pixel/write timing is still not correct enough for visual
  sign-off.
- Additional Latest03 screenshot `20260630_184213-screen.png` shows circled
  title-screen character/object fragments near the left and right screen edges
  that appear split into coherent horizontal pieces rather than randomly
  corrupted. Treat this as evidence to prioritize the two-pixel pair sequencing,
  X-address stepping, and left/right 93422/9T/9H buffer selection timing before
  doing more visual flip/nibble experiments.

Sheet 4B timing audit note:

- PDF Sheet 4B (`Documents/cloak.pdf`, Sheet 4B "Motion Object Buffers")
  confirms both `8J` and `8L` `93422` RAMs are single-address motion buffers:
  the `7J/7K` and `7L/7M` counter outputs drive `A0..A7`, `WE` pin 20 is driven
  by `B5M`, and `CS1`, `CS2`, and `OE` pins 19/17/18 are tied active through
  the grounded rail/pull network. The schematic does not show separate read and
  write addresses or a line-bank select on the `93422` symbols.
- The same Sheet 4B crop confirms `9T` (`74LS273`) clocks from `B5M`, with clear
  held inactive, and `9H` (`74LS157`) selects `LB0/LB1` into `MBIT` using
  `VDBH`, with enable tied active. Therefore `9T/9H` are structurally named in
  RTL, but the upstream bridge feeding them is still not 1:1.
- Cached crop `Documents/schematic_crops/sheet_4b/sheet_4b_left_half_pdf63_r220.png`
  confirms the write-side control split: `7J/7K` load from `MOHLO` and clear
  from `MOHRO`, `7L/7M` load from `MOHLI` and clear from `MOHRI`, `8K` selects
  `MBJ0` versus `LB0` with active-low `MOHLI`, and `8M` selects `MBJ1` versus
  `LB1` with active-low `MOHRI`; both mux enables are `IVDBH`. This matches the
  existing RTL pin naming and the focused `motion_buffer_tb` LS157 coverage, so
  there is still no Sheet 4B evidence for swapping the local 8K/8M selector or
  enable polarity.
- Current Sheet 4B conclusion after commits through `742af9c`: the local 8K/8M
  LS157 pin mapping, 8J/8L 93422 CS/OE/WE pins, 9T latch phase, and 9H selector
  have now been corrected or explicitly verified in the non-driving path. The
  non-driving shadow model can exactly match the compatibility d1 reference
  with a synthetic write-lifetime/lane-timing proof candidate, and follow-up
  h4/h6 classifiers show the proof does not collapse to a local 8K/8M selector,
  enable, 8F-bin, 9H, or 93422-control polarity fix. Keep
  `USE_SCHEMATIC_MOTION_BUFFER=0` because the exact proof still depends on an
  inferred h4/h6 lane rule from the temporary shadow model rather than traced
  Sheet 4A `BYTLOAD`/`LOF`/LS194/8F control timing. The latest p3 age-2
  scoreboards show captured right-side pixels are available but 8M mostly sees
  feedback; inverted `IV` would open only half of the h4/h6 proof points, while
  the other half remains in disabled bin 3 with the same timing signature.
- Follow-up diagnostics through `3bab47c` narrowed the earlier gap: the x0
  write slot is exactly one core clock before the current `BSM` alias, and a
  held-x0-plus-current-x4 candidate improves coverage but does not close the
  gap. Its remaining holes are all `t0`, are written under feedback select on
  both sides, and split across all stored 8F bins. Selected-feedback data is
  worse than captured pixels, so the feedback state is a phase/control symptom,
  not the correct data source. Treat the remaining issue as a combined Sheet 4A
  BYTLOAD/object-scan/write-lifetime problem, not an isolated 8M selector
  polarity, 9H side, read-bank, lane swap, address-offset, or 7N source fix.
- The x0-add missing-source classifier added after `8f53b29` shows the
  remaining x0-add blanks still have pre-buffer source candidates (`pix0=24`,
  `pix1=96`, `7n=24`). This keeps the failure on write-side timing/control
  before the 8J/8L buffers, not on missing motion ROM pixel data.
- A follow-up p3-age2 write-lifetime classifier writes the held p3 age-2 source
  at its held address in a non-driving shadow buffer. It is worse than the
  existing x0-held-add candidate (`d1_match=40` versus `48`) and has the same
  fill count (`fills_bridge_missing=60`), so simply writing the p3 age-2 held
  pair at BSM is not the remaining Sheet 4B fix.
- Combining the x0-held write with the p3-age2 held write is complementary and
  improves the shadow score (`d1_match=64`, `d1_missing=88`,
  `fills_bridge_missing=84`), but still leaves most p3/x6 holes. This points to
  a multi-phase write-lifetime handoff rather than a single held-pair fix.
- The remaining combined-candidate holes are still all selected write tag `t0`
  (`t0=88`, `t4=0`), with hmod concentrated on `0/2/3/6/7`, and valid
  pre-buffer source still present mostly in captured pixel1 (`pix1=64`,
  `pix0=24`, `7n=24`). Keep the next probe on the unresolved `t0` write
  lifetime/source lane, not on local 8J/8L/9T/9H readback.
- The same remaining holes split by read side and bank as `b1h0=56`,
  `b1h1=32`, `bank0=44`, `bank1=44`, rejecting a simple remaining read-bank
  polarity fix.
- Residual source-by-hmod classification after the combined shadow is lane
  specific: h0 matches captured pixel0/7N (`24` each), while h2/h3/h6/h7 match
  captured pixel1 (`24/24/8/8`). This keeps the next candidate focused on
  t0 lane-specific write timing rather than whole-buffer side or bank swaps.
- A synthetic upper-bound candidate that fills blank combined-shadow `t0`
  residuals from those proven source lanes removes blank misses
  (`d1_missing=0`) but only matches `152/192`. The remaining 40 value
  mismatches split by hphase as `h4=24`, `h6=16`, with all other hphases zero,
  and a follow-up split shows all 40 come from the existing x0+p3 shadow writes
  (`base=40`, `fill=0`) rather than the synthetic lane fill. The expected
  source split is `pix0=24`, `pix1=16`, `7n=24`, while the wrong candidate
  values split as `pix0=16`, `pix1=24`, `7n=16`; this supports lane-specific
  write timing while rejecting a naive read-time lane substitution as a
  behavior-driving fix. The hphase-local split is now precise: h4 expects
  `pix0=24` but the base candidate holds `pix1=24`, while h6 expects
  `pix1=16` but the base candidate holds `pix0=16`. This is a narrow
  crossed-lane write artifact in the shadow write lifetime, not evidence to
  switch 9H, bank polarity, or the local 8K/8M pin mapping. A final synthetic
  non-driving proof candidate layered on the same shadow model, forcing h4 to
  captured pixel0 and h6 to captured pixel1, exactly matches the compatibility
  d1 reference (`nonzero=192`, `d1_match=192`, `d1_missing=0`,
  `value_mismatch=0`, `fills_bridge_missing=172`). This proves the residual
  inactive mismatch is now fully explained by write-lifetime/lane timing, but
  it is not yet a schematic implementation because the h4/h6 rule is inferred
  from the temporary shadow model rather than traced to Sheet 4A control. A
  write-time metadata classifier on only those 40 h4/h6 proof points shows they
  are not one write source: `current=24`, p3 age-2 held `hold=16`, with write
  tags `tag4=24` and `tag3=16` only. Stored 8F bins split `bin0=20`,
  `bin3=20`, with no `bin1/bin2`. The exact proof therefore crosses both
  current and held write lifetimes, adjacent write tags 4/3, and both outer 8F
  decode states; the next schematic step must explain that through Sheet 4A
  `BYTLOAD`/`LOF`/LS194 sequencing rather than a local Sheet 4B selector flip.
  Splitting the same proof points by hphase makes the lifetime boundary sharper:
  h4 is entirely current-shadow writes (`h4_current=24`, `h4_hold=0`), h6 is
  entirely p3 age-2 held writes (`h6_current=0`, `h6_hold=16`), and each hphase
  splits evenly across stored 8F bins 0 and 3 (`h4=12/12`, `h6=8/8`). This
  points at two distinct Sheet 4A write-lifetime slots rather than one remaining
  8F decode polarity. Storing the provisional LS194 mode bus with the same
  shadow writes shows both corrected lanes are still saturated in current mode
  bin 3 (`h4 b3=24`, `h6 b3=16`, all other bins zero), so the current LS194
  mode terms do not distinguish the h4 current-write and h6 held-write boundary.
  A follow-up write/origin flag classifier stores provisional
  `BSM`/shift-load/`BYTLOAD`-rise/`LOF` flags with the same proof writes:
  h4 write flags are `bsm=24 shift=24 bytload=8 lof=24`, h6 write flags are
  `bsm=16 shift=16 bytload=0 lof=16`, and h6 origin flags are
  `bsm=0 shift=16 bytload=0 lof=16`. Splitting those proof points by
  `BYTLOAD` and 8F bin shows the h4 BYTLOAD subset is evenly split across
  bins 0/3 (`4/4`) and the remaining h4 no-BYTLOAD subset is also bins 0/3
  (`8/8`), while h6 is entirely no-BYTLOAD bins 0/3 (`8/8`). The
  same proof points split by local 8K/8M write-control bins show identical
  proportions for h4 and h6: 8K is always MBJ-selected but half disabled
  (`h4 c0=12 c2=12`, `h6 c0=8 c2=8`), while 8M is always feedback-selected
  and half disabled (`h4 c1=12 c3=12`, `h6 c1=8 c3=8`). The differentiator
  remains the object/write lifetime and BYTLOAD/BSM relationship, not a simple
  current LS194 mode-bin switch, single 8F bin, or local 8K/8M selector
  polarity. Because the h4/h6 proof bins are evenly split across 8F bins 0 and
  3, a single provisional `IV` or `IVDBH` inversion would only move half of the
  proof points into the corrected `MOHRI` bin, while inverting both would move
  neither; keep the next fix upstream of a local 8F polarity swap. `VERIFY`
  2026-07-03: splitting the remaining missing selected tags by
  stored write-source flags confirms the `t0` lifetime is not writing source
  data into the shadow at all (`t0 s0p0/s0p1/s0_7n/s1p0/s1p1/s1_7n=0/0/0/0/0/0`)
  even though pre-buffer source candidates are present (`t0 pix0/pix1/7n=48/88/48`).
  The comparable `t4` misses retain source flags (`s0p1=12`, `s0_7n=12`,
  `s1p0=8`). This keeps the fault on the write-lifetime handoff into 8K/8M,
  not on missing ROM data or a read-side 9H/9T selection. A follow-up
  meta/nonzero split shows the `t0` holes are mixed rather than a single wrong
  data value: only `48` have a nonzero x0+p3 shadow candidate, only `24` carry
  held-meta valid, and the stored meta distribution is mostly zero/x0
  (`t0_x0=112`, `t0_x3=24`, `t0_x4=0`, `t0_x6=0`). By comparison `t4` has
  `36` nonzero shadow candidates with x4 metadata. This keeps the next probe on
  the missing/unmapped `t0` write window, not on swapping a populated shadow
  source. Splitting `t0` by meta-valid sharpens this: invalid/default metadata
  carries most of the source evidence (`pix0=48`, `pix1=64`, `7n=48`) across
  h0/h2/h3/h6/h7 (`24/24/24/8/8`), while valid held-meta contributes only
  `pix1=24`. The remaining work is therefore at least two write-lifetime
  windows: a larger unmapped/default-current `t0` window and a smaller held-meta
  lane window. Splitting the invalid/default `t0` group by stored timing and
  control flags shows all stored metadata is defaulted: `bsm/shift/byt/lof=0`,
  H flags all zero, `8F s0=112`, `8K c0=112`, `8M c0=112`. These samples did
  not receive any x0+p3 shadow write metadata; they must be populated by a
  missing write window rather than by reselecting existing stored data.
  Candidate reachability on the same invalid/default group shows only the x0
  write shadows cover part of it: captured-pair `0/0`, x0-held `24/24`,
  x0-add `24/24`, p3-age2 `0/0`, combined x0+p3 `24/24`
  (`nonzero/match`). The remaining invalid `t0` holes therefore require an
  additional x0/current write window, not a p3-age2 or captured-pair replay.
  A 7F/B8H
  boundary classifier adds that none of the h4/h6 proof points occurs on a
  `B8H` rising edge (`origin_rise=0`, `write_rise=0` for both), with h4 current
  writes at write-`B8H=0` and h6 held writes at write-`B8H=1`; this points to a
  stable phase split around the 7F latch boundary rather than an edge-race fix.
  Sampling the existing Sheet 3B playfield timing candidates at the same proof
  points does not produce a motion `BYTLOAD` substitute: h4 only partially
  overlaps candidate origin `pf_bytload` (`8/24`) and has no candidate write
  overlap, while h6 has no candidate `pf_bytload` overlap and only lines up
  with `NIBLOAD/LDNIB` at origin/write (`16/16`). Keep motion `BYTLOAD` as
  untraced rather than borrowing the playfield candidate.
- A later side-separated x0-add missing-bin classifier rejects the tempting
  aggregate inverted-`IV` explanation for the right buffer: right-side missing
  bins are `s0=12 s1=24 s2=24 s3=12`, so current 8M decode and inverted-both
  each cover `24`, while inverted-`IV` and inverted-`IVDBH` each cover only
  `12`. Keep this as `VERIFY` evidence against switching 8M/8F polarity from
  the p3 aggregate alone.
- Local Sheet 4B closure status after `601cbd0`: with
  `USE_SCHEMATIC_MOTION_BUFFER=0`, focused Icarus now verifies 8K/8M select and
  enable behavior, integrated 8K/8M data steering through 8J/8L into 9T/9H,
  93422 CS/OE/WE behavior including OE/write separation, 9T latch hold timing,
  and 9H left/right selection. The inactive mismatch is now fully explained by
  a non-driving synthetic write-lifetime/lane proof (`192/192` d1 matches), so
  the next implementation risk is upstream Sheet 4A control timing, not a
  currently evidenced local Sheet 4B pin-mapping fix.
- Fresh focused harness rerun after the `INY` correction and side-bin
  classifier still passes (`Motion buffer harness compare passed`), so there is
  no new evidence to change local Sheet 4B `93422`, `9T`, or `9H` timing. Keep
  the next fixes in the upstream Sheet 4A scan/write lifetime unless new
  schematic evidence contradicts this.
- The first upstream Sheet 4A pair-phase classifier after `3baf547` shows all
  four object pairs see the provisional LS194 shift-load window, but only pair
  `p2` sees both `BYTLOAD` rise and the current `BSM` alias (`p0=0/1024/0`,
  `p1=0/1024/0`, `p2=32/1024/1024`, `p3=0/1024/0` for
  `BYTLOAD/shift/BSM`). This narrows the remaining bridge failure toward the
  provisional `BYTLOAD`/`BSM` lifetime relationship rather than missing LS194
  activity across pairs.
- The pair hold-to-`BSM` classifier confirms the provisional non-`BSM` phases
  are not uniform: `p0` reaches `BSM` one clock later (`a1=1024`), `p1` is
  sampled at the next `BSM` with age zero (`a0=1024`), `p2` is already the
  `BSM` phase, and `p3` reaches a later/non-adjacent `BSM` bucket
  (`other=1023`). This is further evidence that replacing one x0 slot is not a
  complete fix; the temporary scanner's pair-to-`BSM` cadence must be replaced
  by schematic `BYTLOAD`/hold timing.
- A follow-up pair hold address classifier shows only `p0` has a clean
  previous-address relation at the next `BSM` (`left/right m4=1024`). Held
  `p1` and `p3` do not match same, `-4`, or `+4` on either side in this
  temporary cadence, so a general "hold every non-BSM pair to the next BSM"
  bridge would still be phase-incoherent.
- The x0-add remaining-hole classifier shows the post-p0-fix blanks are still
  entirely captured pair `p3` / x slot `x6` (`p3=120`, `x6=120`). This keeps
  the next target on the final subslot's `BYTLOAD`/LS194/7N/write-lifetime
  relationship, not on the earlier p0 held-address opportunity.
- The p3/x6 source-path classifier shows those remaining holes are all
  physical `MOPA X=1` and flipped (`flip1=120`, `11f1=120`), while LS194/MBJF
  outputs match only `24/120`. This keeps 11F flip polarity out of the suspect
  list and points back to final-subslot LS194/BYTLOAD/write timing.
- High-resolution Sheet 4A crop confirms the LS194 `CLK` pins are `BSM`, not
  the temporary `render_pending` alias. Icarus overlap evidence now shows only
  pair `p2`/x4 is loaded during `BSM` (`both=1024`), while p0/x0, p1/x2, and
  the bad p3/x6 slot are all `shift_only=1024`. Expanding the p3 hold-to-BSM
  age histogram shows p3 is not drifting: it lands at age 2 for `992` samples
  with a small saturated tail of `31`, so the next target is a fixed late
  LS194/BYTLOAD/BSM phase, not local 8J/8L/9T/9H readback.
- The p3 age-2 source/selector probe shows the late p3 data is present before
  the buffer (`pix0_nz=992`, `pix1_nz=992`, `7n_nz=992`), and left-side 8K
  selection is open to MBJ for every sample (`8k_mbj=992`). The right-side 8M
  path is still almost entirely feedback (`8m_fb=984`, `8m_mbj=8`), matching
  the earlier MOHRI evidence and keeping the unresolved p3/x6 problem on the
  right-side `BYTLOAD`/`MOHRI`/8M timing.
- A p3 age-2 hphase classifier shows those same samples split evenly across
  the local horizontal bits (`b1h=496`, `b2h=496`, `b4h=512`, `b8h=512`) and
  line bank (`496`). This rejects a simple "use one H counter bit as IV" fix
  for the p3/8M window; the real `IV` source still needs schematic tracing.
- The named but non-driving LS194 mode-chain classifier shows the same p3
  age-2 window is saturated by the current provisional NIB LOAD/FLIP terms
  (`10D pin6=0`, `10C pin6=992`, `10D pin8=992`, `flip_n=0`). This does not
  explain the bad p3 select phase by itself; the real NIB LOAD/BYTLOAD source
  and timing still need to replace the `render_pending` alias.
- A non-driving candidate that feeds the Sheet 4A LS194 mode chain from the
  already named Sheet 3B `NIBLOAD` term is more selective than `render_pending`
  for p3 age-2 (`10D pin6 high=736`, `10C pin6 high=256`) but still leaves the
  10D pin8 mode bus saturated (`992`). This is useful evidence for the next
  NIB LOAD trace, but not enough to drive LS194 mode yet.
- The p3 age-2 11F classifier shows `FLIPM` is already high for every sample
  (`992/992`), and latched `FLIP` is also high for every sample; the provisional
  `LOF` alias is high at the sample point but `BYTLOAD` rise is zero. This
  keeps the failure upstream of a simple 11F output polarity change.
- Superseding note after the high-resolution 8F label check: older 8K/8M audit
  text that treated `MOHRO p3=504` as the neighboring useful right-side window
  was based on the earlier Y0/Y1 right-decode mapping. With Sheet 4A `8F`
  corrected to `Y1=MOHRO`, `Y2=MOHRI`, the post-correction diagnostics are
  `mohri_mbj s1=40`, `mohro_mbj s2=40`, and `8m_mbj p3=16`; use these values
  for the next timing step.
- A corrected-8F p3 age-2 bin probe shows the held decode phase and the BSM
  decode phase are identical (`hold s0/s1/s2/s3=488/8/8/488`, same at `BSM`).
  Therefore the p3/8M failure is not caused by the hold-to-BSM handoff changing
  `IV/IVDBH`; the provisional `IV/IVDBH/BYTLOAD` cadence itself rarely reaches
  corrected `MOHRI=Y2`.
- Inference from the corrected p3 bins: `MOHRI=Y2` requires
  `{IV,IVDBH}=2`, but p3 age-2 mostly sits in bins 0 and 3. Inverting only the
  provisional `IV` source would move the large `s0=488` bucket into the MOHRI
  select state, so the next bounded trace should verify the real Sheet 4A `IV`
  source/polarity into 7F/8F before trying another 8M selector workaround.
- Sheet 4A local boundary: the high-resolution crop shows `IV` entering 7F
  and 8F as a named net; Sheet 4B does not generate it, and the 8J/8L/9T/9H
  buffer path only consumes the resulting `IVDBH`/`MOHRI` timing. Treat the
  exact `IV` source/polarity as upstream of the current Sheet 4B buffer audit.
- Regenerated local inspection crop from `Documents/cloak.pdf` with
  `.venv-pillow` confirms only the local Sheet 4A boundary: 8F enable is
  `BYTLOAD`, 8F inputs are `B=IV` and `A=IVDBH`, 7F captures `IV` on `B8H`,
  and 7F outputs `IVDSH/IVDBH`. The crop does not show the upstream source of
  `IV`, so do not infer one from Sheet 4A alone.
- Non-driving p3 age-2 inverted-`IV` candidate evidence: if only the provisional
  `IV` bit is inverted before the corrected `8F` decode, 8M would select MBJ
  for `488/992` late p3 samples, and all of those have both nonzero pixel1
  source data and the proven nonzero 7N source (`7n_nz=488`). This is not a
  behavior switch; it is evidence that the next schematic trace should
  prioritize the real `IV` polarity/source.
- Polarity candidate split: inverting only `IVDBH` gives the same p3 age-2
  recovery shape (`8m_mbj=488`, `selected1_nz=488`, `7n_nz=488`) as inverting
  only `IV`, while inverting both collapses back to the current weak window
  (`8m_mbj=8`, `7n_nz=8`). This keeps both the upstream `IV` polarity and 7F
  output polarity on the suspect list until the Sheet 4A net source is pinned
  down.
- Corrected IV-source candidate check: when the candidate is treated as a true
  7F source with its own delayed output, simple aliases do not open the p3
  age-2 `MOHRI` window. Line-bank, inverted line-bank, `vcnt[0]`, inverted
  `vcnt[0]`, and Sheet 6B `INY` score `8/992`, `8/992`, `8/992`, `8/992`, and
  `0/992` MBJ/feedback respectively. Therefore the earlier one-sided
  inversion score (`488/992`) is only a polarity stress probe, not evidence to
  drive `IV`, `IVDBH`, or 8F from those aliases.
- P3 age-2 `BYTLOAD`-source candidate check against the corrected 8F bin shows
  no nearby timing alias opens the right-side window: provisional level,
  Sheet 3B `pf_bytload`, and `pf_ldf` each score only `8/992`, while
  provisional rise, `pf_nibload`, and `pf_ldnib` score `0/992`. This keeps the
  failure on combined object-scan/write lifetime and real motion `BYTLOAD`
  tracing, not a simple substitution of the already named Sheet 3B terms.
- Delayed bridge handoff matrix now proves the temporary renderer has an exact
  one-pair data skew: pending p0 writes current p1 data, p1 writes p2, p2
  writes p3, and p3 wraps to p0 (`1024` samples in each off-diagonal bucket,
  zero on the diagonal). Coordinates still match the captured scan point, so
  the remaining inactive 4B mismatch is not random drift; the next structural
  fix must align ROM/LS194 pixel data with the saved object-scan coordinate
  before changing any visible selector.
- RTL now names that non-driving capture boundary as
  `motion_object_scan_capture_*`, storing the scan pair, X coordinate, SX, and
  current ROM pixel pair on `motion_object_scan_match_current`. These registers
  are not connected to 8K/8M or visible video yet; they exist to make the next
  schematic-timed handoff explicit and reversible.
- RTL also adds non-driving 8K/8M scan-capture candidate muxes using the same
  Sheet 4B select/enable pins but sourcing MBJ from
  `motion_object_scan_capture_pixel0/1`. Their outputs are unused; this only
  marks the next safe insertion point for aligning scan pixel data with the
  saved coordinate after the remaining BYTLOAD/BSM lifetime is understood.
- P3 age-2 scoring of those RTL candidate muxes shows captured pixels are
  available on both sides (`scan_sel0_nz=496`, `scan_sel1_nz=496`), but the
  current 8F/IVDBH controls still block half the window. This confirms captured
  data is necessary but still not sufficient without the real motion
  BYTLOAD/BSM control lifetime.
- A follow-up split by held 8F bin/source shows the scan-capture candidate is
  nonzero in bins 0 and 2 only (`8K s0=488 s1=0 s2=8 s3=0`,
  `8M s0=488 s1=0 s2=8 s3=0`). 8K is selected from MBJ for all nonzero
  samples (`8k_mbj_nz=496`, `8k_fb_nz=0`), while 8M is still almost entirely
  feedback (`8m_mbj_nz=8`, `8m_fb_nz=488`). Keep the path non-driving; the next
  target is the missing 8M-side write-control lifetime, not 9H or 93422 RAM
  behaviour.
- A direct captured-pixel IV-polarity scoreboard shows that moving held bin 0
  into the `MOHRI` MBJ case would expose `488` captured right-side pixels
  (`8m_inv_iv_mbj_nz=488`). This is useful evidence for the upstream
  `IV`/`7F`/`8F` phase problem, but not a behaviour change: earlier full
  coverage candidates already rejected a simple local 8M polarity flip as the
  complete Sheet 4B fix.
- Comparing that diagnostic against the h4/h6 perfect proof points shows why:
  current `MOHRI` opens none of those 40 points
  (`h4_current_8m=0`, `h6_current_8m=0`), while inverted `IV` opens only the
  bin-0 half (`h4_inv_iv_8m=12`, `h6_inv_iv_8m=8`). The other half remains in
  disabled bin 3, so the complete correction still needs the upstream
  `BYTLOAD`/`IVDBH` lifetime as well as the right-side `MOHRI` phase.
- Splitting those same proof points by bin 0 versus bin 3 timing flags gives
  identical signatures (`origin_byt=4`, `origin_nib=16`, `origin_ldnib=20`,
  `write_nib=8` for both; no `write_byt`, `write_ldf`, or `write_ldnib`).
  Therefore the disabled bin-3 half is not a distinct local 8K/8M data-steering
  condition; it is the same upstream lifetime arriving under the wrong
  `IVDBH`/`MOHRI` phase.
- A broader p3 age-2 combined scoreboard crossing inverted `IV` with the
  already named timing flags also does not identify a unique substitute:
  origin/write `pf_bytload` each overlap `424`, `pf_nibload` `128`, `pf_ldf`
  `120`, and `pf_ldnib` `368` samples, all with nonzero right-side data. These
  are broad phase correlations, not a clean motion `BYTLOAD`/`LOF` source.
- A new persistent cached crop
  `Documents/schematic_crops/sheet_4a/sheet_4a_bytload_lof_ls194_wide_crop.png`
  keeps the LS194s, 1H/8F decode, 7F, 7N, and 10C/10D mode gates in one view.
  It reinforces that `BYTLOAD` is the decode rail into 1H/8F, while
  `NIB LOAD` enters the LS00/LS194 mode logic separately and `LOF` remains the
  independent 11F clock rail. Do not collapse these three nets into one alias.
- RTL now names this separation explicitly with
  `motion_bytload_decode_enable_provisional` and
  `motion_lof_clock_provisional`, while retaining the old provisional aliases
  for existing probes. This is naming-only; main Icarus and the focused motion
  buffer harness still pass.
- Non-driving 11F probes using the schematic LS86 `FLIPM` candidate but clocked
  from `B4H` rise or from the current `BSM` phase both score `0` high samples
  in the p3 age-2 window, same as the existing LS86/LOF candidate. This rejects
  a simple "LOF is B4H/BSM" substitution while LS194/8F timing remains as-is.
- The same 11F candidates were then scored on only the 40 exact h4/h6 synthetic
  proof points: current provisional `FLIP` is high for all proof points
  (`h4=24`, `h6=16`, and `bin0=20`/`bin3=20`), while the LS86 `FLIPM`
  candidate with provisional `LOF`, `B4H`, or `BSM` clocking is `0` for every
  one. This confirms the proof still depends on the old saturated flip shortcut
  and cannot be promoted to a schematic 11F result without tracing `LOF`.
- Non-driving 11F LS86/`FLIPM` candidates clocked from the already named Sheet
  3B timing aliases (`pf_bytload`, `pf_nibload`, `pf_ldf`, `pf_ldnib`) also
  reject a simple `LOF` substitution. Icarus passes and reports p3 age-2 high
  counts `0/0/0/0`, so these aliases are not promoted to the Sheet 4A `LOF`
  source while `USE_SCHEMATIC_MOTION_BUFFER` remains off.
- Falling-edge versions of those same Sheet 3B aliases were then tested as
  non-driving 11F clocks. Icarus still reports p3 age-2 high counts `0/0/0/0`,
  so neither rising nor falling edges of `pf_bytload`, `pf_nibload`, `pf_ldf`,
  or `pf_ldnib` explain the missing `LOF` timing.
- Extending the same proof-window metadata from `B8H` to origin/write
  `B1H/B2H/B4H` does not reveal a simple horizontal selector. The proof points
  score `h4 ob1/ob2/ob4=24/16/16`, `h4 wb1/wb2/wb4=24/16/16`,
  `h6 ob1/ob2/ob4=8/8/8`, and `h6 wb1/wb2/wb4=8/8/8`; the h6 side is the
  held p3-age2 subset, not an isolated B1/B2/B4 write-side phase.
- A proof-window 8K/8M source-match classifier stores whether the selected
  write data equals captured `pixel0`, `pixel1`, or 7N. It shows h4 is only
  partial (`8K=pixel1/7N 12/12`, `8M=pixel0 8`), while h6 is zero for all
  selected-data matches. The remaining h6 proof is therefore not just a local
  8K/8M mux choice with the held pixels already present; the held p3-age2 data
  is missing before the selected write-data point.
- Splitting that source classifier into origin-selected versus write-selected
  data gives the same counts (`h6` remains all zero), so the missing held h6
  pixels are already absent at the origin selected-8K/8M point. The captured
  pixels exist before the mux, but the current/provisional 8K/8M selected path
  does not carry them.
- A proof-window upstream pixel-path classifier shows where the h6 held pixels
  diverge before 8K/8M: h4 has `7N=pixel1 24`, `LS194=pixel1 16`, and
  `MBJF=pixel1 24`; h6 has `7N=pixel0 8`, `LS194=pixel1 8`, and
  `MBJF=pixel0 8`. The h6 expected pixel1 exists at the LS194-direct point for
  half the proof window, but 7N/MBJF point at the opposite lane, keeping the next
  target on 7N/`FLIP`/LS194 timing rather than local 8K/8M steering.
- Splitting that pixel-path classifier by 8F bin shows the h6 divergence is in
  bin 3. Bin 0 only carries the h4 half (`7N=pixel1 12`,
  `LS194=pixel1 8`, `MBJF=pixel1 12`), while bin 3 carries h4 plus h6:
  `7N=pixel0 8/pixel1 12`, `LS194=pixel1 16`, and
  `MBJF=pixel0 8/pixel1 12`. This makes the bad half a bin-3 7N/MBJF select
  problem, not a generic LS194 data absence.
- A parallel-ROM proof classifier shows the data is correct before LS194
  sequencing: h4 has `parallel0=pixel0 24` and `parallel1=pixel1 24`; h6 has
  `parallel0=pixel0 8` and `parallel1=pixel1 8`. Split by bin, bin 0 scores
  `p0->pixel0 12` and `p1->pixel1 12`; bin 3 scores `20/20`. Therefore the
  h6/bin3 failure is between the parallel ROM output and the LS194/7N path,
  not in the ROM bit grouping itself.
- Re-running the source-path proof after correcting the 7N pin audit keeps the
  RTL logical 7N order validated: the non-driving physical-package
  reconstruction equals the existing logical 7N bus for every captured sample
  (`known=4096 equal=4096`) and scores the same missing-window matches as the
  current 7N path (`7n_match=84`, `7n_pin_order_match=84`). The h4/h6 proof
  still shows the real split in `FLIP`/LS194 timing (`h4 7N=pixel1 24`,
  `LS194=pixel1 16`, `MBJF=pixel1 24`; `h6 7N=pixel0 8`,
  `LS194=pixel1 8`, `MBJF=pixel0 8`), so the corrected selector package order
  does not justify a behaviour change. Keep the next work on `LOF`/`FLIP` and
  LS194 load/shift timing.
- The same smoke run also scores the non-driving 10C/10D LS194 mode candidates
  against the current missing-captured window. The current LS194 tap and MBJF
  each match `84/172`, the direct 10C/10D mode candidate drops to `56/172`,
  and the inverted mode candidate scores `0/172`. This rejects a simple
  "S0/S1 polarity is backwards" fix; the pins are mapped, but the missing piece
  remains timing/lifetime of `NIB LOAD`, `FLIP`/`LOF`, and `BSM`.
- A non-driving LS194 mode-bin check also compares Sheet 3B `NIBLOAD` versus
  `LDNIB` as the candidate 10D pin-5 source, using the same 6H `/MATCH` and
  LS86 `FLIP` candidates. In the p3 age-2 window, `NIBLOAD` gives raw mode
  bins `b2=737/b3=255`; `LDNIB` gives `b2=257/b3=735`; current provisional
  timing remains saturated at `b3=992`. This proves `LDNIB` is a distinct
  timing candidate, but still not behaviour-ready without the real motion
  `NIB LOAD` source and `LOF` timing.
- A focused one-shot p3 age-2 LS194 trace now prints one held nonzero byte
  through the source path. The representative sample is
  `mrom=5aa5`, parallel pixels `5/a`, captured pixels `5/a`, LS194 taps
  `q3/q2/q1/q0=5/a/a/5`, 7N output `5`, and selected 8K/8M data `0/0`.
  Its held flags are `load={lof,byt_rise,shift,bsm}=1010`,
  `timing={ldnib,ldf,nib,byt}=1011`, `8f={iv,ivdbh}=11`, with current mode
  `11`, NIB candidate mode `10`, LDNIB candidate mode `10`, provisional
  `FLIP=1`, provisional `FLIPM=1`, and LS86 `FLIPM=0`. A companion counter
  shows LS194 Q3 equals Q0 for every p3 age-2 sample (`eq=992`, `ne=0`), so
  7N normal/flipped choice cannot explain this specific failing window by
  itself. The byte exists at ROM/LS194/7N, but the write-side selected data is
  still blank, keeping the boundary on load/shift/write timing rather than 7N
  package order or a simple flip select.
- The same diagnostic now compares the held scan-time 7N value against the
  live 7N/ROM state at the BSM write point. In the p3 age-2 window, live 7N
  equals held 7N for all samples (`992/992`), equals held pixel0 and live
  parallel pixel0 for all samples (`992/992` each), and never equals held
  pixel1 or live parallel pixel1 (`0/992`). The representative live-at-BSM
  trace matches the held trace (`mrom=5aa5`, `par0=5`, `par1=a`, `q3=5`,
  `q0=5`, `7n=5`). This says the p3 age-2 source path is stable into 7N and
  consistently points at pixel0; the failure is the timing/control handoff from
  that 7N value into the 8K/8M write-side selected data, not a late 7N sample.
- Extending that p3 age-2 probe across the live 8K/8M pins shows the handoff
  split. At BSM, live 8K control bins are `c0=496/c2=496` and live 8M bins are
  `c0=8/c1=488/c3=496` (`c={G_n,select_n}`); actual data is nonzero
  `496/496`, the non-driving 7N-input candidate is also nonzero `496/496`,
  but actual output equals live 7N only on 8K (`496/0`). The representative
  nonzero source trace has both muxes disabled/feedback-selected at the sampled
  write instant (`8k_ctrl=10`, `8m_ctrl=11`, actual `0/0`, candidate `0/0`).
  This keeps the fault on 8K/8M control/data-source lifetime: 8K can pass 7N
  during the enabled half, while 8M is still steered away from 7N for the p3
  age-2 right-side window.
- Enlarged cached crop `sheet_4a_7f_8f_iv_labels_zoom.png` resolves a naming
  error in the inactive RTL: 7F pin 5 Q is `IVDSH`, while pin 6 `/Q` is
  `IVDBH`, and 8F pin 2 takes `IVDBH`. RTL now maps `ivdbh_from_7f` from
  `q_n`, still non-visible because `USE_SCHEMATIC_MOTION_BUFFER=0`. Icarus
  passes after the correction and the p3 age-2 8M window changes from
  `8m_mbj=8` to `8m_mbj=488`; the representative trace becomes
  `8f={iv,ivdbh}=10`, `8k_ctrl=00`, `8m_ctrl=00`, actual data `5/a`, and
  7N-candidate data `5/5`. The inactive comparison only improves slightly
  (`schematic_missing=168`), so this is a real pin fix but not sufficient to
  enable the schematic buffer.
- With 7F fixed, the inactive 8K/8M mux A inputs were moved from temporary
  `mbj_pending0/1` to the audited 7N `MBJ*` bus. Icarus passes and the p3
  age-2 handoff now shows actual data equals live 7N on both selected sides
  (`actual_eq_7n=496/488`), with the representative trace `sel0=5`,
  `sel1=5`, live `actual=5/5`, and `cand7n=5/5`. This is pin-correct but not
  behaviour-ready: inactive d1 comparison now reports `schematic_missing=168`
  and `value_mismatch=12`, proving the remaining issue is still phase/lifetime
  around `BYTLOAD`/`BSM`/counter write timing rather than the 8K/8M A pin
  source alone.
- A follow-up sim-only classifier localizes those 12 new value mismatches:
  all are `h6`, `b1h=0`, read bank 0, and selected write tag `t0`
  (`h6=12`, `b1h0=12`, `bank0=12`, `tag0=12`). This keeps the 7N A-input
  correction as pin-honest and narrows the new wrong-value risk to the same
  late `t0` write-lifetime/hphase problem already seen in the missing-pixel
  diagnostics.
- Superseding note for the older 7F candidate text below: the pre-correction
  IV-source candidate matrix was taken before 8F was remapped to
  `Y1=MOHRO/Y2=MOHRI` and before the 7F Q/`/Q` naming correction. Use the
  corrected p3 age-2 diagnostics above for the current `IV`/`IVDBH` question.

## Sheet 4A: Motion Object

Pin-level audit note: the strict Sheet 4A/4B motion-object pin table now lives
in `Documents/schematic_4a_4b_pin_audit.md`. Use that table as the pin contract
before making further behaviour-driving changes to the motion-object path.

### Motion RAM Address And Data

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `5L` | `74LS157` | `PABA7`, `PABA6`, `PABA5`, `PABA4`, `B4H`, `B2H`, `B32H`, `12BH`, `MOA7..MOA4`, `MORAM*` | Upper motion RAM address mux | `PARTIAL` | RTL now uses explicit `cloak_74ls157` instances for the upper CPU/Y/ATTR/X MOA phases. This is still phase-expanded because the renderer has not yet been converted to the single physical MOA bus. |
| `5M` | `74LS157` | `PABA3..PABA0`, `B32H`, `B8H`, `5H`, `MOA3..MOA0`, `MORAM*` | Lower motion RAM address mux | `PARTIAL` | RTL now uses explicit `cloak_74ls157` instances for the lower CPU/Y/ATTR/X MOA phases. The exact board select equation is still pending the timed object-scanner rewrite. |
| `6M`, `6L` | `2101A-2` | `MOA0..MOA7`, `PABD0..PABD7`, `MOD0..MOD7`, `PAWRITE` | Motion-object RAM pair | `PARTIAL` | Storage is now split into `motion_ram_6l` and `motion_ram_6m` nibble arrays, with named low/high MOD outputs. Reads are still phase-expanded because the renderer has not yet been converted to one timed physical MOA/MOD bus. |
| `7H` | `74LS244` | `MOD0..MOD7`, `PABD0..PABD7`, `MORAM*`, `PABR/W` | CPU readback buffer from motion RAM | `PARTIAL` | RTL now instantiates `u_7h_mod_to_pabd_buffer` with active-low enables derived from `MORAM` and CPU read. Internal tri-state is represented as inactive `8'hFF`; exact board enable polarity should still be pin-verified. |

### Motion Data Latches And MOPA Generation

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `6K` | `74LS273` | `MOD0..MOD7`, `CLS A..H`, intermediate outputs | Latches motion RAM data into counter/address path | `PARTIAL` | RTL now instantiates an explicit `cloak_74ls273` as `u_6k_mod_latch`, clock-enabled from the detected `B2H` rising edge. Its `CLS` output is named but not yet behaviour-driving until the downstream `5K/6J/6H` path is connected. |
| `6J` | `74LS83` | `CLSA..CLSD`, vertical timing bits, carry/sum outputs | Low-nibble motion Y adder | `PARTIAL` | Crop confirms this is an LS83 adder, not an LS163 counter. RTL now instantiates `u_6j_motion_y_adder_low`; its low sum drives the motion ROM line address through `mopa_low_from_6h`. It still uses direct `MOD` as `cls_for_5k_6j` until the full B2H/B4H object scan timing can safely use the 6K latch output. |
| `5K` | `74LS83` | `CLSE..CLSH`, vertical timing bits, carry from `6J`, high sum outputs | High-nibble motion Y adder | `PARTIAL` | RTL now instantiates `u_5k_motion_y_adder_high`; high sum bits feed the named `5J` match decode. |
| `5J` | `74LS20` | High `5K` sum bits, output to `6H` latch | Decodes vertical match window | `PARTIAL` | RTL now names `match_from_5j_ls20_n` and derives `match_from_6h` from the LS20-style active-low decode. |
| `8H` | `74LS273` | `MOD0..MOD7`, `MOFLIP`, `MOPA5..MOPA11`, `B4H` | Latches flip and high motion picture address bits | `PARTIAL` | Crop confirms `MOD7 -> MOFLIP` and `MOD6..0 -> MOPA11..5`; RTL now instantiates `u_8h_motion_addr_latch` with a detected `B4H` rising edge. The latched outputs are named, but the simplified renderer still uses direct MOD attributes until the full motion-address timing chain is connected. |
| `6H` lower latch | `74LS174` | `MATCH`, `MOFLIP`, `MOPA1..4`, `B4H` | Captures low MOPA/match related state | `PARTIAL` | Crop confirms the latch outputs `MATCH` and `MOPA1..4`; RTL now instantiates `u_6h_match_mopa_latch` using the same detected `B4H` edge. The latched outputs are named but not yet behaviour-driving. |

### Motion ROMs And M Data Bus

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `6N`, `8R` | `2532` | `MOPA11..MOPA1`, `M14H`, `M0..MF` | Two motion-object graphics ROMs | `PARTIAL` | Cached crop `sheet_4a_6n_8r_motion_rom_pin_crop.png` proves the shared ROM address pins and data split: 6N outputs `M0..M7`, 8R outputs `M8..MF`, and both chip selects are tied low. RTL maps this as `motion_rom_parallel_data = {motion_rom_8r_data, motion_rom_6n_data}` and exposes `m0..mf_mrom`. Data-bit mapping is exact, but ROM address phase remains approximate because active `motion_video_addr` still uses provisional motion-address timing and bank selection. `USE_SCHEMATIC_MOTION_ROM_PIXELS` remains off; LS194 load/shift timing must be verified before this can be behaviour-driving. |
| `6P`, `6R`, `7P`, `7R` | `74LS194` | `M0..MF`, `MBJ0..MBJ3`, `MBJ0F..MBJ3F`, `MATCH`, `FLIP` | Shift-register pixel path | `PARTIAL` | RTL now instantiates four `cloak_74ls194` registers with the visible interleaved ROM-bit groupings. Their `MBJ/MBJF` outputs are named but not yet behaviour-driving because the exact `BYTLOAD`/shift/flip timing is still pending. The current shortcut is now explicit in code as `motion_shift_load_from_render_pending = render_pending` with provisional parallel-load mode `2'b11`; this documents that the LS194s are still being loaded by the temporary renderer rather than the schematic BYTLOAD/shift chain. Sheet 4A crop evidence confirms all four LS194 `CLK` pins are labeled `BSM`, while `S0/S1` are driven by the LS00/MATCH/NIB LOAD/FLIP-side logic rather than the temporary `render_pending` alias. A high-resolution Pillow crop and the cached `sheet_4a_ls194_nibload_10c_10d_crop.png` confirm `/MATCH` through 10E, `NIB LOAD`, and `FLIP` feed LS00 gates 10D/10C before the LS194 mode buses; the nearby `BYTLOAD` label belongs to the 1H/8F decode boundary and should not be confused with this `NIB LOAD` trace. The zoomed crop confirms the gate labels/pins as 10D pin 6, 10C pin 6, 10D pin 11, and 10D pin 8. RTL now names these non-driving observed terms as `motion_ls194_*`, with `NIB LOAD` still explicitly provisional from `render_pending`. A new Icarus overlap classifier quantifies the shortcut: only pair `p2`/x4 overlaps `BSM` (`both=1024 shift_only=0`), while p0/x0, p1/x2, and the failing p3/x6 subslot are all `shift_only=1024` with zero `BSM` overlap. Sim-only render-pair diagnostics sampled on `ce_5m` alias to one apparent pair, and the current `7N` output matches `pending0` but not `pending1` in that sampled view. A deterministic all-clock probe corrects that alias: the temporary scanner does produce all four pair/x slots (`scan pair p0=1023 p1=1024 p2=1024 p3=1024`, `x0=1023 x2=1024 x4=1024 x6=1024`) and the delayed bridge write also sees all four slots (`wx0/wx2/wx4/wx6=1024`). A captured-pixel handoff probe now shows the specific shortcut failure: delayed bridge coordinates match the captured scan coordinates (`4094/4094`), but the MBJ pair written by the bridge matches the current ROM pair (`4094/4094`) and never the captured scan pair (`0/4094`). A non-driving captured-pair buffer candidate partially improves the d1 score (`nonzero=48`, `d1_match=24`, `fills_bridge_missing=28`) but leaves most missing pixels (`d1_missing=144`), so captured pixel data is necessary evidence but not sufficient by itself. Missing-d1 classification is now concentrated entirely in captured scan pair `p3` / x slot `x6` (`p3=112`, `x6=112`), narrowing the remaining problem to the final object-scan subslot rather than all pair lanes. The same missing samples split across captured 8F bins (`s0=16`, `s2=64`, `s3=32`), so the final-subslot issue is not confined to the nominal `MOHRI` bin. All of those p3/x6 misses use captured physical `MOPA X=1` and flipped orientation (`flip1=112`); 11F's captured flip latch agrees with the provisional renderer flip for every one (`flip_disagree=0`), and the expected d1 pixels split evenly between captured pixel0 and pixel1 (`56/56`). Captured 7N/LS194/MBJF outputs also match only that same half of the missing pixels (`56/112` each), so this is not a single nibble-order inversion or a simple 11F/7N output swap. The pixel0/pixel1 split has identical final read-side distribution (`pix0_b1h0/1=32/24`, `pix1_b1h0/1=32/24`) and identical read-bank distribution (`48/8` for each), while hmod separates cleanly (`pix0` on h0/h1/h4/h5, `pix1` on h2/h3/h6/h7), pointing at write-side subpixel phase rather than 9H side or bank polarity. A write-address bit1 hphase candidate scores no direct d1 matches (`nonzero=48`, `d1_match=0`, `fills_bridge_missing=28`), rejecting a simple "choose captured pixel0/pixel1 from address bit 1" data-steering fix. A selected-side offset scan shows captured-pair candidate matches nearby rather than absent (`m2=16`, `z=12`, `p2=16`, `p4=12`); the hphase candidate only matches at `m2=28` and `p2=28`, reinforcing an address/phase lifetime problem. Fixed-offset candidate reads at `m2`, `p2`, and `p4` do not improve direct d1 matches (`24/24/24`) versus the base captured-pair candidate and only fill blank holes (`28/28/12`), rejecting a simple constant address offset. Missing selected-side write tags at exact/m2/p2/p4 remain concentrated in bridge tags `t0/t4` (`exact=84/28`, `m2=84/28`, `p2=84/28`, `p4=100/12`), so the hole follows the temporary bridge write lifetime rather than arbitrary read-side RAM contents. The captured-pair candidate's actual recovery is all `t4` (`match_t4=24`, `fill_t4=28`, `t0=0`), leaving the `t0` half unresolved and tying the problem to the bridge's provisional subslot lifetime. Splitting missing source matches by tag shows `t0` still has valid pre-buffer source candidates (`pix0=28`, `pix1=56`, `7n=28`) even though the captured-pair candidate recovers none of it; the data is present before 8J/8L but is not surviving the temporary write phase. A `t0`-only cross-lane candidate, a `t0`-current-ROM candidate, a `t0`-7N candidate, a `t0`-previous-captured-subslot candidate, a `t0`-next-captured-subslot candidate, a `t0`-parallel-ROM-pair candidate, and a `t0`-other-side candidate all tie the base captured-pair candidate (`nonzero=48`, `d1_match=24`, `fills_bridge_missing=28`), so the unresolved `t0` half is not fixed by conditional lane reversal, current ROM data at bridge-write time, substituting the schematic 7N output, using an immediately adjacent captured subslot, substituting the parallel ROM pair for `t0`, or selecting the opposite side only for `t0`. Splitting captured 8K/8M control by `t0/t4` is proportional (`t0_8k s0/s2=12/72`, `t4_8k=4/24`, `t0_8m s1/s2/s3=12/48/24`, `t4_8m=4/16/8`), rejecting a distinct `t0`-only local select/control state. A previous-subslot captured candidate ties the normal captured-pair candidate (`nonzero=48`, `d1_match=24`, `fills_bridge_missing=28`) and does not recover additional missing pixels, while a next-subslot candidate is worse (`nonzero=32`, `d1_match=16`, `fills_bridge_missing=16`), so simple one-subslot early/late pixel holds are not enough. A captured parallel-ROM-pair candidate also ties the normal captured candidate (`nonzero=48`, `d1_match=24`, `fills_bridge_missing=28`), so simply substituting the Sheet 4A parallel pixel pair for the compatibility byte pair is not enough either. The p3 raw mode histogram now shows the current provisional LS194 mode is always raw bin 3 (`b3=992`), while the Sheet3B-NIB plus LS86-FLIP candidate splits into raw bins `b2=736` and `b3=256`; using the corrected latched 6H `/MATCH` input into 10E barely changes that (`b2=737`, `b3=255`). A parallel BSM-clocked LS194 chain driven from the 6H/Sheet3B/LS86 mode candidate is now non-driving; direct mode gives fewer missing-d1 matches (`ls194_direct=56`) than current LS194 (`84`), and inverted mode gives zero, so mode polarity alone is not the missing fix. This confirms the corrected control terms are changing mode intent, but the remaining problem is still the relationship between LS194/7N pixel sequencing, `BYTLOAD`/`LOF`, and the 8F/8K/8M write-side strobes. |
| `7N` | `74LS157` | `MBJ*`, `MBJF*`, `FLIP`, selected `MBJ*` | Flip/select mux for motion pixel bits | `PARTIAL` | Cached crop `sheet_4a_7n_mbj_flip_selector_crop.png` corrects the physical package order: pins 5/6/7 are `MBJ3/MBJ3F/MBJ3*`, pins 14/13/12 are `MBJ2/MBJ2F/MBJ2*`, pins 2/3/4 are `MBJ1/MBJ1F/MBJ1*`, and pins 11/10/9 are `MBJ0/MBJ0F/MBJ0*`. RTL logical vector order remains `mbj_from_7n[3:0]` and is not behaviour-driving until LS194 load/shift timing is verified. A parallel non-driving `u_7n_mbj_flip_ls86_candidate_select` uses the LS86/11F candidate `FLIP`; Icarus shows it does not improve missing-d1 coverage by itself (`7n_match=84`, `7n_ls86_match=84`), so the remaining p3/x6 issue is not solved by simply swapping the 7N select to the corrected FLIP candidate while LS194/LOF timing remains provisional. |

`VERIFY` 2026-07-03: Added a non-driving LS194 tap classifier for Q1/Q2 (`mbj_from_ls194_tap1/tap2`) while keeping `USE_SCHEMATIC_MOTION_BUFFER=0`. Icarus shows the x0+p3 h4/h6 proof window carries the corrected polarity on both taps (`h4 t1p0/t2p0=24/24`, `h6 t1p1/t2p1=16/16`) while the current Q3/Q0 path remains mixed; the 8F split is `bin0 t1p0/t1p1/t2p0/t2p1=12/8/12/8`, `bin3 t1p0/t1p1/t2p0/t2p1=12/8/12/8`. This rejects ROM bit grouping as the immediate cause and keeps the next focus on LS194 shift/tap timing into 7N and the 8K/8M write side.

`VERIFY` 2026-07-03: Added a non-driving 7N-style Q2/Q1 tap candidate (`mbj_from_7n_tap12_candidate`). On all missing d1 samples it scores only `88` matches versus current 7N/LS86-7N `84/84`, so directly selecting Q2/Q1 at 7N is not enough. The remaining issue is still a phase/lifetime problem between LS194 shifting and the 8K/8M write side, not a standalone 7N selector substitution.

`VERIFY` 2026-07-03: Added non-driving `mbj_from_7n_pin_order_candidate` to reconstruct the physical 7N LS157 package order from the corrected pin audit and reorder it back to logical `MBJ3..MBJ0`. Icarus passes and reports `Motion 7N pin-order candidate known=4096 equal=4096 missing_match=84`, exactly matching the existing `7n_match=84`. This proves the corrected audit row does not require a RTL behaviour change; keep the current logical vector order while continuing to trace LS194/`FLIP`/`LOF` timing.

`PARTIAL` 2026-07-03: Added non-driving RTL aliases for the Sheet 4A LS194 mode pins: `motion_ls194_s0_pin9_from_10d8_candidate_n` and `motion_ls194_s1_pin10_from_10c6_candidate_n`. These only rename the existing 10D pin 8 / 10C pin 6 candidate rails and keep the candidate vector order explicit as `{S1 pin 10, S0 pin 9}`. They do not feed the active LS194 path or visible motion output; `NIB LOAD`, `LOF`, and the rail polarity remain unresolved.

`DONE` 2026-07-03: The earlier non-driving `8K/8M` candidate muxes proved the selected `7N` MBJ bus as the Sheet 4B A-side input. After the 7F Q/`/Q` naming correction, the inactive schematic 8K/8M muxes themselves now use `mbj_from_7n` for both left and right buffer writes, matching the pin audit. Visible video remains on the compatibility path because `USE_SCHEMATIC_MOTION_BUFFER=0`.

`VERIFY` 2026-07-03: Superseding the old candidate-only render-write counters, Icarus after the active inactive-path 7N input correction reports p3 age-2 `actual_eq_7n=496/488` and representative trace `actual=5/5 cand7n=5/5`. The full inactive comparison still has `schematic_missing=168` and `value_mismatch=12`, so the 8K/8M A pins are now structurally correct but the write/read phase is not behaviour-ready.

### Control And Timing

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `1H`, `8F` | `74LS139` | `BYTLOAD`, `IV`, `IVDBH`, `MOHLO`, `MOHLI`, `MOHRI`, `MOHRO` | Decode motion hold/read/load controls | `PARTIAL` | Latest cached crop corrects the physical decode pins: `BYTLOAD` feeds the active-low enable pins, `1H` upper half uses `A=IV`, `B=0`, `Y1=MOHLO`, `Y0=MOHLI`, and `8F` lower half uses `A=IVDBH`, `B=IV`, `Y1=MOHRO`, `Y2=MOHRI`. RTL now maps this as `mohro=y1`, `mohri=y2`. Later 7F evidence corrects `IVDBH` to the 7F `/Q` side; the older small-window numbers in this row are retained as historical pre-7F-correction diagnostics. The cached `sheet_4a_ls194_nibload_to_decode_boundary_crop.png` shows the nearby LS194 control rails and the `BYTLOAD` label at the 1H/8F boundary, but does not trace the `BYTLOAD` source; keep `bytload_from_render_pending` provisional. Non-driving 8F enable candidates using the two nearby LS00 rails do not recover the p3 right-side window (`10c6_mohri=0`, `10d8_mohri=8` before the 7F correction; `10d8_mohri=361` after), so a simple "BYTLOAD is this LS00 mode rail" substitution is not enough. The temporary sources are now explicitly named `bytload_from_render_pending`, `iv_provisional_from_display_line_bank`, and `lof_provisional_from_render_pending` so the remaining shortcut is visible in code. RTL also names the phase split as `motion_object_scan_match_current` versus `motion_object_bridge_write_delayed`, documenting that the bridge still writes from the delayed temporary renderer phase rather than a schematic BYTLOAD pulse. Icarus passes with `USE_SCHEMATIC_MOTION_BUFFER=0`; after the 7F correction and 7N A-input correction, the p3 age-2 source probe has source data present and selected 8K/8M equal to 7N in their enabled windows, but the inactive buffer still has `schematic_missing=168` and `value_mismatch=12`. Earlier x0 and p3 hold diagnostics show fixed phase relationships to `BSM`, not random drift, and the remaining bad phase is still the `BYTLOAD`/`MOHRI`/counter-write lifetime against the temporary renderer. |

`VERIFY` 2026-07-03: Added cached crop `sheet_4a_1h_8f_bytload_decode_zoom.png` and corrected the pin audit for physical LS139 pins. `BYTLOAD` feeds the active-low enable pins of both decode halves (`1H` pin 15 and `8F` pin 1), not `1H` A select. `1H` uses the upper half with `A=IV`, `B=0`, `Y1=MOHLO`, and `Y0=MOHLI`; `8F` uses the lower half with `A=IVDBH`, `B=IV`, `Y1=MOHRO`, and `Y2=MOHRI`. No RTL behavior changed in this step; the current RTL remains a provisional/collapsed decode until `BYTLOAD` polarity and source timing are traced.

`VERIFY` 2026-07-03: Started the Step 2 load/shift timing-net table in the pin audit. Current boundary evidence is: `BYTLOAD` drives only the active-low decoder enables seen locally (`1H` pin 15 and `8F` pin 1), `NIB LOAD` enters the LS194 mode chain at `10D` pin 5 and is distinct from `BYTLOAD`, and `LOF` clocks `11F` pin 11 separately. This proves the local destinations but not sources, active polarity at the named net, or pulse/level timing, so no RTL behavior was changed.

`PARTIAL` 2026-07-03: Added non-driving RTL candidate `u_1h_moh_left_pin_candidate_decode` for the physically audited `1H` half: `BYTLOAD` on active-low enable, `B=0`, `A=IV`. The active/collapsed `u_1h_moh_left_decode` remains unchanged, so this does not alter visible output or the current inactive motion-buffer path. It exists only to make future `BYTLOAD`/`IV` timing comparisons pin-honest.

`VERIFY` 2026-07-03: Tightened the Step 2 timing-net audit without changing RTL. Existing diagnostics already tested the tempting Sheet 3B aliases as motion substitutes: `pf_bytload_from_10d` scores only `8/992` in the p3 age-2 right-side window and has no h4 write overlap, while `pf_nibload_from_3f` scores `0/992` in the same p3 window and only partial h6 proof overlap. `LOF` also remains untraced because simple `B4H`/`BSM` clock probes did not recover the 11F candidate. Keep `BYTLOAD`, `NIB LOAD`, and `LOF` separate and unresolved at source level; the Sheet 3B names remain comparison candidates only.

`VERIFY` 2026-07-03: Added sim-only 1H pin-candidate counters. Icarus passes and reports `Motion buffer 1H candidate phase bsm_ll=38910 bsm_rl=38848 render_ll=0 render_rl=0 mismatch_ll=38848 mismatch_rl=39872`. This confirms the physical `1H` decode shape is now measurable, but the current provisional `BYTLOAD` lifetime is wrong for driving it: the candidate is active across broad BSM windows, never during the temporary render-write window, and diverges strongly from the active collapsed decode. Keep `u_1h_moh_left_pin_candidate_decode` non-driving.

`VERIFY` 2026-07-03: Extended the sim-only 1H enable matrix across the simple candidates `BYTLOAD`, inverted `BYTLOAD`, Sheet 3B `pf_bytload`, inverted `pf_bytload`, `pf_nibload`, and inverted `pf_nibload`. Icarus passes and reports render `ll/rl` counts of `0/0`, `512/512`, `64/64`, `448/448`, `384/384`, and `128/128` respectively, while the active temporary render phase remains `render_ll=0 render_rl=1024`. This rejects a simple polarity flip or Sheet 3B alias as a pin-honest 1H replacement and keeps the next work on tracing the real Sheet 4A `BYTLOAD` source/lifetime.

`VERIFY` 2026-07-03: Added cached crop `sheet_4a_bytload_1h_8f_extended_trace_crop.png` using `.venv-pillow` from the full Sheet 4A render. The wider view keeps 6N/8R, the LS194s, 1H/8F, 7F, and 11F in frame and confirms the same boundary conclusion: `BYTLOAD` appears as a named rail entering the LS139 decode enables, while the nearby 10C/10D gates are the distinct `NIB LOAD`/`MATCH`/`FLIP` LS194 mode chain. No RTL behavior changed.

| `11F` | `74LS74` | `FLIPM`, `LOF`, `FLIP` | Flip/load timing latch | `PARTIAL` | Cached Sheet 4A crops confirm `FLIPM` feeds 11F `D`, `LOF` clocks the latch, and the outputs are `FLIP` and its complement. The wider cached `sheet_4a_11f_lof_wide_crop.png` shows `LOF` as a named clock input into 11F and shows the nearby `BYTLOAD` line feeding the local 1H/8F decode area, but it does not show a local connection tying `LOF` to `BYTLOAD`. OCR on the cached full Sheet 4A render did not find another `LOF` label. RTL therefore keeps `u_11f_flip_latch` non-driving with `LOF` now named as `lof_provisional_from_render_pending` plus `lof_rise_provisional_from_render_pending`, and the source stays `VERIFY`; do not infer or drive a `LOF=BYTLOAD` schematic result from the local crop. RTL also adds a non-driving `u_11f_flip_ls86_candidate_latch` that uses the schematic LS86 `FLIPM` candidate with the same provisional `LOF` clock, so the remaining `FLIPM` and `LOF` risks can be measured separately. Icarus shows this separation clearly at the p3 age-2 point: current provisional 11F `FLIP` is saturated (`flip_hi=992`), while the LS86-FLIPM 11F candidate is low (`flip_hi=0`). With the Sheet3B `NIB LOAD` candidate, the LS194 mode-bus high counts swap from current `10c6=256, 10d8=992` to LS86-FLIP candidate `10c6=992, 10d8=256`; useful evidence, but still non-driving because `LOF` is untraced. |
| `7F` | `74LS74` | `IV`, `B8H`, `IVDSH`, `IVDBH` | Video timing latch | `PARTIAL` | Sheet 4A crops confirm the latch clocks from `B8H` and captures `IV`. The enlarged `sheet_4a_7f_8f_iv_labels_zoom.png` crop fixes the local net naming: Q pin 5 is `IVDSH`, `/Q` pin 6 is `IVDBH`, and 8F pin 2 takes `IVDBH`. RTL now maps `ivdbh_from_7f` from `q_n` and `ivdsh_from_7f` from `q`; this remains non-visible while `USE_SCHEMATIC_MOTION_BUFFER=0`. Icarus passes and shows the expected non-driving improvement: p3 age-2 8M MBJ selection rises from `8/992` to `488/992`, all-clock 8M write-side MBJ selection rises to about half of each pair (`p0=504 p1=504 p2=504 p3=496`), and inactive `schematic_missing` improves only from `172` to `168`. The exact upstream `IV` source and the broader object-scan/write phase are still provisional, so this is a pin-correctness fix, not evidence to enable visible schematic motion. Sheet 6B `INY` remains a negative-check source only; after the Q/`/Q` correction it trivially opens the tested p3 window (`selected1_nz=992`) because it is not the Sheet 4A IV net, so it must not be promoted. |
| Gates around `MATCH`, `M14H`, `FLIPM`, `FLIPN` | `74LS00`, `74LS04`, `74LS08`, etc. | `MATCH`, `FLIP`, `M14H` | Pixel/object enable and flip controls | `PARTIAL` | Cached Sheet 4A crop `sheet_4a_6h_flipm_m14h_crop.png` verifies `8H` latches `MOD7` to `MOFLIP` and `MOD6..0` to `MOPA11..5`, while the visible LS86 gates form `FLIPM` from `COCKTAIL` xor `MOFLIP` and `M14H` from `FLIPM` xor `/4H`. The wider cached crop `sheet_4a_6h_left_boundary_crop.png` corrects the `6H` boundary: `6H` latches `COCKTAIL`, `/MATCH`, and `MOPA4..1`, not `MOFLIP`; RTL now names `cocktail_latched_from_6h`, `match_n_latched_from_6h`, and `mopa_low_latched_from_6h` as non-driving schematic boundary signals. RTL keeps the old provisional `flipm`/`m14h` aliases non-driving and adds non-driving schematic candidates `motion_flipm_from_10p_candidate` and `motion_m14h_from_10p_candidate` using latched `COCKTAIL` and latched `MOFLIP`. Icarus passes and shows why this matters for the p3/x6 issue: old provisional `flipm` is saturated at the failing p3 age-2 point (`flipm_hi=992`, `flip_hi=992`), while the schematic LS86 `FLIPM` candidate is low for all of those samples and `M14H` is split (`flipm_hi=0`, `m14h_hi=480`). The corrected 6H boundary counter at the same p3 point is also sane for upright test state (`cocktail_hi=0`, `match_n_hi=2`). This is strong `VERIFY` evidence that the current `flipm = moflip || match` shortcut is wrong, but it remains non-driving until LOF and LS194 timing are traced together. |

## Sheet 4B: Motion Object Buffers / Video

### Left/Right Motion Object Buffers

Focused harness note:
- `sim/motion_buffer_tb.sv` now directly verifies the local 8K/8M `74LS157`
  behavior used by Sheet 4B: select low chooses `MBJ`, select high chooses
  feedback, and disabled output is low in the local LS157 model. It also
  verifies those selected 8K/8M values through the 8J/8L RAMs, 9T latch, and
  9H selector. The same focused harness still verifies 8J/8L WE/CS/OE
  behavior, including OE/write separation, 9T latch hold timing, and 9H
  left/right selection.

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| `7J`, `7K`, `7L`, `7M` | `74LS163A` | `MOHL*`, `MOHR*`, `MOD*`, outputs to `93422` address | Motion buffer address counters | `PARTIAL` | RTL now instantiates four `cloak_74ls163` counters named for `7J/7K/7L/7M`. Upper `7J/7K` load/clear now use decoded `MOHLO/MOHRO`; lower `7L/7M` load/clear use decoded `MOHLI/MOHRI`; all four clock from the named `BSM` phase, with count enables tied active to match the pulled-up LS163 enable pins. Sheet 4B crop confirms the physical parallel load inputs are `MOD0..MOD7` on both counter pairs; the current RTL load values are still provisional two-pixel X addresses from the temporary renderer, with their validity boundary named as `motion_buffer_load_addr_valid = render_pending`. A direct non-driving trial of `mod_render_x` load data was reverted after smoke worsened the inactive path (`schematic_missing` rose from 32 to 172), showing that the MOD source itself is not phase-coherent yet in the current phase-expanded model. New render-write address diagnostics show the temporary bridge write addresses still match their provisional load values (`known=1024 expected=1024 adjacent=1024`), but the inactive schematic counters do not yet line up with those load/write addresses (`counter known=1024 exact=0 prev=0 next=0 cross=0`). After correcting 1H/8F output indices, render-phase load activity moved to the right-side load net (`left_load=0 right_load=1024`, with `left_clear=504 right_clear=8`), confirming the previous left-load-only result was partly an LS139 output-index error. A later non-driving current-scan bridge trial, using the current object-scan sample instead of delayed `render_pending`, was rejected because it introduced `value_mismatch=48` and worsened the single-address probe (`d1_missing=175` versus the prior `167`). This remains phase-incoherent because the right-side mux still rarely selects MBJ during render. |
| `8J`, `8L` | `93422` | Address `A0..A7`, data `D1..D4`, outputs `O1..O4`, `WE`, `CS`, `OE`, `B5M` | Two motion-object buffer RAMs | `PARTIAL` | PDF audit verifies both Sheet 4B `93422` symbols have one `A0..A7` address bus, data pins `D1..D4`, output pins `O1..O4`, `WE` pin 20 driven by `B5M`, and `CS1`, `CS2`, `OE` pins 19/17/18 tied active through the grounded rail/pull network. RTL now names those pin-level controls as `motion_buffer_we_n_from_8j_8l = !bsm`, with `bsm` still explicitly documented as the legacy RTL name/provisional `ce_5m` timing alias for the confirmed Sheet 4B `B5M` rail until the upstream `E5M` source/phase is traced, `motion_buffer_cs1_n_from_8j_8l = 0`, `motion_buffer_cs2_n_from_8j_8l = 0`, and `motion_buffer_oe_n_from_8j_8l = 0`, but still wraps each schematic RAM in a temporary two-bank FPGA bridge so the inactive path can preserve the current renderer's read/write line lifetime. Icarus control-pin evidence confirms the named CS/OE pins remain active for every sampled cycle: `known=78781 cs_oe_active=78781 cs_oe_inactive=0`. The focused `sim/motion_buffer_tb.sv` harness now also verifies that a disabled CS prevents writes and that disabled OE/CS outputs latch as inactive `4'hf` through `9T/9H`. This bridge is not 1:1: it has separate read/write addresses, writes on `render_pending || clear`, clears through the visible raster address, and selects a line bank with `display_line_bank`; the PDF shows none of those as `93422` pins. Smoke-test evidence quantifies the mismatch: `schematic_bsm=78781 bridge=63983 overlap=63983 bridge_only=0 schematic_only=14798 blank=14798 render=0 visible=0`. New 9T/WE phase counters confirm the named schematic latch clock and 93422 WE are currently the same legacy `bsm`/physical `B5M` phase in RTL (`9T clk=78781 we_overlap=78781`), while only the temporary bridge write subset overlaps it (`bridge_overlap=63983`, `blank=19389 visible=59392`). All bridge writes occur during the current `bsm` alias, and the skipped schematic-only phases are blanking rather than visible/render phases, so this diagnostic does not justify switching the bridge to write on every `bsm`. The inactive bridge render-write gate now also requires the legacy `bsm` alias, matching the 93422 `B5M` WE pin; smoke passes with `USE_SCHEMATIC_MOTION_BUFFER=0`, but the inactive comparison worsens (`schematic_missing=172`, `lb_nonzero=20`) because the previous bridge was accepting non-`bsm` x0 writes that the schematic RAM would not write. Render writes use loaded two-pixel pair addresses directly because the synchronous FPGA RAM otherwise sampled stale LS163 outputs on the same `bsm` edge; harness address compare improved from `expected=0 adjacent=0` to `expected=1024 adjacent=1024`. The temporary renderer advances every core clock, so inactive 93422 render writes sample every `render_pending` cycle rather than the final schematic object-scan write phase. The latest handoff probe makes that mismatch concrete: write coordinates are delayed/captured correctly, but MBJ data is from the current ROM pair, so the 93422 bridge receives mismatched address/data phase. A captured-pair candidate improves but does not solve the inactive comparison (`fills_bridge_missing=28`, `d1_missing=144`); reading that captured candidate from the opposite line bank gives the same result (`d1_match=24`, `fills_bridge_missing=28`), rejecting a simple read-bank polarity fix, and side-swapping the captured candidate scores zero (`d1_match=0`), rejecting a simple 9H left/right side swap. A captured-pair candidate that also honors the current `IVDBH` enable is weaker (`nonzero=24`, `d1_match=12`, `d1_missing=168`, `fills_bridge_missing=4`), so current `IVDBH` phase blocks half of the already-partial captured-pixel recovery and confirms that data capture must be solved together with 8K/8M enable/control timing. The complementary disabled-phase candidate scores the same direct d1 matches (`nonzero=24`, `d1_match=12`, `d1_missing=168`) with more fills of currently blank schematic pixels (`fills_bridge_missing=24`), which rejects a simple `IVDBH` polarity flip as a complete fix. A direct inactive RTL trial feeding 8K/8M from captured MBJ was reverted because it introduced `value_mismatch=48` without reducing `schematic_missing=112`; keep this as evidence that captured pixel data must be paired with the correct control/read phase, not applied alone. Corrected 8K/8M pin mapping changes the current inactive signature to `compat_d1_nonzero=192 schematic_missing=112`, showing the local 93422 RAM wrapper is still receiving phase-incoherent data/control from the temporary renderer. Visible pixels still use the simplified `sprite_line` arrays. |
| `8K`, `8M` | `74LS157` | `MBJ*`, `LB*`, `MOHLI/MOHRI`, `IVDBH`, outputs to buffer data | Selects data written into motion buffers | `PARTIAL` | Sheet 4B crop verifies the vector convention used by RTL: `[3:0]` is physical `D4..D1` / `LBx3..LBx0` / `MBIT3..MBIT0`; LS157 outputs route as pin 9 -> `D4`, pin 12 -> `D3`, pin 7 -> `D2`, pin 4 -> `D1` on both `8K -> 8J` and `8M -> 8L`. A later crop re-check corrected the control pins: 8K pin 1 select is active-low `MOHLI`, 8M pin 1 select is active-low `MOHRI`, and both pin 15 enables are `IVDBH`, not tied active and not `IVDSH/IVDBH` selects. RTL now names this as `motion_buffer_8k_select_from_mohli_n`, `motion_buffer_8m_select_from_mohri_n`, and `motion_buffer_8k/8m_enable_n_from_ivdbh`. Icarus passes with `USE_SCHEMATIC_MOTION_BUFFER=0`, but the inactive schematic-buffer comparison worsens after the pin correction (`compat_d1_nonzero=192 schematic_missing=128`, `data_nonzero=496`, `other_window_match=0`, selected d1 matches only `64`). Render-control counters explain why: `IVDBH` enables both muxes about half the render samples (`8k_en=512 8k_dis=511`, same for 8M), but the current `render_pending` phase almost never coincides with MBJ selection (`8k_sel_mbj=0 8k_sel_fb=1023`, `8m_sel_mbj=8 8m_sel_fb=1015`). A one-cycle-prewrite probe is asymmetric: previous-cycle 8K mostly selects MBJ (`8k_sel_mbj=1015 8k_sel_fb=8`), while previous-cycle 8M still selects feedback (`8m_sel_mbj=0 8m_sel_fb=1023`); additional d2/d3 history probes also select feedback for both sides (`pre2 8k_fb=1023 8m_fb=1023`, `pre3 8k_fb=1023 8m_fb=1023`), so the 8M miss is not a simple two- or three-cycle prewrite offset. After correcting 1H/8F decode outputs, render 8K is aligned (`8k_sel_mbj=1023`) but 8M remains mostly feedback (`8m_sel_mbj=8`). Non-driving candidate probes show neighboring `MOHRO` and inverted provisional `IV` both make 8M select MBJ for about half of `ce_5m`-sampled render samples (`render_mbj=504 render_fb=519`), and a render-pair classifier shows this in the sampled view as `render_pair=3` (`MOHRI p3=8`, `MOHRO p3=504`). Later all-clock scan/write counters show that the temporary bridge does exercise all four pair/x slots, so the `t4` render-tag result is a diagnostic sampling alias, not full-rate bridge behavior. New full-clock write-side select counters confirm the asymmetry at the actual bridge-write point: 8K selects MBJ for every write pair (`p0=1023 p1=1023 p2=1023 p3=1024`, feedback zero), while 8M selects MBJ only rarely (`p0=8 p1=8 p2=8 p3=16`) and feedback for the rest (`p0=1015 p1=1015 p2=1015 p3=1008`). A raw right-buffer candidate that only substitutes `MOHRO` for the 8M write select does not improve d1 coverage (`nonzero=0 d1_match=0 d1_missing=192 fills_bridge_missing=0`), and a candidate that lets 8M follow the proven 8K select window also scores zero direct recovery (`nonzero=0 d1_match=0 d1_missing=192 fills_bridge_missing=0`) with only tiny shifted matches (`m1=4`, `p3=4`). Captured-pair write-select classification shows that the limited direct d1 matches are all right-side writes tagged as 8M feedback (`8m_fb=24`), while candidate fills of currently blank schematic pixels split between left 8K MBJ (`8k_mbj=16`) and right 8M feedback (`8m_fb=12`); this is not evidence for a clean 8M MBJ timing fix. A strict captured-pixel candidate gated by both current `IVDBH` enable and active MBJ select is worse again (`nonzero=12`, `d1_match=0`, `d1_missing=180`, `fills_bridge_missing=4`), confirming that the current local 8K/8M control phase rejects the useful captured pixels. Capturing those 8K/8M control bits at object-scan time and applying them at bridge-write time gives the same result (`nonzero=12`, `d1_match=0`, `fills_bridge_missing=4`), so a one-register control/data handoff does not solve the phase. Missing-d1 classification by captured controls shows 8K concentrated in disabled/MBJ (`s2=96`) plus enabled/MBJ (`s0=16`), while 8M is split across enabled/feedback (`s1=16`), disabled/MBJ (`s2=64`), and disabled/feedback (`s3=32`); the holes are therefore not confined to one local select state. Cross-lane captured data steering, writing captured pixel1 to left and captured pixel0 to right, scores the same as the normal captured-pair candidate (`nonzero=48`, `d1_match=24`, `d1_missing=144`, `fills_bridge_missing=28`), so simple 8K/8M lane reversal is also not the missing piece. New `t0` invalid/default metadata tracing shows the x0-held candidate covers only `24/112` of those samples (`x0held=24/24`), while the unreached remainder still carries source evidence (`pix0=24 pix1=64 7n=24`) in the same h0/h2/h3/h6/h7 windows; this points to a missing x0/current write-side lifetime rather than a readback, lane, or selector polarity fix. A follow-up unreached split rejects the existing stored t0-current/prev/next/7N/parallel/cross shadow candidates for that remainder (`0/0` for all six), proving the useful pixels exist only in the live capture sample and are not being written into any current shadow window. Live-gate tracing then shows those 88 unreached samples all occur with capture valid and `pending_x=6`, selected write addresses equal to the display address, but `motion_buffer_render_write=0`, write-bank match `0`, and selected write-hit `0`; this rejects using the live p6 sample directly and points back to capturing the earlier write-bank phase. Pair-3 hold tracing also rejects the current p3 hold as the source for this remainder: it is valid for all 88 samples, but selected address hit is `0`, age2 is `0`, and age15 dominates (`56`), so the retained p3 state is stale/misaligned for the t0 holes. A non-driving p6/no-BSM shadow write candidate using the bridge load addresses also scores `0/0` on the unreached t0 subset, and reading that same candidate from the opposite bank still scores `0/0`, rejecting both a simple "write the p6 no-BSM phase" substitute and a pure bank-selection explanation for that substitute. Therefore the remaining miss is not an isolated 8M select polarity/window, lane swap, captured-control handoff, p3 hold, p6 no-BSM write, bank-only issue, or small address-offset issue; the right-side write lifetime, bank/read phase, and upstream object-scan phase must be corrected together. Treat this as `VERIFY` evidence that the structural pin mapping is now closer to Sheet 4B, while upstream `MOHRI/IVDBH/IV` timing is not phase-coherent with the temporary renderer. |
| `9T` | `74LS273` | `LB00..LB03`, `LB10..LB13`, buffer outputs | Latches buffer outputs into `LB` buses | `PARTIAL` | PDF audit verifies Sheet 4B `9T` clocks from `B5M`, latches the `8J/8L` `O1..O4` outputs into `LB00..LB03` and `LB10..LB13`, and has clear held inactive. RTL now names these controls as `motion_buffer_9t_clk_en_from_bsm = bsm` and `motion_buffer_9t_clear_n_from_sheet = 1`, using the same legacy `bsm`/physical `B5M` latch enable for the bridge and single-address probe; Icarus smoke after this naming-only change passed with unchanged motion-buffer diagnostics. The enlarged `9T/9H` crop confirms the RTL latch packing `{lb1_from_8l, lb0_from_8j}` with `lb0_from_9t = [3:0]` and `lb1_from_9t = [7:4]` preserves `LBx3..LBx0` bit order. RTL instantiates `u_9t_line_buffer_latch` with `clk_en = bsm`, matching the named latch phase. The focused `sim/motion_buffer_tb.sv` harness now verifies both that changing the 93422 read address does not change `9H` output until the next `9T` latch edge and that a same-edge write/latch keeps the old RAM output until a later latch in the current synchronous FPGA model. Status remains `PARTIAL` because the data feeding `9T` still comes from the temporary two-bank bridge rather than a single-address schematic `93422` path, and its outputs are not behaviour-driving. |
| `9H` | `74LS157` | `LB*`, outputs `MBIT0..MBIT3`, `VDBH` | Selects final motion bits | `PARTIAL` | PDF audit verifies Sheet 4B `9H` is the `74LS157` final motion-bit selector: `LB03/LB02/LB01/LB00` are its A inputs, `LB13/LB12/LB11/LB10` are its B inputs, `VDBH` drives select pin 1, enable is tied active, and outputs are `MBIT3..MBIT0`. RTL now names the selector as `motion_buffer_9h_select_from_vdbh` and uses it for both the bridge `9H` and single-address probe `9H`, preserving the existing polarity; Icarus smoke after this naming-only change passed with unchanged motion-buffer diagnostics. Visible video remains on compatibility `mbit = lb_display` after the phase-2 schematic-buffer MiSTer diagnostic caused full-height vertical stripe columns. The failed visible test used `USE_SCHEMATIC_MOTION_BUFFER=1`; keep `USE_SCHEMATIC_MOTION_BUFFER=0` until the upstream `8J/8L` read/write phase is coherent. Current main `cloak_core_tb` diagnostics after the non-driving BSM-gated bridge are still inactive-only: `compat_d1_nonzero=192 schematic_missing=172 value_mismatch=0`, with the remaining miss attributed to upstream `BYTLOAD/MOHRI/IVDBH/IV` phase coherence rather than 9H polarity. Captured-pair selector-phase candidates reinforce that conclusion: using `B2H` for the captured left/right read side gives no d1 matches (`d1_match=0`), and using `B4H` ties the direct matches (`d1_match=24`) but loses coverage versus current `B1H` (`nonzero=24` and `fills_bridge_missing=12` versus `nonzero=48` and `fills_bridge_missing=28`), so there is no evidence to switch 9H away from the schematic `VDBH/B1H` timing. |

`VERIFY` 2026-07-03: Added non-driving selected load-address classifiers for the unreached `t0` p6/no-BSM candidate while keeping `USE_SCHEMATIC_MOTION_BUFFER=0`. Icarus first reports no selected load-address hits at the even two-pixel offsets `-4/-2/0/+2/+4` (`m4/m2/z/p2/p4=0`), and the exact delta histogram then shows the candidate is spread across odd/large deltas (`+3=16`, `+5=16`, `-33=16`, `-31=8`, `-29=8`, `-27=8`, `-1=16`). That rejects a simple even two-pixel address slip while preserving the evidence that p6/no-BSM is phase-structured and still tied to right-side write lifetime, bank/read phase, and upstream object-scan phase together.

`VERIFY` 2026-07-03: Split the exact p6/no-BSM load deltas by `B1H`, read bank, and display hmod. The read-bank counts are balanced for every delta, while hmod is locked (`+3` at h3, `+5` at h2, `-33` at h0/h7, `-31` at h6, `-29` at h3, `-27` at h2, `-1` at h0) and `B1H` follows those hphase groups. This rejects a pure read-bank selector explanation and keeps the remaining fault on horizontal subphase/write-address lifetime rather than 9H or 93422 bank polarity alone.

`VERIFY` 2026-07-03: Checked the same p6/no-BSM shadow memory at its selected load address instead of the displayed `hcnt`. It is still empty for the unreached `t0` subset (`load_nonzero=0`, `load_match=0`, `other_bank=0/0`), so the failed p6/no-BSM candidate is not simply stored at the displaced load address. Keep tracing the earlier write-side lifetime rather than reading this shadow path with a different address.

`VERIFY` 2026-07-03: Compared the unreached `t0` subset against the existing non-driving x0+p3 h4/h6 corrected source candidate. It covers all unreached samples with no value mismatch (`nonzero=88`, `match=88`, `mismatch=0`, hmods `h0=24 h2=24 h3=24 h6=8 h7=8`). This confirms the data needed for the remaining hole is represented by the corrected source/lane timing model, while the p6/no-BSM memory path is empty; the next work should move from substitute reads toward making the source/lane timing structurally trustworthy.

`VERIFY` 2026-07-03: Split those unreached `t0` x0+p3 h4/h6 matches by source. All 88 come from the base x0+p3 lane-source candidate (`lane_nz=88`, `lane_match=88`, `from_lane=88`, `from_h4=0`, `from_h6=0`), so this subset does not depend on the later h4/h6 override. The next bounded target is therefore the base lane-source timing and metadata/lifetime that feeds 8K/8M, not the h4/h6 correction itself.

`VERIFY` 2026-07-03: Split the base x0+p3 lane-source matches into stored base versus live fill. The unreached `t0` subset is entirely live-fill (`lane_base=0`, `lane_fill=88`), meaning the needed pixels are present in the live capture/source sample but are not being preserved into the stored x0+p3 metadata window. This makes the next step a lifetime/registering problem for the `t0` lane-source handoff into 8K/8M, still non-driving.

`PARTIAL` 2026-07-03: Added non-driving RTL registers named `motion_object_lane_live_fill_*` to hold the raw scan-pixel pair and coordinates used by the live-fill proof. These registers do not feed 8K/8M, 8J/8L, 9T, 9H, or visible video. Icarus confirms the held RTL live-fill signal covers the unreached `t0` subset (`valid=88`, `lane_match=88`, `pix0=24`, `pix1=64`), matching the prior testbench-only live-fill evidence and making the lifetime handoff inspectable in RTL.

`VERIFY` 2026-07-03: Added audit-only counters for the held RTL live-fill source tags. The same 88 unreached `t0` samples are all sourced from held scan `pair3/x6` with `sx[2:0]=0` (`pair3=88`, `x6=88`, `sx0=88`; all other pair/x/sx bins zero). This confirms the "x0+p3" proof is a display/read-lane recovery of a live `pair3/x6` source sample, not evidence to relabel the RTL source as x0. The next non-driving step should preserve this held `pair3/x6` source into a candidate `t0`/lane metadata lifetime and compare it against 8K/8M write/read phase before any visible selector is changed.

`VERIFY` 2026-07-03: Added a testbench-only banked shadow RAM that writes the held RTL live-fill pixels at the current bridge render-write addresses and reads them back through the normal left/right read-bank side selection. The unreached `t0` subset still reads empty (`shadow nonzero=0`, `match=0`), while the direct held source remains complete (`valid=88`, `lane_match=88`). This rejects a simple "store held pair3/x6 at the current bridge address" lifetime fix; the remaining issue is the address/read-lane displacement already shown by the exact deltas, not data availability.

`VERIFY` 2026-07-03: Added selected-side `-8..+8` offset bins for the testbench-only RTL live-fill shadow. The shadow is nearby but displaced: nonzero bins are `-3=32`, `-1=8`, `+1=24`, `+3=24`; exact matches are only `-3=32` and `+1=24`. This explains why same-address storage is empty and shows that a single fixed offset is not enough to recover the 88 samples; the remaining 32 are likely split by side/lane or read-phase selection rather than missing source pixels.

`VERIFY` 2026-07-03: Split the live-fill shadow offset hits by display hmod and B1H side. The `-3` matches are `h0=24`, `h7=8` (`b1h0=24`, `b1h1=8`), the `+1` matches are `h3=24` (`b1h1=24`), and the still-unmatched 32 are exactly `h2=24`, `h6=8`, all `b1h0`. This narrows the remaining unreached subset to the low-B1H read lane; next trace should test the opposite-side/right-lane read for those h2/h6 samples before changing any behaviour-driving selector.

`VERIFY` 2026-07-03: Tested the still-unmatched low-B1H `h2/h6` subset against the opposite-side RTL live-fill shadow over `-8..+8`. All 32 are recovered there: nonzero/match bins are `-2=8`, `+2=24`, with no other bins hit. This completes the non-driving classification of the original 88 live-fill holes: selected-side `-3` covers 32, selected-side `+1` covers 24, and opposite-side `-2/+2` covers the remaining 32. The data source is sound; the schematic-visible work must now model the read-lane/address steering, not invent a new pixel source.

`VERIFY` 2026-07-03: Collapsed the classified offsets into one testbench-only mapped recovery candidate: selected-side `h0/h7 -> -3`, selected-side `h3 -> +1`, opposite-side `h2 -> +2`, and opposite-side `h6 -> -2`. Icarus reports full coverage for the unreached `t0` live-fill subset (`nonzero=88`, `match=88`, `mismatch=0`). This is still non-driving, but it proves the remaining Sheet 4B problem is a deterministic read-lane/address steering map around 8J/8L/9T/9H, not random corruption or missing source pixels.

`VERIFY` 2026-07-03: Re-read the RTL 9T/9H implementation after the mapped recovery proof. `9T` only latches `{lb1_from_8l, lb0_from_8j}` on the named BSM enable, and `9H` only selects `lb0_from_9t` versus `lb1_from_9t` with `motion_buffer_9h_select_from_vdbh`. The mapped recovery requires hmod-dependent address and side steering before or at the 8J/8L read/latch boundary; it is not evidence to invert 9H, replace 9H with B2H/B4H, or change a visible selector.

`PARTIAL` 2026-07-04: Shifted the Sheet 4A/4B work from broad diagnostics to an explicit graphics-recovery candidate flow while keeping visible video on the compatibility path. RTL now exposes `USE_MOTION_COMPAT=1`, `USE_MOTION_SCHEMATIC_SOURCE=0`, and `USE_MOTION_SCHEMATIC_BUFFER=0`; the old `USE_SCHEMATIC_MOTION_BUFFER` name remains an alias for the schematic-buffer switch. The current named `mbit_schematic_candidate` is the phase-adjusted true schematic-buffer output, not a behaviour-driving path. The Icarus harness now prints one compact candidate score for the best-known non-driving `x0+p3 h4/h6 corrected` schematic-informed bridge so future work can stop on Outcome A/B/C instead of adding unbounded counters. Smoke passed and scored that bridge against the d1 compatibility window as `compat nonzero pixels=192`, `candidate nonzero pixels=192`, `missing pixels=0`, `wrong value pixels=0`, `best delay=d1`; this is strong evidence for a testable schematic-informed bridge candidate, but not yet a true Sheet 4B implementation.

`PARTIAL` 2026-07-04: Lifted the deterministic live-fill read-lane/address map into disabled RTL as `mbit_schematic_bridge_candidate`, controlled by `USE_MOTION_SCHEMATIC_BRIDGE_CANDIDATE=0`. This path writes the held `motion_object_lane_live_fill_pixel0/1` values into separate left/right line banks at the existing bridge write addresses, then reads selected-side `h0/h7 -> -3`, selected-side `h3 -> +1`, opposite-side `h2 -> +2`, and opposite-side `h6 -> -2`. Visible output remains compatibility because `USE_MOTION_COMPAT=1`. Icarus passes, but the lifted RTL candidate scores only `candidate nonzero pixels=120`, `missing pixels=72`, `wrong value pixels=0` against the same `compat nonzero pixels=192` d1 window. This is not ready for MiSTer testing; the remaining blocker is that the full-scoring testbench bridge also needs the stored x0+p3 and h4/h6 source overrides, not only the live-fill map.

`VERIFY` 2026-07-04: Added disabled RTL x0/p3 hold registers and x0+p3 bridge banks ahead of the live-fill map. Icarus still scores the RTL bridge at `candidate nonzero pixels=120`, `missing pixels=72`, `wrong value pixels=0`; the testbench-only `x0+p3 h4/h6 corrected` bridge remains `192/0/0`. This rejects the first simple RTL lift of the stored x0+p3 writeback. The exact blocker is now the testbench bridge lifetime/source selection around the x0/p3 held writes and h4/h6 override, not the read-side live-fill map alone.

`VERIFY` 2026-07-04: Classified the 72-pixel gap between the full-scoring testbench-only bridge and the disabled RTL lift. Icarus passes and shows every missing sample has the testbench bridge matching `mbit_compat_d1_tb` while both RTL bridge sources are blank (`rtl_x0p3_blank=72`, `rtl_live_blank=72`). The missing class is:

| Count | h phase | tag | TB bridge source | RTL bridge source | x0/p3 state | Rule implication |
| --- | --- | --- | --- | --- | --- | --- |
| 24 | h1 | tag4 | lane-base lifetime | blank x0+p3 and blank live-fill | current metadata, not held | Preserve the stored lane-base write value one phase longer than the RTL lift. |
| 24 | h5 | tag4 | lane-base lifetime | blank x0+p3 and blank live-fill | current metadata, not held | Same lane-base lifetime rule on the opposite half of the hphase group. |
| 24 | h4 | tag0 | h4 current override | blank x0+p3 and blank live-fill | current metadata, not held | The h4 override must be applied as a write/lifetime source, not only as a testbench read-side correction. |

Plain-English rule before any third candidate: when the x0+p3/lane bridge value is otherwise blank, the schematic-informed bridge must keep the current lane-base write value alive through h1/h5 for tag4 samples, and must inject the current h4 override value for tag0 samples. The 72-pixel miss contains no held-meta cases (`meta_valid=0`), no lane-fill cases, and no h6 cases in this score gap, so the smallest next RTL candidate should implement only those two current-lifetime rules while staying disabled and non-visible.

`VERIFY` 2026-07-04: Added the smallest disabled RTL lifetime-rule candidate by storing the x0+p3 write tag beside the disabled bridge banks and using a blank-only fallback for the documented classes: h1/h5 tag4 lane-base lifetime and h4 tag0 current override. Icarus passes, but the disabled RTL score is unchanged (`candidate nonzero pixels=120`, `missing pixels=72`, `wrong value pixels=0`). This rejects the same-address stored live-fill/x0+p3 tag sidecar as the missing lifetime source. The rule classification still stands; the failed RTL lift shows the needed value is not present at the same selected read address/tag location used by the disabled bridge, so the next bounded trace must locate which address/side/bank holds those lane-base and h4 override values before another candidate is changed.

`VERIFY` 2026-07-04: Added a focused offset locator for only the 72 disabled-RTL lifetime misses. Icarus passes and keeps the RTL score unchanged at `120/192`, but the locator shows the expected values are nearby rather than same-address: selected-side live-fill matches only at `+1=24`; opposite-side live-fill matches at `0=24` and `+4=24`; selected-side x0+p3 has duplicate-value hits at `-3=24`, `+1=40`, and `+5=16`; opposite-side x0+p3 has hits at `-4=24`, `0=48`, `+2=16`, and `+4=24`. This confirms the failed same-address fallback was aimed at the wrong read location. Because x0+p3 has duplicate hits, the next bounded diagnostic should split these offsets by the previously classified source classes (`h1/h5 tag4 lane-base` versus `h4 tag0 override`) before changing the disabled RTL candidate again.

`VERIFY` 2026-07-04: Split the 72 lifetime-miss live-fill offset hits by source class. Icarus passes and gives a clean split: the h4 tag0 current override is selected-side live-fill at `+1=24`, while the h1/h5 tag4 lane-base class is only on the opposite side, split as same-address `0=24` and `+4=24`. Selected-side live-fill has no lane-base hits. This makes the next candidate rule more precise: h4 override should read selected live-fill at `hcnt+1`, and lane-base should read opposite live-fill, but the h1 versus h5 sub-split must be confirmed before coding the opposite-side `0/+4` choice.

`VERIFY` 2026-07-04: Split the lane-base class by hphase. Icarus passes and reports `h1_other_z=0`, `h1_other_p4=24`, `h5_other_z=24`, `h5_other_p4=0`. The precise disabled-candidate rule is now: if the normal x0+p3/live-fill bridge output is blank, use selected-side live-fill at `+1` for h4 override, opposite-side live-fill at `+4` for h1 lane-base, and opposite-side live-fill at `0` for h5 lane-base. This is still non-visible and must be re-scored before any behaviour-driving switch.

`VERIFY` 2026-07-04: Lifted only the proven side/offset lifetime rule into the disabled RTL bridge candidate: h4 uses selected-side live-fill at `+1`, h1 uses opposite-side live-fill at `+4`, and h5 uses opposite-side live-fill at `0`, only after the normal x0+p3 and mapped live-fill bridge outputs are blank. Icarus passes and the disabled RTL bridge now matches the testbench-only bridge score: `compat nonzero pixels=192`, `candidate nonzero pixels=192`, `missing pixels=0`, `wrong value pixels=0`. `USE_MOTION_SCHEMATIC_BRIDGE_CANDIDATE` remains `0`, `USE_SCHEMATIC_MOTION_BUFFER` remains `0`, and visible video still uses the compatibility path. This proves the previous 72-pixel blocker was a deterministic lifetime/read-lane side-offset rule, not wrong pixel values.

`VERIFY` 2026-07-04: Prepared the simulation-proven motion bridge as a controlled MiSTer-test candidate. The active video selector now gives `USE_MOTION_SCHEMATIC_BRIDGE_CANDIDATE` priority; setting it to `1` drives visible `mbit` from `mbit_schematic_bridge_candidate`, and setting it back to `0` restores the old `sprite_line0/1` compatibility path. `USE_SCHEMATIC_MOTION_BUFFER` / `USE_MOTION_SCHEMATIC_BUFFER` remains `0`. This candidate is a schematic-informed, compatibility-assisted bridge, not the fully 1:1 Sheet 4B 93422/9T/9H path: it still uses bridge banks, live-fill/x0+p3 lifetimes, and the proven side/offset rule rather than replacing the temporary renderer with the true schematic motion-buffer RAM timing. Icarus was run with the candidate disabled after selector reorder and enabled for the MiSTer-test setting; both runs passed, and the enabled run reports `compat nonzero pixels=192`, `candidate nonzero pixels=192`, `missing pixels=0`, `wrong value pixels=0`. MiSTer testing should check whether main-character/enemy sprite completeness improves, whether the prior vertical stripe regression stays gone, and whether new artifacts appear such as split sprites, horizontal firing lines near the top, wrong sprite side/offset, stale pixels, or flicker.

`VERIFY` 2026-07-04: MiSTer/Quartus test of the bridge candidate failed: with `USE_MOTION_SCHEMATIC_BRIDGE_CANDIDATE=1`, the main character was not displayed at all. This rejects the candidate as a safe visible replacement despite the narrow Icarus d1-window score of `192/192`; the proof window did not cover enough of the live gameplay motion-object lifetime. Restored `USE_MOTION_SCHEMATIC_BRIDGE_CANDIDATE=0`, leaving `USE_SCHEMATIC_MOTION_BUFFER=0`, so visible video returns to the old `sprite_line0/1` compatibility path. Treat the bridge candidate as non-driving evidence only until a broader live-sprite diagnostic explains why the player object disappears.

`VERIFY` 2026-07-04: Added a bounded player-object Icarus diagnostic over the seeded 8x16-style motion-object footprint (X window `24..47`, V window `15..39`) while keeping `USE_MOTION_SCHEMATIC_BRIDGE_CANDIDATE=0` and `USE_SCHEMATIC_MOTION_BUFFER=0`. This explains why the previous `192/192` candidate score was not representative: the bridge still matches the compatibility path at the old delayed timing (`bridge_match_d1=64`) but not at the actual visible timing (`bridge_match_now=24`, `bridge_missing_now=8`, `bridge_wrong_now=32`) inside the player footprint. The first missing visible pixel is at `h=32`, `v=24`, with compat `5`, bridge `0`, schematic `0`; the first-missing boundary classifier points to `8K/8M` input/data selection (`8k8m=8`) rather than ROM, LS194, 7N, 93422, 9T, or 9H. This reproduces/predicts the failed bridge-candidate class in simulation and stops further visible bridge testing until 8K/8M visible-timing data selection is fixed non-driving. The diagnostic still uses the synthetic seeded object and patterned motion ROMs, so it does not yet prove the original real-game player corruption against real motion RAM/ROM state.

`VERIFY` 2026-07-04: Split only the player-footprint visible-timing bridge failures by 8K/8M control/data state. Icarus passes and reports `total=40`, `select_feedback=40`, `feedback_nonzero=0`, `mux_output_nonzero=0`, with `enable_disabled=20`. Live `7N` is present for every failing sample (`live7n_nonzero=40`) and would match the visible compatibility pixel in `24/40`; the scan-captured/delayed 8K/8M candidate matches none (`scan_capture_match=0`). This proves the immediate 8K/8M issue is not A/B data ordering or "needs delayed 7N"; at visible timing the mux control is selecting the feedback side, and sometimes IVDBH disables the mux, while useful live 7N data is available. The remaining `16/40` failures where live 7N is nonzero but not the visible compat pixel mean a simple force-live-7N substitution is not sufficient; the next non-driving correction must solve the 8K/8M select/IVDBH phase together with the write/read lifetime, not create another visible bridge candidate.

`VERIFY` 2026-07-04: Further split the same 40 player-footprint 8K/8M visible-timing failures with non-driving hypothetical control/data fixes. Icarus passes and reports `live7n_fix=24`, split evenly between IVDBH-blocked and already-enabled samples (`ivblocked=12`, `enabled=12`), leaving `still_wrong=16`. Those remaining 16 do not match the current Q3/Q0 LS194 output or MBJF (`remain_ls194=0`, `remain_mbjf=0`), but all match both alternate LS194 taps and the second live/scan pixel lane (`remain_tap1=16`, `remain_tap2=16`, `remain_scan1=16`, `remain_live1=16`). Therefore a corrected 8K/8M select plus IVDBH phase explains only `24/40`; the remaining `16/40` start upstream at the 7N/LS194 tap or side/lane phase, not downstream of 8K/8M. Do not try a visible bridge candidate from only the 8K/8M fix.

`VERIFY` 2026-07-04: Classified the remaining `16/40` player-footprint failures at the LS194/7N boundary. They occur only on `h1/h5` (`h1=8`, `h5=8`), only with `B1H=1`, `FLIP=1`, and `FLIPM=0`; current 7N delay, LS86 FLIP candidate, and corrected pin-order candidate do not match (`7n_d1=0`, `ls86_7n=0`, `pin_order_7n=0`). The non-driving 7N candidate that selects LS194 tap2/tap1 instead of Q3/Q0/MBJF matches all 16 (`tap12_7n=16`), and the previous-cycle raw tap1/tap2 values also match all 16 (`tap1_d1=16`, `tap2_d1=16`). This explains the residual class as a lane-1 LS194 tap/phase rule, not a 7N input ordering or simple FLIP/FLIPM polarity problem. The combined non-visible rule implied by the player diagnostic is now: fix 8K/8M select/IVDBH for the 24 live-7N cases, and for the remaining h1/h5 lane-1 cases feed 7N from the alternate LS194 tap phase before any visible candidate is attempted.

`VERIFY` 2026-07-04: Added a single non-driving `mbit_player_timing_candidate` that combines the two player-footprint classes without changing visible output. The first pass proved the broad live-7N term was too loose (`candidate_nonzero=384`, `match_now=48`, `missing_now=0`, `wrong_now=16`), with the wrong samples only at h2/h6 while the live-7N fixes were h0/h3/h7. Tightening the live-7N term to those h phases, and keeping the h1/h5 `B1H=1`, `FLIP=1`, `FLIPM=0` alternate-tap12 7N term, gives the visible-timing player score `compat_nonzero=64`, `candidate_nonzero=264`, `match_now=64`, `missing_now=0`, `wrong_now=0`, `remaining_unexplained=0`. This improves the previous bridge result (`bridge_match_now=24`, `bridge_missing_now=8`, `bridge_wrong_now=32`) and explains all 40 visible-timing failures in the synthetic player diagnostic. The candidate is schematic-informed and player-diagnostic-only, not a proven true Sheet 4B replacement: it still bypasses unresolved schematic timing by applying classified h-phase rules around the bridge, and it is not connected to the visible `mbit` selector. Before any MiSTer candidate, the h0/h3/h7 live-7N rule and h1/h5 lane-1 tap12 rule must be traced back to actual 8K/8M select, IVDBH/IVDSH, LS194, and 7N schematic timing.

`VERIFY` 2026-07-04: Classified the extra nonzero pixels from `mbit_player_timing_candidate`. Icarus passes and keeps the candidate score at `compat_nonzero=64`, `candidate_nonzero=264`, `match_now=64`, `missing_now=0`, `wrong_now=0`, but the extra-pixel split shows the candidate is not safe for a visible MiSTer test yet: `extra_nonzero_total=200`, `same_object=200`, `other_object=0`, `stale_from_previous_scanline=130`, `stale_from_previous_object=1`, `line_buffer_residue=0`, `unknown_extra=0`, with sources `source_live7n=120`, `source_tap12=80`, `source_bridge=0`. Representative extras begin at `h=24,v=24,val=5,src=live7n`, `h=25,v=24,val=a,src=tap12`, `h=27,v=24,val=5,src=live7n`, and `h=29,v=24,val=a,src=tap12`. A later limiter pass corrected the visible seeded-object box to `h=32..39`, `v=24..39`; with that correction the same candidate has `inside_player_8x16=40` and `outside_player_8x16=160`. The extras are still same-object live/tap lifetime overreach, not harmless additional counted pixels and not line-buffer residue. The next candidate must add a clear enable/lifetime/footprint limit before any behaviour-driving switch.

`VERIFY` 2026-07-04: Tested four non-driving limiters for the player timing candidate. The visible seeded-object box was corrected to the actual compat-positive timing window `h=32..39`, `v=24..39` after the first limiter run showed the previous setup-time `v=15..30` box was not the visible footprint. Icarus passes. Results:

| Limiter | Source | Kind | candidate_nonzero | match_now | missing_now | wrong_now | extra_nonzero_total | outside_player_8x16 | stale_from_previous_scanline |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `match_current` | 5J/6H current `MATCH` | schematic-informed | 64 | 24 | 8 | 32 | 8 | 8 | 1 |
| `match_latched` | 6H latched `MATCH` | schematic-informed | 64 | 24 | 8 | 32 | 8 | 8 | 1 |
| `bridge_write` | `render_pending`/BSM bridge write lifetime | schematic-informed | 64 | 24 | 8 | 32 | 8 | 8 | 1 |
| `diag_footprint` | seeded visible box `h=32..39`, `v=24..39` | diagnostic-only | 112 | 64 | 0 | 0 | 48 | 8 | 41 |

No tested limiter is safe for a MiSTer candidate. The schematic-informed current-MATCH/latched-MATCH/write-time gates are in the object scanner/write phase, so at visible read time they suppress the needed live/tap fixes and collapse back to the old failure class. The diagnostic footprint preserves the desired `match_now=64`, `missing_now=0`, `wrong_now=0`, but still has 48 extra pixels, including 40 transparent-pixel overdraws inside the visible box and 8 outside. This proves the missing limiter is not simply object MATCH or 93422 write enable; it must be a true visible read-side pixel-lifetime/transparent-pixel rule tied back to the 8K/8M, 93422, 9T, or 9H timing before any behaviour-driving switch.

`VERIFY` 2026-07-04: Classified the 48 remaining `diag_footprint` extras against the visible/read-side path. Icarus passes. All 48 extras occur while the real schematic read path is transparent: `read93422_any=0`, `read93422_selected=0`, `latch9t_any=0`, `select9h_nonzero=0`, `select9h_zero=48`, and the active COLSEL gate is not selecting motion (`active_colsel_motion=0`). The extra sources are still the player timing override itself (`source_live7n=32`, `source_tap12=16`, `source_bridge=0`); representative samples are `h=40,v=24,cand=5,compat=0,93422=00,9T=00,9H=0,MBIT_zero=1,COLSEL=1,src=live7n` and `h=40,v=25,cand=5,compat=0,93422=00,9T=00,9H=0,MBIT_zero=1,COLSEL=1,src=live7n`. Four read-side transparency gates were tested non-driving:

| Read limiter | Source | Kind | candidate_nonzero | match_now | missing_now | wrong_now | extra_nonzero_total | outside_player_8x16 | stale_from_previous_scanline |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `read_93422_any` | 8J/8L any nonzero | schematic-informed | 64 | 28 | 8 | 28 | 8 | 8 | 1 |
| `read_93422_selected` | 9H-selected 8J/8L side nonzero | schematic-informed | 64 | 24 | 8 | 32 | 8 | 8 | 1 |
| `read_9t_any` | 9T latched any nonzero | schematic-informed | 64 | 28 | 8 | 28 | 8 | 8 | 1 |
| `read_9h_selected` | 9H/MBIT selected nonzero | schematic-informed | 64 | 28 | 8 | 28 | 8 | 8 | 1 |

This proves the 48 extras are not stale nonzero data coming out of 93422, 9T, or 9H; they are overlaid live/tap override pixels where the real visible read path says transparent. However, the same simple read-side zero gates also suppress part of the 64 required recovered pixels and return to the old `missing=8` class, so a pure read-side zero/nonzero limiter is not the missing correction. The unresolved rule is earlier than final 9H transparency: the player timing override needs a schematic-derived pixel-valid/lifetime mask that distinguishes the 64 needed visible fixes from the 48 transparent overdraw pixels before any visible MiSTer candidate.

`VERIFY` 2026-07-04: Split the transparent real-read samples into required live/tap repairs versus unwanted live/tap overlays. Icarus passes. Required transparent repairs are `required=56`, with `req_live7n=24`, `req_tap12=12`; the remaining matching pixels are already supplied by the bridge path. Unwanted transparent overlays are `extra=48`, with `extra_live7n=32`, `extra_tap12=16`. The timing terms do not cleanly separate the classes: `req_byt=0`, `req_nib=16`, `req_ldnib=40`, `req_lof=0`, while extras are `extra_byt=0`, `extra_nib=16`, `extra_ldnib=32`, `extra_lof=0`. FLIP/FLIPM also do not separate them (`req_flip1=56`, `extra_flip1=48`, `req_flipm0=56`, `extra_flipm0=48`). H phase overlaps heavily: required `h0/h1/h2/h3/h4/h5/h6/h7=8/8/8/8/8/4/4/8`; extras `h0/h1/h2/h3/h4/h5/h6/h7=16/8/0/8/0/8/0/8`.

| Repair rule | Source | Kind | candidate_nonzero | match | missing | wrong | extra | required_overrides_kept | unwanted_extras_suppressed |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `diag_footprint` | seeded `h32..39,v24..39` | diagnostic-only | 112 | 64 | 0 | 0 | 48 | 56 | 0 |
| `live7n_only` | live 7N h0/h3/h7 term only | schematic-informed | 96 | 48 | 0 | 16 | 32 | 44 | 16 |
| `tap12_only` | LS194 tap12 h1/h5 term only | schematic-informed | 80 | 40 | 8 | 16 | 24 | 32 | 24 |
| `htrim` | seeded `h32..38,v24..39` | diagnostic-only | 104 | 56 | 0 | 8 | 40 | 48 | 8 |
| `vhalf` | seeded `h32..39,v24..31` | diagnostic-only | 72 | 64 | 0 | 0 | 8 | 56 | 40 |
| `hvtrim` | seeded `h32..38,v24..31` | diagnostic-only | 72 | 56 | 0 | 8 | 8 | 48 | 40 |
| `vhalf_display_edge` | seeded `h32..39,v24..31` plus display h40 suppress | diagnostic-only | 64 | 64 | 0 | 0 | 0 | 56 | 48 |

Conclusion: the only clean separator found in this bounded step is diagnostic/coordinate based (`vhalf_display_edge`). It proves that the player diagnostic can be made numerically clean, but it is not schematic-proven and is not safe for a MiSTer candidate. None of the available schematic-informed source, h-phase, BYTLOAD/NIBLOAD/LDNIB/LOF, FLIP/FLIPM, 93422, 9T, or 9H signals separates required transparent repairs from unwanted transparent overlays. The exact missing state is a schematic-derived object pixel-valid/window signal, or equivalent write/read lifetime state, that says which transparent 9H samples are legitimate repair targets. Until that is found, the override approach remains diagnostic-only and the true fix should return to real 93422 write/read timing and object-window evidence rather than becoming visible.

`PARTIAL` 2026-07-04: Final bounded pre-human-review pass did not find a schematic-derived object-valid/transparency rule beyond the known uncertain Sheet 4B timing. The pin audit is exact for the `8K/8M` inputs/outputs, `8J/8L` control pins, `9T` latch pins, and `9H` selector pins, but the behaviour-critical timing remains unresolved at the single-address 93422 lifetime and counter/decode phase: `MOHLI/MOHLO/MOHRI/MOHRO`, `IVDBH/IVDSH`, `BYTLOAD`/`NIB LOAD`/`LDNIB`/`LOF`, and `BSM`. Prepared `Documents/sheet_4b_human_review_handoff.md` with current safe commit, failed bridge candidate commit, key diagnostics, and exact IC/signal inspection list. This is Outcome C: human handoff prepared. Do not promote the bridge/override route.

`VERIFY` 2026-07-04: Added a focused non-driving Sheet 4B closed-loop probe from `8K/8M` through `8J/8L`, `9T`, and `9H`. This probe uses the schematic feedback observation from manual review: `8K/8M` B inputs are fed by the probe's own `9T` `LB0/LB1` outputs, not by the temporary compatibility `sprite_line0/1` arrays. Both 93422 RAMs use one schematic counter address per side (`motion_buffer_left_addr_from_7j_7k`, `motion_buffer_right_addr_from_7l_7m`) for read and write, `BSM`-derived write enable, existing CS/OE controls, and `9H` selects with `VDBH`. Two non-driving 9T timing variants were scored: old RAM data before write versus new mux data after write.

| Closed-loop variant | compat_nonzero | probe_nonzero | match_now | missing_now | wrong_now | extra_now | first mismatch | first mismatch boundary |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| `old_ram_before_write` | 64 | 0 | 0 | 64 | 0 | 0 | `h=32,v=24,ref=5,probe=0` | `8K/8M=64`, `93422=0`, `9T=0`, `9H=0`, `value=0` |
| `new_ram_after_write` | 64 | 0 | 0 | 64 | 0 | 0 | `h=32,v=24,ref=5,probe=0` | `8K/8M=64`, `93422=0`, `9T=0`, `9H=0`, `value=0` |

The closed-loop structure is now represented without making it visible, but both variants are blank in the player-footprint diagnostic. Therefore the old-versus-new 93422/9T timing question is not distinguishable yet in this diagnostic: no player pixel data reaches the selected 8K/8M mux output before the RAM/latch boundary. This probe does not reduce the previous problem without coordinate or footprint gates. The next exact blocker remains the real `8K/8M` select/enable phase around `MOHLI/MOHRI` and `IVDBH/IVDSH`, before treating 93422 write/read ordering or 9T/9H selection as the primary failure.

`VERIFY` 2026-07-04: Added non-driving closed-loop control variants to test the pin-audit `1H/8F` decode against the blank `014e394` probe. The active path is unchanged. Variant A keeps the current collapsed active decode (`1H enable_n=0`, `sel={0,BYTLOAD}`). Variant B uses pin-correct `1H` only (`enable_n=BYTLOAD`, `sel={0,IV}`) while leaving the current `8F` control. Variant C uses pin-correct `1H` plus pin-correct `8F` (`8F enable_n=BYTLOAD`, `sel={IV,IVDBH}`). Variant D is a labelled polarity probe with pin-correct selects but inverted provisional BYTLOAD enable. The probe uses LS157 convention `sel=0 -> A/MBJ`, `sel=1 -> B/LB feedback`.

| Closed-loop control variant | 8K select active | 8K enable active | 8M select active | 8M enable active | 8K/8M nonzero data | probe_nonzero | match_now | missing_now | wrong_now | extra_now | first boundary |
| --- | ---: | ---: | ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: | --- |
| `current_active_decode` | 0 | 192 | 0 | 192 | `8K=0, 8M=0, any=0` | 0 | 0 | 64 | 0 | 0 | `8K/8M=64` |
| `pin_1h_only` | 192 | 192 | 0 | 192 | `8K=0, 8M=0, any=0` | 0 | 0 | 64 | 0 | 0 | `8K/8M=64` |
| `pin_1h8f` | 192 | 192 | 192 | 192 | `8K=0, 8M=192, any=192` | 80 | 8 | 48 | 8 | 64 | `8K/8M=40`, `93422=16` |
| `pin_1h8f_inv_bytload_enable` | 0 | 192 | 0 | 192 | `8K=0, 8M=0, any=0` | 0 | 0 | 64 | 0 | 0 | `8K/8M=64` |

This is a useful non-driving result, not a visible candidate. Pin-correct `1H` alone does not help. Pin-correct `1H+8F` is the first closed-loop control variant that gets any player-footprint data into the loop and reduces the first-boundary count from `64` to `40`; it also proves the provisional inverted-BYTLOAD enable polarity is worse for this diagnostic. However, `pin_1h8f` only produces right-side/8M data (`8M=192`) while 8K remains zero, and it adds wrong/extra pixels. Therefore the blank closed-loop probe is not explained by the 93422 old/new latch variant; the immediate remaining source is the left-side `8K`/`MOHLI` data phase or the player diagnostic write phase feeding `MBJ` into 8K. Do not promote this to visible output.

`VERIFY` 2026-07-04: Classified the `pin_1h8f` closed-loop asymmetry. In the player-footprint window, both sides have nonzero live `MBJ` input for all samples (`8K mbj_in_nz=384`, `8M mbj_in_nz=384`) and both sides have active `IVDBH` enable for half the samples (`8K en=192`, `8M en=192`). The difference is phase overlap: `8K` selects MBJ for 192 samples and feedback for 192 samples, but `8K mbj_en_nz=0` and `8K fb_en_nz=0`, so its MBJ-select window never overlaps the active enable window and its feedback is also zero. `8M` has the same raw select/en counts, but `8M mbj_en_nz=192`, so its MBJ-select window does overlap active enable and produces `8M out_nz=192`. Related control counts are balanced in this window (`MOHLI=192`, `MOHLO=192`, `MOHRI=192`, `MOHRO=192`, `IV=192`, `IVDBH=192`, `IVDSH=192`, `BYTLOAD=0`, `BSM=384`). Therefore the right/left split is not missing `MBJ`, not feedback lifetime, and not 8K input value; it is the relative phase between `1H` left decode (`MOHLI/MOHLO`) and the `IVDBH` enable used by 8K.

| Closed-loop asymmetry probe | 8K nonzero | 8M nonzero | probe_nonzero | match_now | missing_now | wrong_now | extra_now | first boundary |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `8k_uses_mohlo` | 192 | 192 | 176 | 16 | 32 | 16 | 144 | `8K/8M=24`, `93422=16`, `value=8` |
| `8m_uses_mohro` | 0 | 0 | 0 | 0 | 64 | 0 | 0 | `8K/8M=64` |
| `8k_uses_ivdsh_enable` | 192 | 192 | 176 | 16 | 32 | 16 | 144 | `8K/8M=24`, `93422=16`, `value=8` |

The `8k_uses_mohlo` and `8k_uses_ivdsh_enable` probes are equivalent for this diagnostic and prove the 8K blanking is a complementary-phase issue: either swapping `MOHLI/MOHLO` for the 8K select, or using the complementary enable phase, lets 8K receive nonzero data and reduces the 8K/8M first-boundary count from `40` to `24`. The `8m_uses_mohro` probe blanks the right side, confirming that 8M's useful data is specifically tied to the current `MOHRI`/`IVDBH` phase. These are still probes only, because they add wrong/extra pixels and do not solve the closed-loop timing. Next evidence should trace whether the schematic expects 8K to use the complementary left decode phase, a different left-side enable phase, or whether the current player diagnostic is sampling the wrong left-side write/read phase.

`VERIFY` 2026-07-04: Re-labelled the non-driving 1H mapping comparison after manual review confirmed `1H pin 12/Y0 = /MOHLI` and `1H pin 11/Y1 = /MOHLO`. The active RTL aliases are still reversed (`mohlo_decoded_n = moh_left_decode_n[0]`, `mohli_decoded_n = moh_left_decode_n[1]`), but the closed-loop probe already had both choices available. The explicit comparison against the player-footprint diagnostic is:

| 1H mapping probe | 8K nonzero | 8M nonzero | probe_nonzero | match_now | missing_now | wrong_now | extra_now | boundary_8K/8M | boundary_93422 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `existing_reversed_y1_as_mohli` | 192 | 192 | 176 | 16 | 32 | 16 | 144 | 24 | 16 |
| `corrected_y0_as_mohli` | 0 | 192 | 80 | 8 | 48 | 8 | 64 | 40 | 16 |

This is a negative result for promoting the corrected 1H Y0/Y1 mapping as a standalone fix in the current synthetic player diagnostic: the schematic-correct `Y0=/MOHLI` probe leaves `8K=0`, while the reversed/provisional `Y1-as-MOHLI` probe makes 8K nonzero and reduces the 8K/8M boundary. Do not change visible output from this. The most likely interpretation is that the pin fact is correct but the current provisional `BYTLOAD`/`IV`/`IVDBH`/player-write phase is not phase-coherent with the true schematic scanner, so the diagnostic rewards the complementary phase even though the pin audit says Y0 is `/MOHLI`. Updated the pin audit rows to make the manual Y0/Y1 mapping explicit and to mark the active RTL aliases as still reversed/non-driving.

`VERIFY` 2026-07-04: Added the requested compact phase-alignment table for the player diagnostic. Both rows use the same non-driving closed-loop feedback path (`9T` LB feedback into 8K/8M B inputs); the only comparison is which 1H phase is treated as `/MOHLI` for 8K select.

| Phase row | samples | BYTLOAD | IV | IVDBH | IVDSH | BSM | `/MOHLI` | `/MOHLO` | `/MOHRI` | `/MOHRO` | 8K A/MBJ | 8K B/fb | 8K en | 8K dis | 8K MBJ nz | 8K out nz | 8M A/MBJ | 8M B/fb | 8M en | 8M dis | 8M out nz |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `schematic_correct_y0_mohli` | 384 | 0 | 192 | 192 | 192 | 384 | 192 | 192 | 192 | 192 | 192 | 192 | 192 | 192 | 384 | 0 | 192 | 192 | 192 | 192 | 192 |
| `complementary_y1_as_mohli` | 384 | 0 | 192 | 192 | 192 | 384 | 192 | 192 | 192 | 192 | 192 | 192 | 192 | 192 | 384 | 192 | 192 | 192 | 192 | 192 | 192 |

This table makes the failure mode precise: the player window has balanced raw phase counts for `IV`, `IVDBH`, `IVDSH`, `MOHLI/MOHLO`, `MOHRI/MOHRO`, and 8K/8M select/enable. `BYTLOAD` is never high in this visible diagnostic window, while `BSM` is always high. The reason schematic-correct `Y0=/MOHLI` leaves 8K blank is not missing MBJ data (`8K MBJ nz=384`) and not missing nominal select/enable counts; it is that the current provisional phase never overlaps 8K's MBJ-selected half with its enabled half, so `8K out nz=0`. Treating the complementary 1H phase as `/MOHLI` creates that overlap and gives `8K out nz=192`, but this remains diagnostic evidence only because it contradicts the pin audit and still creates wrong/extra pixels. The unresolved source is the phase relationship between the real motion `BYTLOAD`/`IV`/`IVDBH` timing and the temporary player/write diagnostic, not the 1H pin fact.

`VERIFY` 2026-07-04: Tightened the player diagnostic from independent phase counts to an overlap table grouped by `BSM/BYTLOAD/IV/IVDBH/IVDSH/MOHLI/MOHLO`. Icarus passes. The schematic-correct row keeps the pin-audit fact `1H Y0=/MOHLI`, `1H Y1=/MOHLO`; the complementary row is diagnostic only.

| Case | BSM | BYTLOAD | IV | IVDBH | IVDSH | `/MOHLI` | `/MOHLO` | samples | MBJ nz | 8K A/MBJ | 8K B/fb | 8K en | 8K dis | A+en | A+en+MBJ | 8K out nz | match | missing | wrong | extra |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `schematic_correct_y0_mohli` | 1 | 0 | 0 | 1 | 0 | 1 | 0 | 192 | 192 | 192 | 0 | 0 | 192 | 0 | 0 | 0 | 8 | 16 | 8 | 64 |
| `schematic_correct_y0_mohli` | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 192 | 192 | 0 | 192 | 192 | 0 | 0 | 0 | 0 | 0 | 32 | 0 | 0 |
| `complementary_y1_as_mohli` | 1 | 0 | 0 | 1 | 0 | 0 | 1 | 192 | 192 | 0 | 192 | 0 | 192 | 0 | 0 | 0 | 8 | 16 | 8 | 64 |
| `complementary_y1_as_mohli` | 1 | 0 | 1 | 0 | 1 | 1 | 0 | 192 | 192 | 192 | 0 | 192 | 0 | 192 | 192 | 192 | 8 | 16 | 8 | 80 |

| 8K enable probe | A+en+MBJ | 8K out nz | probe_nonzero | match | missing | wrong | extra | first boundary |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `enable_n=IVDBH` | 0 | 0 | 80 | 8 | 48 | 8 | 64 | `8K/8M=40`, `93422=16` |
| `enable_n=~IVDBH` / `enable_n=IVDSH` | 192 | 192 | 176 | 16 | 32 | 16 | 144 | `8K/8M=24`, `93422=16` |
| `enable_n=~IVDSH` / `enable_n=IVDBH` | 0 | 0 | 80 | 8 | 48 | 8 | 64 | `8K/8M=40`, `93422=16` |

Conclusion: the exact missing overlap is `8K select A/MBJ` plus active enable plus nonzero `MBJ`. With schematic-correct `/MOHLI`, the player diagnostic selects MBJ only in the `IVDBH=1/IVDSH=0` half, while `8K` enable is active only in the `IVDBH=0/IVDSH=1` half. The complementary phase, or the `IVDSH` enable probe, creates the overlap but also increases wrong/extra output, so it is not a visible fix. Because the pin audit says `8K` enable is `IVDBH`, this is best classified as: `IVDBH` is physically correct, but the current RTL/probe-generated `IVDBH` or the synthetic player diagnostic write phase is shifted relative to real Sheet 4B timing. Do not alter the `1H` pin mapping and do not promote the complementary phase.

`VERIFY` 2026-07-04: Checked the `7F`/`IVDBH` source and delayed-overlap question. The cached Sheet 4A crop confirms `7F` is `LS74`; pin 2 `D` is `IV`, pin 3 clock is `B8H`, pin 5 `Q` is `IVDSH`, and pin 6 `/Q` is `IVDBH`. The pin audit remains unchanged: `8K` pin 15 and `8M` pin 15 are LS157 active-low enables tied to `IVDBH` from 7F `/Q`. RTL matches this naming: `ivdsh_from_7f` is `u_7f_ivdb_latch.q`, `ivdbh_from_7f` is `q_n`, and both `motion_buffer_8k_enable_n_from_ivdbh` and `motion_buffer_8m_enable_n_from_ivdbh` use `ivdbh_from_7f`.

Player diagnostic timing counts for schematic-correct `/MOHLI`:

| Overlap term | Count |
| --- | ---: |
| `8K select MBJ && IVDBH=0` | 0 |
| `8K select MBJ && IVDBH=1` | 192 |
| `8K select MBJ && IVDSH=0` | 192 |
| `8K select MBJ && IVDSH=1` | 0 |
| `8K select MBJ && delayed_IVDBH=0` | 0 |
| `8K select MBJ && delayed_IVDBH=1` | 192 |

This rejects a simple one-visible-sample delayed `IVDBH` fix for the player diagnostic: delayed `IVDBH` still has the same polarity during all `/MOHLI` MBJ-selected samples. Conclusion for this bounded step is option 1 with a caveat: `IVDBH` is correctly named and physically used for 8K/8M pin 15, so the remaining issue is the synthetic player diagnostic/write-phase relationship or upstream provisional `IV`/`B8H` timing, not a swapped `IVDBH`/`IVDSH` RTL name and not a different schematic enable signal.

`PARTIAL` 2026-07-04: Added `Documents/sheet_4a_4b_timing_source_audit.md` to separate schematic pin facts from current RTL timing aliases. The audit concludes that `IV`, `BYTLOAD`, and the legacy `bsm`/corrected `B5M` rail are still provisional in RTL (`display_line_bank`, `render_pending`, and `ce_5m` respectively). Therefore the closed-loop Sheet 4B probe cannot be expected to match the real schematic until those timing sources are traced or replaced. Do not continue local 8K/8M pin/phase variants before tracing the true upstream source of `IV`, then `BYTLOAD`, then `B5M`.

`PARTIAL` 2026-07-04: B5M/legacy-BSM Step 1 timing-source trace. Sheet 4A/4B prove the local destinations of the rail previously tracked as BSM but not its generator: Sheet 4A uses it as the LS194 clock rail, and Sheet 4B uses it for LS163 clocks, active-low 93422 `WE`, and the `9T` clock. The full-sheet crops show it as an incoming labelled rail on both sheets, not locally generated logic. Later Sheet 2A review corrects the interconnect nomenclature: this is the 5 MHz rail family `E5M -> B5M*/B5M`, not `ESM -> BSM*/BSM`. No `bsm_schematic_candidate` was added. Current `bsm = ce_5m` remains approximate/provisional and legacy-named: in the player diagnostic it is high for all 384 samples while BYTLOAD is never high, and prior render-tag evidence shows only loose overlap. Next B5M work must trace the upstream `E5M` source before changing RTL.

`PARTIAL` 2026-07-04: B5M upstream-source trace around Sheet 2A `1P/1R/8C`. The source is narrowed to the master timing/interconnect block already listed in `Documents/schematic_master_cpu_audit.md`. Manual review separates the LS244s: `1P` distributes the BxH rail group, while `1R` distributes `E5M` into `B5M*`/`B5M`, with nearby `8C` inverter stages involved in the complement/export path. The available evidence identifies `E5M` at Sheet 2A connector pin 31 and `1R` outputs labelled `B5M*`/`B5M`, but not the upstream `E5M` generator. Therefore `bsm = ce_5m` remains approximate/provisional rather than pin-to-pin schematic-accurate, but no replacement candidate is safe yet.

`PARTIAL` 2026-07-04: Corrected the Sheet 2A cross-sheet trace nomenclature. The signal previously read as `ESM/BSM` is now documented as `E5M/B5M`: connector pin 31 is `E5M`, and the lower `1R` LS244 path produces `B5M*` and `B5M`. Upper `1P` distributes `E1H/E2H/E4H/E8H` into `B1H/B2H/B4H/B8H`; lower `1R` distributes `MAP0/MAP1/MAP2/E32H/E5M` and related rails into `BMAP0/BMAP1/BMAP2/B32H/B5M*/B5M` and related outputs. Therefore the corrected path is `E5M -> 1R/8C -> B5M*/B5M`, not `ESM -> 1R -> BSM*/BSM`. Do not call the timing source solved yet: upstream `E5M` source, polarity, and phase relationship to `B8H`/base 5 MHz remain untraced. Current RTL `bsm = ce_5m` is still an approximate/provisional legacy-named timing alias and is not a pin-to-pin model of the `E5M -> B5M` interconnect path.

`PARTIAL` 2026-07-04: E5M source trace correction. Existing audits and the Sheet 2A screenshot show `E5M` as an upstream interconnect timing net feeding the lower `1R` LS244 path that produces board-side `B5M*`/`B5M`, but the current readable material does not identify the `E5M` generator IC/pin. Sheet 7A cached sync-chain evidence shows the base `5MHZ` and `1H..256H` timing family, but no readable `E5M` label/source in this pass. Therefore the legacy-BSM rail is one level better traced (`E5M -> 1R/8C -> B5M*/B5M`), but not solved. Exact blocker: need a readable source-side trace for Sheet 2A connector pin 31 `E5M`; if that points back to sync timing, also trace the specific Sheet 7A source net. No RTL or sim changes were made.

`DONE` 2026-07-05: Corrected the Sheet 2A B5M distribution wording using the user-provided bottom-left Master/Slave Interconnect crop. The label is `E5M` at connector pin 31. The local Sheet 2A distribution path is now documented as `E5M -> 1R/8C -> B5M*/B5M`: lower `1R` handles the E5M/MAP/E32H group, and nearby `8C` inverter sections show pin 5 -> 6 labelled `B5M*` and pin 9 -> 8 labelled `B5M`. This replaces the old `ESM/BSM` wording. The upstream generator before connector pin 31 is still unresolved, so RTL `bsm = ce_5m` remains an approximate legacy-named 5 MHz placeholder, not a pin-to-pin schematic source.

`DONE` 2026-07-05: Traced the `E5M` connector source from the user-provided Sheet 6B crop. Sheet 6B lower `3D` (`74LS244`) buffers `5MHZ` on pin 11 to `E5M` on output pin 9, exported at J17 pin 31. Combined cross-sheet path is now `5MHZ -> Sheet 6B 3D pin 11 -> 3D pin 9 E5M -> J17 pin 31 -> Sheet 2A 1R/8C -> B5M*/B5M -> Sheet 4A/4B destinations`. This clears the previous `E5M` source blocker. RTL `bsm = ce_5m` is still legacy-named and not a structural buffer-chain model, but it now matches the correct broad timing family. Remaining timing-source blockers for the Sheet 4A/4B motion path are `IV` and `BYTLOAD`/load timing rather than the `B5M` source.

`DONE` 2026-07-05: Refined the B5M/E5M connector trace with the explicit Sheet 2A `1R` pins. The documented path is now `5MHZ -> Sheet 6B 3D pin 11 -> 3D pin 9 E5M -> J17 pin 31 -> Sheet 2A 1R pins 2 and 17 -> 1R pin 18 B5M* and pin 3 B5M`, with nearby `8C` inverter distribution also shown. This is an important connection/provenance finding, not a requirement to duplicate every LS244/LS04 distribution buffer in Verilog: FPGA clock enables can be generated internally as long as the timing family, phase/polarity, and destination pins are correct.

`PARTIAL` 2026-07-04: Created `Documents/schematic_full_pin_netlist_sheet_4b.md` as the new Sheet 4B source-of-truth start point, then corrected it with fresh Sheet 4B review findings. This is documentation-only and deliberately marks unreadable or ambiguous Sheet 4B pins as `UNCLEAR_*` rather than filling gaps from RTL. The review confirms the local timing rail is `B5M`, not `BSM`; the upper-right LS157 is `11J`, not `10T`; `9H` pin mapping is corrected; and `8D` is `LS32`, not `LS27`. At creation time, motion-buffer ICs were substantially pin-audited but the whole sheet was not complete; the follow-up 2026-07-05 entry below records the visual-check sync that resolves the lower-video review findings.

`DONE` 2026-07-05: Synced `Documents/schematic_full_pin_netlist_sheet_4b.md` to the reviewed Sheet 4B visual-check CSV/Markdown/Numbers set (`068ea36`). The detailed netlist now preserves the human-reviewed corrections: `11J` pull-up pins 2/3/13/14 are confirmed to `PR176`; `10H` pin 11 is confirmed from `6F` pin 5; `6F` pin 6 is confirmed no-connect; `7K/7M` cascade pins are confirmed; and the lower video path is corrected to `9K -> 8C/8E`, `1L LS27` pins 1/2/13 -> 12, `8D LS32` pins 4/5 -> 6, and `8E LS00` pins 12/13 -> 11 for `COLSEL0`. The visual-check source now has 225 rows and no remaining `Check` rows. This is still documentation-only: RTL/simulation were not changed, and the remaining implementation blockers are Sheet 4A/source timing provenance (`MBJ*`, `MOH*`, `IVDBH` via upstream `IV`, `MOD*`, and `BYTLOAD`/load timing) plus explicit RTL comparison, not unresolved local Sheet 4B lower-video pins.

Active-path boundary:

- `rtl/cloak_core.sv` now names `mbit_compat` as the temporary
  `sprite_line0/1` output and `mbit_schematic` as the Sheet 4B `9H` output.
  `USE_SCHEMATIC_MOTION_BUFFER` is back to `0` after the phase-2 MiSTer
  diagnostic regressed into full-height vertical stripe columns. Keep the
  compatibility boundary active until clear/bank/read timing is corrected.
- Reference-designator audit note: Sheet 4B `9H` is the `74LS157` final
  `LB0/LB1` to `MBIT` selector. Sheet 4B `9K` is the `74LS260` `MBIT` zero
  detect gate in the `COLSEL` chain. RTL, simulation harnesses, and handoff
  notes have been corrected to avoid treating `9K` as the final motion mux.

### Final Video Mux

| Ref | Device | Visible Nets | Function | Verilog Status | Notes |
| --- | --- | --- | --- | --- | --- |
| Gates around `COLSEL` | `74LS260`, `74LS00`, `74LS04`, `74LS32`, `74LS27` | `MBIT*`, `BMAP*`, `COLRAM`, `COLSEL0`, `COLSEL1` | Selects playfield/bitmap/motion/color-RAM source | `PARTIAL` | RTL now instantiates Sheet 4B `9K` (`74LS260`) for `MBIT` zero detect, `1L` (`74LS27`) for `BMAP` zero detect, `8C` inverter, `8D` OR, and `8E` NAND gates. `COLRAM` is active-high in RTL decode, so the schematic active-low input is represented as `colram_n`. The resulting `colsel_from_gates` now drives the active `COLA` palette-address mux. |
| `10H`, `10J` | `74LS153` | `PBIT*`, `BMAP*`, `MBIT*`, `PABA*`, outputs `COLA0..COLA3` | Selects low color address bits | `PARTIAL` | RTL now instantiates `u_10h_cola3_cola2_mux` and `u_10j_cola1_cola0_mux` using a `cloak_74ls153` model. Their `cola_low_from_10h_10j` output is behavior-driving for palette addressing when `USE_SCHEMATIC_COLOR_MUX=1`. |
| `11J` | `74LS157` | `PABA4/5`, `COLSEL*`, `COLRAM*`, output `COLA4/5` | Selects high color address bits | `PARTIAL` | RTL now instantiates `u_11j_cola5_cola4_mux`, selecting between `COLSEL0/1` and CPU `PABA4/5` using `COLRAM`. `cola_from_mux_tree` is behavior-driving for palette addressing when `USE_SCHEMATIC_COLOR_MUX=1`. |
| Color RAM address boundary | color RAM block | `COLA0..5`, `PABA6`, `PABD0..7` | Addresses and writes 64x9 color RAM | `PARTIAL` | RTL now names `cola_cpu_from_paba`, `colram_bit8_from_paba6`, `cola_video_from_mux_tree`, and `palette_word_from_cola`. Active visible color now uses `palette_index_schematic = cola_video_from_mux_tree` by default, with `palette_index_compat` retained as the old priority expression. |
| Remaining gates around `COLRAM`, `BMAP`, `MBIT` | `74LS00`, `74LS08`, `74LS27`, `74LS32`, `74LS04` | `COLRAM`, `COLSEL*`, `BMAP*`, `MBIT*` | Priority/control decode for final video mux | `PARTIAL` | The visible `COLSEL` chain, `COLA` palette address path, and Sheet 5A color latch output are now behavior-driving. Remaining work is to verify final blank timing against the PROM/custom timing sources and any still-missing final RGB analog-equivalent gates. |

## Implementation Order From Here

Do not continue editing `motion_shift_pixel()` or ROM nibble order unless this
audit proves a wiring error there. The next work should be:

1. Build explicit Sheet 4A `MOA`/`MOD` bus model around the existing
   `motion_ram`.
2. Implement the Sheet 4A latch/counter/control chain enough to produce named
   `MOHLD`, `MOHRD`, `MOHLC`, `MOHRC`, `MATCH`, and `MOFLIP`.
3. Replace the current abstract object scan state with the schematic
   counters/latches.
4. Make the Sheet 4B `74LS163A`/`93422`/`9T`/`9H` buffer path behavior-driving
   and remove the temporary `sprite_line0/1` visible path.
5. Replace the provisional `palette_index` priority expression in
   `rtl/cloak_core.sv` with the Sheet 4B final mux.

## Verification Rule

Before any new Verilog commit:

- Identify the exact audit row(s) being implemented.
- Name the schematic signals in the Verilog.
- State which shortcut is being removed.
- Run local smoke tests.
- Only ask for Quartus/MiSTer testing after a real schematic row changes.
