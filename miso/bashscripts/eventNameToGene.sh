#!/bin/bash
#This script converts the event names from MISO to ENSMBL ID's.
#It uses the given .gff3 annotation file of the used events.
#Lastly it writes the stimuli name and ENSMBL ID's to the given output file

#input file (path to file)
biomartFile="../biomart_file/mart_export-5.txt"
#echo -e "Stimuli name \t Event Type \t Event name \t ensembl id \t gene name" >> $outputFile


function replaceEventNameToGeneName {
        file=$1
        reference=$2
        stimuli=$(echo $file | perl -ne '/\/([A-Z].*h)/ && print $1')
        referenceFile="../matrices/$reference/"$stimuli"_$reference""_Matrix.tsv"
        outFile="../matrices/$reference""_named/$stimuli""_""$reference""_matrix.tsv"
        while read line; do
                if [[ $line == *"Stimuli"* ]]; then
                        fileHeader=$(echo `head -n1 $referenceFile`)
                        echo $fileHeader >> $outFile
                else

                IFS='   ' read -ra eventLine <<< "$line"
                eventCode=${eventLine[2]}
                geneLine=$(echo `grep $eventCode $referenceFile ` |  perl -ne '/(\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*\s+\d+.?\d*)/ && print $1' ) 
                echo -e "$line \t $geneLine" >> $outFile
                IFS=' '
                fi
        done<$file
}


for file in ../matrices/eventNames/*txt; do
	mode=$(echo $file | perl -ne '/([A-Z\d]+)_/ && print $1')
	stimuli=$(echo $file | perl -ne '/[A-Z\d]+_(.*_\d+h)/ && print $1')
	outputFile="../matrices/eventGenes/$stimuli""_event_names.tsv"
	if [ ! -f $outputFile ]; then
		echo -e "StimuliName\tEventType\tEventName\tEnsemblId\tGeneName" >> $outputFile
	fi 
	while read line; do
		ensemblId=$(echo `grep "$line" ../alternative_events/hg19/$mode.hg19.gff3` | perl -n -e'/ensg_id=(.*);g/ && print $1')
		if [[ $ensemblId == *"NA"* ]]; then 
			continue
		else
			if [[ $ensemblId == *","* ]] ; then
	                	IFS=',' read -ra multiGene <<< "$ensemblId"
                        	for i in "${multiGene[@]}"; do
                        	        geneLine=$(echo `grep $i $biomartFile` | perl -n -e '/ENSG\d+\s(\w+)/ && print $1')
                        	        echo -e "$stimuli\t$mode\t $line\t$i\t$geneLine" >> $outputFile
                       	 	done
				IFS=' '
		
			else
                    		geneLine=$(echo `grep $ensemblId $biomartFile` | perl -n -e '/ENSG\d+\s(\w+)/ && print $1')
                        	echo -e "$stimuli\t$mode\t$line\t$ensemblId\t$geneLine" >> $outputFile
			fi
		fi		
	done<$file
done

for file in ../matrices/eventGenes/*.tsv; do
        replaceEventNameToGeneName $file "occurence"
done

for file in ../matrices/eventGenes/*.tsv; do
        replaceEventNameToGeneName $file "psi"
done

for file in ../matrices/eventGenes/*.tsv; do
        replaceEventNameToGeneName $file "bf"
done

