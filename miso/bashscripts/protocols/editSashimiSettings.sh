#!/bin/bash


sashimiSettings=/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/settings/sashimi_plot_settings.txt
mappedReadCounts=/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/projects/variousStimuli/001/results/alignment/untrimmed/mappedReadCounts/readCounts.txt
colourTable=("#F30C0C" "#F3F30C" "#0CF351" "#0CF351" "#F30CD8" "#F30CD8" "#2F0CF3" "#2F0CF3" "#0CF3EF" "#0CF3EF"  "#F77700" "#F77700" "#8C00F7" "#8C00F7" "#D2691E" "#D2691E")
letterArray=("A" "B" "C" "D" "F" "G" "H")
eventFile=$1
#open every file in the specified dir
#for D in `find /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso//exonFiles/SE/ -mindepth 3 -type d`; do
#for D in `find /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/exonFiles/SE/*h/vol_* -mindepth 1 -type d`; do


while read eventLine; do
	IFS='        ' read -ra ADDR <<< "$eventLine"
		numberOfStimuli=0
		#secho $ADDR
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

# 		for letter in "${letterArray[@]}"; do
# 			numberOfStimuli=`expr $numberOfStimuli + 2`
# 			bamFiles="$bamFiles\"$letter\_$stimuli\_$time.sorted.merged.dedup.bam\","
# 			readCount=$(echo `grep "$letter\_$stimuli\_$time" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}')
# 			readCounts="$readCounts\"$readCount\","
#
# 			bamFiles="$bamFiles\"$letter\_RPMI\_$time.sorted.merged.dedup.bam\","
# 			readCount="$(echo `grep "$letter\_RPMI\_$time" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}')"
# 			readCounts="$readCounts\"$readCount\","
#
#
# 			#echo `grep "$letter\_RPMI\_$time" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}'
# 			misoFiles="$misoFiles\"$letter\_$stimuli\","
# 			misoFiles="$misoFiles\"$letter\_RPMI\","
# 		done
#
# 		end=$numberOfStimuli
# 		for i in $(seq 1 $numberOfStimuli); do
# 			index=$((i-1 % numberOfStimuli))
# 			colourList="$colourList\"${colourTable[$index]}\","
# 		done
#
# 		#replace the last character (,) with an ]
# 		bamFiles="${bamFiles%?}]"
# 		misoFiles="${misoFiles%?}]"
# 		readCounts="${readCounts%?}]"
# 		colourList="${colourList%?}]"
# 		echo $readCounts
# 		#echo $colourList
# 		sed -i "s/mode/$mode/g" $sashimiSettings
# 		sed -i "s/bam_files\=/bam_files\=$bamFiles/g" $sashimiSettings
# 		sed -i "s/miso_files\=/miso_files\=$misoFiles/g" $sashimiSettings
# 		sed -i "s/coverages\=/coverages\=$readCounts/g" $sashimiSettings
# 		sed -i "s/colors\=/colors\=$colourList/g" $sashimiSettings
# 		sed -i "s/time/$time\//g" $sashimiSettings
#
# 		geneNameEvent=$(echo `grep "$event.*ensg_id=" /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/alternative_events/hg19/$mode.hg19.gff3` | perl -n -e'/ensg_id=(.*);g/ && print $1')
# 		#echo "plotting $stimuli $geneNameEvent $mode"
# 		bash /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/bashscripts/protocols/sashimi.sh $event $geneNameEvent $time $stimuli $mode
# 		#sleep 20
# 		#echo "test"
# 	        sed -i "s/bam_files\=.*/bam_files\=/g" $sashimiSettings
# 	        sed -i "s/miso_files\=.*/miso_files\=/g" $sashimiSettings
# 	        sed -i "s/coverages\=.*/coverages\=/g" $sashimiSettings
# 	        sed -i "s/colors\=.*/colors\=/g" $sashimiSettings
# 		#sed -i "s/miso_prefix\=.*/miso_prefix=/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/miso_output/mode/time/g $sashimiSettings"
done<$eventFile
