
# Created R script called run_analysis.R that does the following.
# 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#Download the file and put the file in the data folder and unzip the file

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
              download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Get the list of the files
data_path <- file.path("./data" , "UCI HAR Dataset")
data1<-list.files(data_path, recursive=TRUE)
data1

#Read the Train data
dataFeaturesTrain <- read.table(file.path(data_path, "train", "X_train.txt"),header = FALSE)
dataActivityTrain <- read.table(file.path(data_path, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(data_path, "train", "subject_train.txt"),header = FALSE)

#Read the Test data
dataFeaturesTest  <- read.table(file.path(data_path, "test" , "X_test.txt" ),header = FALSE)
dataActivityTest  <- read.table(file.path(data_path, "test" , "Y_test.txt" ),header = FALSE)
dataSubjectTest  <- read.table(file.path(data_path, "test" , "subject_test.txt"),header = FALSE)


#Observe the structure of the variables:
  
#str(dataFeaturesTest)
#str(dataActivityTrain)
#str(dataSubjectTrain)
#str(dataSubjectTest)
#str(dataFeaturesTrain)
#str(dataFeaturesTest)


# read data description
feature_names <- read.table("./data/UCI HAR Dataset/features.txt")

# read activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
#Rbind the datatables by rows:
dataFeaturesTotal<-rbind(dataFeaturesTrain,dataFeaturesTest)
dataActivityTotal<-rbind(data1ActivityTrain,data1ActivityTest)
dataSubjectTotal<-rbind(dataSubjectTrain,dataSubjectTest)

# 2. Extracts only the measurements on the mean and standard deviation.
selected_feature <- feature_names[grep("mean\\(\\)|std\\(\\)",feature_names[,2]),]
dataFeaturesTotal <- dataFeaturesTotal[,selected_feature[,1]]
#----------------------------------
# 3. Uses descriptive activity names to name the activities in the data set
colnames(dataActivityTotal) <- "activity"
dataActivityTotal$activitylabels <- factor(dataActivityTotal$activity, labels = as.character(activity_labels[,2]))
activitylabel <- dataActivityTotal[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(dataFeaturesTotal) <- variable_names[selected_feature[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
colnames(dataSubjectTotal) <- "subject"
total <- cbind(dataFeaturesTotal, activitylabel, dataSubjectTotal)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./data/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

