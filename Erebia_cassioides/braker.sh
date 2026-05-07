#!/bin/bash

#SBATCH -p normal.168h
#SBATCH -c 16
#SBATCH --mem=120G
#SBATCH -J braker
#SBATCH -o /data/camille/Mind_the_gaps/braker/braker.out

cd /data/camille/Mind_the_gaps/braker
OUTDIR=/data/camille/Mind_the_gaps/braker
mkdir $OUTDIR/draft
mkdir $OUTDIR/chrom

source /data/camille/bin/miniconda3/etc/profile.d/conda.sh
conda activate chromcomp

### Need to copy Augustus from the singularity container to working dir
# singularity exec braker3_lr.sif cp -r /opt/Augustus/include braker/draft
# singularity exec braker3_lr.sif cp -r /opt/Augustus/include braker/chrom

### Copying reference genome in wd
#cp /data/camille/Mind_the_gaps/assemblies/draft.fasta.masked $OUTDIR/draft
DRAFT=$OUTDIR/draft/draft.fasta.masked
#cp /data/camille/Mind_the_gaps/assemblies/chrom.fasta.masked $OUTDIR/chrom
CHROM=$OUTDIR/chrom/chrom.fasta.masked

READS=$OUTDIR/X3529_reads.fastq
PROT=$OUTDIR/Arthropoda.fa #odb12 downloaded from https://bioinf.uni-greifswald.de/bioinf/partitioned_odb12

### Map the reads to the reference

minimap2 -t 16 -ax splice:hq -uf $DRAFT $READS > $OUTDIR/draft/draft.sam     
samtools view -bS --threads 16 $OUTDIR/draft/draft.sam -o $OUTDIR/draft/draft.bam
rm $OUTDIR/draft/draft.sam
minimap2 -t 16 -ax splice:hq -uf $CHROM $READS > $OUTDIR/chrom/chrom.sam     
samtools view -bS --threads 16 $OUTDIR/chrom/chrom.sam -o $OUTDIR/chrom/chrom.bam
rm $OUTDIR/chrom/chrom.sam

### Pull the container (once)
# singularity build braker3_lr.sif docker://teambraker/braker3:isoseq

### Run BRAKER adapter for long reads + protein db
AUGUSTUS_CONFIG_PATH=$OUTDIR/config

singularity exec -B ${PWD}:${PWD},${AUGUSTUS_CONFIG_PATH}:${AUGUSTUS_CONFIG_PATH} /data/camille/Mind_the_gaps/braker3_lr.sif braker.pl --workingdir=$OUTDIR/draft/ \
    --genome=$DRAFT --prot_seq=$PROT --useexisting --species=draft --bam=$OUTDIR/draft/draft.bam --threads=16 --AUGUSTUS_CONFIG_PATH=$AUGUSTUS_CONFIG_PATH

singularity exec -B ${PWD}:${PWD},${AUGUSTUS_CONFIG_PATH}:${AUGUSTUS_CONFIG_PATH} /data/camille/Mind_the_gaps/braker3_lr.sif braker.pl --workingdir=$OUTDIR/chrom/ \
    --genome=$CHROM --prot_seq=$PROT --useexisting --species=chrom --bam=$OUTDIR/chrom/chrom.bam --threads=16 --AUGUSTUS_CONFIG_PATH=$AUGUSTUS_CONFIG_PATH

conda deactivate


### SOFTWARE VERSIONS
# minimap2 v2.30
# BRAKER version 3.0.8 (adapted for long reads + prot db)