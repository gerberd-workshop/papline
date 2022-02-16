library(tidyr)
d = ("/path/to/dir/")
setwd(d)
#set max number of STR differences
difference = 2
#set input
background_samples = "bg_example.csv"
study_samples = "study_example.csv"
output_name = "out.ych"

#script starts here

tab = read.csv(background_samples, stringsAsFactors = F, header = T)
sam = read.csv(study_samples, stringsAsFactors = F, header = T)
c=1
for(i in 2:nrow(tab)){
  tab[i,1] = paste(tab[i,1], c, sep = "")
  c = c + 1
}
fin = NULL
for(i in 1:nrow(sam)){
  temp = sam[i,]
  sammy = sam[i,c(2:length(sam))]
  for(j in 1:nrow(tab)){
    tabby = tab[j,c(2:length(tab))]
    c = 0
    for(k in 1:length(sammy)){
      if(sammy[k] != tabby[k]){
        c = c + 1
      }
    }
    if(c <= difference){
      temp = rbind(temp, tab[j,])
    }
  }
  fin = rbind(fin, temp)
}
fin = fin[order(fin[,1]),]
fin = fin[!duplicated(fin[,1]),]
fin2 = matrix(NA, nrow(fin)*3, 1)
fin2[seq(1, nrow(fin2), by = 3), 1] = fin[,1]
ez = fin %>% unite("x", c(2:ncol(fin)), sep = ",")
fin2[seq(2, nrow(fin2), by = 3),1] = ez[,2]
fin2[seq(3, nrow(fin2), by = 3),1] = 1
hd = paste(colnames(sam[,c(2:ncol(sam))]), collapse = ",")
fin2 = rbind(hd, paste(rep(10, ncol(fin) - 1), collapse = ","), NA, fin2)
write.table(fin2, output_name, quote = F, row.names = F, col.names = F, na = "")
