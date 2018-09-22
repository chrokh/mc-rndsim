df <- read.csv("./output/example.csv")

# Select only cases without intervention
tmp <- subset(df, df$group == 'base')

# Select only first N rows in since we don't want too much data for this analysis
N = min(nrow(tmp), 10000)
tmp <- tmp[1:N,]

# Compute totals
tmp$cost     <- tmp$cost0 + tmp$cost1 + tmp$cost2 + tmp$cost3 + tmp$cost4 + tmp$cost5 + tmp$cost6 + tmp$cost7 + tmp$cost8 + tmp$cost9 + tmp$cost10 + tmp$cost11 + tmp$cost12 + tmp$cost13 + tmp$cost14 + tmp$cost15
tmp$prob     <- tmp$prob0 * tmp$prob1 * tmp$prob2 * tmp$prob3 * tmp$prob4 * tmp$prob5 * tmp$prob6 * tmp$prob7 * tmp$prob8 * tmp$prob9 * tmp$prob10 * tmp$prob11 * tmp$prob12 * tmp$prob13 * tmp$prob14 * tmp$prob15
tmp$time     <- tmp$time0 + tmp$time1 + tmp$time2 + tmp$time3 + tmp$time4 + tmp$time5 + tmp$time6 + tmp$time7 + tmp$time8 + tmp$time9 + tmp$time10 + tmp$time11 + tmp$time12 + tmp$time13 + tmp$time14 + tmp$time15
tmp$revenue  <- tmp$revenue0 + tmp$revenue1 + tmp$revenue2 + tmp$revenue3 + tmp$revenue4 + tmp$revenue5 + tmp$revenue6 + tmp$revenue7 + tmp$revenue8 + tmp$revenue9 + tmp$revenue10 + tmp$revenue11 + tmp$revenue12 + tmp$revenue13 + tmp$revenue14 + tmp$revenue15
tmp$revenue  <- tmp$revenue0 + tmp$revenue1 + tmp$revenue2 + tmp$revenue3 + tmp$revenue4 + tmp$revenue5 + tmp$revenue6 + tmp$revenue7 + tmp$revenue8 + tmp$revenue9 + tmp$revenue10 + tmp$revenue11 + tmp$revenue12 + tmp$revenue13 + tmp$revenue14 + tmp$revenue15
tmp$cashflow <- tmp$revenue - tmp$cost
tmp$probcash <- (tmp$prob) * tmp$cashflow

# Compute cashflows
tmp$cashflow0  <- tmp$revenue0 - tmp$cost0
tmp$cashflow1  <- tmp$revenue1 - tmp$cost1
tmp$cashflow2  <- tmp$revenue2 - tmp$cost2
tmp$cashflow3  <- tmp$revenue3 - tmp$cost3
tmp$cashflow4  <- tmp$revenue4 - tmp$cost4
tmp$cashflow5  <- tmp$revenue5 - tmp$cost5
tmp$cashflow6  <- tmp$revenue6 - tmp$cost6
tmp$cashflow7  <- tmp$revenue7 - tmp$cost7
tmp$cashflow8  <- tmp$revenue8 - tmp$cost8
tmp$cashflow9  <- tmp$revenue9 - tmp$cost9
tmp$cashflow10 <- tmp$revenue10 - tmp$cost10
tmp$cashflow11 <- tmp$revenue11 - tmp$cost11
tmp$cashflow12 <- tmp$revenue12 - tmp$cost12
tmp$cashflow13 <- tmp$revenue13 - tmp$cost13
tmp$cashflow14 <- tmp$revenue14 - tmp$cost14
tmp$cashflow15 <- tmp$revenue15 - tmp$cost15

# Compute cumulative step-by-step probabilities
tmp$cumprob0  <- 1
tmp$cumprob1  <- tmp$cumprob0 * tmp$prob0
tmp$cumprob2  <- tmp$cumprob1 * tmp$prob1
tmp$cumprob3  <- tmp$cumprob2 * tmp$prob2
tmp$cumprob4  <- tmp$cumprob3 * tmp$prob3
tmp$cumprob5  <- tmp$cumprob4 * tmp$prob4
tmp$cumprob6  <- tmp$cumprob5 * tmp$prob5
tmp$cumprob7  <- tmp$cumprob6 * tmp$prob6
tmp$cumprob8  <- tmp$cumprob7 * tmp$prob7
tmp$cumprob9  <- tmp$cumprob8 * tmp$prob8
tmp$cumprob10 <- tmp$cumprob9 * tmp$prob9
tmp$cumprob11 <- tmp$cumprob10 * tmp$prob10
tmp$cumprob12 <- tmp$cumprob11 * tmp$prob11
tmp$cumprob13 <- tmp$cumprob12 * tmp$prob12
tmp$cumprob14 <- tmp$cumprob13 * tmp$prob13
tmp$cumprob15 <- tmp$cumprob14 * tmp$prob14

# Compute expected cashflow
tmp$excash   <- (
  tmp$cashflow0 * tmp$cumprob0 +
    tmp$cashflow1  * tmp$cumprob1 +
    tmp$cashflow2  * tmp$cumprob2 +
    tmp$cashflow3  * tmp$cumprob3 +
    tmp$cashflow4  * tmp$cumprob4 +
    tmp$cashflow5  * tmp$cumprob5 +
    tmp$cashflow6  * tmp$cumprob6 +
    tmp$cashflow7  * tmp$cumprob7 +
    tmp$cashflow8  * tmp$cumprob8 +
    tmp$cashflow9  * tmp$cumprob9 +
    tmp$cashflow10 * tmp$cumprob10 +
    tmp$cashflow11 * tmp$cumprob11 +
    tmp$cashflow12 * tmp$cumprob12 +
    tmp$cashflow13 * tmp$cumprob13 +
    tmp$cashflow14 * tmp$cumprob14 +
    tmp$cashflow15 * tmp$cumprob15
)


# Compute expected revenue
tmp$exrevenue   <- (
  tmp$revenue0 * tmp$cumprob0 +
    tmp$revenue1  * tmp$cumprob1 +
    tmp$revenue2  * tmp$cumprob2 +
    tmp$revenue3  * tmp$cumprob3 +
    tmp$revenue4  * tmp$cumprob4 +
    tmp$revenue5  * tmp$cumprob5 +
    tmp$revenue6  * tmp$cumprob6 +
    tmp$revenue7  * tmp$cumprob7 +
    tmp$revenue8  * tmp$cumprob8 +
    tmp$revenue9  * tmp$cumprob9 +
    tmp$revenue10 * tmp$cumprob10 +
    tmp$revenue11 * tmp$cumprob11 +
    tmp$revenue12 * tmp$cumprob12 +
    tmp$revenue13 * tmp$cumprob13 +
    tmp$revenue14 * tmp$cumprob14 +
    tmp$revenue15 * tmp$cumprob15
)


plot(tmp$cost, tmp$enpv0, xlab="Total cost", ylab='PC ENPV')
abline(lm(tmp$enpv0 ~ tmp$cost), col='red')
lines(lowess(tmp$enpv0 ~ tmp$cost), col='blue')
c = cor.test(tmp$cost, tmp$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(tmp$cost, tmp$enpv0)

plot(tmp$revenue, tmp$enpv0, xlim=c(-200,1500), ylim=c(-50,25), xlab="Total revenues", ylab='PC ENPV')
abline(lm(tmp$enpv0 ~ tmp$revenue), col='red')
lines(lowess(tmp$enpv0 ~ tmp$revenue), col='blue')
c = cor.test(tmp$revenue, tmp$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(tmp$revenue, tmp$enpv0)

plot(tmp$cashflow, tmp$enpv0, xlim=c(-200,1500), ylim=c(-50,25), xlab="Total cashflow (revenues - costs)", ylab='PC ENPV')
abline(lm(tmp$enpv0 ~ tmp$cashflow), col='red')
lines(lowess(tmp$enpv0 ~ tmp$cashflow), col='blue')
c = cor.test(tmp$cashflow, tmp$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(tmp$cashflow, tmp$enpv0)

plot(tmp$prob, tmp$enpv0, xlab="Total probability of success", ylab='PC ENPV')
abline(lm(tmp$enpv0 ~ tmp$prob), col='red')
lines(lowess(tmp$enpv0 ~ tmp$prob), col='blue')
c = cor.test(tmp$prob, tmp$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(tmp$prob, tmp$enpv0)

plot(tmp$time, tmp$enpv0, xlab="Total time of development", ylab='PC ENPV')
abline(lm(tmp$enpv0 ~ tmp$time), col='red')
lines(lowess(tmp$enpv0 ~ tmp$time), col='blue')
c = cor.test(tmp$time, tmp$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(tmp$time, tmp$enpv0)

plot(tmp$probcash, tmp$enpv0, xlab="Probability of reaching final market year multiplied with total cashflow", ylab='PC ENPV')
abline(lm(tmp$enpv0 ~ tmp$probcash), col='red')
lines(lowess(tmp$enpv0 ~ tmp$probcash), col='blue')
c = cor.test(tmp$probcash, tmp$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(tmp$probcash, tmp$enpv0)

plot(tmp$excash, tmp$enpv0, xlab="", ylab='PC ENPV')
abline(lm(tmp$enpv0 ~ tmp$excash), col='red')
lines(lowess(tmp$enpv0 ~ tmp$excash), col='blue')
mtext(side=1, line=2, text='Expected cashflow')
mtext(side=1, line=3, text='(i.e. sum of every cashflow corrected by the probability that it occurs)')
c = cor.test(tmp$excash, tmp$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(tmp$excash, tmp$enpv0)


plot(tmp$exrevenue, tmp$enpv0, xlab="", ylab='PC ENPV')
abline(lm(tmp$enpv0 ~ tmp$exrevenue), col='red')
lines(lowess(tmp$enpv0 ~ tmp$exrevenue), col='blue')
mtext(side=1, line=2, text='Expected revenue')
mtext(side=1, line=3, text='(i.e. sum of every revenue corrected by the probability that it occurs)')
c = cor.test(tmp$exrevenue, tmp$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(tmp$exrevenue, tmp$enpv0)
