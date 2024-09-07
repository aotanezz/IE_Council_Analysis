# The Politics of Warehousing in the Inland Empire, CA: How did we get here?
# Exploratory Data Analysis (EDA)
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
chino <- read_csv('chino_complete.csv')
fontana <- read_csv('fontana_complete.csv')
fontana <- fontana[fontana$Year <= 2023, ]
rialto <- read_csv('rialto_complete.csv')
marchjpa <- read_csv('marchjpa_complete.csv')

# Create corpus for each data frame
corpus_ontario <- corpus(ontario, text_field = 'Text')

corpus_chino <- corpus(chino, text_field = 'text')

corpus_fontana <- corpus(fontana, text_field = 'Text')

corpus_rialto <- corpus(rialto, text_field = 'Text')

corpus_marchjpa <- corpus(marchjpa, text_field = 'Text')

# Pre-processing, removing stop words, and creating dfm #

# Ontario
toks_ont <- tokens(corpus_ontario, remove_punct = TRUE, remove_numbers=TRUE)
toks_ont <- tokens_wordstem(toks_ont)
toks_ont <- tokens_select(toks_ont,  stopwords("en"), selection = "remove")
dfm_ont <- dfm(toks_ont)
dfm_ontario <- dfm_trim(dfm_ont, min_docfreq = 0.2, docfreq_type = "prop")

# Chino
toks_chi <- tokens(corpus_chino, remove_punct = TRUE, remove_numbers=TRUE)
toks_chi <- tokens_wordstem(toks_chi)
toks_chi <- tokens_select(toks_chi,  stopwords("en"), selection = "remove")
dfm_chi <- dfm(toks_chi)
dfm_chino <- dfm_trim(dfm_chi, min_docfreq = 0.2, docfreq_type = "prop")

# Fontana 
toks_fon <- tokens(corpus_fontana, remove_punct = TRUE, remove_numbers=TRUE)
toks_fon <- tokens_wordstem(toks_fon)
toks_fon <- tokens_select(toks_fon,  stopwords("en"), selection = "remove")
dfm_fon <- dfm(toks_fon)
dfm_fontana <- dfm_trim(dfm_fon, min_docfreq = 0.2, docfreq_type = "prop")

# Rialto
toks_ria <- tokens(corpus_rialto, remove_punct = TRUE, remove_numbers=TRUE)
toks_ria <- tokens_wordstem(toks_ria)
toks_ria <- tokens_select(toks_ria,  stopwords("en"), selection = "remove")
dfm_ria <- dfm(toks_ria)
dfm_rialto <- dfm_trim(dfm_ria, min_docfreq = 0.2, docfreq_type = "prop")

# March JPA
toks_jpa <- tokens(corpus_marchjpa, remove_punct = TRUE, remove_numbers=TRUE)
toks_jpa <- tokens_wordstem(toks_jpa)
toks_jpa <- tokens_select(toks_jpa,  stopwords("en"), selection = "remove")
dfm_jpa <- dfm(toks_jpa)
dfm_jpa <- dfm_trim(dfm_jpa, min_docfreq = 0.2, docfreq_type = "prop")

# Count of keywords over time #

# Fontana
warehouse <- 'warehouse'
sum_warehouse <- c()

for(i in 1:nrow(fontana)){
  split_text <- str_split(fontana$Text[i], '\\st+')
  sum_warehouse_per_text <- str_count(split_text, warehouse)
  sum_warehouse <- c(sum_warehouse, sum(sum_warehouse_per_text))
}

plot_warehouse <- ggplot(fontana, aes(x = Year, y = sum_warehouse)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  xlab('Year') +
  ylab("Sum 'warehouse'") +
  ggtitle("Sum of the word 'warehouse' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14))
plot_warehouse + theme_light()

park <- 'recreation'
sum_park <- c()

for(i in 1:nrow(fontana)){
  split_text <- str_split(fontana$Text[i], '\\st+')
  sum_park_per_text <- str_count(split_text, park)
  sum_park <- c(sum_park, sum(sum_park_per_text))
}

plot_park <- ggplot(fontana, aes(x = Year, y = sum_park)) +
  geom_bar(stat = "identity", fill = "orange1") +
  xlab('Year') +
  ylab("Sum 'recreation'") +
  ggtitle("Sum of the word 'recreation' each year") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Fontana, CA') 
plot_park + theme_light()

transportation <- 'transportation'
sum_transportation <- c()

for(i in 1:nrow(fontana)){
  split_text <- str_split(fontana$Text[i], '\\st+')
  sum_transportation_per_text <- str_count(split_text, transportation)
  sum_transportation <- c(sum_transportation, sum(sum_transportation_per_text))
}

plot_transportation <- ggplot(fontana, aes(x = Year, y = sum_transportation)) +
  geom_bar(stat = "identity", fill = "cyan") +
  xlab('Year') +
  ylab("Sum 'transportation'") +
  ggtitle("Sum of the word 'transportation' each year") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Fontana, CA') 
plot_transportation + theme_light()

housing <- 'housing'
sum_housing <- c()

for(i in 1:nrow(fontana)){
  split_text <- str_split(fontana$Text[i], '\\st+')
  sum_housing_per_text <- str_count(split_text, housing)
  sum_housing <- c(sum_housing, sum(sum_housing_per_text))
}

plot_housing <- ggplot(fontana, aes(x = Year, y = sum_housing)) +
  geom_bar(stat = "identity", fill = "purple") +
  xlab('Year') +
  ylab("Sum 'housing'") +
  ggtitle("Sum of the word 'housing' each year") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Fontana, CA') 
plot_housing + theme_light()

grid.arrange(plot_warehouse, plot_park, plot_transportation, plot_housing, ncol = 2)

# Ontario
warehouse <- 'warehouse'
sum_warehouse <- c()

for(i in 1:nrow(ontario)){
  split_text <- str_split(ontario$Text[i], '\\st+')
  sum_warehouse_per_text <- str_count(split_text, warehouse)
  sum_warehouse <- c(sum_warehouse, sum(sum_warehouse_per_text))
}

plot_warehouse <- ggplot(ontario, aes(x = Year, y = sum_warehouse)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  xlab('Year') +
  ylab("Sum 'warehouse'") +
  ggtitle("Sum of the word 'warehouse' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14))
plot_warehouse + theme_light()

park <- 'recreation'
sum_park <- c()

for(i in 1:nrow(ontario)){
  split_text <- str_split(ontario$Text[i], '\\st+')
  sum_park_per_text <- str_count(split_text, park)
  sum_park <- c(sum_park, sum(sum_park_per_text))
}

plot_park <- ggplot(ontario, aes(x = Year, y = sum_park)) +
  geom_bar(stat = "identity", fill = "orange1") +
  xlab('Year') +
  ylab("Sum 'recreation'") +
  ggtitle("Sum of the word 'recreation' each year") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Ontario, CA') 
plot_park + theme_light()

transportation <- 'transportation'
sum_transportation <- c()

for(i in 1:nrow(ontario)){
  split_text <- str_split(ontario$Text[i], '\\st+')
  sum_transportation_per_text <- str_count(split_text, transportation)
  sum_transportation <- c(sum_transportation, sum(sum_transportation_per_text))
}

plot_transportation <- ggplot(ontario, aes(x = Year, y = sum_transportation)) +
  geom_bar(stat = "identity", fill = "cyan") +
  xlab('Year') +
  ylab("Sum 'transportation'") +
  ggtitle("Sum of the word 'transportation' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Ontario, CA') 
plot_transportation + theme_light()

housing <- 'housing'
sum_housing <- c()

for(i in 1:nrow(ontario)){
  split_text <- str_split(ontario$Text[i], '\\st+')
  sum_housing_per_text <- str_count(split_text, housing)
  sum_housing <- c(sum_housing, sum(sum_housing_per_text))
}

plot_housing <- ggplot(ontario, aes(x = Year, y = sum_housing)) +
  geom_bar(stat = "identity", fill = "purple") +
  xlab('Year') +
  ylab("Sum 'housing'") +
  ggtitle("Sum of the word 'housing' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Ontario, CA') 
plot_housing + theme_light()

grid.arrange(plot_warehouse, plot_park, plot_transportation, plot_housing, ncol = 2)

# Rialto 
warehouse <- 'warehouse'
sum_warehouse <- c()

for(i in 1:nrow(rialto)){
  split_text <- str_split(rialto$Text[i], '\\st+')
  sum_warehouse_per_text <- str_count(split_text, warehouse)
  sum_warehouse <- c(sum_warehouse, sum(sum_warehouse_per_text))
}

plot_warehouse <- ggplot(rialto, aes(x = Year, y = sum_warehouse)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  xlab('Year') +
  ylab("Sum 'warehouse'") +
  ggtitle("Sum of the word 'warehouse' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14))
plot_warehouse + theme_light()

park <- 'recreation'
sum_park <- c()

for(i in 1:nrow(rialto)){
  split_text <- str_split(rialto$Text[i], '\\st+')
  sum_park_per_text <- str_count(split_text, park)
  sum_park <- c(sum_park, sum(sum_park_per_text))
}

plot_park <- ggplot(rialto, aes(x = Year, y = sum_park)) +
  geom_bar(stat = "identity", fill = "orange1") +
  xlab('Year') +
  ylab("Sum 'recreation'") +
  ggtitle("Sum of the word 'recreation' each year") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Rialto, CA') 
plot_park + theme_light()

transportation <- 'transportation'
sum_transportation <- c()

for(i in 1:nrow(rialto)){
  split_text <- str_split(rialto$Text[i], '\\st+')
  sum_transportation_per_text <- str_count(split_text, transportation)
  sum_transportation <- c(sum_transportation, sum(sum_transportation_per_text))
}

plot_transportation <- ggplot(rialto, aes(x = Year, y = sum_transportation)) +
  geom_bar(stat = "identity", fill = "cyan") +
  xlab('Year') +
  ylab("Sum 'transportation'") +
  ggtitle("Sum of the word 'transportation' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Rialto, CA') 
plot_transportation + theme_light()

housing <- 'housing'
sum_housing <- c()

for(i in 1:nrow(rialto)){
  split_text <- str_split(rialto$Text[i], '\\st+')
  sum_housing_per_text <- str_count(split_text, housing)
  sum_housing <- c(sum_housing, sum(sum_housing_per_text))
}

plot_housing <- ggplot(rialto, aes(x = Year, y = sum_housing)) +
  geom_bar(stat = "identity", fill = "purple") +
  xlab('Year') +
  ylab("Sum 'housing'") +
  ggtitle("Sum of the word 'housing' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Rialto, CA') 
plot_housing + theme_light()

grid.arrange(plot_warehouse, plot_park, plot_transportation, plot_housing, ncol = 2)

# March JPA 
warehouse <- 'warehouse'
sum_warehouse <- c()

for(i in 1:nrow(marchjpa)){
  split_text <- str_split(marchjpa$Text[i], '\\st+')
  sum_warehouse_per_text <- str_count(split_text, warehouse)
  sum_warehouse <- c(sum_warehouse, sum(sum_warehouse_per_text))
}

plot_warehouse <- ggplot(marchjpa, aes(x = Year, y = sum_warehouse)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  xlab('Year') +
  ylab("Sum 'warehouse'") +
  ggtitle("Sum of the word 'warehouse' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14))
plot_warehouse + theme_light()

park <- 'recreation'
sum_park <- c()

for(i in 1:nrow(marchjpa)){
  split_text <- str_split(marchjpa$Text[i], '\\st+')
  sum_park_per_text <- str_count(split_text, park)
  sum_park <- c(sum_park, sum(sum_park_per_text))
}

plot_park <- ggplot(marchjpa, aes(x = Year, y = sum_park)) +
  geom_bar(stat = "identity", fill = "orange1") +
  xlab('Year') +
  ylab("Sum 'recreation'") +
  ggtitle("Sum of the word 'recreation' each year") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'March Joint Powers Authority, CA') 
plot_park + theme_light()

transportation <- 'transportation'
sum_transportation <- c()

for(i in 1:nrow(marchjpa)){
  split_text <- str_split(marchjpa$Text[i], '\\st+')
  sum_transportation_per_text <- str_count(split_text, transportation)
  sum_transportation <- c(sum_transportation, sum(sum_transportation_per_text))
}

plot_transportation <- ggplot(marchjpa, aes(x = Year, y = sum_transportation)) +
  geom_bar(stat = "identity", fill = "cyan") +
  xlab('Year') +
  ylab("Sum 'transportation'") +
  ggtitle("Sum of the word 'transportation' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'March Joint Powers Authority, CA') 
plot_transportation + theme_light()

housing <- 'housing'
sum_housing <- c()

for(i in 1:nrow(marchjpa)){
  split_text <- str_split(marchjpa$Text[i], '\\st+')
  sum_housing_per_text <- str_count(split_text, housing)
  sum_housing <- c(sum_housing, sum(sum_housing_per_text))
}

plot_housing <- ggplot(marchjpa, aes(x = Year, y = sum_housing)) +
  geom_bar(stat = "identity", fill = "purple") +
  xlab('Year') +
  ylab("Sum 'housing'") +
  ggtitle("Sum of the word 'housing' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'March Joint Powers Authority, CA') 
plot_housing + theme_light()

grid.arrange(plot_warehouse, plot_park, plot_transportation, plot_housing, ncol = 2)

# Chino 
warehouse <- 'warehouse'
sum_warehouse <- c()

for(i in 1:nrow(chino)){
  split_text <- str_split(chino$text[i], '\\st+')
  sum_warehouse_per_text <- str_count(split_text, warehouse)
  sum_warehouse <- c(sum_warehouse, sum(sum_warehouse_per_text))
}

plot_warehouse <- ggplot(chino, aes(x = year, y = sum_warehouse)) +
  geom_bar(stat = "identity", fill = "turquoise") +
  xlab('Year') +
  ylab("Sum 'warehouse'") +
  ggtitle("Sum of the word 'warehouse' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14))
plot_warehouse + theme_light()

park <- 'recreation'
sum_park <- c()

for(i in 1:nrow(chino)){
  split_text <- str_split(chino$text[i], '\\st+')
  sum_park_per_text <- str_count(split_text, park)
  sum_park <- c(sum_park, sum(sum_park_per_text))
}

plot_park <- ggplot(chino, aes(x = year, y = sum_park)) +
  geom_bar(stat = "identity", fill = "orange1") +
  xlab('Year') +
  ylab("Sum 'recreation'") +
  ggtitle("Sum of the word 'recreation' each year") +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Chino, CA') 
plot_park + theme_light()

transportation <- 'transportation'
sum_transportation <- c()

for(i in 1:nrow(chino)){
  split_text <- str_split(chino$text[i], '\\st+')
  sum_transportation_per_text <- str_count(split_text, transportation)
  sum_transportation <- c(sum_transportation, sum(sum_transportation_per_text))
}

plot_transportation <- ggplot(chino, aes(x = year, y = sum_transportation)) +
  geom_bar(stat = "identity", fill = "cyan") +
  xlab('Year') +
  ylab("Sum 'transportation'") +
  ggtitle("Sum of the word 'transportation' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Chino, CA') 
plot_transportation + theme_light()

housing <- 'housing'
sum_housing <- c()

for(i in 1:nrow(chino)){
  split_text <- str_split(chino$text[i], '\\st+')
  sum_housing_per_text <- str_count(split_text, housing)
  sum_housing <- c(sum_housing, sum(sum_housing_per_text))
}

plot_housing <- ggplot(chino, aes(x = year, y = sum_housing)) +
  geom_bar(stat = "identity", fill = "purple") +
  xlab('Year') +
  ylab("Sum 'housing'") +
  ggtitle("Sum of the word 'housing' each year") +
  ggeasy::easy_center_title() +
  theme(axis.text = element_text(size = 12),
        axis.title = element_text(size = 14)) +
  labs(caption = 'Chino, CA') 
plot_housing + theme_light()

grid.arrange(plot_warehouse, plot_park, plot_transportation, plot_housing, ncol = 2)