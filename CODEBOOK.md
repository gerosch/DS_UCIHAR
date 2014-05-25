#  Human Activity Recognition Using Smartphones Dataset (Version 1.0)

## Introduction

This is the CODEBOOK for the script `run_analysis.R` for the Course Project in `Getting and Cleaning Data`. The script reads the data from a local copy of the `UCI HAR Dataset` dataset provided at

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

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

The script combines the data from the provided training and test measurements including activity labels and subject IDs and produces a new dataset by extracting just the measures of mean and standard deviation for the provided 33 direct measurement variables for each observation. It computes a new tidy dataset which contains the average of each of these selected measurement variables for each activity and each subject. The new dataset is written to the file `data/results.csv` in the  current working directory.

Information about the original data can be found in the section `Original source dataset` below.

Information about the script processing can be found in the `README.md` file in this repository.

# Data format of 'results.csv'

This section describes the data contained in the output file `results.csv` of the script `run_analysis.R`. It is a dataset with 180 rows and 66 columns. 

The variables in column 1-66 contain the calculated average values for the mean and standard deviation measurements of the sensor information of a given activity (`activity`) for a given subject (`subjectid`). The variable `activity` contains the type of activity performed by the subject and the variable `subjectid` contains the ID of the subject performing the activity.  

## Data pre-processing of original data

The calculated average values were derived from the provided sensor `accelerometer` and `gyroscope` mean `mean()` and standard deviation `std()` measurements in the original data set for the following signals ('-XYZ' is used to denote 3-axial signals in the X, Y and Z directions):

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

giving a set of 33 mean variables and 33 standard deviation variables. 

These data in this original datset database came from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

In the computed resulting dataset `results.csv` the average of each of these 2 x 33 = 66 sensor measurement variables (always one mean and one standard deviation for a given sensor measurement) is calculated for each subject and each activity performed by this subject, i.e. from all the provided measurements for this specific activity and subject. The result is stored in a new data frame `resultsdata` and written to the file `data/results.csv` with:

      180 rows = 30 subjects x 6 activities per subject
      68  columns = 66 means of 2 x 33 mean/std sensor measurement variables
                    1 activity (type of activity label)
                    1 subjectid (subject ID)

The description of the individual variables in the resulting dataset can be found in the next section.

## Variable description

The variables in the resulting dataset written to the file `data/results.csv` with 180 rows and 68 variables from the `run_analysis.R` script are defined as follows:

      activity: Factor w/ 6 levels - describing one of the 6 activities performed by the subject with 'subjectid'
          "walking"
          "walkingupstairs"
          "walkingdownstairs"
          "sitting"
          "standing"
          "laying"
      
      subjectid: Factor w/ 30 levels - describing the ID of the subject performing the activity 
          "1","2","3","4",..,"30"
    
The following variables represent the calculated `mean` of the selected sensor information for `each subject` and for `each activity` performed by this subject derived from the provided mean (`mean()`) and standard deviation (`std()`) sensor measurement data of the smartphone's `accelerometer` and `gyroscope` in the original data set (for further reference, please refer to section `Original source dataset`):

      Averaged mean() and std() sensor measurement information for each subject and each activity
      Numerical variable
      'mean' denotes that the value is derived from `mean()` sensor measurement value
      'std' denotes that the value is derived from `std()` sensor measurement value
      'X' denotes direction coordinate
      'Y' denotes direction coordinate
      'Z' denotes direction coordinate
      't' prefix denotes time based signal information
      'f' prefix denotes frequency based signal information

      tbodyaccmeanx           : num  
      tbodyaccmeany           : num 
      tbodyaccmeanz           : num 
      
      tbodyaccstdx            : num  
      tbodyaccstdy            : num 
      tbodyaccstdz            : num 
      
      tgravityaccmeanx        : num  
      tgravityaccmeany        : num  
      tgravityaccmeanz        : num  
      
      tgravityaccstdx         : num  
      tgravityaccstdy         : num  
      tgravityaccstdz         : num  
      
      tbodyaccjerkmeanx       : num  
      tbodyaccjerkmeany       : num  
      tbodyaccjerkmeanz       : num  
      
      tbodyaccjerkstdx        : num  
      tbodyaccjerkstdy        : num  
      tbodyaccjerkstdz        : num  
      
      tbodygyromeanx          : num  
      tbodygyromeany          : num  
      tbodygyromeanz          : num  
      
      tbodygyrostdx           : num  
      tbodygyrostdy           : num  
      tbodygyrostdz           : num  
      
      tbodygyrojerkmeanx      : num  
      tbodygyrojerkmeany      : num  
      tbodygyrojerkmeanz      : num  
      
      tbodygyrojerkstdx       : num  
      tbodygyrojerkstdy       : num  
      tbodygyrojerkstdz       : num  
      
      tbodyaccmagmean         : num  
      
      tbodyaccmagstd          : num  
      
      tgravityaccmagmean      : num  
      
      tgravityaccmagstd       : num  
      
      tbodyaccjerkmagmean     : num  
      tbodyaccjerkmagstd      : num  
      
      tbodygyromagmean        : num  
      tbodygyromagstd         : num  
      
      tbodygyrojerkmagmean    : num  
      tbodygyrojerkmagstd     : num  
      
      fbodyaccmeanx           : num  
      fbodyaccmeany           : num  
      fbodyaccmeanz           : num  
      
      fbodyaccstdx            : num 
      fbodyaccstdy            : num
      fbodyaccstdz            : num 
      
      fbodyaccjerkmeanx       : num  
      fbodyaccjerkmeany       : num  
      fbodyaccjerkmeanz       : num  
      
      fbodyaccjerkstdx        : num  
      fbodyaccjerkstdy        : num 
      fbodyaccjerkstdz        : num  
      
      fbodygyromeanx          : num  
      fbodygyromeany          : num  
      fbodygyromeanz          : num  
      
      fbodygyrostdx           : num  
      fbodygyrostdy           : num  
      fbodygyrostdz           : num  
      
      fbodyaccmagmean         : num  
      fbodyaccmagstd          : num  
      
      fbodybodyaccjerkmagmean : num  
      fbodybodyaccjerkmagstd  : num  
      
      fbodybodygyromagmean    : num  
      fbodybodygyromagstd     : num  
      
      fbodybodygyrojerkmagmean: num  
      fbodybodygyrojerkmagstd : num  

  
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

## Original measurement data

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

## Acknowledgement / License of data usage

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


#  DATA DISCLAIMER                            
The original collector of the data (refer to [1])and the author of this project for the course project claim no responsibility  for  uses  of  this collection or for interpretations  or  inferences  based  upon such uses.