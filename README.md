What is Whole Genome Sequencing (WGS)?
Whole genome sequencing (WGS) is a laboratory technique used to determine the entire DNA sequence of an organism’s genome, covering both the coding and non-coding regions. This means that every single nucleotide (the building blocks of DNA: A, T, C, G) in the genome is mapped, providing a complete genetic “blueprint” of a person, animal, plant, or microbe.

EXPERIMENT—DNA-Seq of Drosophila melanogaster: Adult Whole Body (SRX29609289)
From NCBI-SRA—
Type → Whole Genome Sequencing (WGS) of Drosophila melanogaster.
Library layout→ Paired-end reads (two FASTQ files per sample: _1.fastq.gz and _2.fastq.gz).
Instrument→ Illumina NovaSeq 6000 (produces high-quality, short reads).
Read count→ ~33 million read pairs (32,960,967 spots).
Genome size (D. melanogaster) → ~180 Mb → So 3.3 Gb total bases ≈ ~18× coverage.
Selection → PCR (so you’ll have some duplicates → makes the MarkDuplicates step important).
Sex male
Tissue whole body
Library preparation → NEBNext Ultra II DNA Library Prep Kit → standard for WGS.

Tools Required
This workflow covers the steps for processing whole genome sequencing data—from SRA data download

NGS Pipeline Tools
Step/Function	Tool/Utility	Installation Command
Data download	SRA Toolkit	conda install sra-tools
Quality check	FastQC	conda install fastqc
Trimming	Trimmomatic	conda install trimmomatic
Alignment	BWA	conda install bwa
SAM/BAM handling	Samtools	conda install samtools
Duplicate removal	Picard	conda install picard
Variant calling	FreeBayes	conda install freebayes
VCF manipulation	BCFtools	conda install bcftools
Filtering & scripting	awk	Default in Linux
Download/unpack files	wget/curl	Default in Linux/macOS
STEPS:-
Download data from NCBI-SRA SRX29609289, which is the accession number for a specific sequencing experiment submitted to the NCBI Sequence Read Archive (SRA) and PRJNA1285438 is the unique accession number for a BioProject at NCBI, and SRR34448914 is a unique SRA Run accession number
Command:fastq-dump --split-files --gzip SRR34448914 Output file:-fastq.gz
This command will give sample SRR34448914_1.fastq.gz and SRR34448914_2.fastq.gz
Quality control (A) Quality Check using FastQC
(B) Trimming Using Trimmomatic

(A) Quality check using fastQC
Command:-/media/kirti/HD/ASSIGNMENT/SDA/tools/FastQC/fastqc /media/kirti/HD/ASSIGNMENT/SDA/raw_reads/SRR34448914_1.fastq.gz -o /media/kirti/HD/ASSIGNMENT/SDA/fastqc/before1
Output:-.html file
Here, we run FastQC to know the quality of our sample, so when we run, we get............
(B)Trimming Using Trimmomatic
Commands:- java -jar /media/kirti/HD/ASSIGNMENT/SDA/tools/Trimmomatic-0.36/trimmomatic-0.36.jar PE
/media/kirti/HD/ASSIGNMENT/SDA/raw_reads/SRR34448914_1.fastq.gz
/media/kirti/HD/ASSIGNMENT/SDA/raw_reads/SRR34448914_2.fastq.gz
SRR34448914_1_paired.fastq.gz SRR34448914_1_unpaired.fastq.gz SRR34448914_2_paired.fastq.gz SRR34448914_2_unpaired.fastq.gz ILLUMINACLIP:/media/kirti/HD/ASSIGNMENT/SDA/tools/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:30:10 LEADING: 3 TRAILING: 3 SLIDINGWINDOW: 4:15 MINLEN:50
Output file:-SRR34448914_1_paired.fastq.gz SRR34448914_1_unpaired.fastq.gz SRR34448914_2_paired.fastq.gz SRR34448914_2_unpaired.fastq.gz
Re-run the quality check:-after trimming
Command:-/media/kirti/HD/ASSIGNMENT/SDA/tools/FastQC/fastqc /media/kirti/HD/ASSIGNMENT/SDA/raw_reads/SRR34448914_1.fastq.gz -o /media/kirti/HD/ASSIGNMENT/SDA/fastqc/after1
SO NOW HERE, EVEN AFTER TRIMMING, THE RESULT HAS GC CONTENT AND OVERREPRESENTED SEQ
SO WE CAN NOW RUN ,
Commands:(NEW) kirti@kirti-Extensa-215-52:~/Desktop/SDA/trimming2$ java -jar /home/kirti/Desktop/SDA/tools/Trimmomatic-0.36/trimmomatic-0.36.jar PE /home/kirti/Desktop/SDA/raw_reads/SRR34448914_1.fastq.gz /home/kirti/Desktop/SDA/raw_reads/SRR34448914_2.fastq.gz paired_seq_ 1.fastq.gz unpaired_seq_ 1.fastq.gz paired_seq_ 2.fastq.gz unpaired_seq_ 2.fastq.gz ILLUMINACLIP:/home/kirti/Desktop/SDA/tools/Trimmomatic-0.36/adapters/trim1.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
Re-run quality check
Commands:-/home/kirti/Desktop/SDA/tools/FastQC/fastqc /home/kirti/Desktop/SDA/trimming3/SRR34448914_1_PAIR_TRIMMED2.fastq.gz -o /home/kirti/Desktop/SDA/fastqc/after2
Now we want a reference genome and an annotated genome for Drosophila melanogaster.
Reference Genome: Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa.gz
Annotated Genome: Drosophila_melanogaster.BDGP6.46.111.gtf.gz
In tools,
Download bwa:
git clone https://github.com/lh3/bwa.git cd bwa
make
Install samtools:
sudo apt install samtools
Download picard tools:
git clone https://github.com/broadinstitute/picard.git
./gradlew shadowJar

Alignment
A) Indexing of Reference Genome
Commands:-
Indexing of reference genome:/media/kirti/HD/ASSIGNMENT/SDA/tools/bwa/bwa index /media/kirti/HD/ASSIGNMENT/SDA/whole_genome/Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa.gz
Output file - fa.fai
B) Mapping
Commands:-
In bwa folder, /media/kirti/HD/ASSIGNMENT/SDA/tools/bwa/bwa mem -t 6 -R '@RG\tID:14\tSM:14'/media/kirti/HD/ASSIGNMENT/SDA/whole_genome Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa.gz/media/kirti/HD/ASSIGNMENT/SDA/trimming2/paired_seq_1.fastq.gz /media/kirti/HD/ASSIGNMENT SDA/trimming2/paired_seq_2.fastq.gz > /media/kirti/HD/ASSIGNMENT/SDA/bwa/SRR34448914.sam
Output file - SRR34448914.sam
Post-Alignment process
(A) Sorting
Commands:-samtools sort -o SRR34448914.sorted.bam SRR34448914.sam
(B) Marking & Removal of Duplicates
Commands:-java -jar /media/kirti/HD/ASSIGNMENT/SDA/tools/picard/build/libs/picard.jar MarkDuplicates -I/media/kirti/HD/ASSIGNMENT/SDA/bwa SRR34448914.sorted.bam -O SRR34448914_RM.bam -M marked_metrics.txt--REMOVE_DUPLICATES
Filtering
Commands:-
Index—samtools faidx Homo_sapiens.GRCh38.dna.primary_assembly.fa | samtools index SRR34448914_RM.bam
freebayes -f /media/kirti/HD/ASSIGNMENT/SDA/whole_genome/Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa -r 8 /media/kirti/HD/ASSIGNMENT SDA/remove_duplicate/SRR34448914_RM.bam > whole_genomeseq.vcf
bcftools filter -i 'QUAL>30 && DP>10 && DP<100 && MQ>40' wholegenomeseq.vcf -o variants_filtered.vcf
bcftools view -g ^het variants_filtered.vcf > wholegenome_Hom.vcf
Annotation & Visualization: Download IGV on Linux.
Check Java Requirement
IGV (desktop) is a Java application, so you’ll need Java 11+ installed.Check if Java is installed:
java -version If not installed:
sudo apt update
sudo apt install openjdk-17-jre
Download IGV
Go to the official Broad Institute IGV page:
https://software.broadinstitute.org/software/igv/download Or download via terminal (example for version 2.16.2): wget https://data.broadinstitute.org/igv/projects/downloads/2.16/IGV_Linux_2.16.2_WithJava.zip
Extract the ZIP
unzip IGV_Linux_2.16.2_WithJava.zip
cd IGV_Linux_2.16.2
Run IGV
./igv.sh and run - bash igv.sh

Annotation: The experiment focuses on the vermilion mutant, a classical Drosophila eye-color mutation that produces orange eyes due to disruption in the vermilion gene (FBgn0003965), which encodes tryptophan 2,3-dioxygenase, an enzyme essential for ommochrome pigment biosynthesis. The vermilion gene is located on the X chromosome at chrX:10,923,972–10,925,631 (dm6 assembly), and mutations in this locus often result from single nucleotide changes, small indels, or insertions of transposable elements upstream of the gene.

Mutants gene: This BAM file can then be loaded into a genome browser such as IGV (Integrative Genomics Viewer) along with the reference genome. Once the genome and reads are loaded, you can navigate directly to the vermilion gene locus on the X chromosome (chrX:10,923,972–10,925,631 in dm6). In IGV, potential mutations will appear as mismatched bases (colored letters against the reference), small insertions or deletions, or clusters of soft-clipped or discordant reads, which may indicate larger structural changes or transposable element insertions.