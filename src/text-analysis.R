# Install
#install.packages("tm")  # for text mining
#install.packages("SnowballC") # for text stemming
#install.packages("wordcloud") # word-cloud generator 
#install.packages("RColorBrewer") # color palettes
#install.packages("qdap")
# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
#library("qdap")


RenderCloud <- function(dpatterns, allowCompoundWords = F, allowStemming = F) {
  #dpatterns <-
  #  unique(str_replace_all(substr(df$reason_pattern, 1, 200), "[[:punct:]]", ""))

  dpatterns <- gsub("^\\s+|\\s+$", "", dpatterns)
  
  docs <- Corpus(VectorSource(dpatterns))
  
  # Convert the text to lower case
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove numbers
  docs <- tm_map(docs, removeNumbers)
  # Remove english common stopwords
  docs <- tm_map(docs, removeWords, stopwords("english"))
  # Remove your own stop word
  # specify your stopwords as a character vector
  docs <- tm_map(docs, removeWords, c("blabla1", "blabla2"))
  
  if (!allowCompoundWords) {
    # Remove punctuations
    docs <- tm_map(docs, removePunctuation)
    # Eliminate extra white spaces
    docs <- tm_map(docs, stripWhitespace)
  }
  if (allowStemming) {
    # Text stemming
    docs <- tm_map(docs, stemDocument)
  }
  
  dtm <- TermDocumentMatrix(docs)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m), decreasing = TRUE)
  d <- data.frame(word = names(v), freq = v)

  d
}

SplitKeywords <- function(ids, keywords) {
  unitid <-c()
  pattern <- c()

  
  for (i in 1:length(keywords)) {
    kw <- keywords[i]
    
    kp <- data.frame(table(tolower(gsub("^\\s+|\\s+$", "", 
                                           unlist(strsplit(as.character(kw), ","))))))    
    

    unitid <- c(unitid, rep(ids[i], length(kp$Var1)))
    pattern <- c(pattern, as.character(kp$Var1))
    
  }
  df <- cbind.data.frame(unitid, pattern)
  df  
  
}

# d_yes <- RenderCloud(djv[djv$in_out_radio == "yes" & djv$quality_reason != "bad", ])
# d_no <- RenderCloud(djv[djv$in_out_radio == "no" & djv$quality_reason != "bad", ])
# 
# rownames(d_yes) <- NULL
# rownames(d_no) <- NULL
# 
# head(d_yes, 20)
# head(d_no, 20)
# 
# dx_yes <- d_yes [! d_yes$word %in% head(d_no$word,5), ]
# dx_no <- d_no[! d_no$word %in% head(d_yes$word,5), ]
# 
# rownames(dx_yes) <- NULL
# rownames(dx_no) <- NULL







