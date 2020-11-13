
#loading in packages so that we can...
library(tidyverse) #general use
library(readxl) #import/export spreadsheets
library(scales) #rescale data
#another useful package (that we won't use for now is ggplot2 - great for graphing!)

#importing regular season data
MLB5 <- read_excel("rawdata/MLB5reg.xlsx") #change the file name (what is in quotes) depending on what you called it/where it is on your computer
View(MLB5) #to see the spreadsheet in R
mlb5_long <-gather(MLB5, team, ra5, ARI:WSN) #convert to long format in order to make 1 row per team-year
View(mlb5_long)

#same thing for playoffs data
MLB5_playoffs <- read_excel("rawdata/MLB5Playoffs.xlsx")
View(MLB5_playoffs)
#MLB5_playoff
mlb5_playoffs_long <- gather(MLB5_playoffs, team, ra5playoff, ARI:WSN )
View(mlb5_playoffs_long)

#merging regular season and playoff data
mlb5_long$initialyear <- mlb5_long$`Initial Year`
mlb5_long$`Initial Year` <- NULL
mlb5_all <- merge(mlb5_long, mlb5_playoffs_long, by=c("initialyear", "team")) #format for merge: (dataset1, dataset2, by = variables that are the same in both datasets)
View(mlb5_all)

#cleaning the data
##to remove 3-year sequences with 1901 and 1902 (which had no playoffs), as well as Mets' opening seasons
##number of rows will change for different dynasty years

mlb5_all <- mlb5_all %>% drop_na()

mlb5_all$ra5_rescaled <0 rescale(mlb5 )
mlb3_all_none <- mlb3_all_none[-c(1:62, 1848, 1879), ] #subset the data to drop (using the minus sign) the rows we don't want
mlb3_all_none <- mlb3_all_none %>% drop_na() #drop any row that has NA (so if there was no playoffs that year, it is not included)

#rescaling the data to put playoffs and regular season at equal weights 
mlb3_all_none$ra3_rescaled <- rescale(mlb3_all_none$ra3, to = c(0,1)) 
mlb3_all_none$ra3playoff_rescaled <- rescale(mlb3_all_none$ra3playoff, to = c(0,1))
#create a new column which is the sum of the playoff and regular season "scores"
mlb3_all_none$sum <- mlb3_all_none$ra3playoff_rescaled + mlb3_all_none$ra3_rescaled

#save CSV file to your computer
write.csv(mlb5_all, "MLB 5 Year Dynasties.csv") #format of write.csv: (dataset name in R, file you want to save it as (in quotes))
