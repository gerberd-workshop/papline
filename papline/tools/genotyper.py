import pysam
import re
import random

####################
# Genotype caller  #
####################
readclip = False
readcliplen = 2
bamlist = open("bamlist.txt", "r")
for i in bamlist.readlines():
    i = i[:-1]
    bamfile = pysam.AlignmentFile(i, "rb")
    print("Running ", i)
    i = i + ".varcall"
    outfile = open(i, "w+")
    posfile = open("posfile.hazai.txt", "r")
    for j in posfile.readlines():
        j = j[:-1]
        j = list(j.split(" "))
        chr = j[0]
        pos = int(j[1])
        anc = j[2]
        der = j[3]
        anc_cov = []
        der_cov = []
        covered = False
        for read in bamfile.fetch(chr, (pos - 1), pos):
            covered = True
            step = 1
            read = str(read)
            read = read.split("\t")
            start = int(read[3])
            cigar = read[5]
            seque = read[9]
            tilsnp = pos - start
            tilsnpend = int(read[8]) - tilsnp
            if cigar.count("D") > 0 or cigar.count("I") > 0:
                indel = re.split("(\d+)", cigar)
                indel.pop(0)
                intstep = []
                for k in range(len(indel)):
                    try:
                        match = int(indel[k])
                        intstep.append(match)
                        distance = sum(intstep)
                        type = indel[k + 1]
                        if type == "I" and distance <= tilsnp:
                            step = step - match
                        elif type == "D" and distance <= tilsnp:
                            intstep.pop(-1)
                            step = step + match
                    except:
                        pass
            if readclip:
               if tilsnp <= readcliplen or tilsnpend <= readcliplen:
                   anc_cov.append(0)
                   der_cov.append(0)
            else:
               try:
                   snp = seque[tilsnp - step]
                   if snp == anc:
                       anc_cov.append(1)
                   elif snp == der:
                       der_cov.append(1)
               except IndexError:
                   pass
        if covered:
            ancestral = sum(anc_cov)
            derived = sum(der_cov)
            if ancestral > derived:
                allele = anc
            elif derived > ancestral:
                allele = der
            elif ancestral == derived:
                ad = [1, 2]
                if random.choice(ad) == 1:
                    allele = anc
                elif random.choice(ad) == 2:
                    allele = der
        else:
            allele = "NA"
        newline = str(chr) + " " + str(pos) + " " + str(allele)
        outfile.write(newline + "\n")
