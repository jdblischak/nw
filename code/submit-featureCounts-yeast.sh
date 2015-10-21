#!/bin/bash
set -e

# Submit mouse featureCounts jobs from head node

UPSTREAM=../data/yeast/genome/upstream.txt
DOWNSTREAM=../data/yeast/genome/downstream.txt
GENES=../data/yeast/genome/genes-yeast.txt
BINS=../data/yeast/genome/genes-bin.txt
OUTDIR=../data/yeast/counts

mkdir -p $OUTDIR

for BAM in `ls ../data/yeast/bam/*sorted.rmdup.bam`
do
  NAME=`basename ${BAM%.bam}`

  FEATURE=upstream
  JOB_NAME=$FEATURE-$NAME
  echo "featureCounts -a $UPSTREAM -F SAF -f -O -o $OUTDIR/${FEATURE}_${NAME}_genecounts.txt $BAM" | \
    qsub -l h_vmem=4g -V -cwd -N $JOB_NAME -j y -o ../log/

  FEATURE=downstream
  JOB_NAME=$FEATURE-$NAME
  echo "featureCounts -a $DOWNSTREAM -F SAF -f -O -o $OUTDIR/${FEATURE}_${NAME}_genecounts.txt $BAM" | \
    qsub -l h_vmem=4g -V -cwd -N $JOB_NAME -j y -o ../log/

  FEATURE=genes
  JOB_NAME=$FEATURE-$NAME
  echo "featureCounts -a $GENES -F SAF -f -O -o $OUTDIR/${FEATURE}_${NAME}_genecounts.txt $BAM" | \
    qsub -l h_vmem=4g -V -cwd -N $JOB_NAME -j y -o ../log/

  FEATURE=bins
  JOB_NAME=$FEATURE-$NAME
  echo "featureCounts -a $BINS -F SAF -f -O -o $OUTDIR/${FEATURE}_${NAME}_genecounts.txt $BAM" | \
    qsub -l h_vmem=4g -V -cwd -N $JOB_NAME -j y -o ../log/ -l 'hostname=!bigmem01'

done
