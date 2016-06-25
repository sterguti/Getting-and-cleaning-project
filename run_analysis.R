library(dplyr)
library(tidyr)

filename <- "getdata_dataset.zip"
dir <- "./UCI HAR Dataset/"
## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


# Step 1
# Merge the training and test sets to create one data set
######################################################################################

# Load activity labels + features
x_train <- read.table(paste(dir,"train/X_train.txt", sep=""))
y_train <- read.table(paste(dir,"train/y_train.txt",sep=""))
subject_train <- read.table(paste(dir,"train/subject_train.txt",sep=""))

x_test <- read.table(paste(dir, "test/X_test.txt",sep=""))
y_test <- read.table(paste(dir, "test/y_test.txt", sep=""))
subject_test <- read.table(paste(dir, "test/subject_test.txt",sep=""))

# create 'x', 'y' and 'subject' data set
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
y_data_p <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Step 2
#Extracts only the measurements on the mean and standard deviation for each measurement.
########################################################################################

features <- read.table(paste(dir, "features.txt", sep=""))

# get only columns with mean() or std() in their names

mandstd_features <- grep("-(mean|std).*", features[, 2])
#mandstd_features <- grep(".*mean.*|.*std.*", features[,2])

# subset the desired columns
x_data <- x_data[, mandstd_features]

# correct the column names
names(x_data) <- features[mandstd_features, 2]


# Step 3
#3.  Uses descriptive activity names to name the activities in the data set 
########################################################################################

labels <- read.table(paste(dir, "activity_labels.txt", sep=""))

y_data[, 1]
y_data[, 1] <- labels[y_data[, 1], 2]



# Step 4
#Appropriately labels the data set with descriptive variable names.
########################################################################################

names(y_data) <- "activity"
names(subject_data) <- "Subject"

all_data <- cbind(x_data, y_data, subject_data)


# Step 5
#From the data set in step 4, creates a second, independent tidy data set with the average
#of each variable for each activity and each subject.
#######################################################################################


new_data<- aggregate(. ~ Subject - activity, data = all_data, mean) 
a_data<- tbl_df(arrange(dataAggr,Subject,activity))

# Export the tidyData set 
write.table(a_data, './av_data.txt',row.names=TRUE,sep='\t')



