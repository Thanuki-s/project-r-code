# Loan Approval Prediction (Machine Learning in R)

This project builds machine learning models to predict whether a loan application will be Approved or Rejected based on applicant information, loan details, and asset values.  
It includes end-to-end data cleaning, exploratory analysis, model building, evaluation and visualisation using R.

---
  
  ## Project Overview
  
  Financial institutions receive thousands of loan applications each year.  
This project demonstrates how machine learning can support faster and more consistent decision-making.

I compare two models:
  
  - Logistic Regression (baseline, interpretable)
- Random Forest (ensemble model, higher performance)

---
  
  ##Dataset
  
  - Rows:4,269 loan applications  
- Target variable:`loan_status` (Approved / Rejected)  
- Predictors include: 
  - Applicant info: education, employment, dependents  
- Financial info: income, CIBIL score  
- Asset values: residential, commercial, luxury, bank  
- Loan details: amount, term  

`loan_id` was removed as it is just an identifier.  
All categorical variables were converted into factors in R.

No missing values were found in this dataset.

---
  
  ##  Technologies Used
  
  - R
  - tidyverse (data wrangling + plotting)
- caret (train/test split, evaluation)
- randomForest (ML model)
- pROC (ROC curves + AUC)
- RStudio
- Git & GitHub

---
  
  ## Exploratory Data Analysis (EDA)
  
  Some initial insights:
  
  - Approved loans were slightly more common than rejected ones.
- Higher-income applicants were somewhat more likely to be approved.
- CIBIL score showed a strong positive relationship with approval.
- Asset values and loan amounts varied widely across applicants.

(See plots in the `/plots` folder.)

---
  
  ## Models Trained
  
  ###  Logistic Regression
  - Accuracy: ~90.7%
  - F1-score: ~0.93
  - AUC: 0.96
  
  Good, interpretable baseline model.

---
  
  ### Random Forest
  - Accuracy: ~98%
  - F1-score: ~0.98
  - AUC: 0.996
  
  This model achieved significantly higher predictive performance.

Top important features:
  - CIBIL score  
- Loan term  
- Loan amount  
- Income  
- Asset values  

---
  
  ## Results Summary
  
  | Model                | Accuracy | F1 Score | AUC |
  | Logistic Regression  | 0.9077   | 0.9266   | 0.9638|
  | Random Forest        | 0.9804   | 0.9843   | 0.9964|
  
  Random forest clearly outperforms logistic regression.  
ROC curves and confusion matrices are included in the report.


  
  