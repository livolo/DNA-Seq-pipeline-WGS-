#!/usr/bin/env bash
# Step 2: quality check of the raw reads
source "$(dirname "$0")/config.sh"
fastqc -t "$THREADS" -o results/qc data/raw/${SRR}_1.fastq data/raw/${SRR}_2.fastq
