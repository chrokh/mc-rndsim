df <- read.csv("./output/example.csv")

medians  = c(median(df$enpv0), median(df$enpv1), median(df$enpv2), median(df$enpv3), median(df$enpv4), median(df$enpv5))
means    = c(mean(df$enpv0),   mean(df$enpv1),   mean(df$enpv2),   mean(df$enpv3),   mean(df$enpv4),   mean(df$enpv5))
mins     = c(min(df$enpv0),    min(df$enpv1),    min(df$enpv2),    min(df$enpv3),    min(df$enpv4),    min(df$enpv5))
maxes    = c(max(df$enpv0),    max(df$enpv1),    max(df$enpv2),    max(df$enpv3),    max(df$enpv4),    max(df$enpv5))

plot(
  seq(0,5),
  ylab = 'ENPV',
  xlab = 'Development followed by sales',
  ylim = c(min(df$enpv0,df$enpv1,df$enpv2,df$enpv3,df$enpv4,df$enpv5), max(df$enpv5)),
  las = 1,
  xaxt = 'n',
  type = 'n'
)

polygon(c(seq(1,6), rev(seq(1,6))), c(mins, rep(0,6)), col = 'pink', border = NA)
polygon(c(seq(1,6), rev(seq(1,6))), c(rep(0,6), rev(maxes)), col = 'lightgreen', border = NA)

axis(1, at = seq(1,6), labels = c('PC','P1','P2','P3','P4','Market'))

lines(means,  col = 'black', lwd = 1)
lines(mins,  col = 'black', lty = 2)
lines(maxes, col = 'black', lty = 2)
