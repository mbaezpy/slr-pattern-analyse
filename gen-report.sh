#!/bin/bash
PAT_TYPE=$2
CSV_FILE=$1
NOW=`date "+%Y-%m-%d_%H.%M.%S"`

if [ "$#" -ne 2 ]; then
    echo "Invalid number of arguments"
    echo "USAGE: gen-report.sh <FULL_PATH_TO_CSV> <TYPE_PATTERN>"
    echo "       TYPE_PATTERN: keywords | sentences"
    exit 1
fi

mkdir -p output

CURR_DIR=`pwd`

if [ $PAT_TYPE = "sentences" ]; then
  Rscript -e "library(rmarkdown); getwd(); rmarkdown::render(\"./src/report-tmpl-sentence.Rmd\", \"html_document\", output_dir = \"./output/\", output_file =\"${PAT_TYPE}_$NOW.html\")" $CSV_FILE $CURR_DIR
elif [ $PAT_TYPE = "keywords" ]; then  
  Rscript -e "library(rmarkdown); setwd(\".\"); rmarkdown::render(\"./src/report-tmpl-keywords.Rmd\", \"html_document\", output_dir = \"./output/\", output_file =\"${PAT_TYPE}_$NOW.html\")" $CSV_FILE $CURR_DIR
else
    echo "Invalid type of pattern."
    echo "TYPE_PATTERN: keywords | sentences"
fi
