d = ("/path/to/dir/")
setwd(d)
library(ggplot2)
library(dplyr)
library(ggrepel)
#JITTER ON!!!!!
#Provide files
evecname = "example_evec"
background_table = "example_background.csv"
poplist_table = "example_poplist.csv"
#script starts here
#if orientation of the plot is not okay, comment out rows 64 and/or 65
evec = tryCatch({
  read.table(evecname, stringsAsFactors = F, header = F)
}, error = function(err) {
  read.table(evecname, stringsAsFactors = F, header = F, skip = 1)
})
bg = read.csv(background_table, stringsAsFactors = F, header = T, sep = ",")
anc = read.csv(poplist_table, stringsAsFactors = F, header = T, sep = ",")

bgplot = NULL
for(i in 1:nrow(bg)){
  tab = evec[which(bg[i,1] == evec[,6]),]
  if(nrow(tab) != 0){
    tab$pops = bg[i,2]
    tab$col = bg[i,3]
    tab$fill = bg[i,4]
    tab$shape = bg[i,5]
    tab$stroke = bg[i,6]
    tab$size = bg[i,7]
    tab$lab = bg[i,8]
    tab$lab2 = bg[i,9]
    bgplot = rbind(bgplot, tab)
  }
}
colnames(bgplot) = c("Individuals", "PC1", "PC2", "PC3", "PC4", "Populations", "Groups", "Color", "Fill", "Shape", "Stroke", "Size", "Label", "Label2")
bgplot = bgplot[order(bgplot$Groups),]
blist = bgplot[!duplicated(bgplot$Groups),]

ancplot = NULL
for(i in 1:nrow(anc)){
  tab = evec[which(anc[i,1] == evec[,6]),]
  if(nrow(tab) != 0){
    tab$pops = anc[i,2]
    tab$col = anc[i,3]
    tab$fill = anc[i,4]
    tab$shape = anc[i,5]
    tab$stroke = anc[i,6]
    tab$size = anc[i,7]
    tab$lab = anc[i,8]
    tab$lab2 = anc[i,9]
    ancplot = rbind(ancplot, tab)
  }
}
colnames(ancplot) = c("Individuals", "PC1", "PC2", "PC3", "PC4", "Populations", "Groups", "Color", "Fill", "Shape", "Stroke", "Size", "Label", "Label2")
ancplot = ancplot[order(ancplot$Groups),]
alist = ancplot[!duplicated(ancplot$Groups),]

ablist = rbind(bgplot, ancplot)
ablist$Label2[which("" == ablist$Label2)] = NA
ablist = ablist[!is.na(ablist$Label2),]

ggplot() +
  scale_y_reverse() +
  scale_x_reverse() +
  labs(x = "PC1", y = "PC2") +
  guides(col = guide_legend(ncol = 1)) +
  scale_color_manual(values = c(alist$Color[c(1:nrow(alist))], blist$Color[c(1:nrow(blist))]), labels = c(alist$Label[c(1:nrow(alist))], blist$Label[c(1:nrow(blist))]), name = "Populations") +
  scale_fill_manual(values = c(alist$Fill[c(1:nrow(alist))], blist$Fill[c(1:nrow(blist))]), labels = c(alist$Label[c(1:nrow(alist))], blist$Label[c(1:nrow(blist))]), name = "Populations") +
  scale_shape_manual(values = c(as.numeric(alist$Shape[c(1:nrow(alist))]), as.numeric(blist$Shape[c(1:nrow(blist))])), labels = c(alist$Label[c(1:nrow(alist))], blist$Label[c(1:nrow(blist))]), name = "Populations") +
  scale_size_manual(values = c(as.numeric(alist$Size[c(1:nrow(alist))]), as.numeric(blist$Size[c(1:nrow(blist))])), labels = c(alist$Label[c(1:nrow(alist))], blist$Label[c(1:nrow(blist))]), name = "Populations") +
  theme(plot.title = element_text(size = 20),legend.position = "right", legend.title = element_text(size = 16), legend.text = element_text(size = 14), legend.key.size = unit(0.6, "cm")) +
  geom_point(bgplot, mapping = aes(as.numeric(as.character(PC1)), as.numeric(as.character(PC2)), color = bgplot$Groups, fill = bgplot$Groups, shape = bgplot$Groups, size = bgplot$Groups), stroke = as.numeric(bgplot$Stroke), position = position_jitter()) +
  geom_point(ancplot, mapping = aes(as.numeric(as.character(PC1)), as.numeric(as.character(PC2)), color = ancplot$Groups, fill = ancplot$Groups, shape = ancplot$Groups, size = ancplot$Groups), stroke = as.numeric(ancplot$Stroke), position = position_jitter())
