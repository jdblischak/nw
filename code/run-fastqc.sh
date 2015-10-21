#!/bin/bash
set -e

OUTDIR=$1
FILE=$2
BASE=`basename ${FILE%.fastq.gz}`

mkdir -p $OUTDIR

# Unzip file (fastqc throws error when passed unzipped file via process substitution)
zcat $FILE > /tmp/$BASE.fastq

# Run FastQC
fastqc /tmp/$BASE.fastq

# Move to output directory
mv /tmp/${BASE}_fastq* $OUTDIR

# Remove unzipped fastq file
rm /tmp/$BASE.fastq
