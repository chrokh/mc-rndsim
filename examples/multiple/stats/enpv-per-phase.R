#install.packages('elliplot')
library(elliplot)

df <- read.csv("./output/example.csv")
tmp <- subset(df, df$group == 'base')



# PLOT 1
# ======

boxplot(tmp$enpv0, tmp$enpv1, tmp$enpv2, tmp$enpv3, tmp$enpv4, tmp$enpv5,
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

mins  <- c(min(tmp$enpv0),  min(tmp$enpv1),  min(tmp$enpv2),  min(tmp$enpv3),  min(tmp$enpv4),  min(tmp$enpv5))
means <- c(mean(tmp$enpv0), mean(tmp$enpv1), mean(tmp$enpv2), mean(tmp$enpv3), mean(tmp$enpv4), mean(tmp$enpv5))
maxes <- c(max(tmp$enpv0),  max(tmp$enpv1),  max(tmp$enpv2),  max(tmp$enpv3),  max(tmp$enpv4),  max(tmp$enpv5))

q1s <- c(quantile(tmp$enpv0)[2], quantile(tmp$enpv1)[2], quantile(tmp$enpv2)[2], quantile(tmp$enpv3)[2], quantile(tmp$enpv4)[2], quantile(tmp$enpv5)[2])
q2s <- c(quantile(tmp$enpv0)[3], quantile(tmp$enpv1)[3], quantile(tmp$enpv2)[3], quantile(tmp$enpv3)[3], quantile(tmp$enpv4)[3], quantile(tmp$enpv5)[3])
q3s <- c(quantile(tmp$enpv0)[4], quantile(tmp$enpv1)[4], quantile(tmp$enpv2)[4], quantile(tmp$enpv3)[4], quantile(tmp$enpv4)[4], quantile(tmp$enpv5)[4])

plot(
  seq(0,5),
  ylab = 'ENPV quartiles',
  xlab = 'Development followed by sales',
  ylim = c(min(tmp$enpv0,tmp$enpv1,tmp$enpv2,tmp$enpv3,tmp$enpv4,tmp$enpv5), max(tmp$enpv5)),
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

n1s <- c(ninenum(tmp$enpv0)[1], ninenum(tmp$enpv1)[1], ninenum(tmp$enpv2)[1], ninenum(tmp$enpv3)[1], ninenum(tmp$enpv4)[1], ninenum(tmp$enpv5)[1])
n2s <- c(ninenum(tmp$enpv0)[2], ninenum(tmp$enpv1)[2], ninenum(tmp$enpv2)[2], ninenum(tmp$enpv3)[2], ninenum(tmp$enpv4)[2], ninenum(tmp$enpv5)[2])
n3s <- c(ninenum(tmp$enpv0)[3], ninenum(tmp$enpv1)[3], ninenum(tmp$enpv2)[3], ninenum(tmp$enpv3)[3], ninenum(tmp$enpv4)[3], ninenum(tmp$enpv5)[3])
n4s <- c(ninenum(tmp$enpv0)[4], ninenum(tmp$enpv1)[4], ninenum(tmp$enpv2)[4], ninenum(tmp$enpv3)[4], ninenum(tmp$enpv4)[4], ninenum(tmp$enpv5)[4])
n5s <- c(ninenum(tmp$enpv0)[5], ninenum(tmp$enpv1)[5], ninenum(tmp$enpv2)[5], ninenum(tmp$enpv3)[5], ninenum(tmp$enpv4)[5], ninenum(tmp$enpv5)[5])
n6s <- c(ninenum(tmp$enpv0)[6], ninenum(tmp$enpv1)[6], ninenum(tmp$enpv2)[6], ninenum(tmp$enpv3)[6], ninenum(tmp$enpv4)[6], ninenum(tmp$enpv5)[6])
n7s <- c(ninenum(tmp$enpv0)[7], ninenum(tmp$enpv1)[7], ninenum(tmp$enpv2)[7], ninenum(tmp$enpv3)[7], ninenum(tmp$enpv4)[7], ninenum(tmp$enpv5)[7])
n8s <- c(ninenum(tmp$enpv0)[8], ninenum(tmp$enpv1)[8], ninenum(tmp$enpv2)[8], ninenum(tmp$enpv3)[8], ninenum(tmp$enpv4)[8], ninenum(tmp$enpv5)[8])
n9s <- c(ninenum(tmp$enpv0)[9], ninenum(tmp$enpv1)[9], ninenum(tmp$enpv2)[9], ninenum(tmp$enpv3)[9], ninenum(tmp$enpv4)[9], ninenum(tmp$enpv5)[9])

plot(
  seq(0,5),
  ylab = 'ENPV octiles',
  xlab = 'Development followed by sales',
  ylim = c(min(tmp$enpv0,tmp$enpv1,tmp$enpv2,tmp$enpv3,tmp$enpv4,tmp$enpv5), max(tmp$enpv5)),
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

