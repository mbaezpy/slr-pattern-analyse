# Transforms the data in multi-pattern format into a flat file for
# processing

if("jsonlite" %in% rownames(installed.packages()) == FALSE) {
  install.packages("jsonlite")
}

library(jsonlite)

file_include = commandArgs(TRUE)[1]
file_output  = commandArgs(TRUE)[2]

dj1   <- read.csv(file_include, sep = ",")

write(paste("+ Reading", file_include), "")

dj2 <- data.frame()

for (i in 1:nrow(dj1)){
  patterns <- fromJSON(paste(dj1[i, "reason_pattern"]))
  for (j in 1:(length(patterns)/5)){
    row <- dj1[i, ]
    row$reason_pattern <- patterns[j, 2]
    dj2 <- rbind(dj2, row)
  }
}

write.csv(dj2, file = file_output)
write(paste("+ Written to", file_output), "")
