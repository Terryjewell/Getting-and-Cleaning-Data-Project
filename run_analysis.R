# Load libraries
library(plyr)
library(dplyr)

# Clear all previous data
rm(list=ls())

# DATA HANDLING=========================================================================================
# Set source directory and files
DataDir <- "~/R/Getting and Cleaning Data Course Project" #data directory
FeatureFile <-          paste(DataDir, "/features.txt", sep = "") 
ActivityLabelsFile <-   paste(DataDir, "/activity_labels.txt", sep = "")
X_TrainFile <-          paste(DataDir, "/train/X_train.txt", sep = "")
Y_TrainFile <-          paste(DataDir, "/train/y_train.txt", sep = "")
SubjectTrainFile <-     paste(DataDir, "/train/subject_train.txt", sep = "")
X_TestFile  <-          paste(DataDir, "/test/X_test.txt", sep = "")
Y_TestFile  <-          paste(DataDir, "/test/y_test.txt", sep = "")
SubjectTestFile <-      paste(DataDir, "/test/subject_test.txt", sep = "")

# Read in data files
FeaturesData <-         read.table(FeatureFile, colClasses = c("character"))
ActivityLabels <-       read.table(ActivityLabelsFile, col.names = c("ActivityId", "Activity"))
X_TrainData <-          read.table(X_TrainFile)
Y_TrainData <-          read.table(Y_TrainFile)
SubjectTrainData <-     read.table(SubjectTrainFile)
X_TestData <-           read.table(X_TestFile)
Y_TestData <-           read.table(Y_TestFile)
SubjectTestData <-      read.table(SubjectTestFile)


# Merge test and training data sets======================================================================

# Merge data
TrainDataBind <-        cbind(cbind(X_TrainData, SubjectTrainData), Y_TrainData)
TestDataBind <-         cbind(cbind(X_TestData, SubjectTestData), Y_TestData)
MainSensorData <-       rbind(TrainDataBind, TestDataBind)

# Add labels to sensor data
SensorDataLabels <-     rbind(rbind(FeaturesData, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(MainSensorData) <- SensorDataLabels

# Subset average and std. dev. for sensor data set========================================================

SensorDataStats <- MainSensorData[,grepl("mean|std|Subject|ActivityId", names(MainSensorData))]

# Add desciptive labels and clean up data set=============================================================
SensorDataStats <- join(SensorDataStats, ActivityLabels, by = "ActivityId", match = "first")
SensorDataStats <- SensorDataStats[,-1]

names(SensorDataStats) <- gsub('\\(|\\)',"",names(SensorDataStats), perl = TRUE) # Remove parentheses

# Clean up names
names(SensorDataStats) <- make.names(names(SensorDataStats)) 
names(SensorDataStats) <- gsub('Acc',"Acceleration",names(SensorDataStats))
names(SensorDataStats) <- gsub('GyroJerk',"AngularAcceleration",names(SensorDataStats))
names(SensorDataStats) <- gsub('Gyro',"AngularSpeed",names(SensorDataStats))
names(SensorDataStats) <- gsub('Mag',"Magnitude",names(SensorDataStats))
names(SensorDataStats) <- gsub('^t',"TimeDomain.",names(SensorDataStats))
names(SensorDataStats) <- gsub('^f',"FrequencyDomain.",names(SensorDataStats))
names(SensorDataStats) <- gsub('\\.mean',".Mean",names(SensorDataStats))
names(SensorDataStats) <- gsub('\\.std',".StandardDeviation",names(SensorDataStats))
names(SensorDataStats) <- gsub('Freq\\.',"Frequency.",names(SensorDataStats))
names(SensorDataStats) <- gsub('Freq$',"Frequency",names(SensorDataStats))


# Create, check and write final tidy data set==============================================================
SensorAvg = ddply(SensorDataStats, c("Subject","Activity"), numcolwise(mean))
head(SensorAvg)
write.table(SensorAvg, file = "SensorAvgByAct.txt")