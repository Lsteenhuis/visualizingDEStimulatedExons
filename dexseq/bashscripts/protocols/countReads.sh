
module load Python/2.7.9-foss-2015b
module load Pysam/0.9.0-foss-2015b-Python-2.7.9
module load HTSeq

python  /home/umcg-lsteenhuis/R/x86_64-unknown-linux-gnu-library/3.2/DEXSeq/python_scripts/dexseq_count.py \
-f bam \
gff \
bamFileLocation \
../../counted_files/baseName.txt

