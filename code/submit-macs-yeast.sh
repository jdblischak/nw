#!/bin/bash
set -e

# Submit yeast MACS jobs from head node

# Effective genome size for yeast: 1.21e7
# http://seqanswers.com/forums/showthread.php?t=4167

mkdir -p ../data/yeast/peaks

MACS="macs2 callpeak -f BAM -g 12100000 -q 0.01 -B --outdir ../data/yeast/peaks -m 3 50"

NAME=H3K4ME3_aa762-1080_Set1_Rep_1
echo $NAME
CMD="$MACS -t ../data/yeast/bam/$NAME.sorted.rmdup.bam \
           -c ../data/yeast/bam/Input_Set1_aa762-1080_Rep_1.sorted.rmdup.bam \
           -n $NAME"

echo $CMD | qsub -l h_vmem=8g -V -cwd -N macs-$NAME -j y -o ../log/

NAME=H3K4ME3_aa762-1080_Set1_Rep_2
echo $NAME
CMD="$MACS -t ../data/yeast/bam/$NAME.sorted.rmdup.bam \
           -c ../data/yeast/bam/Input_Set1_aa762-1080_Rep_1.sorted.rmdup.bam \
           -n $NAME"

echo $CMD | qsub -l h_vmem=8g -V -cwd -N macs-$NAME -j y -o ../log/

NAME=H3K4ME3_Full_length_Set1_Rep_1
echo $NAME
CMD="$MACS -t ../data/yeast/bam/$NAME.sorted.rmdup.bam \
           -c ../data/yeast/bam/Input_for_Full_length_Set1_Rep1.sorted.rmdup.bam \
           -n $NAME"

echo $CMD | qsub -l h_vmem=8g -V -cwd -N macs-$NAME -j y -o ../log/

NAME=H3K4ME3_Full_length_Set1_Rep_2
echo $NAME
CMD="$MACS -t ../data/yeast/bam/$NAME.sorted.rmdup.bam \
           -c ../data/yeast/bam/Input_for_Full_length_Set1_Rep1.sorted.rmdup.bam \
           -n $NAME"

echo $CMD | qsub -l h_vmem=8g -V -cwd -N macs-$NAME -j y -o ../log/
