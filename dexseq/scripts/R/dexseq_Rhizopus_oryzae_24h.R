########################################################################
#DEXSEQ
library("DEXSeq")
library("BiocParallel")
BPPARAM = MulticoreParam(workers=3)

tmpdir <- Sys.getenv("TMPDIR")
tmpdir <- c("./DEXSEQ'/home")
flattenedFile <- list.files("/Users/larssteenhuis/DEXSEQ/gff", pattern="gff$", full.names = TRUE)
countFiles = list.files("/Users/larssteenhuis/DEXSEQ/home", pattern="txt$", full.names = TRUE)
countFiles

sampleTable = data.frame(
  row.names = c("A_Rhizopus_oryzae_24h", "B_Rhizopus_oryzae_24h", "C_Rhizopus_oryzae_24h", "D_Rhizopus_oryzae_24h", "F_Rhizopus_oryzae_24h", "G_Rhizopus_oryzae_24h", "H_Rhizopus_oryzae_24h",
                "A_RPMI_24h", "B_RPMI_24h", "C_RPMI_24h", "D_RPMI_24h", "E_RPMI_24h", "F_RPMI_24h", "G_RPMI_24h", "H_RPMI_24h"),

  condition = c("Rhizopus_oryzae_24h", "Rhizopus_oryzae_24h", "Rhizopus_oryzae_24h", "Rhizopus_oryzae_24h", "Rhizopus_oryzae_24h", "Rhizopus_oryzae_24h", "Rhizopus_oryzae_24h",
                "RPMI_24h", "RPMI_24h", "RPMI_24h", "RPMI_24h", "RPMI_24h", "RPMI_24h", "RPMI_24h", "RPMI_24h"),

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
showMethods(estimateDispersions)
getMethod(estimateDispersions, "DEXSeqDataSet")

print("testing for differential exon usage")
dxdDEU = testForDEU( dxdDis, BPPARAM=BPPARAM)

print("estimating exon fold changes")
dxdFC <- estimateExonFoldChanges( dxdDEU, BPPARAM=BPPARAM)

print("creating results object")
dxr = DEXSeqResults( dxdDEU )

print("saving results object")
save(dxr,file = "/Users/larssteenhuis/DEXSEQ/dexseq_results/results/24h/Rhizopus_oryzae.results")
 
