Getting and Cleaning Data
========================================================
The following files and precesses are used to clean a data set for the Coursera course, Getting and Cleaning Data.


Files in Project
--------------------------------------------------------
The project has the following files:
* Readme.md: This file.  Markdown file that describes the files and process to run the tidy data cleanup process.
* CodeBook.md: This is a markdown file that details the input files and process to run the tidy data cleanup process.
* run_analysis.R: This file contains the R code that merges and tidies the data and creates final processed data file
* SensorAvgByAct.txt: This is the final output file and contains the tidied, post processing data


Running the Files
--------------------------------------------------------
The following steps are needed to implement these files:

1. Copy the 'run_analysis.R' to the working directory
2. Download the input data files to working directory and set the working directory in the run_analysis.R code
3. Run the 'run_analysis.R' code.  This code loads the activity and feature info, the training and test datasets (keeping only those columns which reflect a mean or standard deviation), the activity and subject data for each dataset.  It then merges the two datasets and converts the activity and subject columns into factors.  Finally, it creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
4. The end result is written to the output file, 'SensorAvgByAct.txt'.

