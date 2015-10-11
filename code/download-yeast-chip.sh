#!/bin/bash

DATA_DIR="../data"

# Yeast ChIP
mkdir -p $DATA_DIR/yeast
URL_YEAST="https://s3-us-west-2.amazonaws.com/ash-testdatasets/testChIP"
FILES_YEAST=(H3K4ME3_Full_length_Set1_Rep_1.fastq.gz \
             H3K4ME3_Full_length_Set1_Rep_2.fastq.gz \
             H3K4ME3_aa762-1080_Set1_Rep_1.fastq.gz \
             H3K4ME3_aa762-1080_Set1_Rep_2.fastq.gz \
             Input_Set1_aa762-1080_Rep_1.fastq.gz \
             Input_for_Full_length_Set1_Rep1.fastq.gz)

for FQ in ${FILES_YEAST[*]}
do
  echo $FQ
  wget --no-check-certificate $URL_YEAST/$FQ
  mv $FQ $DATA_DIR/yeast
done
