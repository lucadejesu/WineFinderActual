#!/usr/bin/env python
# coding: utf-8

# In[34]:


# Format:
#
#
#[ {"points": "87",
#" title": "Nicosia 2013 Vulk\u00e0 Bianco  (Etna)",
#" description": "Aromas include tropical fruit, broom, brimstone and dried herb. 
#  The palate isn't overly expressive, offering unripened apple, citrus and dried sage alongside brisk acidity.",
# "taster_name": "Kerin O\u2019Keefe",
# "taster_twitter_handle": "@kerinokeefe",
# "price": null, "designation": "Vulk\u00e0 Bianco",
# "variety": "White Blend",
# "region_1": "Etna",
# "region_2": null, 
# "province": "Sicily & Sardinia",
# "country": "Italy",
# "winery": "Nicosia"}, . . . . ]

# Need to remove: taster_name, taster_twitter_handle, region_1, region_2, province
# Left with: points, title, description, price, variety, country, winery (7 attributes)


# Location: /Users/luca/Downloads/winemag-data-130k-v2.json
import json
import string 
# To stem the words - remove excess part of the word to get the root
from nltk.stem import PorterStemmer
from nltk.tokenize import word_tokenize

# To remove stop words
import nltk
from nltk.corpus import stopwords

# Count the most frequent words
from collections import Counter

stemmer = PorterStemmer()

# Varieties extracted from all of the reviews:
redWines = ['Pinot Noir', 'Cabernet Sauvignon', 'Red Blend', 'Bordeaux-style Red Blend', 'Syrah, Nebbiolo', 'Sangiovese', 
'Malbec', 'Zinfandel', 'Merlot', 'Portuguese Red', 'Gamay', 'Cabernet Franc', 'Rhône-style Red Blend', 'Tempranillo',
'Shiraz', 'Grenache', 'Tempranillo Blend', 'Petite Sirah', 'Carmenère', "Nero d'Avola", 'Nerello Mascalese',
'Barbera', 'Bonarda', 'Meritage', 'Primitivo', 'Petit Verdot', 'Aglianico', 'G-S-M', 'Mencía', 'Zweigelt',
'Cannonau', 'Dolcetto', 'Tempranillo-Merlot', 'Frappato', 'Monica', 'Touriga Nacional', 'Shiraz-Cabernet Sauvignon',
'Graciano', 'Tannat-Cabernet', 'Sangiovese Grosso', 'Prugnolo Gentile', 'Montepulciano', 'Blaufränkisch',
'Carignan-Grenache', 'Sagrantino', 'Cabernet Sauvignon-Syrah', 'Syrah-Grenache', 'Garnacha Tintorera', 'Pinot Nero',
'Pinotage', 'Pinot Noir-Gamay', 'Cabernet Sauvignon-Carmenère', 'Früburgunder', 'Sousão', 'Cinsault', 'Tinta Miúda',
'Monastrell', 'Corvina, Rondinella, Molinara', 'Port']

whiteWines = ['Chardonnay', 'Riesling', 'Sauvignon Blanc', 'White Blend', 'Prosecco', 'Pinot Gris', 'Gewürztraminer', 
'Grüner Veltliner', 'Viognier', 'Chenin Blanc', 'Bordeaux-style White Blend', 'Albariño', 'Grenache Blanc',
'Pinot Blanc', 'Sauvignon', 'Pinot Bianco', 'Garganega', 'Pinot Grigio', 'Alsace white blend', 'Torrontés',
'Verdejo', 'Grillo', 'Vernaccia', 'Portuguese White', 'Furmint', 'Cortese', 'Glera', 'Viura', 'Sylvaner',
'Roussanne', 'Viognier-Chardonnay', 'Catarratto', 'Inzolia', 'Petit Manseng', 'Vermentino', 'Fumé Blanc', 
'Ugni Blanc-Colombard', 'Friulano', 'Assyrtico', 'Savagnin', 'Vignoles', 'Muscadelle', 'Zierfandler',
'Rhône-style White Blend', 'Vidal', 'Verdelho', 'Marsanne', 'Scheurebe', 'Kerner', 'Vilana', 'Roter Veltliner',
'Sémillon', 'Antão Vaz', 'Verdejo-Viura', 'Verduzzo', 'Verdicchio', 'Silvaner', 'Colombard', 'Carricante',
'Fiano', 'Avesso', 'Chinuri', 'Muscat Blanc à Petits Grains', 'Xarel-lo', 'Greco', 'Trebbiano', 'Chenin Blanc-Chardonnay' ]

others = ['Rosé', 'Champagne Blend', 'Sparkling Blend', 'Rosato', 'Moscato', 'Muscat', 'Shiraz-Viognier',
'Syrah-Viognier', 'Melon', 'Portuguese Sparkling']







file = open("/Users/luca/Downloads/winemag-data-130k-v2.json")

# returns a dictionary
data = json.load(file)

counter = 0

keeperKeys = {'points', 'title', 'description', 'price', 'variety', 'country', 'winery'}

newNewDict = []
allWords = []
allTypes = []
while counter < 1000:
    # Get each desired key, remove the rest:
    newDict = { keeper_key: (data[counter])[keeper_key]for keeper_key in keeperKeys}
    
    
    # Classifying the wine by red, white, or other:
    color = newDict.get('variety')
    
    for variety in redWines:
        if color == variety:
            color = 'red'
    for variety in whiteWines:
        if color == variety:
            color = 'white'
    for variety in others:
        if color == variety:
            color == 'other'
    newDict['color'] = color
    
    # Get the wine type
    # currentType = newDict.get('variety')
    # allTypes.append(currentType)
    
    
    # For visualizing the transformation:
    currentDescription = newDict.get('description')
    
    # We want to remove punctuation 
    currentDescription = currentDescription.translate(str.maketrans('', '', string.punctuation))
    
    #Tokenize the description into a list of strings
    current_words = word_tokenize(currentDescription)
    
    # We want to remove stop words
    filtered_words = [word for word in current_words if word not in stopwords.words('english')]
    
    
    # We want to stem the words to their base
    #new_words = []
    #for word in filtered_words:
    #    word = stemmer.stem(word)
    #    new_words.append(word)
    currentDescription = filtered_words
    
    # So we can later find the top words
    for word in filtered_words:
        allWords.append(word)
        
    newDict['description'] = currentDescription
    #print(newDict.get('description'))
    
    # We want to enhance with phrases
    
    
    newNewDict.append(newDict)
    counter += 1

# Check the most common words:
word_counts = Counter(allWords)
top_sixty = word_counts.most_common(60)

# Count all unique types:
#typeCounts = Counter(allTypes)
#print(top_sixty)
#print(typeCounts)
    
#i = 0
#while i < 5:
#   print(newNewDict[i])
#   i += 1
with open('/Users/luca/Downloads/wineData.json', 'w') as fout:
    json.dump(newNewDict, fout)


# I got the top 60 words to influence the flavor note selections
#flavor notes: fruit, cherry, berry, spice, oak, citrus, plum, pepper, vanilla, lemon, soft, sweet, dry, juicy, light, full
#type red, white, rose/champagne,other
#price

#Red kinds: 'Pinot Noir', 'Cabernet Sauvignon', 'Red Blend', 'Bordeaux-style Red Blend', 'Syrah, Nebbiolo', 'Sangiovese', 
# 'Malbec', 'Zinfandel', 'Merlot', 'Portuguese Red', 'Gamay', 'Cabernet Franc', 'Rhône-style Red Blend', 'Tempranillo',
# 'Shiraz', 'Grenache', 'Tempranillo Blend', 'Petite Sirah', 'Carmenère', 'Nero d'Avola', 'Nerello Mascalese',
# 'Barbera', Bonarda', 'Meritage', 'Primitivo', 'Petit Verdot', 'Aglianico', 'G-S-M', 'Mencía', 'Zweigelt',
# 'Cannonau', 'Dolcetto', 'Tempranillo-Merlot', 'Frappato', 'Monica', 'Touriga Nacional', 'Shiraz-Cabernet Sauvignon',
#  'Graciano', 'Tannat-Cabernet', 'Sangiovese Grosso', 'Prugnolo Gentile', 'Montepulciano', 'Blaufränkisch',
# 'Carignan-Grenache', 'Sagrantino', 'Cabernet Sauvignon-Syrah', 'Syrah-Grenache', 'Garnacha Tintorera', 'Pinot Nero',
# 'Pinotage', 'Pinot Noir-Gamay', 'Cabernet Sauvignon-Carmenère', 'Früburgunder', 'Sousão', 'Cinsault', 'Tinta Miúda',
#  'Monastrell', 'Corvina, Rondinella, Molinara', 'Port'   



#White kinds: 'Chardonnay', 'Riesling', 'Sauvignon Blanc', 'White Blend', 'Prosecco', 'Pinot Gris', 'Gewürztraminer', 
# 'Grüner Veltliner', 'Viognier', 'Chenin Blanc', 'Bordeaux-style White Blend', 'Albariño', 'Grenache Blanc',
# 'Pinot Blanc', 'Sauvignon', 'Pinot Bianco', 'Garganega', 'Pinot Grigio', 'Alsace white blend', 'Torrontés',
#  'Verdejo', 'Grillo', 'Vernaccia', 'Portuguese White', 'Furmint', 'Cortese', 'Glera', 'Viura', 'Sylvaner',
# 'Roussanne', 'Viognier-Chardonnay', 'Catarratto', 'Inzolia', 'Petit Manseng', 'Vermentino', 'Fumé Blanc', 
# 'Ugni Blanc-Colombard', 'Friulano', 'Assyrtico', 'Savagnin', 'Vignoles', 'Muscadelle', 'Zierfandler',
# 'Rhône-style White Blend', 'Vidal', 'Verdelho', 'Marsanne', 'Scheurebe', 'Kerner', 'Vilana', 'Roter Veltliner',
# 'Sémillon', 'Antão Vaz', 'Verdejo-Viura', 'Verduzzo', 'Verdicchio', 'Silvaner', 'Colombard', 'Carricante',
# 'Fiano', 'Avesso', 'Chinuri', 'Muscat Blanc à Petits Grains', 'Xarel-lo', 'Greco', 'Trebbiano', 'Chenin Blanc-Chardonnay'       


#Rose/Champagne/Other: 'Rosé', 'Champagne Blend', 'Sparkling Blend', 'Rosato', 'Moscato', 'Muscat', 'Shiraz-Viognier',
# 'Syrah-Viognier', 'Melon', 'Portuguese Sparkling'   





# In[ ]:





# In[ ]:




