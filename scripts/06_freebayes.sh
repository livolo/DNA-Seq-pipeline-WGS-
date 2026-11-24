#!/usr/bin/env bash
# Step 6: call variants with FreeBayes
source "$(dirname "$0")/config.sh"
samtools faidx "$REF"
freebayes -f "$REF" data/aligned/${SRR}_RM.bam > results/variants/${SRR}.raw.vcf
