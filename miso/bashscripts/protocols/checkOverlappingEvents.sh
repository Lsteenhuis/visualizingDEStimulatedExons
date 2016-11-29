#!/bin/bash
#SBATCH --job-name=checkOverlappingEvents
#SBATCH --output=checkOverlappingEvents.out
#SBATCH --error=checkOverlappingEvents.err
#SBATCH --time=23:59:00
#SBATCH --cpus-per-task 4
#SBATCH --mem 12gb
#SBATCH --open-mode=append
#SBATCH --export=NONE
#SBATCH --get-user-env=30L

ml load Python/2.7.9-foss-2015b

outputDir="../../exonFiles/SE/"
for D in `find ../../filtered_comparisons/SE/volunteers/24h/vol_*  -type d`; do
	time=$(echo $D | perl -n -e'/(\d+h)/ && print $1')
	stimuli=$(echo $D | perl -n -e'/\d+h\/(\w+(?:-\w+)?)/ && print $1')
	if [ ! -d "$outputDir/$time" ]; then
		mkdir "$outputDir/$time"
	fi
	if [ ! -d "$outputDir/$time/$stimuli" ]; then
		mkdir "$outputDir/$time/$stimuli"
		end=8
		for i in $(seq 4 $end); do
			mkdir "$outputDir/$time/$stimuli/$i"
		done
	fi	
	python /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/scripts/python/checkOverlappingEvents.py -t $time -s $stimuli
done
