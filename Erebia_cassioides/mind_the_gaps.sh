/data/camille/Mind_the_gaps
The repeat masked assemblies are there (not indexed):
/data/camille/Mind_the_gaps/assemblies/chrom.fasta
/data/camille/Mind_the_gaps/assemblies/draft.fasta



conda activate /data/camille/bin/miniconda3/envs/chromcomp

cd /data/kay/mindthegap/raw

cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_2713*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_2729*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_2707*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_2715*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_2705*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_2033*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_1824*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_1844*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_1845*.fastq.gz .
cp /legserv/NGS_data/Butterflies/Novaseq/*/*X_1825*.fastq.gz .


cat *X_2713*_R1_*.fastq.gz > X_2713_R1.fq.gz
cat *X_2729*_R1_*.fastq.gz > X_2729_R1.fq.gz
cat *X_2707*_R1_*.fastq.gz > X_2707_R1.fq.gz
cat *X_2715*_R1_*.fastq.gz > X_2715_R1.fq.gz
cat *X_2705*_R1_*.fastq.gz > X_2705_R1.fq.gz
cat *X_2033*_R1_*.fastq.gz > X_2033_R1.fq.gz
cat *X_1824*_R1_*.fastq.gz > X_1824_R1.fq.gz
cat *X_1844*_R1_*.fastq.gz > X_1844_R1.fq.gz
cat *X_1845*_R1_*.fastq.gz > X_1845_R1.fq.gz
cat *X_1825*_R1_*.fastq.gz > X_1825_R1.fq.gz


cat *X_2713*_R2_*.fastq.gz > X_2713_R2.fq.gz
cat *X_2729*_R2_*.fastq.gz > X_2729_R2.fq.gz
cat *X_2707*_R2_*.fastq.gz > X_2707_R2.fq.gz
cat *X_2715*_R2_*.fastq.gz > X_2715_R2.fq.gz
cat *X_2705*_R2_*.fastq.gz > X_2705_R2.fq.gz
cat *X_2033*_R2_*.fastq.gz > X_2033_R2.fq.gz
cat *X_1824*_R2_*.fastq.gz > X_1824_R2.fq.gz
cat *X_1844*_R2_*.fastq.gz > X_1844_R2.fq.gz
cat *X_1845*_R2_*.fastq.gz > X_1845_R2.fq.gz
cat *X_1825*_R2_*.fastq.gz > X_1825_R2.fq.gz




fastqc -t 4 *.fq.gz -o ../qc/fastqc


conda create --name multiqc
conda activate multiqc

multiqc ../qc/fastqc -o ../qc




#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 4
#SBATCH --mem=20G
#SBATCH --array=1-10


cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp


CMDFILE=/data/kay/mindthegap/raw/fastp.txt    # change this to the file with all the one-liners
CMD=$(sed -n ${SLURM_ARRAY_TASK_ID}p $CMDFILE)
eval $CMD


fastp -i X_2713_R1.fq.gz -I X_2713_R2.fq.gz -o X_2713_R1.trim.fq.gz -O X_2713_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_2713.fastp.html -j ../qc/X_2713.fastp.json
fastp -i X_2729_R1.fq.gz -I X_2729_R2.fq.gz -o X_2729_R1.trim.fq.gz -O X_2729_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_2729.fastp.html -j ../qc/X_2729.fastp.json
fastp -i X_2707_R1.fq.gz -I X_2707_R2.fq.gz -o X_2707_R1.trim.fq.gz -O X_2707_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_2707.fastp.html -j ../qc/X_2707.fastp.json
fastp -i X_2715_R1.fq.gz -I X_2715_R2.fq.gz -o X_2715_R1.trim.fq.gz -O X_2715_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_2715.fastp.html -j ../qc/X_2715.fastp.json
fastp -i X_2705_R1.fq.gz -I X_2705_R2.fq.gz -o X_2705_R1.trim.fq.gz -O X_2705_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_2705.fastp.html -j ../qc/X_2705.fastp.json
fastp -i X_2033_R1.fq.gz -I X_2033_R2.fq.gz -o X_2033_R1.trim.fq.gz -O X_2033_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_2033.fastp.html -j ../qc/X_2033.fastp.json
fastp -i X_1824_R1.fq.gz -I X_1824_R2.fq.gz -o X_1824_R1.trim.fq.gz -O X_1824_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_1824.fastp.html -j ../qc/X_1824.fastp.json
fastp -i X_1844_R1.fq.gz -I X_1844_R2.fq.gz -o X_1844_R1.trim.fq.gz -O X_1844_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_1844.fastp.html -j ../qc/X_1844.fastp.json
fastp -i X_1845_R1.fq.gz -I X_1845_R2.fq.gz -o X_1845_R1.trim.fq.gz -O X_1845_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_1845.fastp.html -j ../qc/X_1845.fastp.json
fastp -i X_1825_R1.fq.gz -I X_1825_R2.fq.gz -o X_1825_R1.trim.fq.gz -O X_1825_R2.trim.fq.gz -q 20 -u 30 -l 50 -g -h ../qc/X_1825.fastp.html -j ../qc/X_1825.fastp.json


# Indexing the references
# in /data/kay/mindthegap/assemblies

bwa index chrom.fasta
bwa index draft.fasta

samtools faidx chrom.fasta
samtools faidx draft.fasta

gatk CreateSequenceDictionary -R chrom.fasta
gatk CreateSequenceDictionary -R draft.fasta






# Extract metadata (flowcell ID, lane) for read‑group tags; helps when multiple libraries per sample need merging or when checking platform‑specific biases.
# Does not work

name=$(basename $fastq_1 | sed 's/X_2707_R1.trim.fq.gz//') # this might change based on your file
flowcell=$(zcat $fastq_1 | head -n 1 | cut -d ':' -f3) # this might change based on your file
lane=$(zcat $fastq_1 | head -n 1 | cut -d ':' -f4) # this might change based on your file




#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 8
#SBATCH --mem=8G
#SBATCH --array=1-20


cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp


CMDFILE=/data/kay/mindthegap/raw/bwa.txt    # change this to the file with all the one-liners
CMD=$(sed -n ${SLURM_ARRAY_TASK_ID}p $CMDFILE)
eval $CMD


bwa mem -M -t 8 ../assemblies/draft.fasta X_2707_R1.trim.fq.gz X_2707_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2707.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_2705_R1.trim.fq.gz X_2705_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2705.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_2713_R1.trim.fq.gz X_2713_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2713.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_2715_R1.trim.fq.gz X_2715_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2715.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_1845_R1.trim.fq.gz X_1845_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_1845.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_2729_R1.trim.fq.gz X_2729_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2729.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_1844_R1.trim.fq.gz X_1844_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_1844.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_1824_R1.trim.fq.gz X_1824_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_1824.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_2033_R1.trim.fq.gz X_2033_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2033.draft.bam
bwa mem -M -t 8 ../assemblies/draft.fasta X_1825_R1.trim.fq.gz X_1825_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_1825.draft.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_2707_R1.trim.fq.gz X_2707_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2707.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_2705_R1.trim.fq.gz X_2705_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2705.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_2713_R1.trim.fq.gz X_2713_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2713.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_2715_R1.trim.fq.gz X_2715_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2715.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_1845_R1.trim.fq.gz X_1845_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_1845.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_2729_R1.trim.fq.gz X_2729_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2729.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_1844_R1.trim.fq.gz X_1844_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_1844.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_1824_R1.trim.fq.gz X_1824_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_1824.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_2033_R1.trim.fq.gz X_2033_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_2033.chrom.bam
bwa mem -M -t 8 ../assemblies/chrom.fasta X_1825_R1.trim.fq.gz X_1825_R2.trim.fq.gz |  samtools sort -@8 -o ../bam/X_1825.chrom.bam



#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 1
#SBATCH --mem=8G
#SBATCH --array=1-20


cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp

samtools='/home/kay/software/samtools-1.21/samtools'

CMDFILE=/data/kay/mindthegap/raw/flagstat.txt    # change this to the file with all the one-liners
CMD=$(sed -n ${SLURM_ARRAY_TASK_ID}p $CMDFILE)
eval $CMD

$samtools flagstat ../bam/X_2707.draft.bam > ../qc/X_2707.draft.flagstat.txt
$samtools flagstat ../bam/X_2705.draft.bam > ../qc/X_2705.draft.flagstat.txt
$samtools flagstat ../bam/X_2713.draft.bam > ../qc/X_2713.draft.flagstat.txt
$samtools flagstat ../bam/X_2715.draft.bam > ../qc/X_2715.draft.flagstat.txt
$samtools flagstat ../bam/X_1845.draft.bam > ../qc/X_1845.draft.flagstat.txt
$samtools flagstat ../bam/X_2729.draft.bam > ../qc/X_2729.draft.flagstat.txt
$samtools flagstat ../bam/X_1844.draft.bam > ../qc/X_1844.draft.flagstat.txt
$samtools flagstat ../bam/X_1824.draft.bam > ../qc/X_1824.draft.flagstat.txt
$samtools flagstat ../bam/X_2033.draft.bam > ../qc/X_2033.draft.flagstat.txt
$samtools flagstat ../bam/X_1825.draft.bam > ../qc/X_1825.draft.flagstat.txt
$samtools flagstat ../bam/X_2707.chrom.bam > ../qc/X_2707.chrom.flagstat.txt
$samtools flagstat ../bam/X_2705.chrom.bam > ../qc/X_2705.chrom.flagstat.txt
$samtools flagstat ../bam/X_2713.chrom.bam > ../qc/X_2713.chrom.flagstat.txt
$samtools flagstat ../bam/X_2715.chrom.bam > ../qc/X_2715.chrom.flagstat.txt
$samtools flagstat ../bam/X_1845.chrom.bam > ../qc/X_1845.chrom.flagstat.txt
$samtools flagstat ../bam/X_2729.chrom.bam > ../qc/X_2729.chrom.flagstat.txt
$samtools flagstat ../bam/X_1844.chrom.bam > ../qc/X_1844.chrom.flagstat.txt
$samtools flagstat ../bam/X_1824.chrom.bam > ../qc/X_1824.chrom.flagstat.txt
$samtools flagstat ../bam/X_2033.chrom.bam > ../qc/X_2033.chrom.flagstat.txt
$samtools flagstat ../bam/X_1825.chrom.bam > ../qc/X_1825.chrom.flagstat.txt



# adding RG for gatk... 

samtools addreplacerg -@4 -r ID:S1 -r LB:draft -r SM:X_2707 -r PL:ILLUMINA  -o X_2707.draft.2.bam X_2707.draft.bam
samtools addreplacerg -@4 -r ID:S2 -r LB:draft -r SM:X_2705 -r PL:ILLUMINA  -o X_2705.draft.2.bam X_2705.draft.bam
samtools addreplacerg -@4 -r ID:S3 -r LB:draft -r SM:X_2713 -r PL:ILLUMINA  -o X_2713.draft.2.bam X_2713.draft.bam
samtools addreplacerg -@4 -r ID:S4 -r LB:draft -r SM:X_2715 -r PL:ILLUMINA  -o X_2715.draft.2.bam X_2715.draft.bam
samtools addreplacerg -@4 -r ID:S5 -r LB:draft -r SM:X_1845 -r PL:ILLUMINA  -o X_1845.draft.2.bam X_1845.draft.bam
samtools addreplacerg -@4 -r ID:S6 -r LB:draft -r SM:X_2729 -r PL:ILLUMINA  -o X_2729.draft.2.bam X_2729.draft.bam
samtools addreplacerg -@4 -r ID:S7 -r LB:draft -r SM:X_1844 -r PL:ILLUMINA  -o X_1844.draft.2.bam X_1844.draft.bam
samtools addreplacerg -@4 -r ID:S8 -r LB:draft -r SM:X_1824 -r PL:ILLUMINA  -o X_1824.draft.2.bam X_1824.draft.bam
samtools addreplacerg -@4 -r ID:S9 -r LB:draft -r SM:X_2033 -r PL:ILLUMINA  -o X_2033.draft.2.bam X_2033.draft.bam
samtools addreplacerg -@4 -r ID:S10 -r LB:draft -r SM:X_1825 -r PL:ILLUMINA -o X_1825.draft.2.bam X_1825.draft.bam
samtools addreplacerg -@4 -r ID:S1 -r LB:chrom -r SM:X_2707 -r PL:ILLUMINA  -o X_2707.chrom.2.bam X_2707.chrom.bam
samtools addreplacerg -@4 -r ID:S2 -r LB:chrom -r SM:X_2705 -r PL:ILLUMINA  -o X_2705.chrom.2.bam X_2705.chrom.bam
samtools addreplacerg -@4 -r ID:S3 -r LB:chrom -r SM:X_2713 -r PL:ILLUMINA  -o X_2713.chrom.2.bam X_2713.chrom.bam
samtools addreplacerg -@4 -r ID:S4 -r LB:chrom -r SM:X_2715 -r PL:ILLUMINA  -o X_2715.chrom.2.bam X_2715.chrom.bam
samtools addreplacerg -@4 -r ID:S5 -r LB:chrom -r SM:X_1845 -r PL:ILLUMINA  -o X_1845.chrom.2.bam X_1845.chrom.bam
samtools addreplacerg -@4 -r ID:S6 -r LB:chrom -r SM:X_2729 -r PL:ILLUMINA  -o X_2729.chrom.2.bam X_2729.chrom.bam
samtools addreplacerg -@4 -r ID:S7 -r LB:chrom -r SM:X_1844 -r PL:ILLUMINA  -o X_1844.chrom.2.bam X_1844.chrom.bam
samtools addreplacerg -@4 -r ID:S8 -r LB:chrom -r SM:X_1824 -r PL:ILLUMINA  -o X_1824.chrom.2.bam X_1824.chrom.bam
samtools addreplacerg -@4 -r ID:S9 -r LB:chrom -r SM:X_2033 -r PL:ILLUMINA  -o X_2033.chrom.2.bam X_2033.chrom.bam
samtools addreplacerg -@4 -r ID:S10 -r LB:chrom -r SM:X_1825 -r PL:ILLUMINA -o X_1825.chrom.2.bam X_1825.chrom.bam

#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 1
#SBATCH --mem=8G
#SBATCH --array=1-20


cd /data/kay/mindthegap/raw

conda init bash

conda activate /data/camille/bin/miniconda3/envs/chromcomp


CMDFILE=/data/kay/mindthegap/raw/markduplicates.txt    # change this to the file with all the one-liners
CMD=$(sed -n ${SLURM_ARRAY_TASK_ID}p $CMDFILE)
eval $CMD

gatk MarkDuplicates -I ../bam/X_2707.draft.2.bam -O ../bam/X_2707.draft.dedup.bam  -M ../qc/X_2707.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_2705.draft.2.bam -O ../bam/X_2705.draft.dedup.bam  -M ../qc/X_2705.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_2713.draft.2.bam -O ../bam/X_2713.draft.dedup.bam  -M ../qc/X_2713.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_2715.draft.2.bam -O ../bam/X_2715.draft.dedup.bam  -M ../qc/X_2715.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_1845.draft.2.bam -O ../bam/X_1845.draft.dedup.bam  -M ../qc/X_1845.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_2729.draft.2.bam -O ../bam/X_2729.draft.dedup.bam  -M ../qc/X_2729.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_1844.draft.2.bam -O ../bam/X_1844.draft.dedup.bam  -M ../qc/X_1844.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_1824.draft.2.bam -O ../bam/X_1824.draft.dedup.bam  -M ../qc/X_1824.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_2033.draft.2.bam -O ../bam/X_2033.draft.dedup.bam  -M ../qc/X_2033.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_1825.draft.2.bam -O ../bam/X_1825.draft.dedup.bam  -M ../qc/X_1825.draft.dup.txt
gatk MarkDuplicates -I ../bam/X_2707.chrom.2.bam -O ../bam/X_2707.chrom.dedup.bam  -M ../qc/X_2707.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_2705.chrom.2.bam -O ../bam/X_2705.chrom.dedup.bam  -M ../qc/X_2705.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_2713.chrom.2.bam -O ../bam/X_2713.chrom.dedup.bam  -M ../qc/X_2713.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_2715.chrom.2.bam -O ../bam/X_2715.chrom.dedup.bam  -M ../qc/X_2715.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_1845.chrom.2.bam -O ../bam/X_1845.chrom.dedup.bam  -M ../qc/X_1845.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_2729.chrom.2.bam -O ../bam/X_2729.chrom.dedup.bam  -M ../qc/X_2729.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_1844.chrom.2.bam -O ../bam/X_1844.chrom.dedup.bam  -M ../qc/X_1844.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_1824.chrom.2.bam -O ../bam/X_1824.chrom.dedup.bam  -M ../qc/X_1824.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_2033.chrom.2.bam -O ../bam/X_2033.chrom.dedup.bam  -M ../qc/X_2033.chrom.dup.txt
gatk MarkDuplicates -I ../bam/X_1825.chrom.2.bam -O ../bam/X_1825.chrom.dedup.bam  -M ../qc/X_1825.chrom.dup.txt


samtools index X_2707.draft.dedup.bam
samtools index X_2707.chrom.dedup.bam
samtools index X_2705.chrom.dedup.bam
samtools index X_2705.draft.dedup.bam
samtools index X_1845.draft.dedup.bam
samtools index X_2715.draft.dedup.bam
samtools index X_2713.chrom.dedup.bam
samtools index X_2715.chrom.dedup.bam
samtools index X_2713.draft.dedup.bam
samtools index X_2729.draft.dedup.bam
samtools index X_1825.draft.dedup.bam
samtools index X_1845.chrom.dedup.bam
samtools index X_1824.chrom.dedup.bam
samtools index X_1825.chrom.dedup.bam
samtools index X_1824.draft.dedup.bam
samtools index X_2033.chrom.dedup.bam
samtools index X_2033.draft.dedup.bam
samtools index X_1844.chrom.dedup.bam
samtools index X_2729.chrom.dedup.bam

samtools index X_1844.draft.dedup.bam



#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 1
#SBATCH --mem=8G
#SBATCH --array=1-20


cd /data/kay/mindthegap/raw

conda init bash

conda activate /data/camille/bin/miniconda3/envs/chromcomp


CMDFILE=/data/kay/mindthegap/raw/haplocaller.txt    # change this to the file with all the one-liners
CMD=$(sed -n ${SLURM_ARRAY_TASK_ID}p $CMDFILE)
eval $CMD

gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_1824.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_1824.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_1825.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_1825.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_1844.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_1844.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_1845.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_1845.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_2033.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_2033.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_2705.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_2705.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_2707.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_2707.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_2713.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_2713.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_2715.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_2715.chrom.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/chrom.fasta -I ../bam/X_2729.chrom.dedup.bam -ERC GVCF -O ../gvcf/X_2729.chrom.g.vcf.gz

gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_1824.draft.dedup.bam -ERC GVCF -O ../gvcf/X_1824.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_1825.draft.dedup.bam -ERC GVCF -O ../gvcf/X_1825.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_1844.draft.dedup.bam -ERC GVCF -O ../gvcf/X_1844.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_1845.draft.dedup.bam -ERC GVCF -O ../gvcf/X_1845.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_2033.draft.dedup.bam -ERC GVCF -O ../gvcf/X_2033.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_2705.draft.dedup.bam -ERC GVCF -O ../gvcf/X_2705.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_2707.draft.dedup.bam -ERC GVCF -O ../gvcf/X_2707.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_2713.draft.dedup.bam -ERC GVCF -O ../gvcf/X_2713.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_2715.draft.dedup.bam -ERC GVCF -O ../gvcf/X_2715.draft.g.vcf.gz
gatk HaplotypeCaller -R ../assemblies/draft.fasta -I ../bam/X_2729.draft.dedup.bam -ERC GVCF -O ../gvcf/X_2729.draft.g.vcf.gz




#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 8
#SBATCH --mem=32G

cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp

gatk CombineGVCFs -R ../assemblies/draft.fasta -V /data/kay/mindthegap/gvcf/X_1824.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_1825.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_1844.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_1845.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2033.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2705.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2707.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2713.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2715.draft.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2729.draft.g.vcf.gz -O cohort.draft.g.vcf.gz


#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 8
#SBATCH --mem=32G

cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp

gatk CombineGVCFs -R ../assemblies/chrom.fasta -V /data/kay/mindthegap/gvcf/X_1824.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_1825.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_1844.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_1845.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2033.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2705.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2707.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2713.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2715.chrom.g.vcf.gz -V /data/kay/mindthegap/gvcf/X_2729.chrom.g.vcf.gz -O cohort.chrom.g.vcf.gz






#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 4
#SBATCH --mem=12G

cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp

gatk GenotypeGVCFs -R ../assemblies/chrom.fasta -V cohort.chrom.g.vcf.gz -O cohort.chrom.raw.vcf.gz






#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 4
#SBATCH --mem=12G

cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp

gatk GenotypeGVCFs -R ../assemblies/draft.fasta -V cohort.draft.g.vcf.gz -O cohort.draft.raw.vcf.gz




#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 4
#SBATCH --mem=12G

cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp

gatk VariantFiltration -R ../assemblies/draft.fasta -V cohort.draft.raw.vcf.gz --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0" --filter-name "basic_snp_filter" -O cohort.draft.flt.vcf.gz


#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 4
#SBATCH --mem=12G

cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp

gatk VariantFiltration -R ../assemblies/chrom.fasta -V cohort.chrom.raw.vcf.gz --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0" --filter-name "basic_snp_filter" -O cohort.chrom.flt.vcf.gz








#!/bin/bash
#SBATCH -p normal.168h
#SBATCH -c 4
#SBATCH --mem=12G

cd /data/kay/mindthegap/raw

conda activate /data/camille/bin/miniconda3/envs/chromcomp

bcftools view -f PASS -m2 -M2 -v snps cohort.draft.flt.vcf.gz | vcftools --vcf - --max-missing 0.8 --maf 0.05 --min-alleles 2 --max-alleles 2 --recode --recode-INFO-all --out cohort.draft.final
bgzip -c cohort.draft.final.vcf > cohort.draft.final.vcf.gz
tabix -p vcf cohort.draft.final.vcf.gz



bcftools view -f PASS -m2 -M2 -v snps cohort.chrom.flt.vcf.gz | vcftools --vcf - --max-missing 0.8 --maf 0.05 --min-alleles 2 --max-alleles 2 --recode --recode-INFO-all --out cohort.chrom.final
bgzip -c cohort.chrom.final.vcf > cohort.chrom.final.vcf.gz
tabix -p vcf cohort.chrom.final.vcf.gz




plink2 --vcf cohort.draft.final.recode.vcf.gz --allow-extra-chr --set-all-var-ids @:#:\$r:\$a --make-pgen --out cohort_draft_fixed_ids
plink2 --pfile cohort_draft_fixed_ids --allow-extra-chr --bad-ld  --indep-pairwise 50 5 0.2 --out pruned_draft
plink2 --vcf cohort.draft.final.recode.vcf.gz --extract pruned_draft.prune.in --pca 20 --allow-extra-chr --out pca_draft

plink2 --pfile cohort_draft_fixed_ids --extract pruned_draft.prune.in --allow-extra-chr --pca 20 --out pca_draft

plink2 --vcf cohort.draft.final.recode.vcf.gz --allow-extra-chr --set-all-var-ids @:#:\$r:\$a --extract pruned_draft.prune.in --pca 20 --out pca_draft

plink2 --vcf cohort.draft.final.recode.vcf.gz --allow-extra-chr --set-all-var-ids @:#[b2] --bad-ld --indep-pairwise 50 10 0.2 --out pruned_draft
plink2 --vcf cohort.chrom.final.recode.vcf.gz --allow-extra-chr --set-all-var-ids @:#[b2] --bad-ld --indep-pairwise 50 10 0.2 --out pruned_chrom


plink2 --vcf cohort.draft.final.recode.vcf.gz --extract pruned_draft2.prune.in --pca 20 --allow-extra-chr --out pca_draft



plink2 --vcf cohort.draft.final.recode.vcf.gz --allow-extra-chr --set-all-var-ids @:#:\$r:\$a --make-pgen --out cohort_draft_fixed_ids
plink2 --pfile cohort_draft_fixed_ids --allow-extra-chr --bad-ld  --indep-pairwise 50 5 0.2 --out pruned_draft
plink2 --pfile cohort_draft_fixed_ids --allow-extra-chr --freq --out cohort_draft_freq
plink2 --pfile cohort_draft_fixed_ids --extract pruned_draft.prune.in --read-freq cohort_draft_freq.afreq --allow-extra-chr --pca 10 --out pca_draft

plink2 --vcf cohort.chrom.final.recode.vcf.gz --allow-extra-chr --set-all-var-ids @:#:\$r:\$a --make-pgen --out cohort_chrom_fixed_ids
plink2 --pfile cohort_chrom_fixed_ids --allow-extra-chr --bad-ld  --indep-pairwise 50 5 0.2 --out pruned_chrom
plink2 --pfile cohort_chrom_fixed_ids --allow-extra-chr --freq --out cohort_chrom_freq
plink2 --pfile cohort_chrom_fixed_ids --extract pruned_chrom.prune.in --read-freq cohort_chrom_freq.afreq --allow-extra-chr --pca 10 --out pca_chrom




vcftools --gzvcf cohort.draft.final.recode.vcf.gz --site-pi --out pi_draft
vcftools --gzvcf cohort.chrom.final.recode.vcf.gz --site-pi --out pi_chrom


vcftools --gzvcf cohort.draft.final.recode.vcf.gz --het --out het_draft
vcftools --gzvcf cohort.chrom.final.recode.vcf.gz --het --out het_chrom

#CA7 -pop2
X_2033
X_1824
X_1844
X_1845
X_1825

#CA1 - pop1
X_2713
X_2729
X_2707
X_2715
X_2705


vcftools --gzvcf cohort.draft.final.recode.vcf.gz --weir-fst-pop pop1.txt --weir-fst-pop pop2.txt --out fst_draft
vcftools --gzvcf cohort.chrom.final.recode.vcf.gz --weir-fst-pop pop1.txt --weir-fst-pop pop2.txt --out fst_chrom


