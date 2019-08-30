library(dplyr)
file <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(file, 'coursera_project.zip',method = 'curl')

features <- read.table("features.txt", col.names = c("n","functions"))
activity_labels <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

Full_X <- rbind(x_test, x_train)
Full_Y <- rbind(y_test, y_train)
Full_subject <- rbind(subject_test, subject_train)

Full_Data <- cbind(Full_X, Full_Y, Full_subject)

colnames <- colnames(Full_Data)
means_stds <-  grepl("subject",colnames) | grepl("code",colnames) | grepl("mean..",colnames) | grepl("std..",colnames)
Full_Data_2 <- Full_Data[, means_stds==TRUE]

Full_Data_3 <- merge(Full_Data_2,activity_labels,by='code')

Full_Data_4 <- Full_Data_3 %>% group_by(activity, subject) %>% summarise_all(funs(mean))

write.table(Full_Data_4, 'Final_Data.txt', row.names=FALSE)
