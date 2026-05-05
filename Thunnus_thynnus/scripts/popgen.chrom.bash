#!/bin/bash

LANE=bammerged
INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/vcf/chrom/$LANE
mkdir -p chrom
mkdir -p chrom/$LANE
mkdir -p log

plink2 \
  --vcf $INDIR/cohort.final.recode.vcf.gz \
  --allow-extra-chr \
  --set-all-var-ids '@:#$r,$a' \
  --bad-ld \
  --indep-pairwise 50 10 0.2 \
  --out chrom/$LANE/pruned_chrom &> log/prune.$LANE.chrom.oe

plink2_highcontig \
  --vcf $INDIR/cohort.final.recode.vcf.gz \
  --allow-extra-chr \
  --set-all-var-ids '@:#$r,$a' \
  --extract chrom/$LANE/pruned_chrom.prune.in \
  --bad-freqs \
  --pca 9 \
  --out chrom/$LANE/pca_chrom &> log/pca.$LANE.chrom.oe

awk -F '[: ,]' '{print $1"\t"$2}' chrom/$LANE/pruned_chrom.prune.in | sort -u > chrom/$LANE/pruned.positions

vcftools --gzvcf $INDIR/cohort.final.recode.vcf.gz \
  --positions chrom/$LANE/pruned.positions \
  --site-pi \
  --out chrom/$LANE/pi_chrom &> log/pi.$LANE.chrom.oe

vcftools --gzvcf $INDIR/cohort.final.recode.vcf.gz \
  --positions chrom/$LANE/pruned.positions \
  --het \
  --out chrom/$LANE/het_chrom &> log/het.$LANE.chrom.oe

vcftools --gzvcf $INDIR/cohort.final.recode.vcf.gz \
  --positions chrom/$LANE/pruned.positions \
  --weir-fst-pop pop1.txt \
  --weir-fst-pop pop2.txt \
  --out chrom/$LANE/fst_chrom &> log/fst.$LANE.chrom.oe

