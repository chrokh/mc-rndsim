df <- read.csv("./output/example.csv")

# Compute ENPV diff
df$i1_enpv0diff <- df$i1_enpv0 - df$enpv0

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

# Create intervention specific subsets
dfi0 <- subset(df, df$i1_intervention_phase == 0)
dfi1 <- subset(df, df$i1_intervention_phase == 1)
dfi2 <- subset(df, df$i1_intervention_phase == 2)
dfi3 <- subset(df, df$i1_intervention_phase == 3)
dfi4 <- subset(df, df$i1_intervention_phase == 4)
dfi5 <- subset(df, df$i1_intervention_phase == 5)


# Correlation between promised and expected payout.

plot(df$i1_spend0, df$i1_prob_spend0, xlab='Promised PC payout', ylab='Expected PC payout')
abline(lm(df$i1_prob_spend0 ~ df$i1_spend0), col='red')
mtext(side=1, line=4, text=paste('cor ~', round(cor(df$i1_spend0, df$i1_prob_spend0), 2)))

plot(df$i1_spend1, df$i1_prob_spend1, xlab='Promised P1 payout', ylab='Expected P1 payout')
abline(lm(df$i1_prob_spend1 ~ df$i1_spend1), col='red')
mtext(side=1, line=4, text=paste('cor ~', round(cor(df$i1_spend1, df$i1_prob_spend1), 2)))

plot(df$i1_spend2, df$i1_prob_spend2, xlab='Promised P2 payout', ylab='Expected P2 payout')
abline(lm(df$i1_prob_spend2 ~ df$i1_spend2), col='red')
mtext(side=1, line=4, text=paste('cor ~', round(cor(df$i1_spend2, df$i1_prob_spend2), 2)))

plot(df$i1_spend3, df$i1_prob_spend3, xlab='Promised P3 payout', ylab='Expected P3 payout')
abline(lm(df$i1_prob_spend3 ~ df$i1_spend3), col='red')
mtext(side=1, line=4, text=paste('cor ~', round(cor(df$i1_spend3, df$i1_prob_spend3), 2)))

plot(df$i1_spend4, df$i1_prob_spend4, xlab='Promised P4 payout', ylab='Expected P4 payout')
abline(lm(df$i1_prob_spend4 ~ df$i1_spend4), col='red')
mtext(side=1, line=4, text=paste('cor ~', round(cor(df$i1_spend4, df$i1_prob_spend4), 2)))

plot(df$i1_spend5, df$i1_prob_spend5, xlab='Promised market payout', ylab='Expected market payout')
abline(lm(df$i1_prob_spend5 ~ df$i1_spend5), col='red')
mtext(side=1, line=4, text=paste('cor ~', round(cor(df$i1_spend5, df$i1_prob_spend5), 2)))


# Correlation between promised and expected payout.

plot(df$i1_spend1, df$i1_prob_spend1, xlab='Promised payout', ylab='Expected payout', ylim=c(0,max(df$i1_prob_spend1)), col='antiquewhite2')
abline(lm(df$i1_prob_spend1 ~ df$i1_spend1), col='antiquewhite2')
points(df$i1_spend2, df$i1_prob_spend2, col='brown')
abline(lm(df$i1_prob_spend2 ~ df$i1_spend2), col='brown')
points(df$i1_spend3, df$i1_prob_spend3, col='aquamarine2')
abline(lm(df$i1_prob_spend3 ~ df$i1_spend3), col='aquamarine2')
points(df$i1_spend4, df$i1_prob_spend4, col='deeppink')
abline(lm(df$i1_prob_spend4 ~ df$i1_spend4), col='deeppink')
points(df$i1_spend5, df$i1_prob_spend5, col='black')
abline(lm(df$i1_prob_spend5 ~ df$i1_spend5), col='black')


# Correlation between promised payout and PC ENPV

plot(dfi0$i1_spend0, dfi0$i1_enpv0)
abline(lm(dfi0$i1_enpv0 ~ dfi0$i1_spend0), col='red')
plot(dfi1$i1_spend1, dfi1$i1_enpv0)
abline(lm(dfi1$i1_enpv0 ~ dfi1$i1_spend1), col='red')
plot(dfi2$i1_spend2, dfi2$i1_enpv0)
abline(lm(dfi2$i1_enpv0 ~ dfi2$i1_spend2), col='red')
plot(dfi3$i1_spend3, dfi3$i1_enpv0)
abline(lm(dfi3$i1_enpv0 ~ dfi3$i1_spend3), col='red')
plot(dfi4$i1_spend4, dfi4$i1_enpv0)
abline(lm(dfi4$i1_enpv0 ~ dfi4$i1_spend4), col='red')
plot(dfi5$i1_spend5, dfi5$i1_enpv0)
abline(lm(dfi5$i1_enpv0 ~ dfi5$i1_spend5), col='red')


# Correlation between promised payout and PC ENPV

plot(dfi1$i1_spend1, dfi1$i1_enpv0, xlab='Payout (P1-M)', ylab='PC ENPV')
points(dfi2$i1_spend2, dfi2$i1_enpv0, col='red')
points(dfi3$i1_spend3, dfi3$i1_enpv0, col='blue')
points(dfi4$i1_spend4, dfi4$i1_enpv0, col='yellow')
points(dfi5$i1_spend5, dfi5$i1_enpv0, col='green')


# Correlation between promised payout and PC ENPV improvement

plot(dfi1$i1_spend1, dfi1$i1_enpv0diff, xlab='Payout (P1-M)', ylab='PC ENPV difference')
points(dfi2$i1_spend2, dfi2$i1_enpv0diff, col='red')
points(dfi3$i1_spend3, dfi3$i1_enpv0diff, col='blue')
points(dfi4$i1_spend4, dfi4$i1_enpv0diff, col='yellow')
points(dfi5$i1_spend5, dfi5$i1_enpv0diff, col='green')

