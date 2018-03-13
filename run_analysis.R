fullFile <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",fullFile)
unzip(fullFile, list = TRUE) 

y_test <- read.table(unzip(fullFile, "UCI HAR Dataset/test/y_test.txt"))
x_test <- read.table(unzip(fullFile, "UCI HAR Dataset/test/X_test.txt"))
SubTest <- read.table(unzip(fullFile, "UCI HAR Dataset/test/subject_test.txt"))
y_train <- read.table(unzip(fullFile, "UCI HAR Dataset/train/y_train.txt"))
x_train <- read.table(unzip(fullFile, "UCI HAR Dataset/train/X_train.txt"))
SubTrain <- read.table(unzip(fullFile, "UCI HAR Dataset/train/subject_train.txt"))
feature <- read.table(unzip(fullFile, "UCI HAR Dataset/features.txt"))
unlink(fullFile)

colnames(x_train) <- t(feature[2])
colnames(x_test) <- t(feature[2])

x_train$activities <- y_train[, 1]
x_train$participants <- SubTrain[, 1]
x_test$activities <- y_test[, 1]
x_test$participants <- SubTest[, 1]

## Merges the training and the test sets to create one data set.
MainData <- rbind(x_train, x_test)
duplicated(colnames(MainData))
MainData <- MainData[, !duplicated(colnames(MainData))]

## Extracts only the measurements on the mean and standard deviation for each measurement
MeanData <- grep("mean()", names(MainData), value = FALSE, fixed = TRUE)
MeanData <- append(MeanData, 471:477)
InstrumentMean <- MainData[MeanData]
STD <- grep("std()", names(MainData), value = FALSE)
InstrumentSTD <- MainData[STD]

## Uses descriptive activity names to name the activities in the data set
MainData$activities <- as.character(MainData$activities)
MainData$activities[MainData$activities == 1] <- "Walking"
MainData$activities[MainData$activities == 2] <- "Walking Upstairs"
MainData$activities[MainData$activities == 3] <- "Walking Downstairs"
MainData$activities[MainData$activities == 4] <- "Sitting"
MainData$activities[MainData$activities == 5] <- "Standing"
MainData$activities[MainData$activities == 6] <- "Laying"
MainData$activities <- as.factor(MainData$activities)

## Appropriately labels the data set with descriptive variable names.
names(MainData) <- gsub("Acc", "Accelerator", names(MainData))
names(MainData) <- gsub("Mag", "Magnitude", names(MainData))
names(MainData) <- gsub("Gyro", "Gyroscope", names(MainData))
names(MainData) <- gsub("^t", "time", names(MainData))
names(MainData) <- gsub("^f", "frequency", names(MainData))

MainData$participants <- as.character(MainData$participants)
MainData$participants[MainData$participants == 1] <- "Participant 1"
MainData$participants[MainData$participants == 2] <- "Participant 2"
MainData$participants[MainData$participants == 3] <- "Participant 3"
MainData$participants[MainData$participants == 4] <- "Participant 4"
MainData$participants[MainData$participants == 5] <- "Participant 5"
MainData$participants[MainData$participants == 6] <- "Participant 6"
MainData$participants[MainData$participants == 7] <- "Participant 7"
MainData$participants[MainData$participants == 8] <- "Participant 8"
MainData$participants[MainData$participants == 9] <- "Participant 9"
MainData$participants[MainData$participants == 10] <- "Participant 10"
MainData$participants[MainData$participants == 11] <- "Participant 11"
MainData$participants[MainData$participants == 12] <- "Participant 12"
MainData$participants[MainData$participants == 13] <- "Participant 13"
MainData$participants[MainData$participants == 14] <- "Participant 14"
MainData$participants[MainData$participants == 15] <- "Participant 15"
MainData$participants[MainData$participants == 16] <- "Participant 16"
MainData$participants[MainData$participants == 17] <- "Participant 17"
MainData$participants[MainData$participants == 18] <- "Participant 18"
MainData$participants[MainData$participants == 19] <- "Participant 19"
MainData$participants[MainData$participants == 20] <- "Participant 20"
MainData$participants[MainData$participants == 21] <- "Participant 21"
MainData$participants[MainData$participants == 22] <- "Participant 22"
MainData$participants[MainData$participants == 23] <- "Participant 23"
MainData$participants[MainData$participants == 24] <- "Participant 24"
MainData$participants[MainData$participants == 25] <- "Participant 25"
MainData$participants[MainData$participants == 26] <- "Participant 26"
MainData$participants[MainData$participants == 27] <- "Participant 27"
MainData$participants[MainData$participants == 28] <- "Participant 28"
MainData$participants[MainData$participants == 29] <- "Participant 29"
MainData$participants[MainData$participants == 30] <- "Participant 30"
MainData$participants <- as.factor(MainData$participants)


## Create a tidy data set

InterimData <- data.table(MainData)
Tidy <- InterimData[, lapply(.SD, mean), by = 'participants,activities']
write.table(Tidy, file = "Final.txt", row.names = FALSE)


