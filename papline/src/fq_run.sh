#!/bin/bash

source ./tmp/paramwork
source ./src/functions.sh

if defaults; then
	echo "Defaults are set"
else
	echo "Something is wrong with settings, check PARAMETERFILE"
fi

if dirmake; then 
	echo "Creating directories was successful"
	if [ $erendir == TRUE ]; then
		rm "$endir"/error_dirmake.log
		cp ./src/logtemplate "$endir"/"$runam"/papli_log
	else
		rm "$indir"/error_dirmake.log
		cp ./src/logtemplate "$indir"/"$runam"/papli_log
	fi
else
	echo "Creating directories was unsuccessful, check logfile"
	exit 1
fi

if [ ! -z $fstqc ]; then
	if [ $fstqc == TRUE ] || [ $fstqc == true ] || [ $fstqc == T ] || [ $fstqc == t ]; then
		if fastqc; then
			echo "FASTQC run was successful"
			if [ $erendir == TRUE ]; then
				rm "$endir"/error_dirmake.log
				sed -i "s/fstqc_run=F/fstqc_run=T/g" "$endir"/"$runam"/papli_log
			else
				rm "$indir"/error_dirmake.log
				sed -i "s/fstqc_run=F/fstqc_run=T/g" "$indir"/"$runam"/papli_log
			fi
		else
			echo "FASTQC run was unsuccessful, check logfile"
		fi
	fi
fi

