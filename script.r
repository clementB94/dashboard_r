library(readr)
library(ggplot2)
library(dplyr)
data <- read_csv("running_times.csv")
data$results <- parse_time(data$results, "%H:%M:%OS")
data$gender <- factor(data$gender)
data$sport <- ordered(data$sport, levels=c("100m","100m hurdles","110m hurdles","200m","400m","400m hurdles","800m","1500m","5000m","10000m","marathon"))
data$location <- factor(data$location)
data$year <- ordered(data$year)
data$rank <- ordered(data$rank)
data$country <- factor(data$country)
data$name <- factor(data$name)

ggplot(filter(data, sport=="100m"), aes(x=year,y=results, color=gender)) + geom_point() + geom_smooth()



best <- data %>% group_by(sport, year, gender) %>% summarize(result=as.numeric(min(results, na.rm=TRUE)))
best <- best %>% group_by(sport,gender) %>% mutate(result_ev = result/min(result))

ggplot(filter(best,gender=="M"), aes(year,sport)) + geom_tile(aes(fill=result_ev)) + scale_fill_gradient(low="black", high="white")
ggplot(best,aes(x=year,y=result_ev,color=gender,group=sport)) + geom_line()
ggplot(filter(data,sport=="100m"), aes(x = year, y = results,fill=gender))+geom_violin(position="dodge")
ggplot(filter(data,sport=="100m"), aes(x = year, y = results,fill=gender))+geom_boxplot(position="dodge")


ggplot(filter(data, sport=="100m"),aes(x=country, fill=gender)) +geom_bar(stat="count")
ggplot(filter(data,sport=="100m"),aes(x=results,fill=gender))+geom_histogram(alpha=0.7,position = "identity")
