# Thunnus thynnus

This folder contains the scripts used to analyse whole-genome sequencing data from 10 individuals belonging to two populations of _Thunnus thynnus_ sampled in the Gulf of Mexico and Mediterranean Sea (Sicily, Italy) for the Mind the Gap project. 


## Author
Piergiorgio Massa, University of Bologna - BiGeA Dept., Italy
Alessia Cariani, University of Bologna - BiGeA Dept., Italy



## Environment

The analyses were run in the conda environment specified in the shared computation workflow:

```bash
conda activate chromcomp
```

## Workflow

## 0. Reference preparation

Both assemblies were repeat-masked before mapping.

### Draft assembly

The draft assembly `GCA_003231725.1_GBYP_Tthy_1.0` is highly fragmented. To make variant calling computationally feasible, the masked scaffolds were concatenated into length-based pseudo-scaffolds before indexing.

Scaffolds were assigned to the following length bins:

- 0–300 bp
- 300–600 bp
- 600–1,200 bp
- 1,200–2,400 bp
- 2,400–4,800 bp
- 4,800–9,600 bp
- >9,600 bp

All scaffolds within each non-empty bin were concatenated into one pseudo-scaffold, separated by 10 `N` characters. This produced up to seven pseudo-scaffolds, one per length class.

```bash
cd draft

RepeatMasker \
  -pa 16 \
  -species "vertebrata" \
  -xsmall \
  -gff \
  -dir draft \
  GCA_003231725.1_GBYP_Tthy_1.0_genomic.fna

python make_pseudoscaffolds.py \
  GCA_003231725.1_GBYP_Tthy_1.0_genomic.fna.masked.fna \
  GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna

bwa index GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna
samtools faidx GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna

gatk CreateSequenceDictionary \
  -R GCA_003231725.1_GBYP_Tthy_1.0_genomic.pseudoscaffold.masked.fna

cd ..
```

### Chromosome-level assembly

```bash
cd chrom

RepeatMasker \
  -pa 16 \
  -species "vertebrata" \
  -xsmall \
  -gff \
  -dir chrom \
  GCF_963924715.1_fThuThy2.1_genomic.fna

bwa index GCF_963924715.1_fThuThy2.1_genomic.fna.masked.fna
samtools faidx GCF_963924715.1_fThuThy2.1_genomic.fna.masked.fna

gatk CreateSequenceDictionary \
  -R GCF_963924715.1_fThuThy2.1_genomic.fna.masked.fna

cd ..
```

## 1. FASTQ collection and filename harmonisation

FASTQ files were copied from the sequencing output directories using dataset-specific copy scripts.

```bash
cd reads

bash cp_2201KNO.bash sample-list.txt &> cp_2201KNO.oe &
bash cp_H204.bash sample_list.txt &> cp_H204.oe &
bash cp_HN00164856.bash sample-list.txt &> cp_HN00164856.oe &
bash cp_UiO1.bash sample-list.txt &> cp_UiO1.oe &
bash cp_UiO2.bash sample-list.txt &> cp_UiO2.oe &
```

Some file names contained hyphens, which were replaced with underscores to avoid downstream parsing issues.

```bash
for f in 2201KNO-0042/*-*; do
    new_name=$(basename "$f" | tr '-' '_')
    mv -v -- "$f" "2201KNO-0042/$new_name"
done

for f in HN00164856/*-*; do
    new_name=$(basename "$f" | tr '-' '_')
    mv -v -- "$f" "HN00164856/$new_name"
done

for f in UiO1/*-*; do
    new_name=$(basename "$f" | tr '-' '_')
    mv -v -- "$f" "UiO1/$new_name"
done

for f in UiO2/*-*; do
    new_name=$(basename "$f" | tr '-' '_')
    mv -v -- "$f" "UiO2/$new_name"
done

cd ..
```

## 2. Read quality control

FastQC was run separately for each sequencing lane or run listed in `lane_list.txt`.

```bash
cd qc

for lane in $(cat lane_list.txt); do
  bash fastqc.bash sample_list.txt "$lane" &> fastqc_"$lane".oe &
done

cd ..
```

## 3. Read trimming and filtering

Reads were processed with fastp separately for each sequencing lane or run.

```bash
cd fastp

for lane in $(cat lane_list.txt); do
  bash fastp.bash sample_list.txt "$lane" &> fastp_"$lane".oe &
done

cd ..
```

## 4. Read mapping

Reads were mapped separately to the draft and chromosome-level references.

For individuals sequenced across multiple runs or platforms, preprocessing and alignment were performed separately for each FASTQ pair. The resulting per-run BAM files were then merged at the specimen level before duplicate marking.

### Draft assembly

```bash
cd map/draft

bash map.draft.bash sample_list.txt 2201KNO-0042 32 &> map_2201KNO-0042.oe &
bash map.draft.bash sample_list.txt H204SC25031931 16 &> map_H204SC25031931.oe &
bash map.draft.bash sample_list.txt HN00164856 16 &> map_HN00164856.oe &
bash map.draft.bash sample_list.txt UiO1 24 &> map_UiO1.oe &
bash map.draft.bash sample_list.txt UiO2 24 &> map_UiO2.oe &

bash merge_lanes.draft.bash 32 &> merge_lanes.oe &

for lane in $(cat lane_list.txt); do
  bash flagstats.draft.bash sample_list.txt "$lane" 16 &> flagstats_"$lane".oe &
done

cd ../..
```

### Chromosome-level assembly

```bash
cd map/chrom

for lane in $(cat lane_list.txt); do
  bash map.chrom.bash sample_list.txt "$lane" 20 &> map_"$lane".oe &
done

bash merge_lanes.chrom.bash 32 &> merge_lanes.oe &

for lane in $(cat lane_list.txt); do
  bash flagstats.chrom.bash sample_list.txt "$lane" 16 &> flagstats_"$lane".oe &
done

cd ../..
```

## 5. Duplicate marking

Duplicate marking was performed after merging per-run BAM files at the specimen level. This was done to improve detection of PCR duplicates when the same sequencing library had been resequenced multiple times.

### Draft assembly

```bash
cd dedup/draft

bash dedup.draft.bash sample_list.txt lane_list.txt &> dedup.oe &

cd ../..
```

### Chromosome-level assembly

```bash
cd dedup/chrom

bash dedup.chrom.bash sample_list.txt lane_list.txt &> dedup.oe &

cd ../..
```

## 6. BAM indexing and coverage estimation

BAM files were indexed and coverage/depth summaries were generated.

```bash
cd dedup

bash index.bash sample_list.txt lane_list.txt 4 28 &> index.oe &
bash depth.bash sample_list.txt lane_list.txt 4 28 &> depth.oe &

cd ..
```

## 7. Variant calling

Variant calling was performed with GATK HaplotypeCaller.

```bash
cd gvcf

bash haplotypeCaller.bash sample_list.txt lane_list.txt 8 12 &> haplotypeCaller.oe &

cd ..
```

## 8. Joint genotyping

GVCFs were combined and jointly genotyped separately for the draft and chromosome-level workflows.

### Draft assembly

```bash
cd gvcf

bash genotype.draft.bash gvcf.draft.bammerged.list 100 &> genotype.draft.oe &
```

### Chromosome-level assembly

```bash
bash genotype.chrom.bash gvcf.chrom.bammerged.list 100 &> genotype.chrom.oe &

cd ..
```

## 9. Variant filtering

Variant filtering was performed separately for each reference workflow.

```bash
cd vcf

bash variantFiltration.draft.bash &> variantFiltration.draft.oe &
bash variantFiltration.chrom.bash &> variantFiltration.chrom.oe &

cd ..
```

## 10. Population-genetic summaries

Downstream population-genetic summaries were generated independently for the draft and chromosome-level workflows.

```bash
cd popgen

bash popgen.draft.bash &> popgen.draft.oe &
bash popgen.chrom.bash &> popgen.chrom.oe &

cd ..
```
