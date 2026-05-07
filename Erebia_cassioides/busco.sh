#!/bin/bash

#SBATCH -p normal.168h
#SBATCH -c 16
#SBATCH --mem=120G
#SBATCH -J busco
#SBATCH -o /data/camille/Mind_the_gaps/busco.out

cd /data/camille/Mind_the_gaps/

source /data/camille/bin/miniconda3/etc/profile.d/conda.sh
conda activate chromcomp

busco -i assemblies/chrom.fasta -l lepidoptera_odb12 -m genome -o busco_chrom -c 16
busco -i assemblies/draft.fasta -l lepidoptera_odb12 -m genome -o busco_draft -c 16

conda deactivate
