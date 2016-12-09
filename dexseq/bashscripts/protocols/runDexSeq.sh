ml R

cp ../../counted_files/countfiles $TMPDIR
cp ../../counted_files/rpmifiles $TMPDIR
cp ../../gff/Hsap.GRCh37.75.gff $TMPDIR

Rscript --vanilla stimuliscript
