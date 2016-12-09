#generate.sh
#generates the bash files for a MISO comparison
bamLocation="/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/projects/variousStimuli/001/results/alignment/untrimmed"
gff="/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/DEXSEQ/gff/Hsap.GRCh37.75.gff"
gffLoc=`echo $gff | perl -pi -e 's|\/|\\\/|gs'`
#parameters


timeArray=("4h" "24h")
stimuliArray=("Aspergillus_fumigatus" "Borrelia_burgdorferi" "Candida_albicans" "IL-1alpha" "Mycobacterium_tuberculosis" "Pseudomonas_aeruginosa" "Rhizopus_oryzae" "Streptococcus_pneumoniae")
gffLoc=`echo $gff | perl -pi -e 's|\/|\\\/|gs'`

#checks if the folder runDir exists when not it creates it.
if [ ! -d ./runDir ]; then
        mkdir ./runDir
fi

#Iterator for amount of scripts generated
i=0
for bamFile in $bamLocation/*.bam; do
                #declare fileNames
                fileName="s00_countReads_$i.sh"
                stepName="s00_countReads_$i"

                #retrieve key info from bam files and store them in variables for later use
                bamFile=`echo $bamFile | perl -pi -e 's|\/|\\\/|gs'`
                stimuli=$(echo $bamFile | perl -n -e'/(\w{1}_(?:\w+)(?:-\d\w+)?)_/ && print $1')
                time=$(echo $bamFile | perl -n -e'/(\d+h)/ && print $1')

        	yes | cp -rf ./protocols/templates/header.txt ./runDir/$fileName
                cat ./protocols/countReads.sh >> ./runDir/$fileName
                cat ./protocols/templates/footer.txt >> ./runDir/$fileName

        	# changes header placeholder values to real values
                sed -i "s/runTime/01:59:59/g" ./runDir/$fileName
                sed -i "s/cores/4/g" ./runDir/$fileName
                sed -i "s/ram/8gb/g" ./runDir/$fileName
                sed -i "s/jobName/$stepName/g" ./runDir/$fileName
                sed -i "s/jobOutput/$stepName.out/g" ./runDir/$fileName
                sed -i "s/jobErr/$stepName.err/g" ./runDir/$fileName

        	# changes runMiso placeholder values to real values
                sed -i "s/gff/$gffLoc/g" ./runDir/$fileName
                sed -i "s/bamFileLocation/$bamFile/g" ./runDir/$fileName
        	sed -i "s/baseName/$stimuli\_$time/g" ./runDir/$fileName

                i=`expr $i + 1`
done


i=`expr $i - 16`
for time in "${timeArray[@]}"; do
       for stimuli in "${stimuliArray[@]}"; do
                #currentStimuli = $stimuli$timePoint
                fileName="s01_runDEXSEQ_$i.sh"
                stepName="s01_runDEXSEQ_$i"
		stimCount=0
		rpmiCount=0

		stimuliVector=
		rpmiVector=
		stimConVector=
		rpmiConVector=
		for counted_files in ../counted_files/*$stimuli\_$time*; do
		        countedBase=${counted_files##*/}
		        bashBase=${countedBase%.txt}
			stimuliVector="$stimuliVector, \"$bashBase\""
			stimCount=`expr $stimCount + 1`
		done
		for counted_files in ../counted_files/*RPMI_$time*;do
                        countedBase=${counted_files##*/}
                        bashBase=${countedBase%.txt}
			rpmiVector="$rpmiVector, \"$bashBase\""
			rpmiCount=`expr $rpmiCount + 1`
		done
		for x in $(seq 1 $stimCount); do
			stimConVector="$stimConVector, \"$stimuli\_$time\""

		done
		for x in $(seq 1 $rpmiCount); do
			rpmiConVector="$rpmiConVector, \"RPMI_$time\""

		done

		stimuliVector=${stimuliVector%?}
		rpmiVector=${rpmiVector%?}
		stimConVector=${stimConVector%?}
		rpmiConVector=${rpmiConVector%?}

                yes | cp -rf ./protocols/templates/dexseq_base.R ./runDir/dexseq\_$stimuli\_$time.R
                sed -i "s/stimuli/$stimuli/g" ./runDir/dexseq\_$stimuli\_$time.R
                sed -i "s/time/$time/g" ./runDir/dexseq\_$stimuli\_$time.R
		sed -i "s/vectorS/\"${stimuliVector:3}\"/g" ./runDir/dexseq\_$stimuli\_$time.R
		sed -i "s/vectorR/\"${rpmiVector:3}\"/g" ./runDir/dexseq\_$stimuli\_$time.R
		sed -i "s/stimCon/\"${stimConVector:3}\"/g" ./runDir/dexseq\_$stimuli\_$time.R
		sed -i "s/rpmiCon/\"${rpmiConVector:3}\"/g" ./runDir/dexseq\_$stimuli\_$time.R

                yes | cp -rf ./protocols/templates/header.txt ./runDir/$fileName
                cat ./protocols/runDexSeq.sh >> ./runDir/$fileName
                cat ./protocols/templates/footer.txt >> ./runDir/$fileName

                sed -i "s/runTime/1-23:59:59/g" ./runDir/$fileName
                sed -i "s/cores/4/g" ./runDir/$fileName
                sed -i "s/ram/12gb/g" ./runDir/$fileName
                sed -i "s/jobName/$stepName/g" ./runDir/$fileName
                sed -i "s/jobOutput/$stepName.out/g" ./runDir/$fileName
                sed -i "s/jobErr/$stepName.err/g" ./runDir/$fileName

		sed -i "s/stimuliscript/\/groups\/umcg-wijmenga\/tmp04\/umcg-lsteenhuis\/DEXSEQ\/bashscripts\/runDir\/dexseq\_$stimuli\_$time.R/g" ./runDir/$fileName
                i=`expr $i + 1`
        done
done
