df <- read.csv("./output/example.csv")

# Only use observations with no intervention
tmp <- subset(df, df$group == 'base')

# Cashflow per phase
tmp$cash0 <- tmp$revenue0 - tmp$cost0
tmp$cash1 <- tmp$revenue1 - tmp$cost1
tmp$cash2 <- tmp$revenue2 - tmp$cost2
tmp$cash3 <- tmp$revenue3 - tmp$cost3
tmp$cash4 <- tmp$revenue4 - tmp$cost4
tmp$cash5 <- tmp$revenue5 - tmp$cost5
tmp$cash6 <- tmp$revenue6 - tmp$cost6
tmp$cash7 <- tmp$revenue7 - tmp$cost7
tmp$cash8 <- tmp$revenue8 - tmp$cost8
tmp$cash9 <- tmp$revenue9 - tmp$cost9
tmp$cash10 <- tmp$revenue10 - tmp$cost10
tmp$cash11 <- tmp$revenue11 - tmp$cost11
tmp$cash12 <- tmp$revenue12 - tmp$cost12
tmp$cash13 <- tmp$revenue13 - tmp$cost13
tmp$cash14 <- tmp$revenue14 - tmp$cost14
tmp$cash15 <- tmp$revenue15 - tmp$cost15

# Cumulative cashflow per phase
tmp$ccash0  <- tmp$cash0
tmp$ccash1  <- tmp$cash1  + tmp$ccash0
tmp$ccash2  <- tmp$cash2  + tmp$ccash1
tmp$ccash3  <- tmp$cash3  + tmp$ccash2
tmp$ccash4  <- tmp$cash4  + tmp$ccash3
tmp$ccash5  <- tmp$cash5  + tmp$ccash4
tmp$ccash6  <- tmp$cash6  + tmp$ccash5
tmp$ccash7  <- tmp$cash7  + tmp$ccash6
tmp$ccash8  <- tmp$cash8  + tmp$ccash7
tmp$ccash9  <- tmp$cash9  + tmp$ccash8
tmp$ccash10 <- tmp$cash10 + tmp$ccash9
tmp$ccash11 <- tmp$cash11 + tmp$ccash10
tmp$ccash12 <- tmp$cash12 + tmp$ccash11
tmp$ccash13 <- tmp$cash13 + tmp$ccash12
tmp$ccash14 <- tmp$cash14 + tmp$ccash13
tmp$ccash15 <- tmp$cash15 + tmp$ccash14

means = c(0, mean(tmp$ccash0), mean(tmp$ccash1), mean(tmp$ccash2), mean(tmp$ccash3), mean(tmp$ccash4), mean(tmp$ccash5), mean(tmp$ccash6), mean(tmp$ccash7), mean(tmp$ccash8), mean(tmp$ccash9), mean(tmp$ccash10), mean(tmp$ccash11), mean(tmp$ccash12), mean(tmp$ccash13), mean(tmp$ccash14), mean(tmp$ccash15))
mins  = c(0, min(tmp$ccash0),  min(tmp$ccash1),  min(tmp$ccash2),  min(tmp$ccash3),  min(tmp$ccash4),  min(tmp$ccash5),  min(tmp$ccash6),  min(tmp$ccash7),  min(tmp$ccash8),  min(tmp$ccash9),  min(tmp$ccash10),  min(tmp$ccash11),  min(tmp$ccash12),  min(tmp$ccash13),  min(tmp$ccash14),  min(tmp$ccash15))
maxes = c(0, max(tmp$ccash0),  max(tmp$ccash1),  max(tmp$ccash2),  max(tmp$ccash3),  max(tmp$ccash4),  max(tmp$ccash5),  max(tmp$ccash6),  max(tmp$ccash7),  max(tmp$ccash8),  max(tmp$ccash9),  max(tmp$ccash10),  max(tmp$ccash11),  max(tmp$ccash12),  max(tmp$ccash13),  max(tmp$ccash14),  max(tmp$ccash15))

plot(
  means,
  ylab = 'Cumulative cashflow (min / mean / max)',
  xlab = 'Development followed by sales',
  ylim = c(min(tmp$ccash4), max(tmp$ccash15)),
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
