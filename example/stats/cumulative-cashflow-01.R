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

boxplot(df$ccash0, df$ccash1, df$ccash2, df$ccash3, df$ccash4, df$ccash5, df$ccash6, df$ccash7, df$ccash8, df$ccash9, df$ccash10, df$ccash11, df$ccash12, df$ccash13, df$ccash14, df$ccash15,
        las = 1,
        xlab = 'Development followed by sales',
        ylab = 'Cumulative cashflow')

axis(1, at = seq(1,17), labels = c('PC','P1','P2','P3','P4',seq(0,11)))

