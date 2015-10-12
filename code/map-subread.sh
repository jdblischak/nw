#!/bin/bash
set -e

FQ=$1

GENOME=../data/mouse/genome/Mus_musculus.GRCm38.dna.primary_assembly
NAME=`basename ${FQ%.fastq.gz}`
OUTDIR=../data/mouse/bam

mkdir -p $OUTDIR

echo "Mapping reads"
subread-align -i $GENOME -r $FQ --gzFASTQinput --BAMoutput -uH > $OUTDIR/$NAME.bam

echo "Counting reads"
samtools view -F 4 -c $OUTDIR/$NAME.bam > $OUTDIR/${NAME}_mapped.txt
samtools view -f 4 -c $OUTDIR/$NAME.bam > $OUTDIR/${NAME}_unmapped.txt

echo "Finished"
