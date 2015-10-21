#!/bin/bash
set -e

# Submit mouse FastQC jobs from head node

for FQ in `ls ../data/mouse/fastq/*fastq.gz`
do
  JOB_NAME=fastqc-`basename ${FQ%.fastq.gz}`
  echo "bash run-fastqc.sh ../data/mouse/fastqc $FQ" | qsub -l h_vmem=2g -V -cwd -N $JOB_NAME -j y -o ../log/
done
