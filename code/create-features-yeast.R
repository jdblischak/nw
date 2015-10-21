#!/usr/bin/env Rscript

# Create feature files for for mapping reads to genes with Subread featureCounts.

# Notes:
# + This includes only coding genes, i.e. gene_biotype == "protein_coding"
# + Uses sep2015 Ensembl archive
# + Output is in Simplified Annotation Format (SAF)
#     + Columns: GeneID, Chr, Start, End, Strand
#     + Coordinates are 1-based, inclusive on both ends

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
genes_all <- getBM(attributes = c("ensembl_gene_id", "transcript_length",
                                  "chromosome_name", "start_position",
                                  "end_position", "strand",
                                  "external_gene_name", "transcript_count",
                                  "gene_biotype"),
                   mart = ensembl)
genes_final <- genes_all[genes_all$gene_biotype == "protein_coding" &
                         genes_all$transcript_length > 500 &
                         genes_all$transcript_count == 1,
                         c("ensembl_gene_id", "chromosome_name", "start_position",
                           "end_position", "strand", "external_gene_name")]
colnames(genes_final) <- c("GeneID", "Chr", "Start", "End", "Strand", "Name")
# Sort by chromosome and position
genes_final <- genes_final[order(genes_final$Chr,
                                 genes_final$Start,
                                 genes_final$End), ]

# There are no duplicates. If there were, featureCounts would throw out any
# reads that map to these genes since the GeneID's are different.
full_location <- paste(genes_final$Chr, genes_final$Start, genes_final$End,
                       sep = ".")
duplicate_locations <- which(duplicated(full_location))
# length(duplicate_locations)
# genes_final[sort(c(duplicate_locations, duplicate_locations - 1)), ]

# Fix strand
genes_final$Strand <- ifelse(genes_final$Strand == 1, "+", "-")

# Save as tab-separated file in Simplified Annotation Format (SAF)
write.table(genes_final, "../data/yeast/genome/genes-yeast.txt", quote = FALSE, sep = "\t",
            row.names = FALSE)

# 100 bp upstream of TSS and
# 100 bp downstream of TTS
upstream <- genes_final
downstream <- genes_final
for (i in 1:nrow(upstream)) {
  if (genes_final$Strand[i] == "+") {
    upstream$End[i] <- upstream$Start[i]
    upstream$Start[i] <- upstream$Start[i] - 100
    downstream$Start[i] <- downstream$End[i]
    downstream$End[i] <- downstream$End[i] + 100
  } else {
    downstream$End[i] <- downstream$Start[i]
    downstream$Start[i] <- downstream$Start[i] - 100
    upstream$Start[i] <- upstream$End[i]
    upstream$End[i] <- upstream$End[i] + 100
  }
}
stopifnot(upstream$Start < upstream$End,
          downstream$Start < downstream$End)

# Save upstream and downstream regions in SAF format
write.table(upstream, "../data/yeast/genome/upstream.txt", quote = FALSE,
            sep = "\t", row.names = FALSE)
write.table(downstream, "../data/yeast/genome/downstream.txt", quote = FALSE,
            sep = "\t", row.names = FALSE)

# Split gene body into 50 bins for metagene plots
n_bins <- 50
n_rows <- nrow(genes_final) * n_bins
GeneID <- character(length = n_rows)
Chr <- character(length = n_rows)
Start <- numeric(length = n_rows)
End <- numeric(length = n_rows)
Strand <- character(length = n_rows)
Name <- character(length = n_rows)

j <- 1
for (i in 1:nrow(genes_final)) {
  if (genes_final$Strand[i] == "+") {
    bin_labels <- 1:n_bins
  } else {
    bin_labels <- n_bins:1
  }
  GeneID[j:(j+n_bins-1)] <- paste(genes_final$GeneID[i], bin_labels, sep = ";")
  Chr[j:(j+n_bins-1)] <- genes_final$Chr[i]
  bins <- seq(genes_final$Start[i], genes_final$End[i],
                         length.out = n_bins+1)
  Start[j:(j+n_bins-1)] <- floor(bins[-length(bins)])
  End[j:(j+n_bins-1)] <- floor(bins[-1] -1)
  Strand[j:(j+n_bins-1)] <- genes_final$Strand[i]
  Name[j:(j+n_bins-1)] <- genes_final$Name[i]
  j <- j + n_bins
}
stopifnot(i == nrow(genes_final), j == n_rows + 1)

genes_bin <- data.frame(GeneID, Chr, Start, End, Strand, Name,
                        stringsAsFactors = FALSE)
write.table(genes_bin, "../data/yeast/genome/genes-bin.txt", quote = FALSE,
            sep = "\t", row.names = FALSE)
