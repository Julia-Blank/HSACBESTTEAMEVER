#loading in packages so that we can...
library(tidyverse) #general use
library(readxl) #import/export spreadsheets
library(scales) #rescale data
#another useful package (that we won't use for now is ggplot2 - great for graphing!)

#importing regular season data
MLB3 <- read_excel("rawdata/MLB3.xlsx") #change the file name (what is in quotes) depending on what you called it/where it is on your computer
View(MLB3) #to see the spreadsheet in R
mlb3_long <-gather(MLB3, team, ra3, ARI:WSN) #convert to long format in order to make 1 row per team-year
View(mlb3_long)

#same thing for playoffs data
MLB3_none <- read_excel("rawdata/no z no adj.xlsx")
View(MLB3_none)
MLB3_none$finalyear <- MLB3_none$Years #renaming column names to make it easier to merge in the future
MLB3_none$Years <- NULL #dollar sign after the file name indicates a column name
mlb3_none_long <-gather(MLB3_none, team, ra3playoff, ARI:WSN) #again, converting to make 1 row per team-year
View(mlb3_none_long)

#merging regular season and playoff data
mlb3_all_none <- merge(mlb3_long, mlb3_none_long, by=c("finalyear", "team")) #format for merge: (dataset1, dataset2, by = variables that are the same in both datasets)
View(mlb3_all_none)

#cleaning the data
##to remove 3-year sequences with 1901 and 1902 (which had no playoffs), as well as Mets' opening seasons
##number of rows will change for different dynasty years
mlb3_all_none <- mlb3_all_none[-c(1:62, 1848, 1879), ] #subset the data to drop (using the minus sign) the rows we don't want
mlb3_all_none <- mlb3_all_none %>% drop_na() #drop any row that has NA (so if there was no playoffs that year, it is not included)

#rescaling the data to put playoffs and regular season at equal weights 
mlb3_all_none$ra3_rescaled <- rescale(mlb3_all_none$ra3, to = c(0,1)) 
mlb3_all_none$ra3playoff_rescaled <- rescale(mlb3_all_none$ra3playoff, to = c(0,1))
#create a new column which is the sum of the playoff and regular season "scores"
mlb3_all_none$sum <- mlb3_all_none$ra3playoff_rescaled + mlb3_all_none$ra3_rescaled

#save CSV file to your computer
write.csv(mlb3_all_none, "MLB 3 Year Dynasties.csv") #format of write.csv: (dataset name in R, file you want to save it as (in quotes))



