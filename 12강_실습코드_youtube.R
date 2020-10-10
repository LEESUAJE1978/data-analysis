#0. 패키지 불러오기####
library(httr)
library(rvest)
library(RSelenium)

# port <- 50001L
# class( x = port)
# driver <- chrome(port = port, version = "85.0.4183.87")
# remote <- remoteDriver(port = port, browserName = 'chorome')
# remote$open()
# list_versions(appname ='chromedriver')

#1. 드라이버####
driver <- remoteDriver(remoteServerAddr = 'localhost', 
                     port = 50001L, # 포트번호 입력 
                     browserName = "chrome") 

driver$open() #서버에 연결
driver$navigate("https://www.youtube.com/watch?v=H8YW1tlsmE8") #이 홈페이지로 이동 

element <- driver$findElement("css", "body")

# Scroll down 10 times
for(i in 1:10){
  element$sendKeysToElement(list("key"="page_down"))
  if(exists("pagesource")){
    if(pagesource == driver$getPageSource()[[1]]){
      flag <- FALSE
      writeLines(paste0("Scrolled down ",n*counter," times.\n"))
      } else {
        pagesource <- driver$getPageSource()[[1]]
        }
    } else {
      pagesource <- driver$getPageSource()[[1]]
      }
  Sys.sleep(2) 
  }


html <- read_html(pagesource)

youtube_user_IDs <- html %>% html_nodes('div#header-author > a > span')
youtube_user_IDs <- youtube_user_IDs %>% html_text(trim = T)



youtube_user_comments <- html %>% html_nodes('yt-formatted-string#content-text')
youtube_user_comments <- youtube_user_coments %>% html_text(trim = T)

class(youtube_user_comments)
convert <- as.list(youtube_user_comments)
df <- as.data.frame(convert)
data.frame(lapply(youtube_user_comments, type.convert), stringsAsFactors = FALSE)
data.frame(lapply(youtube_user_IDs, type.convert), stringsAsFactors = FALSE)


#https://awesomeopensource.com/project/yusuzech/r-web-scraping-cheat-sheet
