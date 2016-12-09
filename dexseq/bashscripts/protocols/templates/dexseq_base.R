########################################################################
#DEXSEQ
library("DEXSeq")
library("BiocParallel")
BPPARAM = MulticoreParam(workers=4)

tmpdir <- Sys.getenv("TMPDIR")
flattenedFile <- list.files(tmpdir, pattern="gff$", full.names = TRUE)
countFiles = list.files(tmpdir, pattern="Aspergillus_fumigatus_4h", full.names = TRUE)
RPMI = list.files(tmpdir, pattern="RPMI_4h", full.names = TRUE)
countFiles <- append(countFiles, RPMI)

sampleTable = data.frame(
  row.names = c(vectorS,
                vectorR),

  condition = c(stimCon,
                rpmiCon),

  libType = c("single-end"))

suppressPackageStartupMessages( library( "DEXSeq" ) )
dxd = DEXSeqDataSetFromHTSeq(
        countFiles,
        sampleData=sampleTable,
        design= ~ sample + exon + condition:exon,
        flattenedfile=flattenedFile)

print("estimating sizefactors")
dxdSf = estimateSizeFactors( dxd )

print("estimating dispersions")
dxdDis = estimateDispersions( dxdSf, BPPARAM=BPPARAM)

print("testing for differential exon usage")
dxdDEU = testForDEU( dxdDis, BPPARAM=BPPARAM)

print("estimating exon fold changes")
dxdFC <- estimateExonFoldChanges( dxdDEU, BPPARAM=BPPARAM)

print("creating results object")
dxr = DEXSeqResults( dxdFC )

print("saving results object")
save(dxr,file = "../../dexseq_results/results/time/stimuli.results")
