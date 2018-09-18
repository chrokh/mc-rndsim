df <- read.csv("./output/example.csv")

# Cashflow per phase
df$cash0 <- df$revenue0 - df$cost0
df$cash1 <- df$revenue1 - df$cost1
df$cash2 <- df$revenue2 - df$cost2
df$cash3 <- df$revenue3 - df$cost3
df$cash4 <- df$revenue4 - df$cost4
df$cash5 <- df$revenue5 - df$cost5
df$cash6 <- df$revenue6 - df$cost6
df$cash7 <- df$revenue7 - df$cost7
df$cash8 <- df$revenue8 - df$cost8
df$cash9 <- df$revenue9 - df$cost9
df$cash10 <- df$revenue10 - df$cost10
df$cash11 <- df$revenue11 - df$cost11
df$cash12 <- df$revenue12 - df$cost12
df$cash13 <- df$revenue13 - df$cost13
df$cash14 <- df$revenue14 - df$cost14
df$cash15 <- df$revenue15 - df$cost15

# Cumulative cashflow per phase
df$ccash0  <- df$cash0
df$ccash1  <- df$cash1  + df$ccash0
df$ccash2  <- df$cash2  + df$ccash1
df$ccash3  <- df$cash3  + df$ccash2
df$ccash4  <- df$cash4  + df$ccash3
df$ccash5  <- df$cash5  + df$ccash4
df$ccash6  <- df$cash6  + df$ccash5
df$ccash7  <- df$cash7  + df$ccash6
df$ccash8  <- df$cash8  + df$ccash7
df$ccash9  <- df$cash9  + df$ccash8
df$ccash10 <- df$cash10 + df$ccash9
df$ccash11 <- df$cash11 + df$ccash10
df$ccash12 <- df$cash12 + df$ccash11
df$ccash13 <- df$cash13 + df$ccash12
df$ccash14 <- df$cash14 + df$ccash13
df$ccash15 <- df$cash15 + df$ccash14

means = c(0, mean(df$ccash0), mean(df$ccash1), mean(df$ccash2), mean(df$ccash3), mean(df$ccash4), mean(df$ccash5), mean(df$ccash6), mean(df$ccash7), mean(df$ccash8), mean(df$ccash9), mean(df$ccash10), mean(df$ccash11), mean(df$ccash12), mean(df$ccash13), mean(df$ccash14), mean(df$ccash15))
mins  = c(0, min(df$ccash0),  min(df$ccash1),  min(df$ccash2),  min(df$ccash3),  min(df$ccash4),  min(df$ccash5),  min(df$ccash6),  min(df$ccash7),  min(df$ccash8),  min(df$ccash9),  min(df$ccash10),  min(df$ccash11),  min(df$ccash12),  min(df$ccash13),  min(df$ccash14),  min(df$ccash15))
maxes = c(0, max(df$ccash0),  max(df$ccash1),  max(df$ccash2),  max(df$ccash3),  max(df$ccash4),  max(df$ccash5),  max(df$ccash6),  max(df$ccash7),  max(df$ccash8),  max(df$ccash9),  max(df$ccash10),  max(df$ccash11),  max(df$ccash12),  max(df$ccash13),  max(df$ccash14),  max(df$ccash15))

plot(
  means,
  ylab = 'Cumulative cashflow (min / mean / max)',
  xlab = 'Development followed by sales',
  ylim = c(min(df$ccash4), max(df$ccash15)),
  las = 1,
  xaxt = 'n',
  type = 'n'
)

below0mins  = replace(mins,  mins>=0, 0)
below0maxes = replace(maxes, maxes>=0, 0)
above0mins  = replace(mins,  mins<0, 0)
above0maxes = replace(maxes, maxes<0, 0)

polygon(c(seq(1,17), rev(seq(1,17))), c(below0mins, rev(below0maxes)), col = 'pink', border = NA)
polygon(c(seq(1,17), rev(seq(1,17))), c(above0mins, rev(above0maxes)), col = 'lightgreen', border = NA)

axis(1, at = seq(1,17), labels = c('PC','P1','P2','P3','P4',seq(0,11)))
abline(0,0, lty = 2)

lines(mins,  lty = 1, col = 'black')
lines(means, lty = 1, col = 'black')
lines(maxes, lty = 1, col = 'black')
