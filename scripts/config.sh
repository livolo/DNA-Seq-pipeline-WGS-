#!/usr/bin/env bash
# Shared settings for all steps. Edit these, then run the scripts in order.
set -euo pipefail
SRR="SRR34448914"                      # NCBI SRA run (D. melanogaster, SRX29609289)
THREADS=4
REF="reference/genome.fa"              # TODO: put your Drosophila reference FASTA here
ADAPTERS="reference/TruSeq3-PE.fa"     # TODO: adapter file you used for Trimmomatic
mkdir -p data/raw data/trimmed data/aligned results/qc results/variants
