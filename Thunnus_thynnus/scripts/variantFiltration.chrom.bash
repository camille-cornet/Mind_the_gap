#!/bin/bash

LANE=bammerged
REF=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/chrom/GCF_963924715.1_fThuThy2.1_genomic.fna.masked.fna
INDIR=/media/root/GenoD/piergiorgio.massa2/mind_the_gap/gvcf/chrom/$LANE
mkdir -p chrom
mkdir -p chrom/$LANE
mkdir -p log

gatk VariantFiltration \
  -R $REF \
  -V $INDIR/cohort.raw.vcf.gz \
  --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0" \
  --filter-name "basic_snp_filter" \
  -O chrom/$LANE/cohort.flt.vcf.gz &> log/variantFiltration.$LANE.chrom.oe

bcftools view -f PASS -m2 -M2 -v snps chrom/$LANE/cohort.flt.vcf.gz | \
  vcftools --vcf - \
	--max-missing 0.8 \
	--maf 0.05 \
	--min-alleles 2 --max-alleles 2 \
	--recode --recode-INFO-all --out chrom/$LANE/cohort.final &>> log/variantFiltration.$LANE.chrom.oe
bgzip -c chrom/$LANE/cohort.final.recode.vcf > chrom/$LANE/cohort.final.recode.vcf.gz
tabix -p vcf chrom/$LANE/cohort.final.recode.vcf.gz

