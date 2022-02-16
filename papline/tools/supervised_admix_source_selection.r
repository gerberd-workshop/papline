d = ("/path/to/dir/")
setwd(d)
#set input names
famfile = "input.fam"
indfile = "input.ind"
popfile = "input.csv"
#set output names
outpop = "out.pop"
groupname = "groupname"

#script starts here

fam = read.table(famfile, stringsAsFactors = F, header = F)
ind = read.table(indfile, stringsAsFactors = F, header = F)
pop = read.table(popfile, stringsAsFactors = F, header = F, sep = ",")
tab = NULL
for(i in 1:nrow(pop)){
  ez = ind[pop$V1[i] == ind$V3,c(1, 3)]
  ez$V3 = pop$V2[i]
  tab = rbind(tab, ez)
}
fin = NULL
for(i in 1:nrow(fam)){
  temp = as.data.frame(matrix(NA, 1, 1))
  if(0 == nrow(tab[fam$V2[i] == tab$V1,])){
    temp[1,1] = "-"
  } else {
    temp[1,1] = tab[fam$V2[i] == tab$V1,2]
  }
  fin = rbind(fin, temp)
}
write.table(fin, file = outpop, quote = F, col.names = F, row.names = F)
fin2 = NULL
for(i in 1:nrow(fam)){
  temp = as.data.frame(matrix(NA, 1, 2))
  temp$V1[1] = ind$V3[fam$V2[i] == ind$V1]
  temp$V2[1] = fam$V2[i]
  fin2 = rbind(fin2, temp)
}
write.table(fin2, file = groupname, quote = F, col.names = F, row.names = F)
