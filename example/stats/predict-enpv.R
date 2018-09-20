df <- read.csv("./output/example.csv")

# Select only first N rows in since we don't want too much data for this analysis
N = min(nrow(df), 10000)
sdf <- df[1:N,]

# Compute totals
sdf$cost     <- sdf$cost0 + sdf$cost1 + sdf$cost2 + sdf$cost3 + sdf$cost4 + sdf$cost5 + sdf$cost6 + sdf$cost7 + sdf$cost8 + sdf$cost9 + sdf$cost10 + sdf$cost11 + sdf$cost12 + sdf$cost13 + sdf$cost14 + sdf$cost15
sdf$prob     <- sdf$prob0 * sdf$prob1 * sdf$prob2 * sdf$prob3 * sdf$prob4 * sdf$prob5 * sdf$prob6 * sdf$prob7 * sdf$prob8 * sdf$prob9 * sdf$prob10 * sdf$prob11 * sdf$prob12 * sdf$prob13 * sdf$prob14 * sdf$prob15
sdf$time     <- sdf$time0 + sdf$time1 + sdf$time2 + sdf$time3 + sdf$time4 + sdf$time5 + sdf$time6 + sdf$time7 + sdf$time8 + sdf$time9 + sdf$time10 + sdf$time11 + sdf$time12 + sdf$time13 + sdf$time14 + sdf$time15
sdf$revenue  <- sdf$revenue0 + sdf$revenue1 + sdf$revenue2 + sdf$revenue3 + sdf$revenue4 + sdf$revenue5 + sdf$revenue6 + sdf$revenue7 + sdf$revenue8 + sdf$revenue9 + sdf$revenue10 + sdf$revenue11 + sdf$revenue12 + sdf$revenue13 + sdf$revenue14 + sdf$revenue15
sdf$revenue  <- sdf$revenue0 + sdf$revenue1 + sdf$revenue2 + sdf$revenue3 + sdf$revenue4 + sdf$revenue5 + sdf$revenue6 + sdf$revenue7 + sdf$revenue8 + sdf$revenue9 + sdf$revenue10 + sdf$revenue11 + sdf$revenue12 + sdf$revenue13 + sdf$revenue14 + sdf$revenue15
sdf$cashflow <- sdf$revenue - sdf$cost
sdf$probcash <- (sdf$prob) * sdf$cashflow

# Compute cashflows
sdf$cashflow0  <- sdf$revenue0 - sdf$cost0
sdf$cashflow1  <- sdf$revenue1 - sdf$cost1
sdf$cashflow2  <- sdf$revenue2 - sdf$cost2
sdf$cashflow3  <- sdf$revenue3 - sdf$cost3
sdf$cashflow4  <- sdf$revenue4 - sdf$cost4
sdf$cashflow5  <- sdf$revenue5 - sdf$cost5
sdf$cashflow6  <- sdf$revenue6 - sdf$cost6
sdf$cashflow7  <- sdf$revenue7 - sdf$cost7
sdf$cashflow8  <- sdf$revenue8 - sdf$cost8
sdf$cashflow9  <- sdf$revenue9 - sdf$cost9
sdf$cashflow10 <- sdf$revenue10 - sdf$cost10
sdf$cashflow11 <- sdf$revenue11 - sdf$cost11
sdf$cashflow12 <- sdf$revenue12 - sdf$cost12
sdf$cashflow13 <- sdf$revenue13 - sdf$cost13
sdf$cashflow14 <- sdf$revenue14 - sdf$cost14
sdf$cashflow15 <- sdf$revenue15 - sdf$cost15

# Compute cumulative step-by-step probabilities
sdf$cumprob0  <- 1
sdf$cumprob1  <- sdf$cumprob0 * sdf$prob0
sdf$cumprob2  <- sdf$cumprob1 * sdf$prob1
sdf$cumprob3  <- sdf$cumprob2 * sdf$prob2
sdf$cumprob4  <- sdf$cumprob3 * sdf$prob3
sdf$cumprob5  <- sdf$cumprob4 * sdf$prob4
sdf$cumprob6  <- sdf$cumprob5 * sdf$prob5
sdf$cumprob7  <- sdf$cumprob6 * sdf$prob6
sdf$cumprob8  <- sdf$cumprob7 * sdf$prob7
sdf$cumprob9  <- sdf$cumprob8 * sdf$prob8
sdf$cumprob10 <- sdf$cumprob9 * sdf$prob9
sdf$cumprob11 <- sdf$cumprob10 * sdf$prob10
sdf$cumprob12 <- sdf$cumprob11 * sdf$prob11
sdf$cumprob13 <- sdf$cumprob12 * sdf$prob12
sdf$cumprob14 <- sdf$cumprob13 * sdf$prob13
sdf$cumprob15 <- sdf$cumprob14 * sdf$prob14

# Compute expected cashflow
sdf$excash   <- (
  sdf$cashflow0 * sdf$cumprob0 +
    sdf$cashflow1  * sdf$cumprob1 +
    sdf$cashflow2  * sdf$cumprob2 +
    sdf$cashflow3  * sdf$cumprob3 +
    sdf$cashflow4  * sdf$cumprob4 +
    sdf$cashflow5  * sdf$cumprob5 +
    sdf$cashflow6  * sdf$cumprob6 +
    sdf$cashflow7  * sdf$cumprob7 +
    sdf$cashflow8  * sdf$cumprob8 +
    sdf$cashflow9  * sdf$cumprob9 +
    sdf$cashflow10 * sdf$cumprob10 +
    sdf$cashflow11 * sdf$cumprob11 +
    sdf$cashflow12 * sdf$cumprob12 +
    sdf$cashflow13 * sdf$cumprob13 +
    sdf$cashflow14 * sdf$cumprob14 +
    sdf$cashflow15 * sdf$cumprob15
)


# Compute expected revenue
sdf$exrevenue   <- (
  sdf$revenue0 * sdf$cumprob0 +
    sdf$revenue1  * sdf$cumprob1 +
    sdf$revenue2  * sdf$cumprob2 +
    sdf$revenue3  * sdf$cumprob3 +
    sdf$revenue4  * sdf$cumprob4 +
    sdf$revenue5  * sdf$cumprob5 +
    sdf$revenue6  * sdf$cumprob6 +
    sdf$revenue7  * sdf$cumprob7 +
    sdf$revenue8  * sdf$cumprob8 +
    sdf$revenue9  * sdf$cumprob9 +
    sdf$revenue10 * sdf$cumprob10 +
    sdf$revenue11 * sdf$cumprob11 +
    sdf$revenue12 * sdf$cumprob12 +
    sdf$revenue13 * sdf$cumprob13 +
    sdf$revenue14 * sdf$cumprob14 +
    sdf$revenue15 * sdf$cumprob15
)


plot(sdf$cost, sdf$enpv0, xlab="Total cost", ylab='PC ENPV')
abline(lm(sdf$enpv0 ~ sdf$cost), col='red')
lines(lowess(sdf$enpv0 ~ sdf$cost), col='blue')
c = cor.test(sdf$cost, sdf$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(sdf$cost, sdf$enpv0)

plot(sdf$revenue, sdf$enpv0, xlim=c(-200,1500), ylim=c(-50,25), xlab="Total revenues", ylab='PC ENPV')
abline(lm(sdf$enpv0 ~ sdf$revenue), col='red')
lines(lowess(sdf$enpv0 ~ sdf$revenue), col='blue')
c = cor.test(sdf$revenue, sdf$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(sdf$revenue, sdf$enpv0)

plot(sdf$cashflow, sdf$enpv0, xlim=c(-200,1500), ylim=c(-50,25), xlab="Total cashflow (revenues - costs)", ylab='PC ENPV')
abline(lm(sdf$enpv0 ~ sdf$cashflow), col='red')
lines(lowess(sdf$enpv0 ~ sdf$cashflow), col='blue')
c = cor.test(sdf$cashflow, sdf$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(sdf$cashflow, sdf$enpv0)

plot(sdf$prob, sdf$enpv0, xlab="Total probability of success", ylab='PC ENPV')
abline(lm(sdf$enpv0 ~ sdf$prob), col='red')
lines(lowess(sdf$enpv0 ~ sdf$prob), col='blue')
c = cor.test(sdf$prob, sdf$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(sdf$prob, sdf$enpv0)

plot(sdf$time, sdf$enpv0, xlab="Total time of development", ylab='PC ENPV')
abline(lm(sdf$enpv0 ~ sdf$time), col='red')
lines(lowess(sdf$enpv0 ~ sdf$time), col='blue')
c = cor.test(sdf$time, sdf$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(sdf$time, sdf$enpv0)

plot(sdf$probcash, sdf$enpv0, xlab="Probability of reaching final market year multiplied with total cashflow", ylab='PC ENPV')
abline(lm(sdf$enpv0 ~ sdf$probcash), col='red')
lines(lowess(sdf$enpv0 ~ sdf$probcash), col='blue')
c = cor.test(sdf$probcash, sdf$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(sdf$probcash, sdf$enpv0)

plot(sdf$excash, sdf$enpv0, xlab="", ylab='PC ENPV')
abline(lm(sdf$enpv0 ~ sdf$excash), col='red')
lines(lowess(sdf$enpv0 ~ sdf$excash), col='blue')
mtext(side=1, line=2, text='Expected cashflow')
mtext(side=1, line=3, text='(i.e. sum of every cashflow corrected by the probability that it occurs)')
c = cor.test(sdf$excash, sdf$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(sdf$excash, sdf$enpv0)


plot(sdf$exrevenue, sdf$enpv0, xlab="", ylab='PC ENPV')
abline(lm(sdf$enpv0 ~ sdf$exrevenue), col='red')
lines(lowess(sdf$enpv0 ~ sdf$exrevenue), col='blue')
mtext(side=1, line=2, text='Expected revenue')
mtext(side=1, line=3, text='(i.e. sum of every revenue corrected by the probability that it occurs)')
c = cor.test(sdf$exrevenue, sdf$enpv0)
p = ifelse(c$p.value < 0.001, "p < 0.001", sprintf('p = %s', round(c$p.value, 3)))
mtext(side=1, line=4, text=sprintf('(red = linear,  blue = lowess)   (cor = %s,  t = %s,  %s)', round(c$estimate,2), round(c$statistic,2), p))
mtext(side=3, line=0.5, text=sprintf('N = %s',N))
cor.test(sdf$exrevenue, sdf$enpv0)
