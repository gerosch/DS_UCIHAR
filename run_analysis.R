###############################################################################
## Coursera Course: 03 Getting and Cleaning Data                             ##
## Course Project                                                            ##
###############################################################################
## R ##### Author: Gero Schmidt ###### Version: 1.00 ###### Date: 2014-05-25 ##
###############################################################################
## Script: run_analysis.R                                                    ##
## -----------------------                                                   ##
## This is the script for the Course Project in <Getting and Cleaning Data>. ##
## It reads the data from the <UCI HAR Dataset> dataset located in a <data>  ##
## directory of the current working directory. The script combines the       ##
## data from the training and test measurements including activity labels    ##
## and subject IDs into one data frame. It creates appropriate variable      ##
## names and descriptive labels for the factor variable activity as well     ##
## as for the subjectid variable.                                            ##
## The script then extracts the measures of mean and standard deviation for  ##
## the provided 33 direct measurement variables for each observation and     ##
## computes a new tidy dataset which contains the average of each of these   ##
## measurement variables for each activity and each subject.                 ##
## The new dataset is finally written to the file <data/results.csv> in the  ##
## current working directory.                                                ##
###############################################################################
## Disclaimer: The sample code described herein is provided on an "as is"    ##
## basis, without warranty of any kind. The author does not warrant,         ##
## guarantee or make any representations regarding the use, results of use,  ##
## accuracy, timeliness or completeness of any data or information relating  ##
## to this code. The author disclaims all warranties, express or implied,    ##
## and in particular, disclaims all warranties of merchantability, fitness   ##
## for a particular purpose, and warranties related to the code, or any      ##
## service or software related thereto. The author shall not be liable for   ##
## any direct, indirect or consequential damages or costs of any type        ##
## arising out of any action taken by you or others related to this code.    ##
###############################################################################

## -----------------------------------------
## Check if all required files are available
## -----------------------------------------

### check for data directory and all required files

ALL_FOUND<-TRUE

if (!file.exists("data/UCI HAR Dataset/test/X_test.txt")) {
  message("File <data/UCI HAR Dataset/test/X_test.txt> not found in local directory.")
  ALL_FOUND<-FALSE
}
if (!file.exists("data/UCI HAR Dataset/test/y_test.txt")) {
  message("File <data/UCI HAR Dataset/test/y_test.txt> not found in local directory.")  
  ALL_FOUND<-FALSE
}
if (!file.exists("data/UCI HAR Dataset/test/subject_test.txt")) {
  message("File <data/UCI HAR Dataset/test/subject_test.txt> not found in local directory.")  
  ALL_FOUND<-FALSE
}
if (!file.exists("data/UCI HAR Dataset/train/X_train.txt")) {
  message("File <data/UCI HAR Dataset/train/X_train.txt> not found in local directory.")  
  ALL_FOUND<-FALSE
}
if (!file.exists("data/UCI HAR Dataset/train/y_train.txt")) {
  message("File <data/UCI HAR Dataset/train/y_train.txt> not found in local directory.")  
  ALL_FOUND<-FALSE
}
if (!file.exists("data/UCI HAR Dataset/train/subject_train.txt")) {
  message("File <data/UCI HAR Dataset/train/subject_train.txt> not found in local directory.")  
  ALL_FOUND<-FALSE
} 
if (!file.exists("data/UCI HAR Dataset/features.txt")) {
  message("File <data/UCI HAR Dataset/features.txt> not found in local directory.")  
  ALL_FOUND<-FALSE
} 
if (ALL_FOUND==FALSE) {  
  message("Not all required files for the dataset were found in the local directory.")
  message("Please provide required files in requested location in your working directory.")
  message("Execution of script aborted...")
} else {
  message("OK, found all required data files and will start processing the data...")
}

## Stop if not all files have been found
stopifnot(ALL_FOUND)


## ------
## PART 1
## ------
## 1. Merges the training and the test sets to create one data set.

## --------------------------------
## Read and merge original datasets
## --------------------------------
## New dataset has the following structure
## X_train.txt [561 cols] | y_train.txt [1 col] | subject_train.txt [1 col] -> 7352 rows
## X_test.txt  [561 cols] | y_test.txt  [1 col] | subject_test.txt  [1 col] -> 2947 rows  
## Total; 10299 rows x 563 cols
message("Now reading and merging the whole dataset (task 1).")
message("Please hold on and be patient... This may take a while...")
dataset=rbind(cbind(read.table("data/UCI HAR Dataset/train/X_train.txt", comment.char=""),
                    read.table("data/UCI HAR Dataset/train/y_train.txt", comment.char=""),
                    read.table("data/UCI HAR Dataset/train/subject_train.txt", comment.char="")),
              cbind(read.table("data/UCI HAR Dataset/test/X_test.txt", comment.char=""),
                    read.table("data/UCI HAR Dataset/test/y_test.txt", comment.char=""),
                    read.table("data/UCI HAR Dataset/test/subject_test.txt", comment.char="")))

print(sprintf("Success: Reading complete dataset of dimension %s.",toString(dim(dataset))))


## ------
## PART 2
## ------
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

## Selecting and creating clean variable names for the dataset first

message("Now creating clean names for the feature, activity and subject variables...")

## Read variable names for feature columns 1-561
features<-read.table("data/UCI HAR Dataset/features.txt", comment.char="",colClasses = "character")[2]
features<-features[,1]

## Get indices for 33 measures of mean() and std() from the direct measurements
indMeanDev<-sort(c(grep("std\\(",features,value=FALSE),grep("mean\\(",features,value=FALSE)))

## Clean variable names for feature columns 1-561 by removing "(",")",",","-"
features<-gsub("-","",features)
features<-gsub('\\(',"",features)
features<-gsub('\\)',"",features)
features<-gsub(",","",features)
features<-tolower(features)

## Assign variable names to columns 1-561
names(dataset)[1:561]<-features

## Properly name activity (y_test/train.txt) and subject (subject_test/train.txt) variable in dataset
names(dataset)[562]<-"activity"
names(dataset)[563]<-"subjectid"

print("Success: Creating names for all variables in original dataset according to lecture rules:")
print(names(dataset))

## Reducing dataset to measures of mean and standard deviation for each measurement

message("Now reducing the dataset to 33 measures of mean() and std() from the direct measurements (task 2)")

## Adding columns 562 (activity) and 563 (subjectid) to list of indices
indMeanDev<-c(indMeanDev,562,563)

## Subsetting to mean and std and adding columns 562 (activity) and 563 (subjectid) to list of indices
dataset<-dataset[,indMeanDev]

print("Success: Reducing dataset to measurement mean(), std(), activity and subjectid variables:")
print(dim(dataset))
print(names(dataset))

## ----------
## PART 3 & 4
## ----------
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names. 

## Activity label coding according to "activity_labels.txt"
## 1 WALKING
## 2 WALKING_UPSTAIRS
## 3 WALKING_DOWNSTAIRS
## 4 SITTING
## 5 STANDING
## 6 LAYING

message("Creating descriptive labels for activity names in dataset (tasks 3 & 4)")

## Create factors and labels for activity and subject variables
dataset$activity  <-factor(dataset$activity,levels=c("1","2","3","4","5","6"),labels=c("walking","walkingupstairs","walkingdownstairs","sitting","standing","laying"))
dataset$subjectid <-factor(dataset$subjectid,levels=1:30)

print("Success: Created labels for variable <activity> in dataset:")
print("Levels:")
print(levels(dataset$activity))
print("10 first entries in dataset:")
print(head(dataset$activity,10))
print("Summary:")
print(summary(dataset$activity))

print("Success: Created labels for variable <subjectid> in dataset:")
print("Levels:")
print(levels(dataset$subjectid))
print("10 first entries in dataset:")
print(head(dataset$subjectid,10))
print("Summary:")
print(summary(dataset$subjectid))


## ------
## PART 5
## ------
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

message("Computing new dataset with the average of each variable for each activity and each subject (task 5)")

## Create a new empty dataset <resultsdata> from existing dataset with all columns but no rows
resultsdata<-dataset[0,]

## Compute means for every variable for each subject and activity in new datset <resultsdata>
count<-1
for (subid in levels(dataset$subjectid)){
  for (actid in levels(dataset$activity)){
    ## Get subset for selected subjectid <subid> and activity <actid>
    subdat=subset(dataset, dataset$subjectid==subid & dataset$activity==actid)
    ## Compute means for measurement variables for selected activity and subjectid
    submeans<-colMeans(subdat[,1:66])
    ## Enter new row with means to result dataset
    resultsdata[count,1:66]<-submeans
    resultsdata[count,67]<-actid
    resultsdata[count,68]<-subid
    count=count+1
  }
}

print("Success: New dataset with averages for all mean/std variables for each activity and each subject created.")
print("Specs of new dataset:")
print(str(resultsdata,vec.len=1))

## Write new dataset into csv file      
write.csv(resultsdata, file="data/results.csv",row.names=FALSE,quote=TRUE)

message("The resulting dataset has been written into file <data/results.csv>")

## End script
message("Processing of given dataset successfully finished. Thanks for your patience :-)")