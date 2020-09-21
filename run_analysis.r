library(dplyr)
library(tidyr)
library(reshape2)

## Unzip file
unzip("./getdata_projectfiles_UCI HAR Dataset.zip")

## Load "features.txt" and create variables that will
## be used to subset "set" data for "test" and "train"
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
pattern <- c("std\\(\\)","mean\\(\\)")
setExtractIndices <- grep(paste(pattern,collapse = "|"),features[,2],ignore.case = TRUE)
setExtractLabels <- grep(paste(pattern,collapse = "|"),features[,2],ignore.case = TRUE,value = TRUE)

#####
## CREATE "TEST" DATAFRAME
#####

## Load and subset "test" "set" data
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "\n")
separatedTestSet <- separate(testSet,V1,into=as.character(features$V1),sep=sepSequence)
subsetTestSet <- separatedTestSet[,c(setExtractIndices)]

## create "datasetName" column to
## distinguish between "test" and "train"
## data after they merge
testNrow <- nrow(subsetTestSet)
datasetName <- data.frame(dataset = rep("test",testNrow))

## Load the rest of the "test" data,
## rename variables,
## and merge all three tables into one
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "\n")
names(testSubject) <- "subject"
testLabel <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "\n")
names(testLabel) <- "label"
testDF <- bind_cols(datasetName,testSubject,testLabel,subsetTestSet)

## Remove old vars
rm(datasetName,testSubject,testLabel,subsetTestSet,testNrow)

#####
## CREATE "TRAIN" DATAFRAME
#####

## Load and subset "train" "set" data
trainSet <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "\n")
separatedTrainSet <- separate(trainSet,V1,into=as.character(features$V1),sep=sepSequence)
subsetTrainSet <- separatedTrainSet[,c(setExtractIndices)]

## create "datasetName" column to
## distinguish between "test" and "train"
## data after they merge
trainNrow <- nrow(subsetTrainSet)
datasetName <- data.frame(dataset = rep("train",trainNrow))

## Load the rest of the "test" data,
## rename variables,
## and merge all three tables into one
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "\n")
names(trainSubject) <- "subject"
trainLabel <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "\n")
names(trainLabel) <- "label"
trainDF <- bind_cols(datasetName,trainSubject,trainLabel,subsetTrainSet)

## Remove old vars
rm(datasetName,trainSubject,trainLabel,subsetTrainSet,trainNrow)

#####
## CREATE MERGED DATA FRAME
#####

## Merge data frames and apply
## descriptive activity names
DF <- rbind(testDF,trainDF)
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
activityLabels$V2 <- tolower(activityLabels$V2)
activityLabels$V2 <- gsub("_"," ",activityLabels$V2)
DF <- mutate(DF, label = factor(x=label,labels=c(activityLabels$V2)))

## Melt data and apply
## descriptive measurement names
DF <- melt(DF,id=c("dataset","subject","label"))
DF <- mutate(DF, variable = factor(x=variable,labels=c(setExtractLabels)))

## Separate "variable" column into
## three variable with descriptive labels
DF <- separate(DF,variable,into=c("signal","estimate","direction"),sep="-",fill="right")
DF <- mutate(DF, estimate = factor(ifelse(estimate == "mean()", "mean value", "standard deviation")))

## Rename "label" variable to "activity"
names(DF)[3] <- "activity"
DF$value <- as.numeric(DF$value)

## Export DF into tidy_accelerometer_data.txt
write.table(DF,"./tidy_accelerometer_data.txt",row.name=FALSE)

## Create summary DF by grouping and
## calculating the mean, then export DF
## into tidy_accelerometer_data_averages.txt
groupedDF <- group_by(DF,dataset,subject,activity,signal,estimate,direction)
summarizedDF <- summarize(groupedDF,value=mean(value))
names(summarizedDF)[7] <- "averagevalue"
write.table(summarizedDF,"./tidy_accelerometer_data_averages.txt",row.name=FALSE)

