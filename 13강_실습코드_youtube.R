#0. 패키지 불러오기####
library(httr)
library(rvest)
library(RSelenium)
library(rJava)
require(binman)
require(wdman)

#1. Selenium 실행- chrome 연결####
port <- 4445L #포트 설정
list_versions(appname ='chromedriver')
driver <- chrome(port = port, version = "85.0.4183.87")
driver <- remoteDriver(remoteServerAddr = 'localhost', 
                     port = port, # 포트번호 입력 
                     browserName = "chrome",
                     version = '85.0.4183.87') 
driver$open() #서버에 연결
driver$navigate("https://www.youtube.com/watch?v=H8YW1tlsmE8") #이 홈페이지로 이동 
driver$navigate("https://www.naver.com") #이 홈페이지로 이동 

#2.element 추출####
element <- driver$findElement("css", "body")

element <- driver$findElement("css", "body")
# Scroll down 10 times
for(i in 1:10){
  element$sendKeysToElement(list("key"="page_down"))
  # please make sure to sleep a couple of seconds to since it takes time to load contents
  Sys.sleep(2) 
}

#2.1 Scroll down n- times
element <- driver$findElement("css", "body")
# Scroll down 10 times

for(i in 1:2){
  element$sendKeysToElement(list("key"="page_down"))
  if(exists("pagesource")){
    if(pagesource == driver$getPageSource()[[1]]){
      #flag <- FALSE
      writeLines(paste0("Scrolled down ",n*counter," times.\n"))
      } else {
        pagesource <- driver$getPageSource()[[1]]
        }
    } else {
      pagesource <- driver$getPageSource()[[1]]
      }
  Sys.sleep(2) 
  }


#3. scraping:ID와 Comment 추출
html <- read_html(pagesource) #html 파일 가져오기

youtube_user_IDs <- html %>% html_nodes('div#header-author > a > span')
youtube_user_IDs <- youtube_user_IDs %>% html_text(trim = T)

youtube_user_comments <- html %>% html_nodes('yt-formatted-string#content-text')
youtube_user_comments <- youtube_user_comments %>% html_text(trim = T)

#4.데이터 프레임 생성####

df <-data.frame(youtube_user_IDs, youtube_user_comments)
head(df,2)

#5. csv파일 변환 ####
write.csv(df, 'comment.csv')

#https://awesomeopensource.com/project/yusuzech/r-web-scraping-cheat-sheet
