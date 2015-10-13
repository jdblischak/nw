#!/bin/bash
set -e

# Submit mouse mapping jobs from head node

for FQ in `ls ../data/mouse/fastq/*fastq.gz`
do
  JOB_NAME=map-`basename ${FQ%.fastq.gz}`
  echo "bash map-subread.sh $FQ" | qsub -l h_vmem=12g -V -cwd -N $JOB_NAME -j y -o ../log/
done
