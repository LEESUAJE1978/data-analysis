#1.패키지 설치하기 ####
install.packages('dplyr')
require(dplyr)

#2. 원하는 데이터 추출하기 filter ####
starwars %>%
  filter(species == "Droid")
starwars %>%
  select(name, ends_with("color"))
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
    mass = mean(mass, na.rm = TRUE),
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
