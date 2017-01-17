  geneIDS <- read.delim("~/DEXSEQ/biomart_file/mart_export-5.txt")
  files <- list.files("/Users/larssteenhuis/DEXSEQ/dexseq_results/24h", pattern = ".results", full.names = T)
  lapply(files, function(x){
    # retrieves stimuli name from file path
    stimuli <- substr(x,47,nchar(x)-8)
    print(x)
    matrixFile <- paste("DEXSEQ/matrices/logFold/",stimuli,"_24h.matrix", sep = "")
    if (file.exists(matrixFile)){
     file.remove(matrixFile)
    }
    # loads dexseq results object, refactor to DF, removes NA form subscript
    #file.create(matrixFile)
    dxr <- get(load(x))
    dxr.df <- as.data.frame(dxr)
    dxr.noNa <- dxr.df[!is.na(dxr.df$padj),]
    # only retrieves hits where adjusted P value < 0.05
    dxr.noNa <- dxr.noNa[which(dxr.noNa[,7] < 0.05),]
    # orders on adjusted p value
    dxr.noNa <- dxr.noNa[order(dxr.noNa[,7]),]
    
    #prints header to file
    headerRow <- paste("EnsemblId","exon","geneName","pvalue","padj","logFold", sep = "\t")
    write(headerRow,matrixFile, sep = "", append = T)
    # loops through each row of the file
    apply(dxr.noNa, 1, function(y) {
      groupId <- y$groupID
      featureID <- y$featureID
      
      padjvalue <-y$padj
      pvalue <- y$pvalue
      logFold <- y[10]

      # retrieves gene name based on ensmbl id from genmart file
      geneName <- as.character(geneIDS$Associated.Gene.Name[geneIDS$Ensembl.Gene.ID == groupId])
      # writes row to file 
      rowToFile <- paste(groupId,featureID, geneName,pvalue,padjvalue, logFold, sep = "\t")
      if (logFold >1 || logFold < -1 ) {
        write(rowToFile,matrixFile, sep = "", append = T)
      }
      
    })
  })
