# Licensing and provenance limits

**GPL-3.0-or-later covers harlock74's original contributions only**, as set out
in [LICENSE](../LICENSE). Inherited expression retains its original notices
and terms. No generic owner licence applies to whole mixed-source files.

## Included components

- MAME Cloak driver adaptations: Dan Boris and Mirko Buffoni, BSD-3-Clause.
  The recorded comparison pin is `dfbb415423d78cdb5e78e90a19331952cc95c4fa`;
  the historical import revision is not established.
- T65: Daniel Wallner, Mike Johnson, Wolfgang Scherr and Morten Leikvoll;
  additional revision credits remain in source. Its three-condition
  source/synthesized-form notice and disclaimer accompany the RBF.
- POKEY: MikeJ / FPGAArcade (original implementation); harlock74 (local
  integration/adaptation). The intermediate repository import is described in
  [POKEY provenance](POKEY_PROVENANCE.md). Its exact
  source/synthesized-form grant permits redistribution with/without modification,
  requires notices/disclaimer and prohibits endorsement without permission.
  It has no non-commercial exclusion. [POKEY provenance](POKEY_PROVENANCE.md)
  distinguishes inherited source from harlock74's adaptations and wrappers.
- MiSTer framework: exact file headers govern named GPL/LGPL grants. Silent
  files are assessed using Template's GPLv2 package context, not an invented
  individual grant. GPL/COPYING-only notices retain version ambiguity. The
  historical Template import revision is not established.
- TEMLIB scaler: original freely-distributable/use-for-any-purpose wording.
- SPDIF transmitter: Ultra-Embedded.com, Copyright 2012, GPL-2.0-or-later.
- Intel/Altera PLL and reconfiguration IP: vendor terms and device restrictions.

Full component notices are in [NOTICE](../NOTICE.md), `LICENSES/` and the
unchanged source headers. [NOTICE](../NOTICE.md) preserves the relevant component
classifications, attribution, provenance and modifications.
Files without complete authorship or a precise individual grant remain explicitly
qualified. No new permission is inferred from widespread use or attribution.

## Intel agreement and compatibility

The recorded Quartus Prime 17.0 Web Download Agreement has SHA-256
`cec323b41fee8867f597d4b032c2c8949066e4badde398d5c893de546c2f8732`.
Section 2.5 covers the evidenced free source-form ordinary PLL/reconfiguration
components and derivatives for programming Altera devices. Sections 5/6 require
notice retention. The 17 relevant package files are individually identified
in [NOTICE](../NOTICE.md); no tool binaries or compiler libraries are included.

Section 20 prohibits subjecting Intel licensed material to open-source obligations.
This design jointly compiles GPL/LGPL framework modules and Intel IP for Cyclone V.
Whether that combination triggers the clause remains an unresolved interpretation.
Separate filenames, regenerated IP or README exclusions do not settle it.
No additional override or guaranteed compatibility is claimed.

## POKEY history and remaining limits

Mark Watson's restricted implementation is excluded, rather than relicensed.
The selected AtariSystem2 file has its own three-condition source/synthesized
notice; a repository-level GPL licence does not override that notice.
Byte identity with the intermediate repository's initial import is demonstrated, but a clean
original MikeJ revision, complete pre-import authorship and rights assignments
are not established. A comment comparing GPL Tempest code does not alone prove
copied expression. These are disclosed provenance limits, not a claim of either
proven incompatibility or guaranteed clearance.

The replacement uses IEEE libraries provided by the tools and two original
wrappers. No Paperboy game/mixer logic or Mark Watson POKEY is included.
Original contributions remain separately scoped; third-party compatibility
limits are not resolved by successful simulation, compilation or MiSTer testing.
