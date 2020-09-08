#0. 패키지 불러오기####
require('tidyverse')
if(!require('data.table')){ #데이터 빠르게 읽어 오는 패키지
  install.packages("data.table")
  require('data.table')
}

if(!require('dlookr')){ 
  install.packages("dlookr")
  require('dlookr')
}

if(!require('plotly')){ 
  install.packages("plotly")
  require('plotly')
}

#1.데이터 불러오기####
campus = fread('campus recruit.csv')
str(data)


#2. 데이터 EDA####
dlookr::diagnose_report(campus, output_format = "html")
#file:///C:/Users/LEESUJAE/AppData/Local/Temp/RtmpywtVVk/Diagnosis_Report.html
dlookr::eda_report(campus, target = salary, output_format = "html")
#file:///C:/Users/LEESUJAE/AppData/Local/Temp/RtmpywtVVk/EDA_Report.html
help("diagnose_report")
help("eda_report")

#3. 시각화####
#3.1 MBA 성적과 Salary
colnames(campus)
f <- list(
  family = "Courier New, monospace",
  size = 18,
  color = "#7f7f7f"
)
x <- list(
  title = "Mba 성적",
  titlefont = f
)
y <- list(
  title = "전공",
  titlefont = f
)

fig <- plot_ly(data = campus, x= ~mba_p, y=~salary)
fig %>% layout(title = 'MBA성적 vs 연봉', xaxis =x , yaxis =y)

#3.2.MBA성적과 Salary와의 관계(전공별로)
fig <- plot_ly(data= campus,x=~mba_p, y = ~salary, color = ~specialisation)
fig %>% layout(title = 'MBA성적 vs 연봉 in 전공', xaxis =x , yaxis =y)


#3.3 전공별 MBA 성적 평균(Pie Chart)
df <- campus %>%
  group_by(specialisation) %>%
  summarise(avg = mean(mba_p))

fig <- plot_ly(data=df, labels = ~specialisation, values = ~avg, type ='pie',
               textposition = 'inside',
               textinfo = 'label+percent',
               insidetextfont = list(color = '#FFFFFF'),
               hoverinfo = 'text',
               marker = list(colors = colors,
                             line = list(color = '#FFFFFF', width = 1)))
fig <- fig %>% layout(title = '전공별 연봉 평균',
                      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

fig


#3.4 전공별 MBA 성적 분위 그래프(Box plot)
mba_p_1 = campus %>% filter(specialisation =="Mkt&Fin") %>% 
  select(mba_p)
mba_p_2 = campus %>% filter(specialisation =="Mkt&HR") %>% 
  select(mba_p)

#direct action
plot_ly(y=mba_p_1$mba_p, type = "box", quantilemethod = 'linear', name = 'mba_p_mkt&fin') %>% 
  add_trace(y = mba_p_2$mba_p, type = 'box', quantilemethod = 'linear', name = 'mba_p_mkt&HR') %>% 
  layout(title ="Distribution of percentage marks for specialisation -Mkt%Fin &  MKt&HR" )

#variable action
fig <- plot_ly(y=mba_p_1$mba_p, type = "box", quantilemethod = 'linear', name = 'mba_p_mkt&fin')
fig <- fig %>% add_trace(y = mba_p_2$mba_p, type = 'box', quantilemethod = 'linear', name = 'mba_p_mkt&HR')
fig <- fig %>% layout(title ="Distribution of percentage marks for specialisation -Mkt%Fn &  MKt&HR" )
fig


#3.5 연봉 분포도
#3.5.1. 히스토 그램
fig <- plot_ly(x = campus$salary, type = 'histogram')
fig

#3.5.2. 정규화 된 히스토 그램
fig <- plot_ly(x = campus$salary, type = 'histogram', histnorm = 'probability')
fig

#3.5.3. 히스토그램 겹쳐 그리기
fig <- plot_ly(alpha = 0.6)
fig <- fig %>% add_histogram(x= campus$salary)
fig <- fig %>% add_histogram(x= campus$salary, histnorm = 'probability')
fig <- fig %>% layout(barmode = "overlay") 
fig

#3.6 전공별 연봉 분포도
salary_HR <- campus %>% filter(specialisation == "Mkt&HR") %>% select(salary)
salary_Fin <- campus %>% filter(specialisation == "Mkt&Fin") %>% select(salary)

fig <- plot_ly(y=salary_HR$salary, type = 'box', quantilemethod = 'linear', name = 'HR_Salary')
fig <- fig %>% add_trace(y= salary_Fin$salary, type='box', quantilemethod= 'linear', name = 'Mkt_Salary')
fig <- fig %>% layout(title = 'Distribution of Salary for Specailasation')
fig

#Pop Quiz Mkt&fn와 Mkt&HR 샐러리 0.4M을 제거한 후 Box plot을 그려보세요


#3.7 중학교, 고등학교, 대학교 성적과 취업 여부 시각화(3D Scatter)
fig <- plot_ly(campus,  x= ~ssc_p, y=~hsc_p, z= ~degree_p, 
               marker = list(color = 'etest_p', colorscale= c('#FFE1A1', '#683531'), showscale = TRUE))
fig <- fig %>% add_markers()
fig <- fig %>% layout(scene = list(xaxis = list(title = 'ssc_p'),
                                   yaxis = list(title = 'hsc_p'),
                                   zaxis = list(title = 'degree_p')))
fig
