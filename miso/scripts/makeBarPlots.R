df.4h.all <- data.frame(A3SS=rep(0, 8),A5SS=rep(0, 8),SE=rep(0, 8),MXE=rep(0, 8),RI=rep(0, 8))
df.24h.all <- data.frame(A3SS=rep(0,8),A5SS=rep(0, 8),SE=rep(0, 8),MXE=rep(0, 8),RI=rep(0, 8))
rownames(df.4h.all) <- c("asp","bor", "can", "IL" ,"myc", "pse", "rhi", "stre")
rownames(df.24h.all) <- c("asp","bor", "can", "IL", "myc", "pse", "rhi", "stre")
misoFiles.4h <- list.files("~/miso/matrices/stimuli_events/",
                        pattern="_4h*", full.names = T)
misoFiles.24h <- list.files("~/miso/matrices/stimuli_events/",
                           pattern="_24h*", full.names = T)

countRow <- lapply(misoFiles.4h, function(x){
  file <- read.table(x, header = T ,stringsAsFactors = F)
  events <- file[,2]
  counts <- c(length(events[which(events=="A3SS")]),
              length(events[which(events=="A5SS")]),
              length(events[which(events=="SE")]),
              length(events[which(events=="RI")]),
              length(events[which(events=="MXE")]))
})
df.4h.all[1,] <- countRow[[1]]
df.4h.all[2,] <- countRow[[2]]
df.4h.all[3,] <- countRow[[3]]
df.4h.all[4,] <- countRow[[4]]
df.4h.all[5,] <- countRow[[5]]
df.4h.all[6,] <- countRow[[6]]
df.4h.all[7,] <- countRow[[7]]
df.4h.all[8,] <- countRow[[8]]



countRow <- lapply(misoFiles.24h, function(x){
  file <- read.table(x, header = T ,stringsAsFactors = F)
  events <- file[,2]
  counts <- c(length(events[which(events=="A3SS")]),
              length(events[which(events=="A5SS")]),
              length(events[which(events=="SE")]),
              length(events[which(events=="RI")]),
              length(events[which(events=="MXE")]))
})
df.24h.all[1,] <- countRow[[1]]
df.24h.all[2,] <- countRow[[2]]
df.24h.all[3,] <- countRow[[3]]
df.24h.all[4,] <- countRow[[4]]
df.24h.all[5,] <- countRow[[5]]
df.24h.all[6,] <- countRow[[6]]
df.24h.all[7,] <- countRow[[7]]
df.24h.all[8,] <- countRow[[8]]

par(mfrow=c(1,2))
barplot(as.matrix(t(df.4h.all)), 
        horiz = T,
        col = c("brown1","coral","deepskyblue","darkred","gray0"),
        xlab = "Amount of found splicing variant sites",
        ylab = "Stimuli",
        main = "Found splicing variants at 4 hours")

legend('bottomright','groups', c("A3SS","A5SS","SE","RI", "MXE"), lty = c(1), lwd = c(2),
       col = c("brown1","coral","deepskyblue","darkred","gray0"), ncol=5, bty = "o")

barplot(as.matrix(t(df.24h.all)), 
        horiz = T,
        col = c("brown1","coral","deepskyblue","darkred","gray0"),
        xlab = "splicing variant sites",
        ylab = "Stimuli",
        main = "Found splicing variants at 24 hours"
        )
legend('bottomright','groups', c("A3SS","A5SS","SE","RI", "MXE"), lty = c(1), lwd = c(2),
       col = c("brown1","coral","deepskyblue","darkred","gray0"), ncol=5, bty = "o")

