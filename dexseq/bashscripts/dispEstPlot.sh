#!/bin/bash
#SBATCH --job-name=dispEst.run
#SBATCH --output=dispEst.out
#SBATCH --error=dispEst.err
#SBATCH --time=5-23:59:00
#SBATCH --cpus-per-task 8
#SBATCH --mem 50gb
#SBATCH --open-mode=append
#SBATCH --export=NONE
#SBATCH --get-user-env=30L

set -e
set -u


module load R

Rscript --vanilla /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/DEXSEQ/scripts/R/DEXSEQ_test.R
