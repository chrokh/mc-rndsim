df <- read.csv("./output/example.csv")

# Compute ENPV diff
df$i1_enpv0diff <- df$i1_enpv0 - df$enpv0
df$i1_enpv0div <- (df$i1_enpv0 + abs(min(df$enpv0)) + 1) / (df$enpv0 + abs(min(df$enpv0)) + 1)

# Compute cashflows
df$cashflow0 <- df$revenue0 - df$cost0
df$cashflow1 <- df$revenue1 - df$cost1
df$cashflow2 <- df$revenue2 - df$cost2
df$cashflow3 <- df$revenue3 - df$cost3
df$cashflow4 <- df$revenue4 - df$cost4
df$cashflow5 <- df$revenue5 - df$cost5

df$i1_cashflow0 <- df$i1_revenue0 - df$i1_cost0
df$i1_cashflow1 <- df$i1_revenue1 - df$i1_cost1
df$i1_cashflow2 <- df$i1_revenue2 - df$i1_cost2
df$i1_cashflow3 <- df$i1_revenue3 - df$i1_cost3
df$i1_cashflow4 <- df$i1_revenue4 - df$i1_cost4
df$i1_cashflow5 <- df$i1_revenue5 - df$i1_cost5

# Compute phase specific intervention spends
df$i1_spend0 <- df$i1_cashflow0 - df$cashflow0
df$i1_spend1 <- df$i1_cashflow1 - df$cashflow1
df$i1_spend2 <- df$i1_cashflow2 - df$cashflow2
df$i1_spend3 <- df$i1_cashflow3 - df$cashflow3
df$i1_spend4 <- df$i1_cashflow4 - df$cashflow4
df$i1_spend5 <- df$i1_cashflow5 - df$cashflow5

# Compute probabilistic public spend
df$i1_prob_spend0 <- df$i1_spend0
df$i1_prob_spend1 <- df$i1_spend1 * df$i1_prob0
df$i1_prob_spend2 <- df$i1_spend2 * df$i1_prob0 * df$i1_prob1
df$i1_prob_spend3 <- df$i1_spend3 * df$i1_prob0 * df$i1_prob1 * df$i1_prob2
df$i1_prob_spend4 <- df$i1_spend4 * df$i1_prob0 * df$i1_prob1 * df$i1_prob2 * df$i1_prob3
df$i1_prob_spend5 <- df$i1_spend5 * df$i1_prob0 * df$i1_prob1 * df$i1_prob2 * df$i1_prob3 * df$i1_prob4

# Compute probabilities after risk of gaming
untruthfulness <- 0.3
df$i1_prob0_risky <- df$prob0 + (1-df$prob0) * untruthfulness
df$i1_prob1_risky <- df$prob1 + (1-df$prob1) * untruthfulness
df$i1_prob2_risky <- df$prob2 + (1-df$prob2) * untruthfulness
df$i1_prob3_risky <- df$prob3 + (1-df$prob3) * untruthfulness
df$i1_prob4_risky <- df$prob4 + (1-df$prob4) * untruthfulness
df$i1_prob5_risky <- df$prob5 + (1-df$prob5) * untruthfulness

# Compute probabilistic public spend after risk of gaming
df$i1_prob_spend0_risky <- df$i1_spend0
df$i1_prob_spend1_risky <- df$i1_spend1 * df$i1_prob0_risky
df$i1_prob_spend2_risky <- df$i1_spend2 * df$i1_prob0 * df$i1_prob1_risky
df$i1_prob_spend3_risky <- df$i1_spend3 * df$i1_prob0 * df$i1_prob1 * df$i1_prob2_risky
df$i1_prob_spend4_risky <- df$i1_spend4 * df$i1_prob0 * df$i1_prob1 * df$i1_prob2 * df$i1_prob3_risky
df$i1_prob_spend5_risky <- df$i1_spend5 * df$i1_prob0 * df$i1_prob1 * df$i1_prob2 * df$i1_prob3 * df$i1_prob4_risky

# Subset per active phase intervention
i1_0 <- subset(df, df$i1_intervention_phase == 0)
i1_1 <- subset(df, df$i1_intervention_phase == 1)
i1_2 <- subset(df, df$i1_intervention_phase == 2)
i1_3 <- subset(df, df$i1_intervention_phase == 3)
i1_4 <- subset(df, df$i1_intervention_phase == 4)
i1_5 <- subset(df, df$i1_intervention_phase == 5)


# ===== Absolute ENPV improvement per spend

# Compute PC ENPV improvement per spend
i1_0$enpv0diff_per_spend <- i1_0$i1_enpv0diff / i1_0$i1_spend0
i1_1$enpv0diff_per_spend <- i1_1$i1_enpv0diff / i1_1$i1_spend1
i1_2$enpv0diff_per_spend <- i1_2$i1_enpv0diff / i1_2$i1_spend2
i1_3$enpv0diff_per_spend <- i1_3$i1_enpv0diff / i1_3$i1_spend3
i1_4$enpv0diff_per_spend <- i1_4$i1_enpv0diff / i1_4$i1_spend4
i1_5$enpv0diff_per_spend <- i1_5$i1_enpv0diff / i1_5$i1_spend5

# Compute PC ENPV improvement per probabilistic spend
i1_0$enpv0diff_per_prob_spend <- i1_0$i1_enpv0diff / i1_0$i1_prob_spend0
i1_1$enpv0diff_per_prob_spend <- i1_1$i1_enpv0diff / i1_1$i1_prob_spend1
i1_2$enpv0diff_per_prob_spend <- i1_2$i1_enpv0diff / i1_2$i1_prob_spend2
i1_3$enpv0diff_per_prob_spend <- i1_3$i1_enpv0diff / i1_3$i1_prob_spend3
i1_4$enpv0diff_per_prob_spend <- i1_4$i1_enpv0diff / i1_4$i1_prob_spend4
i1_5$enpv0diff_per_prob_spend <- i1_5$i1_enpv0diff / i1_5$i1_prob_spend5

# Compute PC ENPV improvement per probabilistic spend after risk of gaming
i1_0$enpv0diff_per_prob_spend_risky <- i1_0$i1_enpv0diff / i1_0$i1_prob_spend0_risky
i1_1$enpv0diff_per_prob_spend_risky <- i1_1$i1_enpv0diff / i1_1$i1_prob_spend1_risky
i1_2$enpv0diff_per_prob_spend_risky <- i1_2$i1_enpv0diff / i1_2$i1_prob_spend2_risky
i1_3$enpv0diff_per_prob_spend_risky <- i1_3$i1_enpv0diff / i1_3$i1_prob_spend3_risky
i1_4$enpv0diff_per_prob_spend_risky <- i1_4$i1_enpv0diff / i1_4$i1_prob_spend4_risky
i1_5$enpv0diff_per_prob_spend_risky <- i1_5$i1_enpv0diff / i1_5$i1_prob_spend5_risky


# ===== Relative ENPV improvement per spend

# Compute PC ENPV improvement per spend
i1_0$enpv0div_per_spend <- i1_0$i1_enpv0div / i1_0$i1_spend0
i1_1$enpv0div_per_spend <- i1_1$i1_enpv0div / i1_1$i1_spend1
i1_2$enpv0div_per_spend <- i1_2$i1_enpv0div / i1_2$i1_spend2
i1_3$enpv0div_per_spend <- i1_3$i1_enpv0div / i1_3$i1_spend3
i1_4$enpv0div_per_spend <- i1_4$i1_enpv0div / i1_4$i1_spend4
i1_5$enpv0div_per_spend <- i1_5$i1_enpv0div / i1_5$i1_spend5

# Compute PC ENPV improvement per probabilistic spend
i1_0$enpv0div_per_prob_spend <- i1_0$i1_enpv0div / i1_0$i1_prob_spend0
i1_1$enpv0div_per_prob_spend <- i1_1$i1_enpv0div / i1_1$i1_prob_spend1
i1_2$enpv0div_per_prob_spend <- i1_2$i1_enpv0div / i1_2$i1_prob_spend2
i1_3$enpv0div_per_prob_spend <- i1_3$i1_enpv0div / i1_3$i1_prob_spend3
i1_4$enpv0div_per_prob_spend <- i1_4$i1_enpv0div / i1_4$i1_prob_spend4
i1_5$enpv0div_per_prob_spend <- i1_5$i1_enpv0div / i1_5$i1_prob_spend5

# Compute PC ENPV improvement per probabilistic spend after risk of gaming
i1_0$enpv0div_per_prob_spend_risky <- i1_0$i1_enpv0div / i1_0$i1_prob_spend0_risky
i1_1$enpv0div_per_prob_spend_risky <- i1_1$i1_enpv0div / i1_1$i1_prob_spend1_risky
i1_2$enpv0div_per_prob_spend_risky <- i1_2$i1_enpv0div / i1_2$i1_prob_spend2_risky
i1_3$enpv0div_per_prob_spend_risky <- i1_3$i1_enpv0div / i1_3$i1_prob_spend3_risky
i1_4$enpv0div_per_prob_spend_risky <- i1_4$i1_enpv0div / i1_4$i1_prob_spend4_risky
i1_5$enpv0div_per_prob_spend_risky <- i1_5$i1_enpv0div / i1_5$i1_prob_spend5_risky

# =====  Subset on go decisions
gos <- subset(df, df$conseq_decision5 == 'true')


# ================ PLOTTING ===================

# ENPV per phase
boxplot(
  df$enpv0,
  df$enpv1,
  df$enpv2,
  df$enpv3,
  df$enpv4,
  df$enpv5,
  #outline = FALSE,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  main = "ENPV upon entering phase (without intervention)"
)

# ENPV per phase with and without intervention
boxplot(
  df$enpv0,
  df$i2_enpv0,
  df$i1_enpv0,
  df$enpv1,
  df$i2_enpv1,
  df$i1_enpv1,
  df$enpv2,
  df$i2_enpv2,
  df$i1_enpv2,
  df$enpv3,
  df$i2_enpv3,
  df$i1_enpv3,
  df$enpv4,
  df$i2_enpv4,
  df$i1_enpv4,
  df$enpv5,
  df$i2_enpv5,
  df$i1_enpv5,
  outline = FALSE,
  col = c("gold","lightgreen","lightblue"),
  las = 1,
  names = c('PC','PC','PC',1,1,1,2,2,2,3,3,3,4,4,4,'M','M','M'),
  main = "ENPV upon entering phase (without intervention)"
)

# ENPV per phase, when conseq yes
boxplot(
  gos$enpv0,
  gos$enpv1,
  gos$enpv2,
  gos$enpv3,
  gos$enpv4,
  gos$enpv5,
  #outline = FALSE,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  main = "ENPV upon entering phase (without intervention)"
)

# ENPV per phase with and without intervention, when conseq yes
boxplot(
  gos$enpv0,
  gos$i2_enpv0,
  gos$i1_enpv0,
  gos$enpv1,
  gos$i2_enpv1,
  gos$i1_enpv1,
  gos$enpv2,
  gos$i2_enpv2,
  gos$i1_enpv2,
  gos$enpv3,
  gos$i2_enpv3,
  gos$i1_enpv3,
  gos$enpv4,
  gos$i2_enpv4,
  gos$i1_enpv4,
  gos$enpv5,
  gos$i2_enpv5,
  gos$i1_enpv5,
  outline = FALSE,
  col = c("gold","lightgreen","lightblue"),
  las = 1,
  names = c('PC','PC','PC',1,1,1,2,2,2,3,3,3,4,4,4,'M','M','M'),
  main = "ENPV upon entering phase (without intervention) when conseq yes"
)


# ===== PC ENPV when PER is given in different phases

boxplot(
  i1_0$i1_enpv0,
  i1_1$i1_enpv0,
  i1_2$i1_enpv0,
  i1_3$i1_enpv0,
  i1_4$i1_enpv0,
  i1_5$i1_enpv0,
  df$enpv0,
  #outline = FALSE,
  col = c(rep('gold', 6), 'white'),
  names = c('PC',1,2,3,4,'M','None'),
  las = 1,
  main = 'PC ENPV when PER is promised in different phases'
)
mtext(side = 1, line = 2.5, text = paste(
  'PER range = [', min(df$i1_intervention_operand),
  ',', max(df$i1_intervention_operand),
  ']', sep=''
  ))
mtext(side = 1, line = 3.75, text = paste('Stdev PER =', sd(df$i1_intervention_operand)))



# ===== Absolute PC ENPV improvement

boxplot(
  i1_0$i1_enpv0diff,
  i1_1$i1_enpv0diff,
  i1_2$i1_enpv0diff,
  i1_3$i1_enpv0diff,
  i1_4$i1_enpv0diff,
  i1_5$i1_enpv0diff,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  #outline = FALSE,
  main = "PC ENPV improvement (absolute)"
)


# ===== Absolute ENPV improvement per spend

boxplot(
  i1_0$enpv0diff_per_spend,
  i1_1$enpv0diff_per_spend,
  i1_2$enpv0diff_per_spend,
  i1_3$enpv0diff_per_spend,
  i1_4$enpv0diff_per_spend,
  i1_5$enpv0diff_per_spend,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  #outline = FALSE,
  main = "PC ENPV improvement (absolute) per spend"
)

boxplot(
  i1_0$enpv0diff_per_prob_spend,
  i1_1$enpv0diff_per_prob_spend,
  i1_2$enpv0diff_per_prob_spend,
  i1_3$enpv0diff_per_prob_spend,
  i1_4$enpv0diff_per_prob_spend,
  i1_5$enpv0diff_per_prob_spend,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  main = "PC ENPV improvement (absolute) per probabilistic spend"
)

boxplot(
  i1_0$enpv0diff_per_prob_spend_risky,
  i1_1$enpv0diff_per_prob_spend_risky,
  i1_2$enpv0diff_per_prob_spend_risky,
  i1_3$enpv0diff_per_prob_spend_risky,
  i1_4$enpv0diff_per_prob_spend_risky,
  i1_5$enpv0diff_per_prob_spend_risky,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  outline = FALSE,
  main = paste("PC ENPV improvement (absolute) per prob spend, risk of gaming =", untruthfulness)
)



# ===== Relative ENPV improvement per spend

boxplot(
  i1_0$enpv0div_per_spend,
  i1_1$enpv0div_per_spend,
  i1_2$enpv0div_per_spend,
  i1_3$enpv0div_per_spend,
  i1_4$enpv0div_per_spend,
  i1_5$enpv0div_per_spend,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  outline = FALSE,
  main = "PC ENPV improvement (relative) per spend"
)

boxplot(
  i1_0$enpv0div_per_prob_spend,
  i1_1$enpv0div_per_prob_spend,
  i1_2$enpv0div_per_prob_spend,
  i1_3$enpv0div_per_prob_spend,
  i1_4$enpv0div_per_prob_spend,
  i1_5$enpv0div_per_prob_spend,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  outline = FALSE,
  main = "PC ENPV improvement (relative) per probabilistic spend"
)

boxplot(
  i1_0$enpv0div_per_prob_spend_risky,
  i1_1$enpv0div_per_prob_spend_risky,
  i1_2$enpv0div_per_prob_spend_risky,
  i1_3$enpv0div_per_prob_spend_risky,
  i1_4$enpv0div_per_prob_spend_risky,
  i1_5$enpv0div_per_prob_spend_risky,
  las = 1,
  names = c('PC',1,2,3,4,'M'),
  outline = FALSE,
  ylim = c(0,0.4),
  main = paste("PC ENPV improvement (relative) per prob spend, risk of gaming =", untruthfulness)
)


# ====== 

# PC ENPV improvement ~ spend
plot(i1_0$i1_enpv0diff ~ i1_0$i1_intervention_operand, main = "PC ENPV improvement with PC intervention")
plot(i1_1$i1_enpv0diff ~ i1_1$i1_intervention_operand, main = "PC ENPV improvement with P1 intervention")
plot(i1_2$i1_enpv0diff ~ i1_2$i1_intervention_operand, main = "PC ENPV improvement with P2 intervention")
plot(i1_3$i1_enpv0diff ~ i1_3$i1_intervention_operand, main = "PC ENPV improvement with P3 intervention")
plot(i1_4$i1_enpv0diff ~ i1_4$i1_intervention_operand, main = "PC ENPV improvement with P4 intervention")
plot(i1_5$i1_enpv0diff ~ i1_5$i1_intervention_operand, main = "PC ENPV improvement with M intervention")

# Absolute PC ENPV improvement ~ prob spend
ylim = c(0,max(i1_0$i1_enpv0diff))
xlim = c(0,max(i1_0$i1_prob_spend0))
plot(i1_0$i1_enpv0diff ~ i1_0$i1_prob_spend0, main = "PC ENPV improvement (absolute) by prob PC spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_0$i1_prob_spend0, i1_0$i1_enpv0diff), 3), ')'))
abline(lm(i1_0$i1_enpv0diff ~ i1_0$i1_prob_spend0), col='red')
plot(i1_1$i1_enpv0diff ~ i1_1$i1_prob_spend1, main = "P1 ENPV improvement (absolute) by prob P1 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_1$i1_prob_spend1, i1_1$i1_enpv0diff), 3), ')'))
abline(lm(i1_1$i1_enpv0diff ~ i1_1$i1_prob_spend1), col='red')
plot(i1_2$i1_enpv0diff ~ i1_2$i1_prob_spend2, main = "P2 ENPV improvement (absolute) by prob P2 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_2$i1_prob_spend2, i1_2$i1_enpv0diff), 3), ')'))
abline(lm(i1_2$i1_enpv0diff ~ i1_2$i1_prob_spend2), col='red')
plot(i1_3$i1_enpv0diff ~ i1_3$i1_prob_spend3, main = "P3 ENPV improvement (absolute) by prob P3 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_3$i1_prob_spend3, i1_3$i1_enpv0diff), 3), ')'))
abline(lm(i1_3$i1_enpv0diff ~ i1_3$i1_prob_spend3), col='red')
plot(i1_4$i1_enpv0diff ~ i1_4$i1_prob_spend4, main = "P4 ENPV improvement (absolute) by prob P4 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_4$i1_prob_spend4, i1_4$i1_enpv0diff), 3), ')'))
abline(lm(i1_4$i1_enpv0diff ~ i1_4$i1_prob_spend4), col='red')
plot(i1_5$i1_enpv0diff ~ i1_5$i1_prob_spend5, main = "M ENPV improvement (absolute) by prob M spend", ylim=ylim, xlim=xlim,  xlab=paste('Probabilistic spend, cor (', round(cor(i1_5$i1_prob_spend5, i1_5$i1_enpv0diff), 3), ')'))
abline(lm(i1_5$i1_enpv0diff ~ i1_5$i1_prob_spend5), col='red')

# Absolute PC ENPV improvement ~ spend
ylim = c(0,max(i1_0$i1_enpv0diff))
xlim = c(0,max(i1_0$i1_spend0))
plot(i1_0$i1_enpv0diff ~ i1_0$i1_spend0, main = "PC ENPV improvement (absolute) by prob PC spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_0$i1_spend0, i1_0$i1_enpv0diff), 3), ')'))
abline(lm(i1_0$i1_enpv0diff ~ i1_0$i1_spend0), col='red')
plot(i1_1$i1_enpv0diff ~ i1_1$i1_spend1, main = "P1 ENPV improvement (absolute) by prob P1 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_1$i1_spend1, i1_1$i1_enpv0diff), 3), ')'))
abline(lm(i1_1$i1_enpv0diff ~ i1_1$i1_spend1), col='red')
plot(i1_2$i1_enpv0diff ~ i1_2$i1_spend2, main = "P2 ENPV improvement (absolute) by prob P2 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_2$i1_spend2, i1_2$i1_enpv0diff), 3), ')'))
abline(lm(i1_2$i1_enpv0diff ~ i1_2$i1_spend2), col='red')
plot(i1_3$i1_enpv0diff ~ i1_3$i1_spend3, main = "P3 ENPV improvement (absolute) by prob P3 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_3$i1_spend3, i1_3$i1_enpv0diff), 3), ')'))
abline(lm(i1_3$i1_enpv0diff ~ i1_3$i1_spend3), col='red')
plot(i1_4$i1_enpv0diff ~ i1_4$i1_spend4, main = "P4 ENPV improvement (absolute) by prob P4 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_4$i1_spend4, i1_4$i1_enpv0diff), 3), ')'))
abline(lm(i1_4$i1_enpv0diff ~ i1_4$i1_spend4), col='red')
plot(i1_5$i1_enpv0diff ~ i1_5$i1_spend5, main = "M ENPV improvement (absolute) by prob M spend", ylim=ylim, xlim=xlim,  xlab=paste('Probabilistic spend, cor (', round(cor(i1_5$i1_spend5, i1_5$i1_enpv0diff), 3), ')'))
abline(lm(i1_5$i1_enpv0diff ~ i1_5$i1_spend5), col='red')


# Relative PC ENPV improvement ~ prob spend
ylim = c(0,max(i1_0$i1_enpv0div))
xlim = c(0,max(i1_0$i1_prob_spend0))
plot(i1_0$i1_enpv0div ~ i1_0$i1_prob_spend0, main = "PC ENPV improvement (relative) by prob PC spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_0$i1_prob_spend0, i1_0$i1_enpv0div), 3), ')'))
abline(lm(i1_0$i1_enpv0div ~ i1_0$i1_prob_spend0), col='red')
plot(i1_1$i1_enpv0div ~ i1_1$i1_prob_spend1, main = "P1 ENPV improvement (relative) by prob P1 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_1$i1_prob_spend1, i1_1$i1_enpv0div), 3), ')'))
abline(lm(i1_1$i1_enpv0div ~ i1_1$i1_prob_spend1), col='red')
plot(i1_2$i1_enpv0div ~ i1_2$i1_prob_spend2, main = "P2 ENPV improvement (relative) by prob P2 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_2$i1_prob_spend2, i1_2$i1_enpv0div), 3), ')'))
abline(lm(i1_2$i1_enpv0div ~ i1_2$i1_prob_spend2), col='red')
plot(i1_3$i1_enpv0div ~ i1_3$i1_prob_spend3, main = "P3 ENPV improvement (relative) by prob P3 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_3$i1_prob_spend3, i1_3$i1_enpv0div), 3), ')'))
abline(lm(i1_3$i1_enpv0div ~ i1_3$i1_prob_spend3), col='red')
plot(i1_4$i1_enpv0div ~ i1_4$i1_prob_spend4, main = "P4 ENPV improvement (relative) by prob P4 spend", ylim=ylim, xlim=xlim, xlab=paste('Probabilistic spend, cor (', round(cor(i1_4$i1_prob_spend4, i1_4$i1_enpv0div), 3), ')'))
abline(lm(i1_4$i1_enpv0div ~ i1_4$i1_prob_spend4), col='red')
plot(i1_5$i1_enpv0div ~ i1_5$i1_prob_spend5, main = "M ENPV improvement (relative) by prob M spend", ylim=ylim, xlim=xlim,  xlab=paste('Probabilistic spend, cor (', round(cor(i1_5$i1_prob_spend5, i1_5$i1_enpv0div), 3), ')'))
abline(lm(i1_5$i1_enpv0div ~ i1_5$i1_prob_spend5), col='red')

# Relative PC ENPV improvement ~ spend
ylim = c(0,max(i1_0$i1_enpv0div))
xlim = c(0,max(i1_0$i1_spend0))
plot(i1_0$i1_enpv0div ~ i1_0$i1_spend0, main = "PC ENPV improvement (relative) by prob PC spend", ylim=ylim, xlim=xlim, xlab=paste('Spend, cor (', round(cor(i1_0$i1_spend0, i1_0$i1_enpv0div), 3), ')'))
abline(lm(i1_0$i1_enpv0div ~ i1_0$i1_spend0), col='red')
plot(i1_1$i1_enpv0div ~ i1_1$i1_spend1, main = "P1 ENPV improvement (relative) by prob P1 spend", ylim=ylim, xlim=xlim, xlab=paste('Spend, cor (', round(cor(i1_1$i1_spend1, i1_1$i1_enpv0div), 3), ')'))
abline(lm(i1_1$i1_enpv0div ~ i1_1$i1_spend1), col='red')
plot(i1_2$i1_enpv0div ~ i1_2$i1_spend2, main = "P2 ENPV improvement (relative) by prob P2 spend", ylim=ylim, xlim=xlim, xlab=paste('Spend, cor (', round(cor(i1_2$i1_spend2, i1_2$i1_enpv0div), 3), ')'))
abline(lm(i1_2$i1_enpv0div ~ i1_2$i1_spend2), col='red')
plot(i1_3$i1_enpv0div ~ i1_3$i1_spend3, main = "P3 ENPV improvement (relative) by prob P3 spend", ylim=ylim, xlim=xlim, xlab=paste('Spend, cor (', round(cor(i1_3$i1_spend3, i1_3$i1_enpv0div), 3), ')'))
abline(lm(i1_3$i1_enpv0div ~ i1_3$i1_spend3), col='red')
plot(i1_4$i1_enpv0div ~ i1_4$i1_spend4, main = "P4 ENPV improvement (relative) by prob P4 spend", ylim=ylim, xlim=xlim, xlab=paste('Spend, cor (', round(cor(i1_4$i1_spend4, i1_4$i1_enpv0div), 3), ')'))
abline(lm(i1_4$i1_enpv0div ~ i1_4$i1_spend4), col='red')
plot(i1_5$i1_enpv0div ~ i1_5$i1_spend5, main = "M ENPV improvement (relative) by prob M spend", ylim=ylim, xlim=xlim,  xlab=paste('Spend, cor (', round(cor(i1_5$i1_spend5, i1_5$i1_enpv0div), 3), ')'))
abline(lm(i1_5$i1_enpv0div ~ i1_5$i1_spend5), col='red')

# correlation PC ENPV improvement ~ prob spend
print('cor')
cor(i1_0$i1_prob_spend0, i1_0$i1_enpv0diff)
cor(i1_1$i1_prob_spend1, i1_1$i1_enpv0diff)
cor(i1_2$i1_prob_spend2, i1_2$i1_enpv0diff)
cor(i1_3$i1_prob_spend3, i1_3$i1_enpv0diff)
cor(i1_4$i1_prob_spend4, i1_4$i1_enpv0diff)
cor(i1_5$i1_prob_spend5, i1_5$i1_enpv0diff)
print('cov')
cov(i1_0$i1_prob_spend0, i1_0$i1_enpv0diff)
cov(i1_1$i1_prob_spend1, i1_1$i1_enpv0diff)
cov(i1_2$i1_prob_spend2, i1_2$i1_enpv0diff)
cov(i1_3$i1_prob_spend3, i1_3$i1_enpv0diff)
cov(i1_4$i1_prob_spend4, i1_4$i1_enpv0diff)
cov(i1_5$i1_prob_spend5, i1_5$i1_enpv0diff)

