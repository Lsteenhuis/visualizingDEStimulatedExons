#generate.sh
#generates the bash files for a MISO comparison

#parameters
bamLocation="/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/projects/variousStimuli/001/results/alignment/untrimmed"
gff="/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/DEXSEQ/gff/Hsap.GRCh37.75.gff"
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
	sed -i "s/baseName/$stimuli/g" ./runDir/$fileName
	
	i=`expr $i + 1`
done

# creates a submit script in the rundir
yes | cp -rf ./protocols/templates/submit.sh ./runDir/submit.sh

# loops for every bashscript in ./runDir
for bashscript in ./runDir/*.sh; do
        # defines basename of the script
        bashBase=${bashscript##*/}
        bashBase=${bashBase%.sh}

        # checks first
        if [[ $bashscript == *"s00"* ]]
        then

                cat ./protocols/templates/submit_template.sh >> ./runDir/submit.sh
                sed -i "s/scriptName/$bashBase/g" ./runDir/submit.sh
                sed -i "s/Boolean/false/g" ./runDir/submit.sh
        fi
        if [[ $bashscript == *"s01"* ]]
        then
            	run=$(echo $bashBase | perl -n -e'/_(\d+)/ && print $1')
                cat ./protocols/templates/submit_template_dependencies.sh >> ./runDir/submit.sh
                sed -i "s/scriptName/$bashBase/g" ./runDir/submit.sh
                sed -i "s/InsertHere/s00_runMiso_$run/g" ./runDir/submit.sh
        fi
        if [[ $bashscript == *"s02"* ]]
        then
            	run=$(echo $bashBase | perl -n -e'/_(\d+)/ && print $1')
                cat ./protocols/templates/submit_template_dependencies.sh >> ./runDir/submit.sh
                sed -i "s/scriptName/$bashBase/g" ./runDir/submit.sh
                sed -i "s/InsertHere/s01_compareMisoOutput_$run/g" ./runDir/submit.sh
        fi
done

