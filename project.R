#install.packages(c("tidyverse", "caret", "randomForest", "pROC"))
library(tidyverse)      # data wrangling + plots
library(caret)          # train/test split + modelling helpers
library(randomForest)   # random forest model
library(pROC)           # ROC curve + AUC

loan <- read_csv("loan_approval_dataset.csv")

# Look at the structure
glimpse(loan)
summary(loan)


#2. CLEAN THE DATA       
###########################


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


glimpse(loan_clean)


#3. TRAIN / TEST SPLIT (70/30)  
##################################

set.seed(123)  

train_index <- createDataPartition(
  loan_clean$loan_status,
  p = 0.7,          
  list = FALSE
)

train_data <- loan_clean[train_index, ]
test_data  <- loan_clean[-train_index, ]

# target for the test set
test_y <- test_data$loan_status



#4. MODEL 1: LOGISTIC REGRESSION      
#########################################

# train the model
logit_model <- glm(
  loan_status ~ .,      # predict loan_status using all other columns
  data   = train_data,
  family = binomial
)

summary(logit_model)



# predicted probabilities for "Approved"
logit_prob <- predict(
  logit_model,
  newdata = test_data,
  type = "response"
)

# convert probabilities to class labels ("Approved"/"Rejected")
logit_pred <- ifelse(logit_prob >= 0.5, "Approved", "Rejected")
logit_pred <- factor(logit_pred,
                     levels = levels(test_y))   # make sure levels match


##confustion matix

conf_mat_logit <- confusionMatrix(
  data      = logit_pred,
  reference = test_y,
  positive  = "Approved"   # treat "Approved" as the positive class
)

conf_mat_logit    # accuracy, recall, F1 etc.


#roc n aus

roc_logit <- roc(
  response = test_y,
  predictor = logit_prob,
  levels = c("Rejected", "Approved")
)

auc(roc_logit)   # AUC value

plot(roc_logit,
     main = "Logistic Regression - ROC Curve")

#5. MODEL 2: RANDOM FOREST        
#####################################

set.seed(123)

rf_model <- randomForest(
  loan_status ~ .,
  data = train_data,
  ntree = 300,                              # number of trees
  mtry  = floor(sqrt(ncol(train_data) - 1)),# features per split
  importance = TRUE
)

rf_model   # quick summary



# probabilities for each class
rf_prob <- predict(
  rf_model,
  newdata = test_data,
  type = "prob"
)[, "Approved"]   # take probability of Approved

# predicted class labels
rf_pred <- predict(
  rf_model,
  newdata = test_data,
  type = "response"
)


conf_mat_rf <- confusionMatrix(
  data      = rf_pred,
  reference = test_y,
  positive  = "Approved"
)

conf_mat_rf




roc_rf <- roc(
  response = test_y,
  predictor = rf_prob,
  levels = c("Rejected", "Approved")
)

auc(roc_rf)

plot(roc_rf,
     main = "Random Forest - ROC Curve")


#6.TABLE OF METRICS
########################################

logit_auc <- auc(roc_logit)
rf_auc    <- auc(roc_rf)

logit_acc <- conf_mat_logit$overall["Accuracy"]
rf_acc    <- conf_mat_rf$overall["Accuracy"]

logit_f1  <- conf_mat_logit$byClass["F1"]
rf_f1     <- conf_mat_rf$byClass["F1"]

model_results <- data.frame(
  Model    = c("Logistic Regression", "Random Forest"),
  Accuracy = c(logit_acc, rf_acc),
  F1       = c(logit_f1, rf_f1),
  AUC      = c(logit_auc, rf_auc)
)

model_results


