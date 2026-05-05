#!/bin/bash

SAMPLE_LIST=$1
LANE=$2
THREAD=$3
REF=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/draft/GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna

mkdir -p $LANE
INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/fastp/$LANE
while IFS= read -r SAMPLE; do
FLOWCELL=$(zcat $INDIR/$SAMPLE.R1.trim.fastq.gz | head -n 1 | cut -d ':' -f3)
LANEE=$(zcat $INDIR/$SAMPLE.R1.trim.fastq.gz | head -n 1 | cut -d ':' -f4)
RGID="${FLOWCELL}.${LANEE}"
LIB="${SAMPLE}_lib"
RG="@RG\tID:${RGID}\tSM:${SAMPLE}\tPL:ILLUMINA\tLB:${LIB}"
bwa mem -M -R "$RG" -t $THREAD $REF \
$INDIR/$SAMPLE.R1.trim.fastq.gz $INDIR/$SAMPLE.R2.trim.fastq.gz | \
samtools view -@ $THREAD -Sb - | \
samtools sort -@ $THREAD -o $LANE/$SAMPLE.sorted.bam -
done < "$1"
