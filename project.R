#install.packages(c("tidyverse", "caret", "randomForest", "pROC"))
library(tidyverse)      # data wrangling + plots
library(caret)          # train/test split + modelling helpers
library(randomForest)   # random forest model
library(pROC)           # ROC curve + AUC

loan <- read_csv("loan_approval_dataset.csv")

# Look at the structure
glimpse(loan)
summary(loan)


# 2. CLEAN THE DATA       #
###########################

# - Remove loan_id (just an ID)
# - Convert characters (except target) to factors
# - Make loan_status a factor with levels: Rejected, Approved
# - Drop any rows with missing values (simple first version)

loan_clean <- loan %>%
  select(-loan_id) %>%     # remove pure ID column
  mutate(
    # turn predictors that are character into factors
    across(c(education, self_employed), as.factor),
    # make sure loan_status is a factor and set order of levels
    loan_status = factor(loan_status,
                         levels = c("Rejected", "Approved"))
  )

# check missing values
colSums(is.na(loan_clean))

# simple strategy: drop rows with any NA
loan_clean <- loan_clean %>% drop_na()

# check result
glimpse(loan_clean)
