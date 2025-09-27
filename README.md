# <b>What is Whole Genome Sequencing (WGS)?</b>
<br>
Whole genome sequencing (WGS) is a laboratory technique used to determine the entire DNA sequence of an organism’s genome, covering both the coding and non-coding regions. This means that every single nucleotide (the building blocks of DNA: A, T, C, G) in the genome is mapped, providing a complete genetic “blueprint” of a person, animal, plant, or microbe.
<br>
<b>EXPERIMENT—DNA-Seq of Drosophila melanogaster:</b><br>
Adult Whole Body (SRX29609289)<br>
From NCBI-SRA—<br>
<b>Type →</b> Whole Genome Sequencing (WGS) of Drosophila melanogaster.<br>
<b>Library layout →</b> Paired-end reads (two FASTQ files per sample: _1.fastq.gz and _2.fastq.gz).<br>
<b>Instrument →</b> Illumina NovaSeq 6000 (produces high-quality, short reads).<br>
<b>Read count →</b> ~33 million read pairs (32,960,967 spots).<br>
<b>Genome size (D. melanogaster) → </b>~180 Mb → So 3.3 Gb total bases ≈ ~18× coverage.<br>
<b>Selection →</b> PCR (so you’ll have some duplicates → makes the MarkDuplicates step important).<br>
Sex male <br>
Tissue whole body<br>
<b>Library preparation →</b> NEBNext Ultra II DNA Library Prep Kit → standard for WGS.<br>

## NGS Pipeline Tools
This workflow covers the steps for processing whole genome sequencing data—from SRA data download

| Step / Function        | Tool / Utility  | Installation Command          |
|------------------------|-----------------|-------------------------------|
| Data download          | SRA Toolkit     | `conda install sra-tools`     |
| Quality check          | FastQC          | `conda install fastqc`        |
| Trimming               | Trimmomatic     | `conda install trimmomatic`   |
| Alignment              | BWA             | `conda install bwa`           |
| SAM/BAM handling       | Samtools        | `conda install samtools`      |
| Duplicate removal      | Picard          | `conda install picard`        |
| Variant calling        | FreeBayes       | `conda install freebayes`     |
| VCF manipulation       | BCFtools        | `conda install bcftools`      |
| Filtering & scripting  | awk             | Default in Linux              |
| Download/unpack files  | wget / curl     | Default in Linux/macOS        |

# STEPS:-
<b>Download data </b>
from NCBI-SRA SRX29609289, which is the accession number for a specific sequencing experiment submitted to the NCBI Sequence Read Archive (SRA) and PRJNA1285438 is the unique accession number for a BioProject at NCBI, and SRR34448914 is a unique SRA Run accession number.These files contain paired-end sequencing reads retrieved from the NCBI Sequence Read Archive (SRA) using the SRA accession SRR34448914Each file is in compressed FASTQ format (*.fastq.gz), a standard for storing high-throughput sequencing reads and associated base quality scores.Each entry in a FASTQ file consists of four lines:<br>
1.)Sequence identifier (beginning with @)<br>
2.)Nucleotide sequence<br>
3.)Separator line (beginning with +)<br>
4.)Quality string (ASCII-encoded Phred scores, one character per base)<br>
<b>Quality control</b> 
(A) Quality Check using FastQC , (B) Trimming Using Trimmomatic
<br>
<b>(A) Quality check using fastQC</b>
<br>
When FastQC is run on raw sequencing data, it produces an HTML report that offers a comprehensive assessment of data quality through modular graphical summaries. The report begins with basic statistics about the sample, such as the file name, quality score encoding, total number of reads, read length distribution, and GC content, enabling researchers to verify fundamental properties and the sequencing platform’s performance.One central feature of the report is the “per base sequence quality” plot, which displays box-and-whisker graphs for each position in the read, summarizing the distribution of Phred quality scores across all sequences. This visualization helps reveal trends in base call quality, flagging any positions with consistently low confidence which may indicate technical issues during sequencing or sample preparation.
Here, we run FastQC to know the quality of our sample, so when we run, we get............<br>
<b>(B)Trimming Using Trimmomatic</b>
Trimmomatic processes both mates in each read pair while maintaining pairing information across the resultant output files. A typical workflow involves the ILLUMINACLIP step, where adapter sequences specific to the sequencing protocol (such as Illumina TruSeq3) are identified and removed. Further refinement is achieved through parameter settings like LEADING and TRAILING, which trim low-quality bases from the start and end of reads, respectively, and SLIDINGWINDOW, which continuously checks read quality within a sliding window and trims regions where the average quality drops below a threshold. The MINLEN parameter ensures that only reads of sufficient length after trimming are retained, discarding very short or heavily trimmed reads.
<br>
SO NOW HERE, EVEN AFTER TRIMMING, THE RESULT HAS GC CONTENT AND OVERREPRESENTED SEQ<br>
SO WE CAN NOW RUN ,<br>
After trimming, the remaining paired and unpaired reads are stored in separate output files. A quality check with FastQC, performed on these trimmed files, typically reveals improvements in general sequence quality and base composition. However, it is not uncommon to still observe certain anomalies—such as irregular GC content or the presence of overrepresented sequences—in the FastQC report even after aggressive trimming. GC content outliers may reflect biological characteristics or technical artifacts from library preparation, while persistent overrepresented sequences could be due to incomplete adapter removal, intrinsic sequence bias, or presence of abundant natural sequences in the sample. If these issues remain, rerunning Trimmomatic with a custom or alternative adapter file may help, as shown with the subsequent command using trim1.fa.<br>
Now we want a reference genome and an annotated genome for Drosophila melanogaster.<br>
Reference Genome: Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa.gz<br>
Annotated Genome: Drosophila_melanogaster.BDGP6.46.111.gtf.gz<br>
In tools,<br>
Download bwa:<br>
git clone https://github.com/lh3/bwa.git cd bwa<br>
make<br>
Install samtools:<br>
sudo apt install samtools<br>
Download picard tools:<br>
git clone https://github.com/broadinstitute/picard.git<br>
./gradlew shadowJar<br>

<b>Alignment</b><br>
<b>A) Indexing of Reference Genome</b><br>
The alignment process begins with indexing the reference genome—essential for efficient searching and alignment. Using the bwa index command on the Drosophila melanogaster reference, the software constructs an FM-index based on the Burrows-Wheeler Transform, and outputs several index files (including the .fai), which together allow rapid query and matching of reads against the reference during the mapping step.<br>
<b>B) Mapping</b><br>
Mapping follows by running bwa mem with the indexed reference and the paired, trimmed FASTQ files produced earlier. The BWA-MEM algorithm performs local alignments, efficiently handling both longer and shorter reads, and incorporates read group information with the -R option to enable downstream sample tracking and troubleshooting.<br>
<b>Post-Alignment process</b><br>
<b>(A) Sorting</b><br>
After alignment, the first post-alignment step is sorting the SAM file, which is done using Samtools with the command samtools sort -o SRR34448914.sorted.bam SRR34448914.sam. Sorting reorders the aligned reads based on their genomic coordinates, which is essential for efficient downstream processing such as indexing and variant calling. The sorted file format is BAM, a compressed binary format that facilitates speedy access and reduced storage compared to text SAM files.<br>
<b>(B) Marking & Removal of Duplicates</b><br>
Next, duplicate reads generated during PCR amplification or sequencing artifacts are marked and optionally removed using Picard's MarkDuplicates tool. The command java -jar picard.jar MarkDuplicates specifies the input sorted BAM file and outputs a new BAM file with duplicates marked or removed (with --REMOVE_DUPLICATES flag). Marking duplicates helps to avoid biases in variant calling and other analyses caused by overrepresented reads from the same original DNA molecule. Picard also generates a metrics file summarizing the number of duplicates found and removed.<br>
<b>Filtering</b>
The post-alignment filtering process begins with the indexing of the reference genome FASTA file using samtools faidx. This creates an index file (.fai) that enables rapid and random access to specific regions of the reference during subsequent steps such as variant calling. The BAM alignment file with duplicates removed (SRR34448914_RM.bam) is then indexed to facilitate fast access for variant callers and visualization tools.Variant calling is performed using FreeBayes, which takes the indexed reference genome and the duplicate-removed BAM file as input, and generates a variant call format (VCF) file detailing the identified genomic variants relative to the reference sequence.<br>
<b>Annotation & Visualization: Download IGV on Linux.</b>
Check Java Requirement<br>
IGV (desktop) is a Java application, so you’ll need Java 11+ installed.Check if Java is installed:<br>
java -version If not installed:<br>
sudo apt update<br>
sudo apt install openjdk-17-jre<br>
Download IGV<br>
Go to the official Broad Institute IGV page:<br>
https://software.broadinstitute.org/software/igv/download Or download via terminal (example for version 2.16.2): wget https://data.broadinstitute.org/igv/projects/downloads/2.16/IGV_Linux_2.16.2_WithJava.zip
Extract the ZIP<br>
unzip IGV_Linux_2.16.2_WithJava.zip<br>
cd IGV_Linux_2.16.2<br>
Run IGV<br>
./igv.sh and run - bash igv.sh
<br>
<b>Annotation:</b> The experiment focuses on the vermilion mutant, a classical Drosophila eye-color mutation that produces orange eyes due to disruption in the vermilion gene (FBgn0003965), which encodes tryptophan 2,3-dioxygenase, an enzyme essential for ommochrome pigment biosynthesis. The vermilion gene is located on the X chromosome at chrX:10,923,972–10,925,631 (dm6 assembly), and mutations in this locus often result from single nucleotide changes, small indels, or insertions of transposable elements upstream of the gene.
<br>
<b>Mutants gene:</b> This BAM file can then be loaded into a genome browser such as IGV (Integrative Genomics Viewer) along with the reference genome. Once the genome and reads are loaded, you can navigate directly to the vermilion gene locus on the X chromosome (chrX:10,923,972–10,925,631 in dm6). In IGV, potential mutations will appear as mismatched bases (colored letters against the reference), small insertions or deletions, or clusters of soft-clipped or discordant reads, which may indicate larger structural changes or transposable element insertions.