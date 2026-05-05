#!/bin/bash

SAMPLE_LIST=$1
LANE_LIST=$2
THREAD=$3
REF=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/draft/GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna

mkdir -p log
for LANE in $(cat $LANE_LIST)
do
  mkdir -p $LANE
  INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/map/draft/$LANE
  while IFS= read -r SAMPLE; do
  gatk MarkDuplicates \
    -I $INDIR/${SAMPLE}.sorted.bam \
    -O $LANE/${SAMPLE}.dedup.bam \
    -M ../../qc/$LANE/${SAMPLE}.dedup.dup.txt &> log/$SAMPLE.$LANE.oe &
  done < "$1"
  wait
done
