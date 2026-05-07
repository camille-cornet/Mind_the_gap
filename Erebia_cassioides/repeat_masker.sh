#!/bin/bash

#SBATCH -p normal.168h
#SBATCH -c 16
#SBATCH --mem=120G
#SBATCH -J repeat_masker
#SBATCH -o /data/camille/Mind_the_gaps/repeat_masker.out

cd /data/camille/Mind_the_gaps/

source /data/camille/bin/miniconda3/etc/profile.d/conda.sh
conda activate chromcomp

# Unmask genome (otherwise by default RM will ignore the already masked regions)
sed 's/[acgt]/\U&/g' assemblies/draft_previously_masked.fasta > assemblies/draft.fasta

RepeatMasker -pa 16 -species "arthropoda" -xsmall -gff -dir assemblies/ assemblies/draft.fasta
RepeatMasker -pa 16 -species "arthropoda" -xsmall -gff -dir assemblies/ assemblies/chrom.fasta

conda deactivate
