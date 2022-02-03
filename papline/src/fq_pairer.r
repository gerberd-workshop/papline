#!/usr/bin/env Rscript
library(stringr)
fqlist = commandArgs(trailingOnly = T)
path = fqlist[1]
samples = read.table(fqlist[2], stringsAsFactors = F, header = F, sep = ",")[,1]
print(samples[1])
list = NULL
for(i in 3:length(fqlist)){
  splitted1 = str_split_fixed(fqlist[i], pattern = "/", n = Inf)
  splitted2 = unlist(strsplit(splitted1[length(splitted1)], ".", fixed = T))[1]
  splitted3 = strsplit(splitted2, "_")
  list = c(splitted3, list)
}
for(i in 1:length(samples)){
  sublist = list[c(which(sapply(list, function(e) is.element(samples[i], e))))]
  sublist = lapply(sublist, function(x) x[x != "r1"])
  sublist = lapply(sublist, function(x) x[x != "R1"])
  sublist = lapply(sublist, function(x) x[x != "r2"])
  sublist = lapply(sublist, function(x) x[x != "R2"])
  uni = unique(unlist(sublist))
  vec = NULL
  for(j in 1:length(uni)){
    if(length(sublist[c(which(sapply(sublist, function(e) is.element(uni[j], e))))]) == 2){
      vec = c(uni[j], vec)
    }
  }
  names(sublist) = seq(1, length(sublist))
  fin = as.data.frame(matrix(NA, length(vec), 3))
  for(j in 1:length(vec)){
    fin[j,1] = vec[j]
    fin[j,2:3] = names(sublist[c(which(sapply(sublist, function(e) is.element(vec[j], e))))])
  }
  counter = 2
  finvec = NULL
  for(j in 1:(nrow(fin)-1)){
    finvec = c(fin[j,1], finvec)
    print("JJJJJJJ")
    print(fin[j,1])
    for(k in counter:length(fin)){
      if(fin[j,2] == fin[k,2] && fin[j,3] == fin[k,3]){
        finvec = c(fin[k,1], finvec)
        print("KKKKKKK")
        print(fin[k,1])
      }
    }
    counter = counter + 1
  }
  finvec = c(finvec, fin[nrow(fin),1])
}