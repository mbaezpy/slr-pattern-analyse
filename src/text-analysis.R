library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

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





