#!/usr/bin/env bash
# Step 5: sort by coordinate, remove PCR duplicates, index the BAM
source "$(dirname "$0")/config.sh"
samtools sort -@ "$THREADS" -o data/aligned/${SRR}.sorted.bam data/aligned/${SRR}.sam
picard MarkDuplicates \
  -I data/aligned/${SRR}.sorted.bam \
  -O data/aligned/${SRR}_RM.bam \
  -M results/qc/${SRR}_dup_metrics.txt \
  --REMOVE_DUPLICATES true
samtools index data/aligned/${SRR}_RM.bam
