#!/usr/sh

set -eu

path='/data/nano_meta_ref/result/spades/hybird_temp/spades'

for i in $path/*;
do
name=`echo $i|cut -d '/' -f 8`
#echo $name;

VIBRANT_run.py -i $path/${name}/contigs.fasta -f nucl -t 14 -folder ../nanopore/Vibrant/${name%*_assembly*}

done
