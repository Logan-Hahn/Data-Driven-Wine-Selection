# wine linear regression 
install.packages("OpenML")
devtools::install_github("openml/openml-r")
install.packages(c("farff", "RWeka"))
install.packages("caTools")
install.packages("tree")
library("OpenML")
library("farff")
library("caTools")
library(tree)

install.packages("car")
library("car")


# pulling data from openML
wine = getOMLDataSet(data.id = 40498)
df = wine$data
head(df)
#install.packages("dplyr")
library(dplyr)
library(tidyverse)

# changing column names
wine = df %>% rename("fixed_acidity"= V1,"volatile_acidity"=V2,"citric_acid"=V3,"residual_sugar"=V4,
                     "chlorides"=V5,"free_sulfur_dioxide"=V6,"total_sulfur_dioxide"=V7,"density"=V8,
                     "pH"=V9,"sulphates"=V10,"alcohol"=V11)

head(wine)

# checking for nulls
sum(is.na(wine))


# class is currently a factor
# change to numeric
wine$Class = as.numeric(wine$Class)
str(wine$Class)


library(psych)
summary(wine)
describe(wine)

# looking at linearity of each variable
# checking linearity of certain variables 

# fixed_acidity 
plot(wine$fixed_acidity, wine$Class, main="fixed acidity vs class", xlab="fixed_acidity", ylab="Class", pch=19)
abline(lm(wine$Class~wine$fixed_acidity), col="red")
# negative regression line - relatively stagnant towards earlier class types 
# but the higher the rating correlated to lower amounts of fixed_acidity 
# except for class 1

# volatile_acidity
plot(wine$volatile_acidity, wine$Class, main="volatile acidity vs class", xlab="volatile acidity", ylab="Class", pch=19)
abline(lm(wine$Class~wine$volatile_acidity), col="red")
# same with fixed acidity -- the lower the volatile acidity the hgiher the class type
# except for class 1

# the two above dont really have linear relationships -- could transform by squaring

# citric acid
plot(wine$citric_acid, wine$Class, main="citric_acid vs class", xlab="citric acidity", ylab="Class", pch=19)
abline(lm(wine$Class~wine$citric_acid), col="red")
# non linear relationshio 
# also try transforming

# residual sugar 
plot(wine$residual_sugar, wine$Class, main="residual sugar vs class", xlab="residual sugar", ylab="Class", pch=19)
abline(lm(wine$Class~wine$residual_sugar), col="red")
# 

# chlorides
plot(wine$chlorides, wine$Class, main="chlorides vs class", xlab="chlorides", ylab="Class", pch=19)
abline(lm(wine$Class~wine$chlorides), col="red")

# free sulfur dioxide
plot(wine$free_sulfur_dioxide, wine$Class, main="free_sulfur_dioxide vs class", xlab="free_sulfur_dioxide", ylab="Class", pch=19)
abline(lm(wine$Class~wine$free_sulfur_dioxide), col="red")

# total sulfur dioxide
plot(wine$total_sulfur_dioxide, wine$Class, main="total_sulfur_dioxide vs class", xlab="total_sulfur_dioxide", ylab="Class", pch=19)
abline(lm(wine$Class~wine$total_sulfur_dioxide), col="red")

# density
plot(wine$density, wine$Class, main="density vs class", xlab="density", ylab="Class", pch=19)
abline(lm(wine$Class~wine$density), col="red")

# pH
plot(wine$pH, wine$Class, main="pH vs class", xlab="pH", ylab="Class", pch=19)
abline(lm(wine$Class~wine$pH), col="red")

# sulphates
plot(wine$sulphates, wine$Class, main="sulphates vs class", xlab="sulphates", ylab="Class", pch=19)
abline(lm(wine$Class~wine$sulphates), col="red")

# alcohol
plot(wine$alcohol, wine$Class, main="alcohol vs class", xlab="alcohol", ylab="Class", pch=19)
abline(lm(wine$Class~wine$alcohol), col="red")


# splitting into training and testing
train = sample.split(wine$Class, SplitRatio = .7)
df_train = wine[train,]
df_test = wine[!train,]

head(df_train)
model_all = lm(Class~., data = df_train)
summary(model_all)

model_sig = lm(Class ~. - citric_acid - chlorides - total_sulfur_dioxide, data = df_train)
summary(model_sig)

vif(model_all)

model_vif = lm(Class ~. - citric_acid - chlorides - total_sulfur_dioxide - density - residual_sugar, data = df_train)
summary(model_vif)

model_int = lm(Class ~ fixed_acidity + volatile_acidity + free_sulfur_dioxide
         + pH + alcohol*fixed_acidity*volatile_acidity + sulphates
         ,data = df_train)
summary(model_int) 

# log transformation model 
model_log = lm(Class ~ log(fixed_acidity) + log(volatile_acidity) + log(free_sulfur_dioxide)
        + log(pH) + log(sulphates) + log(alcohol), data = df_train)
summary(model_log)

# vif 
model = lm(Class ~ ., data = df_train)
summary(model)
vif(model)
# vif shows high density and high residual sugar
# removing these two 


lm10= lm(Class ~ fixed_acidity + volatile_acidity + free_sulfur_dioxide
         + alcohol + I(alcohol^2) + alcohol*fixed_acidity + alcohol*volatile_acidity
         + alcohol*free_sulfur_dioxide + I(fixed_acidity^2) + I(free_sulfur_dioxide^2) 
         , data = df_train)
summary(lm10) 

vif(lm10)

######## predictions and rmse for each model ########

df_test$preds_sig = predict(model_sig,df_test, type = "response")
df_test$preds_vif = predict(model_vif,df_test, type = "response")
df_test$preds_int = predict(model_int,df_test, type = "response")
df_test$preds_log  = predict(model_log,df_test, type = "response")
df_test$lm10  = predict(lm10,df_test, type = "response")

rmse = function(m,o) {
  sqrt(mean((m-o)^2))
}

rmse(df_test$preds_sig, df_test$Class)
# 0.7580794
rmse(df_test$preds_vif, df_test$Class)
#  0.767494
rmse(df_test$preds_int, df_test$Class)
# 0.7592698
rmse(df_test$preds_log, df_test$Class)
#0.7596399
rmse(df_test$lm10, df_test$Class)
# 0.7994331


# train predictions
df_train$preds_train = predict(lm10,df_train, type = "response")
head(df_train)


df_test[10:100,]


# making predictions top 100
df_test$preds_test = predict(lm10, df_test, type = "response")

preds_data = df_test[order(-df_test$preds_test),]
top_preds <- head(preds_data,100)
top_preds

# top 100 predictions on test
write.csv(top_preds,"wine_top100.csv", row.names = FALSE)


rmse = function(m,o) {
  sqrt(mean((m-o)^2))
}

rmse(df_test$preds_test, df_test$Class)

# train dataset csv
write.csv(df_train,"wine_train.csv", row.names = FALSE)

# test dataset csv
write.csv(df_test,"wine_test.csv", row.names = FALSE)



####### other linear regression models earlier tested #########
lm5 = lm(Class ~ fixed_acidity + volatile_acidity*residual_sugar + free_sulfur_dioxide
         + density*pH*sulphates + alcohol*fixed_acidity*volatile_acidity*density, data = df_train)
summary(lm5)



lm6 = lm(Class ~ fixed_acidity + volatile_acidity + free_sulfur_dioxide
         + density*pH + alcohol*fixed_acidity*volatile_acidity*density + sulphates + fixed_acidity*density 
         + density*residual_sugar + alcohol*density, data = df_train)
summary(lm6) 

lm7 = lm(Class ~ fixed_acidity + volatile_acidity +  residual_sugar +  free_sulfur_dioxide
         + density*pH + alcohol*fixed_acidity*volatile_acidity*density + sulphates  + fixed_acidity*density 
         + density*residual_sugar + alcohol*density + I(fixed_acidity^2) + I(volatile_acidity^2) +
           I(residual_sugar^2) + I(free_sulfur_dioxide^2) + I(sulphates^2) + I(density^2) + I(pH^2) + I(alcohol^2)
         , data = df_train)
summary(lm7) 


lm8 = lm(Class ~ fixed_acidity + volatile_acidity +  residual_sugar +  free_sulfur_dioxide
         + density*pH + alcohol*fixed_acidity*density + fixed_acidity*density 
         + density*residual_sugar + alcohol*density +  I(fixed_acidity^2) + I(volatile_acidity^2) 
         + I(free_sulfur_dioxide^2) + I(density^2) 
         , data = df_train)
summary(lm8) 



###### tree model ##########
# tree model
## splitting into training and testing

train = sample.split(wine$Class, SplitRatio = .7)
df_train = wine[train,]
df_test = wine[!train,]

tree1 = tree(Class ~., data=df_train)
tree1


# predictions on tree model training
predTrain = predict(tree1,df_train)
tail(table(predTrain, df_train$Class))


# predicting on tree model testing data
predTest = predict(tree1,df_test)
tail(table(predTest, df_test$Class))

preds = predict(tree1,wine)
head(preds)


df_test$Predictions = predTest
df_test[10:20,]
