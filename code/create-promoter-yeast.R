#!/usr/bin/env Rscript

# Create bed file of TSS/promoter regions for yeast.

# Notes:
# + This includes only coding genes, i.e. gene_biotype == "protein_coding"
# + Uses sep2015 Ensembl archive
# + Output is in bed format, the score column contains the position relative to
#   the TSS
# + Each feature is one bp
# + May have been easier to use `bedtools coverage`, but with this method
#   I know I am dealing with the strand correctly and am preparing it for
#   input into R.

# Prevent genomic coordinates from being converted to scientific notation
options(scipen = 999)

library("biomaRt")
ensembl <- useMart(host = "sep2015.archive.ensembl.org",
                   biomart = "ENSEMBL_MART_ENSEMBL",
                   dataset = "scerevisiae_gene_ensembl")
# attributePages(ensembl)
# [1] "feature_page" "structure" "homologs" "sequences" "snp" "snp_somatic"
atts <- listAttributes(ensembl, page = "feature_page")
# atts[grep("strand", atts$description, ignore.case = TRUE), ]
atts_struct <- listAttributes(ensembl, page = "structure")
# atts_struct[grep("exon", atts_struct$description, ignore.case = TRUE), ]
tss_all <- getBM(attributes = c("ensembl_gene_id", "transcription_start_site",
                                  "chromosome_name", "transcript_length",
                                  "strand", "transcript_count",
                                  "external_gene_name",
                                  "gene_biotype"),
                   mart = ensembl)
stopifnot(length(unique(tss_all$ensembl_gene_id)) == nrow(tss_all))
# Only keep genes if:
# * they are protein-coding
# * they are greater than 500 bp in length
# * they have only 1 transcript, so there is no ambiguity in their TSS
#   * this is future proofing. They actually all already have only 1 transcript
tss_filtered <- tss_all[tss_all$gene_biotype == "protein_coding" &
                        tss_all$transcript_length > 500 &
                        tss_all$transcript_count == 1, ]

# Create bed file with each entry +/- 300 bp of TSS
upstream <- 300
downstream <- 300
region <- upstream + downstream + 1
num_bp <- nrow(tss_filtered) * region
chr <- character(length = num_bp)
start <- numeric(length = num_bp)
end <- numeric(length = num_bp)
name <- character(length = num_bp)
score <- numeric(length = num_bp)
strand <- numeric(length = num_bp)

j <- 1
for (i in 1:nrow(tss_filtered)) {
  tss <- tss_filtered$transcription_start_site[i] - 1
  chr[j:(j+region-1)] <- tss_filtered$chromosome_name[i]
  name[j:(j+region-1)] <- paste(tss_filtered$ensembl_gene_id[i],
                                tss_filtered$external_gene_name[i],
                                tss_filtered$transcript_length[i],
                                sep = ";")
  score[j:(j+region-1)] <- -downstream:upstream
  if (tss_filtered$strand[i] == 1) {
    strand[j:(j+region-1)] <- "+"
    start[j:(j+region-1)] <- (tss-upstream):(tss+downstream)
    end[j:(j+region-1)] <- start[j:(j+region-1)] + 1
  } else {
    strand[j:(j+region-1)] <- "-"
    start[j:(j+region-1)] <- (tss+upstream):(tss-downstream)
    end[j:(j+region-1)] <- start[j:(j+region-1)] + 1
  }
  j <- j + region
}

bed <- data.frame(chr, start, end, name, score, strand,
                  stringsAsFactors = FALSE)
# Sort by strand and chromosome
bed <- bed[order(bed$strand, bed$chr), ]

# Save as bed file
# http://useast.ensembl.org/info/website/upload/bed.html?redirect=no
write.table(bed, "../data/yeast/genome/tss-yeast.bed", quote = FALSE, sep = "\t",
            row.names = FALSE, col.names = FALSE)
