# The Politics of Warehousing in the Inland Empire, CA: How did we get here?
## By: Alyson Otañez
##### Advisor: Dr. Marisa Abrajano

## Background
  The Inland Empire (IE) is made up of the San Bernardino and Riverside counties, just east of Los Angeles in Southern California. The IE has experienced rapid economic and industrial growth as a result of the increased demand of e-commerce and fast delivery, which has led to decreased air quality, loss of green space, and health impacts to the region. At the local and state level, this region and its people have been treated as disposable and as the “land of cheap dirt." Warehouse development and placement has proven to be an environmental injustice issue, with over 300,000 individuals living within ¼ mile of a warehouse, roughly 60% of which are Hispanic/Latino. San Bernardino and Riverside counties are also the top two counties in the United States with high concentrations of ozone, where over a third of their year is met with dangerous levels of ozone.
  Decisions on where warehouses can be placed and the approval of them is decided at the local level. Through ambiguous and harmful zoning practices, the Inland Empire has become an industrial center with warehouses placed in close proximity to schools, homes, parks, etc. Based on research conducted by Radical Research and Pitzer College, the 5 cities/regions with the highest concentrations of warehouses are Ontario, Fontana, Rialto, Chino, and the March Joint Powers Authority. My research delves into the behavior taking place at the local level, answering: How have local elected officials in the IE facilitated the growth of industrial warehouses? Do local governments in the IE prioritize warehousing developments over rent control, jobs and the economy, and reducing crime? I find that IE cities discuss warehouses at a higher rate when compared to other issues, and contextually, when discussing warehousing, I find a greater focus on approval and development of new spaces which is not as present in the other issues.
  
![IE_Warehouse_Map](https://github.com/user-attachments/assets/18e01a29-9a19-4a77-81b6-987926116400)
![IE_Race](https://github.com/user-attachments/assets/867bdc52-a948-4b14-9ecf-2472830b7204)
![IE_Risk](https://github.com/user-attachments/assets/5dcaf38e-b59c-440c-bd9f-6df9e8986b2c)

## Research Question & Hypotheses
How have local elected officials in the IE facilitated the growth of industrial warehouses? Do local governments in the IE prioritize warehousing developments over rent control, jobs and the economy, and reducing crime? To address these questions, I test two hypotheses:
1. The amount of discussions dedicated to the approval of new warehouses in city council meetings are far greater than the amount of discussions focused on the approval of new housing, creating jobs and improving the economy, and strengthening public safety.
2. The semantic relationships in which warehouses are discussed versus housing, jobs and the economy, and public safety will differ significantly.

## Data
Scraped the city council meeting agenda/minutes of Ontario, Fontana, Rialto, Chino, and the March Joint Powers Authority. Templates to scrape the data can be found in the `Web_Scraping` folder. Each website was scraped indivually and combined into one file. A PDF (that must be downloaded to access the links) can be found in the `Data` folder, within the folder there is a small sample of the data for reference. 

[Google Drive with all data sets](https://drive.google.com/drive/folders/1VLErQ8uxj7wk_5ENa5H1SLVD98MowPkc?usp=sharing)

[Combined data](https://drive.google.com/file/d/1or3ZNrS9mVwjXdhX2DUCPjRyUwgrauiv/view?usp=sharing) 

**N = 5,526** 

## Methods 
1. `STM_Analysis` To test H2, I use an structural topic model (STM), which is a generative topic model of word counts, where a topic is defined as a combination of words where each word has a probability of belonging to a given topic. Documents are a mixture of topics, meaning that a single document can be composed of various topics. This means that the sum of topic proportions across all topics for a given document is one, and the total word probabilities for a given topic is one.nSTM can provide more accurate and quality estimations when comparing documents and topics as it takes into account the context of the documents as well as the impact of word frequency. This model provides contextual information in two ways: topic prevalence and topic content which can both vary by metadata. Topic prevalence refers to the mention of certain words or concepts in a given document; for example, Democrats talk more about climate change than Republicans. Topic content refers to the co-occurrence of words, for example, when discussing gun/firearms Democrats are more likely to use the words “control” and “restriction(s)” than Republicans.

2. `LDA_Analysis` To test H1, I applied a Latent Dirichlet Allocation (LDA) model to my corpus (combined data of all cities). LDA is the most common topic model in natural language processing (NLP) that applies unsupervised machine learning to textual data to create a group of terms that summarize the document's topics. LDA treats individual documents as a collection of texts in a bag of words model, focusing on term frequency and co-occurrence rather than word order and context. LDA topic models group co-occurring words into a set of topics, wherein each topic represents a probability distribution across the corpus, and classifies a given text into a document and presents the words per topic. Topics appear in a descending order, and words within the topic also appear in a descending order relative to other words within the topic in terms of frequency. The LDA model allows me to test for H1, and understand what topics best describe the corpus, and which words are most related to one another.

## Key Findings 

Despite the harmful health and environmental impact of industrial warehouses, I find that IE local governments spend a significant amount of time discussing (H1) and approving (H2) more warehouses. My research lends support to my hypotheses that the amount of discussion dedicated to the approval of new warehouses in city council meetings are far greater than the amount of discussion focused on the approval of new housing, creating jobs and improving the economy, and strengthening public safety. I also find support for my second hypothesis, which expects that the semantic relationships in which warehouses are discussed versus housing, jobs and the economy, and public safety differ significantly.

Applying a LDA model to my data consisting of city council meeting agendas, H1 is supported, as I derive that 31.8% of all tokens in the data are most related to a topic that is thematically associated with warehousing. <img width="786" alt="lda_topic1" src="https://github.com/user-attachments/assets/38ea7daa-1dd7-43e1-abd6-83c9f18a5cfb" />

Applying a STM model to my data, H2 is supported, that the language and context used when discussing warehousing differs from discussions on other
issues.
<img width="1470" alt="Industrial_Job_Perspective" src="https://github.com/user-attachments/assets/ce175623-631d-430e-b546-6db2da4179d8" />

Additional plots and figures can be found in `Figures`, maps can be found in `Maps`, and the final paper can be found in `Thesis`.

## Information on Project

1. This research project began as an Independent Study ([POLI 199](https://polisci.ucsd.edu/undergrad/research-opportunities/Independent%20Study%20-%20POLI%20199.html)) in the Political Science Deparatment at UC San Diego in 2023.
2. I then was 1 of 4 recipients of a $5,000 scholarship from the [UCSD TRELS](https://ugresearch.ucsd.edu/programs/all-urh-programs/trels/index.html) program to conduct summer research with a faculty member in summer 2023 ([My Profile](https://ugresearch.ucsd.edu/students/student-profiles/archive/2023-2024/alyson-ota%C3%B1ez.html)).

The research completed at the end of summer 2023 was presented at the 2023 UC San Diego Summer Research Conference, and at the 2023 University of Maryland Rising Scholars Conference. 

3. To continue this research I participated in the [Political Science Senior Honors Program](https://polisci.ucsd.edu/undergrad/departmental-honors-and-pi-sigma-alpha/departmental-honors.html) throughout 2024-2025 where I received **High Honors** and the **DeWitt Higgs Award for the Most Outstanding Honors Thesis in Law and Public Policy**.

