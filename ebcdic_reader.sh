#!/bin/bash

HELP(){
	echo "---------------------------------------------------"
	echo " Options List:"
	echo -e "---------------------------------------------------\n"
	echo " -l --> Set the record lenght for the fixed file"
	echo "        default is 1."
	echo " -s --> Substituite space characters with another" 
	echo "        character."
	echo " -z --> Substitute non ASCII characters with the"
	echo "        provided character. Default is '#'."
	echo ""
	echo -e " The script output is directed to stdout.\n\n"
	echo ""
	exit 1
}


RECORDLENGHT=1
NOTASCIICHAR="#"
SPACESUB=" "


NUMARGS=$#
if [ $NUMARGS -eq 0 ]; then
	HELP
fi

echo $FILENAME

while getopts :l:s:z:h FLAG "${MY_OWN_SET[@]}"; do
	case $FLAG in
		l)	RECORDLENGHT=$OPTARG
			;;
		s)	SPACESUB="$OPTARG"
			;;
		z)	NOTASCIICHAR="$OPTARG"
			;;
		h)	HELP
			;;
		\?)	echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
			HELP
		;;
	esac
done

shift $((OPTIND-1))

FILENAME=$1
#echo "record lenght = '$RECORDLENGHT'"
#echo "space sub = '$SPACESUB'"
#echo "notasciichar = '$NOTASCIICHAR'"
#echo "filename = '$FILENAME'"

dd if=$FILENAME conv=ascii status=noxfer  2> /dev/null | perl -pe "s/[^[:ascii:]]/$NOTASCIICHAR/g" | sed "s# #$SPACESUB#g" | sed -e "s/.\{$RECORDLENGHT\}/&\n/g"
