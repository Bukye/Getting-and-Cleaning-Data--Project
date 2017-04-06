


##Set the working directory
setwd("~/Coursera/UCI HAR Dataset")

##Read Data from test directory files
test_x <- read.table("./test/x_test.txt",header=F)
test_y <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

##Read Data from train directory files
train_x <- read.table("./train/x_train.txt")
train_y <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

##Read Data from activity label file
activity_label <- read.table("./activity_labels.txt")
features <- read.table("./features.txt")


##Assign column names to the different datasets
colnames(activity_label)  = c('activityId','activityType');
colnames(subject_train)  = "subjectId";
colnames(train_x)        = features[,2]; 
colnames(train_y)        = "activityId";

colnames(subject_test) = "subjectId";
colnames(test_x)       = features[,2]; 
colnames(test_y)       = "activityId";

##combine test dataset
TestData = cbind(subject_test,test_y,test_x);

##Combine train dataset
TrainingData = cbind(subject_train,train_y,train_x);

##Merge Train and Test Dataset
allData <- rbind(TrainingData, TestData)

##Filter out variables with mean and STD only
mean_std_features <- (grep("-(mean|std)\\(\\)", features[, 2]))
mean_std_features <- grep(".*-mean().*|.*-std().*", features[,2])

##Use Descriptive Variable names 
mean_std_names <- features[mean_std_features,2]
mean_std_names = gsub('-mean', 'Mean', mean_std_names)
mean_std_names = gsub('-std', 'Std', mean_std_names)
mean_std_names <- gsub('[-()]', '', mean_std_names)

##Get data subset with mean and SD features
allData_subset <- allData[, mean_std_features]


##Assign new column names using the descriptive variables
colnames(allData_subset) <- mean_std_names

##Use descriptive activity names to label the activity in the data set

allData_subset[, 2] <- activity_label[allData_subset[, 2], 2]

##Reshape the dataframes for better aggregation
allData_melted <- melt(allData_subset, id = c("subjectId", "activityId"))

FinalData <- dcast(allData_melted, subjectId + activityId ~ variable, mean)

##Write the finalData dataset to a file
write.table(FinalData, "TidyData.txt", row.names = FALSE, quote = FALSE)

