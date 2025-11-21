install.packages(c("tidyverse", "caret", "randomForest", "pROC"))
library(tidyverse)      # data wrangling + plots
library(caret)          # train/test split + modelling helpers
library(randomForest)   # random forest model
library(pROC)           # ROC curve + AUC

loan <- read_csv("loan_approval_dataset.csv")

# Look at the structure
glimpse(loan)
summary(loan)
