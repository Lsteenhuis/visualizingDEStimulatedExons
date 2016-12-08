ml R

cp ../../counted_files/* $TMPDIR
cp ../../gff/Hsap.GRCh37.75.gff $TMPDIR

Rscript --vanilla stimuliscript
