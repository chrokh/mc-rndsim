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

# Round to nearest function
mround <- function(x,base){  base * round(x / base) }

# Bin intervention sizes
bins = 50
bin_size = round((max(df$i1_intervention_operand) - min(df$i1_intervention_operand)) / bins)
df$i1_intervention_operand_bin <- mround(df$i1_intervention_operand, bin_size)

# Create intervention phase specific subsets
dfi0 <- subset(df, df$i1_intervention_phase == 0)
dfi1 <- subset(df, df$i1_intervention_phase == 1)
dfi2 <- subset(df, df$i1_intervention_phase == 2)
dfi3 <- subset(df, df$i1_intervention_phase == 3)
dfi4 <- subset(df, df$i1_intervention_phase == 4)
dfi5 <- subset(df, df$i1_intervention_phase == 5)

# Convert to percentage (used in 'apply')
to_percentage = function(x){ x * 100 / sum(x) }


# https://stackoverflow.com/questions/20318034/keep-r-from-graphing-a-line-outside-of-a-charts-area
par(xpd=FALSE)


# Percentage of go/no-go decisions under different intervention sizes

tbl_i1_0_decision = apply(table(dfi0$i1_decision0_f, dfi0$i1_intervention_operand_bin), 2, to_percentage)
barplot(tbl_i1_0_decision, las = 2, xlab = paste('PC reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_1_decision = apply(table(dfi1$i1_decision0_f, dfi1$i1_intervention_operand_bin), 2, to_percentage)
barplot(tbl_i1_1_decision, las = 2, xlab = paste('P1 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_2_decision = apply(table(dfi2$i1_decision0_f, dfi2$i1_intervention_operand_bin), 2, to_percentage)
barplot(tbl_i1_2_decision, las = 2, xlab = paste('P2 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_3_decision = apply(table(dfi3$i1_decision0_f, dfi3$i1_intervention_operand_bin), 2, to_percentage)
barplot(tbl_i1_3_decision, las = 2, xlab = paste('P3 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_4_decision = apply(table(dfi4$i1_decision0_f, dfi4$i1_intervention_operand_bin), 2, to_percentage)
barplot(tbl_i1_4_decision, las = 2, xlab = paste('P4 reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

tbl_i1_5_decision = apply(table(dfi5$i1_decision0_f, dfi5$i1_intervention_operand_bin), 2, to_percentage)
barplot(tbl_i1_5_decision, las  = 2, xlab = paste('Market reward ( +/-', bin_size, ')'), ylab = 'Percentage of PC no-go decisions', yaxt='n')
mtext(side=3, line = 1, text=paste('discount rate =', discount_rates, '   threshold =', thresholds))
axis(2, at = seq(0,100,by=10), las=2)
abline(h=seq(0,100,by=10), col='black', lty=3)

