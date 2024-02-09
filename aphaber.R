library(rvest)
library(tidyverse)

a = read_html("https://www.airporthaber.com/kose-yazarlari/")

links = a %>% html_elements("a") %>% html_attr('href') 
links = links[str_detect(links, '/kose-yazilari/')]
links = links[str_detect(links, '.html')]


a = read_html("https://www.airporthaber.com/")

links = a %>% html_elements("a") %>% html_attr('href') 
linklist = links[5:45]
linklist= data.frame(link=paste0("https://www.airporthaber.com",linklist),baglanti=linklist)
#links = links %>% sub("havacilik-haberleri","haber/yorumlar",.)

alllinks=c()
for (i in 1:nrow(linklist)) {
  a = read_html(linklist[i,1])
  
  links = a %>% html_elements("a") %>% html_attr('href') 
  links = links[str_detect(links, linklist[i,2])]
  links = links[str_detect(links, '.html')] %>% unique()
  links = paste0("https://www.airporthaber.com",links)
  
  alllinks = rbind(alllinks,links)
  cat(i,"\n")
}
####################
####################
finaldf=list()

for (i in 1:length(links)) {
  
  mainlink = read_html(links[i]) %>% html_element(".comment-title") %>% html_elements("a") %>% html_attr('href') 
  
  if(length(mainlink) > 0){
    yenilink = paste0("https://www.airporthaber.com",mainlink)
    a = read_html(yenilink)
    
    user = a %>% html_elements("li") %>% html_element(".user") %>% html_text()
    comment_date = a %>% html_elements("li") %>% html_element(".comment_date") %>% html_text2() 
    comment = a %>% html_elements("li") %>% html_element(".the_comment") %>% html_text2()
    like = a %>% html_elements("li") %>% html_element(".like") %>% html_text()
    dislike = a %>% html_elements("li") %>% html_element(".dislike") %>% html_text()
    haberlink=links[i]
    haberheader= a %>% html_elements(".postData") %>% html_element("h1") %>% html_text2()
    
    df=cbind(user,comment_date,comment,like,dislike,haberlink,haberheader) %>% as.data.frame()
    finaldf = bind_rows(finaldf,df)
    cat(i," linkcalisti\n")
  }
  else{
    cat(i," linkbozuk\n")
  }
  
}

finaldf %>% write.xlsx("aphaber2.xlsx")

a=read_html("https://www.airporthaber.com/")
a 

linklist = links[5:45]
