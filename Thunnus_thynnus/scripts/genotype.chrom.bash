#!/bin/bash

GVCF_LIST=$1
THREAD=$2
LANE=bammerged
REF=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/chrom/GCF_963924715.1_fThuThy2.1_genomic.fna.masked.fna

mkdir -p $LANE
INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/gvcf/chrom/$LANE
gatk CombineGVCFs -R $REF \
  -V $GVCF_LIST \
  -O chrom/$LANE/cohort.g.vcf.gz &> log/combine.$LANE.chrom.oe

gatk GenotypeGVCFs -R $REF \
  -V chrom/$LANE/cohort.g.vcf.gz \
  -O chrom/$LANE/cohort.raw.vcf.gz &> log/genotype.$LANE.chrom.oe
