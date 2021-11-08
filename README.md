# dashboard_R


This R Dashboard is about Olympic Games, it summarizes more than 100 years of Olympic Games and highlight some specific performances and statistics. 

# User guide :

## This guide is an overview and explains the important features

The Dashboard is built with R and Shiny, graphs are powered by ggplot, Plotly and DT:
- [What is Shiny and its User Guide](https://shiny.rstudio.com/)
- [How to install Shiny](https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/)
- [What is ggplot and how to install it](https://ggplot2.tidyverse.org/index.html)
- [What is Plotly and how to install it](https://plotly.com/r/getting-started/)
- [What is DT and how to install it](https://rstudio.github.io/DT/)


The Olympics Games Datasets:
 - [The main Kaggle's Dataset](https://www.kaggle.com/heesoo37/olympic-history-data-a-thorough-analysis/data)
 - [Olympic Games Wikipedia](https://en.wikipedia.org/wiki/Olympic_Games)
 - [Olympic Games Results](https://olympics.com/en/olympic-games)


The R's libraries required for the compilation are :  Shiny, lubridate, tidyverse, dplyr, plotly, DT, ggrepel and ggplot2.
You can download the folder and open the code with Rstudio, then you can click on 'Run the app' on the top corner left. If it doesn't work you can simply copy(ctrl+c) all the code and paste(ctrl+v) it in the console prompt (if it's located in the 'dashboard_r' folder) and then press enter.
(you might wait a bit because there is a lot of datas and graphs to browse)


# Dashboard presentation :

*We will try to summarize the dynamics behind these analytics.*

## Total amount of medals

![Screenshot_1](https://user-images.githubusercontent.com/81488993/140648385-8a52d765-d053-4476-b712-f6250fe6eed3.png)


Here we can see that United States are the strongest nation in the Olympic Games, they are folowed by the Soviet Union which no longer exist since 30 years, it does mean that during their 68 years of existence they were enough dominant to not be outdated. Further there is East Germany which is in almost in the same case. Overall we see that Western countries are the strongest even if China, Japan and South Korea are well positionned.

## Total amount of medals by region

 
| America | Asia |
| ------------- | ------------- |
| ![image](https://user-images.githubusercontent.com/81488993/140648424-ad9511d7-44f0-4d37-b625-944def418623.png) | ![image](https://user-images.githubusercontent.com/81488993/140648438-c0219fa3-aeb5-4684-93ff-c5332e1d0497.png) |

It clearly shows American, Korean, Japanese and Chinese dominance in their respective regions.

## Map of medals won by year

| 1936 | 2016 |
| ------------- | ------------- |
| ![image](https://user-images.githubusercontent.com/81488993/140648479-77293ff5-aee1-4aa9-a215-cb7709458a22.png) | ![image](https://user-images.githubusercontent.com/81488993/140648502-3baaa9e2-94e2-4e2e-a687-b7c2aa09a936.png) |

This Map is about medals won by year, so it's better to see it scroll in the app. But what we can say is that United states has been dominant since the beginning and that some countries has never gained any medals and some others has obtained their first ever medal quite recently. We also see that there is an increasingly number of medals winner each editions, it shows that the Olympics games are more and more popular worldwide.

## Map of medals won by sport

|Athletics|Gymnatiscs|
|-|-|
| ![image](https://user-images.githubusercontent.com/81488993/140648602-53ab8613-9402-4edf-931c-e19c9044db88.png) | ![image](https://user-images.githubusercontent.com/81488993/140648610-e12b894b-6ccb-42c3-b594-de38000c9ffa.png) |
|Equestrianism|Fencing|
| ![image](https://user-images.githubusercontent.com/81488993/140648642-1372c00f-ce2c-4920-8063-200ce63fcb14.png)| ![image](https://user-images.githubusercontent.com/81488993/140648656-993dde6d-c86d-4a4a-9516-a7a3427188dd.png) |  
|Weightlifting|Conoeing|
![image](https://user-images.githubusercontent.com/81488993/140648687-ec8a55e4-3214-4cc4-9f41-57b5386b1614.png) | ![image](https://user-images.githubusercontent.com/81488993/140648700-d2984827-1ccb-467b-a51f-16a5c4a77def.png) |

These maps shows that the U.S are strong on almost every sport, it also shows that some countries have their favourite sports like France and Italy with fencing and Germany with canoeing. The Weightlifting map present a great confrontation between the U.S and China and the Equestrianism map confirms that the european countries are the strongest on horses.

## Performance by editions

| Boxplot | Histogram |
|-|-|
| ![image](https://user-images.githubusercontent.com/81488993/140648771-068a18b8-f611-4895-ad33-aed472863b3d.png) | ![image](https://user-images.githubusercontent.com/81488993/140648777-7cf25ab7-973b-4014-a143-f58a3841c9ef.png) |
| ![image](https://user-images.githubusercontent.com/81488993/140648804-25afb437-1d29-455b-ba56-591881cd39a7.png) | ![image](https://user-images.githubusercontent.com/81488993/140648817-5b957813-dab3-4872-96df-7327060cd592.png) |
| ![image](https://user-images.githubusercontent.com/81488993/140648857-b3751ec5-bad3-4064-acfa-343a8a73fe9f.png) | ![image](https://user-images.githubusercontent.com/81488993/140648884-e438fe1c-fc38-4396-978f-7dc17bfe5191.png) |

What is most striking is that the athletes have progressed a lot since the beginning of the Olympics. In all the fields, the performances improve with time before stabilizing a little, in general since the years 70-80. Therefore, we can expect that worlds record become rarers and that athletes reach a point where the human body can't go further. 
The Histograms highlight that 'good' performances are common because most of the results are not so far away from the record but doing a truly great performance is very rare, combined with the fact that boxes in the boxplots are getting smaller and smaller we can conclude that the athletes performances are increasingly close and good.  

## Weight/Height by sport

![image](https://user-images.githubusercontent.com/81488993/140648987-e3c3ff60-1558-4120-909d-558bd3ed6eb6.png)

Here we have the height and weight displayed by sport and gender. We observe that there are notable differences depending on the sport. 
We already observe a certain trend between the Weight/Height ratio but some sports are totally out of this trend. Indeed if we take the case of men, we see that gymnasts meet this trend, but they are the smallest, as well as the lightest. Conversely, we have sports like volleyball or basketball where men are the tallest and among the heaviest. Among those who do not follow this trend, we find for example the Weightlifters who have to be very heavy and small. Or tug-of-war athletes who must be as heavy as possible.
This is not surprising, as we can see that each sport requires very specific characteristics of size and weight depending on the type of sport, power or agility, team or individual, combat or precision etc.

## Sports and players wise medal Count

![image](https://user-images.githubusercontent.com/81488993/140649818-61cb925b-1712-4555-a294-fac198cabbb4.png)

These tables summarizes who won the most medals and which sport give the most medals, we can see that sport that most people will think about when thinking about olympics games are indeed the most represented. 
The second table shows for instance how Micheal Phelps is a legend of the olympics and that he has a very impressive number of gold medals compared to the others, we also see that a lot of athletes played for the Soviet Union which demonstrate their power at the time. Nevertheless there is a majority of American athletes in this list.
 
## Medal count by GDP and Population

![image](https://user-images.githubusercontent.com/81488993/140649486-bac0ef81-1127-4ca6-aa79-75a881a47189.png)

GDP and Population values are log values, so the real distibution is wider. We see that there is kind of a threshhold to be a succesfull nation in the olympic game, nations with a not enough aumount of GDP and population all have less than 30 medals. We also can see that the medals are more correlateed with GDP than population.


# Dev Guide :
 
*The code is composed of three major parts which we will explain*

## Data Importation, Preparation and Aggregation

Our study is based on a database "120 years of Olympic history: athletes and results" available on Kaggle: https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results
It contains 271116 data on all the editions of the summer and winter Olympic games since 1896, that is 51 editions. 
It provides us the following information:


| Name| Information | Type |
|-|-|-|
| ID | Unique number for each athlete | Integer |
| Name | Athlete’s name | String |
| Sex  | Athlete’s gender | Char (F or M) |
| Age | Athlete’s age | Integer |
| Height | Athlete’s height (in centimeters) | Integer |
| Weight | Athlete’s weight (in kilograms) | Integer |
| Team | Athlete’s team name | String  |
| NOC | National Olympic Committee 3-letter code | String |
| Games | Year and Season | String |
| Year | Year of the Olympic Game edition | Integer |
| Season | Summer or Winter | String |
| City | City which hosted the Olympic Game | String |
| Sport | The category of the event (Swimming, Athletics…) | String |
| Event | The event (100m, marathon …) | String |
| Medal | Gold, Silver, Bronze or NA | String |

To complete this data, we have created a scraper to get the data from the official website of the Olympic games: https://olympics.com/

First we list all the editions we want to scrape, then the sports. With these two lists we generate the links of the pages to analyze in this way https://olympics.com/en/olympic-games/[edition]/results/[category]/[sport]
For example for the edition in Rio in 2016 for the 100m men in the athletics category: https://olympics.com/en/olympic-games/rio-2016/results/athletics/100m-men
After getting the HTML data of the page using the urllib library (https://docs.python.org/fr/3/library/urllib.request.html#module-urllib.request).
we use HTMLParser from the html library - HyperText Markup Language support (https://docs.python.org/3/library/html.html). 
We can start to look for the important data by launching the function MyHTMLParser.scan(self, data, game_info, sport_info) by passing to it in arguments the information on the sport being studied. With this information the function will generate "info" which contains : 
[ The gender (M or W) , The sport , The country, the year ].

The parser will scan the page, look for a tag whose id is "event-result-row" with handle_starttag, retrieve the following data with handle_data. Once the important data is retrieved, we use save_row to add information about the rank, the name, the country and the result. If the result is a time, we format it to follow this pattern : 0:00:00.00 . For example 9s58 will become 0:00:09.58.
We also merge this information with the information of the event stored in infos to have in the end : [gender, sport, location, year, rank, name, country, results] that we add to all the other scraped data.
We repeat the operation for each "event-result-row" tag, then for each sport in the list, then for each edition of the games.	
For simplicity, a Sport class has been created to contain the information about the sports categories studied in our work. (running, athletics and swimming).
You have to modify sportSelected to choose the desired sports.
Once all the data is scraped, we write it all in a csv file.


we decare locals variables like conversion tables and NOC codes.
Then, as you can see below, we read the csv files, take infos that we want and reformart the datas into a dataframe.
![image](https://user-images.githubusercontent.com/81488993/140649526-48e030b4-0fd1-438d-9d43-d622425d8fd8.png)
We do that multiple times and each time, depending on the finale graph that we want, the csv file, the selected columns and the format are different.

## Application Architecture

There we define the architecture of the application with shiny's output and input elements and graphs.
![image](https://user-images.githubusercontent.com/81488993/140649552-45f43a3a-faef-442e-830f-addd454b3829.png)
It is designed as classic HTML files, but the main elements are shinys elements

## Interactions and renders

The screen below is a basic render, we use elements' ID to interact with them as output/input.
![image](https://user-images.githubusercontent.com/81488993/140649600-c1c6d958-d520-4692-9604-cd24ef3e0418.png)
We link inputs/outputs with a render to return a graph or to update some elements.

## Other files

The scrap.py file has been used to generate Running_results, Swimming_results and Athletics_results csv files.
This file is now useless but can be upgraded to generate new datas.
