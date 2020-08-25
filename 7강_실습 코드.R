#0. 참고사이트: https://r4ds.had.co.nz/####
#https://github.com/LEESUAJE1978/data-analysis

#1.패키지 설치하기 ####
install.packages('dplyr')
require(dplyr)
install.packages('tidyverse')
library(tidyverse)


#2. 원하는 데이터 추출하기 filter ####
starwars
starwars %>%
  filter(species == "Droid")
starwars %>%
  select(name, ends_with("color"))

help("select")
#3. 원하는 컬럼 생성하기 ####
starwars %>%
  mutate(bmi = mass / (height/100) ^ 2) %>%
  select(name:mass, bmi)

#4.데이터 정렬하기####
starwars %>%
  arrange(desc(mass))
starwars %>%
  arrange(mass)

#5.데이터 그룹핑####
starwars %>%
  group_by(species) %>%
  summarize(
    n = n(),
    mass = mean(mass, na.rm = T),
    .groups = 'drop'
  ) %>%
  filter(n>1)

#6.데이터 프레임 병합####
df_1 <- data.frame(x = 1:3, y = 1:3)
df_2 <- data.frame(x = 4:6, y = 4:6)

#6.1. 행 기준 병합
rbind(df_1, df_2)
bind_rows(df_1, df_2)


df_3 <- data.frame(x = 7:9, z = 7:9)
rbind(df_1, df_3)
bind_rows(df_1, df_3)

bind_rows(list(grp_1 = df_1, grp_2 = df_2, grp_3 = df_3), id = 'group_id')
bind_rows(list(grp_1 = df_1, grp_2 = df_2, grp_3 = df_3), .id = 'group_id')

#6.2. 열 기준 병합
cbind(df_1, df_2, df_3)
bind_col(df_1, df_2, df_3)
bind_cols(df_1, df_2, df_3)

#6.3 처리 속도 비교
one <- data.frame(c(x = c(1:1000000), y = c(1:1000000)))
two <- data.frame(c(x = c(1:1000000), y = c(1:1000000)))
system.time(bind_rows(one, two))
system.time(rbind(one, two))
system.time(cbind(one, two))
system.time(bind_cols(one, two))


#7. 시각화(Visualization)####

#7.1 데이터 셋 불러오기####
mpg #차량 연비에 관련된 데이터
help(mpg)

#7.2 엔진 종류와 주행 거리와의 그래프 그리기####
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) #displ은 engine 연비(displacement)를 hwy,고속도로 주행거리를 의미

#데이터 입력 형태
#ggplot(data = <DATA>) + 
 # <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

#7.3 차종별로 색깔 다르게 표시하기####
#7.3.1 클래스 기준으로 색깔 표시하기
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) #(If you prefer British English, like Hadley, you can use colour instead of color.)


#7.3.2 클래스 기준으로 사이즈 표시하기
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))


#7.3.3 파란색으로 표시하기
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))



#7.3.4. 투명도로 표시하기
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

#7.3.5 기호로 표시하기
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))


#7.4 Facet: 데이터별로 비교하기####
#7.4.1 변수 하나만 적용해서 구분하기
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2) #차종 기준

#7.4.2 변수 두개 적용해서 구분하기, 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl) #구동방식과 실린더 기준


#7.5 geom을 활용한 다양한 표현법####
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

#7.5.1 line type 적용하기
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))


#7.6. 여러개의 그래프 형식 합치기####
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) +
  geom_smooth()


#7.7. 특정 데이터만 추출해서 표현하기####
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)
