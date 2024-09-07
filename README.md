# The Politics of Warehousing in the Inland Empire, CA: How did we get here?
## By: Alyson Otañez

## Background
The Inland Empire (IE) is located in Southern California, east of Los Angeles, made up of the San Bernardino and Riverside counties. It has seen rapid economic and industrial growth as a result of the increased demand in e-commerce and fast delivery, which has led to decreased air quality, loss of green space, and health impacts to the region. Warehouse development and placement is an environmental injustice issue; over 300,000 individuals live within ¼ mile of a warehouse, ~60% are Hispanic or Latino. San Bernardino and Riverside are the top 2 counties in the United States, where over a third of their year is met with high concentrations of ozone.

The approval of new warehouses is decided at the local level. My research focuses on Ontario, Fontana, Rialto, Chino, and the March Joint Powers Authority who are the regions with the highest concentration of warehouses in the IE. My project seeks to understand conversations occurring at the local level, as if this a relatively understudied issue, with little understanding of its causes and effects. To understand the dynamic between warehousing and local governments, I chose to analyze the city council agenda/meeting minutes of the cities of interest. 

## Research Question
What role do local governments play in the growth of warehouses in the Inland Empire? What programs, projects, and proposals do these local governments prioritize?

## Data
Scraped the city council meeting agenda/minutes of Ontario, Fontana, Rialto, Chino, and the March Joint Powers Authority. Templates to scrape the data can be found in the `Web_Scraping` folder. Each website was scraped indivually and combined into one file. A PDF (that must be downloaded to access the links) can be found in the `Data` folder, within the folder there is a small sample of the data for reference. 

Google Drive with all data sets: https://drive.google.com/drive/folders/1VLErQ8uxj7wk_5ENa5H1SLVD98MowPkc?usp=sharing

Combined data: https://drive.google.com/file/d/1or3ZNrS9mVwjXdhX2DUCPjRyUwgrauiv/view?usp=sharing 

**N = 5,526** 

## Methods 
1. `STM_Analysis` Analyzed the data of each city using a Structural Topic Model (STM) due to the models ability to provide insight into how the metadata within the corpus interacts with the words of a document, resulting in the creation of topics that describe the conversations within the text. STM can provide more accurate and quality estimations when comparing documents and topics as it takes into account the context of the documents as well as the impact of word frequency. I chose this model to contrast how local governments address topics surrounding warehousing compared to programs that benefit communities such as public transportation and green spaces. This model also highlights the topic proportions, meaning what is being discussed at a higher frequency relative to another topic. Functions within the STM package extract the text that is most associated with a given topic, allowing for contextualization of the data and topics to truly understand what is being discussed and how.

2. `LDA_Analysis` Applied a Latent Dirichlet Allocation (LDA) model to my corpus (combined data of all cities). LDA topic models group co-occurring words into a set of topics, wherein each topic represents a probability distribution across the corpus. LDA classifies a given text into a document and presents the words per topic. Topics appear in a descending order, and words within the topic also appear in a descending order relative to other words within the topic in terms of frequency.
