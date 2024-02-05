xx=read_rds("player.rds")

links=xx$.

finallist=list()

for (i in 13:length(links)) {
  a=read_html(links[i])
  data1 = a %>% html_nodes("#first-row > div:nth-child(2) > table") %>% html_nodes("span.alignright.bold") %>% html_text()
  data2 = a %>% html_nodes("#first-row > div:nth-child(3) > table") %>% html_nodes("span.alignright.bold") %>% html_text()
  dm = c(data1,data2) %>% t()
  asd=data.frame(cbind(links[i],dm))

  df = a %>% html_nodes("body > div.container-main > div.container > article > div.bg-grey-light.fc24.player-card-bg.mb-3 > div") %>% html_table() %>% as.data.frame() %>% separate(X1, into = c("Attribute", "Value"), sep = " (?=[0-9])", convert = TRUE)
  transposed_df <- as.data.frame(t(df), stringsAsFactors = FALSE) # Keep strings as characters
  names(transposed_df) <- transposed_df[1,]
  transposed_df <- transposed_df[-1,]
  findf=cbind(asd,transposed_df)

  finallist = bind_rows(finallist,findf)
  cat(i,"\n")
}