#0.패키지 불러오기####

if(!require('tidyverse')){
  install.packages('tidyverse')
  require(tidyverse)
}

if(!require('randomForest')){
  install.packages('randomForest')
  require('randomForest')
}

#1. 데이터셋 불러오기####
df <- iris
str(iris)
summary(iris)


#2. 학습, 훈련 데이터 셋 만들기####
train<- sort(sample(1:nrow(df), nrow(df)*0.7))
test <- setdiff(1:nrow(df), train)

train_df <- df[train,]
test_df <- df[test,]
colnames(test_df)

#3. 랜덤 포레스트 모델 만들기
rf_m <- randomForest(Species ~Sepal.Length +Sepal.Width+ Petal.Length +Petal.Width, data = train_df)
rf_p <- predict(rf_m, newdata = test_df, type = 'class')

#4. 정확도 확인하기####
rf_m$confusion
sum(rf_p == test_df$Species)/nrow(test_df) *100

#5. 변수 중요도 시각화
plot(rf_m)
legend("topright", colnames(rf_m$err.rate), col = 1:4, cex=0.8, fill =1:4)
varImpPlot(rf_m)
rf_m$importance


#참고: https://www.rdocumentation.org/packages/randomForest/versions/4.6-14/topics/randomForest