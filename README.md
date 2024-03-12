# Fetal_Health_Prediction
<a href="https://circleci.com/gh/badges/shields/tree/master">
<img src="https://img.shields.io/circleci/project/github/badges/shields/master" alt="build status">
</a>

## Overview
- This project deals with a  3 class problem for predicting the fetal health into categories like
i.	Normal
ii.	Suspect
iii.	Pathological
- The Data undergoes pre-processing to remove outliers, then cross validated for better results. Models used include Decision Tree, Random Forest, XGBoost and Naive Bayes.

#### Dataset 
[Reproduction Child-healthcare Classification](https://www.kaggle.com/datasets/gauravduttakiit/reproductive-childhealthcare-classification)
- This dataset has over 2100 records
- Fetal_health is the target variable
- It has 22 input variables including:
        - **Baseline value** - Baseline Fetal Heart Rate (FHR)
        - **Accelerations** - Number of accelerations per second
        - **Fetal_movement** - Number of fetal movements per second
        - **Uterine_contractions** - Number of uterine contractions per second
        - **Light_decelerations** - Number of LDs per second
        - **Severe_decelerations** - Number of SDs per second
        - **Prolongued_decelerations** - Number of PDs per second
        - **Abnormal_short_term_variability** - Percentage of time with abnormal short term variability
        - **Mean_value_of_short_term_variability** - Mean value of short term variability
        - **Percentage_of_time_with_abnormal_long_term_variability** - Percentage of time with abnormal long term variability

#### Accuracy
 So, the following are algorithm implemented along with their accuracy, 
- Naïve Bayes (Accuracy:0.81)
- Decision Tree (Accuracy:0.82)
- XGBoost (Accuracy:0.84)
- Random Forest (Accuracy: 0.87)



### Pre-requisites Required
[R studio](https://posit.co/downloads/)  and [R Programming](https://cran.r-project.org/bin/windows/base/) to be installed using their official documentation.
- Install both simultaneously & ensure version compatability. If either is already downloaded, upgrade it to latest version.
  ```
  install.packages("ggplot2")
  ```

  ```
  install.packages("ROSE")
  ```

 ```
install.packages("rpart")
```
  
```
install.packages("rpart.plot")
```
  
```
install.packages("randomForest")
```

```
install.packages("e1071")
```

```
install.packages("xgboost")
```

```
install.packages("caret")
```
### Execution
- Run the given code by downloading the file and ensure respective csv file is also in same directory
- Set the directory using setwd command.
- Install the required packages

###### If you find my repository helpful, please star⭐ it 🌟.
