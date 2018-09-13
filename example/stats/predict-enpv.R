df <- read.csv("./output/example.csv")

df$cost     <- df$cost0 + df$cost1 + df$cost2 + df$cost3 + df$cost4 + df$cost5
df$prob     <- df$prob0 * df$prob1 * df$prob2 * df$prob3 * df$prob4 * df$prob5
df$time     <- df$time0 + df$time1 + df$time2 + df$time3 + df$time4 + df$time5
df$revenue  <- df$revenue0 + df$revenue1 + df$revenue2 + df$revenue3 + df$revenue4 + df$revenue5 + df$market_size
df$cashflow <- df$revenue - df$cost
df$probcash <- (1-df$prob) * df$cashflow

plot(df$cost, df$enpv0, xlab="Total cost", ylab='PC ENPV')
abline(lm(df$enpv0 ~ df$cost), col='red')
lines(lowess(df$enpv0 ~ df$cost), col='blue')
mtext(side=1, line=4, text=paste('(red = linear model, blue = lowess)  (corr = ', cor(df$cost, df$enpv0), ')',sep=''))
cor.test(df$cost, df$enpv0)

plot(df$revenue, df$enpv0, xlim=c(-200,1500), ylim=c(-50,25), xlab="Total revenues", ylab='PC ENPV')
abline(lm(df$enpv0 ~ df$revenue), col='red')
lines(lowess(df$enpv0 ~ df$revenue), col='blue')
mtext(side=1, line=4, text=paste('(red = linear model, blue = lowess)  (corr = ', cor(df$revenue, df$enpv0), ')',sep=''))
cor.test(df$revenue, df$enpv0)

plot(df$cashflow, df$enpv0, xlim=c(-200,1500), ylim=c(-50,25), xlab="Total cashflow (revenues - costs)", ylab='PC ENPV')
abline(lm(df$enpv0 ~ df$cashflow), col='red')
lines(lowess(df$enpv0 ~ df$cashflow), col='blue')
mtext(side=1, line=4, text=paste('(red = linear model, blue = lowess)  (corr = ', cor(df$cashflow, df$enpv0), ')',sep=''))
cor.test(df$cashflow, df$enpv0)

plot(df$prob, df$enpv0, xlab="Total probability of success", ylab='PC ENPV')
abline(lm(df$enpv0 ~ df$prob), col='red')
lines(lowess(df$enpv0 ~ df$prob), col='blue')
mtext(side=1, line=4, text=paste('(red = linear model, blue = lowess)  (corr = ', cor(df$prob, df$enpv0), ')',sep=''))
cor.test(df$prob, df$enpv0)

plot(df$time, df$enpv0, xlab="Total time of development", ylab='PC ENPV')
abline(lm(df$enpv0 ~ df$time), col='red')
lines(lowess(df$enpv0 ~ df$time), col='blue')
mtext(side=1, line=4, text=paste('(red = linear model, blue = lowess)  (corr = ', cor(df$time, df$enpv0), ')',sep=''))
cor.test(df$time, df$enpv0)

plot(df$probcash, df$enpv0, xlab="Total prob*cashflow", ylab='PC ENPV')
abline(lm(df$enpv0 ~ df$probcash), col='red')
lines(lowess(df$enpv0 ~ df$probcash), col='blue')
mtext(side=1, line=4, text=paste('(red = linear model, blue = lowess)  (corr = ', cor(df$probcash, df$enpv0), ')',sep=''))
cor.test(df$probcash, df$enpv0)
