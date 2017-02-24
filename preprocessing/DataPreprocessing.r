
# find functions for creating confusion matrix within the currenltly loaded packages
print(apropos("confusion"))

# Find such a function in any package. Opens a new browser window
#RSiteSearch("confusion", restrict = "functions")

#install.packages(c('AppliedPredictiveModeling'))

library(AppliedPredictiveModeling)

data(segmentationOriginal)
segData <- subset(segmentationOriginal, Case == "Train")

cellId <- segData$Cell
class <- segData$Class
case <- segData$Case

# Now remove the columns
segData <- segData[,-(1:3)]

statusColNum <- grep("Status", names(segData))
statusColNum

segData <- segData[,-statusColNum]

library(e1071)

#For one predictor:
skewness(segData$AngleCh1)

# Since all predictors are numeric columns, the apply function can 
# be used to computre skewness accross columns
# apply(data, 1=Col, 2=Rows, c(1,2) = Row and Col, function)
skewValues <- apply(segData, 2, skewness)
head(skewValues)

hist(skewValues)

library(caret)
Ch1AreaTrans <- BoxCoxTrans(segData$AreaCh1)
Ch1AreaTrans

head(segData$AreaCh1)

predict(Ch1AreaTrans, head(segData$AreaCh1))

# Compute manually
(819^(-.9)-1)/(-.9)

pcaObject <- prcomp(segData, center = TRUE, scale. = TRUE)

# Calculate the cumulative percentage of variance which each component accounts for
percentVariance <- pcaObject$sd^2/sum(pcaObject$sd^2)*100
percentVariance[1:3]

head(pcaObject$x[,1:5])

head(pcaObject$rotation[,1:3])

trans <- preProcess(segData,
                    method = c("BoxCox", "center", "scale", "pca"))
trans

transformed <- predict(trans, segData)

# These values are different than the previous PCA components since
# they were transformed prior to PCA
head(transformed[,1:5])

# For this dataset there are no nearZeroVar predictors.

nearZeroVar(segData)

correlations <- cor(segData)
dim(correlations)

correlations[1:4, 1:4]

library(corrplot)
corrplot(correlations, order="hclust")

highCorr <- findCorrelation(correlations, cutoff = .75)
length(highCorr)

head(highCorr)

filteredSegData <- segData[,-highCorr]

data(cars)
type <- c("convertible", "coupe", "hatchback", "sedan", "wagon")
cars$Type <- factor(apply(cars[, 14:18], 1, function(x) type[which(x == 1)]))

carSubset <- cars[sample(1:nrow(cars), 20), c(1, 2, 19)]
head(carSubset)
levels(carSubset$Type)

simpleMod <- dummyVars(~Mileage + Type,
                      data = carSubset,
                      ## Remove the variable name from the column name
                      levelsOnly = TRUE)
simpleMod

predict(simpleMod, head(carSubset))

withInteraction <- dummyVars(~Mileage + Type + Mileage:Type,
                            data=carSubset,
                            levelsOnly = TRUE)
withInteraction

predict(withInteraction, head(carSubset))


