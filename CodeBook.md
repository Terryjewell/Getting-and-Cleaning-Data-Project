Getting and Cleaning Data Project
========================================================
*italic* By: Terry Jewell

This code book is to describe the code generated to create a tidy data file fof Coursera Getting and Cleaning Data course.  This code book describes the variables, the data, and any transformations or work that was performed to clean up the data.

Source Data Overview
--------------------------------------------------------
A full description of the data used in this project can be found at The UCI Machine Learning Repository.
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The source data for this project can be found here.
http://archive.ics.uci.edu/ml/machine-learning-databases/00240/

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


Data
--------------------------------------------------------
The dataset includes the following files:

* README.txt
* features_info.txt: Information about the variables used on the feature vector.
* features.txt: List of all features.
* activity_labels.txt: Assignment of class labels with their associated activity name.
* train/X_train.txt: Training set.
* train/y_train.txt: Training labels.
* test/X_test.txt: Test set.
* test/y_test.txt: Test labels.

The following files are available for the train and test data. Their descriptions are equivalent.

* train/subject_train.txt: Each row identifies the who performed each sample activity. These values range from  1 to 30.
* train/Inertial Signals/total_acc_x_train.txt: The signal from the smartphone accelerometer X axis in standard gravity units 'g'. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
* train/Inertial Signals/body_acc_x_train.txt: The body acceleration signal as the difference between the gravity and total acceleration.
* train/Inertial Signals/body_gyro_x_train.txt: The angular velocity vector measured by the gyroscope. The units are radians/second.


Transformations
--------------------------------------------------------
The input files are transformed into a tidy data set through the following steps:

1. Loads Data
2. Merges the training and the test sets to create one data set
3. Subsets Mean and Standard Deviation
4. Cleans Data: Uses descriptive activity names to name the activities in the data set.Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Data Process
--------------------------------------------------------

### Step 1:Load Data
Set the root directory for all data files.  Set the names of all data files that are to be read in.  Read in each of these data files.
```{r}
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
```

### Step 2: Merges Training and test Data
Merge training and test data files.  Add sensor data labels to each field.
```{r}
# Merge data
TrainDataBind <-        cbind(cbind(X_TrainData, SubjectTrainData), Y_TrainData)
TestDataBind <-         cbind(cbind(X_TestData, SubjectTestData), Y_TestData)
MainSensorData <-       rbind(TrainDataBind, TestDataBind)

# Add labels to sensor data
SensorDataLabels <-     rbind(rbind(FeaturesData, c(562, "Subject")), c(563, "ActivityId"))[,2]
names(MainSensorData) <- SensorDataLabels
```

### Step 3: Subset Mean and Standard Deviation
Subset the data by selecting only the mean and standard deviation of the sensor data set.  Add activity labels to sensor data set.
```{r}
SensorDataStats <- MainSensorData[,grepl("mean|std|Subject|ActivityId", names(MainSensorData))]
```

### Step 4: Clean Up Data Set
Create labels that are more descriptive (e.g., 'Acceleration' instead of 'Acc') for each of the sensor dat field names.
```{r}
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
```

### Step 5: Create Final Tidy Data File
Subset, print headers and write final sensor data set to text file "SensorAvgByAct"
```{r}
SensorAvg = ddply(SensorDataStats, c("Subject","Activity"), numcolwise(mean))
head(SensorAvg)
write.table(SensorAvg, file = "SensorAvgByAct.txt")
```



