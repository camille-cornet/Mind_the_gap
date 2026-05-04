#!/bin/bash

GVCF_LIST=$1
THREAD=$2
LANE=bammerged
REF=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/draft/GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna

mkdir -p $LANE
INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/gvcf/draft/$LANE
gatk CombineGVCFs -R $REF \
  -V $GVCF_LIST \
  -O draft/$LANE/cohort.g.vcf.gz &> log/combine.$LANE.draft.oe

gatk GenotypeGVCFs -R $REF \
  -V draft/$LANE/cohort.g.vcf.gz \
  -O draft/$LANE/cohort.raw.vcf.gz &> log/genotype.$LANE.draft.oe
