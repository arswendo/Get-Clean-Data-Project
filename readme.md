1. Getting the data
# set working directory

#get the file from the website

#unzip

#open txt files


2. Merges the training and the test sets to create one data set.

#both files have the same number of variables with different sample size.
#no sample id / key in both files
#to merge the file, it is to concatenate the file using rbind



3. Extracts only the measurements on the mean and standard deviation for each measurement. 

#two different approaches that work
#use psych package to get mean & sd in table format
library(psych)
describe(merged, skew=FALSE,ranges=FALSE)

#use sapply to calculate the mean & sd for each column
as.data.frame( t(sapply(merged, function(cl) list(means=mean(cl,na.rm=TRUE), 
                                              sds=sd(cl,na.rm=TRUE))) ))


4. Uses descriptive activity names to name the activities in the data set

# features.txt has the relationship between column names and activity description

# melt / stack the raw data

# create variable for join key with features

# merge 

# drop the no longer needed columns


5. Appropriately labels the data set with descriptive variable names. 

# cast

6. From the data set in step 4, creates a second, independent tidy data set 




