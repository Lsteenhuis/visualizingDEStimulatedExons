#generate.sh
#generates the bash files for a MISO comparison

#parameters
bamLocation="/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/projects/variousStimuli/001/results/alignment/untrimmed"
gff="/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/alternative_events/indexed_se_event"
gffLoc=`echo $gff | perl -pi -e 's|\/|\\\/|gs'`

#checks if the folder runDir exists when not it creates it.
if [ ! -d ./runDir ]; then
        mkdir ./runDir
fi


#Iterator for amount of scripts generated
i=0

for bamFile in $bamLocation/*.bam; do
	#declare fileNames
        fileName="s00_runMiso_$i.sh"
        stepName="s00_runMiso_$i"

	#retrieve key info from bam files and store them in variables for later use
        bamFile=`echo $bamFile | perl -pi -e 's|\/|\\\/|gs'`
        stimuli=$(echo $bamFile | perl -n -e'/(\w{1}_(?:\w+)(?:-\d\w+)?)_/ && print $1')
        time=$(echo $bamFile | perl -n -e'/(\d+h)/ && print $1')
        RPMI="../../miso_output/SE/$time/${stimuli:0:2}RPMI"
        RPMIDir=`echo $RPMI | perl -pi -e 's|\/|\\\/|gs'`

	#the output dir for runMiso
	misoOutput="../../miso_output/SE/$time/"
        misoOutputDir=`echo $misoOutput | perl -pi -e 's|\/|\\\/|gs'`

	#create runMiso script from header, script and footer
	yes | cp -rf ./protocols/templates/header.txt ./runDir/$fileName
	cat ./protocols/runMiso.sh >> ./runDir/$fileName
	cat ./protocols/templates/footer.txt >> ./runDir/$fileName

	#yes | cp -rf ./protocols/runMiso.sh ./runDir/$fileName

	# changes header placeholder values to real values
	sed -i "s/runTime/04:59:59/g" ./runDir/$fileName
	sed -i "s/cores/4/g" ./runDir/$fileName
	sed -i "s/ram/8gb/g" ./runDir/$fileName
        sed -i "s/jobName/$stepName/g" ./runDir/$fileName
        sed -i "s/jobOutput/$stepName.out/g" ./runDir/$fileName
        sed -i "s/jobErr/$stepName.err/g" ./runDir/$fileName

	# changes runMiso placeholder values to real values
	sed -i "s/gff/$gffLoc/g" ./runDir/$fileName
        sed -i "s/bamFileLocation/$bamFile/g" ./runDir/$fileName
	sed -i "s/resultDir/$misoOutputDir/g" ./runDir/$fileName
        sed -i "s/scriptName/$fileName/g" ./runDir/$fileName


	# checks if bam file is a control sample, these do not have to be processed further.
	if [[ $bamFile != *"RPMI"* ]]; then
        	fileName="s01_compareMisoOutput_$i.sh"
                stepName="s01_compareMisoOutput_$i"
	        comparisonOutput="../../comparison_output/SE/$time/"
        	comparisonOutputDir=`echo $comparisonOutput | perl -pi -e 's|\/|\\\/|gs'`

	        #create runMiso	script from header, script and footer
                yes | cp -rf ./protocols/templates/header.txt ./runDir/$fileName
	        cat ./protocols/compareMisoOutput.sh >> ./runDir/$fileName
        	cat ./protocols/templates/footer.txt >> ./runDir/$fileName

                #yes | cp -rf ./protocols/runMiso.sh ./runDir/$fileName

	        # changes header placeholder values to real values
                sed -i "s/runTime/04:59:59/g" ./runDir/$fileName
	        sed -i "s/cores/4/g" ./runDir/$fileName
        	sed -i "s/ram/8gb/g" ./runDir/$fileName
                sed -i "s/jobName/$stepName/g" ./runDir/$fileName
	        sed -i "s/jobOutput/$stepName.out/g" ./runDir/$fileName
        	sed -i "s/jobErr/$stepName.err/g" ./runDir/$fileName

		#changes compareMisoOutput placeholder values to real values
       		sed -i "s/RPMI/$RPMIDir/g" ./runDir/$fileName
                sed -i "s/stimuli/$misoOutputDir\/$stimuli/g" ./runDir/$fileName
	        sed -i "s/comparisonOutput/$comparisonOutputDir/g" ./runDir/$fileName
		sed -i "s/scriptName/$fileName/g" ./runDir/$fileName


		# define variables to be used in filterComparisonOutput
		fileName="s02_filterMisoComparisonOutput_$i.sh"
	        stepName="s02_filterMisoComparisonOutput_$i"

		filterOutput="../../filtered_comparisons/SE/$time/"
	        filterOutputDir=`echo $filterOutput | perl -pi -e 's|\/|\\\/|gs'`

		comparisonFile=${stimuli:0:2}RPMI"_vs_"$stimuli
                comparisonDir="../../comparison_output/SE/$time/$comparisonFile/bayes-factors/$comparisonFile.miso_bf"
		comparisonOutputDir=`echo $comparisonDir | perl -pi -e 's|\/|\\\/|gs'`

                #create filterComparisonOutputo script from header, script and footer
                yes | cp -rf ./protocols/templates/header.txt ./runDir/$fileName
                cat ./protocols/filterMisoComparisonOutput.sh >> ./runDir/$fileName
                cat ./protocols/templates/footer.txt >> ./runDir/$fileName

                # changes header placeholder values to real values
                sed -i "s/runTime/04:59:59/g" ./runDir/$fileName
                sed -i "s/cores/4/g" ./runDir/$fileName
                sed -i "s/ram/8gb/g" ./runDir/$fileName
                sed -i "s/jobName/$stepName/g" ./runDir/$fileName
                sed -i "s/jobOutput/$stepName.out/g" ./runDir/$fileName
                sed -i "s/jobErr/$stepName.err/g" ./runDir/$fileName

		# changes filterComparisonOutput placeholder values to real values
		sed -i "s/comparisonOutputDir/$comparisonOutputDir/g" ./runDir/$fileName
	        sed -i "s/filterDir/$filterOutputDir/g"	./runDir/$fileName
		sed -i "s/scriptName/$fileName/g" ./runDir/$fileName


	fi
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

		cat ./protocols/submit_template.sh >> ./runDir/submit.sh
		sed -i "s/scriptName/$bashBase/g" ./runDir/submit.sh
		sed -i "s/Boolean/false/g" ./runDir/submit.sh
	fi
	if [[ $bashscript == *"s01"* ]]
	then
		run=$(echo $bashBase | perl -n -e'/_(\d+)/ && print $1')
                cat ./protocols/submit_template_dependencies.sh >> ./runDir/submit.sh
                sed -i "s/scriptName/$bashBase/g" ./runDir/submit.sh
                sed -i "s/InsertHere/s00_runMiso_$run/g" ./runDir/submit.sh
	fi
	if [[ $bashscript == *"s02"* ]]
	then
                run=$(echo $bashBase | perl -n -e'/_(\d+)/ && print $1')
                cat ./protocols/submit_template_dependencies.sh >> ./runDir/submit.sh
                sed -i "s/scriptName/$bashBase/g" ./runDir/submit.sh
                sed -i "s/InsertHere/s01_compareMisoOutput_$run/g" ./runDir/submit.sh
	fi
done
