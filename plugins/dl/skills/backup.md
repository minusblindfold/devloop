# Backup procedure

Used by skills that back up artifacts before overwriting them in refine mode.

## Steps

1. Resolve the backup directory: `<artifact-dir>/.backup/`.
2. Copy the current file there as `YYYY-MM-DD-HH-MM-SS-<original-filename>`.
3. List all backups for this artifact (files matching `*-<original-filename>`), sorted oldest-first.
4. Delete the oldest until the count is at or below `backups.maxPerArtifact`.
