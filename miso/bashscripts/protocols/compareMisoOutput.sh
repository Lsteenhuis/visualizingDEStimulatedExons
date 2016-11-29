
module load Python/2.7.9-foss-2015b
module load Pysam/0.9.0-foss-2015b-Python-2.7.9
module load matplotlib/1.5.1-foss-2015b-Python-2.7.9
module load scipy/0.15.1-foss-2015b-Python-2.7.9
module load numpy/1.9.2-foss-2015b-Python-2.7.9
module load BEDTools
module load SAMtools
export PYTHONPATH="${PYTHONPATH}:/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib"

#create .started file
touch scriptName.started

python /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/compare_miso.py --compare-samples \
	RPMI \
	stimuli \
	comparisonOutput

