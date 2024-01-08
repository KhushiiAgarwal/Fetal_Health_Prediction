#Data Import----
setwd("D:/Practical/VIT/DS R/DataSET")
datax=read.csv("fetal_health.csv")
cat("No of rows initially:",nrow(datax))

datar=subset(datax,(fetal_movement<0.0075))
datar=subset(datar,(severe_decelerations==0))
datar=subset(datar,( mean_value_of_short_term_variability<3.2))
datar=subset(datar,(percentage_of_time_with_abnormal_long_term_variability<27.5))
datar=subset(datar,(mean_value_of_long_term_variability<20.1))
datar=subset(datar,(histogram_number_of_zeroes==0))
datar=subset(datar,(histogram_max<207))
datar=subset(datar,(histogram_number_of_peaks<12))
datar=subset(datar,(histogram_mode>(100.5) & histogram_mode<176.5))
datar=subset(datar,(histogram_mean>(95) & histogram_mean<175))
datar=subset(datar,(histogram_variance<57))
cat("\nNo of rows after removal of outliers ",nrow(datar))

#ROSE----
library(ROSE)
library(caret)
p1=prop.table(table(datar$fetal_health))
print(p1)
data1=subset(datar,(fetal_health<3))
data2=subset(datar,(fetal_health==1 | fetal_health==3))
db1 <- ovun.sample(fetal_health ~ ., data = data1, method = "over", N = 1750, seed = 222)$data
print(table(db1$fetal_health))
db2 <- ovun.sample(fetal_health ~ ., data = data2, method = "over", N = 1700, seed = 123)$data
print(table(db2$fetal_health))
data_new=rbind(db1,db2[db2$fetal_health==3,])
cat("\nNo of rows after oversampling ",nrow(data_new))

#Test-Train split----
set.seed(222)
shuffle_index <- sample(1:nrow(data_new))
data_new<-data_new[shuffle_index,]
id<-sample(2,nrow(data_new),prob=c(0.6,0.4),replace = TRUE)
datar_train<-data_new[id==1,]
datar_test<-data_new[id==2,]

#decision tree----
library(rpart)
library(rpart.plot)
set.seed(51)
id<-sample(2,nrow(datax),prob=c(0.8,0.2),replace = TRUE)
data_train<-datax[id==1,]
data_test<-datax[id==2,]
tree <- rpart(fetal_health~.,data=data_train)
rpart.plot(tree)
printcp(tree)
prun<-prune(tree, cp= tree$cptable[which.min(tree$cptable[,"xerror"]),"CP"])
predicted <-predict(tree,data_test)
predicted<-as.integer(predicted)
cmd=table(data_test$fetal_health,predicted)
print(cmd)
print(confusionMatrix(cmd))
#Random Forest----
library(randomForest)
datar_train$fetal_health=as.factor(datar_train$fetal_health)
rf <- randomForest(fetal_health~.,data = datar_train,ntree = 300,mtry = 8,proximity = TRUE,)
print(rf)
attributes(rf)
# Prediction & Confusion Matrix - train data
p1 <- predict(rf, datar_train)
confusionMatrix(p1, datar_train$fetal_health)
print(confusionMatrix(p1,datar_train$fetal_health))
p2 <- predict(rf, newdata=datar_test) # Prediction & Confusion Matrix - test data
confusionMatrix(p2, as.factor(datar_test$fetal_health))
plot(rf)
hist(treesize(rf),main = "No. of Nodes for the Trees",col = "green")
# Variable Importance
varImpPlot(rf,sort = T,n.var = 10,main = "Top 10 - Variable Importance")
importance(rf)
varUsed(rf)

#Naive Bayes----
library(e1071)
nb=naiveBayes(fetal_health ~ ., data = datar_train)
pred=predict(nb,datar_test)
print(attributes(nb))
#Confusion Matrix
cm=table(datar_test$fetal_health,pred)
print(cm)
print(confusionMatrix(cm))
#XGBoost----
library(xgboost)
#Train-Test split acc to XGBoost
y_train=as.factor(datar_train$fetal_health)
y_test=as.factor(datar_test$fetal_health)
x_train=as.matrix(datar_train[,1:21])
x_test=as.matrix(datar_test[,1:21])
xgboost_train = xgb.DMatrix(data=x_train, label=y_train)
xgboost_test  = xgb.DMatrix(data=x_test, label=y_test)
watchlist = list(train=xgboost_train, test=xgboost_test)
model = xgb.train(data = xgboost_train, max.depth = 5, watchlist=watchlist, nrounds = 500)
#RMSE is min at 95,after which it starts increasing indicating overfitting
final_model = xgboost(data = xgboost_train, max.depth = 5, nrounds = 335, verbose = 0)
pred_test = predict(final_model, xgboost_test)
importance_matrix <- xgb.importance(names(x_train), model = final_model)
xgb.plot.importance(importance_matrix)
#min & max (pred_test) then factorization for confusion matrix
pred_test[pred_test>0.4 & pred_test<1.2]=1
pred_test[pred_test>1.2 & pred_test<2.1]=2
pred_test[pred_test>2.1 & pred_test<3.1]=3
#Confusion Matrix
cm1=table(pred_test,y_test)
print(cm1)
print(confusionMatrix(as.factor(pred_test),as.factor(y_test)))
