#!/bin/bash
set -e

BAM=$1
PROMOTERS=$2

NAME=`basename ${BAM%.bam}`
OUTDIR=../data/yeast/bed

mkdir -p $OUTDIR

echo "Convert bam to bed"
bedtools bamtobed -i $BAM > $OUTDIR/$NAME.bed

echo "Intersect reads with promoters"
bedtools intersect -a $PROMOTERS -b $OUTDIR/$NAME.bed -c > $OUTDIR/${NAME}_promoter.bed

echo "Finished"
