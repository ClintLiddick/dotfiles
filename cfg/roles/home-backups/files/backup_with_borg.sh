#!/bin/bash

set -euxo pipefail

BORG=/usr/local/bin/borg
DATE=$(/bin/date --utc --iso-8601)

# No one can answer if Borg asks these questions, it is better to just fail quickly
# instead of hanging.
export BORG_RELOCATED_REPO_ACCESS_IS_OK=no
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=no

BORG_REPO="/mnt/nas/backups/borg-backups/marvin.borg"
BORG_OPTS="--stats --one-file-system --compression zstd,5"
$BORG --version

echo "Starting backup for ${DATE}"

borg create $BORG_OPTS \
     $BORG_REPO::$DATE \
     /etc /home

echo "Backup for ${DATE} complete"

sync
