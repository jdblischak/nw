#!/usr/bin/env Rscript

# Create exons file for for mapping reads to genes with Subread featureCounts.

# Notes:
# + This includes only coding genes, i.e. gene_biotype == "protein_coding"
# + Uses sep2015 Ensembl archive
# + Output is in Simplified Annotation Format (SAF)
#     + Columns: GeneID, Chr, Start, End, Strand
#     + Coordinates are 1-based, inclusive on both ends
# + Contains duplicate and overlapping exons (featureCounts handles this)

library("biomaRt")
ensembl <- useMart(host = "sep2015.archive.ensembl.org",
                   biomart = "ENSEMBL_MART_ENSEMBL",
                   dataset = "mmusculus_gene_ensembl")
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
# Only include chromosomes and contigs that are part of the primary assembly.
# In other words, exclude alternative haplotypes.
good_contigs <- c(1:19, "MT", "X", "Y",
                  "JH584299.1", "GL456233.1", "JH584301.1", "GL456211.1",
                  "GL456350.1", "JH584293.1", "GL456221.1", "JH584297.1",
                  "JH584296.1", "GL456354.1", "JH584294.1", "JH584298.1",
                  "JH584300.1", "GL456219.1", "GL456210.1", "JH584303.1",
                  "JH584302.1", "GL456212.1", "JH584304.1", "GL456379.1",
                  "GL456216.1", "GL456393.1", "GL456366.1", "GL456367.1",
                  "GL456239.1", "GL456213.1", "GL456383.1", "GL456385.1",
                  "GL456360.1", "GL456378.1", "GL456389.1", "GL456372.1",
                  "GL456370.1", "GL456381.1", "GL456387.1", "GL456390.1",
                  "GL456394.1", "GL456392.1", "GL456382.1", "GL456359.1",
                  "GL456396.1", "GL456368.1", "JH584292.1", "JH584295.1")
exons_final <- exons_all[exons_all$chromosome_name %in% good_contigs &
                           exons_all$gene_biotype == "protein_coding",
                         c("ensembl_gene_id", "chromosome_name", "exon_chrom_start",
                           "exon_chrom_end", "strand", "external_gene_name")]
colnames(exons_final) <- c("GeneID", "Chr", "Start", "End", "Strand", "Name")
# Sort by chromosome and position
exons_final <- exons_final[order(exons_final$Chr,
                                 exons_final$Start,
                                 exons_final$End), ]

# Remove duplicate exon entries. These occur because of alternative transcripts.
# featureCounts can handle these, but since I may want to use these genomic
# coordinates for other analyses, I'll clean them now.
exons_final <- exons_final[!duplicated(exons_final), ]

# Fix strand
exons_final$Strand <- ifelse(exons_final$Strand == 1, "+", "-")

# Save as tab-separated file in Simplified Annotation Format (SAF)
write.table(exons_final, "../data/mouse/genome/exons-mouse.txt",
            quote = FALSE, sep = "\t", row.names = FALSE)
