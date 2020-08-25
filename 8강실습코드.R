#0. 패키지 로딩####
require('tidyverse')
if(!require('data.table')){ #데이터 빠르게 읽어 오는 패키지
  install.packages("data.table")
  require('data.table')
}
if(!require('pastecs')){ #통계 패키지
  install.packages('pastecs')
  require('pastecs')
}

if(!require('psych')){ #통계 패키지
  install.packages('psych')
  require('psych')
}



#.1. 파일 경로 확인####
getwd() #현재 파일 경로 확인
dir() #현재 경로 폴더에 저장된 파일 확인인
#setwd() 경로 설정시 사용 


#2. 파일 불러오기 ####
#2.1.로딩 시간 비교
system.time(read_csv("Accidents0515.csv"))
system.time(read.csv("Accidents0515.csv"))
system.time(fread("Accidents0515.csv"))

#2.2. 파일 불러오기
accidents = read_csv("Accidents0515.csv")
casualties= read_csv("Casualties0515.csv")
vehicles = read_csv("Vehicles0515.csv")

str(accidents)#R과 파이썬의 차이점 중 하나는 R은 인덱스 열을 자동으로 생성하지 않는다
str(casualties)
str(vehicles)


#3. 데이터 탐색(Exploratory Data Analysis)####
#3.1. 데이터 셋 병합
accidents = full_join(accidents,vehicles, by = "Accident_Index")
str(accidents)

#3.2 불필요 데이터 제거
colnames(accidents)
accidents = accidents %>% select(-c('Location_Easting_OSGR', 'Location_Northing_OSGR','LSOA_of_Accident_Location',
                                    'Junction_Control','2nd_Road_Class')) # 필요없는 컬럼 제거

#4.3. 기초 통계량 확인
summary(accidents) #base 패키지
stat.desc(accidents)#pastec 패키지
describe(accidents)

#4.4. 결측치 확인 및 제거
sum(is.na(accidents))
na.omit(accidents)
colnames(accidents)
for(cols in colnames(accidents)){
  accidents_a <- (accidents %>% filter(accidents[cols]!=-1))  
}

for(cols in colnames(accidents)){
  accidents_b <- (accidents %>% filter(accidents[cols]==-1))  
}

#4.5. 날짜 데이터 변환
if(!require('lubridate')){
  install.packages('lubridate')
  require('lubridate')
}
sam <- sample(1:nrow(accidents),1000)
accidents_sam <- accidents[sam,]
accidents_sam <- accidents_sam %>% mutate(Date_time = paste(accidents_sam$Date, accidents_sam$Time))
accidents_sam$Date_time <- dmy_hms(accidents_sam$Date_time)
accidents_sam$Date_time
accidents_sam %>% select(-c('Date', 'Time'))

#5.데이터 시각화(Data Visualization)####
#5.1. 요일별 사고 건수 히스토그램
accidents_sam <- accidents_sam %>% 
  mutate(weekday = wday(accidents_sam$Date_time, label = T))
plot(accidents_sam$weekday)
ggplot(accidents_sam, aes(weekday))+
  geom_histogram(binwidth = 7, stat = 'count', aes(fill = weekday))+ #fill은 그래프 안의 색상 colour는 그래프 선의 색상
  labs(x= "요일", y="사고건수", title = "요일별 교통 사고건수")

#5.2. 시간별 사고 건수 히스토그램
accidents_sam <- accidents_sam %>% 
  mutate(hour=hour(accidents_sam$Time))
plot(accidents_sam$hour)
ggplot(accidents_sam, aes(hour))+
  geom_histogram(binwidth = 7, stat = 'count', aes(fill = 'red'))+ #fill은 그래프 안의 색상 colour는 그래프 선의 색상
  labs(x= "시간", y="사고건수", title = "시간별 교통 사고건수")



#5.3. 나이별 사상자 히스토그램
str(casualties)
sum(casualties$Age_Band_of_Casualty %in% -1) #특이 값 확인
length(which(casualties_sam ==-1))#특이 값 확인


for(col in colnames(casualties)){
  casualties <- casualties %>% filter(casualties[col] !=-1)
}

age <- cut(casualties$Age_Band_of_Casualty,
           breaks = c(0,1,2,3,4,5,6,7,8,9,10, 11, Inf),
           labels = c('0', '0-5', '6-10', '11-15', '16-20', '21-25', '26-35', '36-45', '46-55', '56-65', '66-75', '75+'))

ggplot(casualties, aes(age))+
  geom_histogram(binwidth = 12, stat = 'count')+
  labs(x= '연령대', y="사고건수", title = "연령대별 사고건수")


#5.4. 속도 제한 구역
speed_zone <- accidents %>% filter(accidents$Speed_limit %in% c('50','60','70'))
pie(table(speed_zone$Speed_limit))

#5.5.상관관계
cor(accidents_sam) #r은 모든 데이터가 수치형 데이터여야 함
cor(accidents_sam[,2:5])
pairs(accidents_sam[,2:5])
heatmap(as.matrix(accidents_sam[,2:5]), scale = "col")

#http://blog.naver.com/PostView.nhn?blogId=pmw9440&logNo=221576168716 참고
