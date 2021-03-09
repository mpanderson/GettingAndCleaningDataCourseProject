

#load necessary libraries
library(dplyr)
library(RCurl)
library(stringr)
getwd()

#create directory to store the data
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download data: files takes a few minutes to download
download.file(fileUrl,destfile=".\\data\\phone.zip",method="curl")
list.files(".\\data")

#list files without unzipping
unzip(".\\data\\phone.zip",list=T)

#unzip files extracting to the "data" folder
unzip(".\\data\\phone.zip",exdir=".\\data",list=F)

#set directory for the session to find the files
setwd("./data")
setwd("./UCI HAR Dataset")


#read in data and created column labels
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
subject_train <- read.table("train/subject_train.txt",col.names= "subject")
features <- read.table("features.txt",col.names = c("n","signal"))
activity_labels <- read.table("activity_labels.txt",col.names = c("label", "activity"))
x_test <- read.table("test/X_test.txt",col.names = features$signal)
x_train <- read.table("train/x_train.txt",col.names= features$signal)
y_test <- read.table("test/y_test.txt",col.names = "label")
y_train <- read.table("train/y_train.txt",col.names="label")

#Inertail Signals if needed

body_acc_x_test <- read.table("test\\Inertial Signals\\body_acc_x_test.txt")
body_acc_y_test <- read.table("test\\Inertial Signals\\body_acc_y_test.txt")
body_acc_z_test <- read.table("test\\Inertial Signals\\body_acc_z_test.txt")
body_gyro_x_test <- read.table("test\\Inertial Signals\\body_gyro_x_test.txt")
body_gyro_y_test <- read.table("test\\Inertial Signals\\body_gyro_y_test.txt")
body_gyro_z_test <- read.table("test\\Inertial Signals\\body_gyro_z_test.txt")
total_acc_x_test <- read.table("test\\Inertial Signals\\total_acc_x_test.txt")
total_acc_y_test <- read.table("test\\Inertial Signals\\total_acc_y_test.txt")
total_acc_z_test <- read.table("test\\Inertial Signals\\total_acc_z_test.txt")
body_acc_x_train <- read.table("train\\Inertial Signals\\body_acc_x_train.txt")
body_acc_y_train <- read.table("train\\Inertial Signals\\body_acc_y_train.txt")
body_acc_z_train <- read.table("train\\Inertial Signals\\body_acc_z_train.txt")
body_gyro_x_train <- read.table("train\\Inertial Signals\\body_gyro_x_train.txt")
body_gyro_y_train <- read.table("train\\Inertial Signals\\body_gyro_y_train.txt")
body_gyro_z_train <- read.table("train\\Inertial Signals\\body_gyro_z_train.txt")
total_acc_x_train <- read.table("train\\Inertial Signals\\total_acc_x_train.txt")
total_acc_y_train <- read.table("train\\Inertial Signals\\total_acc_y_train.txt")
total_acc_z_train <- read.table("train\\Inertial Signals\\total_acc_z_train.txt")

#Merge the training and test data
test.dat <- cbind(subject_test,y_test,x_test)
train.dat <- cbind(subject_train,y_train,x_train)
comb <- rbind(test.dat,train.dat)

#look at the names 
names(comb)

#select only those with mean and std in the title
comb.mean.std<-comb[,which(str_count(names(comb),"mean|std|subject|label")==1)]


#Add descriptive activity label rather than number
comb.mean.std$label<-activity_labels[comb.mean.std$label,2]


#use metacharacters to give more appropirate names to variables
names(comb.mean.std)<-gsub("label","Activity",names(comb.mean.std))
names(comb.mean.std)<-gsub("^t","Time ",names(comb.mean.std))
names(comb.mean.std)<-gsub("^f","Frequency ",names(comb.mean.std))
names(comb.mean.std)<-gsub("Acc"," Acceleration ",names(comb.mean.std))
names(comb.mean.std)<-gsub("Gyro"," Gyroscope ",names(comb.mean.std))
names(comb.mean.std)<-gsub(".mean...","Mean ",names(comb.mean.std))
names(comb.mean.std)<-gsub(".std...","Standard Deviation ",names(comb.mean.std))
names(comb.mean.std)<-gsub("Jerk","Jerk ",names(comb.mean.std))
names(comb.mean.std)<-gsub("Mag","Magnitude ",names(comb.mean.std))
names(comb.mean.std)<-gsub("BodyBody","Body",names(comb.mean.std))
names(comb.mean.std)<-gsub(".mean..","Mean",names(comb.mean.std))
names(comb.mean.std)<-gsub(".std..","Standard Deviation",names(comb.mean.std))
 

#Create additiona data set that is the mean of each varaible by subject by activity
add.tidy.data<-comb.mean.std %>% group_by(subject,Activity) %>% summarize_all(mean)

#have a look at the structs of each created data set 
str(comb.mean.std)
str(add.tidy.data)
