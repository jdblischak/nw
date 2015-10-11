#!/bin/bash

# Download and index yeast genome R64-1-1 from Ensembl.

DATA_DIR=../data/yeast/genome

mkdir -p $DATA_DIR

wget --no-check-certificate -O $DATA_DIR/Saccharomyces_cerevisiae.R64-1-1.28.dna.genome.fa.gz \
  ftp://ftp.ensemblgenomes.org/pub/release-28/fungi/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.28.dna.genome.fa.gz

gunzip $DATA_DIR/Saccharomyces_cerevisiae.R64-1-1.28.dna.genome.fa.gz

bwa index $DATA_DIR/Saccharomyces_cerevisiae.R64-1-1.28.dna.genome.fa
