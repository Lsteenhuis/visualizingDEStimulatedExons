########################################################################
#DEXSEQ

library("DEXSeq")
library("BiocParallel")
BPPARAM = MulticoreParam(workers=4)
flattenedFile = "../../gff/Hsap.GRCh37.75.gff"
countFiles = list.files("../../counted_files/", pattern="stimuli_time", full.names = TRUE)
RPMI = list.files("../../counted_files/", pattern="RPMI_time", full.names = TRUE)
countFiles <- append(countFiles, RPMI)

sampleTable = data.frame(
  row.names = c(vectorS,
                vectorR) ,

  condition = c(stimCon,
                rpmiCon),
  
  libType = c("single-end"))

suppressPackageStartupMessages( library( "DEXSeq" ) )
dxd = DEXSeqDataSetFromHTSeq(
  countFiles,
  sampleData=sampleTable,
  design= ~ sample + exon + condition:exon,
  flattenedfile=flattenedFile)

dxdSf = estimateSizeFactors( dxd )
dxdDis = estimateDispersions( dxdSf, BPPARAM=BPPARAM)
dxdDEU = testForDEU( dxdDis, BPPARAM=BPPARAM)
dxdFC <- estimateExonFoldChanges( dxdDEU, BPPARAM=BPPARAM)
dxr = DEXSeqResults( dxdFC )
save(dxr,file = "../../dexseq_results/results/time/stimuli.results")
save(dxdFC, file =  "../../dexseq_results/foldingChanges/time/stimuli.dxdFC")
