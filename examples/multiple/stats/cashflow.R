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

boxplot(
  tmp$cash0,
  tmp$cash1,
  tmp$cash2,
  tmp$cash3,
  tmp$cash4,
  tmp$cash5,
  tmp$cash6,
  tmp$cash7,
  tmp$cash8,
  tmp$cash9,
  tmp$cash10,
  tmp$cash11,
  tmp$cash12,
  tmp$cash13,
  tmp$cash14,
  tmp$cash15,
  col = 'bisque1',
  xlab = 'Development followed by sales',
  ylab = 'Cumulative cashflow'
)

axis(1, at = seq(1,17), labels = c('PC','P1','P2','P3','P4',seq(0,11)))

