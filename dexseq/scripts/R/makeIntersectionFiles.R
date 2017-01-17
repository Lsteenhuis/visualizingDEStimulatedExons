misoMatrices <- list.files("/Users/larssteenhuis/miso/matrices/stimuli_events/")
dexSeqMatrices <- "/Users/larssteenhuis/DEXSEQ/matrices/"
misoDexIntersect <- "/Users/larssteenhuis/intersectMisoDex/"
lapply(misoMatrices,function(x){
  matrixFile <- paste(misoDexIntersect, "intersect_",x ,sep = "") 
  if (file.exists(matrixFile)){
    file.remove(matrixFile)
  } 
  # loads dexseq results object, refactor to DF, removes NA form subscript
  file.create(matrixFile)
  stimuli <- substr(x,1,nchar(x)-16)
  dexSeq <- read.table(paste("/Users/larssteenhuis/DEXSEQ/matrices/",stimuli, ".matrix" ,sep = ""), header=T, sep="\t")
  miso <- read.table(paste("/Users/larssteenhuis/miso/matrices/stimuli_events/",x, sep = ""), header=T, sep="\t")
  intersect.misDex <- intersect(dexSeq$EnsemblId, miso$EnsemblId)
  #miso$GeneName[miso$EnsemblId == dexSeq$EnsemblId]
  lapply(intersect.misDex, function(x){
    # gene <- miso[miso$EnsemblId == x,5]
     
    geneName = as.character(miso$GeneName[miso$EnsemblId == x])[[1]]
    printLine = paste(x,geneName, sep="\t")
    write(printLine,matrixFile, sep = "", append = T)
  })
  #print(intersect.misDex, miso$GeneName[miso$EnsemblId == dexSeq$EnsemblId])
  
})
