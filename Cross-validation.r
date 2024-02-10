#Data Import----
setwd("D:/Practical/VIT/DS R/DataSET")
datar=read.csv("fetal_health.csv")
datar=subset(datar,(fetal_movement<0.0075))
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
datar_train$fetal_health=as.factor(datar_train$fetal_health)
