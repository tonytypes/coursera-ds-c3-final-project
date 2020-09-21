# coursera-ds-c3-final-project
## Getting and Cleaning Data - Final Project - Accelerometer Data

### Description
Created by: Tony Ruiz, tonytypes@gmail.com, https://github.com/tonytypes/

This repo contains the r script for an analysis submitted by Tony Ruiz for the Coursera course "Getting and Cleaning Data."

The r script takes the original smartphone accelerometer data (linked below) and converts them into two tidy data outputs:
* 'tidy_accelerometer_data.txt': 
  * Merges the training and the test sets to create one data set.
  * Extracts only the measurements on the mean and standard deviation for each measurement.
  * Uses descriptive activity names to name the activities in the data set
  * Appropriately labels the data set with descriptive variable names.
* 'tidy_accelerometer_data_averages.txt': 
  * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Contents
* this README file
* 'run_analysis.r': the script used to create the 2 output files
* 'codebook.txt': a description of each variable in each of the 2 output files

### Source file
The original data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Instructions
Before running this script, the ZIP file referenced above must first be saved in the working directory.

