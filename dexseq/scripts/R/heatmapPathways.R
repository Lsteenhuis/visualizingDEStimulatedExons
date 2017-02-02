time <- "4h & 24h"
pat <- paste("tab", sep="")
files <- list.files("/Users/larssteenhuis/DEXSEQ/cpdb/top10", pattern = pat, full.names = T)

# retrieves names of the pathway as column names
colName <- lapply(files, function(x){
  topPathWayTable <- read.delim(x)
  pathColumns<- apply(topPathWayTable,1, function(y){
    pathway <- y[3][[1]]
  })
  colName <- pathColumns
})
#get list of unique column names for data frame
colName <- unlist(colName)
colNames=unique(colName)
# retrieves row names from stimuli from file
rowNames = lapply(files, function(file){
  rowName <- substr(file,45,nchar(file))
})
# get list of rownames 
rowNames = unlist(rowNames)
colNames

#create tmp df for heatmap df
tmp.df =as.data.frame(matrix(0,nrow=14,ncol=length(colNames)))
colnames(tmp.df) <- colNames
rownames(tmp.df) <- rowNames

##### Creation of heatmap df ####
listOfoccurence=lapply(files, function(file) {
  content=read.table(file,stringsAsFactors = F,sep="\t",header = T)
  stimulus <- substr(file,38,nchar(file)-11)
  pathways=data.frame(content[3])
  # vector for positioning of pathways
  line <- rep(0,length(colNames))
  # retrieve list of indexes of which pathways are found in the result
  listOfPathways <- lapply(unlist(pathways), function(pathway){
    which(pathway == colnames(tmp.df))
  })
  # sets line to one at the locations of the pathways
  line[listOfPathways$pathway1] <- 1
  line[listOfPathways$pathway2] <- 1
  line[listOfPathways$pathway3] <- 1
  line[listOfPathways$pathway4] <- 1
  line[listOfPathways$pathway5] <- 1
  line[listOfPathways$pathway6] <- 1
  line[listOfPathways$pathway7] <- 1
  line[listOfPathways$pathway8] <- 1
  line[listOfPathways$pathway9] <- 1
  line[listOfPathways$pathway10] <- 1
  tmp.df[stimulus,] <- line

})

#adds colnames and rownames to dataframe
occurence.df <- t(as.data.frame(listOfoccurence))
colnames(occurence.df) <- colNames
rownames(occurence.df) <- rowNames
#  paramter to set value for amount of pathways
occurence.colSums.df <- occurence.df[,colSums(occurence.df) > 0]
##### ... ####

#plot heatmap
pheatmap(t(occurence.colSums.df),scale="none", fontsize = 8, cluster_rows = T, cluster_cols = T, main = time,
         cellwidth = 8, cellheight= 6.5)
