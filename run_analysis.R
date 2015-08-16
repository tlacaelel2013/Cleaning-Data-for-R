# run_analysis.R script
## luis.arreguin@hotmail.com -- Aug 16, 2015.
# run_analysis.R script

feat_names <- read.table(file("features.txt"), stringsAsFactors=FALSE)
activity <- read.table(file("activity_labels.txt"))

names0 <- c("Activity", "Subject", "Set")

## get indexes of mean and std features

names1 <- strsplit(feat_names[,2], "-")
names2 <-c() 				# vector of column names for selected features

mean_idx_vector <- c()
for (i in 1:length(names1)) {
	idx_bool <- FALSE
	if(!is.na(names1[[i]][2]=="mean()")) idx_bool <- names1[[i]][2]=="mean()" 
	if (idx_bool) {
		mean_idx_vector <- c(mean_idx_vector, i)
		names2 <- c(names2, feat_names[i,2])
	}
}

std_idx_vector <- c()
for (i in 1:length(names1)) {
	idx_bool <- FALSE
	if(!is.na(names1[[i]][2]=="std()")) idx_bool <- names1[[i]][2]=="std()" 
	if (idx_bool) {
		std_idx_vector <- c(std_idx_vector, i)
		names2 <- c(names2, feat_names[i,2])
	}
}

## processing the test set

con1 <- file("test/y_test.txt")
y <- readLines(con1)
close(con1)

n1 <- length(y)

con2 <- file("test/subject_test.txt")
sub <- readLines(con2)
close(con2)


feat <- read.table(file("test/X_test.txt"))


## subsetting the original matrix X

feat_index <- c(mean_idx_vector, std_idx_vector)

feat1 <- feat[,feat_index]
colnames(feat1) <- names2
write(names2, file = "feat_selected.txt")

## assembling the data frame

set_type <- rep("test", n1)

y1 <- as.factor(y)
levels(y1) <- activity[,2]
df1 <- data.frame(y1,sub,set_type,feat1)
colnames(df1) <- c(names0,names2)

## processing the training set


con1 <- file("train/y_train.txt")
y <- readLines(con1)
close(con1)
n2 <- length(y)

con2 <- file("train/subject_train.txt")
sub <- readLines(con2)
close(con2)

feat <- read.table(file("train/X_train.txt"))

## subsetting the original matrix X

feat_index <- c(mean_idx_vector, std_idx_vector)

feat2 <- feat[,feat_index]
colnames(feat2) <- names2

## assembling the data frame

set_type <- rep("training", n2)

y2 <- as.factor(y)
levels(y2) <- activity[,2]
df2 <- data.frame(y2,sub,set_type,feat2)
colnames(df2) <- c(names0,names2)

## assembling the final data frame (including the training and test sets)

df <- rbind(df1, df2)

write.table(df, file = "df_test_train.txt", row.names = FALSE)

## generating a new data frame with means for all features by grouping the dataset df by activity and subject

df3 <- aggregate(df[,4:length(names2)], list("Activity"=df$Activity, "Subject"=df$Subject), mean)

write.table(df3, file = "df_group_by.txt", row.names = FALSE)
