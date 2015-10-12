#!/bin/bash
set -e

FQ=$1

GENOME=../data/yeast/genome/Saccharomyces_cerevisiae.R64-1-1.28.dna.genome.fa
NAME=`basename ${FQ%.fastq.gz}`
OUTDIR=../data/yeast/bam

mkdir -p $OUTDIR

echo "bwa aln"
bwa aln -n 2 $GENOME <(zcat $FQ) > $OUTDIR/$NAME.sai

echo "bwa samse"
bwa samse -n 1 $GENOME  $OUTDIR/$NAME.sai $FQ > $OUTDIR/$NAME.sam

echo "Converting to bam file"
samtools view -S -F 4 -q 10 -b $OUTDIR/$NAME.sam > $OUTDIR/$NAME.bam
samtools view -S -F 4 -q 10 -c $OUTDIR/$NAME.sam > $OUTDIR/${NAME}_quality-mapped.txt
samtools view -S -F 4 -c $OUTDIR/$NAME.sam > $OUTDIR/${NAME}_mapped.txt
samtools view -S -f 4 -c $OUTDIR/$NAME.sam > $OUTDIR/${NAME}_unmapped.txt

echo "Cleaning up"
rm $OUTDIR/$NAME.sa[im]

echo "Finished"
