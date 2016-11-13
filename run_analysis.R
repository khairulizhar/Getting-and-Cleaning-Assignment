# run dplyr library
library(dplyr)

# Merge the training data sets to create one data set.

xtrain <- read.table(file.path("UCI HAR Dataset","train","X_train.txt"))
ytrain <- read.table(file.path("UCI HAR Dataset","train","y_train.txt"))
subtrain <- read.table(file.path("UCI HAR Dataset","train","subject_train.txt"))

# Merge the test data sets to create one data set.
subtest <- read.table(file.path("UCI HAR Dataset","test","subject_test.txt"))
xtest <- read.table(file.path("UCI HAR Dataset","test","X_test.txt"))
ytest <- read.table(file.path("UCI HAR Dataset","test","y_test.txt"))

# Assigning dtrain, dtest, datatest_datatrain variables.
dtrain <- cbind(subtrain, ytrain, xtrain)
dtest <- cbind(subtest, ytest, xtest)
datatest_datatrain <- rbind(dtrain, dtest)

# Extract only the measurements on the mean and standard deviation for each measurement. 

featureName <- read.table(file.path("UCI HAR Dataset","features.txt"), stringsAsFactors = FALSE)[,2]

featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)

dataFinal <- datatest_datatrain[, c(1, 2, featureIndex+2)]

colnames(dataFinal) <- c("subject", "activity", featureName[featureIndex])


# Uses descriptive activity names to name the activities in the data set


activityName <- read.table(file.path("UCI HAR Dataset","activity_labels.txt"))
dataFinal$activity <- factor(dataFinal$activity, levels = activityName[,1], labels = activityName[,2])

# Appropriately labels the data set with descriptive variable names.

names(dataFinal) <- gsub("\\()", "", names(dataFinal))
names(dataFinal) <- gsub("^t", "time", names(dataFinal))
names(dataFinal) <- gsub("^f", "frequence", names(dataFinal))
names(dataFinal) <- gsub("-mean", "Mean", names(dataFinal))
names(dataFinal) <- gsub("-std", "Std", names(dataFinal))


# From the data set, creates a tidy data set with the average of each variable for each activity and each subject.
dataNew <- dataFinal %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# Output to FinalOutput.txt
write.table(dataNew, file.path("FinalOutput.txt"), row.names = FALSE)
