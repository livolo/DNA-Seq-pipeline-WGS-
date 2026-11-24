#!/usr/bin/env bash
# Step 3: remove adapters and low-quality bases, then re-check quality
source "$(dirname "$0")/config.sh"
trimmomatic PE -threads "$THREADS" \
  data/raw/${SRR}_1.fastq data/raw/${SRR}_2.fastq \
  data/trimmed/${SRR}_1_paired.fastq data/trimmed/${SRR}_1_unpaired.fastq \
  data/trimmed/${SRR}_2_paired.fastq data/trimmed/${SRR}_2_unpaired.fastq \
  ILLUMINACLIP:"$ADAPTERS":2:30:10 SLIDINGWINDOW:4:20 MINLEN:36   # TODO: match your settings
fastqc -t "$THREADS" -o results/qc \
  data/trimmed/${SRR}_1_paired.fastq data/trimmed/${SRR}_2_paired.fastq
