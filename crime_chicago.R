# data link 
# https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2
# This dataset reflects reported incidents of crime (with exception of murders where data exists 
# for each victim) that occured in the city of Chicago from 01 / 01 / 2001 to 12/31/2014. 
library(dplyr)
library(data.table)
library(ggplot2)
library(maps)
library(ggmap)
chicago = get_map(location = "chicago", zoom = 11)
ggmap(chicago)
crime <- fread("/Users/craiglab/datascientist/heroku/R-getting-started/Crimes_-_2001_to_present.csv", skip = 1)
names <- c("ID", "case_number", "date", "block", "IUCR", "primary_type", 
           "description", "location_description", "arrest", "domestic", "beat", "district",
           "ward", "community_Area", "FBI_code", "X_coordinate", "Y_coordinate", "year",
           "updated_on", "latitude", "longitude", "location")
colnames(crime) <- names
dim(crime) # 2083325 X 22
head(crime)
# check each type of crimes
table(crime$primary_type)

# my analysis will be focusing on the three most common crimes
crime <- tbl_df(crime)

subcrime <- crime %>%
            filter(primary_type %in% c("BATTERY", "BURGLARY", "THEFT", "NARCOTICS", "CRIMINAL DEMAGE")) %>%
            select(date, primary_type, latitude, longitude) 
head(subcrime)
dim(subcrime) #1186969 X 4
subcrime$date <- strptime(subcrime$date, format = "%m/%d/%Y %I:%M:%S %p")
subcrime$weekday <- weekdays(subcrime$date)
subcrime$hour <- subcrime$date$hour
head(subcrime)
weekdayCounts <- as.data.frame(table(subcrime$weekday))
dim(weekdayCounts)
#weekdayCounts

day_hour_crime <- as.data.frame(table(subcrime$weekday, subcrime$hour))
str(day_hour_crime)
day_hour_crime$hour <- as.numeric(as.character(day_hour_crime$Var2))
head(day_hour_crime)
day_hour_crime$Var1 <- factor(day_hour_crime$Var1, ordered = TRUE, 
                             levels = c("Monday", "Tuesday",
                                        "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

ggplot(day_hour_crime, aes(x = hour, y = Var1)) + 
      geom_tile(aes(fill = Freq)) +
      scale_fill_gradient(name = "Total Crime") +
      theme(axis.title.y = element_blank())


# Load a map of Chicago into R:
 chicago = get_map(location = "chicago", zoom = 11)

# Look at the map
ggmap(chicago)

# Plot the first 100 motor vehicle thefts:
#ggmap(chicago) + geom_point(data = subcrime[1:100,], aes(x = longitude, y = latitude))

# Round our latitude and longitude to 2 digits of accuracy, and create a crime counts data frame for each area:
counts = as.data.frame(table(round(subcrime$longitude,2), round(subcrime$latitude,2)))

str(counts)

# Convert longitude and latitude variable to numbers:
counts$long = as.numeric(as.character(counts$Var1))
counts$lat = as.numeric(as.character(counts$Var2))

# Plot these points on our map and Change the color scheme:
ggmap(chicago) + geom_point(data = counts, aes(x = long, y = lat, color = Freq, size=Freq)) + scale_colour_gradient(low="yellow", high="red")



