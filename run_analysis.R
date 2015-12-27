#  run_analysis.R
#The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. 
#The goal is to prepare tidy data that can be used for later analysis. 

library("data.table")
library("reshape2")

#Downlading and unziping data

Url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
File<-file.path(getwd(),"getdata_dataset.zip")
download.file(Url,File)
unzip("getdata_dataset.zip")

#Loading Data  into R
X_test  <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test  <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

Activity_Labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
Features <- read.table("./UCI HAR Dataset/features.txt")[,2]
Subject_Test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
Subject_Train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Q1&2- Merging the training and the test sets to create one data set. For the extracted measurements 
Extracted_Features <- grepl("mean|std", Features)
names(X_test) = Features 
names(X_train) = Features

X_test = X_test[,Extracted_Features]
X_train = X_train[,Extracted_Features]
Y_test[,2] = Activity_Labels[Y_test[,1]]
Y_train[,2] = Activity_Labels[Y_train[,1]]

names(Y_test) = c("Activity_ID", "Activity_Label")
names(Y_train) = c("Activity_ID", "Activity_Label")
names(Subject_Test) = "subject"
names(Subject_Train) = "subject"

Test_Data <- cbind(as.data.table(Subject_Test), Y_test, X_test)
Train_Data <- cbind(as.data.table(Subject_Train),Y_train, X_train)
AllData = rbind(Test_Data, Train_Data)

#Q3&4 Uses descriptive activity names to name the activities in the data set & Appropriately labels the data set with descriptive variable names. 
Id_Labels   = c("subject", "Activity_ID", "Activity_Label")
Labeled_Data = setdiff(colnames(AllData), Id_Labels)
Data   = melt(AllData, id = Id_Labels, measure.vars = Labeled_Data)

#Q5 Creates a second, independent tidy data set with the average of each variable for each activity and each #subject.
tidy_data   = dcast(Data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")

FinalResult  <- read.table("./tidy_data.txt")
