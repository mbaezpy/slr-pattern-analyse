# Analysis of SLR patterns
Basic analysis of SLR patterns in R. 

## Intallation
You need to install R in your environment. Check the R [project website](https://www.r-project.org) for instructions.

Then install the libraries by running:

```shell
$ ./install.sh
```

## Data format
Comma separated values with (sep ","), with the following columns:

```
id,
excl_crit,
in_out_radio,
reason_pattern,
abstract,
title,
eid,
in_out_radio_gold,
_unit_id,
_golden,
_worker_id,
validPattern,
invalid_reason,
quality_reason,
type_pattern_notes,
type_pattern,
type_reason
```
Depending on the pattern extraction strategy, `reason_pattern` might be 

a) plain text, or:

```
This study provides insight into long-term health outcomes and cost-effectiveness of a tailored PA intervention among adults aged over fifty
```

b) json containing the actual metadata from a highlighting tool:

```json
[["<span class=\\"highlighted\\" data-timestamp=\\"1536360528002\\" style=\\"background-color: rgb(255, 255, 123);\\" data-highlighted=\\"true\\"></span>","This study provides insight into long-term health outcomes and cost-effectiveness of a tailored PA intervention among adults aged over fifty. ","1",303,142]]
```

Since the analysis tool works with plain text, you'll have to pre-process your csv file in case of (b). You can do this with the following script:

```shell
$ split-patterns.sh <INPUT_CSV_FILE> <OUTPUT_CSV_FILE>
```

## Running the scripts
You can analyse *keyword* patterns and *sentences*. Syntax:

```
USAGE: gen-report.sh <FULL_PATH_TO_CSV> <TYPE_PATTERN>
       TYPE_PATTERN: keywords | sentences
```

Examples:

```shell
# Analysing keyword patterns
$ ./gen-report.sh keyword-patterns.csv keywords

# Analysing sentence patterns
$ ./gen-report.sh keyword-patterns.csv sentences
```


