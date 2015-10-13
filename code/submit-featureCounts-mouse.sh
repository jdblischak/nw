#!/bin/bash
set -e

# Submit mouse featureCounts jobs from head node

EXONS=../data/mouse/genome/exons-mouse.txt
OUTDIR=../data/mouse/counts

mkdir -p $OUTDIR

for BAM in `ls ../data/mouse/bam/*bam`
do
  NAME=`basename ${BAM%.bam}`
  JOB_NAME=featureCounts-$NAME
  echo "featureCounts -a $EXONS -F SAF -R -o $OUTDIR/${NAME}_genecounts.txt $BAM" | \
    qsub -l h_vmem=4g -V -cwd -N $JOB_NAME -j y -o ../log/
done
