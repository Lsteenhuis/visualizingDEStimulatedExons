#!/bin/bash
#SBATCH --job-name=sashimi_plot
#SBATCH --output=sashimi.out
#SBATCH --error=sashimi.err
#SBATCH --time=23:59:00
#SBATCH --cpus-per-task 4
#SBATCH --mem 2gb
#SBATCH --open-mode=append
#SBATCH --export=NONE
#SBATCH --get-user-env=30L


event=$1
gene=$2
gff="/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/alternative_events/indexed_se_event/"
time=$3
stimuli=$4
amount=$5

module load Python/2.7.9-foss-2015b
module load matplotlib/1.5.1-foss-2015b-Python-2.7.9
module load scipy/0.15.1-foss-2015b-Python-2.7.9
module load numpy/1.9.2-foss-2015b-Python-2.7.9
module load Pysam/0.9.0-foss-2015b-Python-2.7.9
export PYTHONPATH="${PYTHONPATH}:/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib"


python /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/sashimi_plot/sashimi_plot.py \
--plot-event $event \
$gff \
/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/python/lib/misopy/settings/sashimi_plot_settings.txt \
--output-dir /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/plots/sashimi_plot/SE/$time/$stimuli/$amount/$gene/
