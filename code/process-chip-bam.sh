#!/bin/bash
set -e

BAM=$1


NAME=`basename ${BAM%.bam}`
OUTDIR=../data/yeast/bam

mkdir -p $OUTDIR

echo "Sort bam"
samtools sort $BAM /tmp/$NAME.sorted
echo "Remove duplicates"
samtools rmdup -s /tmp/$NAME.sorted.bam $OUTDIR/$NAME.sorted.rmdup.bam
echo "Count reads"
samtools view -c $OUTDIR/$NAME.sorted.rmdup.bam > $OUTDIR/${NAME}_rmdup.txt

echo "Finished"
