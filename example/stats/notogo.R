df <- read.csv("./output/example.csv")

# Reorder decision factors for better printing
df$decision0_f <- factor(df$decision0, levels(df$decision0)[c(2,1)])
df$decision1_f <- factor(df$decision1, levels(df$decision1)[c(2,1)])
df$decision2_f <- factor(df$decision2, levels(df$decision2)[c(2,1)])
df$decision3_f <- factor(df$decision3, levels(df$decision3)[c(2,1)])
df$decision4_f <- factor(df$decision4, levels(df$decision4)[c(2,1)])
df$decision5_f <- factor(df$decision5, levels(df$decision5)[c(2,1)])

# Create without intervention subset
tmp0 <- subset(df, df$group == 'base')

# Create with-intervention subset but don't rename the ID column
tmp1 <- subset(df, df$group == 'prize')
colnames(tmp1) <- paste('x', colnames(tmp1), sep='')
names(tmp1)[names(tmp1) == 'xid'] <- 'id'

# Merge the two subsets
tmp <- merge(tmp0, tmp1, by='id')

# Pre-compute input ranges for printing
discount_rates = paste('[', min(tmp$discount_rate), ',', max(tmp$discount_rate), ']', sep='')
thresholds     = paste('[', min(tmp$threshold), ',', max(tmp$threshold), ']', sep='')

# Find phase specific intervention spends
tmp$p0_intervention_spend  <- (tmp$cost0  - tmp$xcost0)  + (tmp$xrevenue0  - tmp$revenue0)
tmp$p1_intervention_spend  <- (tmp$cost1  - tmp$xcost1)  + (tmp$xrevenue1  - tmp$revenue1)
tmp$p2_intervention_spend  <- (tmp$cost2  - tmp$xcost2)  + (tmp$xrevenue2  - tmp$revenue2)
tmp$p3_intervention_spend  <- (tmp$cost3  - tmp$xcost3)  + (tmp$xrevenue3  - tmp$revenue3)
tmp$p4_intervention_spend  <- (tmp$cost4  - tmp$xcost4)  + (tmp$xrevenue4  - tmp$revenue4)
tmp$p5_intervention_spend  <- (tmp$cost5  - tmp$xcost5)  + (tmp$xrevenue5  - tmp$revenue5)
tmp$p6_intervention_spend  <- (tmp$cost6  - tmp$xcost6)  + (tmp$xrevenue6  - tmp$revenue6)
tmp$p7_intervention_spend  <- (tmp$cost7  - tmp$xcost7)  + (tmp$xrevenue7  - tmp$revenue7)
tmp$p8_intervention_spend  <- (tmp$cost8  - tmp$xcost8)  + (tmp$xrevenue8  - tmp$revenue8)
tmp$p9_intervention_spend  <- (tmp$cost9  - tmp$xcost9)  + (tmp$xrevenue9  - tmp$revenue9)
tmp$p10_intervention_spend <- (tmp$cost10 - tmp$xcost10) + (tmp$xrevenue10 - tmp$revenue10)
tmp$p11_intervention_spend <- (tmp$cost11 - tmp$xcost11) + (tmp$xrevenue11 - tmp$revenue11)
tmp$p12_intervention_spend <- (tmp$cost12 - tmp$xcost12) + (tmp$xrevenue12 - tmp$revenue12)
tmp$p13_intervention_spend <- (tmp$cost13 - tmp$xcost13) + (tmp$xrevenue13 - tmp$revenue13)
tmp$p14_intervention_spend <- (tmp$cost14 - tmp$xcost14) + (tmp$xrevenue14 - tmp$revenue14)
tmp$p15_intervention_spend <- (tmp$cost15 - tmp$xcost15) + (tmp$xrevenue15 - tmp$revenue15)

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

tbl_x0_decision = apply(table(tmpi0$xdecision0_f, tmpi0$intervention_spend_bin), 2, to_percentage)
barplot(tbl_x0_decision, las = 2, xlab = paste('PC reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_x1_decision = apply(table(tmpi1$xdecision0_f, tmpi1$intervention_spend_bin), 2, to_percentage)
barplot(tbl_x1_decision, las = 2, xlab = paste('P1 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_x2_decision = apply(table(tmpi2$xdecision0_f, tmpi2$intervention_spend_bin), 2, to_percentage)
barplot(tbl_x2_decision, las = 2, xlab = paste('P2 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_x3_decision = apply(table(tmpi3$xdecision0_f, tmpi3$intervention_spend_bin), 2, to_percentage)
barplot(tbl_x3_decision, las = 2, xlab = paste('P3 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_x4_decision = apply(table(tmpi4$xdecision0_f, tmpi4$intervention_spend_bin), 2, to_percentage)
barplot(tbl_x4_decision, las = 2, xlab = paste('P4 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_x5_decision = apply(table(tmpi5$xdecision0_f, tmpi5$intervention_spend_bin), 2, to_percentage)
barplot(tbl_x5_decision, las  = 2, xlab = paste('Market reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

