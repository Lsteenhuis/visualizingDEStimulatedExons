geneIDS <- read.delim("~/DEXSEQ/biomart_file/mart_export-5.txt")
files <- list.files(path = "~/Dropbox/lsteenhuis_internship/data/miso/matrices/stimuli_events" , pattern = ".tsv", full.names = T , recursive = FALSE)
lapply(files, function(x){
  eventSplit <- strsplit(x,split = "/")[[1]]
  stimFull <- strsplit(splot[length(splot)], eventSplit = "_event_names.tsv")[[1]]
  dexseqStim <- strsplit(stimFull, split = "_", perl = FALSE)[[1]]
  stimuli <<- paste(dexseqStim[1], dexseqStim[2], sep = "_")
  time <- dexseqStim[3]
  # creates folder for plots
  dir.create(file.path("~/DEXSEQ/plots", time), showWarnings = FALSE)
  dir.create(file.path(paste("~/DEXSEQ/plots/",time, sep = ""), stimuli), showWarnings = FALSE)
  #load data objects
  dxr <<- get(load(paste("~/DEXSEQ/dexseq_results/results/",time,"/",stimuli,".results", sep = "")))
  print(colnames(dxr))
  # read the stimuli table that 
  stimuli.events <<- read.table(toString(x), header=T, sep="\t")
  #filters NA's from DEXSEqData object
  dxr.noNa <- dxr[!is.na(dxr[,7]<0.05),]
  # creates intersection for genes that miso and dexseq found
  intersect.misDex <- intersect(dxr.noNa$groupID, stimuli.events$EnsemblId)
  # creates count
  countEnsmbl <- lapply(intersect.misDex, function(x) length(grep(x,stimuli.events$EnsemblId)))
  # calculates how much of miso found genes are also found by dexseq
  misoDexCoverage <- Reduce("+",countEnsmbl) / nrow(stimuli.events) * 100
  
  # plots the intersection list 
  lapply(intersect.misDex, function(y) {
    geneInfo <- geneIDS[geneIDS$Ensembl.Gene.ID == y,]
    pdf(paste("DEXSEQ/plots/",time,"/",stimuli,"/", geneInfo$Associated.Gene.Name ,".pdf", sep=""))
    plotDEXSeq( dxr, y , legend=TRUE , cex.axis =1.2, cex=1, lwd=2) #y
    dev.off()
  })

})

dxr <- get(load("~/DEXSEQ/dexseq_results/results/4h/IL-1alpha.results"))
stimuli.events <- read.table("~/Dropbox/lsteenhuis_internship/data/miso/matrices/IL-1alpha_4h_event_names.tsv", header=T, sep="\t")
dxr.noNa <- dxr[!is.na(dxr[,7]<0.05),]
# creates intersection for genes that miso and dexseq found
intersect.misDex <- intersect(dxr.noNa$groupID, stimuli.events$EnsemblId)
plots <- lapply(intersect.misDex, function(x) {
  pdf(paste("DEXSEQ/plots/4h/IL-1alpha/", x,".pdf", sep=""))
  plotDEXSeq( dxr, x , legend=TRUE , cex.axis =1.2, cex=1, lwd=2)
  dev.off()
})

dxr <- get(load("~/DEXSEQ/dexseq_results/results/24h/IL-1alpha.results"))
stimuli.events <- read.table("~/Dropbox/lsteenhuis_internship/data/miso/matrices/IL-1alpha_4h_event_names.tsv", header=T, sep="\t")
dxr.noNa <- dxr[!is.na(dxr[,7]<0.05),]
# creates intersection for genes that miso and dexseq found
intersect.misDex <- intersect(dxr.noNa$groupID, stimuli.events$EnsemblId)
plots <- lapply(intersect.misDex, function(x) {
  pdf(paste("DEXSEQ/plots/24h/IL-1alpha/", x,".pdf", sep=""))
  plotDEXSeq( dxr, x , legend=TRUE , cex.axis =1.2, cex=1, lwd=2)
  dev.off()
})

plotDEXSeq( dxr, "ENSG00000109103" , legend=T , expression = T, splicing = F, cex.axis =1.2, cex=1, lwd=2)
