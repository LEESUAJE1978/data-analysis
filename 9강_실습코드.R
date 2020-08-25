#0.패키지 로딩####
require()

#.1. 파일 경로 확인####
getwd() #현재 파일 경로 확인
dir() #현재 경로 폴더에 저장된 파일 확인인
#setwd() 경로 설정시 사용 

#2. 파일 불러오기####
accidents = read_csv("Accidents0515.csv")
casualties= read_csv("Casualties0515.csv")
vehicles = read_csv("Vehicles0515.csv")

#3. 데이터 시각화
colnames(accidents)
hist(accidents$Age_of_Driver,freq = FALSE)#확률 밀도 함수 그래프 그릴 때는 빈도 사용 않함
lines(density(accidents$Age_of_Driver))
hist(accidents$Age_of_Driver)#빈도를 나타내는 그래프
lines(density(accidents$Age_of_Driver))#빈도로 표현하면 적용 안됨
ggpairs(accidents$Age_of_Driver)

#4. 로지스틱 회귀분석 코드 참조: https://bioinformaticsandme.tistory.com/296
result <- glm(Accident_Severity ~ Speed_limit + Weather_Conditions + Carriageway_Hazards + Sex_of_Driver + 
      Age_of_Driver+Journey_Purpose_of_Driver, data = accidents)

summary(result)

#5. 오즈비 계산
ORtable = function(x, digits=2){
  suppressMessages(a<-confint(x))
  result = data.frame(exp(coef(x)),exp(a))
  result = round(result,digits)
  result = cbind(result, round(summary(x)$coefficient[,4],3))
  colnames(result) = c("OR", "2.5%","97.5%","p")
  result
}

ORtable(result)

#6.의사결정 나무
if(!require('caret')){
  install.packages('caret')
  require('caret')
}

if(!require('tree')){
  install.packages('tree')
  require('tree')
}

if(!require('rpart')){
  install.packages('rpart')
  require('rpart')
}

treemod <- tree(Accident_Severity ~ Speed_limit + Weather_Conditions + Carriageway_Hazards + Sex_of_Driver + 
                  Age_of_Driver+Journey_Purpose_of_Driver, data = accidents_sam)
plot(treemod)
text(treemod)


rpartmod <- rpart(Accident_Severity ~ Speed_limit + Weather_Conditions + Carriageway_Hazards + Sex_of_Driver + 
                    Age_of_Driver+Journey_Purpose_of_Driver, data = accidents_sam)
plot(rpartmod)
text(rpartmod)
