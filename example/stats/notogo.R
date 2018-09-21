df <- read.csv("./output/example.csv")

# Reorder decision factors for better printing
df$i1_decision0_f <- factor(df$i1_decision0, levels(df$i1_decision0)[c(2,1)])
df$i1_decision1_f <- factor(df$i1_decision1, levels(df$i1_decision1)[c(2,1)])
df$i1_decision2_f <- factor(df$i1_decision2, levels(df$i1_decision2)[c(2,1)])
df$i1_decision3_f <- factor(df$i1_decision3, levels(df$i1_decision3)[c(2,1)])
df$i1_decision4_f <- factor(df$i1_decision4, levels(df$i1_decision4)[c(2,1)])
df$i1_decision5_f <- factor(df$i1_decision5, levels(df$i1_decision5)[c(2,1)])

# Pre-compute input ranges for printing
discount_rates = paste('[', min(df$discount_rate), ',', max(df$discount_rate), ']', sep='')
thresholds     = paste('[', min(df$threshold), ',', max(df$threshold), ']', sep='')

# Find phase specific intervention spends
df$p0_intervention_spend  <- (df$cost0  - df$i1_cost0)  + (df$i1_revenue0  - df$revenue0)
df$p1_intervention_spend  <- (df$cost1  - df$i1_cost1)  + (df$i1_revenue1  - df$revenue1)
df$p2_intervention_spend  <- (df$cost2  - df$i1_cost2)  + (df$i1_revenue2  - df$revenue2)
df$p3_intervention_spend  <- (df$cost3  - df$i1_cost3)  + (df$i1_revenue3  - df$revenue3)
df$p4_intervention_spend  <- (df$cost4  - df$i1_cost4)  + (df$i1_revenue4  - df$revenue4)
df$p5_intervention_spend  <- (df$cost5  - df$i1_cost5)  + (df$i1_revenue5  - df$revenue5)
df$p6_intervention_spend  <- (df$cost6  - df$i1_cost6)  + (df$i1_revenue6  - df$revenue6)
df$p7_intervention_spend  <- (df$cost7  - df$i1_cost7)  + (df$i1_revenue7  - df$revenue7)
df$p8_intervention_spend  <- (df$cost8  - df$i1_cost8)  + (df$i1_revenue8  - df$revenue8)
df$p9_intervention_spend  <- (df$cost9  - df$i1_cost9)  + (df$i1_revenue9  - df$revenue9)
df$p10_intervention_spend <- (df$cost10 - df$i1_cost10) + (df$i1_revenue10 - df$revenue10)
df$p11_intervention_spend <- (df$cost11 - df$i1_cost11) + (df$i1_revenue11 - df$revenue11)
df$p12_intervention_spend <- (df$cost12 - df$i1_cost12) + (df$i1_revenue12 - df$revenue12)
df$p13_intervention_spend <- (df$cost13 - df$i1_cost13) + (df$i1_revenue13 - df$revenue13)
df$p14_intervention_spend <- (df$cost14 - df$i1_cost14) + (df$i1_revenue14 - df$revenue14)
df$p15_intervention_spend <- (df$cost15 - df$i1_cost15) + (df$i1_revenue15 - df$revenue15)

# Sum up intervention spend
df$intervention_spend <-
  df$p0_intervention_spend +
  df$p1_intervention_spend +
  df$p2_intervention_spend +
  df$p3_intervention_spend +
  df$p4_intervention_spend +
  df$p5_intervention_spend +
  df$p6_intervention_spend +
  df$p7_intervention_spend +
  df$p8_intervention_spend +
  df$p9_intervention_spend +
  df$p10_intervention_spend +
  df$p11_intervention_spend +
  df$p12_intervention_spend +
  df$p13_intervention_spend +
  df$p14_intervention_spend +
  df$p15_intervention_spend

# Bin intervention sizes
mround <- function(x,base){  base * round(x / base) } # round to nearest
bins = 50
bin_size = round((max(df$intervention_spend) - min(df$intervention_spend)) / bins)
df$intervention_spend_bin <- mround(df$intervention_spend, bin_size)

# Create intervention phase specific subsets
dfi0 <- subset(df, df$p0_intervention_spend > 0)
dfi1 <- subset(df, df$p1_intervention_spend > 0)
dfi2 <- subset(df, df$p2_intervention_spend > 0)
dfi3 <- subset(df, df$p3_intervention_spend > 0)
dfi4 <- subset(df, df$p4_intervention_spend > 0)
dfi5 <- subset(df, df$p5_intervention_spend > 0)

# Convert to percentage (used in 'apply')
to_percentage = function(x){ x * 100 / sum(x) }

# https://stackoverflow.com/questions/20318034/keep-r-from-graphing-a-line-outside-of-a-charts-area
par(xpd=FALSE)

# Percentage of go/no-go decisions under different intervention sizes

tbl_i1_0_decision = apply(table(dfi0$i1_decision0_f, dfi0$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_0_decision, las = 2, xlab = paste('PC reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_1_decision = apply(table(dfi1$i1_decision0_f, dfi1$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_1_decision, las = 2, xlab = paste('P1 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_2_decision = apply(table(dfi2$i1_decision0_f, dfi2$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_2_decision, las = 2, xlab = paste('P2 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_3_decision = apply(table(dfi3$i1_decision0_f, dfi3$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_3_decision, las = 2, xlab = paste('P3 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_4_decision = apply(table(dfi4$i1_decision0_f, dfi4$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_4_decision, las = 2, xlab = paste('P4 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_5_decision = apply(table(dfi5$i1_decision0_f, dfi5$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_5_decision, las  = 2, xlab = paste('Market reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

