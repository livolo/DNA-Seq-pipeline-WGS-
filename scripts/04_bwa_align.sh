#!/usr/bin/env bash
# Step 4: index the reference and align reads with BWA-MEM
source "$(dirname "$0")/config.sh"
[ -f "$REF.bwt" ] || bwa index "$REF"
bwa mem -t "$THREADS" -R "@RG\tID:${SRR}\tSM:${SRR}\tPL:ILLUMINA" "$REF" \
  data/trimmed/${SRR}_1_paired.fastq data/trimmed/${SRR}_2_paired.fastq \
  > data/aligned/${SRR}.sam
