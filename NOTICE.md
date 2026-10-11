# Component notices

harlock74 grants **GPL-3.0-or-later for original Cloak & Dagger contributions
only**. [LICENSE](LICENSE) defines the scope. This does not relicense inherited
code or claim ownership of whole mixed-source files.

**MAME:** game RTL in `rtl/cloak_core.sv` substantially adapts the Cloak driver's
graph-processor addressing, bitmap bank/clear model, graphics layouts, playfield
and motion rendering. The driver credits Dan Boris and Mirko Buffoni under
BSD-3-Clause; its notice/conditions accompany the bitstream in
`LICENSES/MAME-BSD-3-Clause.txt`. The recorded comparison revision is
`dfbb415423d78cdb5e78e90a19331952cc95c4fa`, not an established historical import.
Schematic evidence and MAME gameplay observations are separate.

**T65:** Daniel Wallner, Mike Johnson, Wolfgang Scherr and Morten Leikvoll's
copyright and source/synthesized-form conditions remain in all four files.
Revision credits include ost(ML), WoS, SzGy, foft and ehenciak; retained aliases
are not expanded without evidence. `LICENSES/T65-source-synthesized.txt`
reproduces the required notice for the bitstream.

**POKEY:** MikeJ May 2004 / FPGAArcade (original implementation); harlock74
(local integration/adaptation). The intermediate repository import is documented
in [POKEY provenance](docs/POKEY_PROVENANCE.md), without implying POKEY authorship
or maintenance responsibility.
Basis: AtariSystem2 commit `7ad07997e70190540c5e9464972ccb57e6882442`,
`rtl/lib/POKEY.vhd`. Its original copyright, source/synthesized-form conditions,
non-endorsement clause and disclaimer remain verbatim in source and
`LICENSES/MIKEJ-POKEY-source-synthesized.txt`. Local adaptations and wrappers
are harlock74's original contributions only. See
[POKEY provenance](docs/POKEY_PROVENANCE.md) for modifications and history limits.
Mark Watson's restricted implementation is absent from this source/build.

**MiSTer framework:** retained credits include Sorgelig / Alexey Melnikov,
Till Harbaum, Ludvig Strigeus, Grabulosaure, Kitrinx, bellwood420, Mike Simone
and other Template contributors. Specific GPL-2.0-or-later, GPL-3.0-or-later
and LGPL-3.0-or-later notices remain. Some files have only Template's root GPLv2
package context; GPL/COPYING-only version ambiguity is not silently resolved.
The SPDIF transmitter credits Ultra-Embedded.com (Copyright 2012) and states
GPL-2.0-or-later. TEMLIB's scaler retains its own permissive notice in source
and `LICENSES/TEMLIB-scaler.txt`. GPLv2/GPLv3/LGPLv3 texts are in `LICENSES/`.

**Intel/Altera:** PLL/reconfiguration sources and QIPs retain vendor copyright,
proprietary notices and device-use restrictions. The recorded Quartus Prime
17.0 Web Download Agreement §2.5 permits the evidenced free source-form IP
redistribution/modification for Altera devices. Section 20's compatibility
with jointly compiled GPL/LGPL components remains an unresolved interpretation;
file separation or an owner grant does not settle it. See
[LICENSING](docs/LICENSING.md).

No ROMs or personal saves are included. Component-by-component terms govern
source and bitstream; no guaranteed legal clearance or unrestricted whole-package
GPL claim is made. The component notes below, existing documentation and
retained source headers preserve authorship, licence evidence, provenance and modifications.

**Release profile:** the hardware-tested LegacyMenu build is distributed with
Legacy video forced. The original experimental selector remains in source for
development when the release define is absent. This profile/naming adoption
does not change third-party terms or claim a new upstream revision.

## Framework classification and provenance details

The retained framework is from MiSTer Template, but its historical import revision is not established. File-specific GPL-2.0-or-later notices apply to `sys/alsa.sv`, `sys/arcade_video.v`, `sys/iir_filter.v`, `sys/ltc2308.sv`, `sys/spdif.v`, `sys/sys_top.v`, `sys/video_freezer.sv` and `sys/yc_out.sv`. GPL-3.0-or-later notices apply to `sys/ddr_svc.sv`, `sys/hps_io.sv` and `sys/scandoubler.v`; `sys/sd_card.sv` is LGPL-3.0-or-later. `sys/ascal.vhd` retains TEMLIB's own notice. `sys/hq2x.sv`, `sys/video_cleaner.sv`, `sys/video_freak.sv` and `sys/video_mixer.sv` have GPL-family/COPYING notices whose exact version remains qualified.

Template GPLv2 package context, without an established precise individual grant, applies to `sys/audio_out.v`, `sys/build_id.tcl`, `sys/f2sdram_safe_terminator.sv`, `sys/gamma_corr.sv`, `sys/i2c.v`, `sys/i2s.v`, `sys/math.sv`, `sys/mcp23009.sv`, `sys/mt32pi.sv`, `sys/osd.v`, `sys/pll_hdmi_adj.vhd`, `sys/pll_q17.qip`, `sys/scanlines.v`, `sys/shadowmask.sv`, `sys/sigma_delta_dac.v`, `sys/sys.qip`, `sys/sys.tcl`, `sys/sys_analog.tcl`, `sys/sys_top.sdc`, `sys/sysmem.sv`, `sys/vga_out.sv`. This classification does not override specific source notices or vendor terms, establish individual authorship, or assign a new licence version. `sys/build_id.tcl` retains Jeff Wiencrot and Sorgelig credits; other named contributors remain credited in their unchanged headers.

The 17 evidenced Intel/Altera package inputs covered by the previously described device-use/notice assessment are `rtl/pll.qip`, `rtl/pll.v`, `rtl/pll/pll_0002.qip`, `rtl/pll/pll_0002.v`, `sys/pll_audio.qip`, `sys/pll_audio.v`, `sys/pll_audio/pll_audio_0002.qip`, `sys/pll_audio/pll_audio_0002.v`, `sys/pll_cfg.qip`, `sys/pll_cfg/altera_pll_reconfig_core.v`, `sys/pll_cfg/altera_pll_reconfig_top.v`, `sys/pll_cfg/pll_cfg.v`, `sys/pll_cfg/pll_cfg_hdmi.v`, `sys/pll_hdmi.qip`, `sys/pll_hdmi.v`, `sys/pll_hdmi/pll_hdmi_0002.qip`, `sys/pll_hdmi/pll_hdmi_0002.v`. Generated/IP content is not claimed as wholly owner-authored; historical import provenance is not proved by tool metadata. The separate section 20 interpretation remains unchanged.

T65's source lineage is `MiSTer-devel/T65`; retained version evidence includes FPGAARCADE SVN 1234 (2015) where stated and T65 ver315, SzGy, April 2020. An exact repository import revision is not established. Project QPF/QSF/SDC/QIP files contain inherited Template configuration and project settings; no whole-file owner authorship is inferred. The top-level wrapper preserves its inherited GPL-2.0-or-later notice; the owner grant covers only original integration.
