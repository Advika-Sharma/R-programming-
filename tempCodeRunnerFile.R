library(ggplot2)

data <- data.frame(
  x = c(1, 2, 3, 4),
  y = c(5, 6, 7, 8),
  group = c("A", "B", "B", "A")
)

ggplot(data, aes(x = x, y = y, color = group)) +
  geom_point() +
  xlab("x axis") + 
  ylab("y axis") +
  ggtitle("scatter plot") +
  theme_bw()+
  theme(legend.position = "top",
    axis.text.x=element_text(size=12, angle = 45))
    scale_color_manual(values=c("red","green"))
