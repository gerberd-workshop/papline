#!/bin/bash
help()
{
	echo "PAPline version 1 by Daniel Gerber"
	echo ""
	echo "Performing Archaeogenetic Pipeline, abbreviated as PAPline is a user friendly software that helps to process data fast and efficiently, mainly optimised for aDNA analyses."
	echo ""
	echo "Available at Github under https://github.com/gerberd-workshop/papline"
	echo ""
	echo "Citation:"
	echo "Gerber et al. 2022 Bronze age communities from Western Hungary reveal complex population histories"
	echo ""
	echo "Options:"
	echo "	-a	Auto mode, provide parameterfile, see README"
	echo "	-h	Print this message"
	echo "	-g	Start GUI version"	
}
GUI=false
while getopts a:gh opts
do
	case "${opts}" in
		a) INPUT=${OPTARG}; echo "$INPUT" > ./tmp/parampath; ./src/contratest.sh;;
		g) GUI=true; ./src/papline_gui.sh;;
		h) help; exit 2;;
		\?) echo "Unknown option: -$OPTARG" >&2; exit 1;;
		:) echo "Missing option for: -$OPTARG" >&2; exit 1;;
	esac
done
if (( $OPTIND == 1 )); then help; fi
