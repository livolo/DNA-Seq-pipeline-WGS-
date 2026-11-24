#!/usr/bin/env bash
# Step 7: keep only reliable variants
source "$(dirname "$0")/config.sh"
bcftools filter -i 'QUAL>=30 && INFO/DP>=10' \
  results/variants/${SRR}.raw.vcf -o results/variants/${SRR}.filtered.vcf   # TODO: match your filter
bcftools stats results/variants/${SRR}.filtered.vcf > results/variants/${SRR}.stats.txt
