    geneIDS <- read.delim("~/DEXSEQ/biomart_file/mart_export-5.txt")
    files <- list.files("/Users/larssteenhuis/DEXSEQ/dexseq_results/24h", pattern = ".results", full.names = T)
    lapply(files, function(x){
      # retrieves stimuli name from file path
      
      stimuli <- substr(x,47,nchar(x)-12)
      print(stimuli)
      matrixFile <- paste("DEXSEQ/matrices/counts/",stimuli,".24h.matrix", sep = "")
      if (file.exists(matrixFile)){
       file.remove(matrixFile)
      }
      file.create(matrixFile)
      
      # loads dexseq results object, refactor to DF, removes NA form subscript
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
        exonBin <- paste(groupId,featureID,sep = ":")
        padjvalue <-y$padj
        pvalue <- y$pvalue
        logFold <- y[10]
        countRPMI <- sum(dxr$countData[exonBin,grep("RPMI", colnames(dxr$countData))])
        countStimulus <- sum(dxr$countData[exonBin,grep(substr(colnames(dxr$countData)[1],3,4), colnames(dxr$countData))])
        
        #print(dxr.noNa$countData[dxr$groupID == groupId])
        # retrieves gene name based on ensmbl id from genmart file

        geneName <- as.character(geneIDS$Associated.Gene.Name[geneIDS$Ensembl.Gene.ID == groupId])
        if (!countRPMI < 100 && countStimulus <100) {
          if(countRPMI * 2 < countStimulus){
          rowToFile <- paste(groupId,featureID, geneName,pvalue,padjvalue, logFold, sep = "\t")
          write(rowToFile,matrixFile, sep = "", append = T)
        } else if (countStimulus * 2 < countRPMI){
          rowToFile <- paste(groupId,featureID, geneName,pvalue,padjvalue, logFold, sep = "\t")
          write(rowToFile,matrixFile, sep = "", append = T)
        } else {
          
        }}
        
      })
      
    })
