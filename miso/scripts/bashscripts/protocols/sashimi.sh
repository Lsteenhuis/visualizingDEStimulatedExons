# sashimi plots the given event
event=$1
gene=$2
time=$3
stimuli=$4
mode=$5
gff="/groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/alternative_events/indexed_$mode""_events/"

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
--output-dir /groups/umcg-wijmenga/tmp04/umcg-lsteenhuis/miso/plots/sashimi_plot/$mode/$time/$stimuli/
