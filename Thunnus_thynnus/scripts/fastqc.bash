#!/bin/bash

SAMPLE_LIST=$1
LANE=$2

mkdir -p $LANE

INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/reads/$LANE
while IFS= read -r SAMPLE; do
echo $SAMPLE " BEGIN..."
fastqc -t 16 $INDIR/$SAMPLE.R1.fastq.gz $INDIR/$SAMPLE.R2.fastq.gz -o $LANE/
echo $SAMPLE " DONE"
done < "$SAMPLE_LIST"
