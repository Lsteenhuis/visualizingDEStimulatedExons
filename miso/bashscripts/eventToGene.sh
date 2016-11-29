#This script converts the event names from MISO to ENSMBL ID's.
#It uses the given .gff3 annotation file of the used events.
#Lastly it writes the stimuli name and ENSMBL ID's to the given output file

#input file (path to file)
geneFile=$1

#setting Internal Field Seperator (IFS) to '' and read through the inputfile
while IFS='' read -r line || [[ -n "$line" ]]; do
	for line in $geneFile; do 

		#initializing geneList
		geneList=''

		#splits the line on tab and saves the 2nd column (the list of exons).
		listOfExons=$( echo "$line" | cut -f 2)
		
		#set IFS to , to split the comma separated line
		IFS=',' read -ra ExonSep <<< "$listOfExons"
		for i in "${ExonSep[@]}"; do
			#greps the event line from  the annotation file, and uses perl regex to retrieve the ENSMBL id.
			geneNameEvent=$(echo `grep "$i.*ensg_id=" /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/alternative_events/hg19/SE.hg19.gff3` | perl -n -e'/ensg_id=(.*);g/ && print $1')
			geneList="$geneList$geneNameEvent",""
		done
	
	#writes stimuli \t listOfGenes to output file.
	echo -e "$( echo "$line" | cut -f 1) \t ${geneList%?}" >> ${geneFile%.*}.genes.txt

	sets IFS back to '' for the while loop
	IFS=''
done < "$1"
