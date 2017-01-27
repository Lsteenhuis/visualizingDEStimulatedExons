
misoMatrices <- list.files("/Users/larssteenhuis/miso/matrices/occurence_matrices", pattern="\\_4h")                                                                                                        

lapply(misoMatrices, function(y){
  stimuli <- y
  time <- "4h"
  print(y)
  outputFile <- "/Users/larssteenhuis/miso/matrices/eventLocations/"
  outputPath <- paste(outputFile,stimuli,sep="")
  filePath <- paste("~/miso/matrices/occurence_matrices/",stimuli, sep="")
  fileDf <- read.csv(filePath, sep="")
  test <- apply(fileDf,1,function(x) {
    index <- which(x== 1)
    return(c(x[3], x[2], index))
    })
  string <- lapply(test, function(x) {
    eventName <- x[[1]]
    eventType <- x[[2]]
    stimuli <- names(x)[3]
    occuredStimuli <- names(x)[3:length(names(x))]
    bla <- c(eventName,eventType,"4h", occuredStimuli)
    x <- paste(bla,sep="",collapse = "\t")
  })
  stim <- substr(as.character(y),start = 1, stop = length(y) -24)
  
  write(paste(string,collapse = "\n"), file=outputPath)
})


