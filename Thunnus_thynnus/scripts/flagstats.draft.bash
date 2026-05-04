#!/bin/bash

SAMPLE_LIST=$1
LANE=$2
THREAD=$3

while IFS= read -r SAMPLE; do
samtools flagstat -@ 16 $LANE/$SAMPLE.sorted.bam > ../../qc/$LANE/$SAMPLE.sorted.draft.flagstat.txt
done < "$1"
