
module load Python/2.7.9-foss-2015b
module load Pysam/0.9.0-foss-2015b-Python-2.7.9
module load scipy/0.15.1-foss-2015b-Python-2.7.9


export PYTHONPATH="${PYTHONPATH}:/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib"

#create .started file
touch scriptName.started

python /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/filter_events.py \
	--filter comparisonOutputDir \
	--num-inc 1 \
	--num-exc 1 \
	--num-sum-inc-exc 10 \
	--delta-psi 0.05 \
	--bayes-factor 5.0 \
	--output-dir filterDir
