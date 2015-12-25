# The purpose of this project is to demonstrate your ability to collect, 
# work with, and clean a data set. 
# The goal is to prepare tidy data that can be used for later analysis. 
# You will be graded by your peers on a series of yes/no questions related to the project. 
# You will be required to submit: 
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, 
# and 3) a code book that describes the variables, the data, and any transformations 
# or work that you performed to clean up the data called CodeBook.md. 
# You should also include a README.md in the repo with your scripts. 
# This repo explains how all of the scripts work and how they are connected. 
# 
# One of the most exciting areas in all of data science right now is wearable computing 
# - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing 
# to develop the most advanced algorithms to attract new users. 
# The data linked to from the course website represent data collected from the accelerometers 
# from the Samsung Galaxy S smartphone. A full description is available at the site where 
# the data was obtained: 
#   
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project: 
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

# set working directory
setwd("~/JHU Data Science/3Getting and Cleaning Data/Course Project")

#get the file from the website
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "Dataset.zip")

#unzip
unzip("Dataset.zip")

#open txt files
test <- read.table("./UCI HAR Dataset/test/X_test.txt",stringsAsFactors = FALSE)
train <- read.table("./UCI HAR Dataset/train/X_train.txt",stringsAsFactors = FALSE)

#check the content
summary(test)
str(test)
summary(train)
str(train)


## Merges the training and the test sets to create one data set.

#both files have the same number of variables with different sample size.
#no sample id / key in both files
#to merge the file, it is to concatenate the file using rbind
merged <- rbind(test,train)

#create id column
merged$id <- seq(1,10299,by=1)


## Extracts only the measurements on the mean and standard deviation for each measurement. 

#two different approaches that work
#use psych package to get mean & sd in table format
library(psych)
describe(merged, skew=FALSE,ranges=FALSE)

#use sapply to calculate the mean & sd for each column
as.data.frame( t(sapply(merged, function(cl) list(means=mean(cl,na.rm=TRUE), 
                                              sds=sd(cl,na.rm=TRUE))) ))


## Uses descriptive activity names to name the activities in the data set

# features.txt has the relationship between column names and activity description
features <- read.table("./UCI HAR Dataset/features.txt")
head(features)

# melt / stack the raw data
library(reshape2)
meltMerged <- melt(merged, id="id")

# create variable for join key with features
meltMerged$variableV1 <- as.numeric(substr(meltMerged$variable,2,4))

# merge 
mergedDesc <- merge(meltMerged,features,by.x="variableV1",by.y="V1")
# drop the no longer needed columns
mergedDesc$variableV1 <- NULL
mergedDesc$variable <- NULL
head(mergedDesc)


## Appropriately labels the data set with descriptive variable names. 

# cast
library(reshape)
castMerged <- dcast(mergedDesc, id~V2, mean)
head(castMerged)

## From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
write.table(castMerged, "./tidy.txt", row.names = FALSE)
