# The Politics of Warehousing in the Inland Empire, CA: How did we get here?
# Structural Topic Model (STM)
# Note: Only for Ontario, same process done for all cities
# By: Alyson Otañez

rm(list=ls(all=TRUE))

# Set working directory 
setwd('')

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

# Load data
ontario <- read_csv('ontario_complete.csv')

# Create corpus for each data frame
corpus_ontario <- corpus(ontario, text_field = 'Text')

# Pre-processing, removing stop words, and creating dfm 
toks_ont <- tokens(corpus_ontario, remove_punct = TRUE, remove_numbers=TRUE)
toks_ont <- tokens_wordstem(toks_ont)
toks_ont <- tokens_select(toks_ont,  stopwords("en"), selection = "remove")
dfm_ont <- dfm(toks_ont)
dfm_ontario <- dfm_trim(dfm_ont, min_docfreq = 0.2, docfreq_type = "prop")

# Classifying by keyword 
industrial <- c('warehouse', 'logistics center', 'distribution center', 'industrial', 'warehousing')
recreation <- c('recreation', 'park', 'open space', 'green space', 'pool', 'outdoor')
housing <- c('home', 'apartment', 'townhouse', 'condominium', 'affordable housing')
transportation <- c('transportation', 'bus', 'public transport', 'public transportation', 'bus route', 'train')

ontario$industrial <- ifelse(grepl(paste(industrial, collapse = "|"), ontario$Text), 1, 0)
ontario$recreation <- ifelse(grepl(paste(recreation, collapse = "|"), ontario$Text), 1, 0)
ontario$housing <- ifelse(grepl(paste(housing, collapse = "|"), ontario$Text), 1, 0)
ontario$transportation <- ifelse(grepl(paste(transportation, collapse = "|"), ontario$Text), 1, 0)

# Filtering data
ontario_industrial <- ontario[ontario$industrial == 1,]
ontario_industrial <- ontario_industrial %>%
  mutate(Topic = ifelse(industrial == 1, 'Warehousing', industrial))

ontario_recreation <- ontario[ontario$recreation == 1,]
ontario_recreation <- ontario_recreation %>%
  mutate(Topic = ifelse(recreation == 1, 'Recreation', recreation))

ontario_housing <- ontario[ontario$housing == 1,]
ontario_housing <- ontario_housing %>%
  mutate(Topic = ifelse(housing == 1, 'Housing', housing))

ontario_transportation <- ontario[ontario$transportation == 1,]
ontario_transportation <- ontario_transportation %>%
  mutate(Topic = ifelse(transportation == 1, 'Transportation', transportation))

ontario_indust_rec <- rbind(ontario_industrial, ontario_recreation)
ontario_indust_hou <- rbind(ontario_industrial, ontario_housing)
ontario_indust_trans <- rbind(ontario_industrial, ontario_transportation)

# Structural Topic Model #

# Industrial vs. Recreation 
remove_ontario <- c('ontario', 'city', 'council', 'agenda', 'regular', 'chambers', 'meeting', 'pdf', 
                    'adjournment', 'roll call', 'call to order', 'minutes') 

temp_ontario_indust_rec <- textProcessor(documents = ontario_indust_rec$Text, 
                                         metadata = ontario_indust_rec, 
                                         customstopwords = remove_ontario)

out_ontario_indust_rec <- prepDocuments(temp_ontario_indust_rec$documents, 
                                        temp_ontario_indust_rec$vocab, 
                                        temp_ontario_indust_rec$meta)

model.stm.ontario.1 <- stm(out_ontario_indust_rec$documents, out_ontario_indust_rec$vocab, K = 10,
                           prevalence = ~Topic, data = out_ontario_indust_rec$meta)
labels_ontario_1 <- labelTopics(model.stm.ontario.1)
labels_ontario_1
plot(model.stm.ontario.1, n=10, main = 'Top Topics Discussed: Warehousing + Recreation')

model.stm.ee.ont.1 <- estimateEffect(1:10 ~ Topic, model.stm.ontario.1, meta = out_ontario_indust_rec$meta)

plot(model.stm.ee.ont.1, covariate = 'Topic', topics = c(3, 4, 6, 7, 9, 10),
     model = model.stm.ontario.1, method = "difference",
     cov.value1 = "Warehousing", cov.value2 = "Recreation",
     xlab = " Most recreation ... Most warehousing", main = 'Discussion of Warehousing vs. Recreation',
     xlim = c(-.3,.3))

findThoughts(model.stm.ontario.1, texts=out_ontario_indust_rec$meta$Text, topics=7, n=5)

plot(model.stm.ontario.1, type = "perspectives", topics = c(9, 7), 
     main = 'Topic Contrast Warehousing vs. Recreation', ylab = c("Warehousing", "Recreation"))

# Industrial vs. Housing 

temp_ontario_indust_hou <- textProcessor(documents = ontario_indust_hou$Text, 
                                         metadata = ontario_indust_hou, 
                                         customstopwords = remove_ontario)

out_ontario_indust_hou <- prepDocuments(temp_ontario_indust_hou$documents, 
                                        temp_ontario_indust_hou$vocab, 
                                        temp_ontario_indust_hou$meta)

model.stm.ontario.2 <- stm(out_ontario_indust_hou$documents, out_ontario_indust_hou$vocab, K = 10,
                           prevalence = ~Topic, data = out_ontario_indust_hou$meta)
labels_ontario_2 <- labelTopics(model.stm.ontario.2)
labels_ontario_2
plot(model.stm.ontario.2, n=10, main = 'Top Topics Discussed: Warehousing + Housing')

model.stm.ee.ont.2 <- estimateEffect(1:10 ~ Topic, model.stm.ontario.2, meta = out_ontario_indust_hou$meta)

plot(model.stm.ee.ont.2, covariate = 'Topic', topics = c(3,5,6,10),
     model = model.stm.ontario.2, method = "difference",
     cov.value1 = "Warehousing", cov.value2 = "Housing",
     xlab = " Most housing ... Most warehousing", main = 'Discussion of Warehousing vs. Housing',
     xlim = c(-.3,.3))

findThoughts(model.stm.ontario.2, texts=out_ontario_indust_hou$meta$Text, topics= 6, n=1)

plot(model.stm.ontario.2, type = "perspectives", topics = c(3, 10), 
     main = 'Topic Contrast Warehousing vs. Housing')

# Industrial vs. Transportation 

temp_ontario_indust_trans <- textProcessor(documents = ontario_indust_trans$Text, 
                                           metadata = ontario_indust_trans, 
                                           customstopwords = remove_ontario)

out_ontario_indust_trans <- prepDocuments(temp_ontario_indust_trans$documents, 
                                          temp_ontario_indust_trans$vocab, 
                                          temp_ontario_indust_trans$meta)

model.stm.ontario.3 <- stm(out_ontario_indust_trans$documents, out_ontario_indust_trans$vocab, K = 10,
                           prevalence = ~Topic, data = out_ontario_indust_trans$meta)
labels_ontario_3 <- labelTopics(model.stm.ontario.3)
labels_ontario_3
plot(model.stm.ontario.3, n=10, main = 'Top Topics Discussed: Warehousing + Transportation')

model.stm.ee.ont.3 <- estimateEffect(1:10 ~ Topic, model.stm.ontario.3, meta = out_ontario_indust_trans$meta)

plot(model.stm.ee.ont.3, covariate = 'Topic', #topics = c(2,3,6,9,10),
     model = model.stm.ontario.3, method = "difference",
     cov.value1 = "Warehousing", cov.value2 = "Transportation",
     xlab = " Most transportation ... Most warehousing", main = 'Discussion of Warehousing vs. Transportation',
     xlim = c(-.3,.3))

findThoughts(model.stm.ontario.3, texts=out_ontario_indust_trans$meta$Text, topics = 10, n=3)

plot(model.stm.ontario.3, type = "perspectives", topics = c(9, 10), 
     main = 'Topic Contrast Warehousing vs. Transportation')