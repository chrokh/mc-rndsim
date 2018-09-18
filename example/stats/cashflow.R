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

boxplot(
  df$cash0,
  df$cash1,
  df$cash2,
  df$cash3,
  df$cash4,
  df$cash5,
  df$cash6,
  df$cash7,
  df$cash8,
  df$cash9,
  df$cash10,
  df$cash11,
  df$cash12,
  df$cash13,
  df$cash14,
  df$cash15,
  col = 'bisque1',
  xlab = 'Development followed by sales',
  ylab = 'Cumulative cashflow'
)

axis(1, at = seq(1,17), labels = c('PC','P1','P2','P3','P4',seq(0,11)))

