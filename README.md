# Introduction

This is the README for the script `run_analysis.R` for the Course Project in `Getting and Cleaning Data`. It reads the data from the `UCI HAR Dataset` dataset located in a local directory `data`
in the current working directory. 

The original source dataset used in this project represents data collected from the accelerometers from the Samsung Galaxy S smartphone, derived from experiments with a group of 30 volunteers performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity were captured. The dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. The original dataset includes the following files:

      'README.txt'
      'features_info.txt': Shows information about the variables used on the feature vector.
      'features.txt': List of all features.
      'activity_labels.txt': Links the class labels with their activity name.
      'train/X_train.txt': Training set.
      'train/y_train.txt': Training labels.
      'train/subject_train.txt': Subject IDs
      'test/X_test.txt': Test set.
      'test/y_test.txt': Test labels.
      'test/subject_test.txt': Subject IDs

The script combines the data from the provided training and test measurements including activity labels and subject IDs into one data frame. It creates appropriate variable names and descriptive labels for the activities as well as for the subject IDs.

The script then extracts the measures of mean and standard deviation for the provided 33 direct measurement variables for each observation and computes a new tidy dataset which contains the average of each of these measurement variables for each activity and each subject.

The new dataset is finally written to the file `data/results.csv` in the  current working directory.

Information about the original data can be found in the section `Original source dataset` below.

A detailed explanation of the variables used in the resulting tidy data set can be found in the `CODEBOOK.md` file in this repository.

## Prerequisites

### System requirements

The script has successfully been tested on a Linux system (Ubuntu 14.04) with RStudio Version 0.98.507 and R version 3.1.0. Running the script on other operating systems, especially Windows systems, may require adjustments to file paths used in the script.

### Dataset and required file structure

The `run_analysis.R` script requires the folder `UCI HAR Dataset` of the extracted (unzipped) dataset available at  

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

to be in the current working directory in the directory:

      data

The script does not automatically download and/or extract the data for security purposes. 

The current working directory with the `run_analysis.R` script and the subfolder `data` with the extracted dataset needs to have the following structure and all of the following files for the script to run properly:

      Working directory:
      run_analysis.R
      data/        

      Directory data/:
      UCI HAR Dataset/
      
      Directory data/UCI HAR Dataset/:
      test/
      train/
      features.txt

      Directory data/UCI HAR Dataset/test/:
      subject_test.txt  
      X_test.txt  
      y_test.txt

      Directory data/UCI HAR Dataset/train/:
      subject_train.txt  
      X_train.txt  
      y_train.txt

The path references in the script are written for Unix-like systems with "/" to reference paths.

The required file structure will be obtained by just unzipping the provided zip-archive from the given download link and moving the `UCI HAR Dataset` directory with all the data into the `data` directory of the current working directory where the `run_analysis.R` script resides.

# Script description - Data selection and processing

## Step 1: Combine test and training data

In a first step the script takes the provided original data from the directory `data/UCI HAR Dataset/`

      'train/X_train.txt': Training set.
      'train/y_train.txt': Training labels.
      'train/subject_train.txt': Subject IDs
      'test/X_test.txt': Test set.
      'test/y_test.txt': Test labels.
      'test/subject_test.txt': Subject IDs

and combines the training and test sets into one single dataset of the following structure

      X_train.txt [561 cols] | y_train.txt [1 col] | subject_train.txt [1 col] -> 7352 rows
      X_test.txt  [561 cols] | y_test.txt  [1 col] | subject_test.txt  [1 col] -> 2947 rows  

The first 561 columns contain the features for each measurement. Column 562 contains the coded activity label and column 563 the subject ID of the person who performed the activity.

The combined dataset hasa total of 10299 rows x 563 cols.

## Step 2: Extracting measures of mean and standard deviation for each measurement. 

### Variable names

The features for columns 1-561 are read from the provided file `features.txt` in the original dataset to be used as variable names in the table. The variable names are cleaned by removing ',', '(', ')' and '-' and transformed into lower-case letters. The variable names are assigned to the first 561 colums of the data frame. The column names `activity` and `subjectid` are added for columns 562 and 563, repectively.

### Data Selection for mean and standard deviation

Prior to the cleaning the feature variable names in the previous step a subset of mean `mean()` and standard deviation `std()` features is selected which is directly related to sensor information of the `accelerometer` and `gyroscope` for the measurements involving:

      tBodyAcc-XYZ
      tGravityAcc-XYZ
      tBodyAccJerk-XYZ
      tBodyGyro-XYZ
      tBodyGyroJerk-XYZ
      tBodyAccMag
      tGravityAccMag
      tBodyAccJerkMag
      tBodyGyroMag
      tBodyGyroJerkMag
      fBodyAcc-XYZ
      fBodyAccJerk-XYZ
      fBodyGyro-XYZ
      fBodyAccMag
      fBodyAccJerkMag
      fBodyGyroMag
      fBodyGyroJerkMag

and their index is stored in `indMeanDev` for later reference. This leads to a subset of 33 mean and 33 standard deviation variables for each measurement.

### Subsetting Adding columns 562 (activity) and 563 (subjectid) to list of indices

Using the indices stored in `indMeanDev` for the selected mean and standard deviation variables plus adding columns 562 and 563 for the `activity` and `subjectid` variables, subsetting to this selection gives a new resulting dataset of 10299 rows x 68 cols (2x 33 = 66 cols for mean/std features, 1 col for 'activity', 1 col for 'subjectid').

## Step 3 & 4: Using descriptive activity names and labels in the data set

Using the activity coding provided in `activity_labels.txt` of the original dataset

      1 WALKING
      2 WALKING_UPSTAIRS
      3 WALKING_DOWNSTAIRS
      4 SITTING
      5 STANDING
      6 LAYING

the variable `activity` in the dataset is factorized with levels:

    "walking"
    "walkingupstairs"
    "walkingdownstairs"
    "sitting"
    "standing"
    "laying"

In addition, the variable of the subject ID, called `subjectid`, is also factorized with levels 1 to 30.

## Step 5: Creating a new tidy data set with the average of each variable for each activity and each subject

First, a new empty dataset `resultsdata` is created from the current dataset with the selection of the 66 mean/std feature variables as well as the `activity` and `subjectid` variables. 

To calculate the mean of each of the 2 x 33 = 66 feature variables (always one mean and one standard deviation for a given sensor measurement) for each subject and each activity performed by this subject, a for loop is used across each 'subjectid' with an inner loop across all the activities in 'activity' of this subject calculating the column-mean for each of the activities for this subject. The result is added as a new row to the `resultsdata` data frame. This results in a new data frame `resultsdata` with 180 rows (30 subjects x 6 activities each) and 68 columns (66 mean of measurement variables, 1 activity, 1 subjectid).

Finally, the resulting data frame is written into a file called `data/results.csv` in the current working directory in CSV format and the script stops.

# Original source dataset

The original source dataset used in this project represents data collected from the accelerometers from the Samsung Galaxy S smartphone. The original data is provided by:

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

The data is derived from experiments with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. The dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The activities are coded as follows

      1 WALKING
      2 WALKING_UPSTAIRS
      3 WALKING_DOWNSTAIRS
      4 SITTING
      5 STANDING
      6 LAYING

The persons performing the activities were coded by a subject ID ranging from 1 to 30.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

## Measurement data

For each record it is provided:
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

      tBodyAcc-XYZ
      tGravityAcc-XYZ
      tBodyAccJerk-XYZ
      tBodyGyro-XYZ
      tBodyGyroJerk-XYZ
      tBodyAccMag
      tGravityAccMag
      tBodyAccJerkMag
      tBodyGyroMag
      tBodyGyroJerkMag
      fBodyAcc-XYZ
      fBodyAccJerk-XYZ
      fBodyGyro-XYZ
      fBodyAccMag
      fBodyAccJerkMag
      fBodyGyroMag
      fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

      mean(): Mean value
      std(): Standard deviation
      mad(): Median absolute deviation 
      max(): Largest value in array
      min(): Smallest value in array
      sma(): Signal magnitude area
      energy(): Energy measure. Sum of the squares divided by the number of values. 
      iqr(): Interquartile range 
      entropy(): Signal entropy
      arCoeff(): Autorregresion coefficients with Burg order equal to 4
      correlation(): correlation coefficient between two signals
      maxInds(): index of the frequency component with largest magnitude
      meanFreq(): Weighted average of the frequency components to obtain a mean frequency
      skewness(): skewness of the frequency domain signal 
      kurtosis(): kurtosis of the frequency domain signal 
      bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
      angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

      gravityMean
      tBodyAccMean
      tBodyAccJerkMean
      tBodyGyroMean
      tBodyGyroJerkMean

## Links to original data set 

A full description of the data as well as the original dataset is available at the following website:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The dataset used in this project was taken from the following source:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The original dataset is available at:

http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip


