#Data Import----
datax=read.csv("fetal_health.csv")
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
print(nrow(datar))
#ROSE----
library(ROSE)
library(caret)
p1=prop.table(table(datar$fetal_health))
print(p1)
data1=subset(datar,(fetal_health<3))
data2=subset(datar,(fetal_health==1 | fetal_health==3))

data1$fetal_health
data2$fetal_health

db1 <- ovun.sample(fetal_health ~ ., data = data1, method = "over", N = 1750, seed = 222)$data
print(table(db1$fetal_health))
db2 <- ovun.sample(fetal_health ~ ., data = data2, method = "over", N = 1700, seed = 123)$data
print(table(db2$fetal_health))
data_new=rbind(db1,db2[db2$fetal_health==3,])
print(nrow(data_new))

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
predict_unseen <-predict(tree,data_test)
table_mat <- table( predict_unseen,data_test$fetal_health)
accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
cat('Accuracy for Decision Tree:', accuracy_Test)
#Random Forest----
library(randomForest)
datar_train$fetal_health=as.factor(datar_train$fetal_health)
rf <- randomForest(fetal_health~.,data = datar_train,ntree = 300,mtry = 10,proximity = TRUE,)
print(rf)
attributes(rf)
# Prediction & Confusion Matrix - train data
p1 <- predict(rf, datar_train)
confusionMatrix(p1, datar_train$fetal_health)
print(confusionMatrix(p1,datar_train$fetal_health))
# Prediction & Confusion Matrix - test data
p2 <- predict(rf, newdata=datar_test)
confusionMatrix(p2, as.factor(datar_test$fetal_health))
plot(rf)
hist(treesize(rf),main = "No. of Nodes for the Trees",col = "green")
# Variable Importance
varImpPlot(rf,sort = T,n.var = 10,main = "Top 10 - Variable Importance")
importance(rf)
varUsed(rf)

