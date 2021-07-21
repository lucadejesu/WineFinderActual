# WineFinderActual

This is an iOS application that will assist in finding wines at the grocery store. The user will request a wine based on various descriptors. Wine review data
will be used to filter search results, originally sourced from https://www.kaggle.com/zynicide/wine-reviews (update on 7/20/2021: these reviews were from 2017 and not really relevant to shopping now, so I used new reviews, explained below). After the intial search results, if the user does not
want any of the wines recommended, then the user can click "find a different wine". From there, a machine learning algorithm will recommend a new wine,
based on the unwanted wine in question.


Update on data for the wine on 7/20/2021:

1. Went to Kaggle to find the dataset and the publicly available scraper used for it, found at: https://github.com/zackthoutt/wine-deep-learning/blob/master/scrape-winemag.py . Credit for the code goes to Zack Thoutt and Valeriy Mukhtarulin for the scraper code. I merely used this script and changed the name of the dump file and added arguments for the year 2021 in the format: python3 scrape-winemag.py 1 150 2021 1 (1 is the start page, 150 the end page, 2021 the year of the review, and 1 option to clear the old data). The data is scraped from wwww.winemag.com. 
2. I used my custom "data cleaning" script that is in this repository, to add 900 reviews to the data file (150 pages generated 900 reviews from 2021).
3. In my script, dataCleaningScript.py, there is print output for the top 60 words used in the reviews. I took the new top 60 words and picked out descriptors for flavor, body, etc. Those are now added to the buttons to select for a wine. 
4. Now, there are 900 reviews in the app, all from 2021. I may add more later using this same process: scrape data from the website, clean it with the custom code, add the file and filter new descriptors from it.
