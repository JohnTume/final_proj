library(ggplot2)
library(dplyr)
library(lubridate)
library(zoo)
#check_data <- read.csv("data/nics-firearm-background-checks.csv", stringsAsFactors = FALSE)
#violence_data <- read.csv("data/gun-violence-data_01-2013_03-2018.csv", stringsAsFactors = FALSE)
data <- read.csv("data/raw_data.csv", stringsAsFactors = FALSE)



# plot the sale tendency in state
get_total_check <- function(state_name){
  state_check <- check_data %>% filter(state == state_name)
  
  ggplot(state_check, aes(month, totals)) +
    geom_point(size = 1, color = "red") + geom_smooth(method=lm)
}

get_change <- function(state_name){
  state_check <- check_data %>% filter(state == state_name)
  
  ggplot() +
    geom_line(data = state_check, 
              color = "red",
              aes(x = month, y = totals)) +  geom_smooth(method=lm)
}

################################
map <- map_data("state")

filtered_data <- data %>% filter(year == "2017")

ggplot() +
  geom_map(data=map,
           map=map,
           aes(long, lat, map_id = region),
           fill="white", color="white", size=0.15) +
  geom_map(data=filtered_data,
           map=map,
           aes(fill=lawtotal, map_id=tolower(state)), 
           color="white", size=0.15) +
  scale_fill_continuous(low='thistle2', high='darkred', 
                                 guide='colorbar') +
  coord_map() +
  labs(title = paste0("total number of law in each state"))
