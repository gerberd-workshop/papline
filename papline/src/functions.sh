#!/bin/bash

source ./tmp/paramwork

function defaults {
	if [ -z $thred ]; then
		thred=24
	elif [ $thred -lt 1 ]; then
		thred=24
	fi
	if [ -z $bqthr ]; then
		bqthr=30
	elif [ $bqthr -lt 0 ]; then
		bqthr=0
	fi
	fi [ -z $seeds ]; then
		seeds=2
	elif [ $seeds -lt 1 ]; then
		seeds=0
	fi
	if [ -z $overl ]; then
		overl=5
	elif [ $overl -lt 1 ]; then
		overl=0
	fi
	if [ -z $minle ]; then
		minle=15
	elif [ $minle -lt 1 ]
		minle=0
	fi
	if [ -z $ctrim ]; then
		ctrim=2
	elif [ $ctrim -lt 1 ]; then
		ctrim=0
	fi
	if [ -z $mapqt ]; then
		mapqt=30
	elif [ $mapqt -lt 0 ]; then
		mapqt=0
	fi
	if [ -t $mtcov ]; then
		mtcov=2
	elif [ $mtcov -lt 1 ]; then
		mtcov=0
	fi
	if [ -z $disis ]; then
		disis=30
	elif [ $disis -lt 1 ]; then
		disis=0
	fi
	if [ -z $pigme ]; then
		pigme=1
	elif [ $pigme -lt 0 ]; then
		pigme=0
	fi
	if [ -z $glqua ]; then
		glqua=1
	elif [ $glqua -lt 0 ]; then
		glqua=0
	fi
	if [ -z $fstqc ]; then
		fstqc=TRUE
	fi
	if [ -z $atrim ]; then
		atrim=FALSE
	fi
	if [ -z $btrim ]; then
		btrim=TRUE
	fi
	if [ -z $bdisc ]; then
		bdisc=TRUE
	fi
	if [ -z $align ]; then
		align=Bowtie2_EVF
	fi
	if [ -z $krbam ]; then
		krbam=FALSE
	fi
	if [ -z $rmdup ]; then
		rmdup=TRUE
	fi
	if [ -z $mapda ]; then
		mapda=TRUE
	fi
	if [ -z $cntmx ]; then
		cntmx=FALSE
	fi
	if [ -z $mtfas ]; then
		mtfas=Permissive
	fi
	if [ -z $cotrv ]; then
		cotrv=FALSE
	fi
	if [ -z $psudo ]; then
		psudo=TRUE
	fi
	if [ -z $eigen ]; then
		eigen=FALSE
	fi
	if [ -z $plink ]; then
		plink=FALSE
	fi
}

function dirmake {
	if [ $workf == "PAPLINE" ] || [ $workf == "papline" ] || [ $workf == "PAPline" ] || [ $workf == "Papline" ]; then
		ppp=TRUE
		erendir=FALSE
		erindir=FALSE
	else
		ppp=FALSE
		erendir=FALSE
		erindir=FALSE
	fi
	if [ $ppp == FALSE ]; then
		if [ ! -z $endir ] && [ -d $endir ]; then
			rm -rf "$endir"/"$runam"
			mkdir "$endir"/"$runam"
			basename=$( cat $listf | cut -d, -f1 )
			for i in basename; do
				echo "Create directories"
				mkdir -p "$endir"/"$runam"/"$i"
				mkdir "$endir"/"$runam"/"$i"/RUNLOGS
			done 2> "$endir"/error_dirmake.log
			erendir=TRUE
		else
			rm -rf "$indir"/"$runam"
			mkdir "$indir"/"$runam"
			basename=$( cat $listf | cut -d, -f1 )
			for i in $basename; do
				echo "Create directories"
				mkdir -p "$indir"/"$runam"/"$i"
				mkdir "$indir"/"$runam"/"$i"/RUNLOGS
			done 2> "$indir"/error_dirmake.log
			erindir=TRUE
		fi
	elif [ $ppp == TRUE ]; then
		if [ ! -s "$indir"/papli_log ]
			echo "papli_log file does not exist or is renamed or is empty despite workf=PAPLINE, check your input or PARAMETERFILE"
		fi
	fi
}

function fastqc {
	if ! command -v fastqc &> /dev/null; then
		echo "FASTQC is not installed despite: fastqc=TRUE, try sudo apt install fastqc -y, also check dependencies"
		exit 1
	fi
	basename=$( cat $listf | cut -d, -f1 )
	echo "Quality check of FASTQ files"
	if [ $erindir == TRUE ]; then
		endir=$( echo $indir )
	fi
	for i in $basename; do
		shopt -s nullglob
		echo "FastQC run for $i"
		fastqc "$indir"/"$i"*.{fastq,fastq.gz,fq,fq.gz} 
		shopt -u nullglob
		rm -rf "$endir"/"$runam"/"$i"/FASTQC
		mkdir "$endir"/"$runam"/"$i"/FASTQC
		mv "$indir"/"$i"*.html "$endir"/"$runam"/"$i"/FASTQC/
		mv "$indir"/"$i"*.zip "$endir"/"$runam"/"$i"/FASTQC/
	done 2> x
	mv x "$endir"/"$runam"/error_fastqc.log
}

function basequalitytrim {
	basename=$( cat $listf | cut -d, -f1 )
	echo "BQ trim of FASTQ files"
	if ! command -v cutadapt &> /dev/null; then
		echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
		exit 1
	fi
	if [ $erindir == TRUE ]; then
		endir=$( echo $indir )
	fi
	for i in $basename; do	
		rm -rf "$endir"/"$runam"/"$i"/BQTRIM
		mkdir "$endir"/"$runam"/"$i"/BQTRIM
		if [ ! -d "$endir"/"$runam"/"$i"/RUNLOGS ]; then
			mkdir  "$endir"/"$runam"/"$i"/RUNLOGS
		fi
		shopt -s nullglob
		for j in "$indir"/"$i"*.{fastq,fastq.gz,fq,fq.gz}; do
			echo "$j"
			file=$( echo ${j##*/} )
			bbn=$( echo "$file" | cut -d'.' -f1 )
			cutadapt -j $thred -q $bqthr -o "$endir"/"$runam"/"$i"/BQTRIM/"$bbn"_"$bqthr"bq.fastq.gz $j > "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".qualtrim.full.txt
			echo $( awk '{for(i=1;i<=NF;i++) if ($i=="basepairs") print $(i+2)}' "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".qualtrim.full.txt ) | tr --delete "," > "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".totalbp.txt
			echo $( awk '{for(i=1;i<=NF;i++) if ($i=="Quality-trimmed:") print $(i+1)}' "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".qualtrim.full.txt ) | tr --delete "," > "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".qualtrim.txt
			expr $( zcat "$endir"/"$runam"/"$i"/BQTRIM/"$bbn".bq"$bqthr".fastq.gz | wc -l ) / 4 &> "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".readno1.txt
		done
		shopt -u nullglob
		array1=($(cat "$endir"/"$runam"/"$i"/RUNLOGS/*R1*readno1.txt))
		sum1=$(IFS=+; echo "$((${array1[*]}))")
		echo $sum1 > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Starting_read_number.txt
		array2=($(cat "$endir"/"$runam"/"$i"/RUNLOGS/*totalbp.txt))
		sum2=$(IFS=+; echo "$((${array2[*]}))")
		echo $sum2 > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Starting_basepairs.txt
		array3=($(cat "$endir"/"$runam"/"$i"/RUNLOGS/*qualtrim.txt))
		sum3=$(IFS=+; echo "$((${array3[*]}))")
		echo $sum3 > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Trimmed_off_basepairs.txt
		rm -rf "$endir"/"$runam"/"$i"/RUNLOGS/*.totalbp.txt
		rm -rf "$endir"/"$runam"/"$i"/RUNLOGS/*.qualtrim.txt
		rm -rf "$endir"/"$runam"/"$i"/RUNLOGS/*.readno1.txt
		rm -rf "$endir"/"$runam"/"$i"/RUNLOGS/*.qualtrim.full.txt
	done 2> "$endir"/"$runam"/error_fastqc.log
}

function adaptertrim {
	basename=$( cat $listf | cut -d, -f1 )
	echo "ADAPTER trim of FASTQ files"
	if [ $erindir == TRUE ]; then
		endir=$( echo $indir )
	fi
	if ! command -v cutadapt &> /dev/null; then
		echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
		exit 1
	fi
	r1e=$( echo "0.$( echo $((1000*$seeds/${#p5ada})) )" )
	r2e=$( echo "0.$( echo $((1000*$seeds/${#p7ada})) )" )
	for i in $basename; do
		if [ -d "$endir"/"$runam"/"$i"/BQTRIM ]; then #papli structure
			rm -rf "$endir"/"$runam"/"$i"/ADAPTERTRIM
			mkdir "$endir"/"$runam"/"$i"/ADAPTERTRIM
			shopt -s nullglob
			for j in "$endir"/"$runam"/"$i"/BQTRIM/*{R1,r1}*fastq.gz; do
				echo "$j"
				file=$( echo ${j##*/} )
				bbn=$( echo "$file" | cut -d'.' -f1 )
				cutadapt -j $thred -a $p5ada -e $r1e -o "$endir"/"$runam"/"$i"/ADAPTERTRIM/"$bbn".atrim.fastq.gz $j
			done
			for j in "$endir"/"$runam"/"$i"/BQTRIM/*{R2,r2}*fastq.gz; do
				echo "$j"
				file=$( echo ${j##*/} )
				bbn=$( echo "$file" | cut -d'.' -f1 )
				cutadapt -j $thred -a $p7ada -e $r2e -o "$endir"/"$runam"/"$i"/ADAPTERTRIM/"$bbn".atrim.fastq.gz $j
			done
			shopt -u nullglob
		else #fq outside
			rm -rf "$endir"/"$runam"/"$i"/ADAPTERTRIM
			mkdir "$endir"/"$runam"/"$i"/ADAPTERTRIM
			shopt -s nullglob
			for j in "$indir"/"$i"*{R1,r1}*{fastq.gz,fq.gz,fastq,fq}; do
				echo "$j"
				file=$( echo ${j##*/} )
				bbn=$( echo "$file" | cut -d'.' -f1 )
				cutadapt -j $thred -a $p5ada -e $r1e -o "$endir"/"$runam"/"$i"/ADAPTERTRIM/"$bbn".atrim.fastq.gz $j
			done
			for j in "$indir"/"$i"*{R2,r2}*{fastq.gz,fq.gz,fastq,fq}; do
				echo "$j"
				file=$( echo ${j##*/} )
				bbn=$( echo "$file" | cut -d'.' -f1 )
				cutadapt -j $thred -a $p7ada -e $r2e -o "$endir"/"$runam"/"$i"/ADAPTERTRIM/"$bbn".atrim.fastq.gz $j
			done
			shopt -u nullglob
		fi
	done 2> "$endir"/"$runam"/error_adapter.log
}

function barcodetrim {
	list=$( cat $listf )
	echo "BARCODE trim of FASTQ files"
	if [ $erindir == TRUE ]; then
		endir=$( echo $indir )
	fi
	if ! command -v cutadapt &> /dev/null; then
		echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
		exit 1
	fi
	for k in $list; do
		i=$( echo $k | cut -d , -f1 )
		p5=$( echo $k | cut -d , -f2 )
		p7=$( echo $k | cut -d , -f3 )
		barcode_error=$( echo "0.$( echo $((1000*$seeds/${#p5})) )" )
		echo "Barcode trim for $i"
		rm -rf "$endir"/"$runam"/"$i"/BARCODETRIM
		mkdir "$endir"/"$runam"/"$i"/BARCODETRIM
		if [ ! -d "$endir"/"$runam"/"$i"/RUNLOGS ]; then
			mkdir  "$endir"/"$runam"/"$i"/RUNLOGS
		fi
		shopt -s nullglob
		if [ -d "$endir"/"$runam"/"$i"/ADAPTERTRIM ]; then
			zcat "$endir"/"$runam"/"$i"/ADAPTERTRIM/*{r1,R1}.fastq.gz | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz
			zcat "$endir"/"$runam"/"$i"/ADAPTERTRIM/*{r2,R2}.fastq.gz | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R2_input.fastq.gz
		elif [ -d "$endir"/"$runam"/"$i"/BQTRIM ]; then
			zcat "$endir"/"$runam"/"$i"/BQTRIM/*{r1,R1}.fastq.gz | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz
			zcat "$endir"/"$runam"/"$i"/BQTRIM/*{r2,R2}.fastq.gz | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R2_input.fastq.gz
		else
			countr1=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq,fq,fastq.gz,fq.gz} 2>/dev/null | wc -l )
			countr2=$( ls -1 "$indir"/"$i"*{r2,R2}.{fastq,fq,fastq.gz,fq.gz} 2>/dev/null | wc -l )
			if [ $countr1 -eq 0 ] && [ $countr2 -eq 0 ]; then
				countgz=$( ls -1 "$indir"/"$i"*{fastq.gz,fq.gz} 2>/dev/null | wc -l )
				countuz=$( ls -1 "$indir"/"$i"*{fastq,fq} 2>/dev/null | wc -l )
				if [ $countgz -gt 0 ] && [ $countuz -eq 0 ]; then
					zcat "$indir"/"$i"*{fastq.gz,fq.gz} | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_input.fastq.gz
				elif [ $countuz -gt 0 ] && [ $countgz -eq 0 ]; then
					cat "$indir"/"$i"*{fastq,fq} | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_input.fastq.gz
				fi
			elif [ $countr1 -eq $countr2 ]; then
				countgz=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq.gz,fq.gz} 2>/dev/null | wc -l )
				countuz=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq,fq} 2>/dev/null | wc -l )
				if [ $countgz -gt 0 ] && [ $countuz -eq 0 ]; then
					zcat "$indir"/"$i"*{r1,R1}.{fastq.gz,fq.gz} | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz
					zcat "$indir"/"$i"*{r2,R2}.{fastq.gz,fq.gz} | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz
				elif [ $countuz -gt 0 ] && [ $countgz -eq 0 ]; then
					cat "$indir"/"$i"*{r1,R1}.{fastq,fq} | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz
					cat "$indir"/"$i"*{r2,R2}.{fastq,fq} | gzip -f > "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz
				else
					echo "Both gzipped and unzipped files are exist for a certain sample, please gzip or unzip all input"
					exit 1
				fi
			else
				echo "Uneven read pairs are present in input folder, check your input data"
				exit 1
			fi
		fi
		shopt -u nullglob
		if [ $bdisc == TRUE ] || [ $bdisc == true ] || [ $bdisc == T ] || [ $bdisc == t ]; then
			cutadapt \
			-j $thred \
			--discard-untrimmed \
			-g ^$p5 \
			-G ^$p7 \
			-m $minle \
			-e $barcode_error \
			-o "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_bartrim.fastq.gz \
			-p "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R2_bartrim.fastq.gz \
			"$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz \
			"$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R2_input.fastq.gz > "$endir"/"$runam"/"$i"/RUNLOGS/"$i"_barcode_trim.txt
			rm -rf "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz
			rm -rf "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R2_input.fastq.gz
		else
			cutadapt \
			-j $thred \
			-g ^$p5 \
			-G ^$p7 \
			-m $minle \
			-e $barcode_error \
			-o "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_bartrim.fastq.gz \
			-p "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R2_bartrim.fastq.gz \
			"$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz \
			"$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R2_input.fastq.gz > "$endir"/"$runam"/"$i"/RUNLOGS/"$i"_barcode_trim.txt
			rm -rf "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R1_input.fastq.gz
			rm -rf "$endir"/"$runam"/"$i"/BARCODETRIM/"$i"_R2_input.fastq.gz
		fi
		echo $( awk '{for(i=1;i<=NF;i++) if ($i=="filters):") print $(i+1)}' "$endir"/"$runam"/"$i"/RUNLOGS/"$i"_barcode_trim.txt ) | tr --delete "," > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Reads_passed_barcode_trim.txt
		rm -rf "$endir"/"$runam"/"$i"/RUNLOGS/"$i"_barcode_trim.txt
	done 2> "$endir"/"$runam"/error_barcode.log
}

function mergeread {
	basename=$( cat $listf | cut -d, -f1 )
	echo "MERGE PE reads"
	if [ $erindir == TRUE ]; then
		endir=$( echo $indir )
	fi
		if ! command -v seqprep &> /dev/null; then
		echo "SeqPrep is not installed despite overl is set, try sudo apt install seqprep -y, also check dependencies"
		exit 1
	fi
	for i in $basename; do
		if [ ! -d "$endir"/"$runam"/"$i"/RUNLOGS ]; then
			mkdir  "$endir"/"$runam"/"$i"/RUNLOGS
		fi
		echo "Merging reads for $i"
		rm -rf "$endir"/"$runam"/"$i"/MERGE
		mkdir "$endir"/"$runam"/"$i"/MERGE
		shopt -s nullglob
		if [ -d "$endir"/"$runam"/"$i"/BARCODETRIM ]; then
			temppath=$( echo "$endir"/"$runam"/"$i"/BARCODETRIM )
		elif [ -d "$endir"/"$runam"/"$i"/ADAPTERTRIM ]; then
			temppath=$( echo "$endir"/"$runam"/"$i"/ADAPTERTRIM )
		elif [ -d "$endir"/"$runam"/"$i"/BQTRIM ]; then
			temppath=$( echo "$endir"/"$runam"/"$i"/BQTRIM )
		else
			mkdir "$endir"/"$runam"/"$i"/tmp
			temppath=$( echo "$endir"/"$runam"/"$i"/tmp )
			countr1=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq,fq,fastq.gz,fq.gz} 2>/dev/null | wc -l )
			countr2=$( ls -1 "$indir"/"$i"*{r2,R2}.{fastq,fq,fastq.gz,fq.gz} 2>/dev/null | wc -l )
			if [ $countr1 -eq $countr2 ]; then
				countgz=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq.gz,fq.gz} 2>/dev/null | wc -l )
				countuz=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq,fq} 2>/dev/null | wc -l )
				if [ $countgz -gt 0 ] && [ $countuz -eq 0 ]; then
					zcat "$indir"/"$i"*{r1,R1}.{fastq.gz,fq.gz} | gzip -f > "$temppath"/"$i"_R1_minput.fastq.gz
					zcat "$indir"/"$i"*{r2,R2}.{fastq.gz,fq.gz} | gzip -f > "$temppath"/"$i"_R2_minput.fastq.gz
				elif [ $countuz -gt 0 ] && [ $countgz -eq 0 ]; then
					cat "$indir"/"$i"*{r1,R1}.{fastq,fq} | gzip -f > "$temppath"/"$i"_R1_minput.fastq.gz
					cat "$indir"/"$i"*{r2,R2}.{fastq,fq} | gzip -f > "$temppath"/"$i"_R2_minput.fastq.gz
				else
					echo "Both gzipped and unzipped files are exist for a certain sample, please gzip or unzip all input"
					exit 1
				fi
			else
				echo "Uneven read pairs are present in input folder, check your input data"
				exit 1
			fi
		fi
		seqprep \
		-f "$temppath"/*R1*.{fastq.gz,fq.gz,fastq,fq} \
		-r "$temppath"/*R2*.{fastq.gz,fq.gz,fastq,fq} \
		-1 "$endir"/"$runam"/"$i"/MERGE/"$i"_unmerged_R1.fastq.gz \
		-2 "$endir"/"$runam"/"$i"/MERGE/"$i"_unmerged_R2.fastq.gz \
		-L $minle \
		-s "$endir"/"$runam"/"$i"/MERGE/"$i".merged.fastq.gz \
		-o $overl 
		expr $( zcat "$endir"/"$runam"/"$i"/MERGE/"$i".merged.fastq.gz | wc -l ) / 4 &> "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Reads_passed_merging.txt
		shopt -u nullglob
		rm -rf "$endir"/"$runam"/"$i"/tmp
	done | pv 2> "$endir"/"$runam"/error_merge.log
}

function minlentrim {
	basename=$( cat $listf | cut -d, -f1 )
	echo "LENGTH trim of FASTQ files"
	if [ $erindir == TRUE ]; then
		endir=$( echo $indir )
	fi
	if ! command -v cutadapt &> /dev/null; then
		echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
		exit 1
	fi
	shopt -s nullglob
	for i in $basename; do	
		rm -rf "$endir"/"$runam"/"$i"/LENGTHTRIM
		mkdir "$endir"/"$runam"/"$i"/LENGTHTRIM
		if [ ! -d "$endir"/"$runam"/"$i"/RUNLOGS ]; then
			mkdir  "$endir"/"$runam"/"$i"/RUNLOGS
		fi
		for j in "$indir"/"$i"*.{fastq,fastq.gz,fq,fq.gz}; do
			echo "$j"
			file=$( echo ${j##*/} )
			bbn=$( echo "$file" | cut -d'.' -f1 )
			cutadapt -j $thred -q $bqthr -o "$endir"/"$runam"/"$i"/LENGTHTRIM/"$bbn"_"$minle"minlength.fastq.gz $j > "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".minlen.full.txt
			echo $( awk '{for(i=1;i<=NF;i++) if ($i=="filters):") print $(i+2)}' "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".minlen.full.txt ) | tr --delete "," > "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".passedminlen.txt
			expr $( zcat "$endir"/"$runam"/"$i"/BQTRIM/"$bbn".bq"$bqthr".fastq.gz | wc -l ) / 4 &> "$endir"/"$runam"/"$i"/RUNLOGS/"$bbn".readno1.txt
		done
		array1=($(cat "$endir"/"$runam"/"$i"/RUNLOGS/*R1*readno1.txt))
		sum1=$(IFS=+; echo "$((${array1[*]}))")
		echo $sum1 > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Starting_read_number.txt
		array2=($(cat "$endir"/"$runam"/"$i"/RUNLOGS/*passedminlen.txt))
		sum2=$(IFS=+; echo "$((${array2[*]}))")
		echo $sum2 > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Minlength_passed_reads.txt
		rm -rf "$endir"/"$runam"/"$i"/RUNLOGS/*.passedminlen.txt
		rm -rf "$endir"/"$runam"/"$i"/RUNLOGS/*.readno1.txt
		rm -rf "$endir"/"$runam"/"$i"/RUNLOGS/*.minlen.full.txt
	done 2> "$endir"/"$runam"/error_minlength.log
	shopt -u nullglob
}

function mapping {
	basename=$( cat $listf | cut -d, -f1 )
	echo "MAPPING of reads to reference"
	if [ $erindir == TRUE ]; then
		endir=$( echo $indir )
	fi
	shopt -s nullglob
	for i in $basename; do
		rm -rf "$endir"/"$runam"/"$i"/ALNFILES
		mkdir "$endir"/"$runam"/"$i"/ALNFILES
		if [ ! -d "$endir"/"$runam"/"$i"/RUNLOGS ]; then
			mkdir  "$endir"/"$runam"/"$i"/RUNLOGS
		fi
		echo "Mapping $i to reference"
		if [ $overl -gt 0 ] || [ -d "$endir"/"$runam"/"$i"/MERGE ]; then
			if [ -d "$endir"/"$runam"/"$i"/LENGTHTRIM ]; then
				temppath=$( echo "$endir"/"$runam"/"$i"/LENGTHTRIM )
			elif [ -d "$endir"/"$runam"/"$i"/MERGE ]; then
				temppath=$( echo "$endir"/"$runam"/"$i"/MERGE )
			elif [ -d "$endir"/"$runam"/"$i"/BARCODETRIM ]; then
				temppath=$( echo "$endir"/"$runam"/"$i"/BARCODETRIM )
			elif [ -d "$endir"/"$runam"/"$i"/ADAPTERTRIM ]; then
				temppath=$( echo "$endir"/"$runam"/"$i"/ADAPTERTRIM )
			elif [ -d "$endir"/"$runam"/"$i"/BQTRIM ]; then
				temppath=$( echo "$endir"/"$runam"/"$i"/BQTRIM )
			else
				mkdir "$endir"/"$runam"/"$i"/tmp
				temppath=$( echo "$endir"/"$runam"/"$i"/tmp )
				countr1=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq,fq,fastq.gz,fq.gz} 2>/dev/null | wc -l )
				countr2=$( ls -1 "$indir"/"$i"*{r2,R2}.{fastq,fq,fastq.gz,fq.gz} 2>/dev/null | wc -l )
				if [ $countr1 -eq 0 ] && [ $countr2 -eq 0 ]; then
					countgz=$( ls -1 "$indir"/"$i"*{fastq.gz,fq.gz} 2>/dev/null | wc -l )
					countuz=$( ls -1 "$indir"/"$i"*{fastq,fq} 2>/dev/null | wc -l )
					if [ $countgz -gt 0 ] && [ $countuz -eq 0 ]; then
						zcat "$indir"/"$i"*{fastq.gz,fq.gz} | gzip -f > "$temppath"/"$i"_input.fastq.gz
					elif [ $countuz -gt 0 ] && [ $countgz -eq 0 ]; then
						cat "$indir"/"$i"*{fastq,fq} | gzip -f > "$temppath"/"$i"_input.fastq.gz
					fi
				elif [ $countr1 -eq $countr2 ]; then
					countgz=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq.gz,fq.gz} 2>/dev/null | wc -l )
					countuz=$( ls -1 "$indir"/"$i"*{r1,R1}.{fastq,fq} 2>/dev/null | wc -l )
					if [ $countgz -gt 0 ] && [ $countuz -eq 0 ]; then
						zcat "$indir"/"$i"*{r1,R1}.{fastq.gz,fq.gz} | gzip -f > "$temppath"/"$i"_R1_minput.fastq.gz
						zcat "$indir"/"$i"*{r2,R2}.{fastq.gz,fq.gz} | gzip -f > "$temppath"/"$i"_R2_minput.fastq.gz
					elif [ $countuz -gt 0 ] && [ $countgz -eq 0 ]; then
						cat "$indir"/"$i"*{r1,R1}.{fastq,fq} | gzip -f > "$temppath"/"$i"_R1_minput.fastq.gz
						cat "$indir"/"$i"*{r2,R2}.{fastq,fq} | gzip -f > "$temppath"/"$i"_R2_minput.fastq.gz
					else
						echo "Both gzipped and unzipped files are exist for a certain sample, please gzip or unzip all input"
						exit 1
					fi
				else
					echo "Uneven read pairs are present in input folder, check your input data"
					exit 1
				fi
			fi
			if [ $align -eq BWA_ALN ]; then
				if ! command -v bwa &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
				bwa aln -t $thred -k $seeds $refer "$temppath"/"$i"*{fastq.gz,fq.gz,fastq,fq} > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sai
				bwa samse $refer "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sai "$temppath"/"$i"*{fastq.gz,fq.gz,fastq,fq} > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sam
				samtools view -b "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sam > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.bam
				samtools sort -o "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sorted.bam "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.bam
				if [ $krbam == FALSE ]; then
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.bam
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sam
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sai
				fi
				if [ $rmdup == FALSE ]; then
					samtools index "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sorted.bam
				fi
				samtools view -F 0x904 "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_se.sorted.bam | cut -f 1 | sort | uniq | wc -l > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Reads_mapped.txt
			elif [ $align -eq BWA_MEM ]; then
				if ! command -v bwa &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
				bwa mem -t $thred $refer "$temppath"/"$i"*{fastq.gz,fq.gz,fastq,fq} > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.sam
				samtools view -b "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.sam > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.bam
				samtools sort -o "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.sorted.bam "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.bam
				if [ $krbam == FALSE ]; then
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.bam
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.sam
				fi
				if [ $rmdup == FALSE ]; then
					samtools index "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.sorted.bam
				fi
				samtools view -F 0x904 "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_se.sorted.bam | cut -f 1 | sort | uniq | wc -l > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Reads_mapped.txt
			elif [ $align -eq Bowtie2_EVF ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
				bowtie2 --end-to-end --very-fast --un-gz "$endir"/"$runam"/"$i"/ALNFILES/"$i".unmapped_reads.fastq.gz -t --met-file "$endir"/"$runam"/"$i"/ALNFILES/"$i".metrics.log -p $thred -x $befer -U "$temppath"/"$i"*{fastq.gz,fq.gz,fastq,fq} -S "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.sam > "$endir"/"$i"/ALNFILES/"$i".bt2_evf_se.log
				samtools view -b "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.sam > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.bam
				samtools sort -o "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.sorted.bam "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.bam
				if [ $krbam == FALSE ]; then
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.bam
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.sam
				fi
				if [ $rmdup == FALSE ]; then
					samtools index "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.sorted.bam
				fi
				samtools view -F 0x904 "$endir"/"$runam"/"$i"/ALNFILES/"$i".bt2_evf_se.sorted.bam | cut -f 1 | sort | uniq | wc -l > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Reads_mapped.txt
			elif [ $align -eq Bowtie2_EF ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_EVS ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_ES ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_LVF ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_LF ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_LVS ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_LS ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			else
				echo "align option was incorrectly set, check PARAMETERFILE"
				exit 1
			fi
		else
			if [ $align -eq BWA_ALN ]; then
				if ! command -v bwa &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
				bwa aln -t $thred -k $seeds $refer "$temppath"/"$i"*{r1,R1}*{fastq.gz,fq.gz,fastq,fq} > "$endir"/"$runam"/"$i"/ALNFILES/"$i".R1.bwa_aln_pe.sai
				bwa aln -t $thred -k $seeds $refer "$temppath"/"$i"*{r2,R2}*{fastq.gz,fq.gz,fastq,fq} > "$endir"/"$runam"/"$i"/ALNFILES/"$i".R2.bwa_aln_pe.sai
				bwa sampe $refer "$endir"/"$runam"/"$i"/ALNFILES/"$i".R1.bwa_aln_pe.sai "$endir"/"$runam"/"$i"/ALNFILES/"$i".R2.bwa_aln_pe.sai "$temppath"/"$i"*{r1,R1}*{fastq.gz,fq.gz,fastq,fq} "$temppath"/"$i"*{r2,R2}*{fastq.gz,fq.gz,fastq,fq} > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.sam
				samtools view -b "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.sam > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.bam
				samtools sort -o "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.sorted.bam "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.bam
				if [ $krbam == FALSE ]; then
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.bam
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.sam
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".R1.bwa_aln_pe.sai
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".R2.bwa_aln_pe.sai
				fi
				if [ $rmdup == FALSE ]; then
					samtools index "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.sorted.bam
				fi
				samtools view -F 0x904 "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_aln_pe.sorted.bam | cut -f 1 | sort | uniq | wc -l > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Reads_mapped.txt
			elif [ $align -eq BWA_MEM ]; then
				if ! command -v bwa &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
				bwa mem -t $thred $refer "$temppath"/"$i"*{r1,R1}*{fastq.gz,fq.gz,fastq,fq} "$temppath"/"$i"*{r2,R2}*{fastq.gz,fq.gz,fastq,fq} > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.sam
				samtools view -b "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.sam > "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.bam
				samtools sort -o "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.sorted.bam "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.bam
				if [ $krbam == FALSE ]; then
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.bam
					rm -rf "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.sam
				fi
				if [ $rmdup == FALSE ]; then
					samtools index "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.sorted.bam
				fi
				samtools view -F 0x904 "$endir"/"$runam"/"$i"/ALNFILES/"$i".bwa_mem_pe.sorted.bam | cut -f 1 | sort | uniq | wc -l > "$endir"/"$runam"/"$i"/RUNLOGS/"$i".Reads_mapped.txt
			elif [ $align -eq Bowtie2_EVF ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_EF ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_EVS ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_ES ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_LVF ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_LF ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_LVS ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			elif [ $align -eq Bowtie2_LS ]; then
				if ! command -v bowtie2 &> /dev/null; then
					echo "Cutadapt is not installed despite bqthr is set, try sudo apt install cutadapt -y, also check dependencies"
					exit 1
				fi
			else
				echo "align option was incorrectly set, check PARAMETERFILE"
				exit 1
			fi
		fi
		rm -rf "$endir"/"$runam"/"$i"/tmp
	done 2> "$endir"/"$runam"/error_mapping.log
	shopt -u nullglob
}

function duplicate {
	
}

function sexdeter {
	
}

function mapdamage {
	
}

function contamix {
	
}

function readendtrim {
	
}

function fastamaker {
	
}

function yleaf {
	
}

function pigment {
	
}

function disease {
	
}

function diploidcall {
	
}

function haplocall {
	
}

function eigenstrat {
	
}

function plinkcall {
	
}

function reportmake {
	
}
