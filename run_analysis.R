#Manually downloaded the data from coursera and unzipped them to my working directory

 library(dplyr)  #will be using dplyr for most following operations
 
#Assigning data frames to variables

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merging Training and Test datasets into one dataset
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
complete_data<- cbind(subject, Y, X)

#extracting the mean and standard deviation for each measurement
complete_data_tidy<- complete_data %>% select(subject, code, contains("mean"), contains("std"))

#naming the activities
complete_data_tidy$code <- activities[complete_data_tidy$code, 2]

#labeling dataset
names(complete_data_tidy)[2] = "activity"
names(complete_data_tidy)<-gsub("Gyro", "Gyroscope", names(complete_data_tidy))
names(complete_data_tidy)<-gsub("BodyBody", "Body", names(complete_data_tidy))
names(complete_data_tidy)<-gsub("Mag", "Magnitude", names(complete_data_tidy))
names(complete_data_tidy)<-gsub("^t", "Time", names(complete_data_tidy))
names(complete_data_tidy)<-gsub("^f", "Frequency", names(complete_data_tidy))
names(complete_data_tidy)<-gsub("tBody", "TimeBody", names(complete_data_tidy))
names(complete_data_tidy)<-gsub("-mean()", "Mean", names(complete_data_tidy), ignore.case = TRUE)
names(complete_data_tidy)<-gsub("-std()", "STD", names(complete_data_tidy), ignore.case = TRUE)
names(complete_data_tidy)<-gsub("-freq()", "Frequency", names(complete_data_tidy), ignore.case = TRUE)
names(complete_data_tidy)<-gsub("angle", "Angle", names(complete_data_tidy))
names(complete_data_tidy)<-gsub("gravity", "Gravity", names(complete_data_tidy))

#create a new data set containing the average of the variables for all activities and subjects
Results <- complete_data_tidy %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Results, "Results.txt", row.name=FALSE)