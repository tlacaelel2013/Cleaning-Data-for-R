# Cleaning-Data-for-R
An R script is included to get a tidy file ready for statistical analysis.

The script run_analysis.R prepares a dataset for a simple statistical analysis.
There are four sections in the script, which I describe next.

## [1] Selecting the features

The first step is selecting the 66 out of 561 features that will be included in the dafarame df for analysis.
I accomplish that by reading the file features.txt and using the command strsplit to subsequently find those features whose names include "mean()" or "std()."

## [2] Processing the test and training sets

The next step is reading the files "test/y_test.txt," "test/subject_test.txt," and "test/X_test.txt."
Then, by using the indexes obtained in the previous section, a data frame is built by subsetting the original dataset.
The same steps are performed with the corresponding training data files.

## [3] Assembling the data frame for analysis

Once all the data files are processed into data frames df1 and df2, one data frame df is created by row binding df1 and df2.
Also, a text file is written on disk with the data from df.

## [4] Extracting data by groups to perform simple statistical analysis

Finally, the mean and the standard deviation is computed on the records of the data frame df after groupping the records by activity and subject.
A text file is written on disk containing the result of this analysis.

