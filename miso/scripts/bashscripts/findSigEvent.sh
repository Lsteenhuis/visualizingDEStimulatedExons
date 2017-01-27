#!/bin/bash
# This script converts the event names from MISO to ENSMBL ID's.
# It uses the given .gff3 annotation file of the used events.
# Lastly it writes the stimuli name and ENSMBL ID's to the given output file

# File containing gene and ensembl ID's)
biomartFile="../biomart_file/mart_export-5.txt"

# The function replaces the event names in MISO matrices to gene name based.

function replaceEventNameToGeneName {
	
	# File containing the miso results
        file=$1
		
	# The reference .gff file
        reference=$2
	
	#greps the stimuli name from the file name	
        stimuli=$(echo $file | perl -ne '/\/([A-Z].*h)/ && print $1')
        referenceFile="../matrices/$reference/"$stimuli"_$reference""_Matrix.tsv"
        outFile="../matrices/$reference""_named/$stimuli""_""$reference""_matrix.tsv"
        
	# reads miso result file line by line 
	while read line; do
		# prints the file header to the file when found
                if [[ $line == *"Stimuli"* ]]; then
                        fileHeader=$(echo `head -n1 $referenceFile`)
                        echo $fileHeader >> $outFile
                else
		# setting IFS to tabs and splitting the current line
                IFS='   ' read -ra eventLine <<< "$line"
                # The event name
		eventCode=${eventLine[2]}
                geneLine=$(echo `grep $eventCode $referenceFile ` |  perl -ne '/(\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*)/ && print $1' ) 
                echo -e "$line \t $geneLine" >> $outFile
                IFS=' '
                fi
        done<$file
}


#Loops through each MISO result file
for file in ../matrices/eventNames/*txt; do
	# greps the used MISO mode
	mode=$(echo $file | perl -ne '/([A-Z\d]+)_/ && print $1')
	
	# greps the stimuli name
	stimuli=$(echo $file | perl -ne '/[A-Z\d]+_(.*_\d+h)/ && print $1')
	
	# generates output name
	outputFile="../matrices/eventGenes/$stimuli""_event_names.tsv"
	
	# Creates header if file does not exist
	if [ ! -f $outputFile ]; then
		echo -e "StimuliName\tEventType\tEventName\tEnsemblId\tGeneName" >> $outputFile
	fi 

	# reads the file line by line
	while read line; do
		# greps ensembl ID from the line
		ensemblId=$(echo `grep "$line" ../alternative_events/hg19/$mode.hg19.gff3` | perl -n -e'/ensg_id=(.*);g/ && print $1')
		if [[ $ensemblId == *"NA"* ]]; then 
			continue
		else
			# checks if there are multiple ensembl IDs
			if [[ $ensemblId == *","* ]] ; then
				# set  IFS to , and split line into array of IDs
	                	IFS=',' read -ra multiGene <<< "$ensemblId"
				
				# greps the gene name for each ensembl ID
                        	for i in "${multiGene[@]}"; do
                        	        geneLine=$(echo `grep $i $biomartFile` | perl -n -e '/ENSG\d+\s(\w+)/ && print $1')
                        	        echo -e "$stimuli\t$mode\t $line\t$i\t$geneLine" >> $outputFile
                       	 	done
				# resets the IFS
				IFS=' '
		
			else	
				# greps gene name for ensembl id
                    		geneLine=$(echo `grep $ensemblId $biomartFile` | perl -n -e '/ENSG\d+\s(\w+)/ && print $1')
                        	echo -e "$stimuli\t$mode\t$line\t$ensemblId\t$geneLine" >> $outputFile
			fi
		fi		
	done<$file
done

# sets gene names in the matrices 
for file in ../matrices/eventGenes/*.tsv; do
        replaceEventNameToGeneName $file "occurence"
done

for file in ../matrices/eventGenes/*.tsv; do
        replaceEventNameToGeneName $file "psi"
done

for file in ../matrices/eventGenes/*.tsv; do
        replaceEventNameToGeneName $file "bf"
done

