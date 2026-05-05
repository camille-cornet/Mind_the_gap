#!/bin/bash

LANE=bammerged
REF=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/draft/GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna
INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/gvcf/draft/$LANE
mkdir -p draft
mkdir -p draft/$LANE
mkdir -p log

gatk VariantFiltration \
  -R $REF \
  -V $INDIR/cohort.raw.vcf.gz \
  --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0" \
  --filter-name "basic_snp_filter" \
  -O draft/$LANE/cohort.flt.vcf.gz &> log/variantFiltration.$LANE.draft.oe

bcftools view -f PASS -m2 -M2 -v snps draft/$LANE/cohort.flt.vcf.gz | \
  vcftools --vcf - \
	--max-missing 0.8 \
	--maf 0.05 \
	--min-alleles 2 --max-alleles 2 \
	--recode --recode-INFO-all --out draft/$LANE/cohort.final &>> log/variantFiltration.$LANE.draft.oe
bgzip -c draft/$LANE/cohort.final.recode.vcf > draft/$LANE/cohort.final.recode.vcf.gz
tabix -p vcf draft/$LANE/cohort.final.recode.vcf.gz

