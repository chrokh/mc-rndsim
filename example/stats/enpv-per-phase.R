#install.packages('elliplot')
library(elliplot)

df <- read.csv("./output/example.csv")



# PLOT 1
# ======

boxplot(df$enpv0, df$enpv1, df$enpv2, df$enpv3, df$enpv4, df$enpv5,
        ylab = 'ENPV upon entering phase',
        xlab = 'Development followed by sales',
        las = 1,
        xaxt = 'n',
        col = 'bisque1',
        type = 'n'
        )
axis(1, at = seq(1,6), labels = c('PC','P1','P2','P3','P4','Market'))



# PLOT 2
# ======

mins  <- c(min(df$enpv0),  min(df$enpv1),  min(df$enpv2),  min(df$enpv3),  min(df$enpv4),  min(df$enpv5))
means <- c(mean(df$enpv0), mean(df$enpv1), mean(df$enpv2), mean(df$enpv3), mean(df$enpv4), mean(df$enpv5))
maxes <- c(max(df$enpv0),  max(df$enpv1),  max(df$enpv2),  max(df$enpv3),  max(df$enpv4),  max(df$enpv5))

q1s <- c(quantile(df$enpv0)[2], quantile(df$enpv1)[2], quantile(df$enpv2)[2], quantile(df$enpv3)[2], quantile(df$enpv4)[2], quantile(df$enpv5)[2])
q2s <- c(quantile(df$enpv0)[3], quantile(df$enpv1)[3], quantile(df$enpv2)[3], quantile(df$enpv3)[3], quantile(df$enpv4)[3], quantile(df$enpv5)[3])
q3s <- c(quantile(df$enpv0)[4], quantile(df$enpv1)[4], quantile(df$enpv2)[4], quantile(df$enpv3)[4], quantile(df$enpv4)[4], quantile(df$enpv5)[4])

plot(
  seq(0,5),
  ylab = 'ENPV quartiles',
  xlab = 'Development followed by sales',
  ylim = c(min(df$enpv0,df$enpv1,df$enpv2,df$enpv3,df$enpv4,df$enpv5), max(df$enpv5)),
  las = 1,
  xaxt = 'n',
  type = 'n'
)

axis(1, at = seq(1,6), labels = c('PC','P1','P2','P3','P4','Market'))

polygon(c(seq(1,6), rev(seq(1,6))), c(mins, rev(q1s)), col = 'lightblue', border = NA)
polygon(c(seq(1,6), rev(seq(1,6))), c(q1s, rev(q3s)), col = 'dodgerblue2', border = NA)
polygon(c(seq(1,6), rev(seq(1,6))), c(q3s, rev(maxes)), col = 'lightblue', border = NA)

lines(means, col = 'black', lwd = 1)

abline(0,0, col='black', lty=2)



# PLOT 3
# ======

n1s <- c(ninenum(df$enpv0)[1], ninenum(df$enpv1)[1], ninenum(df$enpv2)[1], ninenum(df$enpv3)[1], ninenum(df$enpv4)[1], ninenum(df$enpv5)[1])
n2s <- c(ninenum(df$enpv0)[2], ninenum(df$enpv1)[2], ninenum(df$enpv2)[2], ninenum(df$enpv3)[2], ninenum(df$enpv4)[2], ninenum(df$enpv5)[2])
n3s <- c(ninenum(df$enpv0)[3], ninenum(df$enpv1)[3], ninenum(df$enpv2)[3], ninenum(df$enpv3)[3], ninenum(df$enpv4)[3], ninenum(df$enpv5)[3])
n4s <- c(ninenum(df$enpv0)[4], ninenum(df$enpv1)[4], ninenum(df$enpv2)[4], ninenum(df$enpv3)[4], ninenum(df$enpv4)[4], ninenum(df$enpv5)[4])
n5s <- c(ninenum(df$enpv0)[5], ninenum(df$enpv1)[5], ninenum(df$enpv2)[5], ninenum(df$enpv3)[5], ninenum(df$enpv4)[5], ninenum(df$enpv5)[5])
n6s <- c(ninenum(df$enpv0)[6], ninenum(df$enpv1)[6], ninenum(df$enpv2)[6], ninenum(df$enpv3)[6], ninenum(df$enpv4)[6], ninenum(df$enpv5)[6])
n7s <- c(ninenum(df$enpv0)[7], ninenum(df$enpv1)[7], ninenum(df$enpv2)[7], ninenum(df$enpv3)[7], ninenum(df$enpv4)[7], ninenum(df$enpv5)[7])
n8s <- c(ninenum(df$enpv0)[8], ninenum(df$enpv1)[8], ninenum(df$enpv2)[8], ninenum(df$enpv3)[8], ninenum(df$enpv4)[8], ninenum(df$enpv5)[8])
n9s <- c(ninenum(df$enpv0)[9], ninenum(df$enpv1)[9], ninenum(df$enpv2)[9], ninenum(df$enpv3)[9], ninenum(df$enpv4)[9], ninenum(df$enpv5)[9])

plot(
  seq(0,5),
  ylab = 'ENPV octiles',
  xlab = 'Development followed by sales',
  ylim = c(min(df$enpv0,df$enpv1,df$enpv2,df$enpv3,df$enpv4,df$enpv5), max(df$enpv5)),
  las = 1,
  xaxt = 'n',
  type = 'n'
)

axis(1, at = seq(1,6), labels = c('PC','P1','P2','P3','P4','Market'))

polygon(c(seq(1,6), rev(seq(1,6))), c(n1s, rev(n9s)), col = 'lightblue', border = NA)
polygon(c(seq(1,6), rev(seq(1,6))), c(n2s, rev(n8s)), col = 'dodgerblue1', border = NA)
polygon(c(seq(1,6), rev(seq(1,6))), c(n3s, rev(n7s)), col = 'dodgerblue3', border = NA)
polygon(c(seq(1,6), rev(seq(1,6))), c(n4s, rev(n6s)), col = 'dodgerblue4', border = NA)

lines(means, col = 'black', lwd = 1)

abline(0,0, col='black', lty=2)

