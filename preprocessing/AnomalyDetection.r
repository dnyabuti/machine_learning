
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
dataset$timestamps <- as.POSIXct(dataset$timestamps, origin="1970-01-01", tz="UTC")
y_and_time.df <- dataset[,c(1,3)]
x <- dataset[,c(-1,-3)]

cat ('X')
head(dataset)

library(e1071)
skewValues <- apply(x, 2, skewness)
head(skewValues)

hist(skewValues)
head(x)

ratio <- skewValues["noise"]/skewValues["seasonality2"]
cat("Ratio of highest to lowest skew value",ratio)

library(caret)
trans <- preProcess(x,
                    method = c("BoxCox", "center", "scale"))
trans

x_trans <- predict(trans, x)
head(x_trans)

nearZeroVar(x_trans)

x_trans <- x_trans[,c(-2,-3)]
head(x_trans)

correlations <- cor(x_trans)
correlations[1:5, 1:5]
library(corrplot)
corrplot(correlations, order="hclust")
highCorr <- findCorrelation(correlations, cutoff = .75)
length(highCorr)


library("caret")
#add anomaly back
x_trans$timestamps <- y_and_time.df$timestamps
x_trans$anomaly <- y_and_time.df$anomaly
nPeriods <- length(x_trans$timestamps)
#capture hour to hour trend correlations
x_trans$Lag1 <- c(NA,x_trans$value[1:(nPeriods-1)])
x_trans$t <- seq(1, nPeriods, 1)
$t / 24)
x_trans$Seasonal_cosine = cos(2 * pi * x_trans$t / 24)
train.df <- x_trans[x_trans$timestamps <= as.POSIXct("01/15/2015", format="%m/%d/%Y"), ] 

# Remove because Lag1 is NA
train.df <- train.df[-1,]
valid.df <- x_trans[x_trans$timestamps > as.POSIXct("01/15/2015", format="%m/%d/%Y"), ]
xvalid <- valid.df[, c(1,2,3,4,5,8,9,10,11)]

anomaly.lr <- glm(anomaly ~ Lag1 + Seasonal_sine + Seasonal_cosine+value
                  +noise+seasonality1+seasonality2+seasonality3
                  , data = train.df
#daily
x_trans$Seasonal_sine = sin(2 * pi * x_trans, family = "binomial")
summary(anomaly.lr)
anomaly.lr.pred <- predict(anomaly.lr, xvalid, type = "response") 
confusionMatrix(ifelse(anomaly.lr$fitted > 0.5, 1, 0), train.df$anomaly)
confusionMatrix(ifelse(anomaly.lr.pred > 0.5, 1, 0), valid.df$anomaly)

