#!/bin/bash


sashimiSettings=/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/settings/sashimi_plot_settings.txt
mappedReadCounts=/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/projects/variousStimuli/001/results/alignment/untrimmed/mappedReadCounts/readCounts.txt
colourTable=("#F30C0C" "#F30CD8" "#2F0CF3" "#0CF3EF" "#0CF351" "#F3F30C" "#F77700" "#8C00F7")


#open every file in the specified dir
#for D in `find /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso//exonFiles/SE/ -mindepth 3 -type d`; do
for D in `find /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso//exonFiles/SE/*h/vol_* -mindepth 1 -type d`; do
	for event in $D/*.txt; do
		if [ ! -f $event ]; then
			echo "continu"
			continue
		fi
		#echo $event
		#load the file in array stimuliList
		stimuliList=( `cat "$event"`)
     		eventBasefile=${event##*/}
        	eventBasename=${eventBasefile%.txt}

		bamFiles="["
		misoFiles="["
		readCounts="["
		colourList="["
		numberOfStimuli=0
	
		#loop through every stimuli in the exon file
		for stimuli in ${stimuliList[@]}; do
                        stimuliBasefile=${stimuli##*/}
                        stimuliBasename=${stimuliBasefile%.miso_bf.filtered}
			stimuliOne=$(echo "${stimuliBasename}" |  awk 'BEGIN {FS="_vs_"} {print $1}')
                        stimuliTwo=$(echo "${stimuliBasename}" |  awk 'BEGIN {FS="_vs_"} {print $2}')
			time=$(echo $D | perl -n -e'/(\d+h)/ && print $1')
                        time=_$time
			if [[ ! $bamFiles == *"$stimuliOne"* ]]; then
				let numberOfStimuli=$numberOfStimuli+1
				#echo $stimuliOne
				bamFiles="$bamFiles\"$stimuliOne$time.sorted.merged.dedup.bam\","
				#echo $bamFiles
                        	if grep -Fq "$stimuliOne" $mappedReadCounts
                        	then
                            		readCount=$(echo `grep "$stimuliOne" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}')
	                                #echo $readCount
	                                readCounts="$readCounts$readCount,"
        	                fi
				misoFiles="$misoFiles\"$stimuliOne\","
			fi
			if [[ ! $bamFiles == *"$stimuliTwo"* ]]; then
				let numberOfStimuli=$numberOfStimuli+1
				bamFiles="$bamFiles\"$stimuliTwo$time.sorted.merged.dedup.bam\","                    
				if grep -Fq "$stimuliTwo" $mappedReadCounts
                        	then
                            		readCount=$(echo `grep "$stimuliTwo" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}')
                                	readCounts="$readCounts$readCount,"
                        	fi
				misoFiles="$misoFiles\"$stimuliTwo\","
			fi
			#let numberOfStimuli=$numberOfStimuli+1
			#get the basename of the stimuli file
			#stimuliBasefile=${stimuli##*/}
			#stimuliBasename=${stimuliBasefile%.miso_bf.filtered}
			#time=$(echo $D | perl -n -e'/(\d+h)/ && print $1')
			#time=_$time
		
			#split the stimuli on _vs_ this results in two strings with the stimuli
			#stimuliOne=$(echo "${stimuliBasename}" |  awk 'BEGIN {FS="_vs_"} {print $1}')
			#stimuliTwo=$(echo "${stimuliBasename}" |  awk 'BEGIN {FS="_vs_"} {print $2}')
			#if grep -Fq "$stimuliOne" $mappedReadCounts
			#then
			#	readCount=$(echo `grep "$stimuliOne" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}')
			#	#echo $readCount
			#	readCounts="$readCounts$readCount,"
			#fi
		

			#if grep -Fq "$stimuliTwo" $mappedReadCounts
			#then
			#	readCount=$(echo `grep "$stimuliTwo" $mappedReadCounts` | awk 'BEGIN {FS=";"} {print $1}')
	                #         readCounts="$readCounts$readCount,"
			#fi		

			#add both stimuli names in the bamFiles and misoFiles list
			#if [[ ! $bamFiles == *"$stimuliOne"* && ! $bamFiles == *"$stimuliTwo"* ]]; then
			#bamFiles="$bamFiles\"$stimuliOne$time.sorted.merged.dedup.bam\","
			#bamFiles="$bamFiles\"$stimuliTwo$time.sorted.merged.dedup.bam\","
			#echo $bamFiles
			#misoFiles="$misoFiles\"$stimuliOne\","
			#misoFiles="$misoFiles\"$stimuliTwo\","
			#fi
		
		done
		#echo $numberOfStimuli
		end=$numberOfStimuli
		for i in $(seq 1 $numberOfStimuli); do
			index=$((i-1 % numberOfStimuli))
			colourList="$colourList\"${colourTable[$index]}\","		
		done
	
	
	if [ ! "$(ls -A $D)" ]; then
		continue;
	fi
	#replace the last character (,) with an ] 
	bamFiles="${bamFiles%?}]"
	misoFiles="${misoFiles%?}]"
	readCounts="${readCounts%?}]"
	bamFilesLength=${#bamFiles[@]}
	colourList="${colourList%?}]"
	
	#echo $numberOfStimuli	
	
	sed -i "s/bam_files\=/bam_files\=$bamFiles/g" $sashimiSettings
	sed -i "s/miso_files\=/miso_files\=$misoFiles/g" $sashimiSettings
	sed -i "s/coverages\=/coverages\=$readCounts/g" $sashimiSettings
	sed -i "s/colors\=/colors\=$colourList/g" $sashimiSettings
	#echo $bamFiles
	#echo $misoFiles
	#echo $readCounts
	#echo $eventBasename
	#echo $D
	stimuli=$(echo $D | perl -n -e'/\d+h\/(\w+(?:-\w+)?)/ && print $1')
	i=$((${#D}-1))
	amount="${D:$i:1}"
	time=$(echo $D | perl -n -e'/(\d+h)/ && print $1')
	sed -i "s/time/$time/g" $sashimiSettings
	#echo $stimuli
	#echo $amount
	#echo $time
	geneNameEvent=$(echo `grep "$eventBasename.*ensg_id=" /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/alternative_events/hg19/SE.hg19.gff3` | perl -n -e'/ensg_id=(.*);g/ && print $1')
	echo "plotting $stimuli $geneNameEvent $amount"
	bash /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/bashscripts/protocols/sashimi.sh $eventBasename $geneNameEvent $time $stimuli $amount
	#sleep 20
	#echo "test"
        sed -i "s/bam_files\=.*/bam_files\=/g" $sashimiSettings
        sed -i "s/miso_files\=.*/miso_files\=/g" $sashimiSettings
        sed -i "s/coverages\=.*/coverages\=/g" $sashimiSettings
        sed -i "s/colors\=.*/colors\=/g" $sashimiSettings
done
done
