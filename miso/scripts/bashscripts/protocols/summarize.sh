#!/bin/bash
#SBATCH --job-name=summarize
#SBATCH --output=summarize.out
#SBATCH --error=summarize.err
#SBATCH --time=23:59:00
#SBATCH --cpus-per-task 8
#SBATCH --mem 10gb
#SBATCH --open-mode=append
#SBATCH --export=NONE
#SBATCH --get-user-env=30L

module load Python/2.7.9-foss-2015b
module load Pysam/0.9.0-foss-2015b-Python-2.7.9

python /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/summarize_miso.py --summarize-samples \
..//miso_output/D_RPMI_24h/ \
../summaries/D_RPMI_24h/
