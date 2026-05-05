#!/bin/bash

SAMPLE_LIST=$1
LANE=$2

mkdir -p $LANE
mkdir -p ../qc
mkdir -p ../qc/$LANE

INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/reads/$LANE
while IFS= read -r SAMPLE; do
echo $SAMPLE " BEGIN..."
/home/PERSONALE/piergiorgio.massa2/fastp/fastp \
-i $INDIR/$SAMPLE.R1.fastq.gz \
-I $INDIR/$SAMPLE.R2.fastq.gz \
-o $LANE/$SAMPLE.R1.trim.fastq.gz \
-O $LANE/$SAMPLE.R2.trim.fastq.gz \
-q 20 \
-u 30 \
-l 50 \
-g \
-h ../qc/$LANE/$SAMPLE.fastp.html \
-j ../qc/$LANE/$SAMPLE.fastp.json \
-w 16
echo $SAMPLE " DONE"
done < "$SAMPLE_LIST"
