# Codebook

## Background
This document contains details about the tidy data set produced by the accompanying [run_anlaysis.R](run_analysis.R) program.

## Details

### Dataset structure   
There are 4 cols.  Their name, count (where appropriate) and a brief description is shown below 
* Subject - 30, Identifier of the human enrolled in the Samsung study, e.g. 1, 2, 3, etc.
* Activity - 6, Different type of activity subjects were performing e.g. LAYING, STTTING, WALKING, etc.
* measurement - 79, Different type of measurements taken while subjects were performing an activity, e.g. timeBodyActivity_mean_X, etc.
* mean - mean value of the measurement

Overall, the tidy data file contains 14220 observations (79*6*30).  

The measurement names were cleaned up by using the following substitutions -
 ```R
    header.names<-gsub("^t","time",header.fields)
    header.names<-gsub("^f","frequency",header.names)
    header.names<-gsub("Acc","Activity",header.names)
    header.names<-gsub("Mag","Magnitude",header.names)
    header.names<-gsub("\\(|\\)","",header.names)
    header.names<-gsub("-","_",header.names)
    header.names<-gsub("BodyBody","Body",header.names)
    header.names<-gsub("Gyro|Jerk","_",header.names)
```
### Study background
The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. The experiments were video-recorded to label the data manually. The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

More gory details can be found here - [Samsung Human Activity Recognition Study](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

### Program (run_analysis.R)
The source code contains detailed comments about individual steps.  From an approach standpoint, the following additional comments may be of help - 

1. The program does not assume source data mentioned in the assignment is available.   If it is available it is used, otherwise it downloads it from the source location.  This will require an active Internet connection.
2. Once data is available, the approach was to build final dataset one step at a time.  [The project  FAQ](https://class.coursera.org/getdata-010/forum/thread?thread_id=49) posted by David Hood was very helpful/invaluable as it crystallized the required steps in a simple way. In particular, this  [picture](https://coursera-forum-screenshots.s3.amazonaws.com/ab/a2776024af11e4a69d5576f8bc8459/Slide2.png) provides an excellent overview of how to construct the required program and the [attached program](run_analysis.R) followed this picture closely.
3. I choose to use rbind.fill because it is much faster than rbind.  For this assignment, it was probably an overkill.  But at the small cost of using an external library (plyr), it allowed me to insert a reminder for myself to continue to use it because often I have to process files that have 30-35 Millon observations.
4. There may be more efficient/elegant ways to process the data but my goal was first and foremost to complete the assignment without creating an embarassing gotchas :-) Now you be the judge!
