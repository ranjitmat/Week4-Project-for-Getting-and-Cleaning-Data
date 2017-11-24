# 
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
data_path <- file.path("./data" , "Run_Folder")
data1<-list.files(data_path, recursive=TRUE)
data1

#Read data from the files into the variables
data1ActivityTest  <- read.table(file.path(data_path, "test" , "Y_test.txt" ),header = FALSE)
data1ActivityTrain <- read.table(file.path(data_path, "train", "Y_train.txt"),header = FALSE)

data1SubjectTrain <- read.table(file.path(data_path, "train", "subject_train.txt"),header = FALSE)
data1SubjectTest  <- read.table(file.path(data_path, "test" , "subject_test.txt"),header = FALSE)

data1FeaturesTest  <- read.table(file.path(data_path, "test" , "X_test.txt" ),header = FALSE)
data1FeaturesTrain <- read.table(file.path(data_path, "train", "X_train.txt"),header = FALSE)

#Observe the structure of the variables:
  
str(data1ActivityTest)
str(data1ActivityTrain)
str(data1SubjectTrain)
str(data1SubjectTest)
str(data1FeaturesTrain)
str(data1FeaturesTest)

#Merge the training / test sets to create one data set
#Rbind the datatables by rows:
data1Subject<-rbind(data1SubjectTrain,data1SubjectTest)
data1Activity<-rbind(data1ActivityTrain,data1ActivityTest)
data1Features<-rbind(data1FeaturesTrain,data1FeaturesTest)

#Setting Names to variables
names(data1Subject)<-c("subject")
names(data1Activity)<- c("activity")
data1FeatureNames <- read.table(file.path(data_path, "features.txt"),head=FALSE)
names(data1Features)<- data1FeatureNames$V2

#Merge Cloumns:
data1Combine <- cbind(data1Subject, data1Activity)
Data <- cbind(data1Features, data1Combine) 

#Extract Mean and Standard deviation:
subdata1FeatureNames<-data1FeatureNames$V2[grep("mean\\(\\)|std\\(\\)", data1FeatureNames$V2)]

selectedNames<-c(as.character(subdata1FeatureNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)

#Read descriptive activity names:
activity1Labels <- read.table(file.path(data_path, "activity_labels.txt"),header = FALSE)
head(Data$activity,30)
#Labeling the data set with descriptive variable names
#prefix t is replaced by time, Acc is replaced by Accelerometer, Gyro is replaced by Gyroscope
#prefix f is replaced by frequency, Mag is replaced by Magnitude, BodyBody is replaced by Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

#Creates a second,independent tidy data set and ouput it
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


#Produce Codebook
#library(knitr)
#knit2html("codebook.md")
#purl("codebook.md")