#!/bin/bash
INPUT_FILE=$1
OUTPUT_FILE=$2

if [ "$#" -ne 2 ]; then
    echo "Invalid number of arguments"
    echo "USAGE: split-patterns.sh <INPUT_CSV_FILE> <OUTPUT_CSV_FILE>"
    exit 1
fi

Rscript src/split-multi-patterns.R $INPUT_FILE $OUTPUT_FILE