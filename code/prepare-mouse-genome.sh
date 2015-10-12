#!/bin/bash

# Download and index (subread) mouse genome GRCm38.p4 from Ensembl (release 82).

DATA_DIR=../data/mouse/genome

mkdir -p $DATA_DIR

wget --no-check-certificate -O $DATA_DIR/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz \
  ftp://ftp.ensembl.org/pub/release-82/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz

gunzip $DATA_DIR/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz

subread-buildindex -o $DATA_DIR/Mus_musculus.GRCm38.dna.primary_assembly \
  $DATA_DIR/Mus_musculus.GRCm38.dna.primary_assembly.fa
