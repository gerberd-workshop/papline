#!/bin/bash

echo "#!/bin/bash" > tmpf
cat ./tmpf $( cat ./tmp/parampath ) > ./tmp/paramwork
rm -rf tmpf tmpp
source ./tmp/paramwork

#essentials check
if [ -z $workf ]; then
	echo "Workflow parameter was not set, check PARAMETERFILE"
	exit 1
elif [ -z $runam ]; then
	echo "Name of the run was not set, check PARAMETERFILE"
	exit 1
elif [ -z $indir ] || [ ! -d $indir ]; then
	echo "Input directory was not set or does not exist, check PARAMETERFILE"
	exit 1
elif [ -z $listf ] || [ ! -s $listf ]; then
	echo "Listfile was not set or is empty or does not exist, check PARAMETERFILE"
	exit 1
elif [ -z $refer ] || [ ! -s $refer ]; then
	echo "Reference file was not set or is empty or does not exist, check PARAMETERFILE"
	exit 1
fi

#cross-software dependency check
if [ $fstqc == TRUE ] || [ $fstqc == true ] || [ $fstqc == T ] || [ $fstqc == t ]; then
	if ! command -v fastqc &> /dev/null; then
		echo "FASTQC is not installed despite: fastqc=TRUE, try sudo apt install fastqc -y, also check dependencies"
		exit 1
	fi
fi

if [ $atrim == TRUE ] || [ $atrim == true ] || [ $atrim == T ] || [ $atrim == t ] || [ $btrim == TRUE ] || [ $btrim == true ] || [ $btrim == T ] || [ $btrim == t ] || [ $bqthr != 0 ] || [ $minle != 0 ]; then
	if ! command -v cutadapt &> /dev/null; then
		echo "CUTADAPT is not installed despite: atrim/btrim/bqthr/minle are set, try sudo apt install cutadapt -y, also check dependencies"
		exit 1
	fi
fi

if [ $align == BWA_ALN ] || [ $align == BWA_MEM ]; then
	if ! command -v bwa &> /dev/null; then
		echo "BWA is not installed despite: align=BWA_ALN/BWA_MEM, try sudo apt install bwa -y, also check dependencies"
		exit 1
	fi
elif [ $align == Bowtie2_EVF ] || [ $align == Bowtie2_EVS ] || [ $align == Bowtie2_EF ] || [ $align == Bowtie2_ES ] || [ $align == Bowtie2_LVS ] || [ $align == Bowtie2_LVF ] || [ $align == Bowtie2_LF ] || [ $align == Bowtie2_LS ]; then
	if ! command -v bowtie2 &> /dev/null; then
		echo "Bowtie2 is not installed despite: align=Bowtie2, try sudo apt install bowtie2 -y, also check dependencies"
		exit 1
	fi
fi

if [ $mapda == TRUE ] || [ $mapda == true ] || [ $mapda == T ] || [ $mapda == t ]; then
	if ! command -v mapDamage &> /dev/null; then
		echo "MapDamage is not installed despite mapdam=TRUE, check dependencies"
		exit 1
	fi
fi

if [ $cntmx == TRUE ] || [ $cntmx == true ] || [ $cntmx == T ] || [ $cntmx == t ]; then
	if ! command -v estimate.R &> /dev/null; then
		echo "ContaMix is not installed despite cntmx=TRUE, check dependencies"
		exit 1
	elif ! command -v mafft &> /dev/null; then
		echo "MAFFT is not installed despite cntmx=TRUE, check dependencies"
		exit 1
	fi
fi

if [ $mtfas == Permissive ] || [ $mtfas == Majority_rule ] || [ $mtfas == Random ] || [ $disis != 0 ] || [ $pigme != 0 ] || [ $glqua != 0 ]; then
	if ! command -v angsd &> /dev/null; then
		echo "ANGSD is not installed despite mtfas/disis/pigme/glqua are set, check dependencies"
		exit 1
	elif ! command -v haplogrep &> /dev/null; then
		echo "Haplogrep is not installed despite mtfas is set, check dependencies"
		exit 1
	fi
fi

if [ $plink == TRUE ] || [ $plink == true ] || [ $plink == T ] || [ $plink == t ]; then
	if ! command -v plink1.9 &> /dev/null; then
		echo "Plink1.9 is not installed, try sudo apt install plink1.9 -y, also check dependencies"
		exit 1
	fi
fi

if [ $overl != 0 ]; then
	if ! command -v seqprep &> /dev/null; then
		echo "SeqPrep is not installed despite overl>0, try sudo apt install seqprep -y, also check dependencies"
		exit 1
	fi
fi

if [ $psudo == TRUE ] || [ $psudo == true ] || [ $psudo == T ] || [ $psudo == t ]; then
	if ! command -v pileupCaller &> /dev/null; then
		echo "SequenceTools is not installed despite psudo=TRUE, check dependencies"
		exit 1
	fi
fi

#overall software dependency
if ! command -v bamtools &> /dev/null; then
	echo "BAMtools is not installed, try sudo apt install bamtools -y, also check dependencies"
	exit 1
elif ! command -v bam &> /dev/null; then
	echo "BamUtil is not installed, check dependencies"
	exit 1
elif ! command -v bedtools &> /dev/null; then
	echo "BEDtools is not installed, try sudo apt install bedtools -y, also check dependencies"
	exit 1
elif ! command -v vcftools &> /dev/null; then
	echo "VCFtools is not installed, try sudo apt install vcftools -y, also check dependencies"
	exit 1
elif ! command -v samtools &> /dev/null; then
	echo "SAMtools is not installed, should have done it already, this is one of the most basic softwares. Use sudo apt install samtools -y, also check dependencies and don't afraid to ask someone for some help in this journey"
	exit 1
elif ! command -v preseq &> /dev/null; then
	echo "PreSeq is not installed, check dependencies"
	exit 1
elif ! command -v Yleaf.py &> /dev/null; then
	echo "Yleaf-master is not installed, check dependencies"
	exit 1
fi


#cross-dependency check
if [ $workf == "FQ" ] || [ $workf == "fq" ] || [ $workf == "Fq" ]; then
	fqc=`ls -1 $indir/*.fq 2>/dev/null | wc -l`
	fac=`ls -1 $indir/*.fastq 2>/dev/null | wc -l`
	fqg=`ls -1 $indir/*.fq.gz 2>/dev/null | wc -l`
	fag=`ls -1 $indir/*.fastq.gz 2>/dev/null | wc -l`
	lba1=$( cat $listf | awk --field-separator="," "{ print NF }" | sort | uniq | wc -l ) #hanyfele
	lba2=$( cat $listf | awk --field-separator="," "{ print NF }" | sort | uniq ) #ertek
	if [ $fqc != 0 ] || [ $fac != 0 ] || [ $fqg != 0 ] || [ $fag != 0 ]; then
		if [ $atrim == TRUE ] || [ $atrim == true ] || [ $atrim == T ] || [ $atrim == t ]; then
			if [ -z $p5ada ] || [ -z $p7ada ]; then
				echo "Adapters were not provided despite atrim=TRUE, check PARAMETERFILE"
				exit 1
			fi
		fi
		if [ $lba1 != 1 ]; then
			echo "${listf##*/} have varying number of columns, separate data or check LISTFILE"
			exit 1
		fi
		if [ $btrim == TRUE ] || [ $btrim == true ] || [ $btrim == T ] || [ $btrim == t ]; then
			if [ $lba2 != 2 ] && [ $lba2 != 3 ]; then
				echo "None of your samples in ${listf##*/} have barcode despite btrim=TRUE, check your input or PARAMETERFILE"
				exit 1
			fi
		fi
		if [ ! -z $align ]; then
			if [ $align == BWA_ALN ] || [ $align == BWA_MEM ]; then
				if [ -z "$refer".fai ]; then
					echo "Reference FASTA file is not properly indexed, missing file: ${refer##*/}.fai, try using: samtools faidx"
					exit 1
				elif [ -z "$refer".amb ] || [ -z "$refer".ann ] || [ -z "$refer".bwt ] || [ -z "$refer".pac ] || [ -z "$refer".sa ]; then
					echo "Reference FASTA file is not properly indexed, missing file(s): ${refer##*/}.amb/ann/bwt/pac/sa, try using: bwa index"
					exit 1
				fi
			elif [ $align == Bowtie2_EVF ] || [ $align == Bowtie2_EVS ] || [ $align == Bowtie2_EF ] || [ $align == Bowtie2_ES ] || [ $align == Bowtie2_LVS ] || [ $align == Bowtie2_LVF ] || [ $align == Bowtie2_LF ] || [ $align == Bowtie2_LS ]; then
				if [ -z $befer ] || [ ! -f $befer ]; then
					echo "Bowtie2 reference was not set or does not exists despite selecting Bt2 as aligner method, check your input or PARAMETERFILE"
					exit 1
				elif [ ${befer##*.} != bt2 ]; then
					echo "Reference FASTA is not properly indexed, missing file(s): ${refer##*/}.1/2/3/4/rev.1/rev.2.bt2, try using: bowtie2-build"
					exit 1
				fi
			else
				echo "Aligner option was not set properly, check PARAMETERFILE"
				exit 1
			fi
		fi
		if [ $cntmx == TRUE ] || [ $cntmx == true ] || [ $cntmx == T ] || [ $cntmx == t ]; then
			if [ $mtfas == None ]; then
				echo "No mtDNA FASTA creation method is set despite cntmx=TRUE, check PARAMETERFILE"
				exit 1
			fi
		fi
	else
		echo "FASTQ files are not exist or improperly formatted in provided directory, check input files"
		exit 1
	fi
	./src/fq_run.sh
elif [ $workf == "BAM" ] || [ $workf == "bam" ] || [ $workf == "Bam" ]; then
	ban=`ls -1 $indir/*.bam 2>/dev/null | wc -l`
	if [ $ban != 0 ]; then
		if [ $cntmx == TRUE ] || [ $cntmx == true ] || [ $cntmx == T ] || [ $cntmx == t ]; then
			if [ $mtfas == None ]; then
				echo "No mtDNA FASTA creation method is set despite cntmx=TRUE, check PARAMETERFILE"
				exit 1
			fi
		fi
	else
		echo "BAM files are not exist or improperly formatted in provided directory, check input files"
		exit 1
	fi
	./src/bam_run.sh
elif [ $workf == "PAPLINE" ] || [ $workf == "papline" ] || [ $workf == "PAPline" ] || [ $workf == "Papline" ]; then
	if [ ! -f "$indir"/papli_log ]; then
		echo "PAPline LOG file does not exists in provided input directory or it was renamed despite workf=PAPLINE, check your input or PARAMETERFILE"
		exit 1
	fi
	./src/pap_run.sh
else
	echo "Workflow parameter is incorrect, check PARAMETERFILE"
	exit 1
fi

./src/distributor.sh
