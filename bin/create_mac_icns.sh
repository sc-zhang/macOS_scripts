#!/bin/sh

help_message="Usage: $0 [-i input_png] [-o output_icns]"

if [ $# -eq 0 ]; then
  echo $help_message
  exit 1
fi

while getopts ":hi:o:" opt
do
  case $opt in
    i) in_png=$OPTARG ;;
    o) out_icns=$OPTARG ;;
    h)
      echo $help_message
      exit 1 ;;
    :)
      echo $help_message
      exit 1 ;;
    ?)
      echo $help_message
      exit 1 ;;
  esac
done

iconset_dir=${out_icns%.*}.iconset
if [[ ! -d ${iconset_dir} ]]; then
  mkdir -p ${iconset_dir}
fi
for i in {16,32,64,128,256,512}; do sips -z $i $i ${in_png} --out ${iconset_dir}/icon_$i"x"$i.png; done
for i in {32,64,128,256,512,1024}; do sips -z $i $i sample.png --out ${iconset_dir}/icon_$((i/2))"x"$((i/2))@2x.png; done
iconutil -c icns ${iconset_dir} -o ${out_icns}

