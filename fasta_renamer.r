d = ("/media/gerberd/4898210B2D702876/orsi/HV0a/separate/")                  #add path
setwd(d)                                                                     #set path as default
tab = read.csv("hv0a.csv", stringsAsFactors = F, header = T)                 #read table to be matched
for(file in dir(path = d, pattern = "fasta$")){                              #for each fasta file
  print(file)                                                                #print filename
  basename = unlist(strsplit(file, "\\."))[1]
  fasta = read.table(file, stringsAsFactors = F, header = F)                 #read fasta as table
  fastahead = substring(fasta[1,], 2)                                        #first line is header, get it without kacsacsor
  if(substring(fastahead, 1, 1) == "I" & is.numeric(as.numeric(substring(fastahead, 2, 5)))){
    fastahead = substring(fastahead, 1, 5)
  }
  fasta[1,1] = paste(">", tab[pmatch(fastahead, tab[,1]),2], sep = "")       #match name in table, get new name, add kacsacsor
  filename = paste(basename, "renamed", "fasta", sep = ".")
  write.table(fasta, file = paste(d, "out/", filename, sep = ""), quote = F, row.names = F, col.names = F)
}
