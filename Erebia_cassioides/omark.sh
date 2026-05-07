#!/bin/bash

#SBATCH -p normal.168h
#SBATCH -c 1
#SBATCH --mem=60G
#SBATCH -J omark
#SBATCH -o /data/camille/Mind_the_gaps/omark/omark.out

INDIR=/data/camille/Mind_the_gaps/braker
OUTDIR=/data/camille/Mind_the_gaps/omark
cd $OUTDIR

source /data/camille/bin/miniconda3/etc/profile.d/conda.sh
conda activate chromcomp

omamer search --db $OUTDIR/LUCA.h5 --query $INDIR/draft/braker.aa --out $OUTDIR/draft.omamer
mkdir $OUTDIR/draft
omark -f $OUTDIR/draft.omamer -d $OUTDIR/LUCA.h5 -o $OUTDIR/draft

omamer search --db $OUTDIR/LUCA.h5 --query $INDIR/chrom/braker.aa --out $OUTDIR/chrom.omamer
mkdir $OUTDIR/chrom
omark -f $OUTDIR/chrom.omamer -d $OUTDIR/LUCA.h5 -o $OUTDIR/chrom

conda deactivate
