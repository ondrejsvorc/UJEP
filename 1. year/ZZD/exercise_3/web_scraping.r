# https://physics.ujep.cz/~jskvor/ZZD/ZZD-cv3.html

library(rvest)

html <- read_html(url("https://ki.ujep.cz/cs/historie/"))
vedouci <- html_table(html, header = TRUE)[[2]]

vedouci$Do[vedouci$Do == "Dosud"] <- "2024"

vedouci$Do <- as.integer(vedouci$Do)
vedouci$Od <- as.integer(vedouci$Od)

vedouci$Celkem_let <- vedouci$Do - vedouci$Od
serazene_vedouci <- vedouci[order(-vedouci$Celkem_let), ]

View(serazene_vedouci)