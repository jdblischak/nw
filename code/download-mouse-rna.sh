#!/bin/bash

DATA_DIR="../data"

# Mouse RNA
mkdir -p $DATA_DIR/mouse
URL_MOUSE="https://s3-us-west-2.amazonaws.com/ash-testdatasets/testRNA"
FILES_MOUSE=(mESc-2i-RNA-DMSO-REP1.fastq.gz \
             mESc-2i-RNA-DMSO-REP2.fastq.gz \
             mESc-2i-RNA-DMSO-REP3.fastq.gz \
             mESc-2i-RNA-RA-REP1.fastq.gz \
             mESc-2i-RNA-RA-REP2.fastq.gz \
             mESc-2i-RNA-RA-REP3.fastq.gz)

for FQ in ${FILES_MOUSE[*]}
do
  echo $FQ
  wget --no-check-certificate $URL_MOUSE/$FQ
  mv $FQ $DATA_DIR/mouse
done
