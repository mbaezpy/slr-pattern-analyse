#rm(list=ls())
library(ggplot2)
library(gridExtra)
library(forcats)
library(reshape2)

if (exists("file_include")) {
  dj1   <- read.csv(file_include, sep = ",")
} else {
  stop("You should specify the file to process")
}


djv <- dj1[dj1$validPattern == 1,]

# Invalid judgments
dji <- melt(table(dj1[dj1$validPattern == 0, ]$invalid_reason))

# Quality of the reasons
# -----------------------
djv$quality_reason <- factor(djv$quality_reason,
                             levels = c("bad", "medium", "good", "excellent"))

dfq <- melt(prop.table(table(djv$X_golden, djv$quality_reason), 1))
colnames(dfq) <- c("golden", "quality", "value")
dfq$golden <-
  factor(
    dfq$golden,
    levels = c("TRUE", "FALSE"),
    labels = c("golden", "unknown")
  )

p1 <- ggplot(data = dfq, aes(x = golden, y = value, fill = quality)) +
  geom_bar(stat = 'identity', position = "stack") +
  geom_text(aes(label = paste0(round(value * 100), '%')),
            position = position_stack(vjust = 0.5)) +
  labs(title = "Quality of reasons provided",
       x = "Golden data?",
       y = "count") +
  scale_fill_brewer(palette = "PRGn") +
  theme_minimal() +
  theme(legend.position = "bottom")

# Type of reasons

p2 <- ggplot(data = djv, aes(x = fct_infreq(type_reason))) +
  geom_bar(fill = "steelblue") +
  geom_text(
    stat = 'count',
    aes(label = ..count..),
    hjust = -0.2,
    size = 3.5
  ) +
  labs(title = "Type of reasons provided",
       x = "Emering reason types",
       y = "count") +
  coord_flip() +
  theme_minimal()


# Characterising patterns
# ------------------------

lpattrn <- c(
  "background",
  "hypothesis",
  "objective",
  "proposal",
  "proposal-details",
  "methods",
  "results",
  "keyword"
)

djv$type_pattern <- factor(djv$type_pattern, levels = lpattrn)

dj_pattrn <- unique(djv[, c("X_unit_id", "type_pattern")])


p3 <- ggplot(data = dj_pattrn, aes(x = type_pattern)) +
  geom_bar(fill = "steelblue") +
  geom_text(
    stat = 'count',
    aes(label = ..count..),
    vjust = -0.3,
    size = 3.5
  ) +
  labs(#title= "Position of patterns in abstract",
    x = "Part of the abstract",
    y = "count (unique patterns)") +
  theme_minimal()


# Distribution of judgements and patterns in the dataset
# ------------------------------------------------------

library("stringr")
dcore <-
  data.frame(table(str_replace_all(
    substr(djv$reason_pattern, 1, 100), "[[:punct:]]", ""
  )))
djuds <- data.frame(melt(table(djv$X_unit_id)))

dcum <-
  rbind.data.frame(
    data.frame(cline = "pattern", Freq = dcore$Freq),
    data.frame(cline = "judgement", Freq = djuds$value)
  )

p4 <- ggplot(dcum, aes(Freq, colour = cline)) + stat_ecdf() +
  scale_x_continuous(breaks = 1:max(dcum$Freq)) +
  scale_y_continuous(breaks = 1:10 / 10) +
  scale_color_discrete(name = "Distribution") +
  labs(title = "Distribution of frenquencies of patterns and # judgements in the dataset", y =
         "% of the corpus", x = "Frequency of pattern / # of judgements") +
  theme_minimal()


# Quality of workers' contributions
# ---------------------------------

dwork <-
  melt(prop.table(table(djv$X_worker_id, djv$quality_reason), 1))
colnames(dwork) <- c("worker", "quality", "value")

dwork$worker <- factor(dwork$worker,
                       levels = dwork$worker[order(dwork$value[dwork$quality == "bad"],
                                                   dwork$value[dwork$quality == "medium"],
                                                   dwork$value[dwork$quality == "good"])])

pwork <- ggplot(data = dwork, aes(x = worker, y = value, fill = quality)) +
  geom_bar(stat = 'identity', position = "stack") +
  labs(title = "Quality of contributions by each worker",
       x = "Worker id",
       y = "% of contributions by quality") +
  scale_fill_brewer(palette = "PRGn") +
  theme_minimal() +
  theme(legend.position = "bottom")

dwork_decent <- dwork[dwork$quality != "bad", ]
dwork_decent <-
  aggregate(dwork_decent$value,
            by = list(Category = dwork_decent$worker),
            FUN = sum)
