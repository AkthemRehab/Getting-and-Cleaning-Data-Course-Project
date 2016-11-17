#You should create one R script called run_analysis.R that does the following:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set.
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Please note that you will need to change the path in all setwd() commands to mach the path of your "UCI HAR Dataset" folder

##Reading activity labels and features data
setwd("C:/Users/T430s/Documents/R/DS Coursera/Data/Wk4/UCI HAR Dataset")
activitylabels<-read.table("activity_labels.txt",header = FALSE)
features<-read.table("features.txt", header = FALSE)

##Filtering the mean and standard deviation column headers
neededheaders<-grepl("mean|std", features[,2])

##Reading the training data
setwd("C:/Users/T430s/Documents/R/DS Coursera/Data/Wk4/UCI HAR Dataset/train")
xtraindata<-read.table("X_train.txt", header = FALSE)
ytraindata<-read.table("y_train.txt", header = FALSE)
subjecttrain<-read.table("subject_train.txt", header = FALSE)
subjecttrain<-as.data.table(subjecttrain)
colnames(xtraindata)=features[,2] ##Appropriately labeling the data set with descriptive variable names
xtraindata=xtraindata[,neededheaders] ##Extracting measurements on the mean and standard deviation for each measurement
ytraindata<-merge(ytraindata,activitylabels,by.x="V1",by.y="V1",sort = FALSE,all.x = TRUE) ##Using descriptive activity names to name the activities in the data set
colnames(ytraindata)=c("activityid", "activitylabel") ##Appropriately labeling the data set with descriptive variable names
colnames(subjecttrain) = "subject" ##Appropriately labeling the data set with descriptive variable names
traindata <- cbind(subjecttrain, ytraindata, xtraindata) ##Gathering all train data in one data set

##Reading the test data
setwd("C:/Users/T430s/Documents/R/DS Coursera/Data/Wk4/UCI HAR Dataset/test")
xtestdata<-read.table("X_test.txt", header = FALSE)
ytestdata<-read.table("y_test.txt", header = FALSE)
subjecttest<-read.table("subject_test.txt", header = FALSE)
subjecttest<-as.data.table(subjecttest)
colnames(xtestdata)=features[,2] ##Appropriately labeling the data set with descriptive variable names
xtestdata=xtestdata[,neededheaders] ##Extracting measurements on the mean and standard deviation for each measurement
ytestdata<-merge(ytestdata,activitylabels,by.x="V1",by.y="V1",sort = FALSE,all.x = TRUE) ##Using descriptive activity names to name the activities in the data set
colnames(ytestdata)=c("activityid", "activitylabel") ##Appropriately labeling the data set with descriptive variable names
colnames(subjecttest) = "subject" ##Appropriately labeling the data set with descriptive variable names
testdata <- cbind(subjecttest, ytestdata, xtestdata) ##Gathering all test data in one data set

## Bind train and test data
mergeData<-rbind(traindata,testdata)


idlabels <- c("subject", "activityid", "activitylabel")
datalabels <- colnames(mergeData)[!(colnames(mergeData)%in%idlabels)]
## Melt the data by subject and activity
meltdata <- melt(mergeData, id = idlabels, measure.vars=datalabels)

## Apply mean function to dataset using dcast function
tidydata = dcast(meltdata, subject + activitylabel ~ variable, mean)

## Print the tidydata
setwd("C:/Users/T430s/Documents/R/DS Coursera/Data/Wk4/UCI HAR Dataset")
write.table(tidydata, file = "./tidydata.txt")