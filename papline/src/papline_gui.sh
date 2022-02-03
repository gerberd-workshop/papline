#!/bin/bash

res=$(mktemp --tmpdir iface1.XXXXXXXX)
reso=$(mktemp --tmpdir iface2.XXXXXXXX)

#cleanup
trap "rm -f $res $reso" EXIT

yad --center \
	--title "PAPline GUI" \
	--form \
	--buttons-layout=end \
	--image=utilities-terminal \
	--image-on-top \
	--columns=1 \
	--scroll \
	--width=700 \
	--height=800 \
	--text "<b><big><big>Select options below</big></big></b>\nPlease check README before begin" \
	--field "Workflow parameter":CB ${op0:-FQ!BAM!PAPLINE} \
	--field "<b>Run name<span foreground='red'>*</span></b>" ${op1:-name_of_the_run} \
	--field "<b>Select input directory<span foreground='red'>*</span></b>":MDIR ${op2:-/path/to/fastq_dir} \
	--field "Select output directory":MDIR ${op3:-/path/to/output} \
	--field "<b>Select list.csv<span foreground='red'>*</span></b>":FL ${op4:-lista} \
	--field "Thread to use":NUM ${op5:-24} \
	--field "Run quality check on Fastq files":CHK ${op6:-false} \
	--field "Base quality threshold":NUM ${op7:-30} \
	--field "Trim off Illumina adapters":CHK ${op8:-false} \
	--field "Illumina P5 adapter" ${op9:-AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC} \
	--field "Illumina P7 adapter" ${op10:-AGATCGGAAGAGCGTCGTGTAGGGAAAG} \
	--field "Trim off inner barcodes":CHK ${op11:-true} \
	--field "Discard reads without barcodes":CHK ${op12:-true} \
	--field "Seed error allowed":NUM ${op13:-2} \
	--field "Overlapping base number for merging":NUM ${op14:-5} \
	--field "Minimum read length":NUM ${op15:-15} \
	--field "<b>Set reference<span foreground='red'>*</span></b>":FL ${op16:-reference} \
	--field "Set Bowtie2 reference":FL ${op17:-reference} \
	--field "Aligner type":CB ${op18:-Bowtie2_EVF!Bowtie2_EF!Bowtie2_ES!Bowtie2_EVS!Bowtie2_LVF!Bowtie2_LF!Bowtie2_LS!Bowtie2_LVS!BWA_ALN!BWA_MEM} \
	--field "Keep raw bam":CHK ${op19:-false} \
	--field "Remove duplicates":CHK ${op20:-true} \
	--field "Mapping quality threshold":NUM ${op21:-30} \
	--field "MapDamage run":CHK ${op22:-true} \
	--field "ContaMix run":CHK ${op23:-false} \
	--field "Bases to trim off from read ends":NUM ${op24:-2} \
	--field "mtDNA FASTA creating method":CB ${op25:-Permissive!Majority_rule!Random!None} \
	--field "Minimum coverage for mtDNA FASTA":NUM ${op26:-2} \
	--field "Call only transversions":CHK ${op27:-false} \
	--field "Call pseudohaploide genome":CHK ${op28:-true} \
	--field "Disease variant Quality":NUM ${op29:-30} \
	--field "Pigmentation variant Quality":NUM ${op30:-1} \
	--field "Genotype Quality":NUM ${op31:-1} \
	--field "Transform data to Eigenstrat format":CHK ${op32:-false} \
	--field "Transform data to PLINK format":CHK ${op33:-false} \
	--button=gtk-save:4 \
	--button=gtk-quit:3 > $res
x=$?
if [[ $x -eq 4 ]]; then
	ez=$(cut -d '|' -f4 < $res)
	runam=$(cut -d '|' -f2 < $res)
	if [ ! -d $ez ] || [ -z $ez ]; then
		endir=$(cut -d '|' -f3 < $res)
	else
		endir=$(cut -d '|' -f4 < $res)
	fi
	echo "workf=$(cut -d '|' -f1 < $res)" > $reso
	echo "runam=$(cut -d '|' -f2 < $res)" >> $reso
	echo "indir=$(cut -d '|' -f3 < $res)" >> $reso
	echo "endir=$(cut -d '|' -f4 < $res)" >> $reso
	echo "listf=$(cut -d '|' -f5 < $res)" >> $reso
	echo "thred=$(cut -d '|' -f6 < $res)" >> $reso
	echo "fstqc=$(cut -d '|' -f7 < $res)" >> $reso
	echo "bqthr=$(cut -d '|' -f8 < $res)" >> $reso
	echo "atrim=$(cut -d '|' -f9 < $res)" >> $reso
	echo "p5ada=$(cut -d '|' -f10 < $res)" >> $reso
	echo "p7ada=$(cut -d '|' -f11 < $res)" >> $reso
	echo "btrim=$(cut -d '|' -f12 < $res)" >> $reso
	echo "bdisc=$(cut -d '|' -f13 < $res)" >> $reso
	echo "seeds=$(cut -d '|' -f14 < $res)" >> $reso
	echo "overl=$(cut -d '|' -f15 < $res)" >> $reso
	echo "minle=$(cut -d '|' -f16 < $res)" >> $reso
	echo "refer=$(cut -d '|' -f17 < $res)" >> $reso
	echo "befer=$(cut -d '|' -f18 < $res)" >> $reso
	echo "align=$(cut -d '|' -f19 < $res)" >> $reso
	echo "krbam=$(cut -d '|' -f20 < $res)" >> $reso
	echo "rmdup=$(cut -d '|' -f21 < $res)" >> $reso
	echo "mapqt=$(cut -d '|' -f22 < $res)" >> $reso
	echo "mapda=$(cut -d '|' -f23 < $res)" >> $reso
	echo "cntmx=$(cut -d '|' -f24 < $res)" >> $reso
	echo "ctrim=$(cut -d '|' -f25 < $res)" >> $reso
	echo "mtfas=$(cut -d '|' -f26 < $res)" >> $reso
	echo "mtcov=$(cut -d '|' -f27 < $res)" >> $reso
	echo "cotrv=$(cut -d '|' -f28 < $res)" >> $reso
	echo "psudo=$(cut -d '|' -f29 < $res)" >> $reso
	echo "disis=$(cut -d '|' -f30 < $res)" >> $reso
	echo "pigme=$(cut -d '|' -f31 < $res)" >> $reso
	echo "glqua=$(cut -d '|' -f32 < $res)" >> $reso
	echo "eigen=$(cut -d '|' -f33 < $res)" >> $reso
	echo "plink=$(cut -d '|' -f34 < $res)" >> $reso
	cat $reso > "$endir"/"$runam".parameterfile
	chmod 777 "$endir"/"$runam".parameterfile
fi

