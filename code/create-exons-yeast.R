#!/usr/bin/env Rscript

# Create exons file for for mapping reads to genes with Subread featureCounts.

# Notes:
# + This includes only coding genes, i.e. gene_biotype == "protein_coding"
# + Uses sep2015 Ensembl archive
# + Output is in Simplified Annotation Format (SAF)
#     + Columns: GeneID, Chr, Start, End, Strand
#     + Coordinates are 1-based, inclusive on both ends
# + Contains a few duplicate and overlapping exons (featureCounts handles this),
#     + They are only 16 Mitochondrial genes.

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
exons_all <- getBM(attributes = c("ensembl_gene_id", "ensembl_exon_id",
                                  "chromosome_name", "exon_chrom_start",
                                  "exon_chrom_end", "strand",
                                  "external_gene_name",
                                  "gene_biotype"),
                   mart = ensembl)
exons_final <- exons_all[exons_all$gene_biotype == "protein_coding",
                         c("ensembl_gene_id", "chromosome_name", "exon_chrom_start",
                           "exon_chrom_end", "strand", "external_gene_name")]
colnames(exons_final) <- c("GeneID", "Chr", "Start", "End", "Strand", "Name")
# Sort by chromosome and position
exons_final <- exons_final[order(exons_final$Chr,
                                 exons_final$Start,
                                 exons_final$End), ]

# There are some duplicates, but they are just 16 mitochondrial genes.
# Thus featureCounts will throw out these reads since the GeneID's are different.
full_location <- paste(exons_final$Chr, exons_final$Start, exons_final$End,
                       sep = ".")
duplicate_locations <- which(duplicated(full_location))
exons_final[sort(c(duplicate_locations, duplicate_locations - 1)), ]

# Fix strand
exons_final$Strand <- ifelse(exons_final$Strand == 1, "+", "-")

# Save as tab-separated file in Simplified Annotation Format (SAF)
write.table(exons_final, "../data/yeast/genome/exons-yeast.txt", quote = FALSE, sep = "\t",
            row.names = FALSE)
