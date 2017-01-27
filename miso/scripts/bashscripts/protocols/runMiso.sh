
#load the modules that are needed

module load Python/2.7.9-foss-2015b
module load Pysam/0.9.0-foss-2015b-Python-2.7.9
module load matplotlib/1.5.1-foss-2015b-Python-2.7.9
module load scipy/0.15.1-foss-2015b-Python-2.7.9
module load numpy/1.9.2-foss-2015b-Python-2.7.9
module load BEDTools
module load SAMtools
export PYTHONPATH="${PYTHONPATH}:/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib"

#calculate readlength of the bam file
output=`samtools view bamFileLocation | head -n 1000000 | cut -f 10 | perl -ne 'chomp;print length($_) . "\n"' | sort | uniq -c`
for word in $output; do  readlen=$word; done


python /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/miso.py \
	--run gff \
	bamFileLocation \
	--output-dir resultDir \
	--read-len $readlen
