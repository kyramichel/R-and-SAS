library(tidyverse)

data = read.csv("data.csv", header=T)
data



fig1 = ggplot(data=data)+geom_bar(mapping = aes(x=Products, y=AbsDiff,fill=Products), stat = "identity", width=0.1)
fig1 + coord_flip()



fig2 = ggplot(data=data)+geom_bar(mapping = aes(x=Products, y=RelDiff, fill=Products), stat = "identity")
fig2 + coord_flip()
fig2 + coord_polar()