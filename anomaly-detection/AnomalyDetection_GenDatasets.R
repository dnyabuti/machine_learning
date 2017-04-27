
setwd("/home/davis/datascience/machine_learning/preprocessing/data")

file_list <- list.files(".")
if (exists("dataset")){
  rm(dataset)
}
for (file in file_list){
  
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.csv(file, header=TRUE, sep=",")
  }
  
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.csv(file, header=TRUE, sep=",")
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
  
}

summary(dataset)
cat('Number of rows is ',nrow(dataset))

head(dataset)

library(mice)
library(VIM)
mice_plot <- aggr(dataset, col=c('navyblue','yellow'),
                  numbers=TRUE, sortVars=TRUE,
                  labels=names(dataset), cex.axis=.7,
                  gap=3, ylab=c("Missing data","Pattern"))


#sort by timestamp
dataset <- dataset[order(dataset$timestamps),]

#Save train and test dataset
train.df <- dataset[dataset$timestamps <= as.POSIXct("01/17/2015", format="%m/%d/%Y"), ] 
valid.df <- dataset[dataset$timestamps >= as.POSIXct("01/18/2015", format="%m/%d/%Y"), ]

write.csv(train.df, file = "anomaly_train.csv",row.names=TRUE)
write.csv(valid.df, file = "anomaly_valid.csv",row.names=TRUE)

