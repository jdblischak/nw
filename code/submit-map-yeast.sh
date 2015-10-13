#!/bin/bash
set -e

# Submit yeast mapping jobs from head node

for FQ in `ls ../data/yeast/fastq/*fastq.gz`
do
  JOB_NAME=map-`basename ${FQ%.fastq.gz}`
  echo "bash map-bwa.sh $FQ" | qsub -l h_vmem=8g -V -cwd -N $JOB_NAME -j y -o ../log/
done
