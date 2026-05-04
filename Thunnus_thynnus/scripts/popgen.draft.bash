#!/bin/bash

LANE=bammerged
INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/vcf/draft/$LANE
mkdir -p draft
mkdir -p draft/$LANE
mkdir -p log

plink2 \
  --vcf $INDIR/cohort.final.recode.vcf.gz \
  --allow-extra-chr \
  --set-all-var-ids '@:#$r,$a' \
  --bad-ld \
  --indep-pairwise 50 10 0.2 \
  --out draft/$LANE/pruned_draft &> log/prune.$LANE.draft.oe

plink2 \
  --vcf $INDIR/cohort.final.recode.vcf.gz \
  --allow-extra-chr \
  --set-all-var-ids '@:#$r,$a' \
  --extract draft/$LANE/pruned_draft.prune.in \
  --bad-freqs \
  --pca 9 \
  --out draft/$LANE/pca_draft &> log/pca.$LANE.draft.oe

awk -F '[: ,]' '{print $1"\t"$2}' draft/$LANE/pruned_draft.prune.in | sort -u > draft/$LANE/pruned.positions

vcftools --gzvcf $INDIR/cohort.final.recode.vcf.gz \
  --positions draft/$LANE/pruned.positions \
  --site-pi \
  --out draft/$LANE/pi_draft &> log/pi.$LANE.draft.oe

vcftools --gzvcf $INDIR/cohort.final.recode.vcf.gz \
  --positions draft/$LANE/pruned.positions \
  --het \
  --out draft/$LANE/het_draft &> log/het.$LANE.draft.oe

vcftools --gzvcf $INDIR/cohort.final.recode.vcf.gz \
  --positions draft/$LANE/pruned.positions \
  --weir-fst-pop pop1.txt \
  --weir-fst-pop pop2.txt \
  --out draft/$LANE/fst_draft &> log/fst.$LANE.draft.oe

