# Verified fixed-instance portfolio version2

Four fixed development instances, thirteen candidate/reference source assets.
Original and candidate bytes are copied without logic edits. registry.json records
fixed parameters, explicit backend, origins, line counts and SHA256;
registry.sha256 detects accidental registry changes.

The original three-instance bank is preserved. The CRC adapter must match the
locked CRC32 reflected byte-update reference and checks both complete outputs;
it cannot be repurposed for another reference merely by changing an instance ID.

Use `python -B -m agents.verified_optimizer list` and the project-root
README_VERIFIED_OPTIMIZER.md. Each run remeasures all selected sources. These
already exposed artifacts are neither new model outputs nor held-out benchmarks
or general rewrite rules. Preserve source copyright notices and provenance.
