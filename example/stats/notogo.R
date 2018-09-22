df <- read.csv("./output/example.csv")

# Reorder decision factors for better printing
df$decision0_f <- factor(df$decision0, levels(df$decision0)[c(2,1)])
df$decision1_f <- factor(df$decision1, levels(df$decision1)[c(2,1)])
df$decision2_f <- factor(df$decision2, levels(df$decision2)[c(2,1)])
df$decision3_f <- factor(df$decision3, levels(df$decision3)[c(2,1)])
df$decision4_f <- factor(df$decision4, levels(df$decision4)[c(2,1)])
df$decision5_f <- factor(df$decision5, levels(df$decision5)[c(2,1)])

# Create with-intervention subset but don't rename the ID column
dfi <- subset(df, df$group == 'i1_')
colnames(dfi) <- paste('i1_', colnames(dfi), sep='')
names(dfi)[names(dfi) == 'i1_id'] <- 'id'

# Create without intervention subset
dfb <- subset(df, df$group == 'base')

# Merge the two subsets
tmp <- merge(dfb, dfi, by='id')

# Pre-compute input ranges for printing
discount_rates = paste('[', min(tmp$discount_rate), ',', max(tmp$discount_rate), ']', sep='')
thresholds     = paste('[', min(tmp$threshold), ',', max(tmp$threshold), ']', sep='')

# Find phase specific intervention spends
tmp$p0_intervention_spend  <- (tmp$cost0  - tmp$i1_cost0)  + (tmp$i1_revenue0  - tmp$revenue0)
tmp$p1_intervention_spend  <- (tmp$cost1  - tmp$i1_cost1)  + (tmp$i1_revenue1  - tmp$revenue1)
tmp$p2_intervention_spend  <- (tmp$cost2  - tmp$i1_cost2)  + (tmp$i1_revenue2  - tmp$revenue2)
tmp$p3_intervention_spend  <- (tmp$cost3  - tmp$i1_cost3)  + (tmp$i1_revenue3  - tmp$revenue3)
tmp$p4_intervention_spend  <- (tmp$cost4  - tmp$i1_cost4)  + (tmp$i1_revenue4  - tmp$revenue4)
tmp$p5_intervention_spend  <- (tmp$cost5  - tmp$i1_cost5)  + (tmp$i1_revenue5  - tmp$revenue5)
tmp$p6_intervention_spend  <- (tmp$cost6  - tmp$i1_cost6)  + (tmp$i1_revenue6  - tmp$revenue6)
tmp$p7_intervention_spend  <- (tmp$cost7  - tmp$i1_cost7)  + (tmp$i1_revenue7  - tmp$revenue7)
tmp$p8_intervention_spend  <- (tmp$cost8  - tmp$i1_cost8)  + (tmp$i1_revenue8  - tmp$revenue8)
tmp$p9_intervention_spend  <- (tmp$cost9  - tmp$i1_cost9)  + (tmp$i1_revenue9  - tmp$revenue9)
tmp$p10_intervention_spend <- (tmp$cost10 - tmp$i1_cost10) + (tmp$i1_revenue10 - tmp$revenue10)
tmp$p11_intervention_spend <- (tmp$cost11 - tmp$i1_cost11) + (tmp$i1_revenue11 - tmp$revenue11)
tmp$p12_intervention_spend <- (tmp$cost12 - tmp$i1_cost12) + (tmp$i1_revenue12 - tmp$revenue12)
tmp$p13_intervention_spend <- (tmp$cost13 - tmp$i1_cost13) + (tmp$i1_revenue13 - tmp$revenue13)
tmp$p14_intervention_spend <- (tmp$cost14 - tmp$i1_cost14) + (tmp$i1_revenue14 - tmp$revenue14)
tmp$p15_intervention_spend <- (tmp$cost15 - tmp$i1_cost15) + (tmp$i1_revenue15 - tmp$revenue15)

# Sum up intervention spend
tmp$intervention_spend <-
  tmp$p0_intervention_spend +
  tmp$p1_intervention_spend +
  tmp$p2_intervention_spend +
  tmp$p3_intervention_spend +
  tmp$p4_intervention_spend +
  tmp$p5_intervention_spend +
  tmp$p6_intervention_spend +
  tmp$p7_intervention_spend +
  tmp$p8_intervention_spend +
  tmp$p9_intervention_spend +
  tmp$p10_intervention_spend +
  tmp$p11_intervention_spend +
  tmp$p12_intervention_spend +
  tmp$p13_intervention_spend +
  tmp$p14_intervention_spend +
  tmp$p15_intervention_spend

# Bin intervention sizes
mround <- function(x,base){  base * round(x / base) } # round to nearest
bins = 50
bin_size = round((max(tmp$intervention_spend) - min(tmp$intervention_spend)) / bins)
tmp$intervention_spend_bin <- mround(tmp$intervention_spend, bin_size)

# Create intervention phase specific subsets
tmpi0 <- subset(tmp, tmp$p0_intervention_spend > 0)
tmpi1 <- subset(tmp, tmp$p1_intervention_spend > 0)
tmpi2 <- subset(tmp, tmp$p2_intervention_spend > 0)
tmpi3 <- subset(tmp, tmp$p3_intervention_spend > 0)
tmpi4 <- subset(tmp, tmp$p4_intervention_spend > 0)
tmpi5 <- subset(tmp, tmp$p5_intervention_spend > 0)

# Convert to percentage (used in 'apply')
to_percentage = function(x){ x * 100 / sum(x) }

# https://stackoverflow.com/questions/20318034/keep-r-from-graphing-a-line-outside-of-a-charts-area
par(xpd=FALSE)

# Percentage of go/no-go decisions under different intervention sizes

tbl_i1_0_decision = apply(table(tmpi0$i1_decision0_f, tmpi0$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_0_decision, las = 2, xlab = paste('PC reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_1_decision = apply(table(tmpi1$i1_decision0_f, tmpi1$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_1_decision, las = 2, xlab = paste('P1 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_2_decision = apply(table(tmpi2$i1_decision0_f, tmpi2$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_2_decision, las = 2, xlab = paste('P2 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_3_decision = apply(table(tmpi3$i1_decision0_f, tmpi3$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_3_decision, las = 2, xlab = paste('P3 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_4_decision = apply(table(tmpi4$i1_decision0_f, tmpi4$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_4_decision, las = 2, xlab = paste('P4 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_5_decision = apply(table(tmpi5$i1_decision0_f, tmpi5$intervention_spend_bin), 2, to_percentage)
barplot(tbl_i1_5_decision, las  = 2, xlab = paste('Market reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

