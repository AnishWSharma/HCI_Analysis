#Note: variable names in this script adhere to Google R Style guide
#https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml

#First things first - check if packages required are installed, if not install and load them
#see http://stackoverflow.com/questions/9341635/how-can-i-check-for-installed-r-packages-before-running-install-packages
current<-getwd()
cat("Current working director - \n",current)
required.packages = c("plyr","dplyr","gmodels","data.table","tidyr")
for (i in required.packages) {
    if(i %in% rownames(installed.packages()) == FALSE) {
        install.packages(i)
    }
    else {
        cat(i,"already installed\n")
    }
}

#load all the packages
#http://stackoverflow.com/questions/8175912/load-multiple-packages-at-once
lapply(required.packages, require, character.only=T)

#remote data file location
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#The following idiom for checking first before creating a folder is from slide 3 of the following course notes
#https://d396qusza40orc.cloudfront.net/getdata/lecture_slides/03_02_summarizingData.pdf
#this will create a folder in the current working location which you can find out using getwd()
local.data.folder<-"UCHI"
if (!file.exists(local.data.folder)) {
    dir.create(local.data.folder)
}

#get remote data and set home folder to where the data is unzipped
dest.file<-paste(local.data.folder,"/UCHI_data.zip",sep="")
if (!file.exists(dest.file)) {
    download.file(file,destfile=dest.file,method="curl")
}
unzip(dest.file)
home<-paste(current,"/UCI HAR Dataset",sep="")
setwd(home)
cat("setting working directory to\n",home)

################
#Step 1 - Merges the training and the test sets to create one data set.
################

#read training and test datasets
x.train<-read.table("train/x_train.txt",header=F)
x.test<-read.table("test/x_test.txt",header=F)

#combine the two using rbind.fill in dplyr package
x.combined<-rbind.fill(x.train,x.test)

#read subject from training dataset
subject.train<-read.table("train/subject_train.txt",header=F)
subject.test<-read.table("test/subject_test.txt",header=F)

#combine the two subjects using rbind.fill from dplyr package
subject.combined<-rbind.fill(subject.train,subject.test)
summary(subject.combined)
#change the column name
setnames(subject.combined,colnames(subject.combined),c("Subject"))
head(subject.combined)

#read activity of training and test dataset
activity.train<-read.table("train/y_train.txt",header=F)
activity.test<-read.table("test/y_test.txt",header=F)
#combine the two
activity.combined<-rbind.fill(activity.train,activity.test)
setnames(activity.combined,colnames(activity.combined),c("Activity"))
nrow(subject.combined)
head(subject.combined)

#Combine _ALL_ data
x.data<-cbind(x.combined,subject.combined,activity.combined)
nrow(x.data)

################
#Step2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
################

#prepare the field names from the features.txt file
#do not read the first column by supplying NULL to colClasses option of read.table
header.fields <- read.table("features.txt",header=F,colClasses=c("NULL","character"),col.names=c("seq","field.name"))

#prepare list of fields that should be kept
header.fields <- c(as.vector(header.fields[,"field.name"]),"Subject","Activity")
#keep only those variables whose name contains either 'mean' or 'std' in their names, plus 'Subject' and 'Activity.id' that we just added
header.select.fields <- grep("mean|std|Subject|Activity",header.fields,value=F)

#filter data based on header names selected
x.data.filtered <- x.data[,header.select.fields,drop=F]

################
#Step 3 - Uses descriptive activity names to name the activities in the data set
################

#get activity labels
activity.labels<-read.table("activity_labels.txt",header=F)
#set the column names in the labels just read
setnames(activity.labels,colnames(activity.labels),c("Activity","Activity.desc"))

#combine the activity  so we get labels instead of numeric codes
#join from plyr package is better; merge reorders which is bad for subsequent steps
x.data.filtered<-join(x.data.filtered,activity.labels)

#get rid of numeric code column for activity since we now have corresponding labels.  Use drop option to preserve data.frame
x.data.filtered<-select(x.data.filtered,-Activity)

################
#Step 4 - Appropriately labels the data set with descriptive variable names. 
################

#replace tBody with timeBody, fBody with frequencyBody, strip out illegal characters
#also replace BodyBody with Body which is a typo in the original dataset
#replace gyro and jerk :-)
header.names<-gsub("^t","time",header.fields)
header.names<-gsub("^f","frequency",header.names)
header.names<-gsub("Acc","Activity",header.names)
header.names<-gsub("Mag","Magnitude",header.names)
header.names<-gsub("\\(|\\)","",header.names)
header.names<-gsub("-","_",header.names)
header.names<-gsub("BodyBody","Body",header.names)
header.names<-gsub("Gyro|Jerk","_",header.names)

#set the names of the columns
setnames(x.data.filtered,colnames(x.data.filtered),header.names[header.select.fields])

################
#Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
################

#At least two different ways of invoking dplyr functions on a given dataset
#the following approach is based on unix pipe and filter approach. 
#Intersting blog here - http://gettinggeneticsdone.blogspot.com/2014/08/do-your-data-janitor-work-like-boss.html
#The '%>%' symbol pipes the output of one function to the next function in chain
#summarise_each loops over the passed data and computes mean of data that is grouped by Subject and Activity; 
#gather function collects the results of individual summarise_each result
tidy.data<-x.data.filtered %>% group_by(Subject,Activity) %>% summarise_each(funs(mean)) %>% gather(measurement, mean, -Activity, -Subject)

# Save the data into the file
write.table(tidy.data, file=paste(home,"/tidy_data.txt",sep=""), row.name=FALSE)
