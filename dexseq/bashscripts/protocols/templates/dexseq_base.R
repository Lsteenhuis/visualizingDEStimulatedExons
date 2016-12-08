########################################################################
#DEXSEQ

library("DEXSeq")
library("BiocParallel")
BPPARAM = MulticoreParam(workers=4)
tmpdir <- Sys.getenv("TMPDIR")

flattenedFile = "tmpdir/Hsap.GRCh37.75.gff"
countFiles = list.files("tmpdir/", pattern="stimuli_time", full.names = TRUE)
RPMI = list.files("tmpdir/", pattern="RPMI_time", full.names = TRUE)
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
