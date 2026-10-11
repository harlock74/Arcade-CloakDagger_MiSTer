# POKEY provenance

MikeJ May 2004 / FPGAArcade POKEY, from MiSTer-devel/Arcade-AtariSystem2_MiSTer
commit `7ad07997e70190540c5e9464972ccb57e6882442`, path `rtl/lib/POKEY.vhd`.
The byte-exact source is bundled as `upstream/mikej-pokey/POKEY.vhd`:
34926 bytes, SHA-256
`4d7948e3d78c11116aae239d9f8c357cfc886d1d66ddaf8bfa1dfea8d1deb453`.
[Pinned source](https://github.com/MiSTer-devel/Arcade-AtariSystem2_MiSTer/blob/7ad07997e70190540c5e9464972ccb57e6882442/rtl/lib/POKEY.vhd).

The original copyright, three source/synthesized-form conditions,
non-endorsement clause and disclaimer remain unchanged in the adapted chip
and `LICENSES/MIKEJ-POKEY-source-synthesized.txt`. The exact grant contains no
non-commercial exclusion; a top-level GPL licence does not replace its terms.

## Intermediate repository role

The bundled upstream snapshot is byte-identical to `rtl/lib/POKEY.vhd` in
AtariSystem2 commit `1ec6c9bc0fe1d9a06ddf3c93e40dd22d777653f2`.
The retained GitHub path-history record identifies RetroShrimp as that commit's
author, with message "initial commit" dated 2026-08-21. This supports attribution
of the repository import to RetroShrimp; it is not inferred from repository
ownership. [Initial import commit](https://github.com/MiSTer-devel/Arcade-AtariSystem2_MiSTer/commit/1ec6c9bc0fe1d9a06ddf3c93e40dd22d777653f2).

The retained path history contains this one entry, and the initial file matches
the later pinned snapshot. It does not demonstrate subsequent POKEY maintenance,
authorship of pre-import modifications, or copyright ownership by RetroShrimp.
Neither the original POKEY copyright header nor its reproduced licence notice
names RetroShrimp. No relevant POKEY modifications authored by RetroShrimp were
established in the available evidence; that is not proof that none exist.
The earlier "importer/maintainer" description therefore overstated the evidence.

This establishes the intermediate source route, not a clean original MikeJ
revision, complete pre-import authorship or rights assignments. The GPL Tempest
comparison comment alone does not establish copied expression or guarantee
legal clearance.

## Local modifications

harlock74's original adaptation and wrappers add deterministic external reset,
CPU-write acceptance independent of audio enables, board ALLPOT/read tie-offs,
STIMER/timer, IRQ/TX/status, initialization, polynomial/history and high-pass
behavior, and linear audio scaling. Integration changes the two board sound
module identifiers and source membership. Paperboy's non-linear mixer and other
game logic were not imported. No Mark Watson implementation was copied.

The adaptation uses VHDL-93-compatible mixer sensitivity/port maps, explicit
unsigned arithmetic and separate concurrent channel-enable assignments.
The component depends on IEEE std_logic_1164/numeric_std plus its two wrappers;
standard libraries are supplied by tools, not bundled.

GPL-3.0-or-later applies only to harlock74's original adaptations, wrappers,
tests and documentation. The untouched upstream source and reproduced licence
notice contain no claimed local modifications. Inherited expression keeps its
own terms; whole-file ownership is not asserted. Component attribution is
preserved in [NOTICE](../NOTICE.md) and the unchanged inherited source notices.
See [validation](../README.md) and [licensing](LICENSING.md) for remaining limits.
