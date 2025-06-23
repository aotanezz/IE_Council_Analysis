# The Politics of Warehousing in the Inland Empire, CA: How did we get here?
# Structural Topic Model (STM)
# By: Alyson Otañez

################################################################################
# Setup 

rm(list=ls(all=TRUE))

# Set working directory 
setwd('/Users/alysonotanez/Desktop/IE_STM_Files/Data')

# Load packages
library(RColorBrewer)
library(wordcloud2)
library(tidyverse)
library(tokenizers)
library(quanteda)
library(quanteda.textplots)
library(stm)
library(seededlda)
library(here)
library(tm)
library(wordcloud)
library(tidytext)
library(patchwork)
library(dplyr)
library(stringr)
library(textstem)
library(tidytext)

# Load data
ie_cities <- read.csv('ie_cities.csv')
ie_cities <- ie_cities %>%
  filter(!is.na(Text))

################################################################################
# Data Cleaning 

# Clean HTML Text
# Define the text preprocessing function
txt_preprocess_pipeline <- function(text) {
  standard_txt <- tolower(text)
  clean_txt <- str_replace_all(standard_txt, "http\\S+|www\\S+|https\\S+", "")
  clean_txt <- str_replace_all(clean_txt, "\\n", " ")
  clean_txt <- str_replace_all(clean_txt, "\\s+", " ")
  clean_txt <- str_replace_all(clean_txt, "\\S+@\\S+", "")
  clean_txt <- str_replace_all(clean_txt, "<.*?>", "")
  clean_txt <- str_replace_all(clean_txt, "[^\\w\\s]", "")
  clean_txt <- str_replace_all(clean_txt, "\\b\\w{1,2}\\b", "")
  tokens <- unlist(str_split(clean_txt, "\\s+"))
  filtered_tokens_alpha <- tokens[grepl("^[a-zA-Z]+$", tokens) & 
                                    !grepl("^[ivxlcdm]+$", tokens, 
                                           ignore.case = TRUE)]
  stop_words <- c(stopwords("en"),
                  "chino", "fontana", "march", "joint", "powers", "authority", 
                  "http", "rialto", "ontario", "city", "council", "agenda",
                  "meeting", "minutes", "back", "site", "main", "welcome", "browse", "video",
                  "monday", "tuesday", "wednesday", "thursday", "friday", 
                  "saturday", "sunday", "notice", "commission", "archive", "pmcity",
                  "chamber", "palm", "ave", "january", "february", "march", "april", "may",
                  "june", "july", "august", "september", "october", "november", "december",
                  "closed", "session")
  filtered_tokens_final <- filtered_tokens_alpha[!filtered_tokens_alpha %in% stop_words]
  lemma_tokens <- lemmatize_words(filtered_tokens_final)
  return(lemma_tokens)
}

# Apply function to clean text
ie_cities$Processed_Text <- sapply(ie_cities$Text, txt_preprocess_pipeline)

# Clean HTML text for STM 
rmv_html <- function(text) {
  clean_txt <- tolower(text)
  clean_txt <- str_replace_all(clean_txt, "http\\S+|www\\S+|https\\S+", "") # Remove URLs
  clean_txt <- str_replace_all(clean_txt, "<[^>]+>", "") # Remove HTML tags
  clean_txt <- str_replace_all(clean_txt, "\\s+", " ") # Remove extra spaces
  clean_txt <- str_replace_all(clean_txt, "[^\\w\\s]", "") # Remove punctuation
  clean_txt <- str_replace_all(clean_txt, "\\b\\w{1,2}\\b", "") # Remove short words
  return(clean_txt)
}

# Apply function to clean text
ie_cities$Clean_Text <- sapply(ie_cities$Text, rmv_html)

################################################################################
# Classify documents based on keyword prevalence 

# Define keywords
industrial <- c('warehouse', 'logistics', 'distribution', 'shipping',
                'industrial', 'warehousing', 'diesel', 'freight', 'cargo', 
                'zoning', 'zone')
housing <- c('home', 'house', 'apartment', 'townhouse', 'condominium', 
             'housing', 'rent', 'mortgage', 'residential', 'homeless',
             'homelessness')
jobs <- c('job', 'economy', 'workforce', 'employment', 'wages', 'trade', 
          'salary', 'workers', 'unemployment', 'jobs', 'employer')
safety <- c('police', 'safety', 'crime', 'security', 'firefighter', 'drugs', 
            'theft', 'gun', 'violence', 'paramedic', 'policing')

# Count keyword appearance in text

# Industrial
count_industrial <- function(text) {
  words <- unlist(strsplit(tolower(text), "\\s+"))
  return(sum(words %in% industrial))
}

ie_cities$Sum_Industrial <- sapply(ie_cities$Processed_Text, count_industrial)

# Housing
count_housing <- function(text) {
  words <- unlist(strsplit(tolower(text), "\\s+"))
  return(sum(words %in% housing))
}

ie_cities$Sum_Housing <- sapply(ie_cities$Processed_Text, count_housing)

# Jobs and the economy
count_jobs <- function(text) {
  words <- unlist(strsplit(tolower(text), "\\s+"))
  return(sum(words %in% jobs))
}

ie_cities$Sum_Jobs <- sapply(ie_cities$Processed_Text, count_jobs)

# Public safety
count_safety <- function(text) {
  words <- unlist(strsplit(tolower(text), "\\s+"))
  return(sum(words %in% safety))
}

ie_cities$Sum_Safety <- sapply(ie_cities$Processed_Text, count_safety)

# Classify
ie_cities$Type <- apply(ie_cities[, c("Sum_Industrial", "Sum_Jobs",
                                      "Sum_Safety", "Sum_Housing")], 1, 
                        function(row) {
                          names(row)[which.max(row)]
                        })

# Rename the values in the 'Type' column
rename <- c(Sum_Industrial = "Industrial", 
            Sum_Jobs = "Jobs & Economy", 
            Sum_Safety = "Public Safety",
            Sum_Housing = "Housing")

ie_cities$Type <- unname(rename[ie_cities$Type])

# Save files
ie_cities2 <- ie_cities %>%
  select(-Processed_Text)

write.csv(ie_cities2, 'IE_Cities_Processed.csv')

################################################################################
# Structural Topic Model
###############################################################################

# Setup 
ie_cities <- read.csv('IE_Cities_Processed.csv')

ie_cities <- ie_cities %>%
  select(-X)

# Split data 
industrial <- ie_cities %>%
  filter(Type == 'Industrial')

housing <- ie_cities %>%
  filter(Type == 'Housing')

jobs <- ie_cities %>%
  filter(Type == 'Jobs & Economy')

safety <- ie_cities %>%
  filter(Type == 'Public Safety')

ie_cities <- ie_cities %>%
  count(Type) %>%
  mutate(percentage = n / sum(n) * 100)

ggplot(ie_cities, aes(x = reorder(Type, percentage), y = percentage, fill = Type)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  geom_text(aes(label = paste0(round(percentage, 1), "%")), 
            vjust = 1.5, size = 5, color = "white") +  
  labs(
    x = "Cateogory",
    y = "Percentage",
    title = "IE City Council Topics"
  ) +
  scale_fill_manual(values = c("Industrial" = "#FF9999", "Housing" = "#99CCFF", "Public Safety" = "#E69F00",
                               'Jobs & Economy' = "#009E73")) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 13)
  )

# Combine with industrial for comparison 
industrial_housing <- rbind(industrial, housing)
industrial_jobs <- rbind(industrial, jobs)
industrial_safety <- rbind(industrial, safety)

rm(industrial)
rm(housing)
rm(jobs)
rm(safety)

########
# Models

# Industrial vs. Housing
remove <- c('fontana', 'ontario', 'chino', 'rialto', 'citi', 'shall',
            'council', 'page', 'city', 'meet', 'minute', 'minutes', 
            'commission', 'regular', 'public', 'cities', 'march') 

temp1 <- textProcessor(documents = industrial_housing$Clean_Text, 
                       metadata = industrial_housing,
                       customstopwords = remove)

out1 <- prepDocuments(temp1$documents, 
                      temp1$vocab, 
                      temp1$meta)

model1 <- stm(out1$documents, out1$vocab, K = 10,
              prevalence = ~Type, data = out1$meta)

labels1 <- labelTopics(model1)
labels1

plot(model1, n = 10, main = 'Topic Model: Industrial + Housing')

model1_diff <- estimateEffect(1:10 ~ Type, model1, meta = out1$meta)

plot(model1_diff, covariate = 'Type', topics = c(2,3,4,6,7,9,10),
     model = model1, method = "difference",
     cov.value1 = "Industrial", cov.value2 = "Housing",
     xlab = "Most Housing          Most Industrial", 
     main = 'Industrial vs. Housing Covariate Level',
     xlim = c(-.3,.3))

findThoughts(model1, texts=out1$meta$Clean_Text, topics=3, n=1)
findThoughts(model1, texts=out1$meta$Clean_Text, topics=10, n=1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

plot(model1, type = 'perspectives', topics = c(3,10), main = 'Topic Contrast Industrial vs. Housing')


########################

# Industrial vs. Public Safety
remove <- c('fontana', 'ontario', 'chino', 'rialto', 'citi', 'shall',
            'council', 'page', 'city', 'meet', 'minute', 'minutes', 
            'commission', 'regular', 'public', 'cities', 'march') 

temp2 <- textProcessor(documents = industrial_safety$Clean_Text, 
                       metadata = industrial_safety,
                       customstopwords = remove)

out2 <- prepDocuments(temp2$documents, 
                      temp2$vocab, 
                      temp2$meta)

model2 <- stm(out2$documents, out2$vocab, K = 10,
              prevalence = ~Type, data = out2$meta)

labels2 <- labelTopics(model2)
labels2

plot(model2, n = 10, main = 'Topic Model: Industrial + Public Safety')

model2_diff <- estimateEffect(1:10 ~ Type, model2, meta = out2$meta)

plot(model2_diff, covariate = 'Type',
     model = model2, method = "difference",
     cov.value1 = "Industrial", cov.value2 = "Public Safety",
     xlab = "Most Public Safety          Most Industrial", 
     main = 'Industrial vs. Public Safety Covariate Level',
     xlim = c(-.3,.3))

findThoughts(model2, texts=out2$meta$Clean_Text, topics=4, n=1)
findThoughts(model2, texts=out2$meta$Clean_Text, topics=7, n=1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

plot(model2, type = 'perspectives', topics = c(4,7), main = 'Topic Contrast Industrial vs. Public Safety')

##############################

# Industrial vs. Jobs and Economy
remove <- c('fontana', 'ontario', 'chino', 'rialto', 'citi', 'shall',
            'council', 'page', 'city', 'meet', 'minute', 'minutes', 
            'commission', 'regular', 'public', 'cities', 'march') 

temp3 <- textProcessor(documents = industrial_jobs$Clean_Text, 
                       metadata = industrial_jobs,
                       customstopwords = remove)

out3 <- prepDocuments(temp3$documents, 
                      temp3$vocab, 
                      temp3$meta)

model3 <- stm(out3$documents, out3$vocab, K = 10,
              prevalence = ~Type, data = out3$meta)

labels3 <- labelTopics(model3)
labels3

plot(model3, n = 10, main = 'Topic Model: Industrial + Jobs & Economy')


model3_diff <- estimateEffect(1:10 ~ Type, model3, meta = out3$meta)

plot(model3_diff, covariate = 'Type', topics = c(2, 3, 4, 5, 9, 10),
     model = model3, method = "difference",
     cov.value1 = "Industrial", cov.value2 = "Jobs & Economy",
     xlab = "Most Jobs & Economy          Most Industrial", 
     main = 'Industrial vs. Jobs & Economy Covariate Level',
     xlim = c(-.3,.3))

findThoughts(model3, texts=out3$meta$Clean_Text, topics=9, n=1)
findThoughts(model3, texts=out3$meta$Clean_Text, topics=3, n=1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

plot(model3, type = 'perspectives', topics = c(9,3), main = 'Topic Contrast Industrial vs. Jobs & Economy')
