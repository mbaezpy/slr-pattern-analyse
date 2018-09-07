#!/bin/bash
PAT_TYPE=$2
CSV_FILE=$1

if [ "$#" -ne 2 ]; then
    echo "Invalid number of arguments"
    echo "USAGE: gen-report.sh <FULL_PATH_TO_CSV> <TYPE_PATTERN>"
    echo "       TYPE_PATTERN: keywords | sentences"
    exit 1
fi


if [ $PAT_TYPE = "sentences" ]; then
  Rscript -e 'library(rmarkdown); rmarkdown::render("./src/report-tmpl-sentence.Rmd", "html_document")' $CSV_FILE
elif [ $PAT_TYPE = "keywords" ]; then

  Rscript -e 'library(rmarkdown); rmarkdown::render("./src/report-tmpl-keywords.Rmd", "html_document")' $CSV_FILE
else
    echo "Invalid type of pattern."
    echo "TYPE_PATTERN: keywords | sentences"
fi
