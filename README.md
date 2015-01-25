# HCI_Analysis

## Background
This repo contains source code, a readme and a codebook that together support the project for 'Getting and Cleaning Data' course.

## Requirements

The requirements for the course are documented here - 

Briefly, 5 distinct steps are required
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The attached R program supports all of the above requirements.

##Assumptions
Availability of Internet connection

The program makes no assumptions about availability of the data on the local machine.  
As a result, it if you were to execute the program, it will try to download the testdata file remotely.  If you don't have an active Internet connection, this step will fail.  You will have to uncomment the appropriate lines in order to execute the program.

Also, the program _does not_ make any assumptons about availability of required packages. It downloads/installs all package dependencies if they are not available. Again, this requires an Internet connection.

