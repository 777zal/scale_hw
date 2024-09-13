#!/bin/bash

mkdir -p  PROD/GBR

filepath=`pwd`
echo $filepath

file_path=`find $filepath -name "*.kicad_pro"`
file_name="${file_path##*/}"
name="${file_name%.*}"
echo $name

kicad-cli pcb export gerbers -o PROD/GBR/ \
                             -l F.Cu,In1.Cu,In2.Cu,B.Cu,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,F.Mask,B.Mask,Edge.Cuts\
                             --ev --no-x2 --no-netlist \
                             --subtract-soldermask \
                             ./scale.kicad_pcb

kicad-cli pcb export drill -o PROD/GBR/ \
                           --format excellon \
                           --drill-origin absolute \
                           --excellon-zeros-format decimal \
                           --excellon-oval-format route \
                           --excellon-units in \
                           --generate-map \
                           --excellon-separate-th \
                           --map-format gerberx2 \
                           ./scale.kicad_pcb

cd PROD/GBR/
zip -r ../../PROD/$name"_gerber".zip .
