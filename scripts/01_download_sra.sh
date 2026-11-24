#!/usr/bin/env bash
# Step 1: download paired-end reads from NCBI SRA
source "$(dirname "$0")/config.sh"
prefetch "$SRR"
fasterq-dump "$SRR" --split-files -e "$THREADS" -O data/raw
