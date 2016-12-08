########################################################################
#DEXSEQ

library("DEXSeq")
library("BiocParallel")
BPPARAM = MulticoreParam(workers=4)

countFiles = list.files("counted_files/", pattern="[.*stimuli.*.*RPMI*.]txt$", full.names = TRUE)
flattenedFile = "gff/Hsap.GRCh37.75.gff"

sampleTable = data.frame(
  row.names = c("A_RPMI_time","A_stimuli","B_RPMI_time","B_stimuli","C_RPMI_time","C_stimuli","D_RPMI_time","D_stimuli","E_RPMI_time","E_stimuli",
                "F_RPMI_time","F_stimuli","G_RPMI_time","G_stimuli","H_RPMI_time","H_stimuli"),
  condition = c("RPMI","stimuli","RPMI","stimuli","RPMI","stimuli","RPMI","stimuli","RPMI","stimuli",
                "RPMI","stimuli","RPMI","stimuli","RPMI", "stimuli"),
  libType = c("single-end"))

suppressPackageStartupMessages( library( "DEXSeq" ) )
dxd = DEXSeqDataSetFromHTSeq(
  countFiles,
  sampleData=sampleTable,
  design= ~ sample + exon + condition:exon,
  flattenedfile=flattenedFile)

dxdSf = estimateSizeFactors( dxd )
dxdDis = estimateDispersions( dxdSf, BPPARAM=BPPARAM)
dxdDEU = testForDEU( dxdDis)
dxdFC <- estimateExonFoldChanges( dxdDEU, BPPARAM=BPPARAM)
dxr = DEXSeqResults( dxdFC )
save(dxr,file = "stimuli.results")
save(dxdFC, file =  "stimuli.dxdFC")
