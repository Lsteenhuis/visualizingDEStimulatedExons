dexFiles.4h <- list.files("/Users/larssteenhuis/DEXSEQ/matrices/", pattern = "\\.4h.matrix$", full.names = T)
dexFiles.24h <- list.files("/Users/larssteenhuis/DEXSEQ/matrices/", pattern = "\\.24h.matrix$", full.names = T)
stimuliNames <- c("Aspergillus_fumigatus","Borrelia_burgdorferi","Candida_albicans",
                  "IL-1alpha", "Mycobacterium_tuberculosis", "Pseudomonas_aeruginosa"
                  ,"Rhizopus_oryzae","Streptococcus_pneumoniae")


countRows <- lapply(dexFiles.4h, function(x){
  file <- read.table(x,header = T, stringsAsFactors = F)
  nrow(file)
})
transposedRows.4h <- as.matrix(t(countRows))
colnames(transposedRows.4h) <-  stimuliNames




barplot(table(bla), las = 2)
countRows <- lapply(dexFiles.24h, function(x){
  file <- read.table(x,header = T, stringsAsFactors = F)
  nrow(file)
})
transposedRows.24h <- as.matrix(t(countRows))
colnames(transposedRows.24h) <-  stimuliNames


par(mfrow=c(1,1),las=2)

barplot(transposedRows.4h, main = "DEXSEQ 4h padj < 0.05",
        xlab = "",
        ylab = "DE exons",
        cex.axis = 1 ,
        cex.names = 0.5 ,
        yaxt="n")

title(xlab="Stimuli", line=0, cex.lab=1.2)

barplot(transposedRows.24h, main = "DEXSEQ 24h padj < 0.05",
        xlab = "",
        ylab = "DE exons",
        yaxt="n")

axis(2,cex.axis=0.75)
title(xlab="Stimuli", line=0, cex.lab=1.2)