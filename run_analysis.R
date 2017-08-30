#add library
library(reshape2)

#Change dir, all files in this dir
setwd("D:/Users/RAHA827I/Documents/R/DATOS_UCI_HAR")

# Se cargan activity labels + features
activity_labels <- read.table("activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Mean and standard deviation
features2 <- grep(".*mean.*|.*std.*", features[,2])
features2.names <- features[features2,2]
features2.names = gsub('-mean', 'Mean', features2.names)
features2.names = gsub('-std', 'Std', features2.names)
features2.names <- gsub('[-()]', '', features2.names)

# Datasets
train <- read.table("X_train.txt")[features2]
Y_train <- read.table("Y_train.txt")
subject_train <- read.table("subject_train.txt")
train <- cbind(subject_train, Y_train, train)


# Se cargan activity labels + features
activity_labels <- read.table("activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Mean and standard deviation
features2 <- grep(".*mean.*|.*std.*", features[,2])
features2.names <- features[features2,2]
features2.names = gsub('-mean', 'Mean', features2.names)
features2.names = gsub('-std', 'Std', features2.names)
features2.names <- gsub('[-()]', '', features2.names)

# Data
train <- read.table("X_train.txt")[features2]
Y_train <- read.table("Y_train.txt")
subject_train <- read.table("subject_train.txt")
train <- cbind(subject_train, Y_train, train)

test <- read.table("X_test.txt")[features2]
testActivities <- read.table("Y_test.txt")
testSubjects <- read.table("subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", features2.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
