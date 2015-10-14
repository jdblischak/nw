#!/usr/bin/env Rscript

# Create count matrix from featureCounts output files.

# Usage:
#  Rscript create-count-matrix.R *_genecounts.txt > output
#  e.g.
#  Rscript create-count-matrix.R ../data/mouse/counts/*_genecounts.txt > ../data/mouse/counts-matrix.txt

suppressPackageStartupMessages(library("edgeR"))

counts_files <- list.files(path = "../data/mouse/counts/", pattern = "txt$",
                           full.names = TRUE)

counts <- readDGE(files = counts_files, columns = c(1, 7), skip = 1,
                  labels = sub("_genecounts.txt", "", basename(counts_files)))

# Write to standard out
write.table(counts$counts, file = "", quote = FALSE, sep = "\t", col.names = NA)
