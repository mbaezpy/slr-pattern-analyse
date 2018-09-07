# Analysis of SLR patterns
Basic analysis of SLR patterns in R.

## Intallation
You need to install R in your environment. 

Then install the libraries by running

`
$ ./install.sh
`

# Running the scripts
You can analys *keyword* patterns and *sentences*. Syntax:

```
USAGE: gen-report.sh <FULL_PATH_TO_CSV> <TYPE_PATTERN>
       TYPE_PATTERN: keywords | sentences
```

Examples:

```
# Analysing keyword patterns
$ ./gen-report.sh keyword-patterns.csv keywords

# Analysing sentence patterns
$ ./gen-report.sh keyword-patterns.csv keywords
```


