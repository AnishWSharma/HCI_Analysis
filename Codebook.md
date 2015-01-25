# Codebook

## Background
This document contains details about the tidy data set produced by the accompanying [run_anlaysis.R](run_anlaysis.R) program.

## Details

### Dataset structure   
There are 4 cols.  Their name, count (where appropriate) and a brief description is shown below 
* Subject - 30, Identifier of the human enrolled in the Samsung study, e.g. 1, 2, 3, etc.
* Activity - 6, Different type of activity subjects were performing e.g. LAYING, STTTING, WALKING, etc.
* measurement - 79, Different type of measurements taken while subjects were performing an activity, e.g. timeBodyActivity_mean_X, etc.
* mean - mean value of the measurement

Overall, the tidy data file contains 14220 observations (79*6*30).  

The measurement names were cleaned up by using the following substituions
    header.names<-gsub("^t","time",header.fields)
    header.names<-gsub("^f","frequency",header.names)
    header.names<-gsub("Acc","Activity",header.names)
    header.names<-gsub("Mag","Magnitude",header.names)
    header.names<-gsub("\\(|\\)","",header.names)
    header.names<-gsub("-","_",header.names)
    header.names<-gsub("BodyBody","Body",header.names)
    header.names<-gsub("Gyro|Jerk","_",header.names)



Original study details can be found here - [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](Samsung Study)

### Program (run_analysis.R)
The source code contains detailed comments
