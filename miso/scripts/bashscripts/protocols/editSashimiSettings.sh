#!/bin/bash
# this file sets the settings for the sashimi plot based on the MISO output in eventFile

#Path to sashimi sttings file
sashimiSettings=/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/settings/sashimi_plot_settings.txt
# Path to the mappedReadCount of the BAM files
mappedReadCounts=/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/projects/variousStimuli/001/results/alignment/untrimmed/mappedReadCounts/readCounts.txt
# Colour table for the plots
colourTable=("#F30C0C" "#F3F30C" "#0CF351" "#0CF351" "#F30CD8" "#F30CD8" "#2F0CF3" "#2F0CF3" "#0CF3EF" "#0CF3EF"  "#F77700" "#F77700" "#8C00F7" "#8C00F7" "#D2691E" "#D2691E")
# Letters for the volunteers
letterArray=("A" "B" "C" "D" "F" "G" "H")
# File which events to plot
eventFile=$1

# reads eventFile line by line
while read eventLine; do
	IFS='        ' read -ra ADDR <<< "$eventLine"
		
		numberOfStimuli=0
		mode=${ADDR[1]}
		time=${ADDR[3]}
		event=${ADDR[0]}
		stimuliList=${ADDR[3]}
		echo $event
		#echo $event
		#load the file in array stimuliList
		bamFiles="["
		misoFiles="["
		readCounts="["
		colourList="["
		
		# Create arrays for BAM files, readcounts and the to be used miso files
 		for letter in "${letterArray[@]}"; do
 			numberOfStimuli=`expr $numberOfStimuli + 2`
 			bamFiles="$bamFiles\"$letter\_$stimuli\_$time.sorted.merged.dedup.bam\","
 			readCount=$(echo `grep "$letter\_$stimuli\_$time" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}')
 			readCounts="$readCounts\"$readCount\","
 			bamFiles="$bamFiles\"$letter\_RPMI\_$time.sorted.merged.dedup.bam\","
 			readCount="$(echo `grep "$letter\_RPMI\_$time" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}')"
 			readCounts="$readCounts\"$readCount\","


 			#echo `grep "$letter\_RPMI\_$time" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}'
 			misoFiles="$misoFiles\"$letter\_$stimuli\","
 			misoFiles="$misoFiles\"$letter\_RPMI\","
 		done
		
		#Selects amount of colours based on number of stimuli
 		end=$numberOfStimuli
 		for i in $(seq 1 $numberOfStimuli); do
 			index=$((i-1 % numberOfStimuli))
 			colourList="$colourList\"${colourTable[$index]}\","
 		done

 		#replace the last character (,) with an ]# 		bamFiles="${bamFiles%?}]"
 		misoFiles="${misoFiles%?}]"
 		readCounts="${readCounts%?}]"
 		colourList="${colourList%?}]"
 		
 		#Sets all settings in the sashimiplot settings file
 		sed -i "s/mode/$mode/g" $sashimiSettings
 		sed -i "s/bam_files\=/bam_files\=$bamFiles/g" $sashimiSettings
 		sed -i "s/miso_files\=/miso_files\=$misoFiles/g" $sashimiSettings
 		sed -i "s/coverages\=/coverages\=$readCounts/g" $sashimiSettings
 		sed -i "s/colors\=/colors\=$colourList/g" $sashimiSettings
 		sed -i "s/time/$time\//g" $sashimiSettings
		
		# greps eventname which need to be plotted 
 		geneNameEvent=$(echo `grep "$event.*ensg_id=" /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/alternative_events/hg19/$mode.hg19.gff3` | perl -n -e'/ensg_id=(.*);g/ && print $1')
		
		#plots the gene event
 		bash /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/bashscripts/protocols/sashimi.sh $event $geneNameEvent $time $stimuli $mode

		#resets the settings file
 	        sed -i "s/bam_files\=.*/bam_files\=/g" $sashimiSettings
 	        sed -i "s/miso_files\=.*/miso_files\=/g" $sashimiSettings
 	        sed -i "s/coverages\=.*/coverages\=/g" $sashimiSettings
 	        sed -i "s/colors\=.*/colors\=/g" $sashimiSettings
 		sed -i "s/miso_prefix\=.*/miso_prefix=/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/miso_output/mode/time/g $sashimiSettings"
done<$eventFile
